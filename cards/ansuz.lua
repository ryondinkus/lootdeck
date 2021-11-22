local helper = include("helper_functions")

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
local WikiDescription = helper.GenerateEncyclopediaPage("Random teleport to either the Treasure Room, Shop, or Boss Room.", "- Unvisited rooms are prioritized.", "- On floors with no Treasure Rooms, Shops, or Bosses, teleports you to a random room.", "Holographic Effect: None")

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
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
