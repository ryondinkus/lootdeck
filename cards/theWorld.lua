local helper = include("helper_functions")

-- Freezes the room for 10 seconds
local Name = "XXI. The World"
local Tag = "theWorld"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Pauses all enemies and projectiles in the room# Effect wears off after 10 seconds, or when you exit the room# Stops the game clock for the duration of the effect"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
                            {str = "Pauses all enemies and projectiles in the room."},
                            {str = "- The effect lasts for 10 seconds, or until you exit the room."},
                            {str = "- The in-game clock does not increment for the duration of the effect."}
						}}

local function MC_USE_CARD(_, c, p)
    local game = Game()
    lootdeck.f.world = 300
    lootdeck.f.savedTime = game.TimeCounter
    game:AddPixelation(15)
    lootdeck.mus:Disable()
    lootdeck.sfx:Play(SoundEffect.SOUND_DOGMA_BRIMSTONE_SHOOT, 1, 0)
end

local function MC_POST_UPDATE()
    local sfx = lootdeck.sfx
    local mus = lootdeck.mus
    if lootdeck.f.world then
        if lootdeck.f.world % 30 == 0 then
            sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0)
        end
        if lootdeck.f.world == 300 then
            helper.ForEachEntityInRoom(function(entity) entity:AddEntityFlags(EntityFlag.FLAG_FREEZE) end, nil, nil, nil, function(entity)
                return entity:IsEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE)
            end)
        end
        if lootdeck.f.world >= 1 then
            Game().TimeCounter = lootdeck.f.savedTime
            lootdeck.f.world = lootdeck.f.world - 1
        end
        if lootdeck.f.world == 1 then
            helper.ForEachEntityInRoom(function(entity) entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE) end, nil, nil, nil, function(entity)
                return entity:IsEnemy() and entity:HasEntityFlags(EntityFlag.FLAG_FREEZE)
            end)
            mus:Enable()
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
        lootdeck.mus:Enable()
        lootdeck.sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
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
