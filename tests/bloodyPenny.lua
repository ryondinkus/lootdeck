local card = lootcardKeys.bloodyPenny

return {
    {
        name = card.Tag.."Use",
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
