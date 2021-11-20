local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; Swap the pools of Red Chests and Gold Chests
local Names = {
    en_us = "The Left Hand",
    spa = "La Mano Izquierda"
}
local Name = Names.en_us
local Tag = "leftHand"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: Swaps the potential drops of Gold Chests and Red Chests",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: Cambia las recompensas potenciales de los Cofres Dorados y los Cofres Rojos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Swaps the potential drops of Gold Chests and Red Chests.")

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.leftHand.Id, SoundEffect.SOUND_VAMP_GULP)
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
