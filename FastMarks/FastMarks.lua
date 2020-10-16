local FM = "FastMarks"
local FMF = "FastMarksFlares"
local versionNum = GetAddOnMetadata("FastMarks", "Version")
local curVer = versionNum 

Defaults = {
	shown = true,
	vertical = false,
	locked = true,
	clFMped = true,
	tooltips = false,
	backgroundHide = false,
	disabled = false,
	markerScale = 1,
	flareScale = 1,
	buttonScale = 1,
	buttonsEnabled = true,
}

local defaultBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true,
	tileSize = 16,
	edgeSize = 16,
	insets = {left = 4, right = 4, top = 4, bottom = 4,}
}
local borderlessBackdrop = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	tile = true,
	tileSize = 16
}

local editBoxBackdrop = {
	bgFile = "Interface\\COMMON\\Common-Input-Border",
	tile = false,
}

FM_mainFrame = CreateFrame("Frame", "FM_mainFrame", UIParent)
--FM_mainFrame:SetBackdrop(borderlessBackdrop)
--FM_mainFrame:SetBackdropColor(0,0,0,0)
FM_mainFrame:EnableMouse(true)
FM_mainFrame:SetMovable(true)
FM_mainFrame:SetSize(190,35)
FM_mainFrame:SetPoint("TOP", UIParent, "TOP")
FM_mainFrame:SetClampedToScreen(true)

local FM_IconFrame = CreateFrame("Frame", "FM_IconFrame", FM_mainFrame)
--FM_IconFrame:SetBackdrop(defaultBackdrop)
--FM_IconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
FM_IconFrame:EnableMouse(true)
FM_IconFrame:SetMovable(true)
FM_IconFrame:SetSize(190,35)
FM_IconFrame:SetPoint("LEFT", FM_mainFrame, "LEFT")
FM_IconFrame:SetScript("OnMouseDown", function(self,button) if (button=="LeftButton" and Defaults.locked == false) then FM_mainFrame:StartMoving() end end)
FM_IconFrame:SetScript("OnMouseUp", function(self) FM_mainFrame:StopMovingOrSizing() end)

local FM_IconSkull = CreateFrame("Button", "FM_IconSkull", FM_IconFrame)
FM_IconSkull:SetSize(20,20)
FM_IconSkull:SetPoint("LEFT", FM_IconFrame, "LEFT",5,0)
FM_IconSkull:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconSkull:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
FM_IconSkull:EnableMouse(true)
FM_IconSkull:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 8) end)

local FM_IconCross = CreateFrame("Button", "FM_IconCross", FM_IconFrame)
FM_IconCross:SetSize(20,20)
FM_IconCross:SetPoint("LEFT", FM_IconSkull, "RIGHT")
FM_IconCross:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconCross:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
FM_IconCross:EnableMouse(true)
FM_IconCross:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 7) end)

local FM_IconSquare = CreateFrame("Button", "FM_IconSquare", FM_IconFrame)
FM_IconSquare:SetSize(20,20)
FM_IconSquare:SetPoint("LEFT", FM_IconCross, "RIGHT")
FM_IconSquare:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconSquare:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
FM_IconSquare:EnableMouse(true)
FM_IconSquare:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 6) end)

local FM_IconMoon = CreateFrame("Button", "FM_IconMoon", FM_IconFrame)
FM_IconMoon:SetSize(20,20)
FM_IconMoon:SetPoint("LEFT", FM_IconSquare, "RIGHT")
FM_IconMoon:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconMoon:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
FM_IconMoon:EnableMouse(true)
FM_IconMoon:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 5) end)

local FM_IconTriangle = CreateFrame("Button", "FM_IconTriangle", FM_IconFrame)
FM_IconTriangle:SetSize(20,20)
FM_IconTriangle:SetPoint("LEFT", FM_IconMoon, "RIGHT")
FM_IconTriangle:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconTriangle:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
FM_IconTriangle:EnableMouse(true)
FM_IconTriangle:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 4) end)

local FM_IconDiFMond = CreateFrame("Button", "FM_IconDiFMond", FM_IconFrame)
FM_IconDiFMond:SetSize(20,20)
FM_IconDiFMond:SetPoint("LEFT", FM_IconTriangle, "RIGHT")
FM_IconDiFMond:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconDiFMond:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
FM_IconDiFMond:EnableMouse(true)
FM_IconDiFMond:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 3) end)

