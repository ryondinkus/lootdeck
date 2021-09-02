lootdeck = RegisterMod("Loot Deck", 1)

local registry = include("registry")

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

lootdeck.k = ConvertRegistryToContent(registry.cards, "K")
lootdeck.t = ConvertRegistryToContent(registry.items, "I")
lootdeck.ev = ConvertRegistryToContent(registry.entityVariants, "EV")
lootdeck.c = ConvertRegistryToContent(registry.costumes, "C")

local game = lootdeck.game
local rng = lootdeck.rng
local sfx = lootdeck.sfx
local f = lootdeck.f
local k = lootdeck.k
local t = lootdeck.t
local ev = lootdeck.ev
local c = lootdeck.c

for _, card in pairs(registry.testCards) do
    for _, callback in pairs(card.callbacks) do
       lootdeck:AddCallback(table.unpack(callback)) 
    end
end

-- set rng seed
lootdeck:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
	lootdeck.room = Game():GetRoom()
    f.oldPennies = Isaac.GetPlayer(0):GetNumCoins()
    f.newPennies = Isaac.GetPlayer(0):GetNumCoins()
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

-- TODO: Audio/visual indicators
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local level = game:GetLevel()
    local effect = rng:RandomInt(2)
    if effect == 0 then
        sfx:Play(SoundEffect.SOUND_SUPERHOLY,1,0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.GROUND_GLOW, 0, p.Position, Vector.Zero, p)
        level:RemoveCurses(level:GetCurses())
    else
        sfx:Play(SoundEffect.SOUND_HOLY,1,0)
        p:AddSoulHearts(2)
    end
end, k.dagaz)

-- TODO: Base on loot deck weights, support stacking with multiple players and items, cap at 50% droprate
helper.SimpleLootCardItem(k.bloodyPenny, t.bloodyPenny, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, e)
    local effectNum = 0
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        effectNum = effectNum + p:GetCollectibleNum(t.bloodyPenny)
    end
    local effect = rng:RandomInt(10)

    local threshold = 0
    if effectNum > 0 then threshold = 1 end
    threshold = threshold + (effectNum - 1)
    if threshold >= 5 then threshold = 4 end
    if effect <= threshold then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, (e.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
    end
end)

-- TODO: Stacking support for multiple 50/50 rolls
helper.SimpleLootCardItem(k.swallowedPenny, t.swallowedPenny, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, e)
    if e:ToPlayer():HasCollectible(t.swallowedPenny) then
        for i=1,e:ToPlayer():GetCollectibleNum(t.swallowedPenny) do
            local effect = rng:RandomInt(2)
            if effect == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, (e.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        end
    end
end, EntityType.ENTITY_PLAYER)

-- TODO: Stacking support? extra pennies
helper.SimpleLootCardItem(k.counterfeitPenny, t.counterfeitPenny, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for x=0,game:GetNumPlayers() do
        if Isaac.GetPlayer(x):HasCollectible(t.counterfeitPenny) then
            f.newPennies = Isaac.GetPlayer(0):GetNumCoins()
            if f.newPennies > f.oldPennies then
                Isaac.GetPlayer(0):AddCoins(1)
                f.newPennies = Isaac.GetPlayer(0):GetNumCoins()
                f.oldPennies = Isaac.GetPlayer(0):GetNumCoins()
            end
        end
    end
end)

-- TODO: Stacking support adds multiple mapping effects
helper.SimpleLootCardItem(k.cainsEye, t.cainsEye, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    f.blueMap = false
    f.compass = false
    f.map = false
    for x=0,game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(t.cainsEye) then
            local level = game:GetLevel()
            local effects = 0
            local effectAmount = p:GetCollectibleNum(t.cainsEye)
            if effectAmount > 3 then effectAmount = 3 end
            while effects < effectAmount do
                local effect = rng:RandomInt(3)
                if effect == 0 and not f.blueMap then
                    level:ApplyBlueMapEffect()
                    f.blueMap = true
                    effects = effects + 1
                elseif effect == 1 and not f.compass then
                    level:ApplyCompassEffect(true)
                    f.compass = true
                    effects = effects + 1
                elseif effect == 2 and not f.map then
                    level:ApplyMapEffect()
                    f.map = true
                    effects = effects + 1
                end
            end
        end
        if data.strength then
            data.strength = nil
            local color = Color(1,1,1,1,0,0,0)
            p.Color = color
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
    end
end)

