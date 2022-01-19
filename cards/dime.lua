local helper = LootDeckAPI

-- Spawns a dime
local Names = {
    en_us = "A Dime!!",
    spa = "¡¡Un Décimo!!"
}
local Name = Names.en_us
local Tag = "dime"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a Dime",
    spa = "Genera un décimo"
}
local HolographicDescriptions = {
    en_us = "Spawns {{ColorRainbow}}2{{CR}} Dimes",
    spa = "Genera {{ColorRainbow}}2{{CR}} décimos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Dime on use.", "Holographic Effect: Spawns two dimes.")

local function MC_USE_CARD(_, c, p)
	helper.SpawnEntity(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.CRACKED_ORB_POOF, 1)
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
            action = "GIVE_CARD",
            arguments = {
                id = Id
            }
        },
        {
            action = "USE_CARD",
            arguments = {}
        }
    }
}
