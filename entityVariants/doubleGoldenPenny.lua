local helper = include("helper_functions")

local Name = "Double Golden Penny"
local Tag = "doubleGoldenPenny"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local p = e:ToPlayer() or 0
    local playerData = p:GetData()
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if p ~= 0 then
         if data.canTake then
            p:AddCoins(2)
            lootdeck.sfx:Play(SoundEffect.SOUND_PENNYPICKUP)
            pi.Velocity = Vector.Zero
            pi.Touched = true
            pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("Collect", true)

            if helper.PercentageChance(85) then
                local room = Game():GetRoom()
                local spawnPoint = room:FindFreePickupSpawnPosition(room:GetRandomPosition(0), 0, true)
                local goldenPenny = Isaac.Spawn(EntityType.ENTITY_PICKUP, Id, 0, spawnPoint, Vector.Zero, pi.Parent)
                goldenPenny:GetSprite():Play("Reappear")
            end

            pi:Die()
        end
    end
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if sprite:IsEventTriggered("DropSound") then
        lootdeck.sfx:Play(SoundEffect.SOUND_DIMEDROP)
    end
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and (((sprite:IsPlaying("Appear") or sprite:IsPlaying("Reappear")) and sprite:IsEventTriggered("DropSound")) or sprite:IsPlaying("Idle")) and not data.canTake then
        data.canTake = true
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
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
