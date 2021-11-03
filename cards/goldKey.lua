local helper = include("helper_functions")

-- Spawns a permacharmed void portal
local Names = {
    en_us = "Gold Key",
    spa = "Llave Dorada"
}
local Name = Names.en_us
local Tag = "goldKey"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a permanently charmed Portal enemy, who spawns other permanently charmed enemies until disappearing",
    spa = "Genera un enemigo Portal encantado, quien genera otros enemigos encantados hasta desaparecer"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a permanently charmed Portal enemy. Portal will spawn other permanently charmed enemies until it disappears.")

local function MC_USE_CARD(_, c, p)
    local enemy = Isaac.Spawn(EntityType.ENTITY_PORTAL, 0, 0, Game():GetRoom():FindFreePickupSpawnPosition(p.Position, 0, true), Vector.Zero, p)
    enemy:GetSprite():ReplaceSpritesheet(0, "gfx/monsters/gold_portal.png")
    enemy:GetSprite():ReplaceSpritesheet(2, "gfx/monsters/gold_portal.png")
    enemy:GetSprite():ReplaceSpritesheet(3, "gfx/monsters/gold_portal.png")
    enemy:GetSprite():LoadGraphics()
    enemy:AddCharmed(EntityRef(p), -1)
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
        }
    }
}
