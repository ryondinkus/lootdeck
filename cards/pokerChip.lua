local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; All penny spawns are either double pennies or nothing
local Name = "Poker Chip"
local Tag = "pokerChip"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: All coin spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: All coins spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all."},
							{str = "- Double coins still retain their respective values. (Double Nickels, Double Dimes, etc.)"},
						}}

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.pokerChip.Id, SoundEffect.SOUND_VAMP_GULP)
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
