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
                    callback[2](_, c, p, f)
                    local data = p:GetData()
                    data.lootcardPickupAnimation:ReplaceSpritesheet(0, string.format("gfx/characters/card_animations/%s.png", card.Tag))
                    data.lootcardPickupAnimation:LoadGraphics()
                    data.lootcardPickupAnimation:Play("Idle", true)
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

lootdeck:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, p)
	helper.ForEachPlayer(function(p, data)
		if not data.isHoldingLootcard then
			return
		end

        local lootcardAnimationContainer = data.lootcardPickupAnimation

		if not p:IsExtraAnimationFinished() then
			if Isaac.GetFrameCount() % 2 == 0 then
                lootcardAnimationContainer:Update()
			end
            lootcardAnimationContainer:Render(Isaac.WorldToScreen(p.Position - Vector(0, 12)), Vector.Zero, Vector.Zero)
		end
	end)
end)

lootdeck:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, function(_, card, collider)
	if not helper.GetLootcardById(card.SubType) or collider.Type ~= EntityType.ENTITY_PLAYER then
		return
	end
	local p = collider:ToPlayer()
	if not p:IsExtraAnimationFinished() then
		return
	end
	local data = p:GetData()

	if card.Price == 0 or helper.CanBuyPickup(p, card) then
        local lootcard = helper.GetLootcardById(card.SubType)
        if lootcard then

            local lootcardAnimationContainer = data.lootcardPickupAnimation

            if not lootcardAnimationContainer then
                data.lootcardPickupAnimation = helper.RegisterSprite("gfx/item_dummy_animation.anm2", nil, "Idle")
                lootcardAnimationContainer = data.lootcardPickupAnimation
            end

            lootcardAnimationContainer:ReplaceSpritesheet(0, string.format("gfx/characters/card_animations/%s.png", lootcard.Tag))
            lootcardAnimationContainer:LoadGraphics()
            lootcardAnimationContainer:Update()
            lootcardAnimationContainer:Play("Idle", true)
            data.isHoldingLootcard = true
        end
	end
end, PickupVariant.PICKUP_TAROTCARD)

lootdeck:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    helper.ForEachPlayer(function(p, data)
        if (not lootdeck.sfx:IsPlaying(SoundEffect.SOUND_CASTLEPORTCULLIS)) or (p.ControlsEnabled) then
            local heldCardId = p:GetCard(0)
            local heldLootcard = helper.GetLootcardById(heldCardId)
            if heldLootcard then
                local BottomRight = helper.GetScreenSize()
                local lootcardAnimationContainer = data.lootcardHUDAnimation

                if not lootcardAnimationContainer then
                    data.lootcardHUDAnimation = helper.RegisterSprite("gfx/new_cardfronts.anm2", nil, "Idle")
                    lootcardAnimationContainer = data.lootcardHUDAnimation
                end

                lootcardAnimationContainer:SetFrame(heldLootcard.Tag, 0)
                lootcardAnimationContainer:Update()
                lootcardAnimationContainer:Render(Vector(BottomRight.X - 13, BottomRight.Y - 15), Vector.Zero, Vector.Zero) -- TODO work with hud offset
            end
        end
    end)
end)