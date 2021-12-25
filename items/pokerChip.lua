local helper = lootdeckHelpers
local entityVariants = include("entityVariants/registry")

-- All penny spawns are either double pennies or nothing
local Names = {
    en_us = "Poker Chip",
    spa = "Ficha de Póker"
}
local Name = Names.en_us
local Tag = "pokerChip"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "All coin spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all",
    spa = "Todas las monedas tienen un 50/50 de posibilidad de generarse como monedas dobles o no generarse en sí"
}
local WikiDescription = helper.GenerateEncyclopediaPage("All coins spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all.", "- Double coins still retain their respective values. (Double Nickels, Double Dimes, etc.)")

local function MC_POST_PICKUP_UPDATE(_, pickup)
	if pickup.FrameCount == 1 or (pickup:GetSprite():IsPlaying("Appear") and pickup:GetSprite():GetFrame() == 1) then
		local data = pickup:GetData()
	    local hasItem = false

	    helper.ForEachPlayer(function()
	        hasItem = true
	    end, Id)

	    if pickup:GetSprite():IsPlaying("Appear") and hasItem and pickup.SpawnerVariant ~= entityVariants.doubleStickyNickel.Id then
			if (pickup.Variant == PickupVariant.PICKUP_COIN or pickup.Variant == entityVariants.chargedPenny.Id)
	        and pickup.SubType ~= CoinSubType.COIN_DOUBLEPACK
	        and pickup.Variant ~= entityVariants.doubleNickel.Id
	        and pickup.Variant ~= entityVariants.doubleDime.Id
	        and pickup.Variant ~= entityVariants.doubleLuckyPenny.Id
	        and pickup.Variant ~= entityVariants.doubleStickyNickel.Id
	        and pickup.Variant ~= entityVariants.doubleGoldenPenny.Id
	        and pickup.Variant ~= entityVariants.doubleChargedPenny.Id then
	            if helper.PercentageChance(50) then
	                local newVariant = PickupVariant.PICKUP_COIN
	                local newSubType = 0
	                if pickup.SubType == CoinSubType.COIN_PENNY then
	                    newSubType = CoinSubType.COIN_DOUBLEPACK
	                elseif pickup.SubType == CoinSubType.COIN_NICKEL then
	                    newVariant = entityVariants.doubleNickel.Id
	                elseif pickup.SubType == CoinSubType.COIN_DIME then
	                    newVariant = entityVariants.doubleDime.Id
	                elseif pickup.SubType == CoinSubType.COIN_LUCKYPENNY then
	                   newVariant = entityVariants.doubleLuckyPenny.Id
	                elseif pickup.SubType == CoinSubType.COIN_STICKYNICKEL then
	                    newVariant = entityVariants.doubleStickyNickel.Id
	                elseif pickup.SubType == CoinSubType.COIN_GOLDEN then
	                    newVariant = entityVariants.doubleGoldenPenny.Id
	                elseif pickup.SubType == CoinSubType.COIN_GOLDEN then
	                    newVariant = entityVariants.doubleGoldenPenny.Id
	                elseif pickup.Variant == entityVariants.chargedPenny.Id then
	                    newVariant = entityVariants.doubleChargedPenny.Id
	                end

					if data[lootdeckChallenges.gimmeTheLoot.Tag] then
						helper.Spawn(EntityType.ENTITY_PICKUP, newVariant, newSubType, pickup.Position, pickup.Velocity, pickup)
						pickup:Remove()
					elseif Isaac.GetChallenge() ~= lootdeckChallenges.gimmeTheLoot.Id then
	                	Isaac.Spawn(EntityType.ENTITY_PICKUP, newVariant, newSubType, pickup.Position, pickup.Velocity, pickup)
						pickup:Remove()
					end
	            else
	                pickup:Remove()
					local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, pickup.Position, pickup.Velocity, pickup)
					effect:GetSprite().Scale = Vector(0.75,0.75)
			    end
	        end
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
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE
        }
    }
}
