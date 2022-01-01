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

local chosenTag = Tag.."Chosen"

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = p:GetData().lootdeck
	data[Tag] = 1

	if shouldDouble then
		data[Tag] = data[Tag] + 1
	end

	local enemies = helper.ListEnemiesInRoom(p.Position)
	for _, enemy in ipairs(enemies) do
		enemy:GetData()[Tag] = 1
	end

	return #enemies > 0
end

local function MC_POST_NEW_ROOM()
    helper.ClearStaggerSpawn(Tag)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
	local rng = p:GetCardRNG(Id)
    local numberOfEnemies = #helper.ListEnemiesInRoom(p.Position, true, function(_, eData) return eData[Tag] end) + 1
    helper.StaggerSpawn(Tag, p, 7, numberOfEnemies, function(player, counterName)
		local data = player:GetData().lootdeck
		if data[counterName] > numberOfEnemies then
			data[counterName] = numberOfEnemies
		end
		local target

		if data[counterName] == 1 then
			target = player
		else
			local enemy = helper.FindRandomEnemy(player.Position, rng, Tag, function(_, eData) return eData[Tag] and not eData[chosenTag] end)
			if enemy then
				target = enemy
				enemy:GetData()[Tag] = nil
			else
				target = player
			end
		end
		Isaac.Explode(target.Position, nil, 40)
		data[counterName] = data[counterName] - 1
	end,
	function(player)
		helper.ClearChosens(player.Position)
	end,
	1)
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
