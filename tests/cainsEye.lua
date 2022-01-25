local card = lootcardKeys.cainsEye

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Uses card",
            "Go to a new stage 5 times",
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
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "RUN_COMMAND",
                        command = "stage 1"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Stacking",
        instructions = {
            "Uses card 3 times",
            "Go to a new stage 5 times",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 3,
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
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "RUN_COMMAND",
                        command = "stage 1"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Existing",
        instructions = {
            "Gives the map",
            "Uses card twice",
            "Go to a new stage 3 times",
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_TREASURE_MAP
            },
            {
                action = "REPEAT",
                times = 2,
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
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "RUN_COMMAND",
                        command = "stage 1"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Rng",
        instructions = {
            "Uses card",
            "Go to a new stage",
            "Reload same seed and repeat"
        },
        steps = {
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = 0,
                        seed = "RA0G 9FVT"
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
                        action = "RUN_COMMAND",
                        command = "stage 2"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    }
                }
            }
        }
    }
}
