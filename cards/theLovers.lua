local helper = include("helper_functions")

-- Gain two temporary hearts for the room
local Name = "VI. The Lovers"
local Tag = "theLovers"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    helper.AddTemporaryHealth(p, 4)
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