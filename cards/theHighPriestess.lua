local helper = LootDeckAPI
local entityVariants = include("entityVariants/registry")

-- Drops 1-6 Mom's Fingers on random enemies in the room
local Names = {
    en_us = "II. The High Priestess",
    spa = "II. La Gran Sacerdotiza"
}
local Name = Names.en_us
local Tag = "theHighPriestess"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Drops 1-6 Mom's Fingers onto enemies, dealing 40 damage to each enemy hit# If no enemies are present, a Mom's Finger will drop on the player, dealing fake damage.",
    spa = "Suelta 1-6 dedos de Mamá en los enemigos, provocando 40 de daño a cada enemigo golpeado#Si no hay enemigos, un dedo de Mamá caerá sobre el jugador, efectuando daño falso"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Drops 1-6 Mom's Fingers onto enemies, dealing 40 damage to each enemy hit.", "- The same enemy cannot be hit by multiple fingers.", "If no enemies are in the room when used, a Mom's Finger will drop on the player, dealing fake damage similar to Dull Razor.", "Holographic Effect: Spawns twice the amount of fingers, dropping two at a time.")

local function SpawnFinger(target)
    if target ~= 0 then
        local finger = Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.momsFinger.Id, 0, target.Position, Vector(0,0), nil)
        local fingerData = finger:GetData()
        fingerData.target = target
    end
end

local function MC_USE_CARD(_, c, p, f, shouldDouble)
	local data = p:GetData().lootdeck

    if #helper.ListEnemiesInRoom() > 0 then
        data[Tag] = 1
        if shouldDouble then
            data[Tag] = data[Tag] + 1
        end
    else
        SpawnFinger(p)
    end

    lootdeck.sfx:Play(SoundEffect.SOUND_MOM_VOX_ISAAC, 1, 0, false, 1.2)
end

local function MC_POST_NEW_ROOM()
    LootDeckAPI.ForEachPlayer(function(player)
        helper.StopStaggerSpawn(player, Tag)
    end)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    if p:GetData().lootdeck[Tag] then
        local rng = p:GetCardRNG(Id)
    	helper.StaggerSpawn(Tag, p, 15, (rng:RandomInt(6) + 1) * (p:GetData().lootdeck[Tag] or 0), function()
    		SpawnFinger(helper.GetRandomEnemy(rng) or 0)
    	end)
    end
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
