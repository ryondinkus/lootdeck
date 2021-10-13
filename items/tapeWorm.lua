local helper = include("helper_functions")

-- 1/10 tears replaced with Worm Tears, which have endless range and create slowing creep on collision
local Name = "Tape Worm"
local Tag = "tapeWorm"
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
