local helper = LootDeckAPI
local items = include("items/registry")

-- trinket; Grants a temporary effect of a random battery item for the rest of the floor
local Names = {
    en_us = "AAA Battery",
    spa = "Batería AAA"
}
local Name = Names.en_us
local Tag = "aaaBattery"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: For each new floor, grants a random temporary battery item",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Por cada piso, otorgará un objeto de batería aleatorio"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Grants a random temporary battery item for each new floor.", "- Additional copies of the passive grant extra battery items.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
    helper.GiveItem(p, items.aaaBattery.Id, SoundEffect.SOUND_VAMP_GULP)
    items.aaaBattery.helpers.GivePlayerItem(p)
    p:GetData().lootdeck[Tag .. "Played"] = false
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
