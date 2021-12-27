local H = {}

-- function to convert tearflags to new BitSet128
function LootDeckHelpers.NewTearflag(x)
    return x >= 64 and BitSet128(0,1<<(x - 64)) or BitSet128(1<<x,0)
end

function LootDeckHelpers.TableContains(table, element)
    if table then
        for _, value in pairs(table) do
            if value == element then
                return true
            end
        end
    end
	return false
end

function LootDeckHelpers.LengthOfTable(t)
    local num = 0
    for _ in pairs(t) do
        num = num + 1
    end
    return num
end

function LootDeckHelpers.Sign(x)
  return x > 0 and 1 or x < 0 and -1 or 0
end

function LootDeckHelpers.SetNestedValue(t, key, value)
    if t and type(t) == "table" then
        if key:find("%.") then
            local levelKey, nextLevelKey = key:match('(.*)%.(.*)')
            return LootDeckHelpers.SetNestedValue(t[levelKey], nextLevelKey, value)
        else
            t[key] = value
        end
    end
end

function LootDeckHelpers.IsArray(t)
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then return false end
    end
    return true
end

function LootDeckHelpers.RandomChance(rng, shouldDouble, ...)
    local functions = {...}

    local effectIndex = rng:RandomInt(#functions) + 1

    if shouldDouble then
        functions[effectIndex]()
    end

    return functions[effectIndex]()
end

function LootDeckHelpers.PercentageChance(percent, max, rng)
    local value
    if percent > (max or 100) then
        value = max or 100
    else
        value = percent
    end
    if rng then return rng:RandomInt(99) + 1 <= value
    else return lootdeck.rng:RandomInt(99) + 1 <= value end
end

return H
