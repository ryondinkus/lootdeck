local card = lootcardKeys.theHierophant

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Spawn Horf",
            "Take damage from Horf twice (will block)"
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
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 5
            }
        }
    },
    {
        name = card.Tag.."BloodBank",
        instructions = {
            "Use card",
            "Take damage from Blood Bank (won't block)"
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
                action = "SPAWN",
                type = EntityType.ENTITY_SLOT,
                variant = 2 -- blood bank
            },
            {
                action = "MOVE_UP",
                seconds = 5
            }
        }
    },
    {
        name = card.Tag.."DullRazor",
        instructions = {
            "Use card",
            "Take damage from Dull Razor (won't block)"
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
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_DULL_RAZOR
            }
        }
    },
    {
        name = card.Tag.."IvBag",
        instructions = {
            "Use card",
            "Take damage from IV Bag (won't block)"
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
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_IV_BAG
            }
        }
    },
    {
        name = card.Tag.."CurseRoom",
        instructions = {
            "Use card",
            "Take damage from Curse Room (will block)"
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
                action = "RUN_COMMAND",
                command = "goto s.curse"
            },
            {
                action = "RUN_COMMAND",
                command = "debug 10"
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
        name = card.Tag.."SacrificeRoom",
        instructions = {
            "Use card",
            "Take damage from Sac Room (will block)"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "ZS3Z VJ1D"
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "MOVE_UP",
                seconds = 3
            }
        }
    },
    {
        name = card.Tag.."PoundOfFlesh",
        instructions = {
            "Use card",
            "Take damage from Pound of Flesh shop item (won't block)"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_POUND_OF_FLESH
            },
            {
                action = "RUN_COMMAND",
                command = "goto s.shop"
            },
            {
                action = "RUN_COMMAND",
                command = "debug 10"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 5
            }
        }
    },
    {
        name = card.Tag.."Stacking",
        instructions = {
            "Use card 3 times",
            "Spawn Horf",
            "Take damage from Horf six times (will block)"
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
                    },
                }
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            }
        }
    },
    {
        name = card.Tag.."HolyMantle",
        instructions = {
            "Grant Holy Mantle",
            "Use card",
            "Take damage from Horf three times"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_HOLY_MANTLE
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            }
        }
    },
    {
        name = card.Tag.."HolyCard",
        instructions = {
            "Use Holy Card",
            "Use card",
            "Take damage from Horf three times"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "USE_CARD",
                id = Card.CARD_HOLY
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            }
        }
    }
}
