local Name = "Charged Penny"
local Tag = "chargedPenny"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local sfx = lootdeck.sfx
    local p = e:ToPlayer() or 0
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if p ~= 0 then
         if data.canTake then
            p:AddCoins(1)
            p:FullCharge()
            sprite:Play("Collect")
            sfx:Play(SoundEffect.SOUND_PENNYPICKUP)
            pi.Velocity = Vector.Zero
            pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        end
    end
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if sprite:IsFinished("Collect") then
        pi.SpriteScale = Vector.Zero
        pi:Remove()
    end
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and sprite:IsEventTriggered("DropSound") and not data.canTake then
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
