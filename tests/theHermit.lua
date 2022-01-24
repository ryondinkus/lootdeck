local card = lootcardKeys.theHermit

return {
    {
        name = card.Tag.."Use",
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
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(15)"
            },
            {
                action = "USE_CARD"
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2,
                async = true
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.1
            }
        }
    },
    {
        name = card.Tag.."Devil",
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
                action = "RUN_COMMAND",
                command = "goto s.devil"
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(15)"
            },
            {
                action = "USE_CARD"
            }
        }
    },
    {
        name = card.Tag.."ActiveItem",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "FFZM XGPC"
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_PLUM_FLUTE
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "EXECUTE_LUA",
                code = "Isaac.GetPlayer(0):AddCoins(15)"
            },
            {
                action = "USE_CARD"
            },
            {
                action = "MOVE_RIGHT",
                seconds = 0.2,
                async = true
            },
            {
                action = "MOVE_DOWN",
                seconds = 0.1
            }
        }
    },
    {
        name = card.Tag.."Rng",
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "FFZM XGPC"
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
                    }
                }
            }
        }
    }
}
