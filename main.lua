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

include("helpers")
include("helpers/achievements")
include("cards/registry")
include("challenges/registry")
local items = include("items/registry")
local entityVariants = include("entityVariants/registry")
local entitySubTypes = include("entitySubTypes/registry")
local trinkets = include("trinkets/registry")

local defaultStartupValues = {
    sunUsed = false,
    removeSun = false,
    floorBossCleared = 0,
    newRoom = false,
    showOverlay = false,
    firstEnteredLevel = false,
    blueMap = false,
    compass = false,
    map = false,
    lostSoul = false,
    isInitialized = false,
    isGameStarted = false,
    delayedCards = {}
}

local defaultMcmOptions = {
    LootCardChance = 20,
    HoloCardChance = 10
}

lootdeck.rng = RNG()
lootdeck.sfx = SFXManager()
lootdeck.mus = MusicManager()
lootdeck.f = table.deepCopy(defaultStartupValues)
lootdeck.unlocks = {}

local helper = lootdeckHelpers
local InitializeMCM = include("modConfigMenu")

local rng = lootdeck.rng

lootdeck:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, p)
    if not p:GetData().lootdeck then
        p:GetData().lootdeck = {}
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if lootdeck:HasData() then
        local data = helper.LoadData()

        if isContinued then
            helper.ForEachEntityInRoom(function(familiar)
                local savedFamiliarData = data.familiars[tostring(familiar.InitSeed)]
                if savedFamiliarData then
                    local familiarData = familiar:GetData()
                    for key, value in pairs(helper.LoadEntitiesFromSaveData(savedFamiliarData)) do
                        familiarData[key] = value
                    end
                end
            end, EntityType.ENTITY_FAMILIAR)
            helper.RemoveHitFamiliars(entityVariants.holyShield.Id, entityVariants.holyShield.Tag)
        end
    end

    lootdeck.f.isGameStarted = true
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if not lootdeck.f.isInitialized then
        local seeds = Game():GetSeeds()
        rng:SetSeed(seeds:GetStartSeed(), 35)

        if lootdeck:HasData() then
            local data = helper.LoadData()
            local initSeed = seeds:GetPlayerInitSeed()
            local isContinued = data.seed == initSeed
            if not isContinued then
                helper.SaveData({
                    seed = initSeed,
                    players = {},
                    familiars = {},
                    global = table.deepCopy(defaultStartupValues),
                    mcmOptions = data.mcmOptions or table.deepCopy(defaultMcmOptions),
                    unlocks = data.unlocks or {}
                })
                lootdeck.f = table.deepCopy(defaultStartupValues)
                lootdeck.unlocks = data.unlocks or {}
            else
                helper.ForEachPlayer(function(p, pData)
                    local savedPlayerData = data.players[tostring(p.InitSeed)]
                    if savedPlayerData then
                        for key, value in pairs(helper.LoadEntitiesFromSaveData(savedPlayerData)) do
                            pData[key] = value
                        end
                    end
                end)

                if data.global then
                    for key, value in pairs(helper.LoadEntitiesFromSaveData(data.global)) do
                        lootdeck.f[key] = value
                    end
                end
            end

            lootdeck.mcmOptions = data.mcmOptions or table.deepCopy(defaultMcmOptions)
            lootdeck.unlocks = data.unlocks or {}
        else
            lootdeck.f = table.deepCopy(defaultStartupValues)
            lootdeck.unlocks = {}
            lootdeck.mcmOptions = table.deepCopy(defaultMcmOptions)
        end

        InitializeMCM(defaultMcmOptions)
        lootdeck.f.isInitialized = true
    end

end)

lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if lootdeck.f.delayedCards then
        for i, delayedCard in pairs(lootdeck.f.delayedCards) do
            if delayedCard then
                delayedCard.delay = delayedCard.delay - 1

                if delayedCard.delay <= 0 then
                    local lootcard = helper.GetLootcardById(delayedCard.cardId)

                    if lootcard then
                        for _, callback in pairs(lootcard.callbacks) do
                            if callback[1] == ModCallbacks.MC_USE_CARD then
                                callback[2](nil, delayedCard.cardId, delayedCard.player:ToPlayer(), delayedCard.flags)
                            end
                        end
                    end
                    lootdeck.f.delayedCards[i] = nil
                end
            end
        end
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
        local isLootCard = lootcards[id] ~= nil
		local isHoloLootCard = helper.IsHolographic(id)
		local holoChance = helper.PercentageChance(lootdeck.mcmOptions.HoloCardChance) and lootdeck.unlocks.gimmeTheLoot
		if (isLootCard and isHoloLootCard and not holoChance) then
			return id - 75
		end
		if (helper.PercentageChance(lootdeck.mcmOptions.LootCardChance + trinkets.cardSleeve.helpers.CalculateLootcardPercentage()) or isLootCard) then
			local selectedLootCard = helper.GetWeightedLootCardId(false)
			if holoChance then
				selectedLootCard = selectedLootCard + 75
			end
			return selectedLootCard
		end
	end
