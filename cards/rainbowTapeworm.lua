local helper = include('helper_functions')

-- trinket; 50% chance each room to grant a temporary copy of a random passive you already have
local Name = "Rainbow Tapeworm"
local Tag = "rainbowTapeworm"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)

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
