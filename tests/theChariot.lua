local card = lootcardKeys.theChariot

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Exit room"
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
        instructions = {
            "Use card as Jacob",
            "Exit room and restart",
            "Use card as Esau",
            "Exit room and restart",
            "Use card as Jacob and Esau",
            "Exit room and restart",
        },
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
        instructions = {
            "Use card as Tainted Bones",
            "Exit room and restart",
            "Use card as Tainted Soul",
            "Exit room and restart",
            "Use card as Tainted Bones and Tainted Soul",
            "Exit room and restart",
        },
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
        instructions = {
            "Use card as The Bones",
            "Exit room as The Bones and restart",
            "Use card as The Soul",
            "Exit room as The Soul and restart",
            "Use card as The Bones",
            "Exit room as The Soul and restart",
            "Use card as The Soul",
            "Exit room as The Bones and restart",
        },
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
        instructions = {
            "Use card as Keeper 5 times",
            "Exit room",
        },
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
        instructions = {
            "Use card as Tainted Keeper 5 times",
            "Exit room",
        },
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
