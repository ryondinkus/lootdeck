local card = lootcardKeys.theTower

return {
	{
		name = card.Tag.."Use",
		instructions = {
			"Spawn Horf",
			"Use card"
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
				action = "SPAWN",
				type = EntityType.ENTITY_HORF
			},
			{
				action = "WAIT_FOR_SECONDS",
				seconds = 1
			},
			{
				action = "USE_CARD"
			}
		}
	},
	{
		name = card.Tag.."Multiple",
		instructions = {
			"Go to new room",
			"Use card",
			"Repeat on same seed"
		},
		steps = {
			{
				action = "REPEAT",
				times = 2,
				steps = {
					{
						action = "RESTART",
						id = PlayerType.PLAYER_ISAAC,
						seed = "2444 XYSA"
					},
					{
						action = "GIVE_CARD",
						id = card.Id
					},
					{
						action = "GO_TO_DOOR",
						slot = DoorSlot.UP0
					},
					{
						action = "WAIT_FOR_SECONDS",
						seconds = 1
					},
					{
						action = "USE_CARD"
					},
					{
						action = "WAIT_FOR_SECONDS",
						seconds = 2
					}
				}
			}
		}
	}
}
