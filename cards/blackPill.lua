local helper = include('helper_functions')

-- Instakill all enemies in room (80 dmg on bosses) | Confuse all enemies in room | Deal full heart of damage
local Name = "Pills! Black"
local Tag = "blackPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    local sfx = lootdeck.sfx
	local effect = lootdeck.rng:RandomInt(3)
	if effect == 0 then
        sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)
        local illegalParents = {
            EntityType.ENTITY_GEMINI, -- gemini's umbilical cord
            EntityType.ENTITY_THE_HAUNT, -- the haunt's minions
            EntityType.ENTITY_FORSAKEN, -- the forsaken's minions
            EntityType.ENTITY_HERETIC, -- the forsaken's minions
        }

        helper.ForEachEntityInRoom(function(entity)
            entity:Kill()
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, p)
            poof.Color = Color(0,0,0,1,0,0,0)
        end, nil, nil, nil,
        function(entity)
            local npc = entity:ToNPC()
            return npc and not npc:IsBoss() and npc:IsVulnerableEnemy() and not helper.TableContains(illegalParents, npc.SpawnerType or 0)
        end)

        helper.ForEachEntityInRoom(function(entity)
            entity:TakeDamage(80, 0, EntityRef(p), 0)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, p)
            poof.Color = Color(0,0,0,1,0,0,0)
        end, nil, nil, nil,
        function(entity)
            local npc = entity:ToNPC()
            return npc and npc:IsVulnerableEnemy()
        end)
	elseif effect == 1 then
        helper.ForEachEntityInRoom(function(entity)
            entity:AddConfusion(EntityRef(f), 150, false)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, p)
            poof.Color = Color(1,1,1,1,1,1,1)
        end, nil, nil, nil,
        function(entity)
            local npc = entity:ToNPC()
            return npc and npc:IsVulnerableEnemy()
        end)
		sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
	else
		helper.TakeSelfDamage(p, 2)
		sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
	end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        }
    }
}
