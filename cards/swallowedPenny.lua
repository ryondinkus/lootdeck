
local helper = include("helper_functions")
local items = include("items/registry")

local Name = "Swallowed Penny"
local Tag = "swallowedPenny"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Stacking support for multiple 50/50 rolls
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.swallowedPenny, SoundEffect.SOUND_VAMP_GULP)
end

local function MC_ENTITY_TAKE_DMG(_, e)
    local rng = lootdeck.rng
    if e:ToPlayer():HasCollectible(items.swallowedPenny) then
        for i=1,e:ToPlayer():GetCollectibleNum(items.swallowedPenny) do
            local effect = rng:RandomInt(2)
            if effect == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, (e.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        end
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}