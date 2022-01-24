local card = lootcardKeys.guppysHairball

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
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 5
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."BloodBank",
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
                action = "SPAWN",
                type = EntityType.ENTITY_SLOT,
                variant = 2 -- blood bank
            },
            {
                action = "MOVE_UP",
                seconds = 5
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."DullRazor",
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
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_DULL_RAZOR
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."IvBag",
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
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_IV_BAG
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."CurseRoom",
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
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."SacrificeRoom",
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
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
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."PoundOfFlesh",
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
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
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Stacking",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "GQYG CK7B"
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
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 5
            },
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "GQYG CK7B"
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
