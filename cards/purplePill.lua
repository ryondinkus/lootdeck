local helper = include("helper_functions")

-- A 1 in 3 chance of recharging your active item, +1 firerate, or -1 firerate
local Name = "Pills! Purple"
local Tag = "purplePill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	local sfx = lootdeck.sfx
	local effect = 2-- rng:RandomInt(3)
	local data = p:GetData()
	if effect == 0 then
		p:FullCharge()
	else
		if effect == 1 then
			data[Tag] = 1
			sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
		else
			data[Tag] = -1
			sfx:Play(SoundEffect.SOUND_THUMBSUP,1,0)
		end
		p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		p:EvaluateItems()
	end
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_FIREDELAY then
        if data[Tag] then
            p.MaxFireDelay = p.MaxFireDelay + (data[Tag])
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
    }
}