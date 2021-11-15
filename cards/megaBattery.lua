local helper = include('helper_functions')

-- Spawns a mega battery
local Names = {
    en_us = "Mega Battery",
    spa = "Mega Batería"
}
local Name = Names.en_us
local Tag = "megaBattery"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a Mega Battery",
    spa = "Genera una Mega batería"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Mega Battery on use.")

local function MC_USE_CARD(_, c, p)
	helper.SpawnEntity(p, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MEGA)
    lootdeck.sfx:Play(SoundEffect.SOUND_SHELLGAME,1,0)
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
