local helper = LootDeckAPI
local items = include("items/registry")
local entityVariants = include("entityVariants/registry")

-- Gives the cointerfeit penny item
local Names = {
    en_us = "Counterfeit Penny",
    spa = "Moneda Falsificada"
}
local Name = Names.en_us
local Tag = "counterfeitPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: When picking up a coin of any type, there is a low chance for the coin to respawn, similar to a Golden Penny# Rarer coin types have a lower chance to respawn",
    spa = "Añáde un objeto pasivo tras usarla:#Efecto pasivo: Al tomar una moneda de cualquier tipo, hay una posibilidad de que esta moneda reaparazca, de forma similar a una moneda dorada#Mayor rareza = menor posibilidad de aparición"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: Get an additional +1 Coin every time you gain Coins",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo tras usarla:#Efecto pasivo: Recibes una moneda adicional cada vez que consigues monedas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: When picking up a coin of any type, there is a low chance for the coin to respawn, similar to a Golden Penny.", "- Penny: 40%", "- Nickel: 33%", "- Dime: 33%", "- Double Penny: 33%", "- Lucky Penny: 25%", "- Charged Penny: 25%", "- Double Coins (except Double Pennies) are half as likely to respawn as their single counterpart.", "- Additional copies increase the respawn chance by 25%, up to 90%", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
	helper.GiveItem(p, items.counterfeitPenny.Id, SoundEffect.SOUND_VAMP_GULP)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
	WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        }
    },
    Tests = function()
        return {
            {
                name = Tag.."Penny",
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
                        id = Id
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
                name = Tag.."Nickel",
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
                        id = Id
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
                name = Tag.."Dime",
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
                        id = Id
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
                name = Tag.."DoublePenny",
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
                        id = Id
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
                name = Tag.."LuckyPenny",
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
                        id = Id
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
                name = Tag.."DoubleNickel",
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
                        id = Id
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
                name = Tag.."DoubleDime",
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
                        id = Id
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
                name = Tag.."DoubleLuckyPenny",
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
                        id = Id
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
                name = Tag.."ChargedPenny",
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
                        id = Id
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
                name = Tag.."DoubleChargedPenny",
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
                        id = Id
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
    end
}
