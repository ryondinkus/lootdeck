local R = {}

R.cards = {
    butterBean = "Butter Bean!", -- butter bean effect
    redPill = "Pills! Red", -- 33% damage buff for the room, 33% hp buff for the room, 33% take 1 heart of dmg
    bluePill = "Pills! Blue", -- 33% gain a loot card, 33% gain 3 loot cards, 33% lose a key, coin, and bomb
    yellowPill = "Pills! Yellow", -- 33% +4c, 33% +7c, 33% -4c
    bomb = "Bomb!", -- explode a random enemy in the room, explode on player if there are none
    goldBomb = "Gold Bomb!!", -- explode three random enemies in the room, explode on player if there are none
    lilBattery = "Lil Battery", -- spawns a lil battery
    megaBattery = "Mega Battery", -- spawns a mega battery
    diceShard = "Dice Shard", -- glowing hourglass effect, respawn in current room
    soulHeart = "Soul Heart", -- one room mantle effect
    blankRune = "Blank Rune", -- gain 1c, loot 2, take 3 damage, gain 4c, loot 5, gain 6c
    dagaz = "Dagaz", -- 50% curse removal, 50% soul heart
    ehwaz = "Ehwaz", -- d10 effect
    bloodyPenny = "Bloody Penny", -- passive, enemies killed drop loot
    swallowedPenny = "Swallowed Penny", -- passive, 50% to drop penny on damage taken
    counterfeitPenny = "Counterfeit Penny", -- passive, adds 1c to money counter every time money is gained
    cainsEye = "Cain's Eye", -- passive, map, compass, or blue map effect on new floor
    brokenAnkh = "Broken Ankh", -- passive, 1/6 chance to revive on death
    curvedHorn = "Curved Horn", -- passive, first shot fired in room has quadruple damage
    purpleHeart = "Purple Heart", -- passive, rerolls a random enemy in the room, rerolled enemy always drops a pickup
    goldenHorseshoe = "Golden Horseshoe", -- passive, every treasure room has an extra glitch item
    guppysHairball = "Guppy's Hairball", -- passive, 1/6 chance to block damage
    lostSoul = "Lost Soul", -- spawns a ghost bomb familiar
    theFool = "O. The Fool", -- glowing hourglass effect, respawn in starting room
    theMagician = "I. The Magician", -- brain worm for the room
    theHighPriestess = "II. The High Priestess", -- deal 40 damage to random enemy 1-6 times
    theEmpress = "III. The Empress", -- grants double shot and increased damage
    theEmperor = "IV. The Emperor", -- charms everything in the room, chance to permacharm
    theHierophant = "V. The Hierophant", -- grants two mantles for the room
    theLovers = "VI. The Lovers", -- grants 2 heart containers for the room
    theChariot = "VII. The Chariot", -- +1 heart container, +0.25 dmg for every heart
    justice = "VIII. Justice", -- gain a bomb, key, or coin for every enemy in the room
    theHermit = "IX. The Hermit", -- spawns a 15c item from the current pool
    wheelOfFortune = "X. Wheel of Fortune", -- 1/6 chances, 1c, 2dmg, loot 3, -4c, 5c, 1 "arcade" item
    strength = "XI. Strength", -- D7 effect, +0.5 damage increase for the floor
    theHangedMan = "XII. The Hanged Man", -- Destroy all consumables in room, get an item (quality based on quality of consumables eaten)
    death = "XIII. Death", -- Die, respawn with 3 bone hearts
    theTower = "XIV. The Tower", -- explode on player 1-2 times, or explode all room enemies
    theDevil = "XV. The Devil", -- spawn a devil deal from the current pool
    temperance = "XVI. Temperance", -- take 1-2 damage, 4c for each damage
    theStars = "XVII. The Stars", -- instantly grants 1 treasure item
    theMoon = "XVIII. The Moon", -- fills a room with shopkeepers
    theSun = "XIX. The Sun", -- when boss of floor is dead, activate forget me now effect. cannot spawn ever again once used, destroy self even with blank card
    judgement = "XX. Judgement", -- grants a few consumables of which you have least, glyph of balance style
    theWorld = "XXI. The World" -- pauses everything in the room for 10 seconds
}

R.items = {
    bloodyPenny = "Bloody Penny",
    swallowedPenny = "Swallowed Penny",
    counterfeitPenny = "Counterfeit Penny",
    cainsEye = "Cain's Eye",
    brokenAnkh = "Broken Ankh",
    curvedHorn = "Curved Horn",
    purpleHeart = "Purple Heart",
    goldenHorseshoe = "Golden Horseshoe",
    guppysHairball = "Guppy's Hairball"
}

R.entityVariants = {
    lostPenny = "Lost Penny",
    lostKey = "Lost Key",
    lostBomb = "Lost Bomb",
    momsFinger = "Mom's Finger"
}

R.costumes = {
    empress = "gfx/empress.anm2",
    sun = "gfx/sun.anm2"
}

R.testCards = {
    penny = include("cards/penny"),
    twoCents = include("cards/twoCents"),
    threeCents = include("cards/threeCents"),
    fourCents = include("cards/fourCents"),
    nickel = include("cards/nickel"),
    dime = include("cards/dime"),
    lilBattery = include("cards/lilBattery"),
    megaBattery = include("cards/megaBattery"),
    theTower = include("cards/theTower")
}

-- for wheel of fortune
R.arcadeItems = {
    CollectibleType.COLLECTIBLE_DOLLAR,
    CollectibleType.COLLECTIBLE_SKATOLE,
    CollectibleType.COLLECTIBLE_BLOOD_BAG,
    CollectibleType.COLLECTIBLE_IV_BAG,
    CollectibleType.COLLECTIBLE_BLOOD_BOMBS,
    CollectibleType.COLLECTIBLE_CRYSTAL_BALL
}

R.soulHeartMarties = {
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

return R
