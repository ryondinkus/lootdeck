local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the bloody penny item
local Name = "Bloody Penny"
local Tag = "bloodyPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: 5% chance to drop a Loot Card on enemy death"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Enemies have a 5% chance to drop a Loot Card on death.", "- Effect stacks +5% for every instance of the passive and caps at 25%.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.bloodyPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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
