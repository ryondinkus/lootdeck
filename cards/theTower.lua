local helper = include('helper_functions')

-- Explodes each enemy in the room and then the player
local Name = "XIV. The Tower"
local Tag = "theTower"
local Id = Isaac.GetCardIdByName(Name)

local EnemiesTag = string.format("%sEnemies", Tag)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
	data[Tag] = 1
	data[EnemiesTag] = helper.ListEnemiesInRoom(p.Position, true)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
	local d = p:GetData()
	if d[Tag] and d[EnemiesTag] then
		local numberOfEnemies = #d[EnemiesTag] + 1
		helper.StaggerSpawn(Tag, p, 7, numberOfEnemies, function(player, counterName)
			local data = player:GetData()

			local availableEnemies = {}

			for _, enemy in ipairs(data[EnemiesTag]) do
				if enemy:IsVulnerableEnemy() then
					availableEnemies[#availableEnemies+1] = enemy
				end
			end

			if data[counterName] > #availableEnemies + 1 then
				data[counterName] = #availableEnemies + 1
			end

			local target

			if data[counterName] == 1 then
				target = player
			else
				local chosenEnemyIndex = lootdeck.rng:RandomInt(#availableEnemies + 1) + 1
				target = availableEnemies[chosenEnemyIndex]
				table.remove(availableEnemies, chosenEnemyIndex)
			end

			if target then
				Isaac.Explode(target.Position, nil, 40)
				data[counterName] = data[counterName] - 1
				data[EnemiesTag] = availableEnemies
			else
				data[EnemiesTag] = nil
			end
		end,
		function(player)
			helper.ClearChosens(player.Position)
		end,
		1)
	end
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