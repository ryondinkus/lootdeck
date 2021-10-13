local helper = include('helper_functions')

-- Allows player to phase through enemies and projectiles for 5 seconds
local Name = "Get out of Jail Card"
local Tag = "getOutOfJail"
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
