local costumes = include("costumes/registry")
local helper = include("helper_functions")

-- As soon as the floor boss is defeated, the floor will be restarted using the "Forget Me Now" effect
-- This card is only usable once per run
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
    if helper.CheckFinalFloorBossKilled() then
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

local function MC_PRE_SPAWN_CLEAN_AWARD()
	local level = Game():GetLevel()
	local room = level:GetCurrentRoom()
	local roomDesc = level:GetCurrentRoomDesc()

	if roomDesc.Clear and room:GetType() == RoomType.ROOM_BOSS then
		lootdeck.f.floorBossCleared = lootdeck.f.floorBossCleared + 1
	end

	if helper.CheckFinalFloorBossKilled() and lootdeck.f.sunUsed then
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
	lootdeck.f.floorBossCleared = 0
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
            ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD,
            MC_PRE_SPAWN_CLEAN_AWARD
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
