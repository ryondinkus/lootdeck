local helper = include('helper_functions')

local Name = "Holy Shield"
local Tag = "holyShield"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_INIT(_, f)
    f:AddToOrbit(0)
    f:GetSprite():Play("Spawn", true)
end

-- Familiar update for Holy Shield card
local function MC_FAMILIAR_UPDATE(_, f)
    if f.FrameCount == 8 then
        f.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        f:GetSprite():Play("Idle", true)
    end
    f.OrbitDistance = Vector(20, 20)
    f.OrbitSpeed = -0.05
    f.Velocity = f:GetOrbitPosition(f.Player.Position + f.Player.Velocity) - f.Position
    if f:GetSprite():IsFinished("Poof") then
        f.SpriteScale = Vector.Zero
    end
end

local function MC_PRE_FAMILIAR_COLLISION(_, f, e)
    if e.Type == EntityType.ENTITY_PROJECTILE then
        e:Die()
        f.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        f:GetData().hit = true
        f:GetSprite():Play("Poof", true)
        lootdeck.sfx:Play(SoundEffect.SOUND_HOLY_MANTLE,1,0,false,1.2)
    end
end

local function MC_POST_NEW_ROOM()
    helper.RemoveHitFamiliars(Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_FAMILIAR_INIT,
            MC_FAMILIAR_INIT,
            Id
        },
        {
            ModCallbacks.MC_FAMILIAR_UPDATE,
            MC_FAMILIAR_UPDATE,
            Id
        },
        {
            ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
            MC_PRE_FAMILIAR_COLLISION,
            Id
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}