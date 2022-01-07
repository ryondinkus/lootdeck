local helper = LootDeckAPI

local Name = "Diamond Baby"
local Tag = "diamondBaby"
local Id = Isaac.GetEntityVariantByName(Name)

local function MC_FAMILIAR_INIT(_, f)
    f:AddToFollowers()
end

local function MC_FAMILIAR_UPDATE(_, f)
	f:GetSprite():Play("Float", false)
	f:FollowParent()
end

local function MC_PRE_FAMILIAR_COLLISION(_, f, e)
	if e:ToNPC() and not e:HasEntityFlags(EntityFlag.FLAG_CHARM) then
		e:AddMidasFreeze(EntityRef(f), 30)
	end
end

local function MC_POST_NEW_LEVEL()
    helper.ForEachEntityInRoom(function(entity)
        local f = entity:ToFamiliar()
        f:RemoveFromFollowers()
        f:Remove()
    end, EntityType.ENTITY_FAMILIAR, Id, nil)
end

return {
    Name = Name,
    Tag = Tag,
	Id = Id,
    Callbacks = {
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
			ModCallbacks.MC_PRE_FAMILIAR_COLLISION,
            MC_PRE_FAMILIAR_COLLISION,
            Id
		},
		{
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL,
            Id
        }
    }
}
