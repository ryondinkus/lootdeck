local card = lootcardKeys.brokenAnkh

return {
    {
        name = card.Tag.."Use",
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
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
                times = 3,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."JandE",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_JACOB
            },
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
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
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE,
                        playerIndex = 1
                    }
                }
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
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Keeper",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_KEEPER
            },
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Forgotten",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_THEFORGOTTEN
            },
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "REPEAT",
                times = 4,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
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
                action = "REPEAT",
                times = 1,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Beast",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
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
                action = "REPEAT",
                times = 6,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Rng",
        steps = {
            LootDeckAPI.ClearDebugFlagStep(card.Tag),
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "DJKY EN7X"
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
                        times = 3,
                        steps = {
                            {
                                action = "USE_ITEM",
                                id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                            }
                        }
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
        steps = {
            LootDeckAPI.ClearDebugFlagStep(card.Tag),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "J394 Q2V2"
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
                    },
                }
            },
            {
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 2
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "J394 Q2V2"
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
                times = 3,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            }
        }
    }
}
