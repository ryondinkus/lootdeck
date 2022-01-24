local card = lootcardKeys.theMoon

return {
    {
        name = card.Tag.."Use",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "LYCX QE8E"
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
                seconds = 4
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.DOWN0
            },
            {
                action = "WAIT_FOR_SECONDS",
                seconds = 1
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.UP0
            }
        }
    }
}
