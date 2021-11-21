local helper = include("helper_functions")

-- 1/10 tears replaced with Worm Tears, which have endless range and create slowing creep on collision
local Names = {
    en_us = "Tape Worm",
    spa = "Gusano"
}
local Name = Names.en_us
local Tag = "tapeWorm"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "10% chance to fire a Worm Tear, which has endless range and spawns slowing creep",
    spa = "10% de posibilidad de lanzar una lágrima con efecto de gusano, con rango infinito y suelta rastro ralentizador"
}
local WikiDescription = helper.GenerateEncyclopediaPage("10% chance to fire a Worm Tear.", "- Worm Tears have endless range, and spawn a streak of slowing creep wherever they go.", "- Additional copies of the passive increase the chance up to 25%")

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

        if not tear:HasTearFlags(helper.NewTearflag(77)) then
            local animationToPlay = "RegularTear6"
            for i = 1,13 do
                if sprite:IsPlaying("RegularTear" .. tostring(i)) then
                    animationToPlay = "RegularTear" .. tostring(i)
                end
            end
            sprite:Load("gfx/tears/tapeworm tear.anm2", true)
            sprite:ReplaceSpritesheet(0, string.format("gfx/tears/tapeworm tear %s.png", spriteSheetDirection))
            sprite:LoadGraphics()
            sprite:Play(animationToPlay, true)
        end
    end
end

local function MC_POST_TEAR_UPDATE(_, tear)
    if tear:GetData()[Tag] then
        if Isaac.GetFrameCount() % 4 == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, tear.Position, Vector.Zero, tear)
            creep:GetSprite().Scale = Vector(1, 1) * 0.3
        end
        if tear.StickTarget then
            tear.FallingAcceleration = 0.1
        end
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
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
