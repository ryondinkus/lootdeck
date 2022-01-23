local helper = LootDeckAPI
local entityVariants = include("entityVariants/registry")

-- Adds a familiar, the familiar refunds you for the next shop/devil item you buy
local Names = {
    en_us = "Credit Card",
    spa = "Tarjeta de Crédito"
}
local Name = Names.en_us
local Tag = "creditCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "After using, the next shop item or Devil Deal you purchase gets refunded via spawned Pennies or Health Up Pills",
    spa = "Al usarlo, el próximo objeto conseguido en una tienda o pacto con el Diablo será reembolsado en monedas o píldoras de MásVida"
}
local HolographicDescriptions = {
    en_us = "After using, the next {{ColorRainbow}}2{{CR}} shop items or Devil Deals you purchase get refunded via spawned Pennies or Health Up Pills",
    spa = "Al usarlo, el próximo {{ColorRainbow}}2{{CR}} objetos conseguido en unas tienda o pacto con el Diablo será reembolsado en monedas o píldoras de MásVida"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, spawns a Credit Card familiar. The Credit Card familiar will refund your next purchased shop item or Devil Deal.", "- Credit Card will spawn the appropriate amount of pennies on the ground. For Devil Deals, it will spawn Soul Hearts or Health Up Pills.", "- It's possible for the Health Up Pills to become Health Downs via False PHD.", "Holographic Effect: Grants two Credit Card familiars.")

local function MC_USE_CARD(_, c, p)
    Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.creditCardBaby.Id, 0, p.Position, Vector.Zero, p)
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
                name = Tag.."Use",
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
                        id = Id
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
                name = Tag.."Multiple",
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
                                id = Id
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
                name = Tag.."Devil",
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
                                id = Id
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
                name = Tag.."Battery",
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
                                id = Id
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
    end
}
