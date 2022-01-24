local card = lootcardKeys.blankRune

return {
    {
        name = card.Tag.."Use",
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
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddHearts(-(Isaac.GetPlayer(0):GetMaxHearts() - 1))"
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_BLANK_CARD
            },
            {
                action = "REPEAT",
                times = 15,
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
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."JandE",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_JACOB
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
                times = 3,
                steps = {
                    {
                        action = "USE_ITEM"
                    }
                }
            }
        }
    }
}
