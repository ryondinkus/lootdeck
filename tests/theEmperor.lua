local card = lootcardKeys.theEmperor

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Go to room with enemies",
            "Use the card"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "3VMW NXHF"
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            }
        }
    },
    {
        name = card.Tag.."Boss",
        instructions = {
            "Go to boss room",
            "Use the card"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "USE_CARD",
                id = Card.CARD_EMPEROR
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
