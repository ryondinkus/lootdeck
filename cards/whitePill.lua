local helper = LootDeckAPI

-- Poison fart | weaken all enemies (they take 2x damage) | do nothing
local Names = {
    en_us = "Pills! White",
    spa = "¡Píldora! Blanca"
}
local Name = Names.en_us
local Tag = "whitePill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:# Create a poison fart, similar to {{Collectible111}} The Bean# Weakens and slows all enemies in the room, similar to {{Card67}} XI - Strength?# Does nothing",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Sueltas un pedo venenoso, igual a  {{Collectible111}} El Frijol#Debilitas a todos los enemigos en la habitación, igual que {{Card67}} XI - ¿Fuerza?#No hace nada"
}
local HolographicDescriptions = {
    en_us = "Random chance for any of these effects:# Create {{ColorRainbow}}2{{CR}} poison farts, similar to {{Collectible111}} The Bean# Weakens and slows all enemies in the room, similar to {{Card67}} XI - Strength?# Does nothing",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Sueltas {{ColorRainbow}}2{{CR}} pedos venenosos, igual a  {{Collectible111}} El Frijol#Debilitas a todos los enemigos en la habitación, igual que {{Card67}} XI - ¿Fuerza?#No hace nada"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Creates a poison fart, like The Bean effect.", "- Weakens and slows all enemies in the room, similar to XI - Strength?.", "- Does nothing.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
    local sfx = lootdeck.sfx

    helper.RunRandomFunction(lootdeck.debug[Tag] or rng, shouldDouble,
    function()
        helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_BEAN)
    end,
    function()
        local useFlags = UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOCOSTUME
        p:UseCard(Card.CARD_REVERSE_STRENGTH, useFlags)
        local fart = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0, p.Position, Vector.Zero, p)
        fart.Color = Color(1,0,1,1,0,0,0)
        sfx:Play(SoundEffect.SOUND_FART,1,0)
        sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)
    end,
    function()
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_PLOP,1,0)
    end)
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
        }
    },
	Tests = function()
        return {
            {
                name = Tag.."PoisonFart",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, 1),
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."Weakens",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, 2),
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."Nothing",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, 3),
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."Use",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 8
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_BLANK_CARD
                    },
                    {
                        action = "REPEAT",
                        times = 10,
                        steps = {
                            {
                                action = "USE_ITEM"
                            }
                        }
                    }
                }
            },
            {
                name = Tag.."Rng",
                steps = {
                    {
                        action = "REPEAT",
                        times = 3,
                        steps = {
                            {
                                action = "RESTART",
                                id = 0
                            },
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 1
                            },
                            {
                                action = "USE_CARD"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 1
                            },
                            {
                                action = "USE_ITEM",
                                id = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 1
                            },
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            }
                        }
                    }
                }
            }
        }
    end
}
