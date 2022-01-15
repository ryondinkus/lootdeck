local helper = LootDeckAPI

-- Spawns a nickel
local Names = {
    en_us = "A Nickel!",
    spa = "¡Un Nickel!"
}
local Name = Names.en_us
local Tag = "nickel"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
    en_us = "Spawns a Nickel",
    spa = "Genera un nickel"
}
local HolographicDescriptions = {
    en_us = "Spawns {{ColorRainbow}}2{{CR}} Nickels",
    spa = "Genera {{ColorRainbow}}2{{CR}} nickels"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Nickel on use.", "Holographic Effect: Spawns two Nickels.")

local function MC_USE_CARD(_, c, p)
	helper.SpawnEntity(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.CRACKED_ORB_POOF, 1)
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
            action = TestActions.USE_PILL_CARD,
            arguments = {}
        }
    }
}
