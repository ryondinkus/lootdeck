local Name = "IX. The Hermit"
local Tag = "theHermit"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: visual audio cues
local function MC_USE_CARD(_, c, p)
    local game = Game()
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed()))
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
    local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, p):ToPickup()
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    spawnedItem.AutoUpdatePrice = true
    spawnedItem.Price = 1
    spawnedItem.ShopItemId = 1
    lootdeck.sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}