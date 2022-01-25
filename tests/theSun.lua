local card = lootcardKeys.theSun

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Give two copies of the card, use one",
            "Go to boss room, kill boss",
            "On key press, spawn another card and grant card directly"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_STARTER_DECK
            },
            {
                action = "GIVE_CARD",
                id = card.Id
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
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 10
            },
            {
                action = "USE_CARD",
                id = Card.CARD_EMPEROR
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_TAROTCARD,
                subType = card.Id
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
        }
    },
    {
        name = card.Tag.."After",
        instructions = {
            "Go to boss room, kill boss",
            "Use card"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 10
            },
            {
                action = "USE_CARD",
                id = Card.CARD_EMPEROR
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 5
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            }
        }
    }
}
