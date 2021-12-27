local helper = LootDeckHelpers

local Name = "Double Lucky Penny"
local Tag = "doubleLuckyPenny"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    helper.CustomCoinPrePickupCollision(pi, e, 2, nil, function(p)
        local data = p:GetData().lootdeck
        local hud = Game():GetHUD()
        hud:ShowItemText("Lucky Pennies", "Luck Up")
        p:PlayExtraAnimation("Happy")
        lootdeck.sfx:Play(SoundEffect.SOUND_LUCKYPICKUP)
        lootdeck.sfx:Play(SoundEffect.SOUND_THUMBSUP_AMPLIFIED)
        if data[Tag] then
            data[Tag] = data[Tag] + 1
        else
            data[Tag] = 1
        end
        p:AddCacheFlags(CacheFlag.CACHE_LUCK)
        p:EvaluateItems()
    end)
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    helper.CustomCoinPickupUpdate(pi, SoundEffect.SOUND_PENNYDROP)
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = p:GetData().lootdeck
    if data[Tag] then
        p.Luck = p.Luck + (2 * data[Tag])
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION,
            Id
        },
        {
            ModCallbacks.MC_POST_PICKUP_UPDATE,
            MC_POST_PICKUP_UPDATE,
            Id
        },
        {
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE,
            CacheFlag.CACHE_LUCK
        }
    }
}
