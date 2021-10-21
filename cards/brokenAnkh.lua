local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Broken Ankh item
local Name = "Broken Ankh"
local Tag = "brokenAnkh"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: On death, 1/6 chance to revive with half a heart"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: On player death, you have a 1/6 chance of reviving with half a heart."},
							{str = "- Additional copies of the passive grant an extra revival chance up to 3/6."},
						}}


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
