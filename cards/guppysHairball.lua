
local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Guppy's Hairball item
local Name = "Guppy's Hairball"
local Tag = "guppysHairball"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: Every instance of damage taken has a 1/6 chance to be blocked"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Every instance of damage taken has a 1/6 chance to be blocked.", "- Additional copies of the passive add an extra 1/6 chance, up to 3/6.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.guppysHairball.Id, SoundEffect.SOUND_VAMP_GULP)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Description = Description,
	WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
