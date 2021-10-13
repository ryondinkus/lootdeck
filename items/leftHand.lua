local helper = include("helper_functions")

-- Swap the pools of Red Chests and Gold Chests
local Name = "The Left Hand"
local Tag = "leftHand"
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
