local helper = include("helper_functions")

-- A 1 in 3 chance of recharging your active item, +1 firerate, or -1 firerate
local Names = {
    en_us = "Pills! Purple",
    spa = "¡Píldora! Púrpura"
}
local Name = Names.en_us
local Tag = "purplePill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:#{{Battery}} Recharge your active item#{{ArrowUp}} +0.27 Tears for the room#{{ArrowDown}} -0.27 Tears for the room",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{Battery}} Recarga tu objeto activo#{{ArrowUp}} +0.27 de lágrimas durante la habitación#{{ArrowDown}} -0.27 de lágrimas durante la habitación)"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Recharge one of your active items (+6 charge).", "- +0.27 Tears for the room.", "- -0.27 Tears for the room.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
	local sfx = lootdeck.sfx
	local data = p:GetData()

    helper.RandomChance(shouldDouble,
    function()
        if (f & UseFlag.USE_MIMIC ~= 0) then
            data[Tag .. "Charge"] = true
        else
            helper.AddActiveCharge(p, 6, true)
        end
    end,
    function()
        sfx:Play(SoundEffect.SOUND_THUMBSUP,1,0)
        if not data[Tag] then
            data[Tag] = 0
        end
        data[Tag] = data[Tag] - 1
		p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		p:EvaluateItems()
    end,
    function()
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
        if not data[Tag] then
            data[Tag] = 0
        end
        data[Tag] = data[Tag] + 1
		p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
		p:EvaluateItems()
    end)
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        data[Tag] = nil
        p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
        p:EvaluateItems()
    end)
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData()
    if f == CacheFlag.CACHE_FIREDELAY then
        if data[Tag] then
            p.MaxFireDelay = p.MaxFireDelay + data[Tag]
        end
    end
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    if p:GetData()[Tag.."Charge"] then
        helper.AddActiveCharge(p, 6, true)
        p:GetData()[Tag.."Charge"] = nil
    end
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
            Id
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
		{
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        },
        {
            ModCallbacks.MC_POST_PEFFECT_UPDATE,
            MC_POST_PEFFECT_UPDATE
        }
    }
}
