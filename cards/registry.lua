local cards = {
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
    theStars = include("cards/theStars"),
    theMoon = include("cards/theMoon"),
    theSun = include("cards/theSun"),
    judgement = include("cards/judgement"),
    theWorld = include("cards/theWorld"),
    chargedPenny = include("cards/chargedPenny"),
    joker = include("cards/joker"),
    holyCard = include("cards/holyCard"),
    twoOfDiamonds = include("cards/twoOfDiamonds"),
    aSack = include("cards/aSack"),
    creditCard = include("cards/creditCard"),
    jera = include("cards/jera"),
    purplePill = include("cards/purplePill"),
    pinkEye = include("cards/pinkEye"),
    cancer = include("cards/cancer"),
    perthro = include("cards/perthro"),
    ansuz = include("cards/ansuz"),
    blackRune = include("cards/blackRune"),
    tapeWorm = include("cards/tapeWorm"),
    aaaBattery = include("cards/aaaBattery"),
    pokerChip = include("cards/pokerChip"),
    leftHand = include("cards/leftHand"),
    blackPill = include("cards/blackPill"),
    whiteSpottedPill = include("cards/whiteSpottedPill"),
    whitePill = include("cards/whitePill"),
    questionCard = include("cards/questionCard"),
    getOutOfJail = include("cards/getOutOfJail"),
    goldKey = include("cards/goldKey"),
    rainbowTapeworm = include("cards/rainbowTapeworm")
}

local holoCards = {}

for key, card in pairs(cards) do
    Isaac.DebugString(key)
    card.HUDAnimationName = "Idle"
    card.PickupAnimationName = "Idle"
    card.UseAnimationName = "IdleFast"

    local holoCard = table.deepCopy(card)
    holoCard.Holographic = true
    holoCard.HUDAnimationName = "IdleHolo"
    holoCard.PickupAnimationName = "IdleHolo"
    holoCard.UseAnimationName = "IdleFastHolo"
	holoCard.Descriptions.en_us = holoCard.Descriptions.en_us .. "#{{ColorRainbow}}HOLOGRAPHIC: Effect doubled!"

    local callbacks = {}

    for _, callback in pairs(card.callbacks) do
        if callback[1] == ModCallbacks.MC_USE_CARD then
            table.insert(callbacks, callback)
        end
    end

    holoCard.callbacks = callbacks

    local holographicCardName = "Holographic "..card.Name
    local holographicCardId = Isaac.GetCardIdByName(holographicCardName)

    holoCard.Tag = "holographic"..card.Tag
    holoCard.Id = holographicCardId

    holoCards[holoCard.Tag] = holoCard
end

lootcards = cards

for tag, card in pairs(holoCards) do
    lootcards[tag] = card
end
