local card = lootcardKeys.guppysHairball

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Guppys Hairball Debug enabled",
            "Use card",
            "Take damage from Horf (will block)"
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
        instructions = {
            "Guppys Hairball Debug enabled",
            "Use card",
            "Take damage from Blood Bank (won't block)"
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
        instructions = {
            "Guppys Hairball Debug enabled",
            "Use card",
            "Take damage from Dull Razor (won't block)"
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
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_DULL_RAZOR
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."IvBag",
        instructions = {
            "Guppys Hairball Debug enabled",
            "Use card",
            "Take damage from IV Bag (won't block)"
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
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_IV_BAG
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."CurseRoom",
        instructions = {
            "Guppys Hairball Debug enabled",
            "Use card",
            "Take damage from Curse Room (will block)"
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
        instructions = {
            "Guppys Hairball Debug enabled",
            "Use card",
            "Take damage from Sac Room (will block)"
        },
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
        instructions = {
            "Guppys Hairball Debug enabled",
            "Use card",
            "Take damage from buying Pound of Flesh item (won't block)"
        },
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
        instructions = {
            "Use card",
            "Take damage from Horf",
            "Restart on same seed, repeat"
        },
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
