local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; 50% chance each room to grant a temporary copy of a random passive you already have
local Name = "Rainbow Tapeworm"
local Tag = "rainbowTapeworm"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: On room entry, 50% chance to temporarily duplicate one of your existing passives"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: When entering a room, 50% chance to duplicate one of your passives for the rest of the room."},
						}}

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.rainbowTapeworm.Id, SoundEffect.SOUND_VAMP_GULP)
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
