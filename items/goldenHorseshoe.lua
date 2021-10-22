local helper = include("helper_functions")

-- Spawns a glitch item in every treasure room
local Name = "Golden Horseshoe"
local Tag = "goldenHorseshoe"
local Id = Isaac.GetItemIdByName(Name)
local Description = "Every Treasure room has an additional {{Collectible721}} TMTRAINER item"
local WikiDescription = helper.GenerateEncyclopediaPage("Every Treasure room has an additional TMTRAINER item.")

local function MC_POST_NEW_ROOM()
    local game = Game()
	  local level = game:GetLevel()
    local room = game:GetRoom()
    local roomDescriptor = level:GetCurrentRoomDesc()
    local alreadySpawned = false
    helper.ForEachPlayer(function(p)
        if not alreadySpawned then
            if room:GetType() == RoomType.ROOM_TREASURE and roomDescriptor.VisitedCount <= 1 then
                p:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER, 0, false)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            end
        end
        alreadySpawned = true
    end, Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
