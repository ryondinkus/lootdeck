local helper = LootDeckAPI

-- Grants a temporary effect of a random battery item for the rest of the floor
local Names = {
    en_us = "AAA Battery",
    spa = "Batería AAA"
}
local Name = Names.en_us
local Tag = "aaaBattery"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "For each new floor, grants a random temporary battery item",
    spa = "Por cada piso, otorgará un objeto de batería aleatorio"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a random temporary battery item for each new floor.", "- Additional copies of the passive grant extra battery items.")

local function GivePlayerItem(p, data, rng)
    if not data then
        data = helper.GetLootDeckData(p)
    end
    local itemPool = Game():GetItemPool()
    local collectibleId
    local itemConfig

    if not rng then
        rng = lootdeck.rng
    end

    while (not collectibleId and not itemConfig) or itemConfig.Type == ItemType.ITEM_ACTIVE do
        collectibleId = itemPool:GetCollectible(ItemPoolType.POOL_BATTERY_BUM, false, rng:Next())
        itemConfig = Isaac.GetItemConfig():GetCollectible(collectibleId)
    end
    p:AddCollectible(collectibleId)
    if not data[Tag] then
        data[Tag] = {}
    end
    table.insert(data[Tag], collectibleId)
end

local function RemovePlayerItems(p, data)
    if not data then
        data = helper.GetLootDeckData(p)
    end
    if data[Tag] then
        for _,v in pairs(data[Tag]) do
            p:RemoveCollectible(v)
        end
        data[Tag] = nil
    end
end

local function MC_POST_NEW_LEVEL()
    helper.ForEachPlayer(function(p, data)
        RemovePlayerItems(p, data)
        for i=1,p:GetCollectibleNum(Id) do
            GivePlayerItem(p, data)
            data[Tag .. "Played"] = false
        end
    end, Id)
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local data = helper.GetLootDeckData(p)
    if data[Tag] and not data[Tag .. "Played"] and p:IsExtraAnimationFinished() then
        p:AnimateCollectible(data[Tag][#data[Tag]])
        lootdeck.sfx:Play(SoundEffect.SOUND_BATTERYCHARGE)
        data[Tag .. "Played"] = true
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
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
