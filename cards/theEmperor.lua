local helper = include("helper_functions")
local costumes = include("costumes/registry")

-- Permacharms all enemies in the room
local Names = {
    en_us = "IV. The Emperor",
    spa = "IV. El Emperador"
}
local Name = Names.en_us
local Tag = "theEmperor"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
	en_us = "Permanently charms every enemy in the room, excluding bosses",
	spa = "Aplica encantamiento permanente a todos los enemigos de la habitación, exceptuando a los jefes"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Permanently charms every enemy in the room. This does not include bosses.")

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    data[Tag] = {}
	local illegalParents = {
		EntityType.ENTITY_GEMINI, -- gemini's umbilical cord
		EntityType.ENTITY_THE_HAUNT, -- the haunt's minions
		EntityType.ENTITY_FORSAKEN, -- the forsaken's minions
		EntityType.ENTITY_HERETIC, -- the forsaken's minions
	}
	helper.ForEachEntityInRoom(function(entity)
		entity:AddCharmed(EntityRef(p), -1)
        table.insert(data[Tag], entity)
	end, nil, nil, nil,
	function(entity)
		local npc = entity:ToNPC()
		return npc and not npc:IsBoss() and npc:IsVulnerableEnemy() and not helper.TableContains(illegalParents, npc.SpawnerType or 0)
	end)
    p:AddNullCostume(costumes.emperor)
    lootdeck.sfx:Play(SoundEffect.SOUND_HAPPY_RAINBOW, 1, 0)
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            for k,v in pairs(data[Tag]) do
                if v:Exists() then return end
            end
        end
        p:TryRemoveNullCostume(costumes.emperor)
        data[Tag] = nil
    end)
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
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        }
    }
}
