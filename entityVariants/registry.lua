local EV = {
    lostPenny = "Lost Penny",
    lostKey = "Lost Key",
    lostBomb = "Lost Bomb",
    momsFinger = "Mom's Finger"
}

for key, name in pairs(EV) do
    EV[key] = Isaac.GetEntityVariantByName(name)
end

return EV