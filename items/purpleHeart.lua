local helper = include("helper_functions")

-- Rerolls an enemy in a room and drops an extra reward per room
local Name = "Purple Heart"
local Tag = "purpleHeart"
local Id = Isaac.GetItemIdByName(Name)
local Description = "25% chance to reroll a random enemy in the room# Rerolled enemies drop a consumable on death"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "25% chance to reroll a random enemy in the room."},
							{str = "- Additional copies of the passive add an additional 25% chance, up to 100%."},
							{str = "Rerolled enemies drop an extra consumable on death."},
							{str = "- Consumables spawned are based on the algorithm from Glyph of Balance, granting a consumable you have the least of."}
						}}

local shouldRerollEnemyTag = string.format("%sShouldRerollEnemy", Tag)
local preRerollEnemySeedList = string.format("%sPreRerollEnemySeedList", Tag)
local rerolledEnemy = string.format("%sRerolledEnemy", Tag)
local chosenEnemy = string.format("%sChosenEnemy", Tag)

local function MC_POST_NEW_ROOM()
    local game = Game()
    local room = game:GetRoom()
    helper.ForEachPlayer(function(p, data)
        if not room:IsClear() then
            if helper.PercentageChance(25*p:GetCollectibleNum(Id), 100) then
                data[shouldRerollEnemyTag] = true
                data[preRerollEnemySeedList] = {}
            end
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
                lootdeck.sfx:Play(SoundEffect.SOUND_EDEN_GLITCH, 1, 0)
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
    Description = Description,
    WikiDescription = WikiDescription,
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
