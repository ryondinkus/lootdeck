
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Curved Horn"
local Tag = "curvedHorn"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Stacking on a single player = more inital shots that are big, audio/visual indicators
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.curvedHorn.Id, SoundEffect.SOUND_VAMP_GULP)
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