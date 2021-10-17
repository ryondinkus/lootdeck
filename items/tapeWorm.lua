local helper = include("helper_functions")

-- 1/10 tears replaced with Worm Tears, which have endless range and create slowing creep on collision
local Name = "Tape Worm"
local Tag = "tapeWorm"
local Id = Isaac.GetItemIdByName(Name)

local function MC_POST_FIRE_TEAR(_, tear)
    local p = tear:GetLastParent():ToPlayer()
    if p:HasCollectible(Id) and helper.PercentageChance(10 * p:GetCollectibleNum(Id), 25) then
        tear.FallingSpeed = 0
        tear.FallingAcceleration = -0.1
        tear:GetData()[Tag] = true
    end
end

local function MC_POST_TEAR_UPDATE(_, tear)
    if tear:GetData()[Tag] and Isaac.GetFrameCount() % 4 == 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, tear.Position, Vector.Zero, tear)
        creep:GetSprite().Scale = Vector(1, 1) * 0.3
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_POST_FIRE_TEAR,
            MC_POST_FIRE_TEAR
        },
        {
            ModCallbacks.MC_POST_TEAR_UPDATE,
            MC_POST_TEAR_UPDATE
        }
    }
}
