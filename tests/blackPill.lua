local card = lootcardKeys.blackPill

return {
    {
        name = card.Tag.."Kill",
        instructions = {
            "Spawn 10 Horfs",
            "Use kill enemies effect from card"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 1),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 10,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF,
                        position = function()
                            return Isaac.GetRandomPosition()
                        end
                    }
                }
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Confuse",
        instructions = {
            "Spawn 10 Horfs",
            "Use confuse enemies effect from card"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 2),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 10,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF,
                        position = function()
                            return Isaac.GetRandomPosition()
                        end
                    }
                }
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."TakeDamage",
        instructions = {
            "Use take damage effect from card"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 3),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 4,
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
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card 10 times"
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
        name = card.Tag.."Rng",
        instructions = {
            "Use card",
            "Glowing Hourglass, use again",
            "Repeat two more times"
        },
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
                        id = card.Id
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
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            }
        }
    }
}
