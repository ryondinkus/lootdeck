local card = lootcardKeys.death

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Go to new room",
            "Use card"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GO_TO_DOOR"
            },
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
        name = card.Tag.."JandE",
        instructions = {
            "Go to new room",
            "Use card as Jacob",
            "Go to new room",
            "Use card as Esau",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_JACOB
            },
            {
                action = "GO_TO_DOOR"
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
                action = "RESTART",
                id = PlayerType.PLAYER_JACOB
            },
            {
                action = "GO_TO_DOOR"
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
            }
        }
    },
    {
        name = card.Tag.."Keeper",
        instructions = {
            "Go to new room",
            "Use card as Keeper",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_KEEPER
            },
            {
                action = "GO_TO_DOOR"
            },
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
        name = card.Tag.."Forgotten",
        instructions = {
            "Go to new room",
            "Use card as The Bones",
            "Go to new room",
            "Use card as The Soul",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN
            },
            {
                action = "GO_TO_DOOR"
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
                action = "GO_TO_DOOR"
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
    },
    {
        name = card.Tag.."Beast",
        instructions = {
            "Go to Beast fight",
            "Use card",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "RUN_COMMAND",
                command = "stage 13"
            },
            {
                action = "RUN_COMMAND",
                command = "goto x.itemdungeon.666"
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
            }
        }
    }
}
