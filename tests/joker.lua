local card = lootcardKeys.joker

return {
    {
        name = card.Tag.."Use",
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
