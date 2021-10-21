local helper = include('helper_functions')

-- Allows player to phase through enemies and projectiles for 5 seconds
local Name = "Get out of Jail Card"
local Tag = "getOutOfJail"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Description = "Grants the player invincibility and the ability to phase through enemies for 5 seconds"
local WikiDescription = {{ -- Effect
							{str = "Effect", fsize = 2, clr = 3, halign = 0},
							{str = "For 5 seconds, the player is invincibile and can phase through enemies."},
						}}

local function MC_USE_CARD(_, c, p)
    local data = p:GetData()
    data[Tag] = 5 * 60
    data[Tag .. "Color"] = p.Color
    p.Color = Color(p.Color.R,p.Color.G,p.Color.B,0.5,p.Color.RO,p.Color.GO,p.Color.BO)
    local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
    poof.Color = Color(1,1,1,1,1,1,1)
    lootdeck.sfx:Play(SoundEffect.SOUND_MIRROR_ENTER, 1, 0)
end

local function MC_PRE_PLAYER_COLLISION(_, p, collider)
    local data = p:GetData()
    if data[Tag] then
        if collider.Type == EntityType.ENTITY_PROJECTILE or collider:IsEnemy() then
            return true
        end
    end
end

local function MC_POST_PLAYER_UPDATE(_, p)
    local data = p:GetData()
    if data[Tag] then
        local alpha = p.Color.A
        if data[Tag] - 1 > 0 then
            data[Tag] = data[Tag] - 1
            if data[Tag] % 60 == 0 then
                alpha = 0.5
                lootdeck.sfx:Play(SoundEffect.SOUND_SOUL_PICKUP, 1, 0)
            else
                alpha = 0.25
            end
        else
            data[Tag] = nil
            alpha = 1
            lootdeck.sfx:Play(SoundEffect.SOUND_MIRROR_EXIT, 1, 0)
            local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, p.Position, Vector.Zero, p)
            poof.Color = Color(1,1,1,1,1,1,1)
        end
        p.Color = Color(p.Color.R,p.Color.G,p.Color.B,alpha,p.Color.RO,p.Color.GO,p.Color.BO)
    end
end

local function MC_ENTITY_TAKE_DMG(_, entity)
    local p = entity:ToPlayer() or 0

    if p ~= 0 and p:GetData()[Tag] then
        return false
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id
        },
        {
            ModCallbacks.MC_PRE_PLAYER_COLLISION,
            MC_PRE_PLAYER_COLLISION
        },
        {
            ModCallbacks.MC_POST_PLAYER_UPDATE,
            MC_POST_PLAYER_UPDATE
        },
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        }
    }
}
