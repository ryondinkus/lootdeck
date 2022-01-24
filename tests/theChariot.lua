local card = lootcardKeys.theChariot

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
                action = "USE_CARD"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    },
    {
        name = card.Tag.."JandE",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_JACOB
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
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_JACOB
            },
            {
                action = "GIVE_CARD",
                id = card.Id,
                playerIndex = 1
            },
            {
                action = "USE_CARD",
                playerIndex = 1
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_JACOB
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "GIVE_CARD",
                id = card.Id,
                playerIndex = 1
            },
            {
                action = "USE_CARD",
                playerIndex = 1
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    },
    {
        name = card.Tag.."TaintedForgotten",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN_B
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
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN_B
            },
            {
                action = "GIVE_CARD",
                id = card.Id,
                playerIndex = 1
            },
            {
                action = "USE_CARD",
                playerIndex = 1
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN_B
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "GIVE_CARD",
                id = card.Id,
                playerIndex = 1
            },
            {
                action = "USE_CARD",
                playerIndex = 1
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    },
    {
        name = card.Tag.."Forgotten",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN
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
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN
            },
            {
                action = "SWAP_SUB_PLAYERS"
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
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "SWAP_SUB_PLAYERS"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN
            },
            {
                action = "SWAP_SUB_PLAYERS"
            },
            {
                action = "GIVE_CARD",
                id = card.Id,
                playerIndex = 1
            },
            {
                action = "USE_CARD",
                playerIndex = 1
            },
            {
                action = "SWAP_SUB_PLAYERS"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
        }
    },
    {
        name = card.Tag.."Keeper",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_KEEPER
            },
            {
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    },
    {
        name = card.Tag.."TaintedKeeper",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_KEEPER_B
            },
            {
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    }
}
