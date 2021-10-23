local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; Grants a temporary effect of a random battery item for the rest of the floor
local Name = "AAA Battery"
local Tag = "aaaBattery"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: For each new floor, grants a random temporary battery item"
local WikiDescription = helper.GenerateEncyclopediaPage("On use, grants a unique passive item.", "Passive effect: Grants a random temporary battery item for each new floor.", "- Additional copies of the passive grant extra battery items.")

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.aaaBattery.Id, SoundEffect.SOUND_VAMP_GULP)
    items.aaaBattery.helpers.GivePlayerItem(p)
    p:GetData()[Tag .. "Played"] = false
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
