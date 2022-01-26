local card = lootcardKeys.jera

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
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            }
        }
    },
    {
        name = card.Tag.."Enemies",
        instructions = {
            "Spawn 5 spiders",
            "Use card"
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
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_SPIDER
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            }
        }
    }
}
