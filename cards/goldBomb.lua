local helper = include("helper_functions")

-- Explodes three random enemies in the room
local Name = "Gold Bomb!!"
local Tag = "goldBomb"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
	local data = p:GetData()
	if not helper.AreEnemiesInRoom(Game():GetRoom()) then
		Isaac.Explode(p.Position, nil, 40)
	else
		data[Tag] = 1
	end
end

-- TODO make it so it only explodes once on enemies that withstand damage
-- if used with no enemies in room, explode on player (ONLY IF FIRST EXPLOSION)
local function MC_POST_PEFFECT_UPDATE(_, p)
	helper.StaggerSpawn(Tag, p, 15, 3, function(p)
		local target = helper.FindRandomEnemy(p.Position) or 0
		if target ~= 0 then
			Isaac.Explode(target.Position, nil, 40)
		end
	end)
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
        },
		{
			ModCallbacks.MC_POST_PEFFECT_UPDATE,
			MC_POST_PEFFECT_UPDATE
		}
    }
}
