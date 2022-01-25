local card = lootcardKeys.questionCard

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card with no enemies"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
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
            },
            {
                action = "MOVE_UP",
                seconds = 0.5
            }
        }
    },
    {
        name = card.Tag.."Enemies",
        instructions = {
            "Go to new room",
            "Use card"
        },
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "KA06 QV94"
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.DOWN0
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
                    },
                    {
                        action = "MOVE_RIGHT",
                        seconds = 1
                    }
                }
            }
        }
    }
}
