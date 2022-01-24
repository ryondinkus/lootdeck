local card = lootcardKeys.theHangedMan

return {
    {
        name = card.Tag.."Use",
        steps = {
            {
                action = "RESTART",
                id = PlayerType.PLAYER_ISAAC,
                seed = "QF4H QV36"
            },
            {
                action = "RUN_COMMAND",
                command = "stage 4"
            },
            {
                action = "GO_TO_DOOR",
                slot = DoorSlot.RIGHT0
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
