local helper = include('helper_functions')

local Name = "A Dime!!"
local Tag = "dime"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.CRACKED_ORB_POOF, 1)
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
            }
    }
}