end)

lootdeck:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, shouldSave)
    if shouldSave then
        helper.SaveGame()
    end
    lootdeck.f = table.deepCopy(defaultStartupValues)
end)

-- lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
--     for soundEffectName, soundEffect in pairs(SoundEffect) do
--         if lootdeck.sfx:IsPlaying(soundEffect) then
--             print(soundEffectName)
--         end
--     end
-- end)

--========== LOOTCARD HUD RENDERING ==========

lootdeck:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, p)
    local data = p:GetData().lootdeck
    local playerAnimation = p:GetSprite():GetAnimation()

    local notExtraAnimations = {
        "WalkRight",
        "WalkDown",
        "WalkLeft",
        "WalkUp",
        "HeadLeft",
        "HeadRight",
        "HeadDown",
        "HeadUp"
    }

    if not helper.TableContains(notExtraAnimations, playerAnimation) then
        data.previousExtraAnimation = playerAnimation
    end

    local flyingOffset = p:GetFlyingOffset()
    if p.SubType == PlayerType.PLAYER_THEFORGOTTEN_B and p.PositionOffset.Y < -38 then
        flyingOffset = p:GetOtherTwin():GetFlyingOffset() - Vector(0,2)
    end
    local offsetVector = Vector(0,12) - p.PositionOffset - flyingOffset

    local cardExtraAnimations = {
        "Pickup",
        "PickupWalkDown",
        "PickupWalkLeft",
        "PickupWalkUp",
        "PickupWalkRight",
        "HeadLeft",
        "HeadRight",
        "HeadDown",
        "HeadUp"
    }

    if not Game():IsPaused() then
        if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
            if data.isHoldingLootcard and helper.TableContains(cardExtraAnimations, data.previousExtraAnimation) and not p:IsExtraAnimationFinished() and data.lootcardPickupAnimation.sprite:IsPlaying(data.lootcardPickupAnimation.sprite:GetAnimation()) then
                if (Isaac.GetFrameCount() - data.lootcardPickupAnimation.frameCount) % 2 == 0 then
                    data.lootcardPickupAnimation.sprite:Update()
                end

                data.lootcardPickupAnimation.sprite:Render(Isaac.WorldToScreen(p.Position - offsetVector), Vector.Zero, Vector.Zero)
            end
        end

        if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
            if ((playerAnimation == "UseItem" and p:GetActiveItem() == items.lootDeck.Id) or helper.TableContains(cardExtraAnimations, data.previousExtraAnimation)) and not p:IsExtraAnimationFinished() and data.lootcardUseAnimation.sprite:IsPlaying(data.lootcardUseAnimation.sprite:GetAnimation()) then
                if (Isaac.GetFrameCount() - data.lootcardUseAnimation.frameCount) % 2 == 0 then
                    data.lootcardUseAnimation.sprite:Update()
                end

                data.lootcardUseAnimation.sprite:Render(Isaac.WorldToScreen(p.Position - offsetVector), Vector.Zero, Vector.Zero)
            end
        end
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
	local data = p:GetData().lootdeck

	if card.Price == 0 or helper.CanBuyPickup(p, card) then
        local lootcard = helper.GetLootcardById(card.SubType)
        if lootcard then
            helper.PlayLootcardPickupAnimation(data, lootcard.Id)
        end
	end
end, PickupVariant.PICKUP_TAROTCARD)

lootdeck:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    helper.ForEachPlayer(function(p, data)
        local heldCardId = p:GetCard(0)
        if heldCardId ~= 0 and (lootdeck.mus:GetCurrentMusicID() ~= Music.MUSIC_JINGLE_BOSS or p.ControlsEnabled) then
            local heldLootcard = helper.GetLootcardById(heldCardId)
            if heldLootcard then

                local lootcardAnimationContainer = data.lootcardHUDAnimation

                lootcardAnimationContainer = helper.RegisterAnimation(lootcardAnimationContainer, "gfx/ui/lootcard_fronts.anm2", heldLootcard.HUDAnimationName, function(lac)
                    local color = lac.Color
                    if p.SubType == PlayerType.PLAYER_JACOB or p.SubType == PlayerType.PLAYER_ESAU then
                        lac.Color = Color(color.R, color.G, color.B, 0.5)
                    end
                end)
                data.lootcardHUDAnimation = lootcardAnimationContainer

                if p.SubType == PlayerType.PLAYER_JACOB or p.SubType == PlayerType.PLAYER_ESAU then
                    local color = lootcardAnimationContainer.sprite.Color
                    if Input.IsActionPressed(ButtonAction.ACTION_DROP, p.ControllerIndex) then
                        lootcardAnimationContainer.sprite.Color = Color(color.R, color.G, color.B, math.min(color.A + 0.07, 1))
                    else
                        lootcardAnimationContainer.sprite.Color = Color(color.R, color.G, color.B, math.max(color.A - 0.07, 0.5))
                    end
                end

                if not lootcardAnimationContainer.sprite:IsPlaying(heldLootcard.HUDAnimationName) then
                    helper.StartLootcardAnimation(lootcardAnimationContainer, heldLootcard.Tag, heldLootcard.HUDAnimationName)
                else
                    helper.StartLootcardAnimation(lootcardAnimationContainer, heldLootcard.Tag)
                end

                if Isaac.GetFrameCount() % 2 == 0 then
                    lootcardAnimationContainer.sprite:Update()
                end
                lootcardAnimationContainer.sprite:Render(helper.GetCardPositionWithHUDOffset(p, lootcardAnimationContainer), Vector.Zero, Vector.Zero)
            else
                if data.lootcardHUDAnimation and data.lootcardHUDAnimation.sprite then
                    if p.SubType == PlayerType.PLAYER_JACOB or p.SubType == PlayerType.PLAYER_ESAU then
                        local color = data.lootcardHUDAnimation.sprite.Color
                        data.lootcardHUDAnimation.sprite.Color = Color(color.R, color.G, color.B, 0.5)
                    end
                end
            end
        end
    end)
