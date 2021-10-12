local helper = include("helper_functions")

-- 50% chance each room to grant a temporary copy of a random passive you already have
local Name = "Rainbow Tapeworm"
local Tag = "rainbowTapeworm"
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
