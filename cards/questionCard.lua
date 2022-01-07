local helper = LootDeckAPI

-- Spawns a permacharmed copy of an enemy in the room, spawns a random permacharmed enemy if no enemies in room
local Names = {
    en_us = "? Card",
    spa = "Carta ¿?"
}
local Name = Names.en_us
local Tag = "questionCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a permanently charmed clone of a random enemy in the room# If there are no enemies, spawns a permanently charmed Gaper",
    spa = "Genera un clon encantado de un enemigo en la habitación#Si no hay enemigos en la habitación, genera un Gaper encantado"
}
local HolographicDescriptions = {
    en_us = "Spawns {{ColorRainbow}}2{{CR}} permanently charmed clones of a random enemy in the room# If there are no enemies, spawns {{ColorRainbow}}2{{CR}} permanently charmed Gapers",
    spa = "Genera {{ColorRainbow}}2{{CR}} clones encantados de un enemigo en la habitación#Si no hay enemigos en la habitación, genera {{ColorRainbow}}2{{CR}} Gapers encantados"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a permanently charmed copy of a random enemy in the room.", "If no enemies are in the room on use, spawns a permanently charmed Smiling Gaper.", "Holographic Effect: Spawns two charmed copies of two different random enemies.")

local function MC_USE_CARD(_, c, p, f, _, _, rng)
    local enemy = helper.GetRandomEnemy(rng, nil, function(entity) return not entity:IsBoss() and not EntityRef(entity).IsCharmed end)

    local friend
    if enemy then
        friend = Isaac.Spawn(enemy.Type, enemy.Variant, enemy.SubType, p.Position, Vector.Zero, p)
    else
        friend = Isaac.Spawn(EntityType.ENTITY_GAPER, 1, 0, p.Position, Vector.Zero, p)
    end

    friend:AddCharmed(EntityRef(p), -1)
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
        }
    }
}
