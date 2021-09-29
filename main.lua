lootdeck = RegisterMod("Loot Deck", 1)

include("cards/registry")
local items = include("items/registry")
local entityVariants = include("entityVariants/registry")

lootdeck.rng = RNG()
lootdeck.sfx = SFXManager()
lootdeck.mus = MusicManager()
lootdeck.level = 0
lootdeck.room = 0
lootdeck.f = {
    bloodyPenny = 0,
    oldPennies = 0,
    rerollEnemy = 0,
    spawnExtraReward = 0,
    visitedItemRooms = {},
    sunUsed = false,
    removeSun = false,
    floorBossCleared = 0,
    newRoom = false,
    foolRoom = false,
    world = nil,
    savedTime = 0,
    showOverlay = false,
    firstEnteredLevel = false,
    blueMap = false,
    compass = false,
    map = false
}

local helper = include("helper_functions")

local game = Game()
local rng = lootdeck.rng
local f = lootdeck.f

for _, card in pairs(lootcards) do
    if card.callbacks then
        for _, callback in pairs(card.callbacks) do
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
	lootdeck.room = Game():GetRoom()
    lootdeck.f.pennyCount = Isaac.GetPlayer(0):GetNumCoins()
end)

local blackOverlay = Sprite()
blackOverlay:Load("gfx/overlay.anm2")
blackOverlay:ReplaceSpritesheet(0, "gfx/coloroverlays/black_overlay.png")
blackOverlay:LoadGraphics()
blackOverlay:Play("Idle", true)

lootdeck:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if f.showOverlay then
         blackOverlay:RenderLayer(0, Vector.Zero)
     end
end)

lootdeck:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, p, f)
    local data = p:GetData()
    if not data.redDamage then data.redDamage = 0 end
    -- red pill damage cache evaulator
    if f == CacheFlag.CACHE_DAMAGE then
        if data.redDamage then
            p.Damage = p.Damage + (2 * data.redDamage)
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    -- run on each player for multiplayer support
    for i=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
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
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_GET_CARD, function(_, r, id, playing, rune, runeOnly)
    -- TODO make it so that a loot card spawning is always decided by the 5% and not by the game itself
	if not runeOnly then
		local roll = rng:RandomInt(99)+1
		local threshold = 5
        local isLootCard = helper.FindItemInTableByKey(lootcards, "Id", id) ~= nil
		if roll <= threshold or isLootCard then
            return helper.GetWeightedLootCardId()
		end
	end
end)
