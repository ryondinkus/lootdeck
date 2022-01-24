local card = lootcardKeys.judgement

return {
    {
        name = card.Tag.."Use",
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                        id = card.Id
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
        name = card.Tag.."Lost",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THELOST
            },
            {
                action = "GIVE_CARD",
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                        id = card.Id
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
        name = card.Tag.."TaintedLost",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THELOST_B
            },
            {
                action = "GIVE_CARD",
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                        id = card.Id
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
        name = card.Tag.."BlueBaby",
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                        id = card.Id
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
        name = card.Tag.."TaintedBlueBaby",
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                id = card.Id
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
                        id = card.Id
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
        name = card.Tag.."Rng",
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
                        id = card.Id
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
