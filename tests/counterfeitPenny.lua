local card = lootcardKeys.counterfeitPenny
local items = include("items/registry")
local entityVariants = include("entityVariants/registry")

return {
    {
        name = card.Tag.."Penny",
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
