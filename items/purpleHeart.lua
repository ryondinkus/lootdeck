local helper = include("helper_functions")

-- Rerolls an enemy in a room and drops an extra reward per room
local Names = {
    en_us = "Purple Heart",
    spa = "Corazón Purputa"
}
local Name = Names.en_us
local Tag = "purpleHeart"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "25% chance to reroll a random enemy in the room# Rerolled enemies drop a consumable on death",
    spa = "25% de rerolear a un enemigo aleatorio en la habitación#Los enemigos reroleados sueltan un recolectable al derrolatolos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("25% chance to reroll a random enemy in the room.", "- Additional copies of the passive add an additional 25% chance, up to 100%.", "Rerolled enemies drop an extra consumable on death.", "- Consumables spawned are based on the algorithm from Glyph of Balance, granting a consumable you have the least of.")

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
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
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
