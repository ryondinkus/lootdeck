local card = lootcardKeys.getOutOfJail

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Spawn 20 Horfs",
            "Move between Horfs",
            "Go to new room, persist"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF,
                        position = Isaac.GetRandomPosition
                    }
                }
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
                seconds = 0.7
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.7
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 0.5
            },
            {
                action = "GO_TO_DOOR"
            }
        },
    }
}
