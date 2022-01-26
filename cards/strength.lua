local helper = LootDeckAPI
local costumes = include("costumes/registry")

local Names = {
    en_us = "XI. Strength",
    spa = "XI. Fuerza"
}
local Name = Names.en_us
local Tag = "strength"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "{{ArrowUp}} +0.25 Damage for each enemy killed in the room until the end of the floor",
    spa = "{{ArrowUp}} +0.25 de daño para todos los enemigos derrotós en la habitación durante todo el piso"
}
local HolographicDescriptions = {
    en_us = "{{ArrowUp}} {{ColorRainbow}}+0.5{{CR}} Damage for each enemy killed in the room until the end of the floor",
    spa = "{{ArrowUp}} {{ColorRainbow}}+0.5{{CR}} de daño para todos los enemigos derrotós en la habitación durante todo el piso"
}
local WikiDescription = helper.GenerateEncyclopediaPage("+0.25 Damage Up for each enemy killed in the room for the rest of the floor.", "Holographic Effect: Grants a +0.5 damage up for each enemy instead.")

local function MC_USE_CARD(_, c, p)
    local data = helper.GetLootDeckData(p)
    local sprite = p:GetSprite()
    if not data[Tag] then
        data[Tag] = lootdeck.f.enemiesKilledInRoom
    else
        data[Tag] = data[Tag] + lootdeck.f.enemiesKilledInRoom
    end
    print(data[Tag])
    for i=1,data[Tag] or 0 do
        local color = Color(1, 1, 1, 1, data[Tag] / 10, 0, 0)
        sprite.Color = color
    end
	p:AddNullCostume(costumes.strengthFire)
    p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    p:EvaluateItems()
    lootdeck.sfx:Play(SoundEffect.SOUND_LAZARUS_FLIP_ALIVE, 1, 0)
end

local function MC_EVALUATE_CACHE(_, p, f)
    local data = helper.GetLootDeckData(p)
    if f == CacheFlag.CACHE_DAMAGE then
        if data[Tag] then
            p.Damage = p.Damage + (data[Tag] * 0.25)
        end
    end
end

local function MC_ENTITY_TAKE_DMG(_, e, amount, flags, source)
    if e.Type ~= EntityType.ENTITY_FIREPLACE and e:IsVulnerableEnemy() and amount >= e.HitPoints then
        lootdeck.f.enemiesKilledInRoom = lootdeck.f.enemiesKilledInRoom + 1
    end
end

local function MC_POST_NEW_ROOM()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            p:TryRemoveNullCostume(costumes.strengthFire)
            p:AddNullCostume(costumes.strengthGlow)
        end
    end)
    lootdeck.f.enemiesKilledInRoom = 0
end

local function MC_POST_NEW_LEVEL()
    helper.ForEachPlayer(function(p, data)
        if data[Tag] then
            data[Tag] = nil
            local color = Color(1,1,1,1,0,0,0)
            p.Color = color
            p:TryRemoveNullCostume(costumes.strengthFire)
            p:TryRemoveNullCostume(costumes.strengthGlow)
            p:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            p:EvaluateItems()
        end
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
            Id,
            true
        },
        {
            ModCallbacks.MC_EVALUATE_CACHE,
            MC_EVALUATE_CACHE
        },
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG
        },
        {
            ModCallbacks.MC_POST_NEW_ROOM,
            MC_POST_NEW_ROOM
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    }
}
