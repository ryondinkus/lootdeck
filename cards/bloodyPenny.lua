local helper = lootdeckHelpers
local items = include("items/registry")

-- Gives the bloody penny item
local Names = {
    en_us = "Bloody Penny",
    spa = "Moneda Sangrienta"
}
local Name = Names.en_us
local Tag = "bloodyPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: 5% chance to drop a Loot Card on enemy death",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Matar a un enemigo otorga un 5% de posibilidad de que suelte una carta de loot"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Enemies have a 5% chance to drop a Loot Card on death.", "- Effect stacks +5% for every instance of the passive and caps at 25%.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.bloodyPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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
