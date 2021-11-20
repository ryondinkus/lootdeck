local helper = include("helper_functions")

local Name = "Lost Soul Baby"
local Tag = "lostSoulBaby"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_INIT(_, f)
    f:AddToFollowers()
end

local function MC_FAMILIAR_UPDATE(_, f)
    local data = f:GetData()
    local sprite = f:GetSprite()
    local room = Game():GetRoom()
    local rng = lootdeck.rng
    local sfx = lootdeck.sfx
    local lostSoulLove = nil
    if not data.state then
        sprite:Play("Float", true)
        sfx:Play(SoundEffect.SOUND_FLOATY_BABY_ROAR, 1, 0, false, 2)
        data.state = "STATE_IDLE"
    end
    helper.ForEachEntityInRoom(function(entity)
        lostSoulLove = entity.Position
        data.inLove = true
    end, EntityType.ENTITY_FAMILIAR, 1297)
    if data.state == "STATE_IDLE" then
        f:FollowParent()
        data.targetPos = lostSoulLove or helper.CheckForSecretRooms(room) or helper.CheckForTintedRocks(room)
        if data.targetPos then
            data.state = "STATE_ACTIVE"
        end
    end
    if data.state == "STATE_ACTIVE" then
        data.targetPos = lostSoulLove or helper.CheckForSecretRooms(room) or helper.CheckForTintedRocks(room)
        if data.targetPos then
            f:RemoveFromFollowers()
            local dir = (data.targetPos - f.Position):Normalized()
            f.Velocity = dir * 3
            if math.abs(f.Position.X - data.targetPos.X) < 20
            and math.abs(f.Position.Y - data.targetPos.Y) < 20 then
                if data.inLove then
                    sprite:Play("Fly", true)
                    f.Velocity = Vector.Zero
                    data.state = "STATE_ASCEND"
                    sfx:Play(SoundEffect.SOUND_SUPERHOLY, 1, 0)
                else
                    sprite:Play("Explode", true)
                    f.Velocity = Vector.Zero
                    data.state = "STATE_EXPLODE"
                end
            end
        else
            f:AddToFollowers()
            f.Velocity = Vector.Zero
            data.state = "STATE_IDLE"
        end
    end
    if data.state == "STATE_EXPLODE" then
        if data.targetPos then
            if sprite:IsEventTriggered("Explode") then
                Isaac.Explode(f.Position, f, 40)
            end
            if sprite:IsFinished("Explode") then
                data.state = "STATE_DEAD"
            end
        end
    end
    if data.state == "STATE_ASCEND" then
        if data.targetPos then
            if sprite:IsEventTriggered("Spawn") then
                sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
                helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL, f.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), f)
            end
            if sprite:IsFinished("Fly") then
                lootdeck.f.lostSoul = false
                f:Remove()
            end
        end
    end
    if data.state == "STATE_DEAD" then
        lootdeck.f.lostSoul = false
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, f.Position, Vector.Zero, f)
        poof.Color = Color(1,1,1,1,1,1,1)
        sfx:Play(SoundEffect.SOUND_DEMON_HIT, 1, 0)
        f:Kill()
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachEntityInRoom(function(entity)
        local data = entity:GetData()
        local sprite = entity:GetSprite()
        data.state = "STATE_IDLE"
        sprite:Play("Float", true)
        data.target = nil
    end, EntityType.ENTITY_FAMILIAR, Id)
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
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
