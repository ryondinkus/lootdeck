local helper = include("helper_functions")

-- Rerolls an enemy in a room and drops an extra reward per room
local Name = "Purple Heart"
local Tag = "purpleHeart"
local Id = Isaac.GetItemIdByName(Name)

local shouldRerollEnemyTag = string.format("%sShouldRerollEnemy", Tag)
local preRerollEnemySeedList = string.format("%sPreRerollEnemySeedList", Tag)
local rerolledEnemy = string.format("%sRerolledEnemy", Tag)
local chosenEnemy = string.format("%sChosenEnemy", Tag)

local function MC_POST_NEW_ROOM()
    local game = Game()
    local room = game:GetRoom()
    helper.ForEachPlayer(function(_, data)
        if not room:IsClear() then
            -- TODO add percentage chance
            data[shouldRerollEnemyTag] = true
            data[preRerollEnemySeedList] = {}
        end
    end, Id)
end

local function MC_POST_UPDATE()
    local game = Game()
    helper.ForEachPlayer(function(p, data)
        if data[preRerollEnemySeedList] and #data[preRerollEnemySeedList] > 0 then
            for _, enemy in ipairs(helper.ListEnemiesInRoom(p.Position, false, nil, false, chosenEnemy)) do
                local isRerolledEnemy = true
                for _, initSeed in ipairs(data[preRerollEnemySeedList]) do
                    if enemy.InitSeed == initSeed then
                        isRerolledEnemy = false
                        break
                    end
                end

                if isRerolledEnemy then
                    data[preRerollEnemySeedList] = nil
                    enemy:GetData()[chosenEnemy] = true
                    data[rerolledEnemy] = enemy
                    break
                end
            end
        end

        if data[shouldRerollEnemyTag] then
            local target = helper.FindRandomEnemy(p.Position, false) or 0
            if target ~= 0 then
                local enemyInitSeeds = {}
                for _, enemy in ipairs(helper.ListEnemiesInRoom(p.Position, false, nil, false, chosenEnemy)) do
                    table.insert(enemyInitSeeds, enemy.InitSeed)
                end
                data[preRerollEnemySeedList] = enemyInitSeeds
                target:GetData()[chosenEnemy] = true
                game:RerollEnemy(target)
            end
            data[shouldRerollEnemyTag] = nil
        end

        if data[rerolledEnemy] and data[rerolledEnemy]:HasMortalDamage() then
            local itemToSpawn = helper.GlyphOfBalance(p)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, itemToSpawn[1], itemToSpawn[2], data[rerolledEnemy].Position, Vector.Zero, nil)
            data[rerolledEnemy] = nil
        end
    end, Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
        }
    }
}