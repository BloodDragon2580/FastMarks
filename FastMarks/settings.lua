-- Localization
local L = FastMarksLocales

-------------------------------------------------------
-- Ace Options Table
-------------------------------------------------------

FastMarksAce = LibStub("AceAddon-3.0"):GetAddon("FastMarks")
local config = FastMarksAce:NewModule("FastMarksConfig", "AceEvent-3.0");
local dbRaid, dbWorld, dbFLoc = nil
FastMarksDB = nil
FastMarksFlaresDB = nil

function config:OnInitialize()
	dbRaid = FastMarksAce.db.profile.raid
	dbWorld = FastMarksAce.db.profile.world
	dbFLoc = FastMarksAce.db.profile.frameLoc

	--Look for old configs, Pre-Ace
	FastMarksDB = FastMarksDB or {}
	FastMarksFlaresDB = FastMarksFlaresDB or {}

	FastMarksAce.db.RegisterCallback(FastMarksAce, "OnProfileReset", "ConfigCheck")
	FastMarksAce.db.RegisterCallback(FastMarksAce, "OnProfileChanged","ConfigCheck")
	FastMarksAce.db.RegisterCallback(FastMarksAce, "OnProfileCopied","ConfigCheck")

	FastMarksAce:RegisterChatCommand("FastMarks","SlashInput")
	FastMarksAce:RegisterChatCommand("fm","SlashInput")
	FastMarksAce:RegisterChatCommand("rc", "SlashReadyCheck")
	FastMarksAce:RegisterChatCommand("roc", "SlashRoleCheck")

	FastMarksAce:RegisterEvent("GROUP_ROSTER_UPDATE","EventHandler")
	FastMarksAce:RegisterEvent("RAID_ROSTER_UPDATE","EventHandler")
	FastMarksAce:RegisterEvent("PLAYER_TARGET_CHANGED","EventHandler")
	FastMarksAce:RegisterEvent("PLAYER_REGEN_ENABLED","EventHandler")

	FastMarksAce.db.global.lastVer = GetAddOnMetadata("FastMarks","Version")
end

function config:OnEnable()
	--Apply saved configs
	FastMarksAce:ConfigCheck()

end

function config:OnDisable()

	FastMarksAce.db.UnregisterAllCallbacks(FastMarksAce)

	FastMarksAce:UnregisterChatCommand("FastMarks","SlashInput")
	FastMarksAce:UnregisterChatCommand("fm","SlashInput")
	FastMarksAce:UnregisterChatCommand("rc", "SlashReadyCheck")
	FastMarksAce:UnregisterChatCommand("roc", "SlashRoleCheck")

	FastMarksAce:UnregisterEvent("GROUP_ROSTER_UPDATE","EventHandler")
	FastMarksAce:UnregisterEvent("RAID_ROSTER_UPDATE","EventHandler")
	FastMarksAce:UnregisterEvent("PLAYER_TARGET_CHANGED","EventHandler")
	FastMarksAce:UnregisterEvent("PLAYER_REGEN_ENABLED","EventHandler")
end

function FastMarksAce:ConfigCheck()
	dbRaid = FastMarksAce.db.profile.raid
	dbWorld = FastMarksAce.db.profile.world
	dbFLoc = FastMarksAce.db.profile.frameLoc

	-- Check if old configs exist, if not yet imported, complete the import
	if (FastMarksDB.locked ~= nil) and (FastMarksAce.db.global.imported == false or FastMarksAce.db.global.imported == nil) then FastMarksAce:ConfigImport() end

	-- Check for old loc exists in Ace, if yes, use these points and nil them
	if (dbRaid.point) then FastMarksAce.raidMain:ClearAllPoints(); FastMarksAce.raidMain:SetPoint(dbRaid.point, "UIParent", dbRaid.relPt, dbRaid.x, dbRaid.y); FastMarksAce:getLoc(FastMarksAce.raidMain); dbRaid.point, dbRaid.relPt, dbRaid.x, dbRaid.y = nil end
	FastMarksAce:setLoc(FastMarksAce.raidMain)
	if (dbWorld.point) then FastMarksAce.worldMain:ClearAllPoints(); FastMarksAce.worldMain:SetPoint(dbWorld.point, "UIParent", dbWorld.relPt, dbWorld.x, dbWorld.y); FastMarksAce:getLoc(FastMarksAce.worldMain); dbWorld.point, dbWorld.relPt, dbWorld.x, dbWorld.y = nil end
	FastMarksAce:setLoc(FastMarksAce.worldMain)

	FastMarksAce.raidMain:SetScale(dbRaid.scale)
	FastMarksAce.raidMain:SetAlpha(dbRaid.alpha)

	FastMarksAce.worldMain:SetScale(dbWorld.scale)
	FastMarksAce.worldMain:SetAlpha(dbWorld.alpha)

	FastMarksAce:updateClamp()
	FastMarksAce:updateVisibility()

	FastMarksAce:updateLock()
	FastMarksAce:backgroundVisibility()

	FastMarksAce:raidOrient()
	FastMarksAce:worldOrient()

	FastMarksAce:worldRetext(dbWorld.worldTex)
