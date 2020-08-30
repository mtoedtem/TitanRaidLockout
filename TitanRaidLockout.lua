-- **************************************************************************
-- * Titan Raid Lockout
-- *
-- * By: Gamut - Nethergarde Keep EU
-- **************************************************************************

local L = LibStub("AceLocale-3.0"):GetLocale("TitanClassic", true)
local TITAN_RAIDLOCKOUT_ID = "TitanRaidLockout"
local VERSION = GetAddOnMetadata(GetAddOnInfo("name"), "Version")
local clientLocale = GetLocale()

function TRaidLockout_Init()
    if (myAddOnsFrame_Register) then
		myAddOnsFrame_Register( {name=TITAN_RAIDLOCKOUT_ID,version=VERSION,category=MYADDONS_CATEGORY_PLUGINS} )
	end
end

function TRaidLockout_OnLoad(self)    
    self.registry = {
        id = TITAN_RAIDLOCKOUT_ID,
        menuText = "Raid Lockout",
        buttonTextFunction = "TRaidLockout_GetButtonText",
        tooltipTitle = "Raid Lockout",
        tooltipTextFunction = "TRaidLockout_GetTooltip",
        icon = "Interface\\Icons\\inv_misc_head_dragon_bronze",
        iconWidth = 16,
        iconButtonWidth = 16,
        category = "Information",
        version = VERSION,
        savedVariables = {
            ShowTooltipHeader = true,
            ShowUnlockedButton = false,
            ShowUnlockedTooltip = false,
            ShowIcon = true,
            ShowColoredText = true,
            ShowLabelText = true,
        }
    };
    self:RegisterEvent("VARIABLES_LOADED")
    self:RegisterEvent("PLAYER_ENTERING_WORLD") 
    self:RegisterEvent("UPDATE_INSTANCE_INFO")
end

function TRaidLockout_OnEvent(self, event, ...)
    if (event == "VARIABLES_LOADED") then
		TRaidLockout_Init();
    elseif (event == "UPDATE_INSTANCE_INFO") then
        initTime = time()+20
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
    elseif (event == "PLAYER_ENTERING_WORLD") then
        initTime = time()+20
        TRaidLockout_GetButtonText()
        TitanPanelPluginHandle_OnUpdate({TITAN_RAIDLOCKOUT_ID, 1})
    end
end

function TRaidLockout_GetButtonText()
    TRaidLockout_SetButtonText()
    return buttonLabel, buttonText
end

function TRaidLockout_GetTooltip()
    TRaidLockout_SetTooltip()
    return tooltipText
end

