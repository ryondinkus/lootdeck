local helper = include('helper_functions')

-- Farts
local Name = "Butter Bean!"
local Tag = "butterBean"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 4

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_BUTTER_BEAN)
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
