local card = lootcardKeys.theStars

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Repeat on same seed"
        },
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "WNKQ RL7M"
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
    },
    {
        name = card.Tag.."Active",
        instructions = {
            "Use card with active item",
            "Make sure charge of original active item is full"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "NF77 6DC0"
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_PLUM_FLUTE,
                charged = true
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
                action = "MOVE_DOWN",
                seconds = 0.2
            }
        }
    }
}
