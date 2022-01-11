local json = include("json")

local H = {}

function LootDeckAPI.SaveData(data)
    lootdeck:SaveData(json.encode(data))
end

function LootDeckAPI.LoadData()
    if lootdeck:HasData() then
        return json.decode(lootdeck:LoadData())
    end
end

function LootDeckAPI.SaveKey(key, value)
    local savedData = LootDeckAPI.LoadData() or {}
    LootDeckAPI.SetNestedValue(savedData, key, value)
    LootDeckAPI.SaveData(savedData)
end

function LootDeckAPI.LoadKey(key)
    local savedData = LootDeckAPI.LoadData()

    if savedData then
        return savedData[key]
    end
end

function LootDeckAPI.FlattenEntityData(data)
    if data ~= nil then
        if type(data) == "userdata" then
            if data.InitSeed then
                return { _type = "userdata", initSeed = tostring(data.InitSeed) }
            end
        elseif type(data) == "table" then
            local output = {}
            for key, item in pairs(data) do
                output[key] = LootDeckAPI.FlattenEntityData(item)
            end
            return output
        else
            return data
        end
    end
end

function LootDeckAPI.RehydrateEntityData(data)
    if data ~= nil and type(data) == "table" then
        if LootDeckAPI.IsArray(data) or data._type ~= "userdata" then
            local output = {}
            for key, item in pairs(data) do
                output[key] = LootDeckAPI.RehydrateEntityData(item)
            end
            return output
        else
            return LootDeckAPI.GetEntityByInitSeed(data.initSeed)
        end
    else
        return data
    end
end

function LootDeckAPI.SaveGame()
    local data = {
        seed = Game():GetSeeds():GetPlayerInitSeed(),
        players = {},
        familiars = {},
        global = lootdeck.f,
        mcmOptions = lootdeck.mcmOptions or {},
        unlocks = lootdeck.unlocks or {}
    }

    LootDeckAPI.ForEachPlayer(function(p)
        data.players[tostring(p.InitSeed)] = LootDeckAPI.GetLootDeckData(p)
    end)

    LootDeckAPI.ForEachEntityInRoom(function(familiar)
        data.familiars[tostring(familiar.InitSeed)] = familiar:GetData()
    end, EntityType.ENTITY_FAMILIAR)

    LootDeckAPI.SaveData(LootDeckAPI.FlattenEntityData(data))
end

return H