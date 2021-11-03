local entityVariants = include("entityVariants/registry")
local helper = include("helper_functions")

-- A 1 in 3 chance of spawning a tarotcard, thee tarotcards, or losing one coin, bomb, and key
local Names = {
    en_us = "Pills! Blue",
    spa = "¡Píldora! Azul"
}
local Name = Names.en_us
local Tag = "bluePill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "Random chance for any of these effects:#{{Card}} Spawn 1 Loot Card#{{Card}} Spawn 3 Loot Cards#{{ArrowDown}} Lose a Coin, Bomb, and Key",
	spa = "Probabilidad de que ocurra uno de los siguientes efectos:#{{Card}} Genera una carta de loor#{{Card}} Genera 3 cartas de loot#Pierdes una moneda, una llave y una bomba"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Spawns a Loot Card.", "- Spawns 3 Loot Cards", "- Lose a Coin, Key, and Bomb, if possible.")

local function MC_USE_CARD(_, c, p)
	local sfx = lootdeck.sfx
	local rng = lootdeck.rng
	local effect = rng:RandomInt(3)
	local room = Game():GetRoom()
	if effect == 0 then
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		local cardId = helper.GetWeightedLootCardId()
		Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
	elseif effect == 1 then
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
		for i=0,2 do
			local cardId = helper.GetWeightedLootCardId()
			Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardId, room:FindFreePickupSpawnPosition(p.Position), Vector.FromAngle(rng:RandomInt(360)), nil)
		end
	else
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
		if p:GetNumCoins() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostPenny.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddCoins(-1)
		end
		if p:GetNumBombs() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostBomb.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddBombs(-1)
		end
		if p:GetNumKeys() > 0 then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, entityVariants.lostKey.Id, 0, p.Position, Vector.FromAngle(rng:RandomInt(360))*2, p)
			p:AddKeys(-1)
		end
	end
end

return {
    Name = Name,
	Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
	Descriptions = Descriptions,
	WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