local FM_IconCircle = CreateFrame("Button", "FM_IconCircle", FM_IconFrame)
FM_IconCircle:SetSize(20,20)
FM_IconCircle:SetPoint("LEFT", FM_IconDiFMond, "RIGHT")
FM_IconCircle:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconCircle:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
FM_IconCircle:EnableMouse(true)
FM_IconCircle:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 2) end)

local FM_IconStar = CreateFrame("Button", "FM_IconStar", FM_IconFrame)
FM_IconStar:SetSize(20,20)
FM_IconStar:SetPoint("LEFT", FM_IconCircle, "RIGHT")
FM_IconStar:SetNormalTexture("interface\\targetingFrame\\ui-raidtargetingIcons")
FM_IconStar:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
FM_IconStar:EnableMouse(true)
FM_IconStar:SetScript("OnClick", function(self) SetRaidTargetIcon("target", 1) end)

local FM_LockIcon = CreateFrame("Button", "FM_LockIcon", FM_IconFrame)
FM_LockIcon:SetSize(20,20)
FM_LockIcon:SetPoint("LEFT", FM_IconStar , "RIGHT")
FM_LockIcon:SetNormalTexture("Interface\\GLUES\\CharacterSelect\\Glues-Addon-Icons")
FM_LockIcon:GetNormalTexture():SetTexCoord(0, 0.25, 0, 1)
FM_LockIcon:EnableMouse(true)
FM_LockIcon:SetScript("OnClick", function(self) FM_lockToggle() end)

function FM_lock()
    Defaults.locked = true
	FM_mainFrame:EnableMouse(false)
	FM_mainFrame:SetMovable(false)
    FM_LockIcon:GetNormalTexture():SetTexCoord(0, 0.25, 0, 1)
end

function FM_unlock()
    Defaults.locked = false
	FM_mainFrame:EnableMouse(true)
	FM_mainFrame:SetMovable(true)
    FM_LockIcon:GetNormalTexture():SetTexCoord(0.25, 0.50, 0, 1)
end

function FM_lockToggle()
    if Defaults.locked then FM_unlock("main") else FM_lock("main") end
end   

function FM_scale(self, DB)
	if self == nil then return end
	if DB == "main" then
		Defaults.markerScale = (self:GetValue())
		getglobal(self:GetName().."Text"):SetText("Marker scale: "..math.floor((Defaults.markerScale*100)).."%")
		FM_mainFrame:SetScale(Defaults.markerScale)
	elseif DB == "flare" then
		Defaults.flareScale = (self:GetValue())
		getglobal(self:GetName().."Text"):SetText("Flares scale: "..math.floor((Defaults.flareScale*100)).."%")
	end
end

function FM_backgroundChange()
	if Defaults.backgroundHide == true then
		--FM_IconFrame:SetBackdropColor(0,0,0,0)
		--FM_IconFrame:SetBackdropBorderColor(0,0,0,0)
	elseif Defaults.backgroundHide == false then
		--FM_IconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		--FM_IconFrame:SetBackdropBorderColor(1,1,1,1)
	end
end

function FM_makeVertical()
	FM_IconSkull:ClearAllPoints()
	FM_IconCross:ClearAllPoints()
	FM_IconSquare:ClearAllPoints()
	FM_IconMoon:ClearAllPoints()
	FM_IconTriangle:ClearAllPoints()
	FM_IconDiFMond:ClearAllPoints()
	FM_IconCircle:ClearAllPoints()
	FM_IconStar:ClearAllPoints()
	FM_LockIcon:ClearAllPoints()
	FM_IconFrame:ClearAllPoints()
	
	if Defaults.vertical == true then
		FM_IconSkull:SetPoint("TOP", FM_IconFrame, "TOP",0,-5)
		FM_IconCross:SetPoint("TOP", FM_IconSkull, "BOTTOM")
		FM_IconSquare:SetPoint("TOP", FM_IconCross, "BOTTOM")
		FM_IconMoon:SetPoint("TOP", FM_IconSquare, "BOTTOM")
		FM_IconTriangle:SetPoint("TOP", FM_IconMoon, "BOTTOM")
		FM_IconDiFMond:SetPoint("TOP", FM_IconTriangle, "BOTTOM")
		FM_IconCircle:SetPoint("TOP", FM_IconDiFMond, "BOTTOM")
		FM_IconStar:SetPoint("TOP", FM_IconCircle, "BOTTOM")
		FM_LockIcon:SetPoint("TOP", FM_IconStar , "BOTTOM")
		FM_mainFrame:SetSize(35,190)
		FM_IconFrame:SetSize(35,190)
		FM_IconFrame:SetPoint("TOP", FM_mainFrame, "TOP")
		
	elseif Defaults.vertical == false then
		FM_IconSkull:SetPoint("LEFT", FM_IconFrame, "LEFT",5,0)
		FM_IconCross:SetPoint("LEFT", FM_IconSkull, "RIGHT")
		FM_IconSquare:SetPoint("LEFT", FM_IconCross, "RIGHT")
		FM_IconMoon:SetPoint("LEFT", FM_IconSquare, "RIGHT")
		FM_IconTriangle:SetPoint("LEFT", FM_IconMoon, "RIGHT")
		FM_IconDiFMond:SetPoint("LEFT", FM_IconTriangle, "RIGHT")
		FM_IconCircle:SetPoint("LEFT", FM_IconDiFMond, "RIGHT")
		FM_IconStar:SetPoint("LEFT", FM_IconCircle, "RIGHT")
		FM_LockIcon:SetPoint("LEFT", FM_IconStar , "RIGHT")
		FM_mainFrame:SetSize(190,35)
		FM_IconFrame:SetSize(190,35)
		FM_IconFrame:SetPoint("LEFT", FM_mainFrame, "LEFT")
	end
