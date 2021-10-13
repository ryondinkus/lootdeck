local helper = include('helper_functions')

-- Reroll your oldest passive | reroll all items in room | reroll all of your passives
local Name = "Pills! White Spotted"
local Tag = "whiteSpottedPill"
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
