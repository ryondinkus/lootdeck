
local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the swallowed penny item
local Name = "Swallowed Penny"
local Tag = "swallowedPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: 50% chance to drop a penny after taking damage"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: 50% chance to drop a penny after taking damage.", "- Increased chance to drop a penny for every extra copy of Swallowed Penny.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.swallowedPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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
