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
    world = nil,
    savedTime = 0,
    showOverlay = false,
    firstEnteredLevel = false,
    blueMap = false,
    compass = false,
    map = false,
    lostSoul = false,
    unlocks = {},
    isInitialized = false,
    isGameStarted = false
}

lootdeck.rng = RNG()
lootdeck.sfx = SFXManager()
lootdeck.mus = MusicManager()
lootdeck.f = table.deepCopy(defaultStartupValues)
lootdeck.unlocks = {}

include("modConfigMenu")
local helper = include("helper_functions")

local mcmOptions = lootdeck.mcmOptions

local rng = lootdeck.rng

lootdeck:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, isContinued)
    if lootdeck:HasData() then
        local data = helper.LoadData()

        if isContinued then
            helper.ForEachEntityInRoom(function(familiar)
                local savedFamiliarData = data.familiars[tostring(familiar.InitSeed)]
                if savedFamiliarData then
                    local familiarData = familiar:GetData()
                    for key, val in pairs(savedFamiliarData) do
                        if val and type(val) == "table" then
                            if helper.IsArray(val) then
                                familiarData[key] = {}
                                for _, v in pairs(val) do
                                    if v and type(v) == "table" then
                                        if v.type == "userdata" then
                                            table.insert(familiarData[key], helper.GetEntityByInitSeed(v.initSeed))
                                        else
                                            goto normal
                                        end
                                    else
                                        goto normal
                                    end
                                end
                                goto continue
                            else
                                if val.type == "userdata" then
                                    familiarData[key] = helper.GetEntityByInitSeed(val.initSeed)
                                    goto continue
                                end
                            end
                        end
                        ::normal::
                        familiarData[key] = val
                        ::continue::
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
                    mcmOptions = data.mcmOptions,
                    unlocks = data.unlocks
                })
                lootdeck.f = table.deepCopy(defaultStartupValues)
            else
                helper.ForEachPlayer(function(p, pData)
                    local savedPlayerData = data.players[tostring(p.InitSeed)]
                    if savedPlayerData then
                        for key, val in pairs(savedPlayerData) do
                            if val and type(val) == "table" then
                                if helper.IsArray(val) then
                                    pData[key] = {}
                                    for _, v in pairs(val) do
                                        if v and type(v) == "table" then
                                            if v.type == "userdata" then
                                                table.insert(pData[key], helper.GetEntityByInitSeed(v.initSeed))
                                            else
                                                goto normal
                                            end
                                        else
                                            goto normal
                                        end
                                    end
                                    goto continue
                                else
                                    if val.type == "userdata" then
                                        pData[key] = helper.GetEntityByInitSeed(val.initSeed)
                                        goto continue
                                    end
                                end
                            end
                            ::normal::
                            pData[key] = val
                            ::continue::
                        end
                    end
                end)

                lootdeck.f = data.global
            end

            lootdeck.mcmOptions = data.mcmOptions
            lootdeck.unlocks = data.unlocks
        end

        if mcmOptions.BlankCardStart then
            Isaac.GetPlayer(0):AddCollectible(CollectibleType.COLLECTIBLE_BLANK_CARD, 4)
        end

        if mcmOptions.JacobEsauStart then
            Isaac.GetPlayer(0):ChangePlayerType(PlayerType.PLAYER_JACOB)
        end

        mcmOptions.LootCardChance = helper.LoadKey("lootCardChance") or mcmOptions.LootCardChance

        lootdeck.f.isInitialized = true
    end

end)

