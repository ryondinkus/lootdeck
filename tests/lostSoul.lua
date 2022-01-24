local card = lootcardKeys.lostSoul

return {
    {
        name = card.Tag.."TintedRock",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "H2NC 87J4"
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 10
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
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
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
        name = card.Tag.."SecretRoom",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "H2NC 87J4"
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 10
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.DOWN0
            },
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
        name = card.Tag.."Double",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "H2NC 87J4"
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
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            }
        }
    }
}
