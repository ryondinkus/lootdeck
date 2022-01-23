local helper = LootDeckAPI

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
    en_us = "On use, fills in all the pits in the current room with rock bridges",
    spa = "Al usarse, rellena todos los precipicios y acantilados en la sala con puentes de piedra"
}
local HolographicDescriptions = {
    en_us = "On use, fills in all the pits in the current room with rock bridges#{{ColorRainbow}}Destroys all rocks in the room",
    spa = "Al usarse, rellena todos los precipicios y acantilados en la sala con puentes de piedra#{{ColorRainbow}}Destruye todos los piedras en la sala"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Fills in all holes in the current room.# Holographic Effect: Breaks all rocks in the room")

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
    HolographicDescriptions = HolographicDescriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    },
    Tests = function()
        return {
            {
                name = Tag.."Use",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC,
                        seed = "QF4H QV36"
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "stage 4"
                    },
                    {
                        action = "GO_TO_DOOR",
                        slot = DoorSlot.RIGHT0
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    }
                }
            }
        }
    end
}
