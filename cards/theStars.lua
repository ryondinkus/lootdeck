local helper = lootdeckHelpers

-- Grants an item from the item pool or (1% chance) possibly the planitarium pool
local Names = {
    en_us = "XVII. The Stars",
    spa = "XVII. Las Estrellas"
}
local Name = Names.en_us
local Tag = "theStars"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Instantly grants an item from the {{TreasureRoom}} Treasure Room pool# 1% chance to grant a Planetarium item instead",
    spa = "Te regala instantaneamente un objeto de la {{TreasureRoom}} Sala del tesoro#1% de posibilidad de que sea un objeto del Planetario"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Instantly grants an item from the Treasure Room pool.", "- 1% chance to instead grant a Planetarium item.", "Holographic Effect: Grants a treasure item, then another.")

local function MC_USE_CARD(_, c, p, f, _, rng)
    local game = Game()
    local room = game:GetRoom()
    local itemPool = game:GetItemPool()
    local effect = rng:RandomInt(99)
    local roomType = RoomType.ROOM_TREASURE
    if effect == 0 then
        roomType = RoomType.ROOM_PLANETARIUM
    end
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(roomType, rng:GetSeed()))
    local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
    if itemConfig.Type == ItemType.ITEM_ACTIVE then
        if p:GetActiveItem() ~= 0 then
            helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, p:GetActiveItem(), room:FindFreePickupSpawnPosition(p.Position), Vector(0,0), p)
            p:RemoveCollectible(p:GetActiveItem(), false, ActiveSlot.SLOT_PRIMARY)
        end
    end
    local hud = game:GetHUD()
    hud:ShowItemText(p, itemConfig)
    p:AnimateCollectible(collectible)
    lootdeck.sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0)
    p:AddCollectible(collectible)

    return false
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
            Id,
            true,
            1
        }
    }
}
