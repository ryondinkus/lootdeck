local helper = LootDeckHelpers
local entityVariants = include("entityVariants/registry")

-- Grants Steam Sale effect for the floor + little card familiar
local Names = {
    en_us = "Two of Diamonds",
    spa = "Dos de Diamantes"
}
local Name = Names.en_us
local Tag = "twoOfDiamonds"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants the {{Collectible64}} Steam Sale effect for the floor, causing all shop items to be half price",
    spa = "Otorga el efecto de las {{Collectible64}} Ofertas de Steam durante el piso"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants the Steam Sale effect for the floor, causing shop items to be sold at half price.", "Holographic Effect: Grants two Steam Sale effects.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData().lootdeck
    local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
    p:AddCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE, 0, false)
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
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
