local card = lootcardKeys.soulHeart

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
    },
    {
        name = card.Tag.."Hierophant",
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
