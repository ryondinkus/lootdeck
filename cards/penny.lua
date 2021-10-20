local helper = include('helper_functions')

-- Spawns a penny
local Name = "A Penny!"
local Tag = "penny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 11
local Description = "Spawns a Penny"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Spawns a Penny on use."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 1)
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
