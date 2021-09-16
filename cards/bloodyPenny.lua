local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the bloody penny item
local Name = "Bloody Penny"
local Tag = "bloodyPenny"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Base on loot deck weights, support stacking with multiple players and items, cap at 50% droprate
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.bloodyPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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