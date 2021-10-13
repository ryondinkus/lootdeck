local helper = include("helper_functions")

-- All penny spawns are either double pennies or nothing
local Name = "Poker Chip"
local Tag = "pokerChip"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_PEFFECT_UPDATE(_, p)

end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        }
    }
}
