local card = lootcardKeys.pokerChip
local entityVariants = include("entityVariants/registry")

return {
    {
        name = card.Tag.."Penny",
        instructions = {
            "Use card",
            "Spawn 9 pennies"
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
                action = "REPEAT",
                times = 9,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_PENNY,
                        position = function()
                            return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                        end
                    }
                }
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            }
        }
    },
    {
        name = card.Tag.."Nickel",
        instructions = {
            "Use card",
            "Spawn 9 nickels"
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
                action = "REPEAT",
                times = 9,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_NICKEL,
                        position = function()
                            return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            }
        }
    },
    {
        name = card.Tag.."Dime",
        instructions = {
            "Use card",
            "Spawn 9 dimes"
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
                action = "REPEAT",
                times = 9,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_DIME,
                        position = function()
                            return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            }
        }
    },
    {
        name = card.Tag.."LuckyPenny",
        instructions = {
            "Use card",
            "Spawn 9 lucky pennies"
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
                action = "REPEAT",
                times = 9,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_LUCKYPENNY,
                        position = function()
                            return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            }
        }
    },
    {
        name = card.Tag.."GoldenPenny",
        instructions = {
            "Use card",
            "Spawn 9 golden pennies"
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
                action = "REPEAT",
                times = 9,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_GOLDEN,
                        position = function()
                            return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            }
        }
    },
    {
        name = card.Tag.."StickyNickel",
        instructions = {
            "Use card",
            "Spawn 9 sticky nickels",
            "Walk on them"
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
                action = "REPEAT",
                times = 9,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_STICKYNICKEL,
                        position = function()
                            return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "TELEPORT_TO_POSITION",
                position = function ()
                    return Game():GetRoom():GetCenterPos()
                end
            },
            {
                action = "USE_BOMB",
                force = true,
                async = true
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.5
            },
        }
    },
    {
        name = card.Tag.."ChargedPenny",
        instructions = {
            "Use card",
            "Spawn 9 charged pennies"
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
                action = "REPEAT",
                times = 9,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.chargedPenny.Id,
                        position = function()
                            return Game():GetRoom():FindFreePickupSpawnPosition(Game():GetRoom():GetCenterPos())
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_LEFT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.7
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2
            },
            {
                action = "MOVE_UP",
                seconds = 0.7
            }
        }
    },
    {
        name = card.Tag.."SoulofTheKeeper",
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
                id = Card.CARD_SOUL_KEEPER
            }
        }
    }
}
