local helper = include("helper_functions")

local Name = "Bomb!"
local Tag = "bomb"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	local target = helper.findRandomEnemy(p.Position) or p
    Isaac.Explode(target.Position, nil, 40)
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