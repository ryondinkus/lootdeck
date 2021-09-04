local helper = include("helper_functions")

local Name = "VI. The Lovers"
local Tag = "theLovers"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    helper.AddTemporaryHealth(p, 4)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}