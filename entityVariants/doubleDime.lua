local Name = "Double Dime"
local Tag = "doubleDime"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local p = e:ToPlayer() or 0
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if p ~= 0 then
         if data.canTake then
            p:AddCoins(20)
            lootdeck.sfx:Play(SoundEffect.SOUND_DIMEPICKUP)
            pi.Velocity = Vector.Zero
            pi.Touched = true
            pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("Collect", true)
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
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and ((sprite:IsPlaying("Appear") and sprite:IsEventTriggered("DropSound")) or sprite:IsPlaying("Idle")) and not data.canTake then
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
