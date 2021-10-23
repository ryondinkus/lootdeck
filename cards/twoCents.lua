local helper = include('helper_functions')

-- Spawns two pennies
local Name = "2 Cents!"
local Tag = "twoCents"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 17
local Description = "Spawns a Double Penny"
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Double Penny on use.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 2)
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
