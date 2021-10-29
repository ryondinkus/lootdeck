local helper = include("helper_functions")

-- Spawns a 15c item from the item pool
local Name = "IX. The Hermit"
local Tag = "theHermit"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Spawns a random 15c item from the current room pool"
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a random 15c item from the current room pool.")

local function MC_USE_CARD(_, c, p)
    local game = Game()
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed()))
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position, 0, true)
    local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, p):ToPickup()
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    spawnedItem.AutoUpdatePrice = false
    spawnedItem.Price = 15
    spawnedItem.ShopItemId = -1
    spawnedItem:GetData()[Tag] = true
    lootdeck.sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0)
end

local function MC_POST_PICKUP_UPDATE(_, entity)
    if entity.FrameCount == 1 then
        if entity.SpawnerEntity and entity.SpawnerEntity.Type == EntityType.ENTITY_PLAYER and entity.ShopItemId == -1 then
            entity.AutoUpdatePrice = false
            entity.Price = 15
        end
    end
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
        },
        {
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE,
            PickupVariant.PICKUP_COLLECTIBLE
        }
    }
}
