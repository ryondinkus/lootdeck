local card = lootcardKeys.counterfeitPenny
local items = include("items/registry")
local entityVariants = include("entityVariants/registry")

return {
    {
        name = card.Tag.."Penny",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 pennies",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 pennies",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_PENNY
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_PENNY
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Nickel",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 nickels",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 nickels",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_NICKEL
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_NICKEL
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Dime",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 dimes",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 dimes",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_DIME
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_DIME
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."DoublePenny",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 double pennies",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 double pennies",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_DOUBLEPACK
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_DOUBLEPACK
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."LuckyPenny",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 lucky pennies",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 lucky pennies",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_LUCKYPENNY
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COIN,
                        subType = CoinSubType.COIN_LUCKYPENNY
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."DoubleNickel",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 double nickels",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 double nickels",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleNickel.Id
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleNickel.Id
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."DoubleDime",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 double dimes",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 double dimes",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleDime.Id
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleDime.Id
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."DoubleLuckyPenny",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 double lucky pennies",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 double lucky pennies",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleLuckyPenny.Id
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleLuckyPenny.Id
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."ChargedPenny",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 charged pennies",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 charged pennies",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.chargedPenny.Id
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.chargedPenny.Id
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."DoubleChargedPenny",
        instructions = {
            "Magneto + Deep Pockets",
            "Uses card",
            "Spawn 20 double charged pennies",
            "Wait for input",
            "Resets coin count",
            "Uses card twice",
            "Spawn 20 double charged pennies",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_MAGNETO
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
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
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleChargedPenny.Id
                    }
                }
            },
            {
                action = "WAIT_FOR_KEY"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = items.counterfeitPenny.Id
                    }
                }
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(-Isaac.GetPlayer(0):GetNumCoins())"
            },
            {
                action = "REPEAT",
                times = 20,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = entityVariants.doubleChargedPenny.Id
                    }
                }
            }
        }
    }
}
