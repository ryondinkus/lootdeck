local helper = LootDeckAPI
local entityVariants = include("entityVariants/registry")

-- Grants Steam Sale effect for the floor + little card familiar
local Names = {
    en_us = "Two of Diamonds",
    spa = "Dos de Diamantes"
}
local Name = Names.en_us
local Tag = "twoOfDiamonds"
local Id = Isaac.GetCardIdByName(Name)
local Weight = 1
local Descriptions = {
    en_us = "Grants the {{Collectible64}} Steam Sale effect for the floor, causing all shop items to be half price# Grants a Two of Diamonds Baby familiar for the floor, who gives a 1 second {{Collectible202}} Midas' Touch effect to enemies on contact",
    spa = "Otorga el efecto de las {{Collectible64}} Ofertas de Steam durante el piso#Otorga un familiar del 2 de diamantes durante el piso, quien aplica el efecto del {{Collectible202}} Toque de Midas al contacto"
}
local HolographicDescriptions = {
    en_us = "Grants {{ColorRainbow}}2{{CR}} {{Collectible64}} Steam Sale effect for the floor, causing all shop items to be half price# Grants {{ColorRainbow}}2{{CR}} Two of Diamonds Baby familiars for the floor, who gives a 1 second {{Collectible202}} Midas' Touch effect to enemies on contact",
    spa = "Otorga {{ColorRainbow}}2{{CR}} efectos de las {{Collectible64}} Ofertas de Steam durante el piso#Otorga {{ColorRainbow}}2{{CR}} familiares del 2 de diamantes durante el piso, quien aplica el efecto del {{Collectible202}} Toque de Midas al contacto"
}
local WikiDescription = helper.GenerateEncyclopediaPage("Grants the Steam Sale effect for the floor, causing shop items to be sold at half price.", "Grants a Two of Diamonds Baby familiar for the floor.", "- On contact with enemies, Two of Diamonds Baby will turn enemies into a gold statue for 1 second, like Midas' Touch.", "Holographic Effect: Grants two Steam Sale effects and two familiars.")

local function MC_USE_CARD(_, c, p)
    local data = helper.GetLootDeckData(p)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
    p:AddCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE, 0, false)
    if not data.sale then data.sale = 1
    else data.sale = data.sale + 1 end
    if data.sale >= p:GetCollectibleNum(CollectibleType.COLLECTIBLE_STEAM_SALE) then
        p:RemoveCostume(itemConfig)
    end
    lootdeck.sfx:Play(SoundEffect.SOUND_CASH_REGISTER, 1, 0)
	Isaac.Spawn(EntityType.ENTITY_FAMILIAR, entityVariants.diamondBaby.Id, 0, p.Position, Vector.Zero, p)
end

local function MC_POST_NEW_LEVEL()
    helper.ForEachPlayer(function(p, data)
        if data.sale then
            for j=1,data.sale do
                p:RemoveCollectible(CollectibleType.COLLECTIBLE_STEAM_SALE)
            end
            data.sale = nil
        end
    end)
end

return {
    Name = Name,
    Names = Names,
    Tag = Tag,
	Id = Id,
    Weight = Weight,
    Descriptions = Descriptions,
    HolographicDescriptions = HolographicDescriptions,
    WikiDescription = WikiDescription,
    Callbacks = {
        {
            ModCallbacks.MC_USE_CARD,
            MC_USE_CARD,
            Id,
            true
        },
        {
            ModCallbacks.MC_POST_NEW_LEVEL,
            MC_POST_NEW_LEVEL
        }
    },
    Tests = function()
        return {
            {
                name = Tag.."Use",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "USE_CARD",
                        id = Card.CARD_HERMIT
                    },
                    {
                        action = "WAIT_FOR_SECONDS",
                        seconds = 2
                    },
                    {
                        action = "RUN_COMMAND",
                        command = "stage 2"
                    },
                    {
                        action = "USE_CARD",
                        id = Card.CARD_HERMIT
                    },
                }
            },
            {
                name = Tag.."Freeze",
                steps = {
                    {
                        action = "RESTART",
                        id = PlayerType.PLAYER_ISAAC
                    },
                    {
                        action = "GIVE_CARD",
                        id = Id
                    },
                    {
                        action = "USE_CARD"
                    },
                    {
                        action = "SPAWN",
                        type = EntityType.ENTITY_HORF
                    },
                    {
                        action = "MOVE_RIGHT",
                        seconds = 0.1,
                        async = true
                    },
                    {
                        action = "MOVE_UP",
                        seconds = 1
                    }
                }
            }
        }
    end
}
