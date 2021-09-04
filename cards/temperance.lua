local Name = "XVI. Temperance"
local Tag = "temperance"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Visual and audio indicator for results, card spawns based on lootdeck weights
local function MC_USE_CARD(_, c, p)
    local rng = lootdeck.rng
    local effect = rng:RandomInt(2)
    if effect == 0 then
        p:TakeDamage(1,0,EntityRef(p),0)
        for i=0,3 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    else
        p:TakeDamage(2,0,EntityRef(p),0)
        for i=0,7 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, p.Position, Vector.Zero, p)
    lootdeck.sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 0)
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
        }
    }
}