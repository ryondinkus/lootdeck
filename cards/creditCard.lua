local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- Adds a familiar, the familiar refunds you for the next shop/devil item you buy
local Name = "Credit Card"
local Tag = "creditCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()

    if not data[Tag] then
        data[Tag] = {}
    end

    table.insert(data[Tag], Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.creditCardBaby.Id, 0, p.Position, Vector.Zero, p))
end

local function MC_PRE_PLAYER_COLLISION(_, p, e)
    local data = p:GetData()
    if data[Tag] and #data[Tag] > 0 and e.Type == EntityType.ENTITY_PICKUP then
        local pickup = e:ToPickup()
        if helper.CanBuyPickup(p, pickup) then
            local familiar = data[Tag][1]:GetData()
			familiar.toSpawn = helper.CalculateRefund(pickup.Price)
			familiar.state = "STATE_SPAWN"
            table.remove(data[Tag], 1)
        end
        print(helper.FeckDechoEdmundMcmillen(p, e:ToPickup()))
    end
end

local function MC_POST_GAME_STARTED() -- cool test code
    local room = Game():GetRoom()
    for i=1,12 do
        local heart = Isaac.Spawn(5,10,i,room:FindFreePickupSpawnPosition(room:GetCenterPos()),Vector.Zero,nil):ToPickup()
        heart.Price = 5
        heart.AutoUpdatePrice = true
    end
    local battery = Isaac.Spawn(5,90,1,room:FindFreePickupSpawnPosition(room:GetCenterPos()),Vector.Zero,nil):ToPickup()
    battery.Price = 5
    battery.AutoUpdatePrice = true
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
		},
        {
            ModCallbacks.MC_POST_GAME_STARTED,
            MC_POST_GAME_STARTED
        }
    }
}
