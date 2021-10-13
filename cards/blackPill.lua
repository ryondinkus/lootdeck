local helper = include('helper_functions')

-- Instakill all enemies in room (80 dmg on bosses) | Confuse all enemies in room | Deal full heart of damage
local Name = "Pills! Black"
local Tag = "blackPill"
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
