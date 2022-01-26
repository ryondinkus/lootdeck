local card = lootcardKeys.fourCents

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Uses the card"
        },
        steps =
        {
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
    }
}