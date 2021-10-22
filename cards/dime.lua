local helper = include('helper_functions')

-- Spawns a dime
local Name = "A Dime!!"
local Tag = "dime"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Spawns a Dime"
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Dime on use.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.CRACKED_ORB_POOF, 1)
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
            }
    }
}
