local json = include("json")

lootdeck = RegisterMod("Loot Deck", 1)

function table.deepCopy(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = table.deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

include("cards/registry")
local items = include("items/registry")
local entityVariants = include("entityVariants/registry")
local entitySubTypes = include("entitySubTypes/registry")

local defaultStartupValues = {
    visitedItemRooms = {},
    sunUsed = false,
    removeSun = false,
    floorBossCleared = 0,
    newRoom = false,
    world = nil,
    savedTime = 0,
    showOverlay = false,
    firstEnteredLevel = false,
    blueMap = false,
    compass = false,
    map = false,
    lostSoul = false,
    hudOffset = 0,
    hudOffsetCountdown = 0,
    hudOffsetControlsCountdown = 0
}

lootdeck.rng = RNG()
lootdeck.sfx = SFXManager()
lootdeck.mus = MusicManager()
lootdeck.f = table.deepCopy(defaultStartupValues)

local helper = include("helper_functions")

local rng = lootdeck.rng

for _, card in pairs(lootcards) do
    if card.callbacks then
        for _, callback in pairs(card.callbacks) do
            if callback[1] == ModCallbacks.MC_USE_CARD then
                lootdeck:AddCallback(callback[1], function(_, c, p, f)
                    local result = callback[2](_, c, p, f)
                    if ((result == nil or result) and f & UseFlag.USE_MIMIC == 0) then
                        local data = p:GetData()

                        local lootcardAnimationContainer = data.lootcardPickupAnimation

                        lootcardAnimationContainer = helper.RegisterAnimation(lootcardAnimationContainer, "gfx/ui/item_dummy_animation.anm2", "IdleSparkleFast")
                        data.lootcardPickupAnimation = lootcardAnimationContainer

                        helper.StartLootcardAnimation(lootcardAnimationContainer, card.Tag, "IdleSparkleFast")
                        data.isHoldingLootcard = true
                    end
                end, callback[3])
            else
                lootdeck:AddCallback(table.unpack(callback))
            end
        end
    end
end

for _, variant in pairs(entityVariants) do
    if variant.callbacks then
        for _, callback in pairs(variant.callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end

for _, subType in pairs(entitySubTypes) do
    if subType.callbacks then
        for _, callback in pairs(subType.callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end

for _, item in pairs(items) do
    if item.callbacks then
        for _, callback in pairs(item.callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end

local HUD_OFFSET_CONTROLS_WAIT_FRAMES = 4 * 60
local HUD_OFFSET_CONTROLS_FADE_FRAMES = 2 * 60

lootdeck:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
    lootdeck.f = table.deepCopy(defaultStartupValues)

    if not ModConfigMenu then
        if lootdeck:HasData() then
            local savedData = json.decode(lootdeck:LoadData())
            lootdeck.f.hudOffset = savedData.hudOffset
        end

        lootdeck.f.hudOffsetControlsCountdown = HUD_OFFSET_CONTROLS_WAIT_FRAMES + HUD_OFFSET_CONTROLS_FADE_FRAMES
    end
end)

-- Temporary health callback
lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    helper.ForEachPlayer(function(p, data)
        if data.redHp then
            if (p:GetSubPlayer() == nil) then
                helper.RemoveHeartsOnNewRoomEnter(p, data.redHp)
            else
                helper.RemoveHeartsOnNewRoomEnter(helper.GetPlayerOrSubPlayerByType(p, PlayerType.PLAYER_THEFORGOTTEN), data.redHp)
            end
            data.redHp = nil
        end
        if data.soulHp then
            helper.RemoveHeartsOnNewRoomEnter(helper.GetPlayerOrSubPlayerByType(p, PlayerType.PLAYER_THESOUL), data.soulHp)
            data.soulHp = nil
        end
    end)
end)

lootdeck:AddCallback(ModCallbacks.MC_GET_CARD, function(_, r, id, playing, rune, runeOnly)
    -- TODO make it so that a loot card spawning is always decided by the 5% and not by the game itself
	if not runeOnly then
        local isLootCard = helper.FindItemInTableByKey(lootcards, "Id", id) ~= nil
		if helper.PercentageChance(5) or isLootCard then
            return helper.GetWeightedLootCardId()
		end
	end
end)

-- sound effect printer
-- lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
--     for soundEffectName, soundEffect in pairs(SoundEffect) do
--         if lootdeck.sfx:IsPlaying(soundEffect) then
--             print(soundEffectName)
--         end
--     end
-- end)

--========== LOOTCARD HUD RENDERING ==========

lootdeck:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function()
    lootdeck:SaveData(json.encode({hudOffset = lootdeck.f.hudOffset}))
end)


