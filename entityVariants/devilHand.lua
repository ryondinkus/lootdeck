local helper = include("helper_functions")

local Name = "Devil Hand"
local Tag = "devilHand"
local Id = Isaac.GetEntityVariantByName(Name)

local STATE_TAG = Tag.."State"
local TARGET_TAG = Tag.."Target"
local SELECTED_ITEM_TAG = Tag.."Selected"
local COLLECTIBLE_TYPE_TAG = Tag.."CollectibleType"
local OPTIONS_PICKUP_INDEX_TAG = Tag.."OptionsPickupIndex"

local STATES = {
    IDLE = "STATE_IDLE",
    MOVE = "STATE_MOVE",
    GRAB = "STATE_GRAB",
    UP = "STATE_UP",
    DOWN = "STATE_DOWN",
    SPAWN = "STATE_SPAWN",
    PUNCHDOWN = "STATE_PUNCH_DOWN",
    PUNCHUP = "STATE_PUNCH_UP"
}

local function MC_FAMILIAR_INIT(_, f)
    f:AddToFollowers()
end

-- Familiar update for Joker card
local function MC_FAMILIAR_UPDATE(_, f)
    local sfx = lootdeck.sfx
    local data = f:GetData()
    local sprite = f:GetSprite()
    local room = Game():GetRoom()

    if not data[STATE_TAG] then
		data[STATE_TAG] = STATES.IDLE
	end

    if data[STATE_TAG] == STATES.IDLE and not data[TARGET_TAG] then
		if not sprite:IsPlaying("Float") then
            sprite:Play("Float", true)
        end

	    local itemsList = {}

        helper.ForEachEntityInRoom(function(entity)
            table.insert(itemsList, entity)
        end,
        EntityType.ENTITY_PICKUP,
        PickupVariant.PICKUP_COLLECTIBLE,
        function(entitySubType) return entitySubType ~= 0 end,
        function(entity) return not entity:GetData()[SELECTED_ITEM_TAG] end)

        if #itemsList > 0 then
            local selectedItem = itemsList[lootdeck.rng:RandomInt(#itemsList) + 1]:ToPickup()
            selectedItem:GetData()[SELECTED_ITEM_TAG] = true

            data[TARGET_TAG] = selectedItem
            data[STATE_TAG] = STATES.MOVE
        else
            f:FollowParent()
            return
        end
    end

    local target = data[TARGET_TAG]

    if data[STATE_TAG] == STATES.MOVE and target then
        if target:Exists() and target.SubType ~= 0 then
            local dir = (target.Position - f.Position):Normalized()
            f.Velocity = dir * 5
            if math.abs(f.Position.X - target.Position.X) < 4
            and math.abs(f.Position.Y - target.Position.Y) < 4 then
                data[STATE_TAG] = STATES.GRAB
            end
        else
            data[STATE_TAG] = STATES.PUNCHDOWN
            data[TARGET_TAG] = nil
            data[SELECTED_ITEM_TAG] = nil
            data[COLLECTIBLE_TYPE_TAG] = nil
            data[OPTIONS_PICKUP_INDEX_TAG] = nil
            return
        end
    end

    if data[STATE_TAG] == STATES.GRAB then
        if sprite:IsFinished("Grab") then
            data[STATE_TAG] = STATES.UP
        else
            if not sprite:IsPlaying("Grab") then
                sprite:Play("Grab", true)
                f.Velocity = Vector.Zero
            end

            if sprite:IsEventTriggered("Land") then
                data[COLLECTIBLE_TYPE_TAG] = target.SubType
                data[OPTIONS_PICKUP_INDEX_TAG] = target.OptionsPickupIndex
                sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0)
                target:Remove()
            end
        end
    end

    if data[STATE_TAG] == STATES.UP then
        if sprite:IsFinished("FlyUp") then
            data[STATE_TAG] = STATES.DOWN
        else
            if not sprite:IsPlaying("FlyUp") then
                sprite:Play("FlyUp", true)
            end
        end
    end

    if data[STATE_TAG] == STATES.DOWN then
        if sprite:IsFinished("FlyDown") then
            data[STATE_TAG] = STATES.SPAWN
        else
            if not sprite:IsPlaying("FlyDown") then
                sprite:Play("FlyDown", true)
                f.Position = room:FindFreePickupSpawnPosition(data.player.Position, 0, true)
            end
        end
    end

    if data[STATE_TAG] == STATES.SPAWN then
        if sprite:IsFinished("Spawn") then
            f:Remove()
        else
            if not sprite:IsPlaying("Spawn") then
                sprite:Play("Spawn", true)
                sfx:Play(SoundEffect.SOUND_SATAN_APPEAR, 1, 0)
            end

            if sprite:IsEventTriggered("Spawn") then
                local collectible = helper.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, data[COLLECTIBLE_TYPE_TAG], f.Position, Vector.Zero, f)
                collectible:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
                local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, f.Position, Vector.Zero, f)
                poof.Color = Color(0,0,0,1,0,0,0)
            end
        end
    end

    if data[STATE_TAG] == STATES.PUNCHDOWN then
        if sprite:IsFinished("PunchDown") then
            data[STATE_TAG] = STATES.PUNCHUP
        else
            if not sprite:IsPlaying("PunchDown") then
                sprite:Play("PunchDown", true)
                f.Velocity = Vector.Zero
                sfx:Play(SoundEffect.SOUND_SATAN_BLAST, 1, 0)
            end

            if sprite:IsEventTriggered("Land") then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE_RANDOM, 0, f.Position, Vector.Zero, f)
                sfx:Play(SoundEffect.SOUND_FORESTBOSS_STOMPS, 1, 0)
            end
        end
    end

    if data[STATE_TAG] == STATES.PUNCHUP then
        if sprite:IsFinished("PunchUp") then
            data[STATE_TAG] = STATES.IDLE
        else
            if not sprite:IsPlaying("PunchUp") then
                sprite:Play("PunchUp", true)
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
        }
    }
}
