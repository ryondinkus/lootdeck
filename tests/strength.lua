local card = lootcardKeys.strength

return {
    {
        name = card.Tag.."Use",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_BOIL
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
                command = "debug 10"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
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
                action = "GO_TO_DOOR"
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
