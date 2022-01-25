local card = lootcardKeys.ansuz

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card twice"
        },
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "NWHG BHV3"
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
                        seconds = 1
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Boss",
        instructions = {
            "Go to Treasure Room and Shop",
            "Use card"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "NWHG BHV3"
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
                action = "GO_TO_DOOR",
                slot = DoorSlot.RIGHT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.RIGHT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.UP0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
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
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            }
        }
    },
    {
        name = card.Tag.."Explore",
        instructions = {
            "Go to Treasure Room, Shop, and Boss Room",
            "Use card"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "NWHG BHV3"
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
                action = "GO_TO_DOOR",
                slot = DoorSlot.RIGHT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.RIGHT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.UP0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
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
                action = "USE_CARD",
                id = Card.CARD_EMPEROR
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
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            }
        }
    }
}
