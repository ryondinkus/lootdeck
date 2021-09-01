local mod = RegisterMod("Loot Deck", 1)
include("item_registry")
local game = Game()
local rng = RNG()
local sfx = SFXManager()
-- TODO: Combine callbacks, create functions for repetitive code, comment shit, standardize some variable names,
-- plenty of audio visual shit, make sure self damage is categorized as such
-- fix self damage stuff to ignore i-frames, ideally theres a function but if not, simply remove health and play hurt animation
-- update those staggered spawns so the first spawn happens instantly
local k = {
    penny = Isaac.GetCardIdByName("A Penny!"), -- spawns a penny
    twoCents = Isaac.GetCardIdByName("2 Cents!"), -- spawns a double penny
    threeCents = Isaac.GetCardIdByName("3 Cents!"), -- spawns 3 pennies
    fourCents = Isaac.GetCardIdByName("4 Cents!"), -- spawns 4 pennies
    nickel = Isaac.GetCardIdByName("A Nickel!"), -- spawns a nickel
    dime = Isaac.GetCardIdByName("A Dime!!"), -- spawns a dime
    butterBean = Isaac.GetCardIdByName("Butter Bean!"), -- butter bean effect
    redPill = Isaac.GetCardIdByName("Pills! Red"), -- 33% damage buff for the room, 33% hp buff for the room, 33% take 1 heart of dmg
    bluePill = Isaac.GetCardIdByName("Pills! Blue"), -- 33% gain a loot card, 33% gain 3 loot cards, 33% lose a key, coin, and bomb
    yellowPill = Isaac.GetCardIdByName("Pills! Yellow"), -- 33% +4c, 33% +7c, 33% -4c
    bomb = Isaac.GetCardIdByName("Bomb!"), -- explode a random enemy in the room, explode on player if there are none
    goldBomb = Isaac.GetCardIdByName("Gold Bomb!!"), -- explode three random enemies in the room, explode on player if there are none
    lilBattery = Isaac.GetCardIdByName("Lil Battery"), -- spawns a lil battery
    megaBattery = Isaac.GetCardIdByName("Mega Battery"), -- spawns a mega battery
    diceShard = Isaac.GetCardIdByName("Dice Shard"), -- glowing hourglass effect, respawn in current room
    soulHeart = Isaac.GetCardIdByName("Soul Heart"), -- one room mantle effect
    blankRune = Isaac.GetCardIdByName("Blank Rune"), -- gain 1c, loot 2, take 3 damage, gain 4c, loot 5, gain 6c
    dagaz = Isaac.GetCardIdByName("Dagaz"), -- 50% curse removal, 50% soul heart
    ehwaz = Isaac.GetCardIdByName("Ehwaz"), -- d10 effect
    bloodyPenny = Isaac.GetCardIdByName("Bloody Penny"), -- passive, enemies killed drop loot
    swallowedPenny = Isaac.GetCardIdByName("Swallowed Penny"), -- passive, 50% to drop penny on damage taken
    counterfeitPenny = Isaac.GetCardIdByName("Counterfeit Penny"), -- passive, adds 1c to money counter every time money is gained
    cainsEye = Isaac.GetCardIdByName("Cain's Eye"), -- passive, map, compass, or blue map effect on new floor
    brokenAnkh = Isaac.GetCardIdByName("Broken Ankh"), -- passive, 1/6 chance to revive on death
    curvedHorn = Isaac.GetCardIdByName("Curved Horn"), -- passive, first shot fired in room has quadruple damage
    purpleHeart = Isaac.GetCardIdByName("Purple Heart"), -- passive, rerolls a random enemy in the room, rerolled enemy always drops a pickup
    goldenHorseshoe = Isaac.GetCardIdByName("Golden Horseshoe"), -- passive, every treasure room has an extra glitch item
    guppysHairball = Isaac.GetCardIdByName("Guppy's Hairball"), -- passive, 1/6 chance to block damage
    lostSoul = Isaac.GetCardIdByName("Lost Soul"), -- spawns a ghost bomb familiar
    theFool = Isaac.GetCardIdByName("O. The Fool"), -- glowing hourglass effect, respawn in starting room
    theMagician = Isaac.GetCardIdByName("I. The Magician"), -- brain worm for the room
    theHighPriestess = Isaac.GetCardIdByName("II. The High Priestess"), -- deal 40 damage to random enemy 1-6 times
    theEmpress = Isaac.GetCardIdByName("III. The Empress"), -- grants double shot and increased damage
    theEmperor = Isaac.GetCardIdByName("IV. The Emperor"), -- charms everything in the room, chance to permacharm
    theHierophant = Isaac.GetCardIdByName("V. The Hierophant"), -- grants two mantles for the room
    theLovers = Isaac.GetCardIdByName("VI. The Lovers"), -- grants 2 heart containers for the room
    theChariot = Isaac.GetCardIdByName("VII. The Chariot"), -- +1 heart container, +0.25 dmg for every heart
    justice = Isaac.GetCardIdByName("VIII. Justice"), -- gain a bomb, key, or coin for every enemy in the room
    theHermit = Isaac.GetCardIdByName("IX. The Hermit"), -- spawns a 15c item from the current pool
    wheelOfFortune = Isaac.GetCardIdByName("X. Wheel of Fortune"), -- 1/6 chances, 1c, 2dmg, loot 3, -4c, 5c, 1 "arcade" item
    strength = Isaac.GetCardIdByName("XI. Strength"), -- D7 effect, +0.5 damage increase for the floor
    theHangedMan = Isaac.GetCardIdByName("XII. The Hanged Man"), -- Destroy all consumables in room, get an item (quality based on quality of consumables eaten)
    death = Isaac.GetCardIdByName("XIII. Death"), -- Die, respawn with 3 bone hearts
    theTower = Isaac.GetCardIdByName("XIV. The Tower"), -- explode on player 1-2 times, or explode all room enemies
    theDevil = Isaac.GetCardIdByName("XV. The Devil"), -- spawn a devil deal from the current pool
    temperance = Isaac.GetCardIdByName("XVI. Temperance"), -- take 1-2 damage, 4c for each damage
    theStars = Isaac.GetCardIdByName("XVII. The Stars"), -- instantly grants 1 treasure item
    theMoon = Isaac.GetCardIdByName("XVIII. The Moon"), -- fills a room with shopkeepers
    theSun = Isaac.GetCardIdByName("XIX. The Sun"), -- when boss of floor is dead, activate forget me now effect. cannot spawn ever again once used, destroy self even with blank card
    judgement = Isaac.GetCardIdByName("XX. Judgement"), -- grants a few consumables of which you have least, glyph of balance style
    theWorld = Isaac.GetCardIdByName("XXI. The World") -- pauses everything in the room for 10 seconds
}

