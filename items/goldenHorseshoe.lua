local helper = lootdeckHelpers

-- Spawns a glitch item in every treasure room
local Names = {
    en_us = "Golden Horseshoe",
    spa = "Herradura Dorada"
}
local Name = Names.en_us
local Tag = "goldenHorseshoe"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions ={
    en_us =  "Every Treasure room has an additional {{Collectible721}} TMTRAINER item",
    spa = "Cada sala del tesoro tiene un objeto adicional de {{Collectible721}} ENTRENADOR TM"
}
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
                helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            end
        end
        alreadySpawned = true
    end, Id)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
