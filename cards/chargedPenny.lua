local helper = include('helper_functions')
local entityVariants = include("entityVariants/registry")

-- Spawns a penny
local Names = {
    en_us = "Charged Penny",
    spa = "Moneda Cargada"
}
local Name = Names.en_us
local Tag = "chargedPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a Charged Penny, which recharges your active on pickup",
    spa = "Genera un penny cargado, el cual recarga tu objeto activo al tomarlo"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Charged Penny on use. Charged Pennies are worth 1 cent and recharge your active item.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, entityVariants.chargedPenny.Id, 0, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 1)
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
            }
    }
}
