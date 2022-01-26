local card = lootcardKeys.ehwaz

return {
        {
        name = card.Tag.."Use",
        instructions = {
            "Grant Spider Mod",
            "Spawns Horf",
            "Uses card"
        },
        steps = {
            {
                action = "RESTART",
                id = 0
            },
            {
                action = "GIVE_ITEM",
                id = CollectibleType.COLLECTIBLE_SPIDER_MOD
            },
            {
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "SPAWN",
                type = EntityType.ENTITY_HORF
            },
            {
                action = "USE_CARD"
            }
        }
    }
}
