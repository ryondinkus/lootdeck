local helper = include('helper_functions')

-- Allows player to phase through enemies and projectiles for 5 seconds
local Name = "Get out of Jail Card"
local Tag = "getOutOfJail"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1

local function MC_USE_CARD(_, c, p)
    p:GetData()[Tag] = 5 * 60
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
        if data[Tag] - 1 > 0 then
            data[Tag] = data[Tag] - 1
        else
            data[Tag] = nil
        end
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
