local helper = LootDeckAPI
local costumes = include("costumes/registry")

-- Fires two tears at once with a demon costume and red tears for the room
local Names = {
    en_us = "III. The Empress",
    spa = "III. La Emperatriz"
}
local Name = Names.en_us
local Tag = "theEmpress"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{ArrowUp}} * 1.3 damage multiplier# Grants the {{Collectible245}} 20/20 effect for the room, allowing you to shoot two tears at once",
    spa = "{{ArrowUp}} Multiplicador de daño x1.3# Otorga el efecto de {{Collectible245}} 20/20 durante la habitación"
}
local HolographicDescriptions = {
    en_us = "{{ArrowUp}} * 1.3 damage multiplier# Grants {{ColorRainbow}}2{{CR}} {{Collectible245}} 20/20 effects for the room, allowing you to shoot {{ColorRainbow}}three{{CR}} tears at once",
    spa = "{{ArrowUp}} Multiplicador de daño x1.3# Otorga {{ColorRainbow}}2{{CR}} efectos de {{Collectible245}} 20/20 durante la habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a x1.3 Damage multiplier and the 20/20 effect for the room, allowing you to shoot two tears at once.", "Holographic Effect: Grants a triple shot with thinner range.")

local function MC_USE_CARD(_, c, p)
    local data = helper.GetLootDeckData(p)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_20_20)
    p:AddCollectible(CollectibleType.COLLECTIBLE_20_20, 0, false)
    if not data.empress then data.empress = 1
    else data.empress = data.empress + 1 end
    if data.empress >= p:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) then
        p:RemoveCostume(itemConfig)
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A, 1, 0)
    p:AddNullCostume(costumes.empress)
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_TEARCOLOR)
    p:EvaluateItems()
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = helper.GetLootDeckData(p)
    if f == CacheFlag.CACHE_DAMAGE then
        if data.empress and p:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) <= data.empress then
            p.Damage = p.Damage * 1.334
        end
    end
	if f == CacheFlag.CACHE_TEARCOLOR then
		if data.empress then
			local color = Color(1,1,1,1,0,0,0)
			color:SetColorize(0.8,0,0,1)
			p.TearColor = color
		end
	end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data.empress then
            for j=1,data.empress do
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_20_20)
            end
            data.empress = nil
            p:TryRemoveNullCostume(costumes.empress)
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_TEARCOLOR)
            p:EvaluateItems()
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
    HolographicDescriptions = HolographicDescriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        },
        {
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