end

function FastMarksAce:ConfigImport()	
	local oldwDB = FastMarksDB
	local oldfDB = FastMarksFlaresDB
	dbRaid.locked = oldwDB.locked
	dbRaid.clamped = oldwDB.clamped
	dbRaid.shown = oldwDB.shown
	dbRaid.flipped = oldwDB.flipped
	dbRaid.vertical = oldwDB.vertical
	dbRaid.partyShow = oldwDB.partyShow
	dbRaid.targetShow = oldwDB.targetShow
	dbRaid.assistShow = oldwDB.assistShow
	dbRaid.bgHide = oldwDB.bgHide
	dbRaid.tooltips = oldwDB.tooltips
	dbRaid.iconSpace = oldwDB.iconSpace
	dbRaid.scale = oldwDB.scale
	dbRaid.alpha = oldwDB.alpha
	dbFLoc["FastMarksRaid"] = {"CENTER", "UIParent", oldwDB.relPt, oldwDB.x, oldwDB.y}

	dbWorld.locked = oldfDB.locked
	dbWorld.clamped = oldfDB.clamped
	dbWorld.shown = oldfDB.shown
	dbWorld.flipped = oldfDB.flipped
	dbWorld.vertical = oldfDB.vertical
	dbWorld.partyShow = oldfDB.partyShow
	dbWorld.targetShow = oldfDB.targetShow
	dbWorld.assistShow = oldfDB.assistShow
	dbWorld.bgHide = oldfDB.bgHide
	dbWorld.tooltips = oldfDB.tooltips
	dbWorld.scale = oldfDB.scale
	dbWorld.alpha = oldfDB.alpha
	dbFLoc["FastMarksWorld"] = {"CENTER", "UIParent", oldfDB.relPt, oldfDB.x, oldfDB.y}

	FastMarksAce.db.global.imported = true
	FastMarksDB = nil
	FastMarksFlaresDB = nil
	FastMarksAce:Print("Configurations imported from legacy FastMarks")
end

