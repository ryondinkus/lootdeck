local helper = LootDeckAPI

-- Allows player to phase through enemies and projectiles for 5 seconds
local Names = {
    en_us = "Get out of Jail Card",
    spa = "Carta Sal de la Cárcel"
}
local Name = Names.en_us
local Tag = "getOutOfJail"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants the player invincibility and the ability to phase through enemies for 5 seconds",
    spa = "El jugador se vuelve invencible y puede traspasar a los enemigos por 5 segundos"
}
local HolographicDescriptions = {
    en_us = "Grants the player invincibility and the ability to phase through enemies for {{ColorRainbow}}10{{CR}} seconds",
    spa = "El jugador se vuelve invencible y puede traspasar a los enemigos por {{ColorRainbow}}10{{CR}} segundos"
}
local WikiDescription = helper.GenerateEncyclopediaPage("For 5 seconds, the player is invincibile and can phase through enemies.", "Holographic Effect: The effect lasts for 10 seconds.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
    local data = helper.GetLootDeckData(p)
    data[Tag] = 5 * 60
    if shouldDouble then
        data[Tag] = data[Tag] * 2
    end
    data[Tag .. "Color"] = p.Color
    p.Color = Color(p.Color.R,p.Color.G,p.Color.B,0.5,p.Color.RO,p.Color.GO,p.Color.BO)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
    poof.Color = Color(1,1,1,1,1,1,1)
    lootdeck.sfx:Play(SoundEffect.SOUND_MIRROR_ENTER, 1, 0)
end

local function MC_PRE_PLAYER_COLLISION(_, p, collider)
    local data = helper.GetLootDeckData(p)
    if data[Tag] then
        if collider.Type == EntityType.ENTITY_PROJECTILE or collider:IsEnemy() then
            return true
        end
    end
end

local function MC_POST_PLAYER_UPDATE(_, p)
    local data = helper.GetLootDeckData(p)
    if data[Tag] then
        local alpha = p.Color.A
        if data[Tag] - 1 > 0 then
            data[Tag] = data[Tag] - 1
            if data[Tag] % 60 == 0 then
                alpha = 0.5
                lootdeck.sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1, 0)
            else
                alpha = 0.25
            end
        else
            data[Tag] = nil
            alpha = 1
            lootdeck.sfx:Play(SoundEffect.SOUND_MIRROR_EXIT, 1, 0)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
            poof.Color = Color(1,1,1,1,1,1,1)
        end
        p.Color = Color(p.Color.R,p.Color.G,p.Color.B,alpha,p.Color.RO,p.Color.GO,p.Color.BO)
    end
end

local function MC_ENTITY_TAKE_DMG(_, entity)
    local p = entity:ToPlayer() or 0

    if p ~= 0 and helper.GetLootDeckData(p)[Tag] then
        return false
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_PRE_PLAYER_COLLISION,
            MC_PRE_PLAYER_COLLISION
        },
        {
            ModCallbacks.MC_POST_PLAYER_UPDATE,
            MC_POST_PLAYER_UPDATE
        },
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    },
    Tests = function()
        return {
            {
                name = Tag.."Use",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "REPEAT",
                        times = 20,
                        steps = {
                            {
                                action = "SPAWN",
                                type = EntityType.ENTITY_HORF,
                                position = Isaac.GetRandomPosition
                            }
                        }
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "MOVE_RIGHT",
                        seconds = 0.7
                    },
                    {
                        action = "MOVE_UP",
                        seconds = 0.7
                    },
                    {
                        action = "MOVE_LEFT",
                        seconds = 0.7
                    },
                    {
                        action = "MOVE_DOWN",
                        seconds = 0.7
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 0.5
                    },
                    {
                        action = "GO_TO_DOOR"
                    }
                }
            }
        }
    end
}
