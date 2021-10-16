local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- All penny spawns are either double pennies or nothing
local Name = "Poker Chip"
local Tag = "pokerChip"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_PICKUP_INIT(_, pickup)
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

                Isaac.Spawn(EntityType.ENTITY_PICKUP, newVariant, newSubType, pickup.Position, pickup.Velocity, pickup)
                pickup:Remove()
            else
                pickup:Remove()
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
            ModCallbacks.MC_POST_PICKUP_INIT,
            MC_POST_PICKUP_INIT
        }
    }
}
