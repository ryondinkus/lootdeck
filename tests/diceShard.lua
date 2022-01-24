local card = lootcardKeys.diceShard

return {
    {
        name = card.Tag.."NewLevel",
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
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            }
        }
    },
    {
        name = card.Tag.."Regular",
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
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            }
        }
    },
    {
        name = card.Tag.."BlankCard",
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
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_BLANK_CARD,
                charged = true
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_ITEM"
            }
        }
    },
    {
        name = card.Tag.."Void",
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
                action = "SPAWN",
                type = EntityType.ENTITY_PICKUP,
                variant = PickupVariant.PICKUP_COLLECTIBLE,
                subType = CollectibleType.COLLECTIBLE_BLANK_CARD
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_VOID,
                charged = true
            },
            {
                action = "USE_ITEM"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "CHARGE_ACTIVE_ITEM"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_ITEM",
                force = true
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
                action = "GIVE_CARD",
                id = card.Id,
                playerIndex = 1
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "REPEAT",
                times = 3,
                steps = {
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "USE_CARD",
                        playerIndex = 1
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."StarterDeck",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_STARTER_DECK
            },
            {
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    }
                }
            },
            {
                action = "GO_TO_DOOR"
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "USE_CARD"
            }
        }
    },
    {
        name = card.Tag.."Beast",
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
                command = "stage 13"
            },
            {
                action = "RUN_COMMAND",
                command = "goto x.itemdungeon.666"
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