local i = {
    bloodyPenny = Isaac.GetItemIdByName("Bloody Penny"),
    swallowedPenny = Isaac.GetItemIdByName("Swallowed Penny"),
    counterfeitPenny = Isaac.GetItemIdByName("Counterfeit Penny"),
    cainsEye = Isaac.GetItemIdByName("Cain's Eye"),
    brokenAnkh = Isaac.GetItemIdByName("Broken Ankh"),
    curvedHorn = Isaac.GetItemIdByName("Curved Horn"),
    purpleHeart = Isaac.GetItemIdByName("Purple Heart"),
    goldenHorseshoe = Isaac.GetItemIdByName("Golden Horseshoe"),
    guppysHairball = Isaac.GetItemIdByName("Guppy's Hairball")
}

local ev = {
    lostPenny = Isaac.GetEntityVariantByName("Lost Penny"),
    lostKey = Isaac.GetEntityVariantByName("Lost Key"),
    lostBomb = Isaac.GetEntityVariantByName("Lost Bomb"),
    momsFinger = Isaac.GetEntityVariantByName("Mom's Finger")
}

local cost = {
    empress = Isaac.GetCostumeIdByPath("gfx/empress.anm2"),
    sun = Isaac.GetCostumeIdByPath("gfx/sun.anm2")
}

