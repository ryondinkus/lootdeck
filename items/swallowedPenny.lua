local helper = lootdeckHelpers

-- Gives a chance for a coin to spawn when the player takes damage
local Names = {
    en_us = "Swallowed Penny",
    spa = "Moneda Tragada"
}
local Name = Names.en_us
local Tag = "swallowedPenny"
local Id = Isaac.GetItemIdByName(Name)
local Descriptions = {
    en_us = "50% chance to drop a penny after taking damage",
    spa = "50% de posibilidad de generar un penny al recibir daño"
}
local WikiDescription = helper.GenerateEncyclopediaPage("50% chance to drop a penny after taking damage.", "- Increased chance to drop a penny for every extra copy of Swallowed Penny.")

local function MC_ENTITY_TAKE_DMG(_, e)
    local p = e:ToPlayer()
    local rng = p:GetCollectibleRNG(Id)
    if p:HasCollectible(Id) then
        for i=1,p:GetCollectibleNum(Id) do
            local tear = p:FireTear(p.Position, Vector.FromAngle(rng:RandomInt(360)) * 10, false, true, false, p, 2)
			tear:ChangeVariant(TearVariant.COIN)
			tear:GetData()[Id] = true
			p:AddCoins(-1)
			lootdeck.sfx:Play(SoundEffect.SOUND_LITTLE_SPIT, 1, 0)
		end
    end
end

local function MC_POST_ENTITY_REMOVE(_, tear)
	local tearData = tear:GetData()
	print('hullo')
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
    callbacks = {
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
