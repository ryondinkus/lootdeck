local helper = lootdeckHelpers
local costumes = include("costumes/registry")

-- Gives magneto effect for the room and a glowing costume
local Names = {
    en_us = "XII. The Hanged Man",
    spa = "XII. El Colgado"
}
local Name = Names.en_us
local Tag = "theHangedMan"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants the {{Collectible53}} Magneto effect for the room, causing pickups to be drawn towards you",
    spa = "Otorga el efecto del {{Collectible53}} Imán durante la habitación"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants the Magneto effect for the room, which causes pickups to be drawn toward your position.", "Holographic Effect: Fills in all holes in the current room.")

local function MC_USE_CARD(_, c, p, f, shouldDouble)
	local room = Game():GetRoom()
	for i=0,room:GetGridSize() do
		local gridEntity = room:GetGridEntity(i)
		if gridEntity and gridEntity:ToPit() then
			gridEntity:ToPit():MakeBridge(gridEntity)
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, gridEntity.Position, Vector.Zero, nil)
		end
		if shouldDouble then
			if gridEntity then
				gridEntity:Destroy()
			end
		end
	end
	lootdeck.sfx:Play(SoundEffect.SOUND_ROCK_CRUMBLE)
	Game():ShakeScreen(15)
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
