-- Gives a chance for a coin to spawn when the player takes damage
local Name = "Swallowed Penny"
local Tag = "swallowedPenny"
local Id = Isaac.GetItemIdByName(Name)

local function MC_ENTITY_TAKE_DMG(_, e)
    local rng = lootdeck.rng
    local p = e:ToPlayer()
    if p:HasCollectible(Id) then
        for i=1,p:GetCollectibleNum(Id) do
            local effect = rng:RandomInt(2)
            if effect == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
				break
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