-- BUG: When you revive, your streak is still lost, and saving/continuing is disabled. this is because Revive() is bugged and the game still thinks you're dead
-- due to how poorly extra lives are supported in the API, this is probably the best we're getting without massive overcomplications
helper.SimpleLootCardItem(k.brokenAnkh, t.brokenAnkh, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, p)
    local data = p:GetData()
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    if ( sprite:IsPlaying("Death") and sprite:GetFrame() >= 55) or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() >= 37) or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() >= 19) then
        if p:HasCollectible(t.brokenAnkh) then
            local effectNum = p:GetCollectibleNum(t.brokenAnkh)
            local effect = 0--rng:RandomInt(6)
            local threshold = 0
            if effectNum > 0 then threshold = 1 end
            threshold = threshold + (effectNum - 1)
            if threshold > 2 then threshold = 2 end
            if effect <= threshold then
                if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                    p:AddBoneHearts(1)
                end
                p:Revive()
                if p:GetOtherTwin() then p:GetOtherTwin():Revive() end
                data.reviveAnkh = true
                local enterDoor = level.EnterDoor
                local door = room:GetDoor(enterDoor)
                local direction = door and door.Direction or Direction.NO_DIRECTION
                game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
                level.LeaveDoor = enterDoor
            end
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for i=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.reviveAnkh then
            if p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                p:AddHearts(-1)
                p:AddHearts(1)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                while p:GetBoneHearts() > 1 do
                    p:AddBoneHearts(-1)
                end
            end
            p:AnimateCard(k.brokenAnkh)
            sfx:Play(SoundEffect.SOUND_HOLY,1,0)
            data.reviveAnkh = nil
        end
        if data.reviveDeath then
            p:AddMaxHearts(-24)
            p:AddSoulHearts(-24)
            p:AddBoneHearts(-12)
            p:AddBoneHearts(3)
            if p:GetOtherTwin() then
                p:GetOtherTwin():AddMaxHearts(-24)
                p:GetOtherTwin():AddSoulHearts(-24)
                p:GetOtherTwin():AddBoneHearts(-12)
                p:GetOtherTwin():AddBoneHearts(3)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
                p:AddMaxHearts(2, false)
                p:AddHearts(2)
            end
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or p:GetPlayerType() == PlayerType.PLAYER_THESOUL then
                while p:GetBoneHearts() > 3 do
                    p:AddBoneHearts(-1)
                end
                p:AddSoulHearts(1)
            end
            p:AnimateCard(k.death)
            sfx:Play(SoundEffect.SOUND_UNHOLY,1,0)
            data.death = nil
            data.reviveDeath = nil
        end
    end
end)

-- TODO: Stacking on a single player = more inital shots that are big, audio/visual indicators
helper.SimpleLootCardItem(k.curvedHorn, t.curvedHorn, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(t.curvedHorn) then
            data.curvedHornTearAmount = p:GetCollectibleNum(t.curvedHorn) or 1
        end
    end
end)
lootdeck:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local p = tear:GetLastParent():ToPlayer()
    local data = p:GetData()
    if p:HasCollectible(t.curvedHorn) then
        if data.curvedHornTearAmount > 0 then
            tear.CollisionDamage = tear.CollisionDamage * 4
            tear.Size = tear.Size * 4
            tear.Scale = tear.Scale * 4
            data.curvedHornTearAmount = data.curvedHornTearAmount - 1
            sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK,1,0)
        end
    end
end)

-- BUG: Our standard helper.findRandomEnemy(_, noDupes) doesn't work here since rerolled enemies don't preserve their data tables
-- can't really think of a good way to track rerolled enemies right now
helper.SimpleLootCardItem(k.purpleHeart, t.purpleHeart, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(t.purpleHeart) and not room:IsClear() then
            for y=1,p:GetCollectibleNum(t.purpleHeart) do
                f.rerollEnemy = f.rerollEnemy + 1
                if room:GetType() ~= RoomType.ROOM_BOSS then
                    f.spawnExtraReward = f.spawnExtraReward + 1
                end
            end
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_, e)
    local room = game:GetRoom()
    if f.rerollEnemy > 0 then
        local p = Isaac.GetPlayer(0)
        for i=1,f.rerollEnemy do
            local target = helper.findRandomEnemy(p.Position, false) or 0
            if target ~= 0 then
                game:RerollEnemy(target)
            end
        end
        f.rerollEnemy = 0
    end
    if f.spawnExtraReward > 0 and room:GetAliveEnemiesCount() == 0 then
        for i=1,f.spawnExtraReward do
    		room:SpawnClearAward()
        end
        f.spawnExtraReward = 0
	end
end)