FastMarksAce.options = {
	name = "FastMarks",
	handler = FastMarksAce,
	type = 'group',
	args = {
		raidMarkers = {
			type = 'group',
			name = L["Raid marker"],
			order = 10,
			width = "full",
			args = {
				raidMarkersText = {
					type = "description",
					name = (FastMarksAce.titleText.." - "..L["Raid marker"]),
					fontSize = "large",
					width = "full",
					order = 0,
				},
				spacer = {
					type = "description",
					name = "",
					fontSize = "large",
					width = "full",
					order = 1,
				},
				showCheck = {
					type = "toggle",
					name = L["Show frame"],
					set = "raidShowToggle",
					get = function(info) return dbRaid.shown end,
					order = 5,
					width = "full",
				},
				lockCheck = {
					type = "toggle",
					name = L["Lock frame"],
					set = "raidLockToggle",
					get = function(info) return dbRaid.locked end,
					order = 10,
				},
				clampCheck = {
					type = "toggle",
					name = L["Clamp to screen"],
					set = "raidClampToggle",
					get = function(info) return dbRaid.clamped end,
					order = 15,
				},
				reverseCheck = {
					type = "toggle",
					name = L["Reverse icons"],
					set = "raidReverseToggle",
					get = function(info) return dbRaid.flipped end,
					order = 20,
				},
				vertCheck = {
					type = "toggle",
					name = L["Display vertically"],
					set = "raidVertToggle",
					get = function(info) return dbRaid.vertical end,
					order = 25,
				},
				aloneCheck = {
					type = "toggle",
					name = L["Hide when alone"],
					set = "raidPartyToggle",
					get = function(info) return dbRaid.partyShow end,
					order = 30,
				},
				targetCheck = {
					type = "toggle",
					name = L["Show only with a target"],
					set = "raidTargetToggle",
					get = function(info) return dbRaid.targetShow end,
					order = 35,					
				},
				assistCheck = {
					type = "toggle",
					name = L["Hide without assist (in a raid)"],
					set = "raidAssistToggle",
					get = function(info) return dbRaid.assistShow end,
					order = 40,
					width = "full"
				},
				hideBGCheck = {
					type = "toggle",
					name = L["Hide background"],
					set = "raidBgToggle",
					get = function(info) return dbRaid.bgHide end,
					order = 45,
				},
				tooltipsCheck = {
					type = "toggle",
					name = L["Enable tooltips"],
					set = "raidTooltipsToggle",
					get = function(info) return dbRaid.tooltips end,
					order = 50,
				},
				scaleSlider = {
					type = "range",
					name = "Scale",
					min = 0.5,
					max = 2,
					step = 0.05,
					isPercent = true,
					set = "raidScaleSet",
					get = function(info) return dbRaid.scale end,
					order = 55
				},
				alphaSlider = {
					type = "range",
					name = "Transparency",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					set = "raidAlphaSet",
					get = function(info) return dbRaid.alpha end,
					order = 60
				},
				spacingSlider = {
					type = "range",
					name = L["Icon spacing"],
					min = -5,
					max = 15,
					step = 1,
					set = "raidSpacingSet",
					get = function(info) return dbRaid.iconSpace end,
					order = 65
				},
			},
		},
		worldMarkers = {
			type = 'group',
			name = L["World markers"],
			order = 20,
			args = {
				worldMarkersText = {
					type = "description",
					name = (FastMarksAce.titleText.." - "..L["World markers"]),
					fontSize = "large",
					width = "full",
					order = 0,
				},
				spacer = {
					type = "description",
					name = "",
					fontSize = "large",
					width = "full",
					order = 1,
				},
				showCheck = {
					type = "toggle",
					name = L["Show frame"],
					set = "worldShowToggle",
					get = function(info) return dbWorld.shown end,
					order = 5,
					width = "full"
				},
				lockCheck = {
					type = "toggle",
					name = L["Lock frame"],
					set = "worldLockToggle",
					get = function(info) return dbWorld.locked end,
					order = 10,
				},
				clampCheck = {
					type = "toggle",
					name = L["Clamp to screen"],
					set = "worldClampToggle",
					get = function(info) return dbWorld.clamped end,
					order = 15,
				},
				reverseCheck = {
					type = "toggle",
					name = L["Reverse icons"],
					set = "worldReverseToggle",
					get = function(info) return dbWorld.flipped end,
					order = 20,
				},
				vertCheck = {
					type = "toggle",
					name = L["Display vertically"],
					set = "worldVertToggle",
					get = function(info) return dbWorld.vertical end,
					order = 25,
				},
				aloneCheck = {
					type = "toggle",
					name = L["Hide when alone"],
					set = "worldPartyToggle",
					get = function(info) return dbWorld.partyShow end,
					order = 30,
				},
				assistCheck = {
					type = "toggle",
					name = L["Hide without assist (in a raid)"],
					set = "worldAssistToggle",
					get = function(info) return dbWorld.assistShow end,
					order = 40,
					width = "full"
				},
				hideBGCheck = {
					type = "toggle",
					name = L["Hide background"],
					set = "worldBgToggle",
					get = function(info) return dbWorld.bgHide end,
					order = 45,
				},
				tooltipsCheck = {
					type = "toggle",
					name = L["Enable tooltips"],
					set = "worldTooltipsToggle",
					get = function(info) return dbWorld.tooltips end,
					order = 50,
				},
				scaleSlider = {
					type = "range",
					name = "Scale",
					min = 0.5,
					max = 2,
					step = 0.05,
					isPercent = true,
					set = "worldScaleSet",
					get = function(info) return dbWorld.scale end,
					order = 55
				},
				alphaSlider = {
					type = "range",
					name = "Transparency",
					min = 0,
					max = 1,
					step = 0.05,
					isPercent = true,
					set = "worldAlphaSet",
					get = function(info) return dbWorld.alpha end,
					order = 60
				},
				displayAsRadio = {
					type = "select",
					style = "radio",
					name = L["Display as"],
					values = {[1] = L["Blips"], [2] = L["Icons"]},
					set = "worldTexSelect",
					get = function(info) return dbWorld.worldTex end,
					order = 65
				},
			}
		},
	},
}

-------------------------------------------------------
-- Option Handlers
-------------------------------------------------------

--Raid Marker Handlers
function FastMarksAce:raidShowToggle()
	dbRaid.shown = not dbRaid.shown
	FastMarksAce:updateVisibility()
end

function FastMarksAce:raidLockToggle()
	dbRaid.locked = not dbRaid.locked
	FastMarksAce:updateLock()
end

function FastMarksAce:raidClampToggle()
	dbRaid.clamped = not dbRaid.clamped
	FastMarksAce:updateClamp();
end

function FastMarksAce:raidReverseToggle()
	dbRaid.flipped = not dbRaid.flipped
	FastMarksAce:raidOrient()
end

function FastMarksAce:raidVertToggle()
	dbRaid.vertical = not dbRaid.vertical
	FastMarksAce:raidOrient()
end

function FastMarksAce:raidPartyToggle()
	dbRaid.partyShow = not dbRaid.partyShow
	FastMarksAce:updateVisibility()
end

