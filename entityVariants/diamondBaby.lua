local helper = include("helper_functions")

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
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL,
            Id
        }
    }
}
