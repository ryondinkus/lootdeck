local card = lootcardKeys.judgement

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card as Azazel with one black heart",
            "Use card with half a red heart",
            "Use card with no keys, then bombs",
            "Use card with less than full health",
            "Use card with less than 15 coins, then 5 keys, then 5 bombs",
            "Use card with no trinkets in inventory or on ground",
            "Use card with less than 6 hearts of any kind",
            "Use card 10 times"
        },
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
        instructions = {
            "Use card as The Lost",
            "Use card with no keys, then bombs",
            "Use card with less than 15 coins, then 5 keys, then 5 bombs",
            "Use card with no trinkets in inventory or on ground",
            "Use card 10 times"
        },
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
        instructions = {
            "Use card as Tainted Lost",
            "Use card with no keys, then bombs",
            "Use card with less than 15 coins, then 5 keys, then 5 bombs",
            "Use card with no trinkets in inventory or on ground",
            "Use card 10 times"
        },
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
        instructions = {
            "Use card as ??? with one Soul Heart",
            "Use card with no keys, then bombs",
            "Use card with less than 15 coins, then 5 keys, then 5 bombs",
            "Use card with no trinkets in inventory or on ground",
            "Use card with less than 6 hearts of any kind",
            "Use card 10 times"
        },
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
        instructions = {
            "Use card as ??? with one Soul Heart",
            "Use card with no keys, then bombs",
            "It's just gonna spawn a buncha doodoo feces lmao",
            "Use card 10 times"
        },
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
        instructions = {
            "Use card",
            "Repeat on same seed"
        },
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
