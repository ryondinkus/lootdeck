local helper = include('helper_functions')
local costumes = include("costumes/registry")

local Name = "XI. Strength"
local Tag = "strength"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_D7)

    local data = p:GetData()
    local sprite = p:GetSprite()
    if not data.strength then data.strength = 1
    else
        data.strength = data.strength + 1
    end
    for i=1,data.strength or 0 do
        local color = Color(1,1,1,1,data.strength/10,0,0)
        sprite.Color = color
    end
	p:AddNullCostume(costumes.strengthFire)
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
    lootdeck.sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 1, 0)
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_DAMAGE then
        if data.strength then
            p.Damage = p.Damage + (0.5 * data.strength)
        end
    end
end

local function MC_POST_NEW_ROOM()
	for x=0,Game():GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if data.strength then
			p:TryRemoveNullCostume(costumes.strengthFire)
			p:AddNullCostume(costumes.strengthGlow)
        end
    end
end

local function MC_POST_NEW_LEVEL()
    for x=0,Game():GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if data.strength then
            data.strength = nil
            local color = Color(1,1,1,1,0,0,0)
            p.Color = color
			p:TryRemoveNullCostume(costumes.strengthFire)
			p:TryRemoveNullCostume(costumes.strengthGlow)
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
		},
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
