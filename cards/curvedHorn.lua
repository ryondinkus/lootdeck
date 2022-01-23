
local helper = LootDeckAPI
local items = include("items/registry")

local Names = {
    en_us = "Curved Horn",
    spa = "Cuerno Torcido"
}
local Name = Names.en_us
local Tag = "curvedHorn"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: Quadruple damage for the first tear fired in a room",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Cuadriplica el daño de la primer lágrima lanzada en una habitación"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: Quadruple damage for the first tear fired in a room",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo tras usarla#Efecto pasivo: Cuadriplica el daño de la primer lágrima lanzada en una habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: In a room with active enemies, the first tear fired has x4 damage and size.", "- This effect occurs when enemies spawn after entering a room, such as when a spider spawns from a pot.", "- Additional copies of the passive let you fire additional x4 damage tears.", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.curvedHorn.Id, SoundEffect.SOUND_VAMP_GULP)
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
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
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
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
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
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
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
        }
    end
}
