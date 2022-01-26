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

LootDeckAPI = {}

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
    lostSoul = false,
	enemiesKilledInRoom = 0,
    isInitialized = false,
    isGameStarted = false,
    delayedCards = {},
    debugSounds = false,
    startingItems = {}
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
lootdeck.debug = {}

local helper = LootDeckAPI
local InitializeMCM = include("modConfigMenu")

local rng = lootdeck.rng

lootdeck:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if lootdeck:HasData() then
        local data = helper.LoadData()

        if isContinued then
            helper.ForEachEntityInRoom(function(familiar)
                local savedFamiliarData = data.familiars[tostring(familiar.InitSeed)]
                if savedFamiliarData then
                    local familiarData = familiar:GetData()
                    for key, value in pairs(helper.RehydrateEntityData(savedFamiliarData)) do
                        familiarData[key] = value
                    end
                end
            end, EntityType.ENTITY_FAMILIAR)
            helper.RemoveHitFamiliars(entityVariants.holyShield.Tag, entityVariants.holyShield.Id)
        end
    end

    lootdeck.f.isGameStarted = true
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player.FrameCount == 1 then
        local playerInventory = LootDeckAPI.GetPlayerInventory(player)
        local key = tostring(player.InitSeed)
        if #playerInventory > 0 then
            lootdeck.f.startingItems[key] = {}

            local savedPlayerInventory = lootdeck.f.startingItems[key]

            for _, id in pairs(playerInventory) do
                savedPlayerInventory[tostring(id)] = (savedPlayerInventory[tostring(id)] or 0) + 1
            end
        end
    end
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
                        for key, value in pairs(helper.RehydrateEntityData(savedPlayerData)) do
                            pData[key] = value
                        end
                    end
                end)

                if data.global then
                    for key, value in pairs(helper.RehydrateEntityData(data.global)) do
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
                        for _, callback in pairs(lootcard.Callbacks) do
                            if callback[1] == ModCallbacks.MC_USE_CARD then
                                local p = delayedCard.player:ToPlayer()
                                callback[2](nil, delayedCard.cardId, p, delayedCard.flags, false, true, p:GetCardRNG(callback[3]))
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
                helper.RemoveMaxHearts(p, data.redHp)
            else
                helper.RemoveMaxHearts(helper.GetPlayerOrSubPlayerByType(p, PlayerType.PLAYER_THEFORGOTTEN), data.redHp)
            end
            data.redHp = nil
        end
        if data.soulHp then
            helper.RemoveMaxHearts(helper.GetPlayerOrSubPlayerByType(p, PlayerType.PLAYER_THESOUL), data.soulHp)
            data.soulHp = nil
        end
    end)
end)

lootdeck:AddCallback(ModCallbacks.MC_GET_CARD, function(_, r, id, playing, rune, runeOnly)
    local isTaintedLost = false
    helper.ForEachPlayer(function(p)
        if p:GetPlayerType() == PlayerType.PLAYER_THELOST_B then
            isTaintedLost = true
        end
    end)
    -- TODO make it so that a loot card spawning is always decided by the 5% and not by the game itself
	if not runeOnly and not (isTaintedLost and id == Card.CARD_HOLY) then
        local isLootCard = lootcards[id] ~= nil
		local isHoloLootCard = helper.IsHolographic(id)
		local holoChance = helper.PercentageChance(lootdeck.mcmOptions.HoloCardChance, 100, r) and lootdeck.unlocks.gimmeTheLoot
		if (isLootCard and isHoloLootCard and not holoChance) then
			return id - 75
		end
		if (helper.PercentageChance(lootdeck.mcmOptions.LootCardChance + trinkets.cardSleeve.helpers.CalculateLootcardPercentage(), 100, r) or isLootCard) then
			local selectedLootCard = helper.GetWeightedLootCardId(false, r)
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

lootdeck:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, command, args)
    if command:lower() == "lootdeck" and args:lower() == "debugsounds" then
        lootdeck.f.debugSounds = not lootdeck.f.debugSounds

        if lootdeck.f.debugSounds then
            print("Sound debugging started")
        else
            print("Sound debugging stopped")
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_, command, args)
    if lootdeck.f and lootdeck.f.debugSounds then
        local playingSoundEffects = {}
        for soundEffectName, soundEffect in pairs(SoundEffect) do
            if lootdeck.sfx:IsPlaying(soundEffect) then
                table.insert(playingSoundEffects, soundEffectName..": "..soundEffect)
            end
        end
        if #playingSoundEffects > 0 then
            print("=====Sounds playing on frame "..Isaac.GetFrameCount().."=====")
            for _, sfx in pairs(playingSoundEffects) do
                print(sfx)
            end
            print("=====End of sounds playing on frame "..Isaac.GetFrameCount().."=====")
        end
    end
