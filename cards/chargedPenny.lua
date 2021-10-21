local helper = include('helper_functions')
local entityVariants = include("entityVariants/registry")

-- Spawns a penny
local Name = "Charged Penny"
local Tag = "chargedPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Spawns a Charged Penny, which recharges your active on pickup"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "Spawns a Charged Penny on use. Charged Pennies are worth 1 cent and recharge your active item."},
						}}

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_PICKUP, entityVariants.chargedPenny.Id, 0, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 1)
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
