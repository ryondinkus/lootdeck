local helper = LootDeckAPI
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
    en_us = "Adds a unique passive item on use# Passive: 10% chance to fire a Worm Tear, which has very high range, spawns slowing creep, and bounces off obstacles like {{Collectible221}} Rubber Cement",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: 10% de posibilidad de lanzar una lágrima con efecto de gusano, con rango alto, suelta rastro ralentizador, y rebota en los obstáculos como {{Collectible221}} Pegamento Elástico"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: 10% chance to fire a Worm Tear, which has endless range and spawns slowing creep",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo al usarla#Efecto pasivo: 10% de posibilidad de lanzar una lágrima con efecto de gusano, con rango infinito y suelta rastro ralentizador"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: 10% chance to fire a Worm Tear.", "- Worm Tears have very high range, occasionally spawn slowing creep, and bounce off of enemies, obstacles, and walls like Rubber Cement.", "- Additional copies of the passive increase the chance up to 25%", "Holographic Effect: Grants two copies of the passive.")

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
    HolographicDescriptions = HolographicDescriptions,
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
