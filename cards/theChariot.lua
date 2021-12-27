local helper = LootDeckHelpers
local costumes = include("costumes/registry")

-- Gain .50 damage for the room for each heart
local Names = {
    en_us = "VII. The Chariot",
    spa = "VII. El carro"
}
local Name = Names.en_us
local Tag = "theChariot"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{Heart}} +1 Heart Container for the room# {{ArrowUp}} +0.5 damage for every Heart Container you have",
    spa = "{{Heart}} +1 contenedor de corazón durante la habitación# {{ArrowUp}} +0.5 de daño por cada contenedor de corazón que tengas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants a temporary Heart Container for the room.", "Adds +0.5 Damage for every Heart Container you have for the duration of the room.", "Holographic Effect: Grants an extra Heart Container.")

local function MC_USE_CARD(_, c, p)
    helper.AddTemporaryHealth(p, 2)
    local data = p:GetData().lootdeck
    if not data.chariot then data.chariot = true end
    p:AddNullCostume(costumes.chariot)
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData().lootdeck
    if f == CacheFlag.CACHE_DAMAGE then
        if data.chariot then
            if helper.IsSoulHeartFarty(p) or p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
                p.Damage = p.Damage + (0.25 * p:GetSoulHearts())
            else
                p.Damage = p.Damage + (0.25 * p:GetHearts())
            end
        end
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data.chariot then
            data.chariot = nil
            p:TryRemoveNullCostume(costumes.chariot)
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
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
    WikiDescription = WikiDescription,
    callbacks = {
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