function TitanPanelRightClickMenu_PrepareTitanRaidLockoutMenu()
    TitanPanelRightClickMenu_AddTitle(TitanPlugins[TITAN_RAIDLOCKOUT_ID].menuText);
    TitanPanelRightClickMenu_AddToggleVar("Tooltip Legend", TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
    TitanPanelRightClickMenu_AddToggleVar("Panel - Show all instances", TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
    TitanPanelRightClickMenu_AddSpacer();
    TitanPanelRightClickMenu_AddToggleVar("Show Icon", TITAN_RAIDLOCKOUT_ID, "ShowIcon")
    TitanPanelRightClickMenu_AddToggleColoredText(TITAN_RAIDLOCKOUT_ID)
	TitanPanelRightClickMenu_AddToggleLabelText(TITAN_RAIDLOCKOUT_ID)
    TitanPanelRightClickMenu_AddSpacer();
	TitanPanelRightClickMenu_AddCommand(L["TITAN_PANEL_MENU_HIDE"], TITAN_RAIDLOCKOUT_ID, TITAN_PANEL_MENU_FUNC_HIDE);
end

-- **************************************************************************
--  _SetButtonText()
-- **************************************************************************
function TRaidLockout_SetButtonText()
    
    local numSaved = GetNumSavedInstances()
    
    local coloredText = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowColoredText")
    local showUnlocked = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowUnlockedButton")
    buttonLabel = "Lockout: "
    
    if coloredText then
        textColor = "|cFFDE1010"
    else
        textColor = "|cFFFFFFFF"
    end
    
    buttonText = textColor
    
    if showUnlocked then
        
        -- Filter instance names depending on game client langauge
        -- If the client is english or it's not listed it will return as english
        -- Italian game client uses English names?
        
        if ( clientLocale == "deDE" ) then
        -- GERMAN
            
            local raidsTable = {
                ["ZG"] = "Zul'Gurub",
                ["MC"] = "Geschmolzener Kern",
                ["BWL"] = "Pechschwingenhort",
                ["ONY"] = "Onyxias Hort",
                ["AQ20"] = "Ruinen von Ahn'Qiraj",
                ["AQ40"] = "Ahn'Qiraj",
            }

            if numSaved > 0 then
                -- Add locked instance abbriviations to button text
                for savedIndex = 1, numSaved do

                    local name = GetSavedInstanceInfo(savedIndex)

                    if name == "Zul'Gurub" then
                        buttonText = buttonText .. " ZG"
                        raidsTable["ZG"] = nil
                    elseif name == "Geschmolzener Kern" then
                        buttonText = buttonText .. " MC"
                        raidsTable["MC"] = nil
                    elseif name == "Pechschwingenhort" then
                        buttonText = buttonText .. " BWL"
                        raidsTable["BWL"] = nil
                    elseif name == "Onyxias Hort" then
                        buttonText = buttonText .. " ONY"
                        raidsTable["ONY"] = nil
                    elseif name == "Ruinen von Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ20"
                        raidsTable["AQ20"] = nil
                    elseif name == "Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ40"
                        raidsTable["AQ40"] = nil
                    end

                end
            end
            
        elseif ( clientLocale == "esES" or clientLocale == "esMX" ) then
        -- SPANISH
            
            local raidsTable = {
                ["ZG"] = "Zul'Gurub",
                ["MC"] = "Núcleo de Magma",
                ["BWL"] = "Guarida Alanegra",
                ["ONY"] = "Guarida de Onyxia",
                ["AQ20"] = "Ruinas de Ahn'Qiraj",
                ["AQ40"] = "Ahn'Qiraj",
            }

            if numSaved > 0 then
                -- Add locked instance abbriviations to button text
                for savedIndex = 1, numSaved do

                    local name = GetSavedInstanceInfo(savedIndex)

                    if name == "Zul'Gurub" then
                        buttonText = buttonText .. " ZG"
                        raidsTable["ZG"] = nil
                    elseif name == "Núcleo de Magma" then
                        buttonText = buttonText .. " MC"
                        raidsTable["MC"] = nil
                    elseif name == "Guarida Alanegra" then
                        buttonText = buttonText .. " BWL"
                        raidsTable["BWL"] = nil
                    elseif name == "Guarida de Onyxia" then
                        buttonText = buttonText .. " ONY"
                        raidsTable["ONY"] = nil
                    elseif name == "Ruinas de Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ20"
                        raidsTable["AQ20"] = nil
                    elseif name == "Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ40"
                        raidsTable["AQ40"] = nil
                    end

                end
            end
            
        elseif ( clientLocale == "frFR" ) then
        -- FRENCH
            
            local raidsTable = {
                ["ZG"] = "Zul'Gurub",
                ["MC"] = "Cœur du Magma",
                ["BWL"] = "Repaire de l'Aile noire",
                ["ONY"] = "Repaire d'Onyxia",
                ["AQ20"] = "Ruines d'Ahn'Qiraj",
                ["AQ40"] = "Ahn'Qiraj",
            }

            if numSaved > 0 then
                -- Add locked instance abbriviations to button text
                for savedIndex = 1, numSaved do

                    local name = GetSavedInstanceInfo(savedIndex)

                    if name == "Zul'Gurub" then
                        buttonText = buttonText .. " ZG"
                        raidsTable["ZG"] = nil
                    elseif name == "Cœur du Magma" then
                        buttonText = buttonText .. " MC"
                        raidsTable["MC"] = nil
                    elseif name == "Repaire de l'Aile noire" then
                        buttonText = buttonText .. " BWL"
                        raidsTable["BWL"] = nil
                    elseif name == "Repaire d'Onyxia" then
                        buttonText = buttonText .. " ONY"
                        raidsTable["ONY"] = nil
                    elseif name == "Ruines d'Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ20"
                        raidsTable["AQ20"] = nil
                    elseif name == "Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ40"
                        raidsTable["AQ40"] = nil
                    end

                end
            end
            
        elseif ( clientLocale == "ruRU" ) then
        -- RUSSIAN
            
            local raidsTable = {
                ["ZG"] = "Зул'Гуруб",
                ["MC"] = "Огненные Недра",
                ["BWL"] = "Логово Крыла Тьмы",
                ["ONY"] = "Логово Ониксии",
                ["AQ20"] = "Руины Ан'Киража",
                ["AQ40"] = "Ан'Кираж",
            }

            if numSaved > 0 then
                -- Add locked instance abbriviations to button text
                for savedIndex = 1, numSaved do

                    local name = GetSavedInstanceInfo(savedIndex)

                    if name == "Зул'Гуруб" then
                        buttonText = buttonText .. " ZG"
                        raidsTable["ZG"] = nil
                    elseif name == "Огненные Недра" then
                        buttonText = buttonText .. " MC"
                        raidsTable["MC"] = nil
                    elseif name == "Логово Крыла Тьмы" then
                        buttonText = buttonText .. " BWL"
                        raidsTable["BWL"] = nil
                    elseif name == "Логово Ониксии" then
                        buttonText = buttonText .. " ONY"
                        raidsTable["ONY"] = nil
                    elseif name == "Руины Ан'Киража" then
                        buttonText = buttonText .. " AQ20"
                        raidsTable["AQ20"] = nil
                    elseif name == "Ан'Кираж" then
                        buttonText = buttonText .. " AQ40"
                        raidsTable["AQ40"] = nil
                    end

                end
            end
            
        else
        -- ENGLISH
        
            local raidsTable = {
                ["ZG"] = "Zul'Gurub",
                ["MC"] = "Molten Core",
                ["BWL"] = "Blackwing Lair",
                ["ONY"] = "Onyxia's Lair",
                ["AQ20"] = "Ruins of Ahn'Qiraj",
                ["AQ40"] = "Ahn'Qiraj",
            }

            if numSaved > 0 then
                -- Add locked instance abbriviations to button text
                for savedIndex = 1, numSaved do

                    local name = GetSavedInstanceInfo(savedIndex)

                    if name == "Zul'Gurub" then
                        buttonText = buttonText .. " ZG"
                        raidsTable["ZG"] = nil
                    elseif name == "Molten Core" then
                        buttonText = buttonText .. " MC"
                        raidsTable["MC"] = nil
                    elseif name == "Blackwing Lair" then
                        buttonText = buttonText .. " BWL"
                        raidsTable["BWL"] = nil
                    elseif name == "Onyxia's Lair" then
                        buttonText = buttonText .. " ONY"
                        raidsTable["ONY"] = nil
                    elseif name == "Ruins of Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ20"
                        raidsTable["AQ20"] = nil
                    elseif name == "Ahn'Qiraj" then
                        buttonText = buttonText .. " AQ40"
                        raidsTable["AQ40"] = nil
                    end

                end
            end
        
        end
        
        if coloredText then
            buttonText = buttonText .. GREEN_FONT_COLOR_CODE
        else
            buttonText = buttonText .. " |"
        end
        
        for abbr, raidName in pairs(raidsTable) do
            buttonText = buttonText .. " " .. abbr
        end
        
        if coloredText then
            buttonText = buttonText .. GREEN_FONT_COLOR_CODE
        else
            buttonText = buttonText .. " |"
        end
        
        for abbr, raidName in pairs(raidsTable) do
            buttonText = buttonText .. " " .. abbr
        end
    
    else
        
        if numSaved > 0 then
            -- Add locked instance abbriviations to button text
            for savedIndex = 1, numSaved do

                local name = GetSavedInstanceInfo(savedIndex)
                
                if name == "Zul'Gurub" then
                    buttonText = buttonText .. " ZG"
                elseif name == "Molten Core" then
                    buttonText = buttonText .. " MC"
                elseif name == "Blackwing Lair" then
                    buttonText = buttonText .. " BWL"
                elseif name == "Onyxia's Lair" then
                    buttonText = buttonText .. " ONY"
                elseif name == "Ruins of Ahn'Qiraj" then
                    buttonText = buttonText .. " AQ20"
                elseif name == "Ahn'Qiraj" then
                    buttonText = buttonText .. " AQ40"
                end

            end
        end
        
    end
        
end

-- **************************************************************************
--  _SetTooltip()
-- **************************************************************************
function TRaidLockout_SetTooltip()
            
	tooltipText = ""
    local numSaved = GetNumSavedInstances()
    local showHeader = TitanGetVar(TITAN_RAIDLOCKOUT_ID, "ShowTooltipHeader")
    local headerText = ""
    
    if showHeader then
        headerText = headerText .. "|cFFA9A9A9Instance Name [Bosses] - Reset Time\n"
    end
        
    tooltipText = tooltipText .. headerText
    
    if numSaved < 1 then
        
        tooltipText = tooltipText .. "|cFFFFFFFFAll raid instances are unlocked"
        
    else
        -- Add locked instances to tooltip
        for savedIndex = 1, numSaved do

            local name, _, reset, _, _, _, _, _, _, _, numEncounters, encounterProgress, _ = GetSavedInstanceInfo(savedIndex)
            
            local timeToReset = reset + time()
            local dateTable = date("*t", timeToReset)
            dateTable["min"] = 0
            local dateToReset = date("%a %d/%m %H:%M", time(dateTable))

            local progress = ""

            if ( encounterProgress < numEncounters ) then
                progress = progress .. "|cFF3DDC53" .. encounterProgress
            else
                progress = progress .. "|cFFFFF244" .. encounterProgress
            end

            tooltipText = tooltipText .. "|cFFDE1010" .. name .. "|cFFFFFFFF [" .. progress .. "|cFFFFF244/" .. numEncounters .. "|cFFFFFFFF]|cFFFFF244 - " .. dateToReset .. "\n"
            
            dateToReset = nil

        end
    end
    
end