function LootDeckAPI.CreateSprite(animationPath, spritesheetPath, animationName)
	local sprite = Sprite()
	sprite:Load(animationPath, true)
	sprite:Play(animationName and animationName or sprite:GetDefaultAnimationName(), true)
	sprite:Update()
	if spritesheetPath then
        sprite:ReplaceSpritesheet(0, spritesheetPath)
    end
	sprite:LoadGraphics()

	return sprite
end

local FIRST_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(1.5, 0.5),
    [2] = Vector(3, 1),
    [3] = Vector(5, 2),
    [4] = Vector(6.5, 2.5),
    [5] = Vector(8, 3),
    [6] = Vector(9.5, 3.5),
    [7] = Vector(11, 4),
    [8] = Vector(13, 5),
    [9] = Vector(14.5, 5.5),
    [10] = Vector(16, 6)
}

local SECOND_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(-2.5, 1),
    [2] = Vector(-5, 2.5),
    [3] = Vector(-7, 3.5),
    [4] = Vector(-9.5, 5),
    [5] = Vector(-12, 6),
    [6] = Vector(-14.5, 7),
    [7] = Vector(-17, 8.5),
    [8] = Vector(-19, 9.5),
    [9] = Vector(-21.5, 11),
    [10] = Vector(-24, 12)
}

local THIRD_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(2.5, -0.5),
    [2] = Vector(5, -1),
    [3] = Vector(7, -2),
    [4] = Vector(9.5, -2.5),
    [5] = Vector(11.5, -3),
    [6] = Vector(13.5, -3.5),
    [7] = Vector(16, -4),
    [8] = Vector(18, -5),
    [9] = Vector(20.5, -5.5),
    [10] = Vector(22.5, -6)
}

local FOURTH_PLAYER_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(2.5, 1),
    [2] = Vector(4, 1.5),
    [3] = Vector(6, 2.5),
    [4] = Vector(7.5, 3),
    [5] = Vector(9, 3.5),
    [6] = Vector(10.5, 4),
    [7] = Vector(12, 4.5),
    [8] = Vector(14, 5.5),
    [9] = Vector(15.5, 6),
    [10] = Vector(17, 6.5)
}

local JACOB_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(2, 1),
    [2] = Vector(4, 2.5),
    [3] = Vector(6, 3.5),
    [4] = Vector(8, 5),
    [5] = Vector(10, 6),
    [6] = Vector(12, 7),
    [7] = Vector(14, 8.5),
    [8] = Vector(16, 9.5),
    [9] = Vector(18, 11),
    [10] = Vector(20, 12)
}

local ESAU_HUD_OFFSET_VECTORS = {
    [0] = Vector(0, 0),
    [1] = Vector(1.5, 0.5),
    [2] = Vector(3, 1),
    [3] = Vector(5, 2),
    [4] = Vector(6.5, 2.5),
    [5] = Vector(8, 3),
    [6] = Vector(9.5, 3.5),
    [7] = Vector(11, 4),
    [8] = Vector(13, 5),
    [9] = Vector(14.5, 5.5),
    [10] = Vector(16, 6)
}

