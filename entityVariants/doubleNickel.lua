local helper = LootDeckHelpers

local Name = "Double Nickel"
local Tag = "doubleNickel"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    helper.CustomCoinPrePickupCollision(pi, e, 10, SoundEffect.SOUND_NICKELPICKUP)
end

local function MC_POST_PICKUP_UPDATE(_, pi)
    helper.CustomCoinPickupUpdate(pi, SoundEffect.SOUND_NICKELDROP)
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
