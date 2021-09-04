local helper = include("helper_functions")

local Name = "II. The High Priestess"
local Tag = "theHighPriestess"
local Id = Isaac.GetCardIdByName(Name)

local function MC_USE_CARD(_, c, p)
	local data = p:GetData()
	data[Tag] = 1
end

local function MC_POST_PEFFECT_UPDATE(_, p)
    local ev = lootdeck.ev
    local rng = lootdeck.rng
	helper.StaggerSpawn(Tag, p, 15, rng:RandomInt(6)+1, function(p)
		local target = helper.findRandomEnemy(p.Position) or 0
		if target ~= 0 then
            local finger = Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.momsFinger, 0, target.Position, Vector(0,0), p)
            local fingerData = finger:GetData()
            fingerData.target = target
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