local card = lootcardKeys.justice

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Spawn Horf"
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
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 5
            }
        }
    },
    {
        name = card.Tag.."Interrupt",
        instructions = {
            "Use card",
            "Spawn Horf",
            "Kill Horf after a couple of seconds"
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
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 10
            }
        }
    },
    {
        name = card.Tag.."Multiple",
        instructions = {
            "Use card twice",
            "Spawn Horf"
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
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 5
            }
        }
    },
    {
        name = card.Tag.."MultipleEnemies",
        instructions = {
            "Use card twice",
            "Go to room with multiple enemies"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "08FT KREY"
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.LEFT0
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
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
                seconds = 5
            }
        }
    }
}
