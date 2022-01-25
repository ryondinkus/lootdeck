local card = lootcardKeys.theWorld

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Spawn 5 Horfs",
            "Use card",
            "Go to new room twice"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 5,
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
                action = "WAIT_FOR_SECONDS",
                seconds = 3
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1.5
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    }
}
