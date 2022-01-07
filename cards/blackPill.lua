local helper = LootDeckAPI

-- Instakill all enemies in room (80 dmg on bosses) | Confuse all enemies in room | Deal full heart of damage
local Names = {
    en_us = "Pills! Black",
    spa = "¡Píldora! Negra"
}
local Name = Names.en_us
local Tag = "blackPill"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Random chance for any of these effects:# Instantly kill all enemies in the room (80 damage to bosses)# Confuses all room enemies#{{Warning}} Take a Full Heart of damage (non-fatal)",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Matar a todos los enemigos de la habitación instantaneamente (80 de daño a jefes)#Confundir a todos los enemigos de la habitación#{{Warning}} Recibir un corazón de daño (no fatal)"
}
local HolographicDescriptions = {
    en_us = "Random chance for any of these effects:# Instantly kill all enemies in the room ({{ColorRainbow}}160{{CR}} damage to bosses)# Confuses all room enemies#{{Warning}} Take {{ColorRainbow}}2 Full Hearts{{CR}} of damage (non-fatal)",
    spa = "Probabilidad de que ocurra uno de los siguientes efectos:#Matar a todos los enemigos de la habitación instantaneamente (({{ColorRainbow}}160{{CR}} de daño a jefes)#Confundir a todos los enemigos de la habitación#{{Warning}} Recibir {{ColorRainbow}}2 corazónes{{CR}} de daño (no fatal)"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On use, triggers one of three effects:", "- Instantly kills all enemies in the room. Deals 80 damage to bosses.", "- Confuses all enemies in the room for 5 seconds.", "- Take a Full Heart of damage. The damage will be negated if it would kill the player.", "Holographic Effect: Performs the same random effect twice.")

local function MC_USE_CARD(_, c, p, f, shouldDouble, isDouble, rng)
    local sfx = lootdeck.sfx

    return helper.RunRandomFunction(rng, shouldDouble,
        function()
            sfx:Play(SoundEffect.SOUND_DEATH_CARD,1,0)

            helper.ForEachEntityInRoom(function(entity)
                entity:Kill()
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, p)
                poof.Color = Color(0,0,0,1,0,0,0)
            end, nil, nil, nil,
            function(entity)
                local npc = entity:ToNPC()
                return npc and not npc:IsBoss() and npc:IsVulnerableEnemy()
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
        end,
        function()
            helper.ForEachEntityInRoom(function(entity)
                entity:AddConfusion(EntityRef(p), 150, false)
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, entity.Position, Vector.Zero, p)
                poof.Color = Color(1,1,1,1,1,1,1)
            end, nil, nil, nil,
            function(entity)
                local npc = entity:ToNPC()
                return npc and npc:IsVulnerableEnemy()
            end)
            sfx:Play(SoundEffect.SOUND_THUMBSUP	,1,0)
        end,
        function()
            helper.TakeSelfDamage(p, 2)
            sfx:Play(SoundEffect.SOUND_THUMBS_DOWN,1,0)
            return false
        end)
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
    }
}
