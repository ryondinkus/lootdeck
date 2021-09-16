local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Broken Ankh item
local Name = "Broken Ankh"
local Tag = "brokenAnkh"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- BUG: When you revive, your streak is still lost, and saving/continuing is disabled. this is because Revive() is bugged and the game still thinks you're dead
-- due to how poorly extra lives are supported in the API, this is probably the best we're getting without massive overcomplications
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.brokenAnkh.Id, SoundEffect.SOUND_VAMP_GULP)
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