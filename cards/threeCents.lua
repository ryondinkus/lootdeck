local helper = LootDeckAPI

-- Spawns three pennies
local Names = {
    en_us = "3 Cents!",
    spa = "¡3 Centavos!"
}
local Name = Names.en_us
local Tag = "threeCents"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
    en_us = "Spawns 3 Pennies",
    spa = "Genera 3 pennies"
}
local HolographicDescriptions = {
    en_us = "Spawns {{ColorRainbow}}6{{CR}} Pennies",
    spa = "Genera {{ColorRainbow}}6{{CR}} pennies"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns three Pennies on use.", "Holographic Effect: Spawns six Pennies.")

local function MC_USE_CARD(_, c, p)
	helper.SpawnEntity(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 3, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 3)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
	WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        }
    },
    Tests = {
        {
            action = TestActions.GIVE_CARD,
            arguments = {
                id = Id
            }
        },
        {
            action = TestActions.USE_CARD,
            arguments = {}
        }
    }
}
