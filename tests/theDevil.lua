local card = lootcardKeys.theDevil

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Buy item"
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
                action = "MOVE_RIGHT",
                seconds = 0.2,
                async = true
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.1
            }
        }
    },
    {
        name = card.Tag.."Angel",
        instructions = {
            "Go to Angel Room",
            "Use card"
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
                action = "RUN_COMMAND",
                command = "goto s.angel"
            },
            {
                action = "USE_CARD"
            }
        }
    },
    {
        name = card.Tag.."ActiveItem",
        instructions = {
            "Use card (active will spawn)",
            "Buy and swap active items"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "SXD6 CKMV"
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_PLUM_FLUTE
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
                seconds = 0.2,
                async = true
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.1
            }
        }
    },
    {
        name = card.Tag.."Rng",
        instructions = {
            "Use card",
            "Repeat on same seed"
        },
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "SXD6 CKMV"
                    },
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            }
        }
    }
}