local globalFlags = {
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

-- for wheel of fortune
local arcadeItems = {
    CollectibleType.COLLECTIBLE_DOLLAR,
    CollectibleType.COLLECTIBLE_SKATOLE,
    CollectibleType.COLLECTIBLE_BLOOD_BAG,
    CollectibleType.COLLECTIBLE_IV_BAG,
    CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL
}

-- helper function for using findRandomEnemy with noDupes, resets chosen enemy counter in case of multiple uses of tower card, for example
function clearChosens(pos)
    local entities = Isaac.FindInRadius(pos, 875, EntityPartition.ENEMY)
    for i, entity in pairs(entities) do
        local data = entity:GetData()
        if data.chosen then
            data.chosen = nil
        end
    end
end

-- function for finding target enemy, then calculating the angle/position the fire will spawn
function findRandomEnemy(pos, noDupes)
    if noDupes == nil then noDupes = false end
    local entities = Isaac.FindInRadius(pos, 875, EntityPartition.ENEMY)
    local enemies = {}
    local key = 1;
    for i, entity in pairs(entities) do
        if noDupes then
            if entity:IsVulnerableEnemy() and not entity:GetData().chosen then
                enemies[key] = entities[i]
                key = key + 1;
            end
        else
            if entity:IsVulnerableEnemy() then
                enemies[key] = entities[i]
                key = key + 1;
            end
        end
    end
    local chosenEnt = enemies[rng:RandomInt(#enemies)+1]
    if noDupes and chosenEnt then
        if not chosenEnt:GetData().chosen then chosenEnt:GetData().chosen = true end
    end
    return chosenEnt
end

-- function for registering basic loot cards that spawn items
local function SimpleLootCardSpawn(cardID, spawnType, spawnVariant, spawnSubtype, uses, position, sound, effect, effectAmount)
    mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
        room = game:GetRoom()
        for i = 1,(uses or 1) do
            Isaac.Spawn(spawnType, spawnVariant or 0, spawnSubtype or 0, position or p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
        end
        if effect then
            for i=1,(effectAmount or 1) do
                Isaac.Spawn(EntityType.ENTITY_EFFECT, effect, 0, position or p.Position, Vector.FromAngle(rng:RandomInt(360)), p)
            end
        end
        if sound then
            sfx:Play(sound)
        end
    end, cardID)
end


-- function for registering basic loot cards that copy item effects
local function SimpleLootCardEffect(cardID, itemEffect, sound)
    mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
        p:UseActiveItem(itemEffect, false)
        if sound then
            sfx:Play(sound,1,0)
        end
    end, cardID)
end

-- function for registering basic loot cards that give items
local function SimpleLootCardItem(cardID, itemID, sound)
    mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
        p:AddCollectible(itemID)
        if sound then
            sfx:Play(sound,1,0)
        end
    end, cardID)
end

-- function to convert tearflags to new BitSet128
local function NewTearflag(x)
    return x >= 64 and BitSet128(0,1<<(x - 64)) or BitSet128(1<<x,0)
end

local soulHeartMarties = {
    PlayerType.PLAYER_XXX,
    PlayerType.PLAYER_BLACKJUDAS,
    PlayerType.PLAYER_THELOST,
    PlayerType.PLAYER_THESOUL,
    PlayerType.PLAYER_JUDAS_B,
    PlayerType.PLAYER_XXX_B,
    PlayerType.PLAYER_THELOST_B,
    PlayerType.PLAYER_THESOUL_B,
    PlayerType.PLAYER_BETHANY_B,
}

-- function to check if player can only use soul/black hearts
local function IsSoulHeartMarty(p)
    for i,v in ipairs(soulHeartMarties) do
        if p:GetPlayerType() == v then
            return true
        end
    end
    return false
end

-- helper function for glyphOfBalance(), makes shit less ocopmlicationsed
local function trinketsOnGround()
    local entities = Isaac.GetRoomEntities()
    for i, entity in pairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP
        and entity.Variant == PickupVariant.PICKUP_TRINKET then
            return true
        end
    end
    return false
end

-- function that returns a consumable based on what glyph of balance would drop
local function glyphOfBalance(p)
    if p:GetMaxHearts() <= 0 and p:GetSoulHearts() <= 4 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    elseif p:GetHearts() <= 1 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
    elseif p:GetNumKeys() <= 0 then
        return {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
    elseif p:GetNumBombs() <= 0 then
        return {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
    elseif p:GetHearts() < p:GetMaxHearts() then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL}
    elseif p:GetNumCoins() < 15 then
        return {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY}
    elseif p:GetNumKeys() < 5 then
        return {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL}
    elseif p:GetNumBombs() < 5 then
        return {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL}
    elseif p:GetTrinket(0) == 0 and not trinketsOnGround() then
        return {PickupVariant.PICKUP_TRINKET, 0}
    elseif p:GetHearts() + p:GetSoulHearts() < 12 then
        return {PickupVariant.PICKUP_HEART, HeartSubType.HEART_SOUL}
    else
        return {(rng:RandomInt(4)+1)*10, 1}
    end
end

-- set rng seed
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
    rng:SetSeed(Game():GetSeeds():GetStartSeed(), 35)
    globalFlags.oldPennies = Isaac.GetPlayer(0):GetNumCoins()
    globalFlags.newPennies = Isaac.GetPlayer(0):GetNumCoins()
end)

SimpleLootCardSpawn(k.penny, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 1)
SimpleLootCardSpawn(k.twoCents, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DOUBLEPACK, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 2)
SimpleLootCardSpawn(k.threeCents, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 3, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 3)
SimpleLootCardSpawn(k.fourCents, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, 4, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.COIN_PARTICLE, 4)
SimpleLootCardSpawn(k.nickel, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.CRACKED_ORB_POOF, 1)
SimpleLootCardSpawn(k.dime, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME, 1, nil, SoundEffect.SOUND_CASH_REGISTER, EffectVariant.CRACKED_ORB_POOF, 1)

SimpleLootCardEffect(k.butterBean, CollectibleType.COLLECTIBLE_BUTTER_BEAN)

-- TODO: Sound effects/visuals indicating effect
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local effect = 1--rng:RandomInt(3)
    local data = p:GetData()
    -- initialize dmg and hp cache values for each player
    if not data.redDamage then data.redDamage = 0 end
    if effect == 0 then
        -- stack damage for each use
        data.redDamage = data.redDamage + 1
        p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        p:EvaluateItems()
        sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
        sfx:Play(SoundEffect.SOUND_DEVIL_CARD,1,0)
        local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL)
        p:AddCostume(itemConfig, true)
    elseif effect == 1 then
        AddTemporaryHealth(p, 2)
        sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
    else
        -- if player would die, do full health effect instead
        if p:GetHearts() <= 1 and p:GetSoulHearts() <= 1 then
            sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,1,0)
            p:SetFullHearts()
        else
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
            local flags = (DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
            p:TakeDamage(1,flags,EntityRef(p),0)
            p:ResetDamageCooldown()
        end
    end
end, k.redPill)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, p, f)
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
            if IsSoulHeartMarty(p) or p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN_B then
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

