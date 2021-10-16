local helper = include("helper_functions")

local Name = "Charged Penny"
local Tag = "chargedPenny"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    helper.CustomCoinPrePickupCollision(pi, e, 1, SoundEffect.SOUND_PENNYPICKUP, function(p)
        p:FullCharge()
    end)
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    helper.CustomCoinPickupUpdate(pi, SoundEffect.SOUND_PENNYDROP)
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
        }
    }
}
