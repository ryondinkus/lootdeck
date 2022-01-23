local helper = LootDeckAPI
local items = include("items/registry")

-- Gives the Cancer item
local Names = {
    en_us = "Cancer!",
    spa = "¡Cancer!"
}
local Name = Names.en_us
local Tag = "cancer"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use#{{ArrowUp}} Passive: Massive firerate increase when entering a room with enemies#{{ArrowDown}} The firerate increase quickly diminishes over time",
    spa = "Añade un efecto pasivo tras usarla#Efecto pasivo: {{ArrowUp}} Aumento masivo en potencia de fuego al entrar en una habitación con enemigos#El efecto disminuye rápidamente"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use#{{ArrowUp}} Passive: Massive firerate increase when entering a room with enemies#{{ArrowDown}} The firerate increase quickly diminishes over time",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} efecto pasivo tras usarla#Efecto pasivo: {{ArrowUp}} Aumento masivo en potencia de fuego al entrar en una habitación con enemigos#El efecto disminuye rápidamente"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: In a room with active enemies, your firerate massively increases, then decreases over time.", "- This effect occurs when enemies spawn after entering a room, such as when a spider spawns from a pot.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.cancer.Id, SoundEffect.SOUND_VAMP_GULP)
    items.cancer.helpers.Initialize(p)
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
            Id,
            true
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
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 3
                    }
                }
            },
            {
                name = Tag.."NewRoom",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "ZH0R FKBE"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "SHOOT_RIGHT",
                        seconds = 3
                    }
                }
            },
            {
                name = Tag.."Stacking",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "ZH0R FKBE"
                    },
                    {
                        action = "REPEAT",
                        times = 2,
                        steps = {
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            },
                        }
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "SHOOT_RIGHT",
                        seconds = 3
                    }
                }
            },
            {
                name = Tag.."BossRush",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "goto s.bossrush"
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "debug 10"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_VOID
                    },
                    {
                        action = "SHOOT_DOWN",
                        seconds = 5
                    },
                }
            },
            {
                name = Tag.."ChallengeRoom",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "goto s.challenge.17"
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "debug 10"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_VOID
                    },
                    {
                        action = "SHOOT_DOWN",
                        seconds = 5
                    },
                }
            },
            {
                name = Tag.."WallHuggers",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "8QLT YXGN"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_MERCURIUS
                    },
                    {
                        action = "MOVE_DOWN",
                        seconds = 2
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_DOWN",
                        seconds = 1
                    },
                }
            },
            {
                name = Tag.."LevelTwoSpiders",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "debug 3"
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
                        seconds = 0.5
                    },
                    {
                        action = "REPEAT",
                        times = 10,
                        steps = {
                            {
                                action = "SPAWN",
                                type = EntityType.ENTITY_SPIDER_L2
                            }
                        }
                    },
                    {
                        action = "SHOOT_DOWN",
                        seconds = 10
                    },
                }
            },
            {
                name = Tag.."BlueCap",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "debug 3"
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_BLUE_CAP
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 4
                    },
                    {
                        action = "REPEAT",
                        times = 2,
                        steps = {
                            {
                                action = "GIVE_ITEM",
                                id = CollectibleType.COLLECTIBLE_BLUE_CAP
                            }
                        }
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 4
                    }
                }
            },
            {
                name = Tag.."SoyMilk",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "debug 3"
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_SOY_MILK
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 4
                    }
                }
            }
        }
    end
}
