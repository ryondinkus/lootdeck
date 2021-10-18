local helper = include("helper_functions")

-- 50% chance each room to grant a temporary copy of a random passive you already have
local Name = "Rainbow Tapeworm"
local Tag = "rainbowTapeworm"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)

        if data[Tag] then
            for _, id in pairs(data[Tag]) do
                p:RemoveCollectible(id)
            end
            data[Tag] = nil
        end

        for i=1,p:GetCollectibleNum(Id) do
            if helper.PercentageChance(50) then
                local itemId = helper.GetRandomItemIdInInventory(p, Id)
                if itemId then
                    p:AddCollectible(itemId)
                    p:AnimateCollectible(itemId, "UseItem")
                    lootdeck.sfx:Play(SoundEffect.SOUND_1UP, 1, 0)
                    if data[Tag] then
                        table.insert(data[Tag], itemId)
                    else
                        data[Tag] = { itemId }
                    end
                end
            end
        end
    end, Id)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
