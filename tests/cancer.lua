local card = lootcardKeys.cancer

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Shoot in empty room",
            "Spawn horf",
            "Shoot"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_CARD",
                id = card.Id
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
        name = card.Tag.."NewRoom",
        instructions = {
            "Use card",
            "Shoot in empty room",
            "Go to new room with enemies",
            "Shoot"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "ZH0R FKBE"
            },
            {
                action = "GIVE_CARD",
                id = card.Id
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
        name = card.Tag.."BossRush",
        instructions = {
            "Debug 10 + goto boss rush",
            "Use card",
            "Void items to trigger BR",
            "Shoot"
        },
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
                id = card.Id
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
        name = card.Tag.."ChallengeRoom",
        instructions = {
            "Debug 10 + goto boss challenge room",
            "Use card",
            "Void items to trigger BR",
            "Shoot"
        },
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
                id = card.Id
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
        name = card.Tag.."WallHuggers",
        instructions = {
            "Use card",
            "Go to specific wall hugger seed",
            "Go to specific wall hugger room",
            "Shoot"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "8QLT YXGN"
            },
            {
                action = "GIVE_CARD",
                id = card.Id
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
        name = card.Tag.."LevelTwoSpiders",
        instructions = {
            "debug 3",
            "Use card",
            "Spawn 10 Lv 2 Spiders",
            "Shoot"
        },
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
                id = card.Id
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
        name = card.Tag.."BlueCap",
        instructions = {
            "debug 3",
            "Give Blue Cap",
            "Use card",
            "Spawn Horf and shoot",
            "Give 2 more Blue Caps",
            "Spawn Horf and shoot",
        },
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
                id = card.Id
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
        name = card.Tag.."SoyMilk",
        instructions = {
            "debug 3",
            "Give Soy Milk",
            "Use card",
            "Spawn Horf and shoot",
        },
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
                id = card.Id
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
