local helper = LootDeckHelpers
local items = include("items/registry")

-- trinket; 1/10 tears replaced with Worm Tears, which have endless range and create slowing creep on collision
local Names = {
    en_us = "Tape Worm",
    spa = "Gusano"
}
local Name = Names.en_us
local Tag = "tapeWorm"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: 10% chance to fire a Worm Tear, which has endless range and spawns slowing creep",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: 10% de posibilidad de lanzar una lágrima con efecto de gusano, con rango infinito y suelta rastro ralentizador"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: 10% chance to fire a Worm Tear.", "- Worm Tears have endless range, and spawn a streak of slowing creep wherever they go.", "- Additional copies of the passive increase the chance up to 25%", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
    helper.GiveItem(p, items.tapeWorm.Id, SoundEffect.SOUND_VAMP_GULP)
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
