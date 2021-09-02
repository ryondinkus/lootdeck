local helper = include("helper_functions")

local Name = "Gold Bomb!!"
local Tag = "goldBomb"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	local data = p:GetData()
	data[Tag] = 1
end

local function MC_POST_PEFFECT_UPDATE(_, p)
	helper.StaggerSpawn(Tag, p, 15, 3, function(p)
		local target = helper.findRandomEnemy(p.Position) or 0
		if target ~= 0 then
			Isaac.Explode(target.Position, nil, 40)
		end
	end)
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
        },
		{
			ModCallbacks.MC_POST_PEFFECT_UPDATE,
			MC_POST_PEFFECT_UPDATE
		}
    }
}