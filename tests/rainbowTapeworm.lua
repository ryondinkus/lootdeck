local card = lootcardKeys.rainbowTapeworm

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Give 4 random passives",
            "Enter and exit room 10 times"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 4,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = function()
                            local game = Game()
                            local room = game:GetRoom()
                            local itemPool = game:GetItemPool()
                            local currentPool = itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed())
                            if currentPool == -1 then currentPool = 0 end
                            return itemPool:GetCollectible(currentPool)
                        end
                    }
                }
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
            },
            {
                action = "REPEAT",
                times = 10,
                steps = {
                    {
                        action = "GO_TO_DOOR"
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
            "Use 5 timescard",
            "Give 4 random passives",
            "Enter and exit room 5 times"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "REPEAT",
                times = 4,
                steps = {
                    {
                        action = "GIVE_ITEM",
                        id = function()
                            local game = Game()
                            local room = game:GetRoom()
                            local itemPool = game:GetItemPool()
                            local currentPool = itemPool:GetPoolForRoom(room:GetType(), lootdeck.rng:GetSeed())
                            if currentPool == -1 then currentPool = 0 end
                            return itemPool:GetCollectible(currentPool)
                        end
                    }
                }
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
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
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "GO_TO_DOOR"
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
