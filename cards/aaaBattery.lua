local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; Grants a temporary effect of a random battery item for the rest of the floor
local Name = "AAA Battery"
local Tag = "aaaBattery"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.aaaBattery.Id, SoundEffect.SOUND_VAMP_GULP)
    items.aaaBattery.helpers.GivePlayerItem(p)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
