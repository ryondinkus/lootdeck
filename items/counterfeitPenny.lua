local helper = LootDeckAPI
local entityVariants = include("entityVariants/registry")

-- Gives an extra penny for each penny picked up
local Names = {
    en_us = "Counterfeit Penny",
    spa = "Moneda Falsificada"
}
local Name = Names.en_us
local Tag = "counterfeitPenny"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "When picking up a coin of any type, there is a low chance for the coin to respawn, similar to a Golden Penny# Rarer coin types have a lower chance to respawn",
    spa = "Al tomar una moneda de cualquier tipo, hay una posibilidad de que esta moneda reaparazca, de forma similar a una moneda dorada#Mayor rareza = menor posibilidad de aparición"
}
local WikiDescription = helper.GenerateEncyclopediaPage("When picking up a coin of any type, there is a low chance for the coin to respawn, similar to a Golden Penny.", "- Penny: 40%", "- Nickel: 33%", "- Dime: 33%", "- Double Penny: 33%", "- Lucky Penny: 25%", "- Charged Penny: 25%", "- Double Coins (except Double Pennies) are half as likely to respawn as their single counterpart.", "- Additional copies increase the respawn chance by 25%, up to 90%")

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
	if e:ToPlayer() and helper.IsCoin(pi) then
		local p = e:ToPlayer()
		local chance = 0
		if helper.IsCoin(pi, true) then
			local chanceTable = {
				[2252] = 18, -- Double Nickel
				[2253] = 18, -- Double Dime
				[2254] = 10, -- Double Lucky Penny
				[2257] = 10, -- Double Charged Penny
				[9192] = 25  -- Charged Penny
			}
			chance = chanceTable[pi.Variant] or 0
		else
			local chanceTable = {
				40, -- Penny
				33, -- Nickel
				33, -- Dime
				33, -- Double Penny
				25  -- Lucky Penny
			}
			chance = chanceTable[pi.SubType] or 0
		end
	    if helper.PercentageChance(chance * p:GetCollectibleNum(Id), 90) and (pi.Price == 0 or helper.CanBuyPickup(p, pi)) then
			local room = Game():GetRoom()
	        local spawnPoint = room:FindFreePickupSpawnPosition(room:GetRandomPosition(0), 0, true)
	        local coin = helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, pi.SubType, spawnPoint, Vector.Zero, pi.Parent)
		end
	end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
		{
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
        }
    }
}
