local helper = include('helper_functions')

-- trinket; Swap the pools of Red Chests and Gold Chests
local Name = "The Left Hand"
local Tag = "leftHand"
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