function LootDeckAPI.GetHUDCardPosition(player, sprite)
    local controllerIndex = LootDeckAPI.GetPlayerControllerIndex(player)
    local BottomRight = Vector(Isaac.GetScreenWidth(), Isaac.GetScreenHeight())
    local BottomLeft = Vector(0, Isaac.GetScreenHeight())
    local TopRight = Vector(Isaac.GetScreenWidth(), 0)
    local fuckOffVector = Vector(5000, 5000)

    local hudOffset = math.floor((Options.HUDOffset * 10) + 0.5)

    local hudOffsetVector = Vector.Zero

    if controllerIndex ~= 0 and player.SubType == PlayerType.PLAYER_ESAU then
        return fuckOffVector
    end

    -- Jacob in first player slot
    if controllerIndex == 0 and player.SubType == PlayerType.PLAYER_JACOB then
        hudOffsetVector = JACOB_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(11, 41) + hudOffsetVector
    end

    -- Esau in second player slot
    if controllerIndex == 0 and player.SubType == PlayerType.PLAYER_ESAU then
        hudOffsetVector = ESAU_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(BottomRight.X - 10, BottomRight.Y - 44) - hudOffsetVector
    end

    -- Player 2 (top right)
    if controllerIndex == 1 and player.SubType ~= PlayerType.PLAYER_ESAU then
        if sprite then
            sprite.Scale = Vector(0.5, 0.5)
        end
        hudOffsetVector = SECOND_PLAYER_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(TopRight.X - 147, TopRight.Y + 44) + hudOffsetVector
    end

    -- Player 3 (bottom left)
    if controllerIndex == 2 and player.SubType ~= PlayerType.PLAYER_ESAU then
        if sprite then
            sprite.Scale = Vector(0.5, 0.5)
        end
        hudOffsetVector = THIRD_PLAYER_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(BottomLeft.X + 21.5, BottomLeft.Y + 5) + hudOffsetVector
    end

    -- Player 4 (bottom right)
    if controllerIndex == 3 and player.SubType ~= PlayerType.PLAYER_ESAU then
        if sprite then
            sprite.Scale = Vector(0.5, 0.5)
        end
        hudOffsetVector = FOURTH_PLAYER_HUD_OFFSET_VECTORS[hudOffset]
        return Vector(BottomRight.X - 154, BottomRight.Y + 5.5) - hudOffsetVector
    end

    hudOffsetVector = FIRST_PLAYER_HUD_OFFSET_VECTORS[hudOffset]

    return Vector(BottomRight.X - 15, BottomRight.Y - 12) - hudOffsetVector
end

function LootDeckAPI.CreateCardAnimation(animationContainer, animationPath, animationName, callback)
    if not animationContainer or not animationContainer.sprite then
        animationContainer = {
            sprite = LootDeckAPI.CreateSprite(animationPath, nil, animationName),
            frameCount = 0
        }
        if callback then
            callback(animationContainer)
        end
    end
    return animationContainer
end

function LootDeckAPI.StartLootcardAnimation(lootcardAnimationContainer, lootcardTag, animationName)
    lootcardAnimationContainer.sprite:ReplaceSpritesheet(0, string.format("gfx/ui/lootcard_fronts/%s.png", lootcardTag:gsub("holographic", "")))
    lootcardAnimationContainer.sprite:LoadGraphics()
    if animationName then
        lootcardAnimationContainer.sprite:Play(animationName, true)
        lootcardAnimationContainer.frameCount = Isaac.GetFrameCount()
    end
end

function LootDeckAPI.PlayLootcardPickupAnimation(player, cardId)
    local data = LootDeckAPI.GetLootDeckData(player)
    local card = LootDeckAPI.GetLootcardById(cardId)

    if card then
        local animationName = card.PickupAnimationName
        if Game():GetRoom():HasWater() then
            animationName = animationName.."Water"
        end
        data.lootcardPickupAnimation = LootDeckAPI.CreateCardAnimation(data.lootcardPickupAnimation, "gfx/ui/item_dummy_animation.anm2", animationName)

        LootDeckAPI.StartLootcardAnimation(data.lootcardPickupAnimation, card.Tag, animationName)
        data.isHoldingLootcard = true
        if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
            data.lootcardUseAnimation.sprite:SetLastFrame()
        end
    end
end

function LootDeckAPI.PlayLootcardUseAnimation(player, cardId)
    local data = LootDeckAPI.GetLootDeckData(player)
    local card = LootDeckAPI.GetLootcardById(cardId)

    if card then
        local animationName = card.UseAnimationName
        if Game():GetRoom():HasWater() then
            animationName = animationName.."Water"
        end
        data.lootcardUseAnimation = LootDeckAPI.CreateCardAnimation(data.lootcardUseAnimation, "gfx/ui/item_dummy_animation.anm2", animationName)

        LootDeckAPI.StartLootcardAnimation(data.lootcardUseAnimation, card.Tag, animationName)
        if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
            data.lootcardPickupAnimation.sprite:SetLastFrame()
        end
    end
end