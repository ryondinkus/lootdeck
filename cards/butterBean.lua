local helper = include('helper_functions')

-- Farts
local Name = "Butter Bean!"
local Tag = "butterBean"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 2
local Description = "Creates a {{Collectible294}} Butter Bean fart, which knocks back enemies."
local WikiDescription = helper.GenerateEncyclopediaPage("Does a Butter Bean fart on use, which knocks back enemies and deals damage if they hit walls.")

local function MC_USE_CARD(_, c, p)
	helper.SimpleLootCardEffect(p, CollectibleType.COLLECTIBLE_BUTTER_BEAN)
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
