local helper = lootdeckHelpers

local Name = "Credit Card Baby"
local Tag = "creditCardBaby"
local Id = Isaac.GetEntityVariantByName(Name)

local STATE_TAG = Tag.."State"
local FAMILIAR_INIT_SEEDS_TAG = Tag.."FamiliarInitSeeds"
local REFUND_PRICE_TAG = Tag.."Refund"

local STATES = {
	IDLE = "STATE_IDLE",
	SPENT = "STATE_SPENT"
}

local function MC_FAMILIAR_INIT(_, f)
	f:AddToFollowers()
	
	local p = f.SpawnerEntity:ToPlayer()

	if p then
		local data = p:GetData().lootdeck

		if data[FAMILIAR_INIT_SEEDS_TAG] then
			if not helper.TableContains(data[FAMILIAR_INIT_SEEDS_TAG], f.InitSeed) then
				table.insert(data[FAMILIAR_INIT_SEEDS_TAG], f.InitSeed)
			end
		else
			data[FAMILIAR_INIT_SEEDS_TAG] = { f.InitSeed }
		end
	end
end

local function MC_FAMILIAR_UPDATE(_, f)
	local data = f:GetData()
	local sprite = f:GetSprite()
	local sfx = lootdeck.sfx

	if not data[STATE_TAG] then
		data[STATE_TAG] = STATES.IDLE
	end

	if data[STATE_TAG] == STATES.IDLE then
		if not sprite:IsPlaying("Float") then
			sprite:Play("Float", true)
		end
	elseif data[STATE_TAG] == STATES.SPENT then
		if sprite:IsFinished("Spent") then
			f:RemoveFromFollowers()
			f:Remove()

			local p = f.SpawnerEntity:ToPlayer()

			if p then
				local pData = p:GetData().lootdeck

				table.remove(pData[FAMILIAR_INIT_SEEDS_TAG], 1)

				if #pData[FAMILIAR_INIT_SEEDS_TAG] <= 0 then
					pData[FAMILIAR_INIT_SEEDS_TAG] = nil
				end
			end
		end

		if not sprite:IsPlaying("Spent") then
			sprite:Play("Spent", false)
		end

		if sprite:IsEventTriggered("Sound") then
			for i=1, data[REFUND_PRICE_TAG][4] do
				helper.Spawn(data[REFUND_PRICE_TAG][1], data[REFUND_PRICE_TAG][2], data[REFUND_PRICE_TAG][3], f.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), f)
			end
			for i=1, (data[REFUND_PRICE_TAG][8] or 0) do
				helper.Spawn(data[REFUND_PRICE_TAG][5], data[REFUND_PRICE_TAG][6], data[REFUND_PRICE_TAG][7], f.Position, Vector.FromAngle(lootdeck.rng:RandomInt(360)), f)
			end
			sfx:Play(SoundEffect.SOUND_SLOTSPAWN, 1, 0)
		end
	end

	f:FollowParent()
end

local function MC_PRE_PICKUP_COLLISION(_, pi, e)
    local p = e:ToPlayer()
    if p then
        local playerData = p:GetData().lootdeck
        if playerData[FAMILIAR_INIT_SEEDS_TAG] and #playerData[FAMILIAR_INIT_SEEDS_TAG] > 0 and pi.Type == EntityType.ENTITY_PICKUP then
            if helper.CanBuyPickup(p, pi) then
				local familiar = helper.GetEntityByInitSeed(playerData[FAMILIAR_INIT_SEEDS_TAG][1])

				if familiar then
					local familiarData = familiar:GetData()
					familiarData[REFUND_PRICE_TAG] = helper.CalculateRefund(pi.Price)
    				familiarData[STATE_TAG] = STATES.SPENT
				end
            end
        end
    end
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
        },
		{
            ModCallbacks.MC_PRE_PICKUP_COLLISION,
            MC_PRE_PICKUP_COLLISION
		}
    }
}