function RemoveHeartsOnNewRoomEnter(player, hpValue)
    for i=1,hpValue do
        player:AddMaxHearts(-2)
    end
end

function GetPlayerOrSubPlayerByType(player, type)
    if (player:GetPlayerType() == type) then
        return player
    elseif (player:GetSubPlayer():GetPlayerType() == type) then
        return player:GetSubPlayer()
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    -- run on each player for multiplayer support
    for i=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(i)
        local data = p:GetData()
        if data.redDamage then
            data.redDamage = 0
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
        if data.redHp then
            if (p:GetSubPlayer() == nil) then
                RemoveHeartsOnNewRoomEnter(p, data.redHp)
            else
                RemoveHeartsOnNewRoomEnter(GetPlayerOrSubPlayerByType(p, PlayerType.PLAYER_THEFORGOTTEN), data.redHp)
            end
            data.redHp = nil
        end
        if data.soulHp then
            RemoveHeartsOnNewRoomEnter(GetPlayerOrSubPlayerByType(p, PlayerType.PLAYER_THESOUL), data.soulHp)
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
            p:TryRemoveNullCostume(cost.empress)
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
    if globalFlags.bloodyPenny > 0 then globalFlags.bloodyPenny = 0 end
end)

-- TODO: Sound effects and visuals for result, base card spawns from lootdeck weight
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p, f)
    local room = game:GetRoom()
    local effect = rng:RandomInt(3)
    local sprite = p:GetSprite()
    if effect == 0 then
        sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), p)
    elseif effect == 1 then
        sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
        for i=0,2 do
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), p)
        end
    else
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
        if p:GetNumCoins() > 0 then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostPenny, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
            p:AddCoins(-1)
        end
        if p:GetNumBombs() > 0 then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostBomb, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
            p:AddBombs(-1)
        end
        if p:GetNumKeys() > 0 then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostKey, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
            p:AddKeys(-1)
        end
    end
end, k.bluePill)

-- TODO: Sound effects and visuals for result
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local effect = rng:RandomInt(3)
    if effect == 0 then
        sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
        sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        p:AddCoins(4)
    elseif effect == 1 then
        sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
        sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
        p:AddCoins(7)
    else
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
        for i=1,4 do
            if p:GetNumCoins() > 0 then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.lostPenny, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, nil)
                p:AddCoins(-1)
            end
        end
    end
end, k.yellowPill)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local target = findRandomEnemy(p.Position) or p
    Isaac.Explode(target.Position, nil, 40)
end, k.bomb)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    if data.goldBomb then data.goldBomb = 1 end
    if data.goldBombTimer then data.goldBombTimer = 0 end
    if data.goldBombCounter then data.goldBombCounter = 3 end
end, k.goldBomb)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
    local data = p:GetData()
    if not data.goldBomb then data.goldBomb = 0 end
    if not data.goldBombTimer then data.goldBombTimer = 0 end
    if not data.goldBombCounter then data.goldBombCounter = 0 end
    if data.goldBomb == 1 then
        data.goldBombTimer = data.goldBombTimer - 1
        if data.goldBombTimer <= 0 then
            local target = findRandomEnemy(p.Position) or 0
            if target ~= 0 then
                Isaac.Explode(target.Position, nil, 40)
            end
            data.goldBombTimer = 15
            data.goldBombCounter = data.goldBombCounter - 1
            if data.goldBombCounter <= 0 then
                data.goldBomb = 0
            end
        end
    end
end)

SimpleLootCardSpawn(k.lilBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_NORMAL)
SimpleLootCardSpawn(k.megaBattery, EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_LIL_BATTERY, BatterySubType.BATTERY_MEGA)

local blackOverlay = Sprite()
blackOverlay:Load("gfx/overlay.anm2")
blackOverlay:ReplaceSpritesheet(0, "gfx/coloroverlays/black_overlay.png")
blackOverlay:LoadGraphics()
blackOverlay:Play("Idle", true)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if globalFlags.showOverlay then
         blackOverlay:RenderLayer(0, Vector.Zero)
     end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    globalFlags.firstEnteredLevel = true
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if globalFlags.firstEnteredLevel then
        globalFlags.firstEnteredLevel = false
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if globalFlags.checkEm then
        for i=0,game:GetNumPlayers()-1 do
            local p = Isaac.GetPlayer(i)
            local data = p:GetData()
            for j=0,3 do
                if p:GetCard(j) == k.diceShard and data.removeCard then
                    p:SetCard(j, 0)
                    data.removeCard = nil
                end
            end
            if data.dischargeMimic then
                for j=0,3 do
                    if p:GetActiveItem(j) == CollectibleType.COLLECTIBLE_BLANK_CARD then
                        p:DischargeActiveItem(j)
                        data.dischargeMimic = nil
                    end
                end
            end
            if data.dischargeVoid then
                for j=0,3 do
                    if p:GetActiveItem(j) == CollectibleType.COLLECTIBLE_VOID then
                        p:DischargeActiveItem(j)
                        data.dischargeVoid = nil
                    end
                end
            end
        end
        globalFlags.checkEm = false
        globalFlags.showOverlay = false
    end
    if globalFlags.newRoom then
        globalFlags.showOverlay = true
        local level = game:GetLevel()
        local room = level:GetCurrentRoom()
        local enterDoor = level.EnterDoor
        local door = room:GetDoor(enterDoor)
        local direction = Direction.NO_DIRECTION
        game:StartRoomTransition(globalFlags.newRoom,direction,0)
        level.LeaveDoor = enterDoor
        globalFlags.newRoom = nil
        globalFlags.checkEm = true
    end