end

function FM_disable()
	if Defaults.disabled == true then
		FM_IconSkull:Hide()
		FM_IconCross:Hide()
		FM_IconSquare:Hide()
		FM_IconMoon:Hide()
		FM_IconTriangle:Hide()
		FM_IconDiFMond:Hide()
		FM_IconCircle:Hide()
		FM_IconStar:Hide()
		FM_LockIcon:Hide()
		FM_IconFrame:Hide()
		
	elseif Defaults.disabled == false then
		FM_IconSkull:Show()
		FM_IconCross:Show()
		FM_IconSquare:Show()
		FM_IconMoon:Show()
		FM_IconTriangle:Show()
		FM_IconDiFMond:Show()
		FM_IconCircle:Show()
		FM_IconStar:Show()
		FM_LockIcon:Show()
		FM_IconFrame:Show()

	end
end

function FM_SavePositions()
	local m_ap, _, _, m_x, m_y = FM_mainFrame:GetPoint()
	Defaults.FlaresAP = f_ap
	Defaults.FlaresX = f_x
	Defaults.FlaresY = f_y	
	Defaults.MarkersAP = m_ap
	Defaults.MarkersX = m_x
	Defaults.MarkersY = m_y
end

function FM_SetPositions()
	if (Defaults.MarkersX ~= nil) then
		FM_mainFrame:ClearAllPoints()
		FM_mainFrame:SetPoint(Defaults.MarkersAP, UIParent, Defaults.MarkersX, Defaults.MarkersY)
		FM_CheckUpdater()
	end
end

function FM_CheckUpdater()
	FastMarksVertCheck:SetChecked(Defaults.vertical)
	if Defaults.vertical == true then
		FM_makeVertical()
	end
	FastMarksBackgroundCheck:SetChecked(Defaults.backgroundHide)
	if Defaults.backgroundHide == true then
		FM_backgroundChange()
	end
	FastMarksDisablerCheck:SetChecked(Defaults.disabled)
	if Defaults.disabled == true then
		FM_disable()
	end
	FM_mainFrame:SetScale(Defaults.markerScale);
end

FastMarksOptions = {};
FastMarksOptions.panel = CreateFrame( "Frame", "FastMarksOptions", InterfaceOptionsFramePanelContainer );
FastMarksOptions.panel.name = "FastMarks";
InterfaceOptions_AddCategory(FastMarksOptions.panel);

local FastMarksOptionsTitle = FastMarksOptions.panel:CreateFontString("FastMarksOptionsTitle", "OVERLAY", "ChatFontNormal")
FastMarksOptionsTitle:SetPoint("TOP", FastMarksOptions.panel, "TOP",0,-10) 
FastMarksOptionsTitle:SetText("|cffe1a500 FastMarks Options")

