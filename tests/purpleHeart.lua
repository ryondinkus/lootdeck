local card = lootcardKeys.purpleHeart

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Go to new room",
            "Restart + repeat 9 more times"
        },
        steps = {
            {
                action = "REPEAT",
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
                        action = "USE_CARD"
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    }
                },
                times = 10
            }
        }
    },
    {
        name = card.Tag.."Stacking",
        instructions = {
            "Use card 4 times",
            "Go to new room",
            "Kill all room enemies for enemy drops",
            "Restart + repeat 4 more times"
        },
        steps = {
            {
                action = "REPEAT",
                steps = {
                    {
                        action = "RESTART",
                        id = 0
                    },
                    {
                        action = "REPEAT",
                        steps = {
                            {
                                action = "GIVE_CARD",
                                id = card.Id
                            },
                            {
                                action = "USE_CARD"
                            }
                        },
                        times = 4
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "USE_CARD",
                        id = Card.CARD_DEATH
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                },
                times = 5
            }
        }
    },
    {
        name = card.Tag.."Rng",
        instructions = {
            "Use card",
            "Go to new room",
            "Restart on same seed + repeat"
        },
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "2L6V G6XJ"
                    },
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    }
                }
            }
        }
    },
}
