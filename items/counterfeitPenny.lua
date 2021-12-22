local helper = lootdeckHelpers
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
    en_us = "Get an additional +1 Coin every time you gain Coins",
    spa = "Recibes una moneda adicional cada vez que consigues monedas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Gain an additional +1 Coin whenever you gain coins.")

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
	if e:ToPlayer() and helper.IsCoin(pi) then
		local p = e:ToPlayer()
		local chance = 0
		if helper.IsCoin(pi, true) then
			local chanceTable = {
				[2252] = 18,
				[2253] = 18,
				[2254] = 10,
				[2257] = 18,
				[9192] = 25
			}
			chance = chanceTable[pi.Variant]
		else
			local chanceTable = {
				40,
				33,
				33,
				33,
				25
			}
			chance = chanceTable[pi.SubType]
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
    callbacks = {
		{
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
        }
    }
}
