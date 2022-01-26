local card = lootcardKeys.goldBomb

return {
    {
        name = card.Tag.."Enemy",
        instructions = {
            "Blow up enemy in room below",
            "Glowing Hourglass",
            "Blow up same enemy in room below",
            "Glowing Hourglass",
            "Spawn and blow up Horf"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "E6S9 3MNY"
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.5
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 3
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
                action = "MOVE_DOWN",
                seconds = 0.5
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 3
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
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            },
        }
    },
    {
        name = card.Tag.."Self",
        instructions = {
            "Blow up player"
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
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            }
        }
    }
}
