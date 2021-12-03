local helper = lootdeckHelpers

-- Rerolls the enemies in the room using the D10
local Names = {
    en_us = "Ehwaz",
    spa = "Ehwaz"
}
local Name = Names.en_us
local Tag = "ehwaz"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{Collectible285}} D10 effect on use, rerolling all enemies in the room.# All rerolled enemies will have 50% HP.",
    spa = "Efecto del {{Collectible285}} D10, al usarse rerolea a todos los enemigos de la habitación#Todos los enemigos reroleados tendrán 50% de salud"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers the D10 effect, rerolling all enemies in the room.", "All rerolled enemies will have 50% HP.", "Holographic Effect: Rerolls all room enemies, then rerolls them again.")

local function MC_USE_CARD(_, c, p)
	helper.UseItemEffect(p, CollectibleType.COLLECTIBLE_D10, SoundEffect.SOUND_LAZARUS_FLIP_DEAD)
    helper.ForEachEntityInRoom(function(entity)
		entity:AddHealth(-(entity.HitPoints/2))
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0, entity.Position, Vector.Zero, nil)
	end, nil, nil, nil,
	function(entity)
		local npc = entity:ToNPC()
		return npc and not npc:IsBoss() and npc:IsVulnerableEnemy()
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
            Id,
            true,
            0.25
        }
    }
}
