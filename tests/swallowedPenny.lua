local card = lootcardKeys.swallowedPenny
local items = include("items/registry")

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Debug 3 + Dollar",
            "Uses card",
            "Razor Blade damage 5 times",
            "Uses card again",
            "Razor Blade damage 5 more times"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 3
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_DOLLAR
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
                times = 5,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
            {
                action = "GIVE_ITEM",
                id = items.swallowedPenny.Id
            },
            {
                action = "REPEAT",
                times = 5,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
        }
    },
    {
        name = card.Tag.."Broke",
        instructions = {
            "Debug 3",
            "Uses card",
            "Razor Blade damage 2 times"
        },
        steps = {
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
                action = "REPEAT",
                times = 2,
                steps = {
                    {
                        action = "USE_ITEM",
                        id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
                    }
                }
            },
        }
    },
    {
        name = card.Tag.."KindaBroke",
        instructions = {
            "Debug 3",
            "Uses card",
            "Grants Swallowed Penny directly (so no penny granted)",
            "Razor Blade damage"
        },
        steps = {
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
                action = "GIVE_ITEM",
                id = items.swallowedPenny.Id
            },
            {
                action = "USE_ITEM",
                id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
            }
        }
    },
    -- {
    --     name = card.Tag.."Cool",
    --     instructions = {
    --         "Deep Pockets + 10 Dollars",
    --         "Uses card 999 times",
    --         "Razor Blade damage",
    --     },
    --     steps = {
    --         {
    --             action = "RESTART",
    --             id = 0
    --         },
    --         {
    --             action = "GIVE_ITEM",
    --             id = CollectibleType.COLLECTIBLE_DEEP_POCKETS
    --         },
    --         {
    --             action = "REPEAT",
    --             times = 10,
    --             steps = {
    --                 {
    --                     action = "GIVE_ITEM",
    --                     id = CollectibleType.COLLECTIBLE_DOLLAR
    --                 }
    --             }
    --         },
    --         {
    --             action = "REPEAT",
    --             times = 999,
    --             steps = {
    --                 {
    --                     action = "GIVE_ITEM",
    --                     id = items.swallowedPenny.Id,
    --                     async = true
    --                 }
    --             }
    --         },
    --         {
    --             action = "USE_ITEM",
    --             id = CollectibleType.COLLECTIBLE_RAZOR_BLADE
    --         }
    --     }
    -- }
}
