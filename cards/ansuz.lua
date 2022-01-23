local helper = LootDeckAPI

-- Teleport to Treasure Room, Shop, or Boss, with priority given to unvisited rooms
local Names = {
    en_us = "Ansuz",
    spa = "Ansuz"
}
local Name = Names.en_us
local Tag = "ansuz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Teleport to either the Treasure Room, Shop, or Boss Room# Priority is given to unvisited rooms",
    spa = "Te teletransporta a la Sala del Tesoro, la Tienda o la Sala del jefe#Se le da prioridad a salas no visitadas"
}
local HolographicDescriptions = {
    en_us = "Teleport to either the Treasure Room, Shop, or Boss Room# Priority is given to unvisited rooms# {{ColorRainbow}}Grants {{Collectible21}} The Compass effect for the floor",
    spa = "Te teletransporta a la Sala del Tesoro, la Tienda o la Sala del jefe#Se le da prioridad a salas no visitadas# {{ColorRainbow}}Otorga el efecto de {{Collectible21}} La Brújula durante el piso"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Random teleport to either the Treasure Room, Shop, or Boss Room.", "- Unvisited rooms are prioritized.", "- On floors with no Treasure Rooms, Shops, or Bosses, teleports you to a random room.", "Holographic Effect: Grants the Compass effect.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
    local level = Game():GetLevel()
    local roomIndexes = {
        level:QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, rng),
        level:QueryRoomTypeIndex(RoomType.ROOM_TREASURE, false, rng),
        level:QueryRoomTypeIndex(RoomType.ROOM_BOSS, false, rng)
    }

    local finalRoomIndexes = {}

    for _, roomIndex in pairs(roomIndexes) do
        if level:GetRoomByIdx(roomIndex).VisitedCount <= 0 then
            table.insert(finalRoomIndexes, roomIndex)
        end
    end

    if #finalRoomIndexes <= 0 then
        for _, roomIndex in pairs(roomIndexes) do
            if level:GetRoomByIdx(roomIndex).Data.Type == RoomType.ROOM_BOSS or level:GetRoomByIdx(roomIndex).Data.Type == RoomType.ROOM_TREASURE or level:GetRoomByIdx(roomIndex).Data.Type == RoomType.ROOM_SHOP then
                table.insert(finalRoomIndexes, roomIndex)
            end
        end
    end

    if #finalRoomIndexes <= 0 then
        finalRoomIndexes = roomIndexes
    end

    Game():StartRoomTransition(finalRoomIndexes[rng:RandomInt(#finalRoomIndexes) + 1], Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)

	if shouldDouble then
		level:ApplyCompassEffect()
	end

    return false
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    },
    Tests = function()
        return {
            {
                name = Tag.."Use",
                steps = {
                    {
                        action = "REPEAT",
                        times = 2,
                        steps = {
                            {
                                action = "RESTART",
                                id = PlayerType.PLAYER_ISAAC,
                                seed = "NWHG BHV3"
                            },
                            {
                                action = "GIVE_CARD",
                                id = Id
                            },
                            {
                                action = "USE_CARD"
                            },
                            {
                                action = "WAIT_FOR_SECONDS",
                                seconds = 1
                            }
                        }
                    }
                }
            },
            {
                name = Tag.."Boss",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "NWHG BHV3"
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 10
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.DOWN0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.RIGHT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.RIGHT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.UP0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
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
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            },
            {
                name = Tag.."Explore",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "NWHG BHV3"
                    },
                    {
                        action = "ENABLE_DEBUG_FLAG",
                        flag = 10
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.DOWN0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.RIGHT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.RIGHT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.UP0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.LEFT0
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
                        action = "USE_CARD",
                        id = Card.CARD_EMPEROR
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 1
                    }
                }
            }
        }
    end
}
