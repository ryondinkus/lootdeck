local card = lootcardKeys.chargedPenny

return {
    {
        name = card.Tag.."Use",
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
                action = "GIVE_CARD",
                id = card.Id
            },
            {
                action = "USE_CARD"
            }
        }
    }
}
