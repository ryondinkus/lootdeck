local helper = include("helper_functions")

local Name = "Lost Soul Baby"
local Tag = "lostSoulDefault"
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
    if not data.state then
        sprite:Play("Float", true)
        data.state = "STATE_IDLE"
    end
    if data.state == "STATE_IDLE" then
        f:FollowParent()
        data.targetPos = helper.CheckForSecretRooms(room) or helper.CheckForTintedRocks(room)
        if data.targetPos then
            data.state = "STATE_ACTIVE"
        end
    end
    if data.state == "STATE_ACTIVE" then
        data.targetPos = helper.CheckForSecretRooms(room) or helper.CheckForTintedRocks(room)
        if data.targetPos then
            f:RemoveFromFollowers()
            local dir = (data.targetPos - f.Position):Normalized()
            f.Velocity = dir * 3
            if math.abs(f.Position.X - data.targetPos.X) < 4
            and math.abs(f.Position.Y - data.targetPos.Y) < 4 then
                sprite:Play("Explode", true)
                f.Velocity = Vector.Zero
                data.state = "STATE_EXPLODE"
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
    if data.state == "STATE_DEAD" then
        local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 3, f.Position, Vector.Zero, f)
        poof.Color = Color(1,1,1,1,1,1,1)
        sfx:Play(SoundEffect.SOUND_DEMON_HIT, 1, 0)
        f:Kill()
    end
end

local function MC_POST_NEW_ROOM()
    for _, entity in pairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_FAMILIAR
        and entity.Variant == Id then
            local data = entity:GetData()
            local sprite = entity:GetSprite()
            data.state = "STATE_IDLE"
            sprite:Play("Float", true)
            data.target = nil
        end
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
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
