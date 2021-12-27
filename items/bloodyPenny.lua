local helper = LootDeckHelpers

-- Gives a chance for killing an enemy to drop a tarotcard
local Names = {
    en_us = "Bloody Penny",
    spa = "Moneda Sangrienta"
}
local Name = Names.en_us
local Tag = "bloodyPenny"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "5% chance to drop a Loot Card on enemy death",
    spa = "Matar a un enemigo otorga un 5% de posibilidad de que suelte una carta de loot"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Enemies have a 5% chance to drop a Loot Card on death.", "- Effect stacks +5% for every instance of the passive and caps at 25%.")

local function MC_ENTITY_TAKE_DMG(_, e, amount, flags, source)
    local shouldRun = false
    helper.ForEachPlayer(function()
        shouldRun = true
    end, Id)

    if shouldRun then
        local p
        if source and source.Entity then
            if source.Entity.Type == EntityType.ENTITY_PLAYER then
                p = source.Entity:ToPlayer()
            elseif source.Entity:GetLastParent() and source.Entity:GetLastParent().Type == EntityType.ENTITY_PLAYER then
                p = source.Entity:GetLastParent():ToPlayer()
            end
        end
        if e.Type ~= EntityType.ENTITY_FIREPLACE and e:IsVulnerableEnemy() and amount >= e.MaxHitPoints and p then
            local rng = p:GetCollectibleRNG(Id)
            if helper.PercentageChance(5 * p:GetCollectibleNum(Id), 25, rng) then
                local cardId = helper.GetWeightedLootCardId(true, rng)
                helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, e.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, e.Position, Vector.Zero, nil)
                lootdeck.sfx:Play(SoundEffect.SOUND_DEATH_BURST_LARGE, 1, 0)
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
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG
        }
    }
}