helper.SimpleLootCardItem(k.goldenHorseshoe, t.goldenHorseshoe, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    f.spawnGlitchItem = true
end, k.goldenHorseshoe)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(t.goldenHorseshoe) and room:GetType() == RoomType.ROOM_TREASURE and f.spawnGlitchItem then
            p:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
            p:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            f.spawnGlitchItem = false
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if not f.spawnGlitchItem then f.spawnGlitchItem = true end
end)

helper.SimpleLootCardItem(k.guppysHairball, t.guppysHairball, SoundEffect.SOUND_VAMP_GULP)
lootdeck:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, e)
    local p = e:ToPlayer()
    if p:HasCollectible(t.guppysHairball) then
        local effectNum = p:GetCollectibleNum(t.guppysHairball)
        local effect = rng:RandomInt(6)
        local threshold = 0
        if effectNum > 0 then threshold = 1 end
        threshold = threshold + (effectNum - 1)
        if threshold > 2 then threshold = 2 end
        if effect <= threshold then
            sfx:Play(SoundEffect.SOUND_HOLY_MANTLE,1,0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 11, p.Position, Vector.Zero, p)
            p:SetMinDamageCooldown(30)
            return false
        end
    end
end, EntityType.ENTITY_PLAYER)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    -- BUG: Purgatory ghost crashes on spawn, need API update to fix
    --Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, p.Position, Vector.Zero, nil)
end, k.lostSoul)

-- If it ever gets fixed, AddTrinketEffect() would be better here
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    if not data.magician then data.magician = 1
    else data.magician = data.magician + 1 end
    local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MIND)
    if not p:HasCollectible(CollectibleType.COLLECTIBLE_MIND) then
        p:AddCostume(itemConfig, true)
    end
    p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR)
    p:EvaluateItems()
end, k.theMagician)

lootdeck:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, t)
    local p = t:GetLastParent():ToPlayer()
    local data = p:GetData()
    if data.magician then
        t:AddTearFlags(helper.NewTearflag(71)) -- brain worm effect
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
	local data = p:GetData()
	data[helper.FormatDataKey(k.theHighPriestess)] = 1
end, k.theHighPriestess)

lootdeck:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
	helper.StaggerSpawn(k.theHighPriestess, p, 15, rng:RandomInt(6)+1, function(p)
		local target = helper.findRandomEnemy(p.Position) or 0
		if target ~= 0 then
            local finger = Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.momsFinger, 0, target.Position, Vector(0,0), p)
            local fingerData = finger:GetData()
            fingerData.target = target
		end
	end)
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

-- TODO: Costume?
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_20_20)
    p:AddCollectible(CollectibleType.COLLECTIBLE_20_20)
    if not data.empress then data.empress = 1
    else data.empress = data.empress + 1 end
    if data.empress >= p:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) then
        p:RemoveCostume(itemConfig)
    end
    sfx:Play(SoundEffect.SOUND_MONSTER_YELL_A, 1, 0)
    p:AddNullCostume(Isaac.GetCostumeIdByPath("gfx/empress.anm2"))
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_TEARCOLOR)
    p:EvaluateItems()
end, k.theEmpress)

-- TODO: audio visual?
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if not entity:IsBoss() then
            entity:AddCharmed(EntityRef(p), -1)
        end
    end
    sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW, 1, 0)
end, k.theEmperor)

-- TODO: based on our discoveries with guppy's hairball, emulate a mantle effect
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    -- BUGGED: when AddCollectibleEffect() is fixed, this will give two Holy Mantle effects for the room.
    -- p:GetEffects():AddCollectibleEffect(5, false)
    p:AddSoulHearts(4)
end, k.theHierophant)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    helper.AddTemporaryHealth(p, 4)
end, k.theLovers)

-- TODO: Add compatibility for Tainted Forgotten
-- T. Forgor gets the extra heart but no damage, because the damage scales based on pile-o-bones
-- Needs twin() shenanigans to fix
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    helper.AddTemporaryHealth(p, 2)
    local data = p:GetData()
    if not data.chariot then data.chariot = true end
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
end, k.theChariot)

-- TODO: audio/visual effects, stagger a bit
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity:IsActiveEnemy() then
            local effect = rng:RandomInt(3)
            if effect == 0 then
                p:AddKeys(1)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL, entity.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            elseif effect == 1 then
                p:AddBombs(1)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL, entity.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            else
                p:AddCoins(1)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, entity.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            end
        end
    end
    sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
end, k.justice)

-- TODO: visual audio cues
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), rng:GetSeed()))
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
    local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, p):ToPickup()
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    spawnedItem.AutoUpdatePrice = true
    spawnedItem.Price = 1
    spawnedItem.ShopItemId = 1
    sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0)
