local helper = include("helper_functions")
local entityVariants = include("entityVariants/registry")

-- Grants Steam Sale effect for the floor + little card familiar
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
	Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.diamondBaby.Id, 0, p.Position, Vector.Zero, p)
end

local function MC_POST_NEW_LEVEL()
    helper.ForEachPlayer(function(p, data)
        if data.sale then
            for j=1,data.sale do
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
            end
            data.sale = nil
        end
    end)
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
