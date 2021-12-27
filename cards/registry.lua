local cards = {
    include("cards/penny"),
    include("cards/twoCents"),
    include("cards/threeCents"),
    include("cards/fourCents"),
    include("cards/nickel"),
    include("cards/dime"),
    include("cards/butterBean"),
    include("cards/redPill"),
    include("cards/bluePill"),
    include("cards/yellowPill"),
    include("cards/bomb"),
    include("cards/goldBomb"),
    include("cards/lilBattery"),
    include("cards/megaBattery"),
    include("cards/diceShard"),
    include("cards/soulHeart"),
    include("cards/blankRune"),
    include("cards/dagaz"),
    include("cards/ehwaz"),
    include("cards/bloodyPenny"),
    include("cards/swallowedPenny"),
    include("cards/counterfeitPenny"),
    include("cards/cainsEye"),
    include("cards/brokenAnkh"),
    include("cards/curvedHorn"),
    include("cards/purpleHeart"),
    include("cards/goldenHorseshoe"),
    include("cards/guppysHairball"),
    include("cards/lostSoul"),
    include("cards/theFool"),
    include("cards/theMagician"),
    include("cards/theHighPriestess"),
    include("cards/theEmpress"),
    include("cards/theEmperor"),
    include("cards/theHierophant"),
    include("cards/theLovers"),
    include("cards/theChariot"),
    include("cards/justice"),
    include("cards/theHermit"),
    include("cards/wheelOfFortune"),
    include("cards/strength"),
    include("cards/theHangedMan"),
    include("cards/death"),
    include("cards/theTower"),
    include("cards/theDevil"),
    include("cards/temperance"),
    include("cards/theStars"),
    include("cards/theMoon"),
    include("cards/theSun"),
    include("cards/judgement"),
    include("cards/theWorld"),
    include("cards/chargedPenny"),
    include("cards/joker"),
    include("cards/holyCard"),
    include("cards/twoOfDiamonds"),
    include("cards/aSack"),
    include("cards/creditCard"),
    include("cards/jera"),
    include("cards/purplePill"),
    include("cards/pinkEye"),
    include("cards/cancer"),
    include("cards/perthro"),
    include("cards/ansuz"),
    include("cards/blackRune"),
    include("cards/tapeWorm"),
    include("cards/aaaBattery"),
    include("cards/pokerChip"),
    include("cards/leftHand"),
    include("cards/blackPill"),
    include("cards/whiteSpottedPill"),
    include("cards/whitePill"),
    include("cards/questionCard"),
    include("cards/getOutOfJail"),
    include("cards/goldKey"),
    include("cards/rainbowTapeworm")
}

local holoCards = {}

for _, card in pairs(cards) do
    table.insert(holoCards, LootDeckHelpers.GenerateHolographicCard(card))
end

lootcards = {}

for _, card in pairs(cards) do
    lootcards[card.Id] = card
end

for _, card in pairs(holoCards) do
    lootcards[card.Id] = card
end

lootcardKeys = {}

for _, card in pairs(lootcards) do
    lootcardKeys[card.Tag] = card
end