end)

--========== LOOTCARD HUD RENDERING ==========

lootdeck:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, function(_, p)
    local data = helper.GetLootDeckData(p)
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

	if card.Price == 0 or helper.CanBuyPickup(p, card) then
        local lootcard = helper.GetLootcardById(card.SubType)
        if lootcard then
            helper.PlayLootcardPickupAnimation(p, lootcard.Id)
        end
	end
end, PickupVariant.PICKUP_TAROTCARD)

lootdeck:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    helper.ForEachPlayer(function(p, data)
        local heldCardId = p:GetCard(0)
        if heldCardId ~= 0 and (lootdeck.mus:GetCurrentMusicID() ~= Music.MUSIC_JINGLE_BOSS or p.ControlsEnabled) then
            local heldLootcard = helper.GetLootcardById(heldCardId)

            local isJacobAndEsau = p.SubType == PlayerType.PLAYER_JACOB or (p.SubType == PlayerType.PLAYER_ESAU and p:GetOtherTwin())

            if heldLootcard then
                local lootcardAnimationContainer = data.lootcardHUDAnimation

                lootcardAnimationContainer = helper.CreateCardAnimation(lootcardAnimationContainer, "gfx/ui/lootcard_fronts.anm2", heldLootcard.HUDAnimationName, function(lac)
                    local color = lac.sprite.Color
                    if isJacobAndEsau then
                        lac.sprite.Color = Color(color.R, color.G, color.B, 0.5)
                    end
                end)
                data.lootcardHUDAnimation = lootcardAnimationContainer

                if isJacobAndEsau then
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
                lootcardAnimationContainer.sprite:Render(helper.GetHUDCardPosition(p, lootcardAnimationContainer), Vector.Zero, Vector.Zero)
            else
                if data.lootcardHUDAnimation and data.lootcardHUDAnimation.sprite then
                    if isJacobAndEsau then
                        local color = data.lootcardHUDAnimation.sprite.Color
                        data.lootcardHUDAnimation.sprite.Color = Color(color.R, color.G, color.B, 0.5)
                    end
                end
            end
        end
    end)
end)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = helper.GetLootDeckData(p)

    if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
        data.lootcardPickupAnimation.sprite:SetLastFrame()
    end

    if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
        data.lootcardUseAnimation.sprite:SetLastFrame()
    end

end)

lootdeck:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, type, rng, p)
    local data = helper.GetLootDeckData(p)

    if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
        data.lootcardPickupAnimation.sprite:SetLastFrame()
    end

    if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
        data.lootcardUseAnimation.sprite:SetLastFrame()
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, type, rng, p)
    local heldLootcard = helper.GetLootcardById(p:GetCard(0))

    local data = helper.GetLootDeckData(p)

    if data.lootcardPickupAnimation and data.lootcardPickupAnimation.sprite then
        data.lootcardPickupAnimation.sprite:SetLastFrame()
    end

    if data.lootcardUseAnimation and data.lootcardUseAnimation.sprite then
        data.lootcardUseAnimation.sprite:SetLastFrame()
    end

    if heldLootcard then
        helper.PlayLootcardUseAnimation(p, heldLootcard.Id)
    end
end, CollectibleType.COLLECTIBLE_DECK_OF_CARDS)

local magnetoSpeed = 1.75

lootdeck:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
    if LootDeckAPI.IsCoin(pickup, true) and pickup.Variant ~= entityVariants.doubleStickyNickel.Id then
        local closestPlayer

		LootDeckAPI.ForEachPlayer(function(player)
			if player:HasCollectible(CollectibleType.COLLECTIBLE_MAGNETO) or player:HasTrinket(TrinketType.TRINKET_BROKEN_MAGNET) then
	            if not closestPlayer then
	                closestPlayer = player
	            else
	                if player.Position:Distance(pickup.Position) < closestPlayer.Position:Distance(pickup.Position) then
	                    closestPlayer = player
	                end
	            end
			end
        end)

        if closestPlayer then
            pickup.Velocity = (closestPlayer.Position - pickup.Position):Normalized() * magnetoSpeed
        end
    end
end)

