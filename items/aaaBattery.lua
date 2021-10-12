local helper = include("helper_functions")

-- Grants a temporary effect of a random battery item for the rest of the floor
local Name = "AAA Battery"
local Tag = "aaaBattery"
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
