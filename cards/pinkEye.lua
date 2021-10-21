local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Pink Eye"
local Tag = "pinkEye"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: On damage taken, 5% chance to fire a {{Collectible531}} Haemolacria tear with poisonous green creep towards your attacker"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: On damage taken, 5% chance to fire a Haemolacria tear with poisonous green creep towards the enemy that damaged you."},
							{str = "- Additional copies of the passive grant an extra 5% chance to trigger up to 25%."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.pinkEye.Id, SoundEffect.SOUND_VAMP_GULP)
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
