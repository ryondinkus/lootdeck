local card = lootcardKeys.dagaz

return {
    {
        name = card.Tag.."Use",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "USE_PILL",
                id = PillEffect.PILLEFFECT_AMNESIA
            },
            {
                action = "RUN_COMMAND",
                command = "curse 128"
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "ENABLE_DEBUG_FLAG",
                flag = 8
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_BLANK_CARD
            },
            {
                action = "REPEAT",
                times = 10,
                steps = {
                    {
                        action = "USE_ITEM"
                    }
                }
            }
        }
    }
}