local FastMarksVertCheck = CreateFrame("CheckButton", "FastMarksVertCheck", FastMarksOptions.panel, "UICheckButtonTemplate")
FastMarksVertCheck:SetPoint("LEFT",FastMarksOptions.panel,"TOPLEFT",10,-50)
FastMarksVertCheck:SetSize(20,20)
FastMarksVertCheck:SetScript("OnClick", function(self) Defaults.vertical = not Defaults.vertical; FM_makeVertical() end)
local FastMarksVertText = FastMarksOptions.panel:CreateFontString("vertText", "OVERLAY", "ChatFontSmall")
FastMarksVertText:SetPoint("LEFT", FastMarksVertCheck , "RIGHT", 5,0)
FastMarksVertText:SetText("|cffe1a500 Display vertically")

local FastMarksBackgroundCheck = CreateFrame("CheckButton", "FastMarksBackgroundCheck", FastMarksOptions.panel, "UICheckButtonTemplate")
FastMarksBackgroundCheck:SetPoint("TOP",FastMarksVertCheck,"BOTTOM",0,-5)
FastMarksBackgroundCheck:SetSize(20,20)
FastMarksBackgroundCheck:SetScript("OnClick", function(self) Defaults.backgroundHide = not Defaults.backgroundHide; FM_backgroundChange() end)
local FastMarksBackgroundText = FastMarksOptions.panel:CreateFontString("FastMarksBackgroundText", "OVERLAY", "ChatFontSmall")
FastMarksBackgroundText:SetPoint("LEFT", FastMarksBackgroundCheck, "RIGHT", 5,0)
FastMarksBackgroundText:SetText("|cffe1a500 Hide background and border")

local FastMarksDisablerCheck = CreateFrame("CheckButton", "FastMarksDisablerCheck", FastMarksOptions.panel, "UICheckButtonTemplate")
FastMarksDisablerCheck:SetPoint("TOP",FastMarksBackgroundCheck,"BOTTOM",0,-5)
FastMarksDisablerCheck:SetSize(20,20)
FastMarksDisablerCheck:SetScript("OnClick", function(self) Defaults.disabled = not Defaults.disabled; FM_disable() end)
local FastMarksDisablerText = FastMarksOptions.panel:CreateFontString("FastMarksDisablerText", "OVERLAY", "ChatFontSmall")
FastMarksDisablerText:SetPoint("LEFT", FastMarksDisablerCheck, "RIGHT", 5,0)
FastMarksDisablerText:SetText("|cffe1a500 Disable FastMarks")

local FastMarksScale = CreateFrame("Slider", "FastMarksScale", FastMarksOptions.panel, "OptionsSliderTemplate")
FastMarksScale:SetPoint("TOPLEFT", FastMarksDisablerCheck, "BOTTOMLEFT",0,-25)
FastMarksScale:SetSize(180,16)
FastMarksScale:SetMinMaxValues(0.5,1.5)
FastMarksScale:SetValue(1)
FastMarksScale:SetValueStep(0.01)
FastMarksScale:SetOrientation("HORIZONTAL")
getglobal(FastMarksScale:GetName().."Low"):SetText("50%")
getglobal(FastMarksScale:GetName().."High"):SetText("150%")
FastMarksScale:SetValue(Defaults.markerScale)
FastMarksScale:SetScript("OnValueChanged", function(self) FM_scale(self, "main") end)
FastMarksScale:SetScript("OnLoad", function(self) FM_scale(self, "main") end)

local FM_OnUpdate = CreateFrame("Frame")
FM_OnUpdate:RegisterEvent("ADDON_LOADED")
FM_OnUpdate:RegisterEvent("PLAYER_LOGOUT")
FM_OnUpdate:RegisterEvent("PLAYER_LOGIN")
FM_OnUpdate:RegisterEvent("PLAYER_ENTERING_WORLD")
FM_OnUpdate:RegisterEvent("PLAYER_REGEN_DISABLED")
FM_OnUpdate:RegisterEvent("PLAYER_REGEN_ENABLED")

FM_OnUpdate:SetScript("OnEvent", function(self,event,addon,...)
	if (event=="PLAYER_LOGOUT" or event=="PLAYER_ENTERING_WORLD") then
		FM_SavePositions()
	end
	if (event=="PLAYER_LOGIN") then
		FM_SetPositions()
	end
end)

SLASH_MB1 = '/FM'
SLASH_MB2 = '/FastMarks'
function SlashCmdList.MB(msg, editbox)
	local chan
	if (msg=="options") then
		InterfaceOptionsFrame_OpenToCategory(FastMarksOptions.panel)
		InterfaceOptionsFrame_OpenToCategory(FastMarksOptions.panel)
    elseif (msg=="options") then
	else
		DEFAULT_CHAT_Frame:AddMessage("use /FM options to open configuration screen")
	end
end