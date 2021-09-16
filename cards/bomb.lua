local helper = include("helper_functions")

-- Explodes a random enemy or (if there are no enemies in the room) explodes the player
local Name = "Bomb!"
local Tag = "bomb"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 4

local function MC_USE_CARD(_, c, p)
	local target = helper.FindRandomEnemy(p.Position) or p
    Isaac.Explode(target.Position, nil, 40)
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