function FastMarksAce:raidTargetToggle()
	dbRaid.targetShow = not dbRaid.targetShow
	FastMarksAce:updateVisibility()
end

function FastMarksAce:raidAssistToggle()
	dbRaid.assistShow = not dbRaid.assistShow
	FastMarksAce:updateVisibility()
end

function FastMarksAce:raidBgToggle()
	dbRaid.bgHide = not dbRaid.bgHide
	FastMarksAce:backgroundVisibility()
end

function FastMarksAce:raidTooltipsToggle()
	dbRaid.tooltips = not dbRaid.tooltips
end

function FastMarksAce:raidScaleSet(info, input)
	dbRaid.scale = input
	FastMarksAce.raidMain:SetScale(dbRaid.scale)
end

function FastMarksAce:raidAlphaSet(info, input)
	dbRaid.alpha = input
	FastMarksAce.raidMain:SetAlpha(dbRaid.alpha);
end

function FastMarksAce:raidSpacingSet(info, input)
	dbRaid.iconSpace = input
	FastMarksAce:raidOrient()
end

--World Marker Handlers
function FastMarksAce:worldShowToggle()
	dbWorld.shown = not dbWorld.shown
	FastMarksAce:updateVisibility()
end

function FastMarksAce:worldLockToggle()
	dbWorld.locked = not dbWorld.locked
	FastMarksAce:updateLock()
end

function FastMarksAce:worldClampToggle()
	dbWorld.clamped = not dbWorld.clamped
	FastMarksAce:updateClamp();
end

function FastMarksAce:worldReverseToggle()
	dbWorld.flipped = not dbWorld.flipped
	FastMarksAce:worldOrient()
end

function FastMarksAce:worldVertToggle()
	dbWorld.vertical = not dbWorld.vertical
	FastMarksAce:worldOrient()
end

function FastMarksAce:worldPartyToggle()
	dbWorld.partyShow = not dbWorld.partyShow
	FastMarksAce:updateVisibility()
end

function FastMarksAce:worldAssistToggle()
	dbWorld.assistShow = not dbWorld.assistShow
	FastMarksAce:updateVisibility()
end

function FastMarksAce:worldBgToggle()
	dbWorld.bgHide = not dbWorld.bgHide
	FastMarksAce:backgroundVisibility()
end

function FastMarksAce:worldTooltipsToggle()
	dbWorld.tooltips = not dbWorld.tooltips
end

function FastMarksAce:worldScaleSet(info, input)
	dbWorld.scale = input
	FastMarksAce.worldMain:SetScale(dbWorld.scale)
end

function FastMarksAce:worldAlphaSet(info, input)
	dbWorld.alpha = input
	FastMarksAce.worldMain:SetAlpha(dbWorld.alpha);
end

function FastMarksAce:worldTexSelect(info, input)
	dbWorld.worldTex = input
	FastMarksAce:worldRetext(dbWorld.worldTex)
end

-------------------------------------------------------
-- Helper Functions
-------------------------------------------------------

-- Based on Shadowed's Out of Combat function queue
FastMarks_queuedFuncs = {};
function FastMarksAce:RegisterOOCFunc(self,func)
	if (type(func)=="string") then
		FastMarks_queuedFuncs[func] = self;		
	else
		FastMarks_queuedFuncs[self] = true;
	end	
end

-------------------------------------------------------
-- Frame Manipulation functions (Oh so many of them.)
-------------------------------------------------------

function FastMarksAce:updateVisibility()
	--Start off by saying both should be shown
	FastMarksAce.raidMain:Show()
	local worldMarks = true

	--Raid Marker check
	if (dbRaid.shown==false) then FastMarksAce.raidMain:Hide() end
	if (dbRaid.partyShow==true) then if (GetNumGroupMembers()==0) then FastMarksAce.raidMain:Hide() end end
	if (dbRaid.targetShow==true) then if not (UnitExists("target")) then FastMarksAce.raidMain:Hide() end end
	if (dbRaid.assistShow==true) then if (IsInRaid()) and (UnitIsGroupAssistant("player")==false and UnitIsGroupLeader("player")==false) then FastMarksAce.raidMain:Hide() end end

	--World Marker check
	if (dbWorld.shown==false) then worldMarks = false end
	if (dbWorld.partyShow==true) then if (GetNumGroupMembers()==0) then worldMarks = false end end
	if (dbWorld.assistShow==true) then if (IsInRaid()==true) and (UnitIsGroupAssistant("player")==false and UnitIsGroupLeader("player")==false) then worldMarks = false end end

	--World Marker hide/show
	if not (InCombatLockdown()) then
		if (worldMarks==true) then
			if not(FastMarksAce.worldMain:IsShown()) then 
				FastMarksAce.worldMain:Show() 
			end
		else
			if (FastMarksAce.worldMain:IsShown()) then
				FastMarksAce.worldMain:Hide()
			end
		end
	else
		FastMarksAce:RegisterOOCFunc(self,"updateVisibility");
	end