end)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p, f)
    if not globalFlags.firstEnteredLevel then
        local level = game:GetLevel()
        local data = p:GetData()
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS)
        globalFlags.newRoom = level:GetCurrentRoomIndex()
        if (f & UseFlag.USE_MIMIC == 0) then
            data.removeCard = true
        else
            data.dischargeMimic = true
        end
        if (f & UseFlag.USE_VOID == 0) then
            data.dischargeVoid = true
        end
    else
        local room = game:GetRoom()
        sfx:Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ	,1,0)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, p)
    end
end, k.diceShard)

-- TODO: based on our discoveries with guppy's hairball, emulate a mantle effect
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    -- BUGGED: when AddCollectibleEffect() is fixed, this will give Holy Mantle effect for the room.
    -- p:GetEffects():AddCollectibleEffect(5, false)
    p:AddSoulHearts(2)
    sfx:Play(SoundEffect.SOUND_HOLY,1,0)
end, k.soulHeart)

-- TODO: Visual and audio indicator for results, card spawns based on lootdeck weights,
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local room = game:GetRoom()
    local effect = rng:RandomInt(6)
    for i=1,game:GetNumPlayers() do
        if effect == 0 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
            p:AddCoins(1)
        elseif effect == 1 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            for j=1,2 do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        elseif effect == 2 then
            -- if player would die, do full health effect instead
            if p:GetHearts() <= 2 and p:GetSoulHearts() <= 2 then
                sfx:Play(SoundEffect.SOUND_POWERUP_SPEWER,1,0)
                p:SetFullHearts()
            else
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
                local flags = (DamageFlag.DAMAGE_NOKILL | DamageFlag.DAMAGE_INVINCIBLE | DamageFlag.DAMAGE_NO_MODIFIERS | DamageFlag.DAMAGE_NO_PENALTIES)
                p:TakeDamage(2,flags,EntityRef(p),0)
                p:ResetDamageCooldown()
            end
        elseif effect == 3 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
            p:AddCoins(4)
        elseif effect == 4 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            for j=1,5 do
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        elseif effect == 5 then
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
            sfx:Play(SoundEffect.SOUND_PENNYPICKUP, 1, 0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACKED_ORB_POOF, 0, p.Position, Vector.Zero, p)
            p:AddCoins(6)
        end
    end
end, k.blankRune)

-- TODO: Audio/visual indicators
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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

-- TODO: Audio/visual indicators
SimpleLootCardEffect(k.ehwaz, CollectibleType.COLLECTIBLE_D10, SoundEffect.SOUND_LAZARUS_FLIP_DEAD)

-- TODO: Base on loot deck weights, support stacking with multiple players and items, cap at 50% droprate
SimpleLootCardItem(k.bloodyPenny, i.bloodyPenny, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, function(_, e)
    local effectNum = 0
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        effectNum = effectNum + p:GetCollectibleNum(i.bloodyPenny)
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
SimpleLootCardItem(k.swallowedPenny, i.swallowedPenny, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, e)
    if e:ToPlayer():HasCollectible(i.swallowedPenny) then
        for i=1,e:ToPlayer():GetCollectibleNum(i.swallowedPenny) do
            local effect = rng:RandomInt(2)
            if effect == 0 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, (e.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
            end
        end
    end
end, EntityType.ENTITY_PLAYER)

-- TODO: Stacking support? extra pennies
SimpleLootCardItem(k.counterfeitPenny, i.counterfeitPenny, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for x=0,game:GetNumPlayers() do
        if Isaac.GetPlayer(x):HasCollectible(i.counterfeitPenny) then
            globalFlags.newPennies = Isaac.GetPlayer(0):GetNumCoins()
            if globalFlags.newPennies > globalFlags.oldPennies then
                Isaac.GetPlayer(0):AddCoins(1)
                globalFlags.newPennies = Isaac.GetPlayer(0):GetNumCoins()
                globalFlags.oldPennies = Isaac.GetPlayer(0):GetNumCoins()
            end
        end
    end
end)

-- TODO: Stacking support adds multiple mapping effects
SimpleLootCardItem(k.cainsEye, i.cainsEye, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    globalFlags.blueMap = false
    globalFlags.compass = false
    globalFlags.map = false
    for x=0,game:GetNumPlayers() - 1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(i.cainsEye) then
            local level = game:GetLevel()
            local effects = 0
            local effectAmount = p:GetCollectibleNum(i.cainsEye)
            if effectAmount > 3 then effectAmount = 3 end
            while effects < effectAmount do
                local effect = rng:RandomInt(3)
                if effect == 0 and not globalFlags.blueMap then
                    level:ApplyBlueMapEffect()
                    globalFlags.blueMap = true
                    effects = effects + 1
                elseif effect == 1 and not globalFlags.compass then
                    level:ApplyCompassEffect(true)
                    globalFlags.compass = true
                    effects = effects + 1
                elseif effect == 2 and not globalFlags.map then
                    level:ApplyMapEffect()
                    globalFlags.map = true
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
SimpleLootCardItem(k.brokenAnkh, i.brokenAnkh, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, p)
    local data = p:GetData()
    local sprite = p:GetSprite()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    if ( sprite:IsPlaying("Death") and sprite:GetFrame() >= 55) or (sprite:IsPlaying("LostDeath") and sprite:GetFrame() >= 37) or (sprite:IsPlaying("ForgottenDeath") and sprite:GetFrame() >= 19) then
        if p:HasCollectible(i.brokenAnkh) then
            local effectNum = p:GetCollectibleNum(i.brokenAnkh)
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

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
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
SimpleLootCardItem(k.curvedHorn, i.curvedHorn, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        local data = p:GetData()
        if p:HasCollectible(i.curvedHorn) then
            data.curvedHornTearAmount = p:GetCollectibleNum(i.curvedHorn)
        end
    end
end)
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, t)
    local p = t:GetLastParent():ToPlayer()
    local data = p:GetData()
    if p:HasCollectible(i.curvedHorn) then
        if data.curvedHornTearAmount > 0 then
            t.CollisionDamage = t.CollisionDamage * 4
            t.Size = t.Size * 4
            t.Scale = t.Scale * 4
            data.curvedHornTearAmount = data.curvedHornTearAmount - 1
            sfx:Play(SoundEffect.SOUND_EXPLOSION_WEAK,1,0)
        end
    end
end)

