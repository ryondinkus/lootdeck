local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Temporary tears up and brain worm effect for the room, as well as a brain costume
local Name = "I. The Magician"
local Tag = "theMagician"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "{{ArrowUp}} +0.27 Tears Up for the room# Grants the {{Trinket144}} Brain Worm effect for the room, causing your tears to turn 90 degrees and hit enemies"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Grants a +0.31 Tears Up and the Brain Worm effect for the room, which causes your tears to turn 90 degrees to hit enemies."},
						}}

-- If it ever gets fixed, AddTrinketEffect() would be better here
local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    if not data.magician then data.magician = 1
    else data.magician = data.magician + 1 end
	p:AddNullCostume(costumes.magician)
    p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR | CacheFlag.CACHE_TEARFLAG)
    p:EvaluateItems()
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_FIREDELAY then
        if data.magician then
            p.MaxFireDelay = p.MaxFireDelay - (data.magician)
        end
    end
    if f == CacheFlag.CACHE_TEARCOLOR then
        if data.magician then
            local tearColor = Color(1,1,1,1,0,0,0)
            tearColor:SetColorize(1,1,1,1)
			local laserColor = Color(1,1,1,1,1,1,1)
            p.TearColor = tearColor
			p.LaserColor = laserColor
        end
    end
	if f == CacheFlag.CACHE_TEARFLAG then
        if data.magician then
            p.TearFlags = p.TearFlags | helper.NewTearflag(71)
        end
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data.magician then
            data.magician = nil
			p:TryRemoveNullCostume(costumes.magician)
            p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR | CacheFlag.CACHE_TEARFLAG)
            p:EvaluateItems()
        end
    end)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
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
