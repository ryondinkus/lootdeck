local H = {}

function lootdeckHelpers.GenerateEncyclopediaPage(...)
    local output = {
        {str = "Effect", fsize = 2, clr = 3, halign = 0}
    }

    for _, description in pairs({...}) do
        table.insert(output, {str = description})
    end

    return {output}
end

function lootdeckHelpers.AddExternalItemDescriptionCard(card)
	if EID and card.Descriptions then
        lootdeckHelpers.RegisterExternalItemDescriptionLanguages(card, EID.addCard)
		local cardFrontPathTag = card.Tag
		if card.Holographic then
			cardFrontPathTag = cardFrontPathTag:gsub("holographic", "")
		end
		local cardFrontPath = string.format("gfx/ui/lootcard_fronts/%s.png", cardFrontPathTag)
		local cardFrontSprite = Sprite()
        cardFrontSprite:Load("gfx/ui/eid_lootcard_fronts.anm2", true)
		cardFrontSprite:ReplaceSpritesheet(0, cardFrontPath)
		cardFrontSprite:LoadGraphics()
		local cardFrontAnim = "Idle"
		if card.Holographic then
			cardFrontAnim = "IdleHolo"
		end
		EID:addIcon("Card"..card.Id, cardFrontAnim, -1, 8, 8, 0, 1, cardFrontSprite)
	end
end

function lootdeckHelpers.AddExternalItemDescriptionItem(item)
	if EID and item.Descriptions then
        lootdeckHelpers.RegisterExternalItemDescriptionLanguages(item, EID.addCollectible)
	end
end

function lootdeckHelpers.AddExternalItemDescriptionTrinket(trinket)
	if EID and trinket.Descriptions then
        lootdeckHelpers.RegisterExternalItemDescriptionLanguages(trinket, EID.addTrinket)
	end
end

function lootdeckHelpers.RegisterExternalItemDescriptionLanguages(obj, func)
    for language, description in pairs(obj.Descriptions) do
        func(EID, obj.Id, description, obj.Names[language], language)
    end
end

return H