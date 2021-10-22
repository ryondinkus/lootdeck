local helper = include('helper_functions')

-- Spawns three pennies
local Name = "3 Cents!"
local Tag = "threeCents"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 21
local Description = "Spawns three Pennies"
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns three Pennies on use.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 3, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 3)
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
