local helper = lootdeckHelpers

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
    en_us = "Triggers the {{Collectible631}} Meat Cleaver effect, splitting all room enemies in half with half their respective HP# All cleaved enemies will drop a Full Red Heart# If used with no enemies in the room, it will damage the player for one full heart and drop a Full Red Heart",
    spa = "Activa el efecto del {{Collectible631}} Cuchillo de Carnicero, partiendo a los enemigos a la mitad con la mitad de sus PS respectivos#Los enemigos partidos soltarán un Corazón Rojo#Si se usa en una habitación sin enemigos, dañará al jugador y soltará un Corazón Rojo"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers the Meat Cleaver effect, which splits all room enemies in half with half of their respective HP.", "- All cleaved enemies will drop a Full Red Heart.", "Holographic Effect: Splits all enemies, then splits them again.")

local function MC_USE_CARD(_, c, p, f, _, rng)
    local enemies = helper.ListEnemiesInRoom(p.Position)
    if #enemies > 0 then
        for _, entity in pairs(enemies) do
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, entity.Position, Vector.FromAngle(rng:RandomInt(360)), entity)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, entity.Position, Vector.Zero, nil)
        end
        helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_MEAT_CLEAVER)
    else
        helper.TakeSelfDamage(p, 2)
        helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL, p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
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
