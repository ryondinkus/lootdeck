local helper = include("helper_functions")

local Name = "Double Sticky Nickel"
local Tag = "doubleStickyNickel"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local p = e:ToPlayer() or 0
    local playerData = p:GetData()
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if p ~= 0 then
        print(data.ourGuy)
         if data.canTake and data.canShake then
            lootdeck.sfx:Play(SoundEffect.SOUND_NICKELDROP)
            pi.Velocity = Vector.Zero
            pi.Touched = true
            pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
            sprite:Play("Touched", true)
            data.canShake = false
        end
        print("colliding, incrementing: " .. data.collisionTime)
        data.collisionTime = data.collisionTime + 1
    end
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if not data.collisionTime then
        data.collisionTime = 0
        data.previousCollisionTime = 0
    end
    pi:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
    if sprite:IsEventTriggered("DropSound") then
        lootdeck.sfx:Play(SoundEffect.SOUND_NICKELDROP)
    end
    if not sprite:IsPlaying("Collect") and not sprite:IsFinished("Collect") and sprite:IsEventTriggered("DropSound") and not data.canTake then
        data.canTake = true
        data.canShake = true
    end
    if Isaac.GetFrameCount() % 2 == 0 then
        print("checking if colliding: " .. data.previousCollisionTime .. " | " .. data.collisionTime)
        if data.collisionTime == data.previousCollisionTime then
            data.canShake = true
            pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
        else
            data.previousCollisionTime = 0
            data.collisionTime = 0
        end
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
