local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- Explodes a random enemy or (if there are no enemies in the room) explodes the player
local Name = "Credit Card"
local Tag = "creditCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    data.credit = true
end

local function MC_PRE_PLAYER_COLLISION(_, p, e)
    local data = p:GetData()
    if data.credit and e.Type == EntityType.ENTITY_PICKUP then
        pickup = e:ToPickup()
        if helper.CanBuyPickup(p, pickup) then
            data.refund = pickup.Price
			for i=1,data.refund do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, p.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), p)
            end
            data.credit = nil
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_PRE_PLAYER_COLLISION,
            MC_PRE_PLAYER_COLLISION,
		}
    }
}
