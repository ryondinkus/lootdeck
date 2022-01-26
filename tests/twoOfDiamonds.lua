local card = lootcardKeys.twoOfDiamonds

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Go to shop",
            "Go to shop on new floor"
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
                action = "USE_CARD",
                id = Card.CARD_HERMIT
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RUN_COMMAND",
                command = "stage 2"
            },
            {
                action = "USE_CARD",
                id = Card.CARD_HERMIT
            },
        }
    },
    {
        name = card.Tag.."Freeze",
        instructions = {
            "Use card",
            "Spawn Horf",
            "Run into Horf"
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
                action = "MOVE_RIGHT",
                seconds = 0.1,
                async = true
            },
            {
                action = "MOVE_UP",
                seconds = 1
            }
        }
    }
}