end, k.theHermit)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    room = game:GetRoom()
    local effect = rng:RandomInt(6)
    if effect == 0 then
        p:AddCoins(1)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 1 then
        if p:GetHearts() <= 2 and p:GetSoulHearts() <= 2 then
            p:SetFullHearts()
            sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER, 1, 0)
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
            local flags = (DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
            p:TakeDamage(1,flags,EntityRef(p),0)
            p:ResetDamageCooldown()
        end
    elseif effect == 2 then
        for j=1,3 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), p)
        end
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 3 then
        p:AddCoins(-4)
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0)
        for i=0,3 do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostPenny, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
        end
    elseif effect == 4 then
        p:AddCoins(5)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    elseif effect == 5 then
        local room = game:GetRoom()
        local collectible = arcadeItems[rng:RandomInt(6)+1]
        local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
        local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, p)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0)
    end
end, k.wheelOfFortune)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    local magnetoConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
    local soulConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_SOUL)
    p:AddCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
    if not data.hangedMan then data.hangedMan = 1
    else data.hangedMan = data.hangedMan + 1 end
    if data.hangedMan >= p:GetCollectibleNum(CollectibleType.COLLECTIBLE_MAGNETO) then
        p:RemoveCostume(magnetoConfig)
    end
    if not p:HasCollectible(CollectibleType.COLLECTIBLE_SOUL) then
        p:AddCostume(soulConfig, true)
    end
end, k.theHangedMan)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    if not data.death then data.death = true end
    game:ShakeScreen(15)
    sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0)
    p:Die()
end, k.death)

-- TODO: add visual/audio indicators
-- keeper should revive with one coin heart and the flies of 3 bone hearts
lootdeck:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, p)
    local data = p:GetData()
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    if ( sprite:IsPlaying("Death") and sprite:GetFrame() >= 55) or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() >= 37) or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() >= 19) then
        if data.death then
            if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
                p:AddBoneHearts(1)
            end
            p:Revive()
            if p:GetOtherTwin() then p:GetOtherTwin():Revive() end
            data.reviveDeath = true
            local enterDoor = level.EnterDoor
            local door = room:GetDoor(enterDoor)
            local direction = door and door.Direction or Direction.NO_DIRECTION
            game:StartRoomTransition(level:GetPreviousRoomIndex(),direction,0)
            level.LeaveDoor = enterDoor
        end
    end
end)

-- TODO: visual audio cues
lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), rng:GetSeed()))
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
    local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, nil):ToPickup()
    spawnedItem.AutoUpdatePrice = false
    if helper.IsSoulHeartMarty(p) then
        spawnedItem.Price = -3
    elseif p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
        spawnedItem.Price = 15
    else
        spawnedItem.Price = -1
    end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    sfx:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0)
end, k.theDevil)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local effect = rng:RandomInt(2)
    if effect == 0 then
        p:TakeDamage(1,0,EntityRef(p),0)
        for i=0,3 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    else
        p:TakeDamage(2,0,EntityRef(p),0)
        for i=0,7 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, p.Position, Vector.FromAngle(rng:RandomInt(360)), nil)
        end
    end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, p.Position, Vector.Zero, p)
    sfx:Play(SoundEffect.SOUND_BLOODBANK_SPAWN, 1, 0)
end, k.temperance)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local room = game:GetRoom()
    local itemPool = game:GetItemPool()
    local effect = rng:RandomInt(99)
    local roomType = RoomType.ROOM_TREASURE
    if effect == 0 then
        roomType = RoomType.ROOM_PLANETARIUM
    end
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(roomType, rng:GetSeed()))
    local itemConfig = Isaac.GetItemConfig():GetCollectible(collectible)
    if itemConfig.Type == ItemType.ITEM_ACTIVE then
        if p:GetActiveItem() ~= 0 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, p:GetActiveItem(), room:FindFreePickupSpawnPosition(p.Position), Vector(0,0), p)
            p:RemoveCollectible(p:GetActiveItem(), false, ActiveSlot.SLOT_PRIMARY)
        end
    end
    local hud = game:GetHUD()
    hud:ShowItemText(p, itemConfig)
    p:AnimateCollectible(collectible)
    sfx:Play(SoundEffect.SOUND_POWERUP1, 1, 0)
    p:AddCollectible(collectible)
end, k.theStars)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
	local data = p:GetData()
	data[helper.FormatDataKey(k.theMoon)] = 1
end, k.theMoon)

lootdeck:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
	helper.StaggerSpawn(k.theMoon, p, 7, rng:RandomInt(6)+5, function(p)
		room = game:GetRoom()
		local spawnPos = room:GetRandomPosition(0)
		Isaac.Spawn(EntityType.ENTITY_SHOPKEEPER, 0, 0, spawnPos, Vector.Zero, nil)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, nil)
	end)
