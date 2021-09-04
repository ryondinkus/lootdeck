local Name = "Mom's Finger"
local Tag = "lostBomb"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_POST_EFFECT_UPDATE(_, e)
    local data = e:GetData()
    local sprite = e:GetSprite()
    if data.target then
        local target = data.target
        e.Position = target.Position
        if sprite:IsEventTriggered("Land") then
            target:TakeDamage(40, 0, EntityRef(e), 0)
            data.target = nil
        end
    end
    if sprite:IsFinished("JumpDown") then
        sprite:Play("JumpUp", true)
    end
    if sprite:IsFinished("JumpUp") then
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