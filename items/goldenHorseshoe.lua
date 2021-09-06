local helper = include("helper_functions")

-- Spawns a glitch item in every treasure room
local Name = "Golden Horseshoe"
local Tag = "goldenHorseshoe"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_NEW_ROOM()
    local game = Game()
	local level = game:GetLevel()
    local room = game:GetRoom()
	local roomIndex = level:GetCurrentRoomIndex()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(Id) and room:GetType() == RoomType.ROOM_TREASURE and not helper.TableContains(lootdeck.f.visitedItemRooms, roomIndex) then
            p:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
            p:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            table.insert(lootdeck.f.visitedItemRooms, roomIndex)
        end
    end
end

local function MC_POST_NEW_LEVEL()
	for k in pairs(lootdeck.f.visitedItemRooms) do
	    lootdeck.f.visitedItemRooms[k] = nil
	end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
