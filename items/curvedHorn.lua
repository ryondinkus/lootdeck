local helper = LootDeckAPI

-- Gives an extra large and damage-boosted tear in each new room, the number of tears in each room being the number of curved horns
local Names = {
    en_us = "Curved Horn",
    spa = "Cuerno Torcido"
}
local Name = Names.en_us
local Tag = "curvedHorn"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "Quadruple damage for the first tear fired in a room",
    spa = "Cuadriplica el daño de la primer lágrima lanzada en una habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("In a room with active enemies, the first tear fired has x4 damage and size.", "- This effect occurs when enemies spawn after entering a room, such as when a spider spawns from a pot.", "- Additional copies of the passive let you fire additional x4 damage tears.")

local finishedTag = string.format("%sFinished", Tag)
local roomClearedTag = string.format("%sRoomCleared", Tag)
local greedModeWaveTag = string.format("%sGreedModeWave", Tag)
local bossRushBossesTag = string.format("%sBossRushBosses", Tag)

local function Initialize(p)
    local game = Game()
    if helper.AreEnemiesInRoom(game:GetRoom()) then
        local data = p:GetData().lootdeck
        data[finishedTag] = false
        data[roomClearedTag] = nil
        if game:IsGreedMode() then
            data[greedModeWaveTag] = 0
        end
        data.curvedHornTearAmount = p:GetCollectibleNum(Id) or 1
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(Initialize, Id)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    helper.TriggerOnRoomEntryPEffectUpdate(p, Id, Initialize, function() end, Tag);
end

local function MC_POST_FIRE_TEAR(_, tear)
    local p = tear:GetLastParent():ToPlayer()
    local data = p:GetData().lootdeck
    if p:HasCollectible(Id) then
        if data.curvedHornTearAmount and data.curvedHornTearAmount > 0 then
            tear.CollisionDamage = tear.CollisionDamage * 4
            tear.Size = tear.Size * 4
            tear.Scale = tear.Scale * 4
            data.curvedHornTearAmount = data.curvedHornTearAmount - 1
            lootdeck.sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK,1,0)
        else
            data[finishedTag] = true
        end
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        },
        {
            ModCallbacks.MC_POST_FIRE_TEAR,
            MC_POST_FIRE_TEAR
        }
    }
}
