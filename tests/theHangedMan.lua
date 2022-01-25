local card = lootcardKeys.theHangedMan

return {
    {
        name = card.Tag.."Use",
        instructions = {
            "Go to Caves room with holes",
            "Use card"
        },
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
