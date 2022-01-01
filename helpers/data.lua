local json = include("json")

local H = {}

function LootDeckHelpers.SaveData(data)
    lootdeck:SaveData(json.encode(data))
end

function LootDeckHelpers.LoadData()
    if lootdeck:HasData() then
        return json.decode(lootdeck:LoadData())
    end
end

function LootDeckHelpers.SaveKey(key, value)
    local savedData = LootDeckHelpers.LoadData() or {}
    LootDeckHelpers.SetNestedValue(savedData, key, value)
    LootDeckHelpers.SaveData(savedData)
end

function LootDeckHelpers.LoadKey(key)
    local savedData = LootDeckHelpers.LoadData()

    if savedData then
        return savedData[key]
    end
end

function LootDeckHelpers.FlattenEntityData(data)
    if data ~= nil then
        if type(data) == "userdata" then
            if data.InitSeed then
                return { _type = "userdata", initSeed = tostring(data.InitSeed) }
            end
        elseif type(data) == "table" then
            local output = {}
            for key, item in pairs(data) do
                output[key] = LootDeckHelpers.FlattenEntityData(item)
            end
            return output
        else
            return data
        end
    end
end

function LootDeckHelpers.RehydrateEntityData(data)
    if data ~= nil and type(data) == "table" then
        if LootDeckHelpers.IsArray(data) or data._type ~= "userdata" then
            local output = {}
            for key, item in pairs(data) do
                output[key] = LootDeckHelpers.RehydrateEntityData(item)
            end
            return output
        else
            return LootDeckHelpers.GetEntityByInitSeed(data.initSeed)
        end
    else
        return data
    end
end

function LootDeckHelpers.SaveGame()
    local data = {
        seed = Game():GetSeeds():GetPlayerInitSeed(),
        players = {},
        familiars = {},
        global = lootdeck.f,
        mcmOptions = lootdeck.mcmOptions or {},
        unlocks = lootdeck.unlocks or {}
    }

    LootDeckHelpers.ForEachPlayer(function(p)
        data.players[tostring(p.InitSeed)] = p:GetData().lootdeck
    end)

    LootDeckHelpers.ForEachEntityInRoom(function(familiar)
        data.familiars[tostring(familiar.InitSeed)] = familiar:GetData()
    end, EntityType.ENTITY_FAMILIAR)

    LootDeckHelpers.SaveData(LootDeckHelpers.FlattenEntityData(data))
end

return H