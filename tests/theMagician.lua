local card = lootcardKeys.theMagician

return {
    {
        name = card.Tag.."Use",
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
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "SHOOT_UP",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "SHOOT_DOWN",
                seconds = 2
            }
        }
    }
}
