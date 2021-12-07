local helper = lootdeckHelpers

-- Doubles the effect of loot cards
local Names = {
    en_us = "Player Card",
    spa = "Carta de Jugador"
}
local Name = Names.en_us
local Tag = "playerCard"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "{{Card}} Spawns a Loot Card on pickup# All Loot Card effects are doubled, similar to {{Collectible451}} Tarot Cloth",
    spa = "{{Card}} Genera una carta de loot al tomarlo#Todos los efectos de las cartasde Lootse duplican, igual al {{Collectible451}} Tapete de Tarot"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Loot Card.", "All Loot Card effects are now doubled, similar to the effect of Tarot Cloth.")

local function ShouldRunDouble(p)
    return p:HasCollectible(Id)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = p:GetData().lootdeck
    if data[Tag] then
        if p:IsExtraAnimationFinished() then
            data[Tag] = nil
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, helper.GetWeightedLootCardId(false, p:GetCollectibleRNG(Id)), Game():GetRoom():FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
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
    Names = Names,
    Tag = Tag,
	  Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
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
