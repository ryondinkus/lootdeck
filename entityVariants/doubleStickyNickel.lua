local helper = include("helper_functions")

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
    if not sprite:IsPlaying("Touched") and not sprite:IsFinished("Touched") and sprite:IsEventTriggered("DropSound")then
        data.shouldShake = true
    end

    if data.isColliding ~= 0 and data.isColliding == data.prevIsColliding then -- Able to shake
        data.isColliding = 0
        data.prevIsColliding = nil
        data.shouldShake = true
        pi.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    else -- Update and continue on without enabling shaking
        data.prevIsColliding = data.isColliding
    end
end

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    print("collided with ?????")
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
    local b = e:ToBomb() or 0
    if b ~= 0 then
        print("why dot dot its a bomb")
        local sprite = b:GetSprite()
        if sprite:IsPlaying("Explode") then
            print("its EXPLODING!! (this shouldnt run)")
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, pi.Position, Vector.Zero, pi.Parent)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, pi.Position, Vector.Zero, pi.Parent)
            pi:Remove()
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

-- local function MC_ENTITY_TAKE_DMG(_, pi, _, flags)
--     print("uouwch")
--     if pi.Variant == Id then
--         if flags & DamageFlag.DAMAGE_EXPLOSION == 0 then
--             Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, pi.Position, Vector.Zero, pi.Parent)
--             Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, pi.Position, Vector.Zero, pi.Parent)
--             pi:Remove()
--         end
--     end
-- end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
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
        -- {
        --     ModCallbacks.MC_ENTITY_TAKE_DMG,
        --     MC_ENTITY_TAKE_DMG,
        --     EntityType.ENTITY_PICKUP
        -- },
    }
}
