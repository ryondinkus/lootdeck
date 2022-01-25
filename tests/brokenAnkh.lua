local card = lootcardKeys.brokenAnkh

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Broken Ankh Debug enabled",
            "Uses card",
            "Die from razor blade"
        },
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
        instructions = {
            "Broken Ankh Debug enabled",
            "Uses card as Jacob",
            "Jacob dies from razor blade",
            "Uses card as Jacob",
            "Esau dies from razor blade",
            "Uses card as Jacob and Esau",
            "Jacob dies from razor blade"
        },
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
        instructions = {
            "Broken Ankh Debug enabled",
            "Uses card as Keeper",
            "Dies from razor blade"
        },
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
        instructions = {
            "Broken Ankh Debug enabled",
            "Uses card as Bones",
            "Bones dies from razor blade",
            "Uses card as Soul",
            "Soul dies from razor blade"
        },
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
        instructions = {
            "Broken Ankh Debug enabled",
            "Uses card",
            "Die in Beast fight"
        },
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
        instructions = {
            "Use card",
            "Die from razor blade",
            "Repeat on same seed"
        },
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
        instructions = {
            "Use card three times",
            "Die from razor blade, revive",
            "Repeat on same seed",
            "Use card once",
            "Die from razor blade, no revive",
        },
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