if EID then
   local EIDLootCardIcon = Sprite()
    EIDLootCardIcon:Load("gfx/ui/eid_lootcard_icon.anm2", true)
    EID:addIcon("LootCard", "Idle", 0, 9, 9, -1, 0, EIDLootCardIcon)
end

function LootDeckAPI.RegisterLootCard(card, newCard)

    local failed = false

    local missingNameMessage = "A lootcard is missing the 'Name' and 'Names.en_us' properties, so it will not be registered"
    if not card.Name then
        if card.Names and card.Names.en_us then
            card.Name = card.Names.en_us
        else
            LootDeckAPI.PrintError(missingNameMessage)
            failed = true
        end
    else
        if not card.Names then
            card.Names = { en_us = card.Name }
        elseif not card.Names.en_us then
            card.Names.en_us = card.Name
        end
    end

    if not card.Id and card.Name then
        local cardId = Isaac.GetCardIdByName(card.Name)
        if cardId and cardId ~= -1 then
            card.Id = cardId
        else
            LootDeckAPI.PrintError("%s is missing the 'Id' property or could not find a card with the name %s, so it will not be registered", card.Name or "A lootcard", card.Name or "")
            failed = true
        end
    end

    if not card.Tag then
        LootDeckAPI.PrintError("%s is missing the 'Tag' property, so it will not be registered", card.Name or "A lootcard")
        failed = true
    end

    if not card.Weight then
        card.Weight = 1
    end

    if failed then return end

    if lootcards[card.Id] and lootcards[card.Id].RemoveCallbacks then
        for _, removeCallbacks in pairs(lootcards[card.Id].RemoveCallbacks) do
            removeCallbacks()
        end
    end

    if card.Callbacks then
        card.RemoveCallbacks = {}
        for _, callback in pairs(card.Callbacks) do
            if callback[1] == ModCallbacks.MC_USE_CARD then
                local function useCardCallback(_, c, p, f)
                    local shouldDouble = card.IsHolographic or items.playerCard.helpers.ShouldRunDouble(p)
                    local result = callback[2](_, c, p, f, shouldDouble, false, p:GetCardRNG(card.Id))
                    local shouldContinueDouble = true

                    if type(result) == "table" then
                        shouldContinueDouble = result[2]
                        result = result[1]
                    end

                    if shouldDouble and shouldContinueDouble and callback[4] then
                        if not callback[5] then
                            callback[2](_, c, p, f, false, true, p:GetCardRNG(card.Id))
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
                        local data = helper.GetLootDeckData(p)
                        if result == nil then
                            helper.PlayLootcardUseAnimation(p, card.Id)
                        end
                        data.isHoldingLootcard = false
                    end
                end
                lootdeck:AddCallback(callback[1], useCardCallback, card.Id)
                table.insert(card.RemoveCallbacks, function() lootdeck:RemoveCallback(callback[1], useCardCallback) end)
            else
                lootdeck:AddCallback(table.unpack(callback))
                table.insert(card.RemoveCallbacks, function() lootdeck:RemoveCallback(callback[1], callback[2]) end)
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
            Hide = card.IsHolographic
		}

		Encyclopedia.AddCard(encyclopediaOptions)
	end

    lootcards[card.Id] = card
    lootcardKeys[card.Tag] = card

    if newCard == true or newCard == nil then
        LootDeckAPI.RegisterLootCard(LootDeckAPI.GenerateHolographicCard(card), false)
    end
end

for _, card in pairs(lootcards) do
    LootDeckAPI.RegisterLootCard(card, false)
end

for _, challenge in pairs(lootdeckChallenges) do
    if challenge.Callbacks then
        for _, callback in pairs(challenge.Callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end

for _, variant in pairs(entityVariants) do
    if variant.Callbacks then
        for _, callback in pairs(variant.Callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end

for _, subType in pairs(entitySubTypes) do
    if subType.Callbacks then
        for _, callback in pairs(subType.Callbacks) do
            lootdeck:AddCallback(table.unpack(callback))
        end
    end
end

for _, item in pairs(items) do
    if item.Callbacks then
        for _, callback in pairs(item.Callbacks) do
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

	if AnimatedItemsAPI then
		AnimatedItemsAPI:SetAnimationForCollectible(item.Id, "items/collectibles/animated/".. item.Tag .. "Animated.anm2")
	end
end

for _, trinket in pairs(trinkets) do
    if trinket.Callbacks then
        for _, callback in pairs(trinket.Callbacks) do
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

include("tests/registry")
