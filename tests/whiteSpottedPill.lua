local card = lootcardKeys.whiteSpottedPill

return {
    {
        name = card.Tag.."Swap",
        instructions = {
            "Give 5 keys",
            "Use swap pickups effect from card"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 1),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "EXECUTE_LUA",
                code = function(arguments)
                    Isaac.GetPlayer(arguments.playerIndex or 0):AddKeys(5)
                end
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."RoomItems",
        instructions = {
            "Spawn 3 items",
            "Use reroll pedestals effect from card"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 2),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_PICKUP,
                        variant = PickupVariant.PICKUP_COLLECTIBLE,
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
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Passives",
        instructions = {
            "Give 4 items",
            "Use reroll run effect from card"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, 3),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 4,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = function()
                            local game = Game()
                            local room = game:GetRoom()
                            local itemPool = game:GetItemPool()
                            local currentPool = itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed())
                            if currentPool == -1 then currentPool = 0 end
                            return itemPool:GetCollectible(currentPool)
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card 10 times"
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
                action = "ENABLE_DEBUG_FLAG",
                flag = 8
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_BLANK_CARD
            },
            {
                action = "REPEAT",
                times = 10,
                steps = {
                    {
                        action = "USE_ITEM"
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Rng",
        instructions = {
            "Use card",
            "Glowing Hourglass, use again",
            "Repeat two more times"
        },
        steps = {
            {
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "RESTART",
                        id = 0
                    },
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            }
        }
    }
}
