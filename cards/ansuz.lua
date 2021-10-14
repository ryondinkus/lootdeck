local helper = include('helper_functions')

-- Teleport to Treasure Room, Shop, or Boss, with priority given to unvisited rooms
local Name = "Ansuz"
local Tag = "ansuz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)

end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}