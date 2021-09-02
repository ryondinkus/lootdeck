local helper = include('helper_functions')

local Name = "O. The Fool"
local Tag = "theFool"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_TELEPORT_2)
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