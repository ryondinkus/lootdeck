local helper = include('helper_functions')

local Names = {
    en_us = "Gimme the Loot",
    spa = "Dame el botín"
}
local Name = Names.en_us
local Tag = "gimmeTheLoot"
local Id = Isaac.GetChallengeIdByName(Name)

local function MC_POST_PICKUP_UPDATE(_, entity)
    if Isaac.GetChallenge() == Id and Isaac.GetFrameCount() % 2 == 0 and (entity:GetSprite():IsPlaying("Appear") or entity.Price ~= 0) and entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE and entity.Variant ~= PickupVariant.PICKUP_TROPHY and not entity:GetData()[Tag] then
        if not helper.GetLootcardById(entity.SubType) then
            local pickup = helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, helper.GetWeightedLootCardId(), entity.Position, entity.Velocity, entity.SpawnerEntity):ToPickup()
            pickup.Price = entity.Price
            entity:Remove()
        end
    end
end

local function MC_PRE_PICKUP_COLLISION(_, pickup, entity)
    if Isaac.GetChallenge() == Id then
        local player = entity:ToPlayer()
        if player then
            local data = player:GetData()
            if not data[Tag] then
                lootdeck.unlocks[Tag] = true
                data[Tag] = true
                helper.SaveGame()
            end
        end
    end
end

local function MC_POST_NEW_ROOM()
    for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
        local door = Game():GetRoom():GetDoor(i)
        
        if door and door:IsRoomType(RoomType.ROOM_SHOP) then
            door:TryUnlock(Isaac.GetPlayer(0), true)
        end
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE
        },
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
            PickupVariant.PICKUP_TROPHY
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}