end

function FastMarksAce:updateLock()
	if (dbRaid.locked==true) then
		FastMarksAce.raidMain.moverLeft:SetAlpha(0)
		FastMarksAce.raidMain.moverLeft:EnableMouse(false)
		FastMarksAce.raidMain.moverRight:SetAlpha(0)
		FastMarksAce.raidMain.moverRight:EnableMouse(false)
	elseif (dbRaid.locked==false) then
		FastMarksAce.raidMain.moverLeft:SetAlpha(1)
		FastMarksAce.raidMain.moverLeft:EnableMouse(true)
		FastMarksAce.raidMain.moverRight:SetAlpha(1)
		FastMarksAce.raidMain.moverRight:EnableMouse(true)
	end
	if (dbWorld.locked==true) then
		FastMarksAce.worldMain.moverLeft:SetAlpha(0)
		FastMarksAce.worldMain.moverLeft:EnableMouse(false)
		FastMarksAce.worldMain.moverRight:SetAlpha(0)
		FastMarksAce.worldMain.moverRight:EnableMouse(false)
	elseif (dbWorld.locked==false) then
		FastMarksAce.worldMain.moverLeft:SetAlpha(1)
		FastMarksAce.worldMain.moverLeft:EnableMouse(true)
		FastMarksAce.worldMain.moverRight:SetAlpha(1)
		FastMarksAce.worldMain.moverRight:EnableMouse(true)
	end
end

function FastMarksAce:backgroundVisibility()
	if (dbRaid.bgHide==true) then
		FastMarksAce.raidMain.iconFrame:SetBackdropColor(0,0,0,0)
		FastMarksAce.raidMain.iconFrame:SetBackdropBorderColor(0,0,0,0)
		FastMarksAce.raidMain.controlFrame:SetBackdropColor(0,0,0,0)
		FastMarksAce.raidMain.controlFrame:SetBackdropBorderColor(0,0,0,0)
	elseif (dbRaid.bgHide==false) then
		FastMarksAce.raidMain.iconFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		FastMarksAce.raidMain.iconFrame:SetBackdropBorderColor(1,1,1,1)
		FastMarksAce.raidMain.controlFrame:SetBackdropColor(0.1,0.1,0.1,0.7)
		FastMarksAce.raidMain.controlFrame:SetBackdropBorderColor(1,1,1,1)
	end
	if (dbWorld.bgHide==true) then
		FastMarksAce.worldMain:SetBackdropColor(0,0,0,0)
		FastMarksAce.worldMain:SetBackdropBorderColor(0,0,0,0)
	elseif (dbWorld.bgHide==false) then
		FastMarksAce.worldMain:SetBackdropColor(0.1,0.1,0.1,0.7)
		FastMarksAce.worldMain:SetBackdropBorderColor(1,1,1,1)
	end
end

function FastMarksAce:updateClamp()
	FastMarksAce.raidMain:SetClampedToScreen(dbRaid.clamped or false)
	FastMarksAce.worldMain:SetClampedToScreen(dbWorld.clamped or false)
end

function FastMarksAce:raidFrameFormat(orient)
	if (orient=="horiz") then
		FastMarksAce.raidMain:SetSize(225+(dbRaid.iconSpace*7),35)
		FastMarksAce.raidMain.iconFrame:SetSize(170+(dbRaid.iconSpace*7),35)
		FastMarksAce.raidMain.controlFrame:SetSize(55,35)
		FastMarksAce.raidMain.iconFrame:SetPoint("LEFT", FastMarksAce.raidMain, "LEFT")
		FastMarksAce.raidMain.controlFrame:SetPoint("RIGHT", FastMarksAce.raidMain, "RIGHT")
		FastMarksAce.raidMain.moverLeft:SetSize(20,35)
		FastMarksAce.raidMain.moverRight:SetSize(20,35)
		FastMarksAce.raidMain.moverLeft:SetPoint("RIGHT",FastMarksAce.raidMain,"LEFT")
		FastMarksAce.raidMain.moverRight:SetPoint("LEFT",FastMarksAce.raidMain,"RIGHT")
	elseif (orient=="vert") then
		FastMarksAce.raidMain:SetSize(35,225+(dbRaid.iconSpace*7))
		FastMarksAce.raidMain.iconFrame:SetSize(35,170+(dbRaid.iconSpace*7))
		FastMarksAce.raidMain.controlFrame:SetSize(35,55)
		FastMarksAce.raidMain.iconFrame:SetPoint("TOP", FastMarksAce.raidMain, "TOP")
		FastMarksAce.raidMain.controlFrame:SetPoint("BOTTOM", FastMarksAce.raidMain, "BOTTOM")
		FastMarksAce.raidMain.moverLeft:SetSize(35,20)
		FastMarksAce.raidMain.moverRight:SetSize(35,20)
		FastMarksAce.raidMain.moverLeft:SetPoint("BOTTOM",FastMarksAce.raidMain,"TOP")
		FastMarksAce.raidMain.moverRight:SetPoint("TOP",FastMarksAce.raidMain,"BOTTOM")
	end
