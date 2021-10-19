local Name = "Funny Red Chest"
local Tag = "funnyRedChest"
local Id = 8908

local function MC_PRE_PICKUP_COLLISION(_, pickup, collider)
    local p = collider:ToPlayer() or 0

    if p ~= 0 and pickup.SubType == Id then
        pickup:TryOpenChest(p)
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
            PickupVariant.PICKUP_LOCKEDCHEST
        }
    }
}
