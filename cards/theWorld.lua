local helper = include("helper_functions")

-- Freezes the room for 10 seconds
local Names = {
    en_us = "XXI. The World",
    spa = "XXI. El Mundo"
}
local Name = Names.en_us
local Tag = "theWorld"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Pauses all enemies and projectiles in the room# Effect wears off after 10 seconds# Stops the game clock for the duration of the effect",
    spa = "Detiene a todos los enemigos y proyectiles en la sala#Dura 10 segundos#El reloj del juego se detiene al activar el efecto"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Pauses all enemies and projectiles in the room.", "- The effect lasts for 10 seconds.", "- The in-game clock does not increment for the duration of the effect.", "Holographic Effect: The effect lasts for 20 seconds.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local game = Game()
    lootdeck.f.world = 300
    if shouldDouble then
        lootdeck.f.world = lootdeck.f.world * 2
    end
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
        if lootdeck.f.world > 1 then
            Game().TimeCounter = lootdeck.f.savedTime
            lootdeck.f.world = lootdeck.f.world - 1
            helper.ForEachEntityInRoom(function(entity) entity:AddEntityFlags(EntityFlag.FLAG_FREEZE) end, nil, nil, nil, function(entity)
                return entity:IsEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE)
            end)
        elseif lootdeck.f.world <= 1 then
            helper.ForEachEntityInRoom(function(entity) entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE) end, nil, nil, nil, function(entity)
                return entity:IsEnemy() and entity:HasEntityFlags(EntityFlag.FLAG_FREEZE)
            end)
            mus:Enable()
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
            lootdeck.f.world = nil
        end
    end
end

local function MC_POST_PROJECTILE_UPDATE(_, p)
    local data = p:GetData().lootdeck
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

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
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
        }
    }
}
