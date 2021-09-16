local Name = "Devil Hand"
local Tag = "Devil Hand"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_UPDATE(_, f)
    local data = f:GetData()
    local sprite = f:GetSprite()
    local room = Game():GetRoom()
    if data.target and sprite:IsPlaying("Float") then
        local dir = (data.target.Position - f.Position):Normalized()
        f.Velocity = dir * 10
        if math.abs(f.Position.X - data.target.Position.X) < 4
        and math.abs(f.Position.Y - data.target.Position.Y) < 4 then
            sprite:Play("Grab", true)
            f.Velocity = Vector.Zero
        end
    end
    if sprite:IsEventTriggered("Land") then
        data.collectibleType = data.target.SubType
        data.opi = data.target.OptionsPickupIndex
        data.target:Remove()
    end
    if sprite:IsFinished("Grab") then
        sprite:Play("FlyUp", true)
    end
    if sprite:IsFinished("FlyUp") then
        f.Position = room:FindFreePickupSpawnPosition(data.playerPos, 0, true)
        sprite:Play("FlyDown", true)
    end
    if sprite:IsFinished("FlyDown") then
        sprite:Play("Spawn", true)
    end
    if sprite:IsEventTriggered("Spawn") then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, data.collectibleType, f.Position, Vector.Zero, f)
    end
    if sprite:IsFinished("Spawn") then
        f:Remove()
    end
end

local function MC_PRE_FAMILIAR_COLLISION(_, f, collide)
    print(collide.Type)
    local data = f:GetData()
    local pi = collide:ToPickup() or 0
    if pi ~= 0 then
        if data.target.InitSeed == pi.InitSeed then
            sprite:Play("Grab", true)
            f.Velocity = Vector.Zero
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
        },
        {
            ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
            MC_PRE_FAMILIAR_COLLISION,
            Id
        }
    }
}
