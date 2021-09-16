local helper = include('helper_functions')

-- A 1 in 2 chance of losing half a heart and gaining 4 coins or losing a full heart and gaining 8 coins
local Name = "XVI. Temperance"
local Tag = "temperance"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Visual and audio indicator for results, card spawns based on lootdeck weights
local function MC_USE_CARD(_, c, p)
    local rng = lootdeck.rng
    local effect = rng:RandomInt(2)
    if effect == 0 then
		helper.TakeSelfDamage(p, 1, true)
		for i=0,3 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    else
        helper.TakeSelfDamage(p, 2, true)
        for i=0,7 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, p.Position, Vector.Zero, p)
    lootdeck.sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 0)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
