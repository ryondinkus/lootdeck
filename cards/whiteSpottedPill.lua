local helper = LootDeckAPI

-- Shuffle values of coins, keys, and bombs | reroll all items in room | reroll all of your passives
local Names = {
    en_us = "Pills! White Spotted",
    spa = "¡Píldora! con Puntos Blancos"
}
local Name = Names.en_us
local Tag = "whiteSpottedPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:# Swaps the amounts of your coins, keys, and bombs# Rerolls all item pedestals in the room# Rerolls all of your passives",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Pone de revés tu cantidad de monedas, llaves y bombas#Rerolea todos los objetos de pedestales#Rerolea todos tus objetos pasivos"
}
local HolographicDescriptions = {
    en_us = "Random chance for any of these effects:# Swaps the amounts of your coins, keys, and bombs {{ColorRainbow}}twice{{CR}}# Rerolls all item pedestals in the room {{ColorRainbow}}twice{{CR}}# Rerolls all of your passives {{ColorRainbow}}twice{{CR}}",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Pone de revés tu cantidad de monedas, llaves y bombas {{ColorRainbow}}dos veces{{CR}}#Rerolea todos los objetos de pedestales {{ColorRainbow}}dos veces{{CR}}#Rerolea todos tus objetos pasivos {{ColorRainbow}}dos veces{{CR}}"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Swaps the amounts of your coins, keys, and bombs.", "- Rerolls all pedestals in the room.", "- Rerolls all of your passive items.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
    local sfx = lootdeck.sfx

    return helper.RunRandomFunction(lootdeck.debug[Tag] or rng, shouldDouble,
        function()
            sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
            local coins = p:GetNumCoins()
            local bombs = p:GetNumBombs()
            local keys = p:GetNumKeys()
            p:AddCoins(bombs - coins)
            p:AddBombs(keys - bombs)
            p:AddKeys(coins - keys)
        end,
        function()
            helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_D6, SoundEffect.SOUND_EDEN_GLITCH)
        end,
        function()
            p:PlayExtraAnimation("Glitch")
            helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_D4, SoundEffect.SOUND_EDEN_GLITCH)
            return false
        end)
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
            Id
        }
    },
	Tests = function()
        return {
            {
                name = Tag.."Swap",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, 1),
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
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."RoomItems",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, 2),
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
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."Passives",
                steps = {
                    LootDeckAPI.SetDebugFlagStep(Tag, 3),
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
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    LootDeckAPI.ClearDebugFlagStep(Tag)
                }
            },
            {
                name = Tag.."Use",
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
                name = Tag.."Rng",
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
                                id = Id
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
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            }
                        }
                    }
                }
            }
        }
    end
}
