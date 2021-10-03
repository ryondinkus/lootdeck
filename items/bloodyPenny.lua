local helper = include("helper_functions")

-- Gives a chance for killing an enemy to drop a tarotcard
local Name = "Bloody Penny"
local Tag = "bloodyPenny"
local Id = Isaac.GetItemIdByName(Name)

local function MC_ENTITY_TAKE_DMG(_, e, amount, flags, source)
    local shouldRun = false
    helper.ForEachPlayer(function()
        shouldRun = true
    end, Id)
    
    if shouldRun then
        local rng = lootdeck.rng

        local p
        if source.Entity.Type == EntityType.ENTITY_PLAYER then
            p = source.Entity:ToPlayer()
        elseif source.Entity:GetLastParent() and source.Entity:GetLastParent().Type == EntityType.ENTITY_PLAYER then
            p = source.Entity:GetLastParent():ToPlayer()
        end
        if e:IsEnemy() and amount >= e.MaxHitPoints and p then
            if helper.PercentageChance(5 * p:GetCollectibleNum(Id), 25) then
                local cardId = helper.GetWeightedLootCardId()
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, e.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
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
            MC_ENTITY_TAKE_DMG
        }
    }
}
