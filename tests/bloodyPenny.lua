local card = lootcardKeys.bloodyPenny

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Debug 3 + Debug 4",
            "Uses card",
            "Spawns 20 spiders",
            "Kill them all!"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 4
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_SPIDER
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Stacking",
        instructions = {
            "Debug 3 + Debug 4",
            "Uses card 5 times",
            "Spawns 12 spiders",
            "Kill them all!"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 4
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
            },
            {
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                action = "REPEAT",
                times = 12,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_SPIDER
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."InvEnemies",
        instructions = {
            "Debug 3 + Debug 4 + Soy",
            "Uses card 5 times",
            "Spawns a grimace",
            "Shoots at grimace for 10s"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 4
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_SOY_MILK
            },
            {
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_STONEHEAD
            },
            {
                action = "SHOOT_UP",
                seconds = 10
            }
        }
    },
    {
        name = card.Tag.."Rng",
        instructions = {
            "Debug 3 + Debug 4 + Soy",
            "Uses card 5 times",
            "Enter new room",
            "Kill shit",
            "On key press, use glowing hour glass and do it again"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "BWD6 Y8BM"
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 4
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_SOY_MILK
            },
            {
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    }
}
