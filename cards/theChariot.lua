local helper = include("helper_functions")

-- Gain .50 damage for the room for each heart
local Name = "VII. The Chariot"
local Tag = "theChariot"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Add compatibility for Tainted Forgotten
-- T. Forgor gets the extra heart but no damage, because the damage scales based on pile-o-bones
-- Needs twin() shenanigans to fix
local function MC_USE_CARD(_, c, p)
    helper.AddTemporaryHealth(p, 2)
    local data = p:GetData()
    if not data.chariot then data.chariot = true end
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_DAMAGE then
        if data.chariot then
            if helper.IsSoulHeartMarty(p) or p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
                p.Damage = p.Damage + (0.25 * p:GetSoulHearts())
            else
                p.Damage = p.Damage + (0.25 * p:GetHearts())
            end
        end
    end
end

local function MC_POST_NEW_ROOM()
    for i=0,Game():GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.chariot then
            data.chariot = false
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
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
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}