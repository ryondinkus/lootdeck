local costumes = include("costumes/registry")

-- Fires two tears at once with a demon costume and red tears for the room
local Name = "Two of Diamonds"
local Tag = "twoOfDiamonds"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
    p:AddCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
    if not data.sale then data.sale = 1
    else data.sale = data.sale + 1 end
    if data.sale >= p:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) then
        p:RemoveCostume(itemConfig)
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0)
end

local function MC_POST_NEW_LEVEL()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.sale then
            for j=1,data.sale do
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
            end
            data.sale = nil
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
