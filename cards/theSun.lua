local costumes = include("costumes/registry")

local Name = "XIX. The Sun"
local Tag = "theSun"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    lootdeck.f.sunUsed = true
    lootdeck.f.removeSun = true
    for i=0,3 do
        if p:GetCard(i) == Id then
            p:SetCard(i, 0)
        end
    end
    local entities = Isaac.GetRoomEntities()
    for i, entity in pairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_TAROTCARD
        and entity.SubType == Id then
            entity:Remove()
        end
    end
    if lootdeck.f.floorBossCleared then
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
    end
    p:AddNullCostume(costumes.sun)
    lootdeck.sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 1, 0)
end

local function MC_POST_NEW_ROOM()
    if lootdeck.f.removeSun then
        local entities = Isaac.GetRoomEntities()
        for i, entity in pairs(entities) do
            if entity.Type == EntityType.ENTITY_PICKUP
            and entity.Variant == PickupVariant.PICKUP_TAROTCARD
            and entity.SubType == Id then
                entity:Remove()
            end
        end
    end
end

local function MC_POST_UPDATE()
    local level = Game():GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    if roomDesc.Clear and room:GetType() == RoomType.ROOM_BOSS then
        lootdeck.f.floorBossCleared = true
    end

    if lootdeck.f.floorBossCleared and lootdeck.f.sunUsed then
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
    end
end

local function MC_POST_NEW_LEVEL()
    if lootdeck.f.sunUsed then
        for i=0,Game():GetNumPlayers()-1 do
            Isaac.GetPlayer(i):TryRemoveNullCostume(costumes.sun)
        end
    end
    lootdeck.f.sunUsed = false
    lootdeck.f.floorBossCleared = false
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}