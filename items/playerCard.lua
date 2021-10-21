local helper = include("helper_functions")

-- Doubles the effect of loot cards
local Name = "Player Card"
local Tag = "playerCard"
local Id = Isaac.GetItemIdByName(Name)

local function ShouldRunDouble(p)
    return p:HasCollectible(Id)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = p:GetData()
    if data[Tag] then
        if p:IsExtraAnimationFinished() then
            data[Tag] = nil
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, helper.GetWeightedLootCardId(), Game():GetRoom():FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
        end
    else
        local targetItem = p.QueuedItem.Item
        if (not targetItem) or targetItem.ID ~= Id then
            return
        end
        data[Tag] = true
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        }
    },
    helpers = {
        ShouldRunDouble = ShouldRunDouble
    }
}
