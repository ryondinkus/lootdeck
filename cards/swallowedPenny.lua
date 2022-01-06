
local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the swallowed penny item
local Names = {
    en_us = "Swallowed Penny",
    spa = "Moneda Tragada"
}
local Name = Names.en_us
local Tag = "swallowedPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: 50% chance to drop a penny after taking damage",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: 50% de posibilidad de generar un penny al recibir daño"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: 50% chance to drop a penny after taking damage.", "- Increased chance to drop a penny for every extra copy of Swallowed Penny.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.swallowedPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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