-- BUG: Our standard findRandomEnemy(_, noDupes) doesn't work here since rerolled enemies don't preserve their data tables
-- can't really think of a good way to track rerolled enemies right now
SimpleLootCardItem(k.purpleHeart, i.purpleHeart, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(i.purpleHeart) and not room:IsClear() then
            for y=1,p:GetCollectibleNum(i.purpleHeart) do
                globalFlags.rerollEnemy = globalFlags.rerollEnemy + 1
                if room:GetType() ~= RoomType.ROOM_BOSS then
                    globalFlags.spawnExtraReward = globalFlags.spawnExtraReward + 1
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function(_, e)
    local room = game:GetRoom()
    if globalFlags.rerollEnemy > 0 then
        local p = Isaac.GetPlayer(0)
        for i=1,globalFlags.rerollEnemy do
            local target = findRandomEnemy(p.Position, false) or 0
            if target ~= 0 then
                game:RerollEnemy(target)
            end
        end
        globalFlags.rerollEnemy = 0
    end
    if globalFlags.spawnExtraReward > 0 and room:GetAliveEnemiesCount() == 0 then
        for i=1,globalFlags.spawnExtraReward do
    		room:SpawnClearAward()
        end
        globalFlags.spawnExtraReward = 0
	end
end)

SimpleLootCardItem(k.goldenHorseshoe, i.goldenHorseshoe, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    globalFlags.spawnGlitchItem = true
end, k.goldenHorseshoe)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    for x=0,game:GetNumPlayers()-1 do
        local p = Isaac.GetPlayer(x)
        if p:HasCollectible(i.goldenHorseshoe) and room:GetType() == RoomType.ROOM_TREASURE and globalFlags.spawnGlitchItem then
            p:AddCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, nil)
            p:RemoveCollectible(CollectibleType.COLLECTIBLE_TMTRAINER)
            globalFlags.spawnGlitchItem = false
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if not globalFlags.spawnGlitchItem then globalFlags.spawnGlitchItem = true end
end)

SimpleLootCardItem(k.guppysHairball, i.guppysHairball, SoundEffect.SOUND_VAMP_GULP)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, e)
    local p = e:ToPlayer()
    if p:HasCollectible(i.guppysHairball) then
        local effectNum = p:GetCollectibleNum(i.guppysHairball)
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

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    -- BUG: Purgatory ghost crashes on spawn, need API update to fix
    --Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PURGATORY, 1, p.Position, Vector.Zero, nil)
end, k.lostSoul)

SimpleLootCardEffect(k.theFool, CollectibleType.COLLECTIBLE_TELEPORT_2)

-- If it ever gets fixed, AddTrinketEffect() would be better here
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, t)
    local p = t:GetLastParent():ToPlayer()
    local data = p:GetData()
    if data.magician then
        t:AddTearFlags(NewTearflag(71)) -- brain worm effect
    end
end)

-- TODO: Audio visual indicator
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    if data.highPriestess then data.highPriestess = 1 end
    if data.highPriestessTimer then data.highPriestessTimer = 0 end
    if data.highPriestessCounter then data.highPriestessCounter = rng:RandomInt(6) end
end, k.theHighPriestess)


mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
    local data = p:GetData()
    if not data.highPriestess then data.highPriestess = 0 end
    if not data.highPriestessTimer then data.highPriestessTimer = 0 end
    if not data.highPriestessCounter then data.highPriestessCounter = 0 end
    if data.highPriestess == 1 then
        data.highPriestessTimer = data.highPriestessTimer - 1
        if data.highPriestessTimer <= 0 then
            local target = findRandomEnemy(p.Position) or 0
            if target ~= 0 then
                local finger = Isaac.Spawn(EntityType.ENTITY_EFFECT, ev.momsFinger, 0, target.Position, Vector(0,0), p)
                local fingerData = finger:GetData()
                fingerData.target = target
            end
            data.highPriestessTimer = 15
            data.highPriestessCounter = data.highPriestessCounter - 1
            if data.highPriestessCounter <= 0 then
                data.highPriestess = 0
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
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
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    for i, entity in ipairs(Isaac.GetRoomEntities()) do
        if not entity:IsBoss() then
            entity:AddCharmed(EntityRef(p), -1)
        end
    end
    sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW, 1, 0)
end, k.theEmperor)

-- TODO: based on our discoveries with guppy's hairball, emulate a mantle effect
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    -- BUGGED: when AddCollectibleEffect() is fixed, this will give two Holy Mantle effects for the room.
    -- p:GetEffects():AddCollectibleEffect(5, false)
    p:AddSoulHearts(4)
end, k.theHierophant)

function GetPlayerHeartTotal(p)
    local heartTotal = p:GetMaxHearts()
    if IsSoulHeartMarty(p) then heartTotal = heartTotal + p:GetSoulHearts() end
    if p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then heartTotal = heartTotal + (p:GetBoneHearts() * 2) end
    return heartTotal
end

function FindHealthToAdd(p, hp)
    local heartTotal = GetPlayerHeartTotal(p)
    if heartTotal < p:GetHeartLimit() then
        local remainder = math.floor((p:GetHeartLimit() - heartTotal)/2)
        local amountToAdd = math.floor(hp/2)
        if remainder < amountToAdd then amountToAdd = remainder end
        return amountToAdd
    end
    return 0
end

function AddTemporaryHealth(p, hp) -- hp is calculated in half hearts
    local data = p:GetData()
    local amountToAdd = FindHealthToAdd(p, hp)
    if p:GetPlayerType() == PlayerType.PLAYER_THESOUL then
        if not data.soulHp then data.soulHp = 0 end
        data.soulHp = data.soulHp + amountToAdd
    else
        if not data.redHp then data.redHp = 0 end
        data.redHp = data.redHp + amountToAdd
    end
    p:AddMaxHearts(hp)
    p:AddHearts(hp)
    sfx:Play(SoundEffect.SOUND_VAMP_GULP,1,0)
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    AddTemporaryHealth(p, 4)
end, k.theLovers)

-- TODO: Add compatibility for Tainted Forgotten
-- T. Forgor gets the extra heart but no damage, because the damage scales based on pile-o-bones
-- Needs twin() shenanigans to fix
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    AddTemporaryHealth(p, 2)
    local data = p:GetData()
    if not data.chariot then data.chariot = true end
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
end, k.theChariot)

-- TODO: audio/visual effects, stagger a bit
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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

SimpleLootCardEffect(k.strength, CollectibleType.COLLECTIBLE_D7)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    local sprite = p:GetSprite()
    if not data.strength then data.strength = 1
    else
        data.strength = data.strength + 1
    end
    for i=1,data.strength or 0 do
        local color = Color(1,1,1,1,data.strength/10,0,0)
        --color:SetColorize(0.1,0,0,1)
        sprite.Color = color
    end
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
    sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 1, 0)
end, k.strength)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    if not data.death then data.death = true end
    game:ShakeScreen(15)
    sfx:Play(SoundEffect.SOUND_DEATH_CARD, 1, 0)
    p:Die()
end, k.death)

-- TODO: add visual/audio indicators
-- keeper should revive with one coin heart and the flies of 3 bone hearts
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, p)
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

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    if data.tower then data.tower = 1 end
    if data.towerTimer then data.towerTimer = 7 end
end, k.theTower)


mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
    local data = p:GetData()
    if not data.tower then data.tower = 0 end
    if not data.towerTimer then data.towerTimer = 0 end
    if data.tower == 1 then
        data.towerTimer = data.towerTimer - 1
        if data.towerTimer <= 0 then
            local target = findRandomEnemy(p.Position, true) or p
            Isaac.Explode(target.Position, nil, 40)
            if target == p then
                data.tower = 0
                clearChosens(p.Position)
            end
            data.towerTimer = 7
        end
    end
end)

-- TODO: visual audio cues
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local itemPool = game:GetItemPool()
    local room = game:GetRoom()
    local collectible = itemPool:GetCollectible(itemPool:GetPoolForRoom(room:GetType(), rng:GetSeed()))
    local spawnPos = room:FindFreePickupSpawnPosition(p.Position)
    local spawnedItem = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, collectible, spawnPos, Vector.Zero, nil):ToPickup()
    spawnedItem.AutoUpdatePrice = false
    if IsSoulHeartMarty(p) then
        spawnedItem.Price = -3
    elseif p:GetPlayerType() == PlayerType.PLAYER_KEEPER or p:GetPlayerType() == PlayerType.PLAYER_KEEPER_B then
        spawnedItem.Price = 15
    else
        spawnedItem.Price = -1
    end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, p)
    sfx:Play(SoundEffect.SOUND_SATAN_GROW, 1, 0)
