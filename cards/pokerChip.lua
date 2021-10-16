local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; All penny spawns are either double pennies or nothing
local Name = "Poker Chip"
local Tag = "pokerChip"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.pokerChip.Id, SoundEffect.SOUND_VAMP_GULP)
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
