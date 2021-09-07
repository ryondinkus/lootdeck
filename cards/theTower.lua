local helper = include('helper_functions')

-- Explodes each enemy in the room and then the player
local Name = "XIV. The Tower"
local Tag = "theTower"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
	data[Tag] = 1
	for _, enemy in ipairs(helper.ListEnemiesInRoom(p.Position, true)) do
		enemy:GetData()[Tag] = 1
	end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local numberOfEnemies = #helper.ListEnemiesInRoom(p.Position, true, Tag) + 1
    helper.StaggerSpawn(Tag, p, 7, numberOfEnemies, function(player, counterName)
		local data = player:GetData()
		if data[counterName] > numberOfEnemies then
			data[counterName] = numberOfEnemies
		end
		local target

		if data[counterName] == 1 then
			target = player
		else
			local enemy = helper.FindRandomEnemy(player.Position, true, false, Tag)
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
    Tag = Tag,
	Id = Id,
    callbacks = {
            {
                ModCallbacks.MC_USE_CARD,
                MC_USE_CARD,
                Id
            },
            {
                ModCallbacks.MC_POST_PEFFECT_UPDATE,
                MC_POST_PEFFECT_UPDATE
            }
    }
}