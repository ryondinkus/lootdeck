local helper = LootDeckAPI

-- Spawns 1-3 of a pickup determined by the Glyph of Balance algorithm
local Names = {
    en_us = "XX. Judgement",
    spa = "XX. Juicio"
}
local Name = Names.en_us
local Tag = "judgement"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns 1-3 consumables based on the {{Collectible464}} Glyph of Balance algorithm, spawning whatever consumables you have the least of",
    spa = "Genera 1-3 recolectables basándose en el algoritmo de {{Collectible464}} Glifo de Blance, generando los recolectables que en menor cantidad poseas"
}
local HolographicDescriptions = {
    en_us = "Spawns {{ColorRainbow}}2-6{{CR}} consumables based on the {{Collectible464}} Glyph of Balance algorithm, spawning whatever consumables you have the least of",
    spa = "Genera {{ColorRainbow}}2-6{{CR}} recolectables basándose en el algoritmo de {{Collectible464}} Glifo de Blance, generando los recolectables que en menor cantidad poseas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns 1-3 consumables based on the Glyph of Balance algorithm. This spawns whatever consumable you have least of.", "Holographic Effect: Spawns twice as many consumables.")

local function MC_USE_CARD(_, c, p, f, _, _, rng)
    local reward = helper.GlyphOfBalance(p, rng)
    local room = Game():GetRoom()
    for i=0, rng:RandomInt(3) do
        helper.Spawn(EntityType.ENTITY_PICKUP, reward[1], reward[2], room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
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
                        id = PlayerType.PLAYER_AZAZEL
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBlackHearts(-2)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddMaxHearts(4)"
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddHearts(-3)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddHearts(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD",
                        async = true
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddHearts(2)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddCoins(15)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_TRINKET",
                        id = TrinketType.TRINKET_CANCER
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
                        times = 10
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            },
            {
                name = Tag.."Lost",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THELOST
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD",
                        async = true
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddCoins(15)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_TRINKET",
                        id = TrinketType.TRINKET_CANCER
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
                        times = 10
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            },
            {
                name = Tag.."TaintedLost",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_THELOST_B
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD",
                        async = true
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddCoins(15)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_TRINKET",
                        id = TrinketType.TRINKET_CANCER
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
                        times = 10
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            },
            {
                name = Tag.."BlueBaby",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_XXX
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddSoulHearts(-2)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddSoulHearts(2)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                        action = "USE_CARD",
                        async = true
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddCoins(15)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_TRINKET",
                        id = TrinketType.TRINKET_CANCER
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
                        times = 10
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            },
            {
                name = Tag.."TaintedBlueBaby",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_XXX_B
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddSoulHearts(-2)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddSoulHearts(2)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                        action = "USE_CARD",
                        async = true
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(1)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
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
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddCoins(15)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddKeys(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "EXECUTE_LUA",
                        code = "Isaac.GetPlayer(0):AddBombs(5)"
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_TRINKET",
                        id = TrinketType.TRINKET_CANCER
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
                        times = 10
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            },
            {
                name = Tag.."Rng",
                steps = {
                    {
                        action = "REPEAT",
                        steps =
                        {
                            {
                                action = "RESTART",
                                id = PlayerType.PLAYER_ISAAC,
                                seed = "YP6S Q6AW"
                            },
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 1
                            },
                        },
                        times = 2,
                    }
                }
            },
        }
    end
}
