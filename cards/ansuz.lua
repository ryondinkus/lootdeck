-- Teleport to Treasure Room, Shop, or Boss, with priority given to unvisited rooms
local Name = "Ansuz"
local Tag = "ansuz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Teleport to either the Treasure Room, Shop, or Boss Room# Priority is given to unvisited rooms"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Random teleport to either the Treasure Room, Shop, or Boss Room."},
                            {str = "- Unvisited rooms are prioritized."},
                            {str = "- On floors with no Treasure Rooms, Shops, or Bosses, teleports you to a random room."},
						}}

local function MC_USE_CARD(_, c, p)
    local level = Game():GetLevel()
    local roomIndexes = {
        level:QueryRoomTypeIndex(RoomType.ROOM_SHOP, false, lootdeck.rng),
        level:QueryRoomTypeIndex(RoomType.ROOM_TREASURE, false, lootdeck.rng),
        level:QueryRoomTypeIndex(RoomType.ROOM_BOSS, false, lootdeck.rng)
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

    Game():StartRoomTransition(finalRoomIndexes[lootdeck.rng:RandomInt(#finalRoomIndexes) + 1], Direction.NO_DIRECTION, RoomTransitionAnim.TELEPORT)
    return false
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
