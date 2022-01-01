local Name = "Lost Bomb"
local Tag = "lostBomb"
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
    Callbacks = {
        {
            ModCallbacks.MC_POST_EFFECT_UPDATE,
            MC_POST_EFFECT_UPDATE,
            Id
        }
    }
}