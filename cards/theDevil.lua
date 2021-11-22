local helper = include("helper_functions")

-- Spawns a devil deal item
local Names = {
    en_us = "XV. The Devil",
    spa = "XV. El Diablo"
}
local Name = Names.en_us
local Tag = "theDevil"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a random 1 Heart Devil Deal from the current room pool",
    spa = "Genera un Trato con el Diablo de 1 corazón de la pool de la habitación actual"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a random 1 Heart Devil Deal from the current room pool.", "Holographic Effect: Spawns two Devil Deals.")

local function MC_USE_CARD(_, c, p)
    local game = Game()
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed()))
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position, 0, true)
    local spawnedItem = helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, nil):ToPickup()
    spawnedItem.AutoUpdatePrice = false
    if helper.IsSoulHeartFarty(p) then
        spawnedItem.Price = -3
    elseif p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
        spawnedItem.Price = 15
    else
        spawnedItem.Price = -1
    end
    spawnedItem.ShopItemId = -2
    spawnedItem:GetData()[Tag] = true
    poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    poof.Color = Color(0,0,0,1,0,0,0)
    lootdeck.sfx:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0)
end

local function MC_POST_PICKUP_UPDATE(_, entity)
    if entity.FrameCount == 1 then
        if not entity.SpawnerType and entity.ShopItemId == -2 then
            entity.AutoUpdatePrice = false
            if helper.IsSoulHeartFarty(entity.SpawnerEntity:ToPlayer()) then
                entity.Price = -3
            elseif entity.SpawnerEntity:ToPlayer():GetPlayerType() == PlayerType.PLAYER_KEEPER or entity.SpawnerEntity:ToPlayer():GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                entity.Price = 15
            else
                entity.Price = -1
            end
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
