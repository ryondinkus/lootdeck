local helper = include("helper_functions")

local MenuName = "Lootdeck"
local SubMenuName = "Settings"
DEBUG = false

lootdeck.mcmOptions = {
	GuaranteedLoot = false,
	LootDeckStart = false,
	BlankCardStart = false,
	JacobEsauStart = false,
    LootCardChance = 20
}

local mcmOptions = lootdeck.mcmOptions

--========== MCM BUGTESTING SHIT ===========
if ModConfigMenu then
	if DEBUG then
        ModConfigMenu.AddSetting(
        MenuName,
        SubMenuName,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return mcmOptions.GuaranteedLoot
            end,
            Display = function()
                local onOff = "Disabled"
                if mcmOptions.GuaranteedLoot then
                    onOff = "Enabled"
                end
                return "100% Loot Drop Rate: " .. onOff
            end,
            OnChange = function(currentBool)
                mcmOptions.GuaranteedLoot = currentBool
            end,
            Info = "Turns all card drops into Loot Card drops."
        })

        ModConfigMenu.AddSetting(
        MenuName,
        SubMenuName,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return mcmOptions.LootDeckStart
            end,
            Display = function()
                local onOff = "Disabled"
                if mcmOptions.LootDeckStart then
                    onOff = "Enabled"
                end
                return "Start with Loot Deck: " .. onOff
            end,
            OnChange = function(currentBool)
                mcmOptions.LootDeckStart = currentBool
            end,
            Info = "Gives you Loot Deck at the start of a new run. Loot Deck drops a Loot Card every 6 rooms."
        })

        ModConfigMenu.AddSetting(
        MenuName,
        SubMenuName,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return mcmOptions.BlankCardStart
            end,
            Display = function()
                local onOff = "Disabled"
                if mcmOptions.BlankCardStart then
                    onOff = "Enabled"
                end
                return "Start with Blank Card: " .. onOff
            end,
            OnChange = function(currentBool)
                mcmOptions.BlankCardStart = currentBool
            end,
            Info = "Gives you Blank Card and a random Loot Card at the start of a new run."
        })

        ModConfigMenu.AddSetting(
        MenuName,
        SubMenuName,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function()
                return mcmOptions.JacobEsauStart
            end,
            Display = function()
                local onOff = "Disabled"
                if mcmOptions.JacobEsauStart then
                    onOff = "Enabled"
                end
                return "Start as Jacob & Esau: " .. onOff
            end,
            OnChange = function(currentBool)
                mcmOptions.JacobEsauStart = currentBool
            end,
            Info = "Start your next run as Jacob & Esau."
        })
    end
    ModConfigMenu.AddSetting(
		MenuName,
		SubMenuName,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return mcmOptions.LootCardChance
			end,
			Minimum = 0,
			Maximum = 100,
			ModifyBy = 5,
			Display = function()
                if mcmOptions.LootCardChance == 0 then
                    return "Loot Card Chance: 1%"
                end
				return "Loot Card Chance: " .. mcmOptions.LootCardChance .. "%"
			end,
			OnChange = function(currentNum)
				mcmOptions.LootCardChance = currentNum
                helper.SaveKey("lootCardChance", currentNum)
			end,
			Info = {"Chance for Loot Cards to replace normal card drops (Default: 20%)"}
		}
	)
end