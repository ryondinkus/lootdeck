local helper = lootdeckHelpers

-- Spawns 1-3 of a pickup determined by the Glyph of Balance algorithm
local Names = {
    en_us = "XX. Judgement",
    spa = "XX. Juicio"
}
local Name = Names.en_us
local Tag = "judgement"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns 1-3 consumables based on the {{Collectible464}} Glyph of Balance algorithm, spawning whatever consumables you have the least of",
    spa = "Genera 1-3 recolectables basándose en el algoritmo de {{Collectible464}} Glifo de Blance, generando los recolectables que en menor cantidad poseas"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns 1-3 consumables based on the Glyph of Balance algorithm. This spawns whatever consumable you have least of.", "Holographic Effect: Spawns twice as many consumables.")

local function MC_USE_CARD(_, c, p)
    local reward = helper.GlyphOfBalance(p)
    local room = Game():GetRoom()
    for i=0,lootdeck.rng:RandomInt(3) do
        helper.Spawn(EntityType.ENTITY_PICKUP, reward[1], reward[2], room:FindFreePickupSpawnPosition(p.Position), Vector.Zero, nil)
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
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
            true
        }
    }
}
