local card = lootcardKeys.theFool

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Uses the card"
        },
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "A7AZ L4E3"
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
