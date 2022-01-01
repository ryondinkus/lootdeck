local helper = LootDeckHelpers

local entityVariants = include("entityVariants/registry")

local Names = {
    en_us = "Lost Soul",
    spa = "Alma Perdida"
}
local Name = Names.en_us
local Tag = "lostSoul"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns a Lost Soul familiar, who will discover Tinted Rocks and Secret Rooms and blow them up# If used while a Lost Soul already exists, it will spawn a Found Soul instead. The two souls will fall in love, spawn a Soul Heart, and fly away.",
    spa = "Añade un objeto pasivo tras usarla#Efecto pasivo: Genera un Alma Perdida familiar, que encontrará las piedras marcadas y entradas a Salas Secretas y las explotará#Si ya se tiene un Alma Perdida, se generará un Alma Encontrada en su lugar en medio de la habitación, las dos almas se enamorarán y volarán lejos, soltando un corazón rojo"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns a Lost Soul familiar, who will discover Tinted Rocks and Secret Rooms and blow them up.", "- Lost Soul will prioritize Secret Rooms over Tinted Rocks.", "If used while a Lost Soul familiar already exists, it will instead spawn a Found Soul in the center of the room. The two souls will fall in love and fly away, spawning one Soul Heart.", "Holographic Effect: Spawns two Lost Souls, who instantly fall in love and spawn a Soul Heart.")

local function MC_USE_CARD(_, c, p)
    local room = Game():GetRoom()
    local f = lootdeck.f
    if not f.lostSoul then
        Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.lostSoulBaby.Id, 0, p.Position, Vector.Zero, p)
        f.lostSoul = true
    else
        local foundSoul = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.lostSoulLove.Id, 0, room:FindFreePickupSpawnPosition(room:GetCenterPos()), Vector.Zero, p)
        foundSoul:AddEntityFlags(EntityFlag.FLAG_NO_PHYSICS_KNOCKBACK | EntityFlag.FLAG_NO_KNOCKBACK)
        f.lostSoul = false
    end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
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
