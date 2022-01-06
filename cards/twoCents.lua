local helper = LootDeckAPI

-- Spawns two pennies
local Names = {
    en_us = "2 Cents!",
    spa = "¡2 Centavos!"
}
local Name = Names.en_us
local Tag = "twoCents"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
    en_us = "Spawns a Double Penny",
    spa = "Genera una moneda doble"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Double Penny on use.", "Holographic Effect: Spawns two Double Pennies.")

local function MC_USE_CARD(_, c, p)
	helper.SpawnEntity(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 2)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
	WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        }
    }
}
