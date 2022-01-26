if Test then

    local lootdeckTests = {}

    for _, card in pairs(lootcards) do
        LootDeckAPI.RegisterLootCard(card, false)

        if Test then
            if not card.IsHolographic then
                local cardTests = include("tests/"..card.Tag)
                if cardTests then
                    table.insert(lootdeckTests, { name = card.Tag, steps = cardTests })
                end
            end
        end
    end

    Test.RegisterTests("lootdeck", lootdeckTests, "lootdeck")
end