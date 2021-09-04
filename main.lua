lootdeck = RegisterMod("Loot Deck", 1)

local registry = include("registry")
local cards = include("cards/registry")

lootdeck.game = Game()
lootdeck.rng = RNG()
lootdeck.sfx = SFXManager()
lootdeck.level = 0
lootdeck.room = 0
lootdeck.f = {
    bloodyPenny = 0,
    oldPennies = 0,
    newPennies = 0,
    rerollEnemy = 0,
    spawnExtraReward = 0,
    spawnGlitchItem = false,
    sunUsed = false,
    removeSun = false,
    floorBossCleared = false,
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

function ConvertRegistryToContent(tbl, contentType)
    local ret = {}
    for k, v in pairs(tbl) do
        local id
        if contentType == "I" then
            id = Isaac.GetItemIdByName(v)
        elseif contentType == "K" then
        	id = Isaac.GetCardIdByName(v)
        elseif contentType == "ET" then
        	id = Isaac.GetEntityTypeByName(v)
        elseif contentType == "EV" then
        	id = Isaac.GetEntityVariantByName(v)
		elseif contentType == "C" then
			id = Isaac.GetCostumeIdByPath("gfx/characters/costumes/".. v ..".anm2")
		end

        if id ~= -1 then
            ret[k] = id
        else
            Isaac.DebugString(k .. " invalid name!")
            ret[k] = id
        end
    end

    return ret
end

lootdeck.ev = ConvertRegistryToContent(registry.entityVariants, "EV")
lootdeck.c = ConvertRegistryToContent(registry.costumes, "C")

local game = lootdeck.game
local rng = lootdeck.rng
local f = lootdeck.f
local ev = lootdeck.ev
local c = lootdeck.c

for _, card in pairs(cards) do
    if card.callbacks then
        for _, callback in pairs(card.callbacks) do
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

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    f.firstEnteredLevel = true
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if f.firstEnteredLevel then
        f.firstEnteredLevel = false
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local data = e:GetData()
    local sprite = e:GetSprite()
    if data.target then
        local target = data.target
        e.Position = target.Position
        if sprite:IsEventTriggered("Land") then
            target:TakeDamage(40, 0, EntityRef(e), 0)
            data.target = nil
        end
    end
    if sprite:IsFinished("JumpDown") then
        sprite:Play("JumpUp", true)
    end
    if sprite:IsFinished("JumpUp") then
        e:Remove()
    end
end, ev.momsFinger)

lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    if roomDesc.Clear and room:GetType() == RoomType.ROOM_BOSS then
        f.floorBossCleared = true
    end

    if f.floorBossCleared and f.sunUsed then
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if f.sunUsed then
        for i=0,game:GetNumPlayers()-1 do
            Isaac.GetPlayer(i):TryRemoveNullCostume(c.sun)
        end
    end
    f.sunUsed = false
    f.floorBossCleared = false
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    if sprite:IsEventTriggered("Remove") then
        e:Remove()
    end
end, ev.lostKey)

lootdeck:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    if sprite:IsEventTriggered("Remove") then
        e:Remove()
    end
end, ev.lostBomb)

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
        if data.redDamage then
            data.redDamage = nil
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
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
        if data.curvedHornTear then data.curvedHornTear = 1 end
    end
    if f.bloodyPenny > 0 then f.bloodyPenny = 0 end
end)
