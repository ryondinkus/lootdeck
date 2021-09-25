local Name = "Credit Card Baby"
local Tag = "creditCardBaby"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_INIT(_, f)
    f:AddToFollowers()
end

local function MC_FAMILIAR_UPDATE(_, f)
	local data = f:GetData()
	local sprite = f:GetSprite()
	local sfx = lootdeck.sfx
	if not data.state then
		sprite:Play("Float", true)
		data.state = "STATE_IDLE"
	end
	if data.state == "STATE_SPAWN" then
		sprite:Play("Spent", false)
		if sprite:IsEventTriggered("Sound") then
			for i=1,data.toSpawn[4] do
				Isaac.Spawn(data.toSpawn[1], data.toSpawn[2], data.toSpawn[3], f.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), f)
			end
			for i=1,(data.toSpawn[8] or 0) do
				Isaac.Spawn(data.toSpawn[5], data.toSpawn[6], data.toSpawn[7], f.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), f)
			end
			sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
		end
		if sprite:IsFinished("Spent") then
			f:RemoveFromFollowers()
			f:Remove()
		end
	end
	f:FollowParent()
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    callbacks = {
        {
            ModCallbacks.MC_FAMILIAR_INIT,
            MC_FAMILIAR_INIT,
            Id
        },
		{
            ModCallbacks.MC_FAMILIAR_UPDATE,
            MC_FAMILIAR_UPDATE,
            Id
        }
    }
}
