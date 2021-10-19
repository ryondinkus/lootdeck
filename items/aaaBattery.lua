local helper = include("helper_functions")

-- Grants a temporary effect of a random battery item for the rest of the floor
local Name = "AAA Battery"
local Tag = "aaaBattery"
local Id = Isaac.GetItemIdByName(Name)

local function GivePlayerItem(p, data)
    if not data then
        data = p:GetData()
    end
    local itemPool = Game():GetItemPool()
    local collectibleId = itemPool:GetCollectible(ItemPoolType.POOL_BATTERY_BUM)
    p:AddCollectible(collectibleId)
    if data[Tag] then
        p:RemoveCollectible(data[Tag])
    end
    data[Tag] = collectibleId
    data[Tag .. "Played"] = false
end

local function MC_POST_NEW_LEVEL()
    helper.ForEachPlayer(function(p, data)
        for i=0,p:GetCollectibleNum(Id) do
            GivePlayerItem(p, data)
        end
    end, Id)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = p:GetData()
    if data[Tag] and not data[Tag .. "Played"] and p:IsExtraAnimationFinished() then
        p:AnimateCollectible(data[Tag])
        lootdeck.sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
        data[Tag .. "Played"] = true
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        },
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        }
    },
    helpers = {
        GivePlayerItem = GivePlayerItem
    }
}
