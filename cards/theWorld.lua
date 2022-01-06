local helper = LootDeckAPI

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

local SavedTimeTag = Tag.."SavedTime"

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local game = Game()
    local global = lootdeck.f
    global[Tag] = 300
    if shouldDouble then
        global[Tag] = global[Tag] * 2
    end
    global[SavedTimeTag] = game.TimeCounter
    game:AddPixelation(15)
    lootdeck.mus:Disable()
    lootdeck.sfx:Play(SoundEffect.SOUND_DOGMA_BRIMSTONE_SHOOT, 1, 0)
end

local function MC_POST_UPDATE()
    local sfx = lootdeck.sfx
    local mus = lootdeck.mus
    local global = lootdeck.f
    if global[Tag] then
        if global[Tag] % 30 == 0 then
            sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0)
        end
        if global[Tag] > 1 then
            Game().TimeCounter = global[SavedTimeTag]
            global[Tag] = global[Tag] - 1
            helper.ForEachEntityInRoom(function(entity) entity:AddEntityFlags(EntityFlag.FLAG_FREEZE) end, nil, nil, nil, function(entity)
                return entity:IsEnemy() and not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE)
            end)
        else
            helper.ForEachEntityInRoom(function(entity) entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE) end, nil, nil, nil, function(entity)
                return entity:IsEnemy() and entity:HasEntityFlags(EntityFlag.FLAG_FREEZE)
            end)
            mus:Enable()
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
            global[Tag] = nil
        end
    end
end

local function MC_POST_PROJECTILE_UPDATE(_, p)
    local data = p:GetData().lootdeck
    local global = lootdeck.f
    if global[Tag] then
        if global[Tag] >= 300 then
            data.Velocity = p.Velocity
            data.FallingSpeed = p.FallingSpeed
            data.FallingAccel = p.FallingAccel
            data.frozen = true
        end
        if global[Tag] > 1 then
            p.Velocity = Vector(0,0)
            p.FallingSpeed = 0
            p.FallingAccel = -0.1
        end
        if global[Tag] == 1 and data.frozen then
            p.Velocity = data.Velocity
            p.FallingSpeed = data.FallingSpeed
            p.FallingAccel = data.FallingAccel
            data.frozen = nil
        end
    end
end

local function MC_NPC_UPDATE(_, entity)
    local global = lootdeck.f
    if global[Tag] then
        if global[Tag] > 0 and entity.FrameCount == 1 then
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
    Callbacks = {
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
