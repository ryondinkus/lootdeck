local card = lootcardKeys.theStars

return {
    {
        name = card.Tag.."Use",
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
                        seed = "WNKQ RL7M"
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
