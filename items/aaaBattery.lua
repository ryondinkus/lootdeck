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

end

local function MC_POST_NEW_LEVEL()
    helper.ForEachPlayer(GivePlayerItem, Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    },
    helpers = {
        GivePlayerItem = GivePlayerItem
    }
}
