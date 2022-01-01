local helper = LootDeckHelpers

local Name = "Double Golden Penny"
local Tag = "doubleGoldenPenny"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    helper.CustomCoinPrePickupCollision(pi, e, 2, SoundEffect.SOUND_PENNYPICKUP, function()
        if helper.PercentageChance(90) then
            local room = Game():GetRoom()
            local spawnPoint = room:FindFreePickupSpawnPosition(room:GetRandomPosition(0), 0, true)
            local goldenPenny = helper.Spawn(EntityType.ENTITY_PICKUP, Id, 0, spawnPoint, Vector.Zero, pi.Parent)
            goldenPenny:GetSprite():Play("Reappear")
        end
    end)
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    helper.CustomCoinPickupUpdate(pi, SoundEffect.SOUND_DIMEDROP)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Callbacks = {
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
            Id
        },
        {
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE,
            Id
        }
    }
}
