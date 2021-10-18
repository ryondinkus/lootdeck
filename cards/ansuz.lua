-- Teleport to Treasure Room, Shop, or Boss, with priority given to unvisited rooms
local Name = "Ansuz"
local Tag = "ansuz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

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
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
