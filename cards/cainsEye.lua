local helper = LootDeckHelpers
local items = include("items/registry")

-- Gives the Cain's Eye item
local Names = {
    en_us = "Cain's Eye",
    spa = "Ojo de Cain"
}
local Name = Names.en_us
local Tag = "cainsEye"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: Gain a random mapping effect ( {{Collectible54}} Treasure Map, {{Collectible21}} The Compass, {{Collectible246}} Blue Map) for each floor",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Gana efectos de mapas ({{Collectible54}} Mapa del Tesoro, {{Collectible21}} La Brújula, {{Collectible}}) por cada piso"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: On each floor, gain a random effect of either Treasure Map, The Compass, or Blue Map.", "- Additional copies of the passive grant extra mapping effects, avoiding duplicate effects.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.cainsEye.Id, SoundEffect.SOUND_VAMP_GULP)
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
