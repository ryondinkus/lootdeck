local helper = include('helper_functions')

-- Poison fart | weaken all enemies (they take 2x damage) | do nothing
local Name = "Pills! White"
local Tag = "whitePill"
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
