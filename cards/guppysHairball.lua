
local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the Guppy's Hairball item
local Names = {
    en_us = "Guppy's Hairball",
    spa = "Bola de Pelo de Guppy"
}
local Name = Names.en_us
local Tag = "guppysHairball"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: Every instance of damage taken has a 1/6 chance to be blocked",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Cada vez que se reciba daño, hay una posibilidad de 1/6 de bloquearlo"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Every instance of damage taken has a 1/6 chance to be blocked.", "- Additional copies of the passive add an extra 1/6 chance, up to 3/6.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.guppysHairball.Id, SoundEffect.SOUND_VAMP_GULP)
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
