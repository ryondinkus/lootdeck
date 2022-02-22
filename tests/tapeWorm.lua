local card = lootcardKeys.tapeWorm

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card and shoot",
            "Use card three times and shoot",
            "Use Book of Belial and shoot"
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
                action = "TELEPORT_TO_POSITION",
                position = function()
                    return Game():GetRoom():GetCenterPos()
                end
            },
            {
                action = "REPEAT",
                times = 4,
                steps = {
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_RIGHT",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_DOWN",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_LEFT",
                        seconds = 1
                    }
                }
            },
            {
                action = "REPEAT",
                times = 3,
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
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "SHOOT_UP",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_RIGHT",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_DOWN",
                        seconds = 1
                    },
                    {
                        action = "SHOOT_LEFT",
                        seconds = 1
                    }
                }
            },
            {
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL
            },
            {
                action = "SHOOT_UP",
                seconds = 1
            },
            {
                action = "SHOOT_RIGHT",
                seconds = 1
            },
            {
                action = "SHOOT_DOWN",
                seconds = 1
            },
            {
                action = "SHOOT_LEFT",
                seconds = 1
            }
        }
    }
}
