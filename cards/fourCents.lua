local helper = include('helper_functions')

-- Spawns four pennies
local Names = {
    en_us = "4 Cents!",
    spa = "¡4 Centavos!"
}
local Name = Names.en_us
local Tag = "fourCents"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Descriptions = {
    en_us = "Spawns four Pennies",
    spa = "Genera 4 pennies"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns four Pennies on use.", "Holographic Effect: Spawns eight Pennies.")

local function MC_USE_CARD(_, c, p)
	helper.SpawnEntity(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 4, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 4)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
	WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        }
    }
}
