local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Cancer item
local Name = "Cancer!"
local Tag = "cancer"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use#{{ArrowUp}} Passive: Massive firerate increase when entering a room with enemies#{{ArrowDown}} The firerate increase quickly diminishes over time"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: In a room with active enemies, your firerate massively increases, then decreases over time."},
							{str = "- This effect occurs when enemies spawn after entering a room, such as when a spider spawns from a pot."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.cancer.Id, SoundEffect.SOUND_VAMP_GULP)
    items.cancer.helpers.Initialize(p)
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
