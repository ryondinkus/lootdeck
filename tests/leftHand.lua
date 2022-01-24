local card = lootcardKeys.leftHand

return {
    {
        name = card.Tag.."Locked",
        steps = {
            {
                action = "REPEAT",
                times = 10,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_SKELETON_KEY
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
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_LOCKEDCHEST,
                        position = function()
                            return Game():GetRoom():GetCenterPos()
                        end
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 0.5
                    },
                    {
                        action = "MOVE_UP",
                        seconds = 0.5
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Red",
        steps = {
            {
                action = "REPEAT",
                times = 10,
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
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_REDCHEST,
                        position = function()
                            return Game():GetRoom():GetCenterPos()
                        end
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 0.5
                    },
                    {
                        action = "MOVE_UP",
                        seconds = 0.5
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."LockedBefore",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_SKELETON_KEY
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_LOCKEDCHEST,
                position = function()
                    return Game():GetRoom():GetCenterPos()
                end
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 0.5
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "MOVE_UP",
                seconds = 0.5
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            }
        }
    },
    {
        name = card.Tag.."RedBefore",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_REDCHEST,
                position = function()
                    return Game():GetRoom():GetCenterPos()
                end
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 0.5
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "MOVE_UP",
                seconds = 0.5
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            }
        }
    }
}
