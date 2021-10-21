local helper = include("helper_functions")

-- Gives a chance for killing an enemy to drop a tarotcard
local Name = "Bloody Penny"
local Tag = "bloodyPenny"
local Id = Isaac.GetItemIdByName(Name)
local Description = "5% chance to drop a Loot Card on enemy death"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Enemies have a 5% chance to drop a Loot Card on death."},
							{str = "- Effect stacks +5% for every instance of the passive and caps at 25%."},
						}}

local function MC_ENTITY_TAKE_DMG(_, e, amount, flags, source)
    local shouldRun = false
    helper.ForEachPlayer(function()
        shouldRun = true
    end, Id)

    if shouldRun then
        local rng = lootdeck.rng

        local p
        if source and source.Entity then
            if source.Entity.Type == EntityType.ENTITY_PLAYER then
                p = source.Entity:ToPlayer()
            elseif source.Entity:GetLastParent() and source.Entity:GetLastParent().Type == EntityType.ENTITY_PLAYER then
                p = source.Entity:GetLastParent():ToPlayer()
            end
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
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG
        }
    }
}
