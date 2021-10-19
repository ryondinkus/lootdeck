local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; 1/10 tears replaced with Worm Tears, which have endless range and create slowing creep on collision
local Name = "Tape Worm"
local Tag = "tapeWorm"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.tapeWorm.Id, SoundEffect.SOUND_VAMP_GULP)
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
