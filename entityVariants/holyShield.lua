local Name = "Holy Shield"
local Tag = "holyShield"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_INIT(_, f)
    f:AddToOrbit(5)
    f:GetSprite():Play("Idle", true)
end

-- Familiar update for Joker card
local function MC_FAMILIAR_UPDATE(_, f)
    if f.FrameCount == 1 then
        f.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
    end
    print(f.EntityCollisionClass)
    f.OrbitDistance = Vector(50, 50)
    f.OrbitSpeed = -0.05
    f.Velocity = f:GetOrbitPosition(f.Player.Position + f.Player.Velocity) - f.Position
    if f:GetSprite():IsFinished("Poof") then
        -- TODO: remove orbitals when all others are hidden
        --f:Remove()
        f.SpriteScale = Vector.Zero
    end
end

local function MC_PRE_FAMILIAR_COLLISION(_, f, e)
    print("woah")
    if e.Type == EntityType.ENTITY_PROJECTILE then
        print("ehe")
        e:Die()
        f.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        f:GetData().hit = true
        f:GetSprite():Play("Poof", true)
        lootdeck.sfx:Play(SoundEffect.SOUND_HOLY_MANTLE,1,0,false,1.2)
    end
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
        }
    }
}
