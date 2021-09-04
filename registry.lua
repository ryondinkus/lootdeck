local R = {}

R.cards = {
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
    theChariot = include("cards/theChariot"),
    justice = include("cards/justice"),
    theHermit = include("cards/theHermit"),
    wheelOfFortune = include("cards/wheelOfFortune"),
    strength = include("cards/strength"),
    theHangedMan = include("cards/theHangedMan"),
    death = include("cards/death"),
    theTower = include("cards/theTower"),
    theDevil = include("cards/theDevil"),
    temperance = include("cards/temperance"),
    theStars = include("cards/theStars")
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
