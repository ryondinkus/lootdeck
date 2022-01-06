
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
    en_us = "Adds a unique passive item on use# Passive: On damage taken, lose 1 cent and fire a penny tear in a random direction# The penny tear has 2x damage and drops a Penny and a puddle of creep when it makes contact",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: Al recibir daño, perderás y dispararás una moneda en una dirección aleatoria# Esta moneda hace tu daño x2 y genera tanto una moneda como un charco de Creep al hacer contacto"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: On damage taken, lose 1 cent and fire a penny tear in a random direction", "- The penny tear will have 2x damage.", "- On contact with enemies, obstacles, or the floor, penny tears will turn into a normal Penny (or rarely, other coin types) and leave a puddle of creep behind.", "- Additional copies will fire extra penny tears in random directions, at the cost of additional cents.", "Holographic Effect: Grants two copies of the passive.")

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
