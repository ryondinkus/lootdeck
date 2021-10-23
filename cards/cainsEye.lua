local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Cain's Eye item
local Name = "Cain's Eye"
local Tag = "cainsEye"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: Gain a random mapping effect ( {{Collectible54}} Treasure Map, {{Collectible21}} The Compass, {{Collectible246}} Blue Map) for each floor"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: On each floor, gain a random effect of either Treasure Map, The Compass, or Blue Map.", "- Additional copies of the passive grant extra mapping effects, avoiding duplicate effects.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.cainsEye.Id, SoundEffect.SOUND_VAMP_GULP)
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
