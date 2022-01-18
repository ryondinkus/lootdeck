function LootDeckAPI.AreEnemiesInRoom()
    return #LootDeckAPI.ListEnemiesInRoom(true, function(entity) return not EntityRef(entity).IsCharmed end) > 0
end

function LootDeckAPI.GetSecretRoomDoorPosition(room)
    if not room then
        room = Game():GetRoom()
    end
    for i=0,7 do
        local door = room:GetDoor(i)
        if door ~= nil then
            if (door:IsRoomType(RoomType.ROOM_SECRET) or door:IsRoomType(RoomType.ROOM_SUPERSECRET)) and door:GetSprite():GetAnimation() == "Hidden" then
                return door.Position
            end
        end
    end
end

function LootDeckAPI.GetTintedRockPosition(room)
    if not room then
        room = Game():GetRoom()
    end
    for i=0,room:GetGridSize() do
        local rock = room:GetGridEntity(i)
        if rock then
            if rock.CollisionClass ~= 0 and (rock:GetType() == GridEntityType.GRID_ROCKT or rock:GetType() == GridEntityType.GRID_ROCK_SS) then
                return room:GetGridPosition(i)
            end
        end
    end
end

-- helper function for GlyphOfBalance(), makes shit less ocopmlicationsed
function LootDeckAPI.AreTrinketsOnGround()
    local isTrinketOnGround = false
    LootDeckAPI.ForEachEntityInRoom(function()
        isTrinketOnGround = true
    end, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET)
    return isTrinketOnGround
end

function LootDeckAPI.OpenAllDoors(p, force, revealSecretDoors, room)
    if not room then
        room = Game():GetRoom()
    end
    if force == nil then
        force = true
    end
    if revealSecretDoors == nil then
        revealSecretDoors = true
    end
	for i=0, DoorSlot.NUM_DOOR_SLOTS - 1 do
		local door = room:GetDoor(i)
		if door then
			if door:IsLocked() then
				door:TryUnlock(p, force)
			end
			if revealSecretDoors and (door:IsRoomType(RoomType.ROOM_SECRET) or door:IsRoomType(RoomType.ROOM_SUPERSECRET)) and door:GetSprite():GetAnimation() == "Hidden" then
				door:TryBlowOpen(true, p)
			end
            door:Open()
		end
	end
end

function LootDeckAPI.IsFinalFloorBossKilled()
	local level = Game():GetLevel()
	local labyrinth = level:GetCurses() & LevelCurse.CURSE_OF_LABYRINTH > 0
	if (lootdeck.f.floorBossCleared == 1 and not labyrinth)
	or (lootdeck.f.floorBossCleared == 2 and labyrinth) then
		return true
	end
	return false
end

function LootDeckAPI.IsInChallenge(challengeName)
    local challengeId = Isaac.GetChallengeIdByName(challengeName)
    return Isaac.GetChallenge() == challengeId
end