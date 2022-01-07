local helper = LootDeckAPI

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

local function GetSpriteSheetDirection(tear)
    local spriteSheetDirection
    local sprite = tear:GetSprite()
    if math.abs(tear.Velocity.X) > math.abs(tear.Velocity.Y) then
        spriteSheetDirection = "side"
        if tear.Velocity.X < 0 then
            sprite.FlipX = true
        else
            sprite.FlipX = false
        end
    elseif math.abs(tear.Velocity.Y) > math.abs(tear.Velocity.X) then
        if tear.Velocity.Y < 0 then
            spriteSheetDirection = "back"
        else
            spriteSheetDirection = "front"
        end
    end
    return spriteSheetDirection
end

local function MC_POST_FIRE_TEAR(_, tear)
    local p = tear:GetLastParent():ToPlayer()
    if p:HasCollectible(Id) and helper.PercentageChance(10 * p:GetCollectibleNum(Id), 25) then
        tear.FallingSpeed = -8
        tear.FallingAcceleration = 0
        tear:GetData()[Tag] = true
        tear:AddTearFlags(TearFlags.TEAR_BOUNCE)

        local sprite = tear:GetSprite()
        local spriteSheetDirection = GetSpriteSheetDirection(tear)

        if not tear:HasTearFlags(helper.ConvertBitSet64ToBitSet128(77)) then
            local animationToPlay = sprite:GetAnimation()
            sprite:Load("gfx/tears/tapeworm tear.anm2", true)
            sprite:ReplaceSpritesheet(0, string.format("gfx/tears/tapeworm tear %s.png", spriteSheetDirection))
            sprite:LoadGraphics()
            sprite:Play(animationToPlay, true)
        end
    end
end

local function MC_POST_TEAR_UPDATE(_, tear)
    if tear:GetData()[Tag] then
        local sprite = tear:GetSprite()
        if Isaac.GetFrameCount() % 15 == 0 then
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_WHITE, 0, tear.Position, Vector.Zero, tear)
            creep:GetSprite().Scale = Vector(1, 1) * 0.3
        end
        if tear.StickTarget then
            tear.FallingAcceleration = 0.1
        end
        sprite:ReplaceSpritesheet(0, string.format("gfx/tears/tapeworm tear %s.png", GetSpriteSheetDirection(tear)))
        sprite:LoadGraphics()
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
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
