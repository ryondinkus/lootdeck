local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Cain's Eye item
local Name = "Cain's Eye"
local Tag = "cainsEye"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

-- TODO: Stacking support adds multiple mapping effects
local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.cainsEye.Id, SoundEffect.SOUND_VAMP_GULP)
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