for _, card in pairs(lootcards) do
    if card.callbacks then
        for _, callback in pairs(card.callbacks) do
            if callback[1] == ModCallbacks.MC_USE_CARD then
                lootdeck:AddCallback(callback[1], function(_, c, p, f)
                    local shouldDouble = card.Holographic or items.playerCard.helpers.ShouldRunDouble(p)
                    local result = callback[2](_, c, p, f, shouldDouble)

                    if shouldDouble and callback[4] then
                        callback[2](_, c, p, f)
                    end

                    if f & UseFlag.USE_MIMIC == 0 then
                        local data = p:GetData()
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
		local cardFrontPath = string.format("gfx/ui/lootcard_fronts/%s.png", card.Tag)
		Encyclopedia.AddCard({
			Class = "Loot Deck",
			ID = card.Id,
			WikiDesc = card.WikiDescription,
			ModName = "Loot Deck",
			Spr = Encyclopedia.RegisterSprite("gfx/ui/lootcard_fronts.anm2", card.HUDAnimationName, 0, cardFrontPath),
		})
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
		if (helper.PercentageChance(mcmOptions.LootCardChance + trinkets.cardSleeve.helpers.CalculateLootcardPercentage()) or isLootCard) or mcmOptions.GuaranteedLoot then
			return helper.GetWeightedLootCardId()
		end
	end
end)

lootdeck:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, function(_, shouldSave)
    lootdeck.f.isInitialized = false
    lootdeck.f.isGameStarted = false
    if shouldSave then
        helper.SaveGame()
    end
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
    local data = p:GetData()

    if not p:IsExtraAnimationFinished() then
        if (Isaac.GetFrameCount() % 2) == 0 and not Game():IsPaused() then
            if data.isHoldingLootcard and data.lootcardPickupAnimation and data.lootcardPickupAnimation:IsPlaying(data.lootcardPickupAnimation:GetAnimation()) then
                data.lootcardPickupAnimation:Update()
            end

            if data.lootcardUseAnimation and data.lootcardUseAnimation:IsPlaying(data.lootcardUseAnimation:GetAnimation()) then
                data.lootcardUseAnimation:Update()
            end
        end

		local flyingOffset = p:GetFlyingOffset()
		if p.SubType == PlayerType.PLAYER_THEFORGOTTEN_B and p.PositionOffset.Y < -38 then
			flyingOffset = p:GetOtherTwin():GetFlyingOffset() - Vector(0,2)
		end
		local offsetVector = Vector(0,12) - p.PositionOffset - flyingOffset

        if data.isHoldingLootcard and data.lootcardPickupAnimation and data.lootcardPickupAnimation:IsPlaying(data.lootcardPickupAnimation:GetAnimation()) then
            data.lootcardPickupAnimation:Render(Isaac.WorldToScreen(p.Position - offsetVector), Vector.Zero, Vector.Zero)
        end

        if data.lootcardUseAnimation and data.lootcardUseAnimation:IsPlaying(data.lootcardUseAnimation:GetAnimation()) then
            data.lootcardUseAnimation:Render(Isaac.WorldToScreen(p.Position - offsetVector), Vector.Zero, Vector.Zero)
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
	local data = p:GetData()

	if card.Price == 0 or helper.CanBuyPickup(p, card) then
        local lootcard = helper.GetLootcardById(card.SubType)
        if lootcard then
            helper.PlayLootcardPickupAnimation(data, lootcard.Id)
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

                lootcardAnimationContainer = helper.RegisterAnimation(lootcardAnimationContainer, "gfx/ui/lootcard_fronts.anm2", heldLootcard.HUDAnimationName, function(lac)
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

                if not lootcardAnimationContainer:IsPlaying(heldLootcard.HUDAnimationName) then
                    helper.StartLootcardAnimation(lootcardAnimationContainer, heldLootcard.Tag, heldLootcard.HUDAnimationName)
                else
                    helper.StartLootcardAnimation(lootcardAnimationContainer, heldLootcard.Tag)
                end

                if Isaac.GetFrameCount() % 2 == 0 then
                    lootcardAnimationContainer:Update()
                end
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

lootdeck:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, type, rng, p)
    local heldLootcard = helper.GetLootcardById(p:GetCard(0))

    local data = p:GetData()

    if data.lootcardUseAnimation then
        data.lootcardUseAnimation:SetLastFrame()
    end

    if heldLootcard then
        helper.PlayLootcardUseAnimation(data, heldLootcard.Id)
    end
end, CollectibleType.COLLECTIBLE_DECK_OF_CARDS)