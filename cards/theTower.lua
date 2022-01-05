local helper = LootDeckHelpers

-- Explodes each enemy in the room and then the player
local Names = {
    en_us = "XIV. The Tower",
    spa = "XIV. La Torre"
}
local Name = Names.en_us
local Tag = "theTower"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "{{Warning}} On use, explodes on every enemy in the room, then the player",
	spa = "{{Warning}} Al usarla, todos los enemigos en la habitación explotarán luego explotará el jugador"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns an explosion on every enemy in the room, dealing 40 damage to any enemy in the explosion.", "After exploding on all enemies, it will explode on the player.", "Holographic Effect: Spawns explosions two at a time.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = p:GetData().lootdeck
	data[Tag] = 1

	if shouldDouble then
		data[Tag] = data[Tag] + 1
	end

	local enemies = helper.ListEnemiesInRoom()
	for _, enemy in ipairs(enemies) do
		enemy:GetData()[Tag] = 1
	end

	return #enemies > 0
end

local function MC_POST_NEW_ROOM()
    LootDeckHelpers.ForEachPlayer(function(player)
        helper.StopStaggerSpawn(player, Tag)
    end)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
	local rng = p:GetCardRNG(Id)
    local numberOfEnemies = #helper.ListEnemiesInRoom(true, function(_, eData) return eData[Tag] end) + 1
    helper.StaggerSpawn(Tag, p, 7, numberOfEnemies, function(counterTag, previousResult)

		if not previousResult then
			previousResult = 1
		end

		local data = p:GetData().lootdeck
		if data[counterTag] > numberOfEnemies then
			data[counterTag] = numberOfEnemies
		end
		local target

		print(data[counterTag])

		if data[counterTag] == 1 then
			target = p
		else
			local enemy = helper.GetRandomEnemy(rng, nil, function(_, eData) return eData[Tag] end)
			if enemy then
				target = enemy
				enemy:GetData()[Tag] = nil
			else
				target = p
			end
		end
		
		if target ~= p or previousResult < data[Tag] then
			Isaac.Explode(target.Position, nil, 40)
			data[counterTag] = data[counterTag] - 1
		end

		return previousResult + 1
	end,
	function()
		local enemies = helper.ListEnemiesInRoom()
		for _, enemy in ipairs(enemies) do
			enemy:GetData()[Tag] = true
		end
	end,
	true)
end

return {
    Name = Name,
	Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
            {
                ModCallbacks.MC_USE_CARD,
                MC_USE_CARD,
                Id
            },
			{
				ModCallbacks.MC_POST_NEW_ROOM,
				MC_POST_NEW_ROOM
			},
            {
                ModCallbacks.MC_POST_PEFFECT_UPDATE,
                MC_POST_PEFFECT_UPDATE
            }
    }
}
