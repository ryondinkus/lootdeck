local card = lootcardKeys.aSack

return {
    {
        name = card.Tag.."Use",
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
        instructions = "Use EID to check card RNG"
    }
}
