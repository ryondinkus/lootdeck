local card = lootcardKeys.theHighPriestess

return {
    {
        name = card.Tag.."Enemy",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
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
                        type = EntityType.ENTITY_SPIDER
                    },
                }
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
        name = card.Tag.."Player",
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
        name = card.Tag.."Rng",
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = 0,
                        seed = "WHYD KMJ4"
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.DOWN0
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
                    }
                }
            }
        }
    }
}
