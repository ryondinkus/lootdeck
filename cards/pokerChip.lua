local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; All penny spawns are either double pennies or nothing
local Names = {
    en_us = "Poker Chip",
    spa = "Ficha de Póker"
}
local Name = Names.en_us
local Tag = "pokerChip"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: All coin spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: Todas las monedas tienen un 50/50 de posibilidad de generarse como monedas dobles o no generarse en sí"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: All coins spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all.", "- Double coins still retain their respective values. (Double Nickels, Double Dimes, etc.)")

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.pokerChip.Id, SoundEffect.SOUND_VAMP_GULP)
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
