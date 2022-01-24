local card = lootcardKeys.purpleHeart

return {
    {
        name = card.Tag.."Use",
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
