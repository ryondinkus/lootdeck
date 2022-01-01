local helper = LootDeckHelpers
local items = include("items/registry")

local Names = {
    en_us = "Pink Eye",
    spa = "Ojo Rosado"
}
local Name = Names.en_us
local Tag = "pinkEye"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: On damage taken, 5% chance to fire a {{Collectible531}} Haemolacria tear with poisonous green creep towards your attacker",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: Al recibir daño, tienes un 5% de posibilidad de disparar una lágrima de {{Collectible531}} Haemolacria con creep venenoso hacia el atacante"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: On damage taken, 5% chance to fire a Haemolacria tear with poisonous green creep towards the enemy that damaged you.", "- Additional copies of the passive grant an extra 5% chance to trigger up to 25%.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.pinkEye.Id, SoundEffect.SOUND_VAMP_GULP)
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
