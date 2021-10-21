local helper = include('helper_functions')
local items = include("items/registry")

-- trinket; 1/10 tears replaced with Worm Tears, which have endless range and create slowing creep on collision
local Name = "Tape Worm"
local Tag = "tapeWorm"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Adds a unique passive item on use# Passive: 10% chance to fire a Worm Tear, which has endless range and spawns slowing creep"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "On use, grants a unique passive item."},
							{str = "Passive effect: 10% chance to fire a Worm Tear."},
							{str = "- Worm Tears have endless range, and spawn a streak of slowing creep wherever they go."},
                            {str = "- Additional copies of the passive increase the chance up to 25%"},
						}}

local function MC_USE_CARD(_, c, p)
    helper.SimpleLootCardItem(p, items.tapeWorm.Id, SoundEffect.SOUND_VAMP_GULP)
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
