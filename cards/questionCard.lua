local helper = include('helper_functions')

-- Spawns a permacharmed copy of an enemy in the room, spawns a random permacharmed enemy if no enemies in room
local Name = "? Card"
local Tag = "questionCard"
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
