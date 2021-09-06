
local helper = include("helper_functions")
local items = include("items/registry")

-- Gives the Guppy's Hairball item
local Name = "Guppy's Hairball"
local Tag = "guppysHairball"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardItem(p, items.guppysHairball.Id, SoundEffect.SOUND_VAMP_GULP)
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