local HUD_OFFSET_WAIT_FRAMES = 1 * 60
local HUD_OFFSET_FADE_FRAMES = 0.5 * 60

lootdeck:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not ModConfigMenu then
        if not Game():IsPaused() then
            helper.ForEachPlayer(function(p)
                if helper.KeyboardTriggered(Keyboard.KEY_LEFT_BRACKET, p.ControllerIndex) then
                    lootdeck.f.hudOffset = math.max(lootdeck.f.hudOffset - 1, 0)
                    lootdeck.f.hudOffsetCountdown = HUD_OFFSET_WAIT_FRAMES + HUD_OFFSET_FADE_FRAMES
					lootdeck.sfx:Play(SoundEffect.SOUND_PLOP,1,0)
                elseif helper.KeyboardTriggered(Keyboard.KEY_RIGHT_BRACKET, p.ControllerIndex) then
                    lootdeck.f.hudOffset = math.min(lootdeck.f.hudOffset + 1, 10)
                    lootdeck.f.hudOffsetCountdown = HUD_OFFSET_WAIT_FRAMES + HUD_OFFSET_FADE_FRAMES
					lootdeck.sfx:Play(SoundEffect.SOUND_PLOP,1,0)
				end
            end)
        end
        lootdeck.f.hudOffsetCountdown = math.max(0, lootdeck.f.hudOffsetCountdown - 1)

        if not lootdeck.f.hudOffsetPopup then
            lootdeck.f.hudOffsetPopup = helper.RegisterAnimation(nil, "gfx/ui/hudoffsetmenu.anm2", "Idle")
        end

        if lootdeck.f.hudOffsetCountdown > 0 then
            lootdeck.f.hudOffsetPopup:SetFrame(lootdeck.f.hudOffset)
            local existingColor = lootdeck.f.hudOffsetPopup.Color
            if lootdeck.f.hudOffsetCountdown - HUD_OFFSET_FADE_FRAMES > 0 then
                lootdeck.f.hudOffsetPopup.Color = Color(existingColor.R, existingColor.G, existingColor.B, 1)
            else
                local normalizedOpacity = lootdeck.f.hudOffsetCountdown / HUD_OFFSET_FADE_FRAMES
                lootdeck.f.hudOffsetPopup.Color = Color(existingColor.R, existingColor.G, existingColor.B, normalizedOpacity)
            end
        else
            local existingColor = lootdeck.f.hudOffsetPopup.Color
            lootdeck.f.hudOffsetPopup.Color = Color(existingColor.R, existingColor.G, existingColor.B, 0)
        end
        lootdeck.f.hudOffsetPopup:Render(Vector(helper.GetScreenSize().X / 2, helper.GetScreenSize().Y - 30), Vector.Zero, Vector.Zero)

        if lootdeck.f.hudOffsetControlsCountdown > 0 then
            local message = "You can change the mod HUD offset using \091 and \093"
            local position = Vector(20, helper.GetScreenSize().Y - 25)
            if lootdeck.f.hudOffsetControlsCountdown - HUD_OFFSET_CONTROLS_FADE_FRAMES > 0 then
                Isaac.RenderText(message, position.X, position.Y, 1, 1, 1, 1)
            else
                local normalizedOpacity = lootdeck.f.hudOffsetControlsCountdown / HUD_OFFSET_CONTROLS_FADE_FRAMES
                Isaac.RenderText(message, position.X, position.Y, 1, 1, 1, normalizedOpacity)
            end
            lootdeck.f.hudOffsetControlsCountdown = math.max(0, lootdeck.f.hudOffsetControlsCountdown - 1)
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, p)
    local data = p:GetData()

    if not data.isHoldingLootcard then
        return
    end

    local lootcardAnimationContainer = data.lootcardPickupAnimation

    if not p:IsExtraAnimationFinished() then
        if (Isaac.GetFrameCount() % 2) == 0 and not Game():IsPaused() then
            lootcardAnimationContainer:Update()
        end

		local flyingOffset = p:GetFlyingOffset()
		if p.SubType == PlayerType.PLAYER_THEFORGOTTEN_B and p.PositionOffset.Y < -38 then
			flyingOffset = p:GetOtherTwin():GetFlyingOffset() - Vector(0,2)
		end
		local offsetVector = Vector(0,12) - p.PositionOffset - flyingOffset

        lootcardAnimationContainer:Render(Isaac.WorldToScreen(p.Position - offsetVector), Vector.Zero, Vector.Zero)
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, card, collider)
	if not helper.GetLootcardById(card.SubType) or collider.Type ~= EntityType.ENTITY_PLAYER then
		return
	end
	local p = collider:ToPlayer()
    if p.SubType == PlayerType.PLAYER_THESOUL_B then
        p = p:GetOtherTwin()
    end
	if not p:IsExtraAnimationFinished() then
		return
	end
	local data = p:GetData()

	if card.Price == 0 or helper.CanBuyPickup(p, card) then
        local lootcard = helper.GetLootcardById(card.SubType)
        if lootcard then
            local lootcardAnimationContainer = data.lootcardPickupAnimation

            lootcardAnimationContainer = helper.RegisterAnimation(lootcardAnimationContainer, "gfx/ui/item_dummy_animation.anm2", "IdleSparkle")
            data.lootcardPickupAnimation = lootcardAnimationContainer

            helper.StartLootcardAnimation(lootcardAnimationContainer, lootcard.Tag, "IdleSparkle")
            data.isHoldingLootcard = true
        end
	end
