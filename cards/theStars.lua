-- Grants an item from the item pool or (1% chance) possibly the planitarium pool
local Name = "XVII. The Stars"
local Tag = "theStars"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Instantly grants an item from the {{TreasureRoom}} Treasure Room pool# 1% chance to grant a Planetarium item instead"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
                            {str = "Instantly grants an item from the Treasure Room pool."},
                            {str = "- 1% chance to instead grant a Planetarium item."},
						}}

local function MC_USE_CARD(_, c, p)
    local game = Game()
    local rng = lootdeck.rng
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
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, p:GetActiveItem(), room:FindFreePickupSpawnPosition(p.Position), Vector(0,0), p)
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
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
