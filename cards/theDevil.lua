local helper = include("helper_functions")

-- Spawns a devil deal item
local Name = "XV. The Devil"
local Tag = "theDevil"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: visual audio cues
local function MC_USE_CARD(_, c, p)
    local game = Game()
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed()))
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position, 0, true)
    local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, nil):ToPickup()
    spawnedItem.AutoUpdatePrice = false
    if helper.IsSoulHeartMarty(p) then
        spawnedItem.Price = -3
    elseif p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
        spawnedItem.Price = 15
    else
        spawnedItem.Price = -1
    end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    lootdeck.sfx:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
