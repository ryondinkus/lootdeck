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
local json = include("json")

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
    hudOffset = 0,
    hudOffsetCountdown = 0,
    hudOffsetControlsCountdown = 0,
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
                                    if val.type == "userdata" then
                                        table.insert(familiarData[key], helper.GetEntityByInitSeed(v.initSeed))
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
                                        if val.type == "userdata" then
                                            table.insert(pData[key], helper.GetEntityByInitSeed(v.initSeed))
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
                    callback[2](_, c, p, f, items.playerCard.helpers.ShouldRunDouble(p))

                    if callback[4] then
                        callback[2](_, c, p, f)
                    end
                end, callback[3])
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
			Spr = Encyclopedia.RegisterSprite("gfx/ui/lootcard_fronts.anm2", "Idle", 0, cardFrontPath),
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