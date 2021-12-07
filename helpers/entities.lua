local H = {}

-- helper function for using FindRandomEnemy with noDupes, resets chosen enemy counter in case of multiple uses of tower card, for example
function lootdeckHelpers.ClearChosens(pos)
    local entities = Isaac.FindInRadius(pos, 1875, EntityPartition.ENEMY)
    for i, entity in pairs(entities) do
        local data = entity:GetData()
        if data.chosen then
            data.chosen = nil
        end
    end
end

function lootdeckHelpers.ListEnemiesInRoom(pos, ignoreVulnerability, filter)
	local entities = Isaac.FindInRadius(pos, 1875, EntityPartition.ENEMY)
	local enemies = {}
	for _, entity in pairs(entities) do
		if (ignoreVulnerability or entity:IsVulnerableEnemy()) and (not filter or filter(entity, entity:GetData())) then
            table.insert(enemies, entity)
		end
	end
	return enemies
end

function lootdeckHelpers.ListBossesInRoom(pos, ignoreMiniBosses, filter)
	local enemies = lootdeckHelpers.ListEnemiesInRoom(pos, true, filter)
    local bosses = {}

    for _, enemy in pairs(enemies) do
        if enemy:IsBoss() and (enemy.Type == EntityType.ENTITY_THE_HAUNT or enemy.Type == EntityType.ENTITY_MASK_OF_INFAMY or enemy:IsVulnerableEnemy()) and (not ignoreMiniBosses or (ignoreMiniBosses and (enemy.SpawnerType == 0 or enemy.SpawnerType == EntityType.ENTITY_MASK_OF_INFAMY or enemy.SpawnerType == EntityType.ENTITY_THE_HAUNT))) then
            table.insert(bosses, enemy)
        end
    end

    return bosses
end

-- function for finding random enemy in the room
function lootdeckHelpers.FindRandomEnemy(pos, rng, tag, filter)
	local enemies = lootdeckHelpers.ListEnemiesInRoom(pos, false, filter)
    local chosenEnt = enemies[rng:RandomInt(#enemies) + 1]
    if chosenEnt and tag then
        chosenEnt:GetData()[tag] = true
    end
    return chosenEnt
end

function lootdeckHelpers.StaggerSpawn(key, p, interval, occurences, callback, onEnd, noAutoDecrement)
	local data = p:GetData().lootdeck
    if data[key] and data[key] > 0 then
		local timerName = key.."Timer"
		local counterName = key.."Counter"
		if not data[timerName] then data[timerName] = 0 end
		if not data[counterName] then data[counterName] = occurences end

        data[timerName] = data[timerName] - 1
        if data[timerName] <= 0 then
			local result = callback(p, counterName)
            if data[key] >= 2 then
                callback(p, counterName, result)
            end
            data[timerName] = interval
			if noAutoDecrement ~= 1 then
				data[counterName] = data[counterName] - 1
			end
            if data[counterName] <= 0 then
                data[key] = nil
				data[timerName] = nil
				data[counterName] = nil
				if onEnd then
					onEnd(p)
				end
            end
        end
    end
end

function lootdeckHelpers.ClearStaggerSpawn(tag)
    lootdeckHelpers.ForEachPlayer(function(_, data)
        data[tag] = nil
        data[tag.."Timer"] = nil
        data[tag.."Counter"] = nil
    end)
end

function lootdeckHelpers.ForEachEntityInRoom(callback, entityType, entityVariant, entitySubType, extraFilters)
    local filters = {
        Type = entityType,
        Variant = entityVariant,
        SubType = entitySubType
    }

    local initialEntities = Isaac.GetRoomEntities()

    for _, entity in ipairs(initialEntities) do
        local shouldReturn = true
        for entityKey, filter in pairs(filters) do
            if not shouldReturn then
                break
            end

            if filter ~= nil then
                if type(filter) == "function" then
                    shouldReturn = filter(entity[entityKey])
                else
                    shouldReturn = entity[entityKey] == filter
                end
            end
        end

        if shouldReturn and extraFilters ~= nil then
            shouldReturn = extraFilters(entity)
        end

        if shouldReturn then
            callback(entity)
        end
	  end
end

function lootdeckHelpers.RemoveHitFamiliars(id, hitTag)
    lootdeckHelpers.ForEachEntityInRoom(function(entity)
        entity:Remove()
    end, EntityType.ENTITY_FAMILIAR, id, nil, function(entity)
        return entity:GetData()[hitTag] == true
    end)
end

function lootdeckHelpers.Spawn(type, variant, subType, position, velocity, spawner, seed)
    local entity
    if seed then
        entity = Game():Spawn(type, variant or 0, position, velocity, spawner, subType or 0, seed)
    else
        entity = Isaac.Spawn(type, variant or 0, subType or 0, position, velocity, spawner)
    end
    if Isaac.GetChallenge() == lootdeckChallenges.gimmeTheLoot.Id then
        entity:GetData()[lootdeckChallenges.gimmeTheLoot.Tag] = true
    end

    return entity
end

-- function for registering basic loot cards that spawn items
function lootdeckHelpers.SpawnEntity(p, spawnType, spawnVariant, spawnSubtype, uses, position, sound, effect, effectAmount)
    local output = {
        effects = {},
        entities = {}
    }
    if effect then
        for i=1,(effectAmount or 1) do
            local newEffect = Isaac.Spawn(EntityType.ENTITY_EFFECT, effect, 0, position or p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)
            table.insert(output.effects, newEffect)
        end
    end
    if sound then
        lootdeck.sfx:Play(sound)
    end
    for i = 1,(uses or 1) do
        local entity = lootdeckHelpers.Spawn(spawnType, spawnVariant or 0, spawnSubtype or 0, position or p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)

        table.insert(output.entities, entity)
    end

    return output
end

function lootdeckHelpers.GetEntityByInitSeed(initSeed)
    local entities = Isaac.GetRoomEntities()

    for _, entity in pairs(entities) do
        if tostring(entity.InitSeed) == tostring(initSeed) then
            return entity
        end
    end
end

return H
