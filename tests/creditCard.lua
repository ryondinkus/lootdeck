local card = lootcardKeys.creditCard

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Give Plum Flute",
            "Use card",
            "Go to shop",
            "Try to buy active item, fail",
            "Give a dollar",
            "Buy item again, swapping actives"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "WXCB GR6C"
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_PLUM_FLUTE
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
                action = "MOVE_UP",
                seconds = 0.5
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DOLLAR
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.5
            }
        }
    },
    {
        name = card.Tag.."Multiple",
        instructions = {
            "Give a dollar",
            "Use card twice",
            "Go to shop",
            "Buy two items",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "WXCB GR6C"
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DOLLAR
            },
            {
                action = "REPEAT",
                times = 2,
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
                action = "USE_CARD",
                id = Card.CARD_HERMIT
            },
            {
                action = "MOVE_UP",
                seconds = 0.3
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.5
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_LEFT",
                seconds = 1
            }
        }
    },
    {
        name = card.Tag.."Devil",
        instructions = {
            "Give player 4 red hearts, 6 soul hearts",
            "Use card 4 times",
            "Buy 1 heart devil deal",
            "Buy 2 heart devil deal",
            "Buy 3 soul heart devil deal",
            "Buy 1 red heart + 2 soul heart devil deal"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_BREAKFAST
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = CollectibleType.COLLECTIBLE_BREAKFAST
                    },
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_GUPPYS_PAW
                    }
                }
            },
            {
                action = "REPEAT",
                times = 4,
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
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE,
                after = function(entity)
                    local pickup = entity:ToPickup()
                    pickup.AutoUpdatePrice = false
                    pickup.Price = PickupPrice.PRICE_ONE_HEART
                end
            },
            {
                action = "MOVE_UP",
                seconds = 1,
                speed = 0.8
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE,
                after = function(entity)
                    local pickup = entity:ToPickup()
                    pickup.AutoUpdatePrice = false
                    pickup.Price = PickupPrice.PRICE_TWO_HEARTS
                end
            },
            {
                action = "MOVE_DOWN",
                seconds = 1,
                speed = 0.8
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE,
                after = function(entity)
                    local pickup = entity:ToPickup()
                    pickup.AutoUpdatePrice = false
                    pickup.Price = PickupPrice.PRICE_THREE_SOULHEARTS
                end
            },
            {
                action = "MOVE_UP",
                seconds = 1,
                speed = 0.8
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE,
                after = function(entity)
                    local pickup = entity:ToPickup()
                    pickup.AutoUpdatePrice = false
                    pickup.Price = PickupPrice.PRICE_ONE_HEART_AND_TWO_SOULHEARTS
                end
            },
            {
                action = "MOVE_DOWN",
                seconds = 1,
                speed = 0.8
            }
        }
    },
    {
        name = card.Tag.."Battery",
        instructions = {
            "Give a dollar",
            "Use card twice",
            "Spawn two Mega Batteries for sale",
            "Try to buy Mega Battery with no active",
            "Give uncharged Plum Flute",
            "Buy Mega Battery",
            "Try to buy Mega Battery with charged active",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DOLLAR
            },
            {
                action = "REPEAT",
                steps = 
                {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                },
                times = 2
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_LIL_BATTERY,
                subType = BatterySubType.BATTERY_MEGA,
                after = function(entity)
                    local pickup = entity:ToPickup()
                    pickup.AutoUpdatePrice = false
                    pickup.Price = 15
                end
            },
            {
                action = "MOVE_UP",
                seconds = 1,
                speed = 0.8
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_PLUM_FLUTE
            },
            {
                action = "MOVE_DOWN",
                seconds = 1,
                speed = 0.8
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_LIL_BATTERY,
                subType = BatterySubType.BATTERY_MEGA,
                after = function(entity)
                    local pickup = entity:ToPickup()
                    pickup.AutoUpdatePrice = false
                    pickup.Price = 15
                end
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "MOVE_UP",
                seconds = 1,
                speed = 0.8
            }
        }
    }
}