end

function FastMarksAce:raidOrientFormat(dir)
	for k,v in pairs(FastMarksAce.raidMain.icon) do v:ClearAllPoints() end
	FastMarksAce.raidMain.clearIcon:ClearAllPoints()
	FastMarksAce.raidMain.readyCheck:ClearAllPoints()
	FastMarksAce.raidMain.moverLeft:ClearAllPoints()
	FastMarksAce.raidMain.moverRight:ClearAllPoints()
	if (dir==1) then -- Normal
		FastMarksAce.raidMain.icon["Skull"]:SetPoint("LEFT", FastMarksAce.raidMain.iconFrame, "LEFT",5,0)
		for i = 2,8,1 do FastMarksAce.raidMain.icon[i]:SetPoint("LEFT", FastMarksAce.raidMain.icon[i-1], "RIGHT",dbRaid.iconSpace,0) end
		FastMarksAce.raidMain.clearIcon:SetPoint("LEFT", FastMarksAce.raidMain.controlFrame, "LEFT",10,0)
		FastMarksAce.raidMain.readyCheck:SetPoint("LEFT", FastMarksAce.raidMain.clearIcon, "RIGHT")
		FastMarksAce:raidFrameFormat("horiz")
	elseif (dir==2) then -- Backwards
		FastMarksAce.raidMain.icon["Star"]:SetPoint("LEFT",FastMarksAce.raidMain.iconFrame,"LEFT",5,0)
		for i = 7,1,-1 do FastMarksAce.raidMain.icon[i]:SetPoint("LEFT",FastMarksAce.raidMain.icon[i+1],"RIGHT",dbRaid.iconSpace,0) end
		FastMarksAce.raidMain.clearIcon:SetPoint("LEFT", FastMarksAce.raidMain.controlFrame, "LEFT",10,0)
		FastMarksAce.raidMain.readyCheck:SetPoint("LEFT", FastMarksAce.raidMain.clearIcon, "RIGHT")
		FastMarksAce:raidFrameFormat("horiz")
	elseif (dir==3) then -- Normal vertical
		FastMarksAce.raidMain.icon["Skull"]:SetPoint("TOP", FastMarksAce.raidMain.iconFrame, "TOP",0,-5)
		for i = 2,8,1 do FastMarksAce.raidMain.icon[i]:SetPoint("TOP",FastMarksAce.raidMain.icon[i-1], "BOTTOM",0,0-dbRaid.iconSpace) end
		FastMarksAce.raidMain.clearIcon:SetPoint("TOP", FastMarksAce.raidMain.controlFrame, "TOP",0,-10)
		FastMarksAce.raidMain.readyCheck:SetPoint("TOP", FastMarksAce.raidMain.clearIcon, "BOTTOM")
		FastMarksAce:raidFrameFormat("vert")
	elseif (dir==4) then -- Backwards vertical
		FastMarksAce.raidMain.icon["Star"]:SetPoint("TOP", FastMarksAce.raidMain.iconFrame, "TOP",0,-5)
		for i = 7,1,-1 do FastMarksAce.raidMain.icon[i]:SetPoint("TOP", FastMarksAce.raidMain.icon[i+1], "BOTTOM",0,0-dbRaid.iconSpace) end
		FastMarksAce.raidMain.clearIcon:SetPoint("TOP", FastMarksAce.raidMain.controlFrame, "TOP",0,-10)
		FastMarksAce.raidMain.readyCheck:SetPoint("TOP", FastMarksAce.raidMain.clearIcon, "BOTTOM")
		FastMarksAce:raidFrameFormat("vert")
	end
end

function FastMarksAce:raidOrient()
	if (dbRaid.flipped==false) and (dbRaid.vertical==false) then
		FastMarksAce:raidOrientFormat(1)
	elseif (dbRaid.flipped==true) and (dbRaid.vertical==false) then 
		FastMarksAce:raidOrientFormat(2)	
	elseif (dbRaid.flipped==false) and (dbRaid.vertical==true) then
		FastMarksAce:raidOrientFormat(3)
	elseif (dbRaid.flipped==true) and (dbRaid.vertical==true) then
		FastMarksAce:raidOrientFormat(4)
	end
end