end)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    f.sunUsed = true
    f.removeSun = true
    for i=0,3 do
        if p:GetCard(i) == k.theSun then
            p:SetCard(i, 0)
        end
    end
    local entities = Isaac.GetRoomEntities()
    for i, entity in pairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_TAROTCARD
        and entity.SubType == k.theSun then
            entity:Remove()
        end
    end
    if f.floorBossCleared then
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
    end
    p:AddNullCostume(c.sun)
    sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 1, 0)
end, k.theSun)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if f.removeSun then
        local entities = Isaac.GetRoomEntities()
        for i, entity in pairs(entities) do
            if entity.Type == EntityType.ENTITY_PICKUP
            and entity.Variant == PickupVariant.PICKUP_TAROTCARD
            and entity.SubType == k.theSun then
                entity:Remove()
            end
        end
    end
end)

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

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local reward = helper.glyphOfBalance(p)
    local room = game:GetRoom()
    for i=0,rng:RandomInt(3) do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, reward[1], reward[2], room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
    end
end, k.judgement)

lootdeck:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    f.world = 300
    f.savedTime = game.TimeCounter
    game:AddPixelation(15)
    sfx:Play(SoundEffect.SOUND_DOGMA_BRIMSTONE_SHOOT, 1, 0)
end, k.theWorld)

lootdeck:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if f.world then
        if f.world % 30 == 0 then
            sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0)
        end
        if f.world == 300 then
            local entities = Isaac.GetRoomEntities()
            for i, entity in pairs(entities) do
                if entity:IsEnemy() then
                    if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                        entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
                    end
                end
            end
        end
        if f.world > 1 then
            game.TimeCounter = f.savedTime
            f.world = f.world - 1
        end
        if f.world == 1 then
            local entities = Isaac.GetRoomEntities()
            for i, entity in pairs(entities) do
                if entity:IsEnemy() then
                    if entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                        entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
                    end
                end
            end
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
            f.world = nil
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, p)
    local data = p:GetData()
    if f.world then
        if f.world >= 300 then
            data.Velocity = p.Velocity
            data.FallingSpeed = p.FallingSpeed
            data.FallingAccel = p.FallingAccel
            data.frozen = true
        end
        if f.world > 1 then
            p.Velocity = Vector(0,0)
            p.FallingSpeed = 0
            p.FallingAccel = -0.1
        end
        if f.world == 1 and data.frozen then
            p.Velocity = data.Velocity
            p.FallingSpeed = data.FallingSpeed
            p.FallingAccel = data.FallingAccel
            data.frozen = nil
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
    if f.world then
        if f.world > 0 and entity.FrameCount == 1 then
            if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
            end
        end
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if f.world then
        f.world = nil
        sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
    end
end)

lootdeck:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    if sprite:IsEventTriggered("Remove") then
        e:Remove()
    end
end, ev.lostPenny)

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
        if data.empress and p:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20) <= data.empress then
            p.Damage = p.Damage * 1.334
        end
        if data.chariot then
            if helper.IsSoulHeartMarty(p) or p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
                p.Damage = p.Damage + (0.25 * p:GetSoulHearts())
            else
                p.Damage = p.Damage + (0.25 * p:GetHearts())
            end
        end
        if data.strength then
            p.Damage = p.Damage + (0.5 * data.strength)
        end
    end
    if f == CacheFlag.CACHE_FIREDELAY then
        if data.magician then
            p.MaxFireDelay = p.MaxFireDelay - (data.magician)
        end
    end
    if f == CacheFlag.CACHE_TEARCOLOR then
        if data.magician then
            local color = Color(1,1,1,1,0,0,0)
            color:SetColorize(1,1,1,1)
            p.TearColor = color
        end
        if data.empress then
            local color = Color(1,1,1,1,0,0,0)
            color:SetColorize(0.8,0,0,1)
            p.TearColor = color
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
        if data.magician then
            data.magician = nil
            p:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_TEARCOLOR)
            p:EvaluateItems()
        end
        if data.empress then
            for i=1,data.empress do
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_20_20)
            end
            data.empress = nil
            p:TryRemoveNullCostume(c.empress)
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_TEARCOLOR)
            p:EvaluateItems()
        end
        if data.chariot then
            data.chariot = false
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
        if data.hangedMan then
            for i=1,data.hangedMan do
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_MAGNETO)
            end
            data.hangedMan = nil
        end
    end
    if f.bloodyPenny > 0 then f.bloodyPenny = 0 end
end)
