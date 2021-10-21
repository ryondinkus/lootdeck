local helper = include('helper_functions')

-- Teleport 2.0 effect
local Name = "O. The Fool"
local Tag = "theFool"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Triggers the {{Collectible419}} Teleport 2.0 effect, teleporting you to an unvisited room"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, triggers the Teleport 2.0 effect, which teleports you to an unvisited room with certain priority given to special rooms."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_TELEPORT_2)
	return false
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