function FastMarksAce:worldFrameFormat(orient)
	if (orient=="horiz") then
		FastMarksAce.worldMain:SetSize(190,30)
		FastMarksAce.worldMain.moverLeft:SetSize(20,30)
		FastMarksAce.worldMain.moverRight:SetSize(20,30)
		FastMarksAce.worldMain.moverLeft:SetPoint("RIGHT",FastMarksAce.worldMain,"LEFT")
		FastMarksAce.worldMain.moverRight:SetPoint("LEFT",FastMarksAce.worldMain,"RIGHT")
	elseif (orient=="vert") then
		FastMarksAce.worldMain:SetSize(30,190)
		FastMarksAce.worldMain.moverLeft:SetSize(30,20)
		FastMarksAce.worldMain.moverRight:SetSize(30,20)
		FastMarksAce.worldMain.moverLeft:SetPoint("BOTTOM",FastMarksAce.worldMain,"TOP")
		FastMarksAce.worldMain.moverRight:SetPoint("TOP",FastMarksAce.worldMain,"BOTTOM")
	end
end

function FastMarksAce:worldOrientFormat(dir)
	for k,v in pairs(FastMarksAce.worldMain.marker) do v:ClearAllPoints() end
	FastMarksAce.worldMain.clearIcon:ClearAllPoints()
	FastMarksAce.worldMain.moverLeft:ClearAllPoints()
	FastMarksAce.worldMain.moverRight:ClearAllPoints()
	if (dir==1) then -- Normal
		FastMarksAce.worldMain.marker["Square"]:SetPoint("LEFT", FastMarksAce.worldMain, "LEFT",5,0)
		for i = 2,8 do FastMarksAce.worldMain.marker[i]:SetPoint("LEFT", FastMarksAce.worldMain.marker[i-1], "RIGHT") end
		FastMarksAce.worldMain.clearIcon:SetPoint("LEFT",FastMarksAce.worldMain.marker["Skull"],"RIGHT",3,0)
		FastMarksAce:worldFrameFormat("horiz")
	elseif (dir==2) then -- Backwards
		FastMarksAce.worldMain.marker["Skull"]:SetPoint("LEFT",FastMarksAce.worldMain,"LEFT",5,0)
		for i = 7,1,-1 do FastMarksAce.worldMain.marker[i]:SetPoint("LEFT",FastMarksAce.worldMain.marker[i+1],"RIGHT") end
		FastMarksAce.worldMain.clearIcon:SetPoint("LEFT",FastMarksAce.worldMain.marker["Square"],"RIGHT",3,0)
		FastMarksAce:worldFrameFormat("horiz")
	elseif (dir==3) then -- Normal vertical
		FastMarksAce.worldMain.marker["Square"]:SetPoint("TOP", FastMarksAce.worldMain, "TOP",0,-5)
		for i = 2,8 do FastMarksAce.worldMain.marker[i]:SetPoint("TOP",FastMarksAce.worldMain.marker[i-1], "BOTTOM") end
		FastMarksAce.worldMain.clearIcon:SetPoint("TOP",FastMarksAce.worldMain.marker["Skull"],"BOTTOM",0,-3)
		FastMarksAce:worldFrameFormat("vert")
	elseif (dir==4) then -- Backwards vertical
		FastMarksAce.worldMain.marker["Skull"]:SetPoint("TOP", FastMarksAce.worldMain, "TOP",0,-5)
		for i = 7,1,-1 do FastMarksAce.worldMain.marker[i]:SetPoint("TOP", FastMarksAce.worldMain.marker[i+1], "BOTTOM") end
		FastMarksAce.worldMain.clearIcon:SetPoint("TOP",FastMarksAce.worldMain.marker["Square"],"BOTTOM",0,-3)
		FastMarksAce:worldFrameFormat("vert")
	end
end

function FastMarksAce:worldOrient(dir)
	if not (UnitAffectingCombat("player")) then
		if (dbWorld.flipped==false) and (dbWorld.vertical==false) then
			FastMarksAce:worldOrientFormat(1)
		elseif (dbWorld.flipped==true) and (dbWorld.vertical==false) then 
			FastMarksAce:worldOrientFormat(2)	
		elseif (dbWorld.flipped==false) and (dbWorld.vertical==true) then
			FastMarksAce:worldOrientFormat(3)
		elseif (dbWorld.flipped==true) and (dbWorld.vertical==true) then
			FastMarksAce:worldOrientFormat(4)
		end
	else
		--World Markers frame cannot be changed while in combat since they're SecureActionButtons
		FastMarksAce:RegisterOOCFunc(self,"worldOrient");
	end
end

