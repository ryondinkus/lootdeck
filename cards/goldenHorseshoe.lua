local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Golden Horseshoe item
local Name = "Golden Horseshoe"
local Tag = "goldenHorseshoe"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: Every Treasure room has an additional {{Collectible721}} TMTRAINER item"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Every Treasure room has an additional TMTRAINER item.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.goldenHorseshoe.Id, SoundEffect.SOUND_VAMP_GULP)
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
