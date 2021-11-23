local helper = include('helper_functions')

-- Meat Cleaver effect
local Names = {
    en_us = "Jera",
    spa = "Jera"
}
local Name = Names.en_us
local Tag = "jera"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a Lost Soul familiar, who will discover Tinted Rocks and Secret Rooms and blow them up# If used while a Lost Soul already exists, it will spawn a Found Soul instead. The two souls will fall in love, spawn a Soul Heart, and fly away.",
    spa = "Genera un Alma Perdida familiar, que encontrará las piedras marcadas y entradas a Salas Secretas y las explotará#Si ya se tiene un Alma Perdida, se generará un Alma Encontrada en su lugar en medio de la habitación, las dos almas se enamorarán y volarán lejos, soltando un Corazón de Alma"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers the Meat Cleaver effect, which splits all room enemies in half with half of their respective HP.", "- All cleaved enemies will drop a Full Red Heart.", "Holographic Effect: Splits all enemies, then splits them again.")

local function MC_USE_CARD(_, c, p)
    local enemies = helper.ListEnemiesInRoom(p.Position)
    if #enemies > 0 then
        for _, entity in pairs(enemies) do
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, entity.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), entity)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector.Zero, nil)
        end
        helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_MEAT_CLEAVER)
    else
        helper.TakeSelfDamage(p, 2)
        helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CLEAVER_SLASH, 0, p.Position, Vector.Zero, nil)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, p.Position, Vector.Zero, nil)
        lootdeck.sfx:Play(SoundEffect.SOUND_SHELLGAME, 1, 0)
        lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_BURST_SMALL, 1, 0)
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
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true,
            0.25
        }
    }
}
