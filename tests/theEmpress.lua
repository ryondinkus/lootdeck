local card = lootcardKeys.theEmpress

return {
    {
        name = card.Tag.."Use",instructions = {
            "Use the card twice",
            "Shoot",
            "Exit room"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 2,
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
            {
                action = "SHOOT_UP",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "SHOOT_DOWN",
                seconds = 2
            }
        }
    }
}
