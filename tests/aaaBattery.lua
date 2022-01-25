local card = lootcardKeys.aaaBattery

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Glowing hourglass",
            "Use card",
            "Go to new floor"
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
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
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
                seconds = 2
            },
            {
                action = "RUN_COMMAND",
                command = "stage 2"
            }
        }
    },
    {
        name = card.Tag.."Stacking",
        instructions = {
            "Use card twice",
            "Go to new floor"
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
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RUN_COMMAND",
                command = "stage 2"
            }
        }
    }
}
