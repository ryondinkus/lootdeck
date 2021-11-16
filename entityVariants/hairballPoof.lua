local helper = include("helper_functions")

local Name = "Hairball Poof"
local Tag = "hairballPoof"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_POST_EFFECT_UPDATE(_, e)
    local effectData = e:GetData()
    local sprite = e:GetSprite()
    if effectData.player then
        helper.ForEachPlayer(function(p, data)
            if p.InitSeed == effectData.player then
                e.Position = p.Position - helper.GetPlayerSpriteOffset(p)
            end
        end)
    end
    if sprite:IsFinished("Idle") then
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
