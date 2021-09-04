local R = {}

R.cards = {
    theChariot = "VII. The Chariot", -- +1 heart container, +0.25 dmg for every heart
    justice = "VIII. Justice", -- gain a bomb, key, or coin for every enemy in the room
    theHermit = "IX. The Hermit", -- spawns a 15c item from the current pool
    wheelOfFortune = "X. Wheel of Fortune", -- 1/6 chances, 1c, 2dmg, loot 3, -4c, 5c, 1 "arcade" item
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
    butterBean = include("cards/butterBean"),
    redPill = include("cards/redPill"),
    bluePill = include("cards/bluePill"),
    yellowPill = include("cards/yellowPill"),
    bomb = include("cards/bomb"),
    goldBomb = include("cards/goldBomb"),
    lilBattery = include("cards/lilBattery"),
    megaBattery = include("cards/megaBattery"),
    diceShard = include("cards/diceShard"),
    soulHeart = include("cards/soulHeart"),
    blankRune = include("cards/blankRune"),
    dagaz = include("cards/dagaz"),
    ehwaz = include("cards/ehwaz"),
    bloodyPenny = include("cards/bloodyPenny"),
    swallowedPenny = include("cards/swallowedPenny"),
    counterfeitPenny = include("cards/counterfeitPenny"),
    cainsEye = include("cards/cainsEye"),
    brokenAnkh = include("cards/brokenAnkh"),
    curvedHorn = include("cards/curvedHorn"),
    purpleHeart = include("cards/purpleHeart"),
    goldenHorseshoe = include("cards/goldenHorseshoe"),
    guppysHairball = include("cards/guppysHairball"),
    lostSoul = include("cards/lostSoul"),
    theFool = include("cards/theFool"),
    theMagician = include("cards/theMagician"),
    theHighPriestess = include("cards/theHighPriestess"),
    theEmpress = include("cards/theEmpress"),
    theEmperor = include("cards/theEmperor"),
    theHierophant = include("cards/theHierophant"),
    theLovers = include("cards/theLovers"),
    strength = include("cards/strength"),
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
