local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the Cancer item
local Names = {
    en_us = "Cancer!",
    spa = "¡Cancer!"
}
local Name = Names.en_us
local Tag = "cancer"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use#{{ArrowUp}} Passive: Massive firerate increase when entering a room with enemies#{{ArrowDown}} The firerate increase quickly diminishes over time",
    spa = "Añade un efecto pasivo tras usarla#Efecto pasivo: {{ArrowUp}} Aumento masivo en potencia de fuego al entrar en una habitación con enemigos#El efecto disminuye rápidamente"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: In a room with active enemies, your firerate massively increases, then decreases over time.", "- This effect occurs when enemies spawn after entering a room, such as when a spider spawns from a pot.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.cancer.Id, SoundEffect.SOUND_VAMP_GULP)
    items.cancer.helpers.Initialize(p)
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
