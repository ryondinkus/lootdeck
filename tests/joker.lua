local card = lootcardKeys.joker

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Spawn an item"
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
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE
            }
        }
    },
    {
        name = card.Tag.."Shop",
        instructions = {
            "Use card",
            "Go to a shop"
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
                action = "RUN_COMMAND",
                command = "goto s.shop"
            }
        }
    },
    {
        name = card.Tag.."Devil",
        instructions = {
            "Use card",
            "Go to a Devil Room"
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
                action = "RUN_COMMAND",
                command = "goto s.devil"
            }
        }
    },
    {
        name = card.Tag.."Interrupt",
        instructions = {
            "Use card",
            "Spawn item",
            "Take item before Devil Hand"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD",
                async = true
            },
            {
                action = "MOVE_UP",
                seconds = 1
            }
        }
    },
    {
        name = card.Tag.."Double",
        instructions = {
            "Use card twice",
            "Spawn item"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD",
                async = true
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
        name = card.Tag.."DoubleDouble",
        instructions = {
            "Use card twice",
            "Spawn two items"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE,
                position = function()
                    return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                end
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD",
                async = true
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
}
