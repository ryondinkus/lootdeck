local card = lootcardKeys.pinkEye

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Pink Eye Debug + Debug 3",
            "Use card",
            "Spawn Spider",
            "Take damage"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
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
                type = EntityType.ENTITY_SPIDER
            },
            {
                action = "WAIT_FOR_KEY"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Projectile",
        instructions = {
            "Pink Eye Debug + Debug 3",
            "Use card",
            "Spawn Horf",
            "Take damage from projectile"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
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
                action = "WAIT_FOR_KEY"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."SelfDamage",
        instructions = {
            "Pink Eye Debug + Debug 3",
            "Use card",
            "Take damage from razor blade"
        },
        steps = {
            LootDeckAPI.SetDebugFlagStep(card.Tag, true),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
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
                id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
            },
            {
                action = "WAIT_FOR_KEY"
            },
            LootDeckAPI.ClearDebugFlagStep(card.Tag)
        }
    },
    {
        name = card.Tag.."Stacking",
        instructions = {
            "Use card three times",
            "Spawn Horf",
            "Take damage from Horf",
            "Repeat on same seed, using card once",
        },
        steps = {
            LootDeckAPI.ClearDebugFlagStep(card.Tag),
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "ETLF 8RK8"
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
                seed = "ETLF 8RK8"
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
