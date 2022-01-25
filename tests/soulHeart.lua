local card = lootcardKeys.soulHeart

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Use card",
            "Spawn Horf",
            "Take damage from Horf"
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
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            }
        }
    },
    {
        name = card.Tag.."Remove",
        instructions = {
            "Use card",
            "Go to new room",
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
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "GO_TO_DOOR"
            }
        }
    },
    {
        name = card.Tag.."HolyMantle",
        instructions = {
            "Grant Holy Mantle",
            "Use card",
            "Take damage from Horf twice"
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
            "Take damage from Horf twice"
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
    },
    {
        name = card.Tag.."Hierophant",
        instructions = {
            "Use Hierophant",
            "Use card",
            "Take damage from Horf twice"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC
            },
            {
                action = "USE_CARD",
                id = lootcardKeys.theHierophant.Id
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