function FastMarksAce:worldRetext(tex)
	if (tex==1) then
		for k,v in pairs(FastMarksAce.worldMain.marker) do v:SetNormalTexture("interface\\minimap\\partyraidblips") end
		FastMarksAce.worldMain.marker["Square"]:GetNormalTexture():SetTexCoord(0.75,0.875,0,0.25)
		FastMarksAce.worldMain.marker["Triangle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0,0.25)
		FastMarksAce.worldMain.marker["Diamond"]:GetNormalTexture():SetTexCoord(0,0.125,0.25,0.5)
		FastMarksAce.worldMain.marker["Cross"]:GetNormalTexture():SetTexCoord(0.625,0.75,0,0.25)
		FastMarksAce.worldMain.marker["Star"]:GetNormalTexture():SetTexCoord(0.375,0.5,0,0.25)
		FastMarksAce.worldMain.marker["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.375,0.25,0.5)
		FastMarksAce.worldMain.marker["Moon"]:GetNormalTexture():SetTexCoord(0.875,1,0,0.25)
		FastMarksAce.worldMain.marker["Skull"]:GetNormalTexture():SetTexCoord(0.5,0.625,0,0.25)
	else
		for k,v in pairs(FastMarksAce.worldMain.marker) do v:SetNormalTexture("interface\\targetingframe\\ui-raidtargetingicons") end
		FastMarksAce.worldMain.marker["Square"]:GetNormalTexture():SetTexCoord(0.25,0.5,0.25,0.5)
		FastMarksAce.worldMain.marker["Triangle"]:GetNormalTexture():SetTexCoord(0.75,1,0,0.25)
		FastMarksAce.worldMain.marker["Diamond"]:GetNormalTexture():SetTexCoord(0.5,0.75,0,0.25)
		FastMarksAce.worldMain.marker["Cross"]:GetNormalTexture():SetTexCoord(0.5,0.75,0.25,0.5)
		FastMarksAce.worldMain.marker["Star"]:GetNormalTexture():SetTexCoord(0,0.25,0,0.25)
		FastMarksAce.worldMain.marker["Circle"]:GetNormalTexture():SetTexCoord(0.25,0.5,0,0.25)
		FastMarksAce.worldMain.marker["Moon"]:GetNormalTexture():SetTexCoord(0,0.25,0.25,0.5)
		FastMarksAce.worldMain.marker["Skull"]:GetNormalTexture():SetTexCoord(0.75,1,0.25,0.5)
	end
end

function FastMarksAce:getLoc(frame, savedVar)
	local point, relativeTo, relPt, xOff, yOff = frame:GetPoint()
	if (relativeTo == nil) then relativeTo = _G["UIParent"] end
	dbFLoc[savedVar or frame:GetName()] = {point, relativeTo:GetName(), relPt, xOff, yOff};
end

function FastMarksAce:setLoc(frame, savedVar)
	if dbFLoc[savedVar or frame:GetName()] then
		frame:ClearAllPoints()
		frame:SetPoint(unpack(dbFLoc[savedVar or frame:GetName()]))
	else
		self:getLoc(frame)
	end
end

-------------------------------------------------------
-- Slash Command Handlers
-------------------------------------------------------

function FastMarksAce:SlashInput(input)
	if not input or input:trim() == "" then
		LibStub("AceConfigDialog-3.0"):Open("FastMarks")
	else
		if (input=="lock") then
			FastMarksAce:raidLockToggle()
			FastMarksAce:worldLockToggle()
		elseif (input=="show") then
			dbRaid.shown=true
			dbWorld.shown=true
			FastMarksAce:updateVisibility()
		elseif (input=="hide") then
			dbRaid.shown=false
			dbWorld.shown=false
			FastMarksAce:updateVisibility()
		elseif (input=="clamp") then
			FastMarksAce:raidClampToggle(); 
			FastMarksAce:worldClampToggle()
		elseif (input=="options") then
			LibStub("AceConfigDialog-3.0"):Open("FastMarks")
		end
	end
end

function FastMarksAce:SlashReadyCheck()
	DoReadyCheck();
end

function FastMarksAce:SlashRoleCheck()
	InitiateRolePoll();
end

-------------------------------------------------------
-- Event Handler
-------------------------------------------------------

function FastMarksAce:EventHandler(event, arg1, arg2, ...)

	if (event=="GROUP_ROSTER_UPDATE") or (event=="RAID_ROSTER_UPDATE") or (event=="PLAYER_TARGET_CHANGED") then
		FastMarksAce:updateVisibility()
	elseif (event=="PLAYER_REGEN_ENABLED") then
		-- Based on Shadowed's Out of Combat function queue
		for func, handler in pairs(FastMarks_queuedFuncs) do
			if (type(handler)=="table") then
				handler[func](handler);
			elseif (type(func)=="string") then
				_G[func]();
			else
				func();
			end
		end
		
		for func in pairs(FastMarks_queuedFuncs) do
			FastMarks_queuedFuncs[func] = nil;
		end

	end

end
