local helper = include("helper_functions")

local MenuName = "Lootdeck"
local SubMenuName = "Settings"

local mcmOptions = lootdeck.mcmOptions

--========== MCM SHIT ===========
if ModConfigMenu and not ModConfigMenu.GetCategoryIDByName(MenuName) then
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
			end,
			Info = {"Chance for Loot Cards to replace normal card drops (Default: 20%)"}
		}
	)

    ModConfigMenu.AddSetting(
		MenuName,
		SubMenuName,
		{
			Type = ModConfigMenu.OptionType.NUMBER,
			CurrentSetting = function()
				return mcmOptions.HoloCardChance
			end,
			Minimum = 0,
			Maximum = 100,
			ModifyBy = 5,
			Display = function()
				return "Holo Card Chance: " .. mcmOptions.HoloCardChance .. "%"
			end,
			OnChange = function(currentNum)
				mcmOptions.HoloCardChance = currentNum
			end,
			Info = {"Chance for Holographic Loot Cards to replace normal Loot Card drops (Default: 10%)"}
		}
	)

    ModConfigMenu.AddSetting(
        MenuName,
        SubMenuName,
        {
            Type = ModConfigMenu.OptionType.BOOLEAN,
            CurrentSetting = function() return true end,
            Display = function() return "[ Clear Loot Deck save data ]" end,
            OnChange = function()
                helper.SaveData({
                    players = {},
                    familiars = {},
                    global = {},
                    mcmOptions = nil,
                    unlocks = {}
                })
                lootdeck.f = {}
                lootdeck.unlocks = {}
            end,
            Info = "Clear all achievement unlocks, Mod Config Menu settings, and run progress. THIS WILL BREAK YOUR CURRENT RUN."
        }
    )
end