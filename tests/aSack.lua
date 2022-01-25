local card = lootcardKeys.aSack

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Check cards using EID",
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
                        seed = "YCZW QAV7"
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
                        seconds = 5
                    }
                }
            }
        },
    }
}
