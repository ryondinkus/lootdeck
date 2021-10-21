local helper = include("helper_functions")

-- 1/10 tears replaced with Worm Tears, which have endless range and create slowing creep on collision
local Name = "Tape Worm"
local Tag = "tapeWorm"
local Id = Isaac.GetItemIdByName(Name)
local Description = "10% chance to fire a Worm Tear, which has endless range and spawns slowing creep"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "10% chance to fire a Worm Tear."},
							{str = "- Worm Tears have endless range, and spawn a streak of slowing creep wherever they go."},
                            {str = "- Additional copies of the passive increase the chance up to 25%"},
						}}

local function MC_POST_FIRE_TEAR(_, tear)
    local p = tear:GetLastParent():ToPlayer()
    if p:HasCollectible(Id) and helper.PercentageChance(10 * p:GetCollectibleNum(Id), 25) then
        tear.FallingSpeed = 0
        tear.FallingAcceleration = -0.1
        tear:GetData()[Tag] = true

        local sprite = tear:GetSprite()
        local spriteSheetDirection

        if math.abs(tear.Velocity.X) > math.abs(tear.Velocity.Y) then
            spriteSheetDirection = "side"
            if tear.Velocity.X < 0 then
                sprite.FlipX = true
            end
        elseif math.abs(tear.Velocity.Y) > math.abs(tear.Velocity.X) then
            if tear.Velocity.Y < 0 then
                spriteSheetDirection = "back"
            else
                spriteSheetDirection = "front"
            end
        end

        sprite:ReplaceSpritesheet(0, string.format("gfx/tears/tapeworm tear %s.png", spriteSheetDirection))
        sprite:LoadGraphics()
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
    Description = Description,
    WikiDescription = WikiDescription,
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
