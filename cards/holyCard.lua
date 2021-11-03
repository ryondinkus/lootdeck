local helper = include('helper_functions')
local entityVariants = include("entityVariants/registry")

-- Spawns 10 "Holy Shield" familiars that block bullets and die after blocking
local Names = {
    en_us = "Holy Card",
    spa = "Carta Sagrada"
}
local Name = Names.en_us
local Tag = "holyCard"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Spawns 10 Holy Shield orbitals, which die after blocking one projectile.",
    spa = "Genera 10 Escudos Sagrados orbitales, se destruyen al bloquear un proyectil"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Spawns 10 Holy Shield orbitals. Holy Shields can block one projectile, which causes them to break.")

local function MC_USE_CARD(_, c, p)
    helper.RemoveHitFamiliars(entityVariants.holyShield.Id)
	local data = p:GetData()
	data[Tag] = 1
	helper.SimpleLootCardSpawn(p, EntityType.ENTITY_FAMILIAR, entityVariants.holyShield.Id, 0, 10, Vector.Zero, SoundEffect.SOUND_HOLY)
	local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 5, p.Position, Vector.Zero, p)
	poof.Color = Color(1,1,1,1,1,1,1)
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
