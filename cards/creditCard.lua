local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- Explodes a random enemy or (if there are no enemies in the room) explodes the player
local Name = "Credit Card"
local Tag = "creditCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Add future stacking support
local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
	if not data.credit then
		data.familiar = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.creditCardBaby.Id, 0, p.Position, Vector.Zero, p)
	end
    data.credit = true
end

local function MC_PRE_PLAYER_COLLISION(_, p, e)
    local data = p:GetData()
    if data.credit and e.Type == EntityType.ENTITY_PICKUP then
        pickup = e:ToPickup()
        if helper.CanBuyPickup(p, pickup) then
			famData = data.familiar:GetData()
			famData.toSpawn = helper.CalculateRefund(pickup.Price)
			famData.state = "STATE_SPAWN"
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
