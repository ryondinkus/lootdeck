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
    lostSoul = false
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

                        lootcardAnimationContainer = helper.RegisterLootcardAnimation(lootcardAnimationContainer, "gfx/ui/item_dummy_animation.anm2", "IdleSparkleFast")
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

for _, item in pairs(items) do
    if item.callbacks then
        for _, callback in pairs(item.callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end

-- set rng seed
lootdeck:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
    lootdeck.f = table.deepCopy(defaultStartupValues)
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

            lootcardAnimationContainer = helper.RegisterLootcardAnimation(lootcardAnimationContainer, "gfx/ui/item_dummy_animation.anm2", "IdleSparkle")
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

                lootcardAnimationContainer = helper.RegisterLootcardAnimation(lootcardAnimationContainer, "gfx/ui/lootcard_fronts.anm2", "Idle", function(lac)
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