end, k.theDevil)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
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

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    if data.moon then data.moon = 1 end
    if data.moonTimer then data.moonTimer = 7 end
    if data.moonCounter then data.moonCounter = rng:RandomInt(6)+5 end
end, k.theMoon)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, p)
    local data = p:GetData()
    room = game:GetRoom()
    if not data.moon then data.moon = 0 end
    if not data.moonTimer then data.moonTimer = 0 end
    if not data.moonCounter then data.moonCounter = 0 end
    if data.moon == 1 then
        data.moonTimer = data.moonTimer - 1
        if data.moonTimer <= 0 then
            local spawnPos = room:GetRandomPosition(0)
            Isaac.Spawn(EntityType.ENTITY_SHOPKEEPER, 0, 0, spawnPos, Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, spawnPos, Vector.Zero, nil)
            data.moonCounter = data.moonCounter - 1
            if data.moonCounter <= 0 then
                data.moon = 0
            end
            data.moonTimer = 7
        end
    end
end)
mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local data = p:GetData()
    globalFlags.sunUsed = true
    globalFlags.removeSun = true
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
    if globalFlags.floorBossCleared then
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
    end
    p:AddNullCostume(cost.sun)
    sfx:Play(SoundEffect.SOUND_CHOIR_UNLOCK, 1, 0)
end, k.theSun)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if globalFlags.removeSun then
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

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local level = game:GetLevel()
    local room = level:GetCurrentRoom()
    local roomDesc = level:GetCurrentRoomDesc()

    if roomDesc.Clear and room:GetType() == RoomType.ROOM_BOSS then
        globalFlags.floorBossCleared = true
    end

    if globalFlags.floorBossCleared and globalFlags.sunUsed then
        Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_FORGET_ME_NOW)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    if globalFlags.sunUsed then
        for i=0,game:GetNumPlayers()-1 do
            Isaac.GetPlayer(i):TryRemoveNullCostume(cost.sun)
        end
    end
    globalFlags.sunUsed = false
    globalFlags.floorBossCleared = false
end)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    local reward = glyphOfBalance(p)
    local room = game:GetRoom()
    for i=0,rng:RandomInt(3) do
        Isaac.Spawn(EntityType.ENTITY_PICKUP, reward[1], reward[2], room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
    end
end, k.judgement)

mod:AddCallback(ModCallbacks.MC_USE_CARD, function(_, c, p)
    globalFlags.world = 300
    globalFlags.savedTime = game.TimeCounter
    game:AddPixelation(15)
    sfx:Play(SoundEffect.SOUND_DOGMA_BRIMSTONE_SHOOT, 1, 0)
end, k.theWorld)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if globalFlags.world then
        if globalFlags.world % 30 == 0 then
            sfx:Play(SoundEffect.SOUND_FETUS_LAND, 1, 0)
        end
        if globalFlags.world == 300 then
            local entities = Isaac.GetRoomEntities()
            for i, entity in pairs(entities) do
                if entity:IsEnemy() then
                    if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                        entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
                    end
                end
            end
        end
        if globalFlags.world > 1 then
            game.TimeCounter = globalFlags.savedTime
            globalFlags.world = globalFlags.world - 1
        end
        if globalFlags.world == 1 then
            local entities = Isaac.GetRoomEntities()
            for i, entity in pairs(entities) do
                if entity:IsEnemy() then
                    if entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                        entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
                    end
                end
            end
            sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
            globalFlags.world = nil
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, function(_, p)
    local data = p:GetData()
    if globalFlags.world then
        if globalFlags.world >= 300 then
            data.Velocity = p.Velocity
            data.FallingSpeed = p.FallingSpeed
            data.FallingAccel = p.FallingAccel
            data.frozen = true
        end
        if globalFlags.world > 1 then
            p.Velocity = Vector(0,0)
            p.FallingSpeed = 0
            p.FallingAccel = -0.1
        end
        if globalFlags.world == 1 and data.frozen then
            p.Velocity = data.Velocity
            p.FallingSpeed = data.FallingSpeed
            p.FallingAccel = data.FallingAccel
            data.frozen = nil
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, function(_, entity)
    if globalFlags.world then
        if globalFlags.world > 0 and entity.FrameCount == 1 then
            if not entity:HasEntityFlags(EntityFlag.FLAG_FREEZE) then
                entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if globalFlags.world then
        globalFlags.world = nil
        sfx:Play(SoundEffect.SOUND_DOGMA_TV_BREAK, 1, 0)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    if sprite:IsEventTriggered("Remove") then
        e:Remove()
    end
end, ev.lostPenny)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    if sprite:IsEventTriggered("Remove") then
        e:Remove()
    end
end, ev.lostKey)

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, e)
    local sprite = e:GetSprite()
    if sprite:IsEventTriggered("Remove") then
        e:Remove()
    end
end, ev.lostBomb)
