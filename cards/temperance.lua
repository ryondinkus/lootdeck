local helper = include('helper_functions')

-- A 1 in 2 chance of losing half a heart and gaining 4 coins or losing a full heart and gaining 8 coins
local Name = "XVI. Temperance"
local Tag = "temperance"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Random chance for any of these effects:#{{Warning}} Take 1 Half Heart of damage (fatal), gain 4 Cents#{{Warning}} Take 1 Full Heart of damage (fatal), gain 8 cents"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
                            {str = "On use, triggers one of either effects:"},
                            {str = "- Take 1 Half Heart of damage, gain 4 Coins. This damage can kill the player."},
                            {str = "- Take 1 Full Heart of damage, gain 8 Coins. This damage can kill the player."},
						}}

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
    return false
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
