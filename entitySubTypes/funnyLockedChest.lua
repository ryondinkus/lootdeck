local Name = "Funny Locked Chest"
local Tag = "funnyLockedChest"
local Id = 9356

local function MC_PRE_PICKUP_COLLISION(_, pickup, collider)
    local p = collider:ToPlayer() or 0

    if p ~= 0 and pickup.SubType == Id then
        if p:HasTrinket(TrinketType.TRINKET_PAPER_CLIP) or p:HasGoldenKey() then
            pickup:TryOpenChest(p)
        elseif p:GetNumKeys() > 0 then
            pickup:TryOpenChest(p)
            p:AddKeys(-1)
        else
            return false
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Callbacks = {
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
            PickupVariant.PICKUP_REDCHEST
        }
    }
}
