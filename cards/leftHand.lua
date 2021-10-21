local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; Swap the pools of Red Chests and Gold Chests
local Name = "The Left Hand"
local Tag = "leftHand"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: Swaps the potential drops of Gold Chests and Red Chests"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: Swaps the potential drops of Gold Chests and Red Chests."},
						}}

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.leftHand.Id, SoundEffect.SOUND_VAMP_GULP)
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
