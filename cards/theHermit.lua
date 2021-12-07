local helper = lootdeckHelpers

-- Spawns a 15c item from the item pool
local Names = {
    en_us = "IX. The Hermit",
    spa = "IX. El Ermitaño"
}
local Name = Names.en_us
local Tag = "theHermit"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a random 15c item from the current room pool",
    spa = "Genera un objeto con un costo de 15 monedas de la pool de la habitación actual"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a random 15c item from the current room pool.", "Holographic Effect: Spawns two 15c items.")

local function MC_USE_CARD(_, c, p, f, _, rng)
    local game = Game()
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local currentPool = itemPool:GetPoolForRoom(room:GetType(), rng:GetSeed())
    if currentPool == -1 then currentPool = 0 end
    local collectible = itemPool:GetCollectible(currentPool, false, rng:GetSeed())
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position, 0, true)
    local spawnedItem = helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, nil):ToPickup()
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    spawnedItem.AutoUpdatePrice = false
    spawnedItem.Price = 15
    spawnedItem.ShopItemId = -904
    spawnedItem:GetData()[Tag] = true
    lootdeck.sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0)
end

local function MC_POST_PICKUP_UPDATE(_, entity)
    if entity.FrameCount == 1 then
        if not entity.SpawnerType and entity.ShopItemId == -904 then
            entity.AutoUpdatePrice = false
            entity.Price = 15
        end
    end
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
            true
        },
        {
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE,
            PickupVariant.PICKUP_COLLECTIBLE
        }
    }
}
