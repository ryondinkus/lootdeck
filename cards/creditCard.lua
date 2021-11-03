local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- Adds a familiar, the familiar refunds you for the next shop/devil item you buy
local Names = {
    en_us = "Credit Card",
    spa = "Tarjeta de Crédito"
}
local Name = Names.en_us
local Tag = "creditCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "After using, the next shop item or Devil Deal you purchase gets refunded via spawned Pennies or Health Up Pills",
    spa = "Al usarlo, el próximo objeto conseguido en una tienda o pacto con el Diablo será reembolsado en monedas o píldoras de MásVida"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns a Credit Card familiar. The Credit Card familiar will refund your next purchased shop item or Devil Deal.", "- Credit Card will spawn the appropriate amount of pennies on the ground. For Devil Deals, it will spawn Soul Hearts or Health Up Pills.", "- It's possible for the Health Up Pills to become Health Downs via False PHD.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()

    if not data[Tag] then
        data[Tag] = {}
    end

    table.insert(data[Tag], Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.creditCardBaby.Id, 0, p.Position, Vector.Zero, p))
end

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local p = e:ToPlayer()
    if p then
        local playerData = p:GetData()
        if playerData[Tag] and #playerData[Tag] > 0 and pi.Type == EntityType.ENTITY_PICKUP then
            if helper.CanBuyPickup(p, pi) then
                local familiar = playerData[Tag][1]:GetData()
    			familiar.toSpawn = helper.CalculateRefund(pi.Price)
    			familiar.state = "STATE_SPAWN"
                table.remove(playerData[Tag], 1)
            end
        end
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
		}
    }
}
