local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the cointerfeit penny item
local Name = "Counterfeit Penny"
local Tag = "counterfeitPenny"
local Id = Isaac.GetCardIdByName(Name)

-- TODO: Stacking support? extra pennies
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.counterfeitPenny.Id, SoundEffect.SOUND_VAMP_GULP)
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