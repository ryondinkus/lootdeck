local helper = LootDeckAPI

local Name = "Double Sticky Nickel"
local Tag = "doubleStickyNickel"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_POST_PICKUP_UPDATE(_, pi)
    pi:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)

    local data = pi:GetData()
    local sprite = pi:GetSprite()

    if not data.isColliding then
        data.isColliding = 0
    end

    if sprite:IsEventTriggered("DropSound") then
        lootdeck.sfx:Play(SoundEffect.SOUND_NICKELDROP)
    end
    if not sprite:IsPlaying("Touched") and not sprite:IsFinished("Touched") and sprite:IsEventTriggered("DropSound") then
        data.shouldShake = true
    end

    if sprite:IsFinished("Touched") then
        sprite:Play("Idle", true)
    end

    if data.isColliding ~= 0 and data.isColliding == data.prevIsColliding then
        data.isColliding = 0
        data.prevIsColliding = nil
        data.shouldShake = true
        pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    else
        data.prevIsColliding = data.isColliding
    end

    local maxRadius = pi.Size * 6
    for _, nearEntity in pairs(Isaac.FindInRadius(pi.Position, maxRadius)) do
        if nearEntity.Type == EntityType.ENTITY_BOMBDROP then
            if nearEntity:GetSprite():IsPlaying("Explode") then
                local directionVector = Vector(pi.Position.X - nearEntity.Position.X, pi.Position.Y - nearEntity.Position.Y)
                local maxVector = Vector(maxRadius * helper.Sign(directionVector.X), maxRadius * helper.Sign(directionVector.Y))
                directionVector = (maxVector - directionVector) * 0.27
                local directionVariant = lootdeck.rng:RandomInt(20) + 10
                if lootdeck.rng:RandomFloat() < 0.5 then
                    directionVariant = -directionVariant
                end

                if helper.Sign(directionVector.X) ~= helper.Sign(maxVector.X) then
                    directionVector = Vector(-directionVector.X, directionVector.Y)
                end

                if helper.Sign(directionVector.Y) ~= helper.Sign(maxVector.Y) then
                    directionVector = Vector(directionVector.X, -directionVector.Y)
                end

                local firstNickel = helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, pi.Position, directionVector, pi)
                firstNickel:GetSprite():Play("Idle", true)
                firstNickel.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                local secondNickel = helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, pi.Position, directionVector:Rotated(directionVariant), pi)
                secondNickel:GetSprite():Play("Idle", true)
                secondNickel.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYERONLY
                pi:Remove()
            end
        end
    end

end

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local p = e:ToPlayer() or 0
    if p ~= 0 then
        local data = pi:GetData()
        data.isColliding = data.isColliding + 1
        if data.shouldShake then
            local sprite = pi:GetSprite()
            lootdeck.sfx:Play(SoundEffect.SOUND_NICKELDROP)
            pi.Velocity = Vector.Zero
            pi.Touched = true
            sprite:Play("Touched", true)
            data.shouldShake = false
        else
            return true
        end
    end
end

local function MC_POST_PICKUP_INIT(_, pi)
    local data = pi:GetData()
    local sprite = pi:GetSprite()
    if not sprite:IsPlaying("Touched") and not sprite:IsFinished("Touched") then
        data.shouldShake = true
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Callbacks = {
        {
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE,
            Id
        },
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
            Id
        },
        {
            ModCallbacks.MC_POST_PICKUP_INIT,
            MC_POST_PICKUP_INIT,
            Id
        }
    }
}
