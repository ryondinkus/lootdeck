-- Gives a chance for a coin to spawn when the player takes damage
local Name = "Swallowed Penny"
local Tag = "swallowedPenny"
local Id = Isaac.GetItemIdByName(Name)

local function MC_ENTITY_TAKE_DMG(_, e)
    local rng = lootdeck.rng
    if e:ToPlayer():HasCollectible(Id) then
        for i=1,e:ToPlayer():GetCollectibleNum(Id) do
            local effect = rng:RandomInt(2)
            if effect == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, (e.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}