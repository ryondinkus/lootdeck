local card = lootcardKeys.theHierophant

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
