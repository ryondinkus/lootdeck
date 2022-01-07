local helper = LootDeckAPI

-- Gives a chance for a coin to spawn when the player takes damage
local Names = {
    en_us = "Swallowed Penny",
    spa = "Moneda Tragada"
}
local Name = Names.en_us
local Tag = "swallowedPenny"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "On damage taken, lose 1 cent and fire a penny tear in a random direction# The penny tear has 2x damage and drops a Penny and a puddle of creep when it makes contact",
    spa = "Al recibir daño, perderás y dispararás una moneda en una dirección aleatoria# Esta moneda hace tu daño x2 y genera tanto una moneda como un charco de Creep al hacer contacto"
}
local WikiDescription = helper.GenerateEncyclopediaPage("On damage taken, lose 1 cent and fire a penny tear in a random direction", "- The penny tear will have 2x damage.", "- On contact with enemies, obstacles, or the floor, penny tears will turn into a normal Penny (or rarely, other coin types) and leave a puddle of creep behind.", "- Additional copies will fire extra penny tears in random directions, at the cost of additional cents.")

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    local rng = p:GetCollectibleRNG(Id)
    if p:HasCollectible(Id) then
        for i=1,p:GetCollectibleNum(Id) do
            if p:GetNumCoins() > 0 then
                local tear = p:FireTear(p.Position, Vector.FromAngle(rng:RandomInt(360)) * 10, false, true, false, p, 2)
                tear:ChangeVariant(TearVariant.COIN)
                tear:GetData()[Id] = true
                p:AddCoins(-1)
                lootdeck.sfx:Play(SoundEffect.SOUND_LITTLE_SPIT, 1, 0)
            end
		end
    end
end

local function MC_POST_ENTITY_REMOVE(_, tear)
	local tearData = tear:GetData()
	if tearData[Id] then
		local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLYWATER_TRAIL, 0, tear.Position, Vector.Zero, tear)
		helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0, tear.Position, tear.Velocity:Normalized(), tear)
		effect:GetSprite().Scale = Vector(2,2)
		tearData[Id] = nil
	end
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Descriptions = Descriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_ENTITY_TAKE_DMG,
            MC_ENTITY_TAKE_DMG,
            EntityType.ENTITY_PLAYER
        },
		{
            ModCallbacks.MC_POST_ENTITY_REMOVE,
            MC_POST_ENTITY_REMOVE,
        }
    }
}
