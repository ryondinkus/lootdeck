local Name = "Lost Penny"
local Tag = "lostPenny"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_POST_EFFECT_UPDATE(_, e)
    local sprite = e:GetSprite()
    if sprite:IsEventTriggered("Remove") then
        e:Remove()
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_EFFECT_UPDATE,
            MC_POST_EFFECT_UPDATE,
            Id
        }
    }
}