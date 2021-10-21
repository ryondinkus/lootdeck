local costumes = include("costumes/registry")
local helper = include("helper_functions")

-- As soon as the floor boss is defeated, the floor will be restarted using the "Forget Me Now" effect
-- This card is only usable once per run
local Name = "XIX. The Sun"
local Tag = "theSun"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "If used, defeating the boss of this floor triggers the {{Collectible127}} Forget Me Now effect, restarting the floor# The effect will also trigger on use if the boss of this floor is already defeated# After using, all other instances of the card are removed and cannot be found for the rest of the run"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
                            {str = "After using, defeating the boss of the current floor triggers the Forget Me Now effect, which restarts the floor."},
                            {str = "- The effect will also trigger on use if the current floor's boss is already defeated."},
                            {str = "On use, all other instances of this card are removed and cannot be found for the rest of the run."},
						}}

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    lootdeck.f.sunUsed = true
    lootdeck.f.removeSun = true
    for i=0,3 do
        if p:GetCard(i) == Id then
            p:SetCard(i, 0)
        end
    end
    helper.ForEachEntityInRoom(function(entity) entity:Remove() end, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Id)
    if helper.CheckFinalFloorBossKilled() then
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
    end
    p:AddNullCostume(costumes.sun)
    lootdeck.sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 1, 0)
end

local function MC_POST_UPDATE()
    if lootdeck.f.removeSun then
        helper.ForEachEntityInRoom(function(entity) entity:Remove() end, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, Id)
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
        helper.ForEachPlayer(function(p)
            p:TryRemoveNullCostume(costumes.sun)
        end)
    end
    lootdeck.f.sunUsed = false
	lootdeck.f.floorBossCleared = 0
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
        },
        {
            ModCallbacks.MC_POST_UPDATE,
            MC_POST_UPDATE
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
