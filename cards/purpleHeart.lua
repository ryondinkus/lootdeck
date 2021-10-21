local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Purple Heart item
local Name = "Purple Heart"
local Tag = "purpleHeart"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: 25% chance to reroll a random enemy in the room# Rerolled enemies drop a consumable on death"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: 25% chance to reroll a random enemy in the room."},
							{str = "- Additional copies of the passive add an additional 25% chance, up to 100%."},
							{str = "Rerolled enemies drop an extra consumable on death."},
							{str = "- Consumables spawned are based on the algorithm from Glyph of Balance, granting a consumable you have the least of."}
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.purpleHeart.Id, SoundEffect.SOUND_VAMP_GULP)
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
