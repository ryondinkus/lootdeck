local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Purple Heart item
local Name = "Purple Heart"
local Tag = "purpleHeart"
local Id = Isaac.GetCardIdByName(Name)

-- BUG: Our standard helper.FindRandomEnemy(_, noDupes) doesn't work here since rerolled enemies don't preserve their data tables
-- can't really think of a good way to track rerolled enemies right now
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.purpleHeart.Id, SoundEffect.SOUND_VAMP_GULP)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}