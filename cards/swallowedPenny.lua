
local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the swallowed penny item
local Name = "Swallowed Penny"
local Tag = "swallowedPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.swallowedPenny.Id, SoundEffect.SOUND_VAMP_GULP)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
