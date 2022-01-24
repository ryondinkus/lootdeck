local card = lootcardKeys.perthro

return {
    {
        name = card.Tag.."NoItems",
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
            }
        }
    },
    {
        name = card.Tag.."StartingItems",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_CAIN
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
                id = PlayerType.PLAYER_CAIN
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_LUCKY_FOOT
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
        name = card.Tag.."ActiveItem",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_PLUM_FLUTE
            },
            {
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = function()
                            local items = {
                                CollectibleType.COLLECTIBLE_SAD_ONION,
                                CollectibleType.COLLECTIBLE_INNER_EYE,
                                CollectibleType.COLLECTIBLE_SPOON_BENDER,
                                CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
                                CollectibleType.COLLECTIBLE_BROTHER_BOBBY
                            }

                            return items[lootdeck.rng:RandomInt(#items - 1) + 1]
                        end
                    }
                }
            },
            {
                action = "REPEAT",
                times = 10,
                steps = {
                    {
                        action = "GIVE_CARD",
                        id = card.Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 3
                    }
                }
            }
        }
    },
    {
        name = card.Tag.."Persist",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "9RMR ZWCQ"
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
                action = "USE_CARD"
            },
            {
                action = "MOVE_DOWN",
                seconds = 1
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
                        seed = "9RMR ZWCQ"
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
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 3
                    }
                }
            }
        }
    }
}
