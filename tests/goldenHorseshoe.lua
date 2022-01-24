local card = lootcardKeys.goldenHorseshoe

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
                action = "USE_CARD"
            },
            {
                action = "REPEAT",
                steps =
                {
                    {
                        action = "USE_CARD",
                        id = Card.CARD_STARS
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "GO_TO_DOOR"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                },
                times = 3
            }
        }
    },
    {
        name = card.Tag.."Labyrinth",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "RUN_COMMAND",
                command = "curse 2"
            },
            {
                action = "RUN_COMMAND",
                command = "stage 1"
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
                steps =
                {
                    {
                        action = "USE_CARD",
                        id = Card.CARD_STARS
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                },
                times = 2
            }
        }
    }
}
