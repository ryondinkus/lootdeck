local helper = include("helper_functions")

-- On damamge taken, chance to fire a poison creep tear at attacker
local Name = "Pink Eye"
local Tag = "pinkEye"
local Id = Isaac.GetItemIdByName(Name)
local Description = "On damage taken, 5% chance to fire a {{Collectible531}} Haemolacria tear with poisonous green creep towards your attacker"
local WikiDescription = helper.GenerateEncyclopediaPage("On damage taken, 5% chance to fire a Haemolacria tear with poisonous green creep towards the enemy that damaged you.", "- Additional copies of the passive grant an extra 5% chance to trigger up to 25%.")

local function MC_ENTITY_TAKE_DMG(_, e, amount, flags, source)
    local p = e:ToPlayer()
    if p:HasCollectible(Id) then
        if helper.PercentageChance(5 * p:GetCollectibleNum(Id), 25) then
            local target = source
            if source.Type == EntityType.ENTITY_PROJECTILE then
                target = source.Entity.SpawnerEntity
            end

            if target == nil then
                return
            end

            local targetDir = (target.Position - p.Position):Normalized() * 5
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.EYE_BLOOD, 0, p.Position, targetDir, nil):ToTear()
            tear.CollisionDamage = tear.CollisionDamage * 2
            tear.Size = tear.Size * 2
            tear.Scale = tear.Scale * 2
            local poisonFlags = helper.NewTearflag(4) | helper.NewTearflag(62) | helper.NewTearflag(33)
            tear:GetData().arc = true
            tear:AddTearFlags(poisonFlags)
            tear.FallingSpeed = -20
        end
    end
end

local function MC_POST_TEAR_UPDATE(_, t)
    local data = t:GetData()
    if data.arc then
        t.FallingAcceleration = t.FallingAcceleration + 0.1
    end
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Description = Description,
    WikiDescription = WikiDescription,
    callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        },
        {
            ModCallbacks.MC_POST_TEAR_UPDATE,
            MC_POST_TEAR_UPDATE
        }
    }
}
