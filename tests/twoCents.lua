local card = lootcardKeys.twoCents

return {
    {
        action = "RESTART",
        id = 0
    },
    {
        action = "GIVE_CARD",
        id = card.Id
    },
    {
        action = "USE_CARD"
    }
}
