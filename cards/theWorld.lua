-- Freezes the room for 10 seconds
local Name = "XXI. The World"
local Tag = "theWorld"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local game = Game()
    lootdeck.f.world = 300
    lootdeck.f.savedTime = game.TimeCounter
    game:AddPixelation(15)
    lootdeck.sfx:Play(SoundEffect.SOUND_DOGMA_BRIMSTONE_SHOOT, 1, 0)
end

local function MC_POST_UPDATE()
    print(lootdeck.f.world)
    local sfx = lootdeck.sfx
    if lootdeck.f.world then
        if lootdeck.f.world % 30 == 0 then
            sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0)
        end
        if lootdeck.f.world == 300 then
            local entities = Isaac.GetRoomEntities()
            for i, entity in pairs(entities) do
                if entity:IsEnemy() then
                    if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                        entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
                    end
                end
            end
        end
        if lootdeck.f.world >= 1 then
            Game().TimeCounter = lootdeck.f.savedTime
            lootdeck.f.world = lootdeck.f.world - 1
        end
        if lootdeck.f.world == 1 then
            local entities = Isaac.GetRoomEntities()
            for i, entity in pairs(entities) do
                if entity:IsEnemy() then
                    if entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                        entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
                    end
                end
            end
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
        end
        if lootdeck.f.world <= 0 then
            lootdeck.f.world = nil
        end
    end
end

local function MC_POST_PROJECTILE_UPDATE(_, p)
    local data = p:GetData()
    if lootdeck.f.world then
        if lootdeck.f.world >= 300 then
            data.Velocity = p.Velocity
            data.FallingSpeed = p.FallingSpeed
            data.FallingAccel = p.FallingAccel
            data.frozen = true
        end
        if lootdeck.f.world > 1 then
            p.Velocity = Vector(0,0)
            p.FallingSpeed = 0
            p.FallingAccel = -0.1
        end
        if lootdeck.f.world == 1 and data.frozen then
            p.Velocity = data.Velocity
            p.FallingSpeed = data.FallingSpeed
            p.FallingAccel = data.FallingAccel
            data.frozen = nil
        end
    end
end

local function MC_NPC_UPDATE(_, entity)
    local f = lootdeck.f
    if lootdeck.f.world then
        if lootdeck.f.world > 0 and entity.FrameCount == 1 then
            if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
            end
        end
    end
end

local function MC_POST_NEW_ROOM()
    if lootdeck.f.world then
        lootdeck.f.world = nil
        lootdeck.sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
        },
        {
            ModCallbacks.MC_POST_PROJECTILE_UPDATE,
            MC_POST_PROJECTILE_UPDATE
        },
        {
            ModCallbacks.MC_NPC_UPDATE,
            MC_NPC_UPDATE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
