local helper = LootDeckAPI
local items = include("items/registry")
local entityVariants = include("entityVariants/registry")

-- trinket; All penny spawns are either double pennies or nothing
local Names = {
    en_us = "Poker Chip",
    spa = "Ficha de Póker"
}
local Name = Names.en_us
local Tag = "pokerChip"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Adds a unique passive item on use# Passive: All coin spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all",
    spa = "Añade un objeto pasivo al usarla#Efecto pasivo: Todas las monedas tienen un 50/50 de posibilidad de generarse como monedas dobles o no generarse en sí"
}
local HolographicDescriptions = {
    en_us = "Adds {{ColorRainbow}}2 copies of a{{CR}} unique passive item on use# Passive: All coin spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all",
    spa = "Añade {{ColorRainbow}}2 copias de un{{CR}} objeto pasivo al usarla#Efecto pasivo: Todas las monedas tienen un 50/50 de posibilidad de generarse como monedas dobles o no generarse en sí"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: All coins spawns have a 50/50 chance to either spawn as Double Coins or not spawn at all.", "- Double coins still retain their respective values. (Double Nickels, Double Dimes, etc.)", "Holographic Effect: Grants two copies of the passive.")

local function MC_USE_CARD(_, c, p)
    helper.GiveItem(p, items.pokerChip.Id, SoundEffect.SOUND_VAMP_GULP)
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
                        action = "GIVE_CARD",
                        id = Id
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
                name = Tag.."Nickel",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
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
                name = Tag.."Dime",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
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
                name = Tag.."LuckyPenny",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
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
                name = Tag.."GoldenPenny",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
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
                name = Tag.."StickyNickel",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
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
                name = Tag.."ChargedPenny",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
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
                name = Tag.."SoulofTheKeeper",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
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
    end
}
