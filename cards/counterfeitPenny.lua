local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the cointerfeit penny item
local Name = "Counterfeit Penny"
local Tag = "counterfeitPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: Get an additional +1 Coin every time you gain Coins"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: Gain an additional +1 Coin whenever you gain coins."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.counterfeitPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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
