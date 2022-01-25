local card = lootcardKeys.bluePill

return {
    {
        name = card.Tag.."LootCard",
        instructions = {
            "Runs the spawn 1 loot effect"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 1),
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
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."LootCards",
        instructions = {
            "Runs the spawn 3 loot effect"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 2),
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
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Lose",
        instructions = {
            "Runs the lose pickups effect"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 3),
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
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Use",
        instructions = {
            "Uses random blue pill effect 10 times"
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
            "Uses the card",
            "Glowing Hourglass and use card again",
            "Repeat twice"
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