end)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData().lootdeck

    if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
        data.lootcardPickupAnimation.sprite:SetLastFrame()
    end

    if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
        data.lootcardUseAnimation.sprite:SetLastFrame()
    end

end)

lootdeck:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, type, rng, p)
    local data = p:GetData().lootdeck

    if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
        data.lootcardPickupAnimation.sprite:SetLastFrame()
    end

    if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
        data.lootcardUseAnimation.sprite:SetLastFrame()
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, type, rng, p)
    local heldLootcard = helper.GetLootcardById(p:GetCard(0))

    local data = p:GetData().lootdeck

    if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
        data.lootcardPickupAnimation.sprite:SetLastFrame()
    end

    if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
        data.lootcardUseAnimation.sprite:SetLastFrame()
    end

    if heldLootcard then
        helper.PlayLootcardUseAnimation(data, heldLootcard.Id)
    end
end, CollectibleType.COLLECTIBLE_DECK_OF_CARDS)

for _, card in pairs(lootcards) do
    if card.callbacks then
        for _, callback in pairs(card.callbacks) do
            if callback[1] == ModCallbacks.MC_USE_CARD then
                lootdeck:AddCallback(callback[1], function(_, c, p, f)
                    local shouldDouble = card.Holographic or items.playerCard.helpers.ShouldRunDouble(p)
                    local result = callback[2](_, c, p, f, shouldDouble)

                    if shouldDouble and callback[4] then
                        if not callback[5] then
                            callback[2](_, c, p, f)
                        else
                            table.insert(lootdeck.f.delayedCards, {
                                player = p,
                                cardId = c,
                                flags = f,
                                delay = callback[5] * 30
                            })
                        end
                    end

                    if f & UseFlag.USE_MIMIC == 0 then
                        local data = p:GetData().lootdeck
                        if result == nil or result then
                            helper.PlayLootcardUseAnimation(data, card.Id)
                        end
                        data.isHoldingLootcard = false
                    end
                end, card.Id)
            else
                lootdeck:AddCallback(table.unpack(callback))
            end
        end
    end

    helper.AddExternalItemDescriptionCard(card)

	if Encyclopedia and card.WikiDescription then
		local cardFrontPath = string.format("gfx/ui/lootcard_fronts/%s.png", card.Tag:gsub("holographic", ""))

        local encyclopediaOptions = {
			Class = "Loot Deck",
			ID = card.Id,
			WikiDesc = card.WikiDescription,
			ModName = "Loot Deck",
            Name = card.Name,
			Spr = Encyclopedia.RegisterSprite("gfx/ui/lootcard_fronts.anm2", card.HUDAnimationName, 2, cardFrontPath),
            Hide = card.Holographic
		}

		Encyclopedia.AddCard(encyclopediaOptions)
	end
end

for _, challenge in pairs(lootdeckChallenges) do
    if challenge.callbacks then
        for _, callback in pairs(challenge.callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
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

	helper.AddExternalItemDescriptionItem(item)

	if Encyclopedia and item.WikiDescription then
		Encyclopedia.AddItem({
			Class = "Loot Deck",
			ID = item.Id,
			WikiDesc = item.WikiDescription,
			ModName = "Loot Deck"
		})
	end
end

for _, trinket in pairs(trinkets) do
    if trinket.callbacks then
        for _, callback in pairs(trinket.callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end

	helper.AddExternalItemDescriptionTrinket(trinket)

	if Encyclopedia and trinket.WikiDescription then
		Encyclopedia.AddTrinket({
			Class = "Loot Deck",
			ID = trinket.Id,
			WikiDesc = trinket.WikiDescription,
			ModName = "Loot Deck"
		})
	end
end

for _, trinket in pairs(trinkets) do
    if trinket.callbacks then
        for _, callback in pairs(trinket.callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end