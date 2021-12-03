local helper = lootdeckHelpers

local Name = "Lost Soul Love"
local Tag = "lostSoulLove"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_UPDATE(_, f)
    local data = f:GetData()
    local sprite = f:GetSprite()
    local room = Game():GetRoom()
    local rng = lootdeck.rng
    local sfx = lootdeck.sfx
    local lostSoulLove = nil
    if not data.state then
        sprite:Play("FloatLove", true)
        sfx:Play(SoundEffect.SOUND_FLOATY_BABY_ROAR, 1, 0, false, 2)
        data.state = "STATE_IDLE"
    end
    helper.ForEachEntityInRoom(function(entity)
        lostSoulLove = entity.Position
        data.inLove = true
    end, EntityType.ENTITY_FAMILIAR, 1296)
    if data.state == "STATE_IDLE" then
        data.targetPos = lostSoulLove
        if data.targetPos then
            if math.abs(f.Position.X - data.targetPos.X) < 20
            and math.abs(f.Position.Y - data.targetPos.Y) < 20 then
                sprite:Play("FlyLove", true)
                f.Velocity = Vector.Zero
                data.state = "STATE_ASCEND"
            end
        end
    end
    if data.state == "STATE_ASCEND" then
        if data.targetPos then
            if sprite:IsFinished("FlyLove") then
                f:Remove()
            end
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
		{
            ModCallbacks.MC_FAMILIAR_UPDATE,
            MC_FAMILIAR_UPDATE,
            Id
        }
    }
}
