local helper = include('helper_functions')

-- Spawns four pennies
local Name = "4 Cents!"
local Tag = "fourCents"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 13
local Description = "Spawns four Pennies"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Spawns four Pennies on use."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 4, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 4)
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
