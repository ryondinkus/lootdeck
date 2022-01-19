function LootDeckAPI.GenerateEncyclopediaPage(...)
    local output = {
        {str = "Effect", fsize = 2, clr = 3, halign = 0}
    }

    for _, description in pairs({...}) do
        table.insert(output, {str = description})
    end

    return {output}
end

function LootDeckAPI.AddExternalItemDescriptionCard(card)
	if EID and (card.Descriptions or card.HolographicDescriptions) then

		local cardFrontPathTag = card.Tag
		local descriptions = card.Descriptions
		if card.IsHolographic then
			cardFrontPathTag = cardFrontPathTag:gsub("holographic", "")
			descriptions = card.HolographicDescriptions
		end

        LootDeckAPI.RegisterExternalItemDescriptionLanguages(card.Id, card.Names, descriptions, EID.addCard)

		local cardFrontPath = string.format("gfx/ui/lootcard_fronts/%s.png", cardFrontPathTag)
		local cardFrontSprite = Sprite()
        cardFrontSprite:Load("gfx/ui/eid_lootcard_fronts.anm2", true)
		cardFrontSprite:ReplaceSpritesheet(0, cardFrontPath)
		cardFrontSprite:LoadGraphics()
		local cardFrontAnim = "Idle"
		if card.IsHolographic then
			cardFrontAnim = "IdleHolo"
		end
		EID:addIcon("Card"..card.Id, cardFrontAnim, -1, 8, 8, 0, 1, cardFrontSprite)
	end
end

function LootDeckAPI.AddExternalItemDescriptionItem(item)
	if EID and item.Descriptions then
        LootDeckAPI.RegisterExternalItemDescriptionLanguages(item.Id, item.Names, item.Descriptions, EID.addCollectible)
	end
end

function LootDeckAPI.AddExternalItemDescriptionTrinket(trinket)
	if EID and trinket.Descriptions then
        LootDeckAPI.RegisterExternalItemDescriptionLanguages(trinket.Id, trinket.Names, trinket.Descriptions, EID.addTrinket)
	end
end

function LootDeckAPI.RegisterExternalItemDescriptionLanguages(id, names, descriptions, func)
    if EID and descriptions then
		for language, description in pairs(descriptions) do
			func(EID, id, description, names[language], language)
		end
	end
end

function LootDeckAPI.PrintError(msg, ...)
	local params = {...}
	
	local error = "[LootDeckAPI] Error | "..string.format(msg, table.unpack(params) or "")
	print(error)
	Isaac.DebugString(error)
end