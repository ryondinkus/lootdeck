local helper = include("helper_functions")

local Name = "Justice Haunt"
local Tag = "justiceHaunt"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_INIT(_, f)
    f:AddToFollowers()
    lootdeck.sfx:Play(SoundEffect.SOUND_THE_FORSAKEN_LAUGH, 1, 0)
end

-- Familiar update for Justice card
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
        if helper.AreEnemiesInRoom(room) then
            data.state = "STATE_ACTIVE"
            sprite:Play("FloatChase", true)
        end
    end
    if data.state == "STATE_ACTIVE" then
        if data.target then
            f:RemoveFromFollowers()
            local dir = (data.target.Position - f.Position):Normalized()
            f.Velocity = dir * 6
            if math.abs(f.Position.X - data.target.Position.X) < 4
            and math.abs(f.Position.Y - data.target.Position.Y) < 4 then
                sprite:Play("FloatAttack", true)
                f.Velocity = Vector.Zero
                data.spawnCountdown = 0
                data.spawnAmount = 4
                data.state = "STATE_ATTACK"
            end
        else
            data.target = helper.FindRandomEnemy(f.Position)
        end
        if not helper.AreEnemiesInRoom(room) then
            data.state = "STATE_DEAD"
        end
    end
    if data.state == "STATE_ATTACK" then
        if data.target:IsDead() or not data.target then
            data.state = "STATE_DEAD"
            sprite:Play("Death", true)
        else
            f.Position = data.target.Position
            if data.target:IsBoss() then
                data.target:AddConfusion(EntityRef(f), 150, false)
            else
                data.target:AddConfusion(EntityRef(f), 1, false)
            end
            data.spawnCountdown = data.spawnCountdown - 1
            if data.spawnCountdown <= 0 then
                if data.spawnAmount < 1 then
                    data.state = "STATE_DEAD"
                    return
                end
                local chosenVariant = (rng:RandomInt(4) + 1) * 10
                Isaac.Spawn(EntityType.ENTITY_PICKUP, chosenVariant, 0, data.target.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), f)
                data.spawnAmount = data.spawnAmount - 1
                data.spawnCountdown = 30
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
        }
    }
}