end, PickupVariant.PICKUP_TAROTCARD)

lootdeck:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    helper.ForEachPlayer(function(p, data)
        if lootdeck.mus:GetCurrentMusicID() ~= Music.MUSIC_JINGLE_BOSS or p.ControlsEnabled then
            local heldCardId = p:GetCard(0)
            local heldLootcard = helper.GetLootcardById(heldCardId)
            if heldLootcard then

                local lootcardAnimationContainer = data.lootcardHUDAnimation

                lootcardAnimationContainer = helper.RegisterAnimation(lootcardAnimationContainer, "gfx/ui/lootcard_fronts.anm2", "Idle", function(lac)
                    local color = lac.Color
                    if p.SubType == PlayerType.PLAYER_JACOB or p.SubType == PlayerType.PLAYER_ESAU then
                        lac.Color = Color(color.R, color.G, color.B, 0.5)
                    end
                end)
                data.lootcardHUDAnimation = lootcardAnimationContainer

                if p.SubType == PlayerType.PLAYER_JACOB or p.SubType == PlayerType.PLAYER_ESAU then
                    local color = lootcardAnimationContainer.Color
                    if Input.IsActionPressed(ButtonAction.ACTION_DROP, p.ControllerIndex) then
                        lootcardAnimationContainer.Color = Color(color.R, color.G, color.B, math.min(color.A + 0.07, 1))
                    else
                        lootcardAnimationContainer.Color = Color(color.R, color.G, color.B, math.max(color.A - 0.07, 0.5))
                    end
                end

                helper.StartLootcardAnimation(lootcardAnimationContainer, heldLootcard.Tag, "Idle")

                lootcardAnimationContainer:Render(helper.GetCardPositionWithHUDOffset(p, lootcardAnimationContainer), Vector.Zero, Vector.Zero)
            else
                if data.lootcardHUDAnimation then
                    if p.SubType == PlayerType.PLAYER_JACOB or p.SubType == PlayerType.PLAYER_ESAU then
                        local color = data.lootcardHUDAnimation.Color
                        data.lootcardHUDAnimation.Color = Color(color.R, color.G, color.B, 0.5)
                    end
                end
            end
        end
    end)
end)