local _G = _G
local hooksecurefunc = hooksecurefunc
local pairs = pairs
local string = string
local table = table
local tinsert = tinsert
local type = type
local pcall = pcall

local GetCVar = GetCVar
local GetCVarBool = GetCVarBool
local GetNumGroupMembers = GetNumGroupMembers
local InCombatLockdown = InCombatLockdown
local IsInGroup = IsInGroup
local IsShiftKeyDown = IsShiftKeyDown
local UnitAura = UnitAura

local UIParent = UIParent

local MovAny = _G.MovAny

local HidenFrame = CreateFrame("Frame", "HidenFrame", UIParent)
HidenFrame.frameinfo = { }
HidenFrame:Hide()

local function ScaleChildren(self, scale)
	if self.attachedChildren then
		for i, child in pairs(self.attachedChildren) do
			child:SetScale(scale)
		end
	end
end

local function AlphaChildren(self, alpha)
	if self.attachedChildren then
		for i, child in pairs(self.attachedChildren) do
			child:SetAlpha(alpha)
		end
	end
end

local function ResetChildren(self, readOnly)
	if not readOnly then
		ScaleChildren(self, 1)
		AlphaChildren(self, 1)
	end
end

MovAny.lVirtualMovers = {
	UIPanelMover1 = {
		w = 384,
		h = 512,
		point = {"TOPLEFT", "UIParent", "TOPLEFT", 0, -104},
		OnMAAttach = MovAny.SyncUIPanels,
		OnMAPosition = MovAny.SyncUIPanels,
		OnMAAlpha = MovAny.SyncUIPanels,
		OnMAScale = MovAny.SyncUIPanels
	},
	UIPanelMover2 = {
		w = 384,
		h = 512,
		point = {"TOPLEFT", "UIParent", "TOPLEFT", 384, -104},
		OnMAAttach = MovAny.SyncUIPanels,
		OnMAPosition = MovAny.SyncUIPanels,
		OnMAAlpha = MovAny.SyncUIPanels,
		OnMAScale = MovAny.SyncUIPanels
	},
	UIPanelMover3 = {
		w = 384,
		h = 512,
		point = {"TOPLEFT", "UIParent", "TOPLEFT", 772, -104},
		OnMAAttach = MovAny.SyncUIPanels,
		OnMAPosition = MovAny.SyncUIPanels,
		OnMAAlpha = MovAny.SyncUIPanels,
		OnMAScale = MovAny.SyncUIPanels
	},
	TooltipMover = {
		frameStrata = "TOOLTIP",
		w = 150,
		h = 80,
		point = {"TOP", "UIParent", 0, 0},
		OnShow = function(self)
			self:SetFrameLevel(GameTooltip:GetFrameLevel() + 1)
		end,
		--[[OnMAPostHook = function(self)
			--MovAny:HookTooltip(self)
		end,
		OnMAPosition = function(self)
			--MovAny:HookTooltip(self)
		end,]]
		OnMAPreReset = function(self)
			local f = _G.GameTooltip
			self.MAE:Reset(f, true)
			f.MAHidden = nil
		end
	},
	WatchFrameMover = {
		w = 235,
		h = 700,
		point = {"TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -10, 0},
		OnMAHook = function(self)
			local b = WatchFrame
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", self, "TOPRIGHT")
			MovAny:LockPoint(b)
			--b.ignoreFramePositionManager = true
			--b:SetMovable(true)
			b:SetHeight(self:GetHeight())
			--b:SetUserPlaced(true)
			self.sbf = b
			_G["InterfaceOptionsObjectivesPanelWatchFrameWidth"]:SetEnabled(false)
		end,
		OnMAPostReset = function(self)
			local b = WatchFrame
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -10, 0)
		--	b:SetHeight(700)
			WatchFrame_SetWidth(GetCVar("watchFrameWidth"))
			_G["InterfaceOptionsObjectivesPanelWatchFrameWidth"]:SetEnabled(true)
			UIParent_ManageFramePositions()
		end,
		OnMAScale = function(self)
			local b = WatchFrame
			local scaleS = self:GetScale()
			local scaleH = self:GetHeight()
			local scaleW = self:GetWidth()
			if scaleH * scaleS < 150 then
				scaleH = 150
			end
			if scaleW * scaleS < 150 then
				scaleW = 150
			end
			b:SetHeight(scaleH)
			b:SetWidth(scaleW)
			if GetCVar("watchFrameWidth") ~= "0" then
				if not InCombatLockdown() then
					SetCVar("watchFrameWidth", 0)
				end
			end
			WATCHFRAME_EXPANDEDWIDTH = scaleW
			WATCHFRAME_MAXLINEWIDTH = scaleW
			WatchFrame_Update()
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				MovAny:LockVisibility(_G["WatchFrame"])
			else
				MovAny:UnlockVisibility(_G["WatchFrame"])
			end
		end
	},
	ObjectiveTrackerFrameMover = {
		w = 235,
		h = 700,
		point = {"TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -10, 0},
		OnMAHook = function(self)
			local b = ObjectiveTrackerFrame or QuestWatchFrame
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", self, "TOPRIGHT")
			MovAny:LockPoint(b)
			--b.ignoreFramePositionManager = true
			b:SetMovable(true)
			b:SetHeight(self:GetHeight())
			b:SetUserPlaced(true)
			--self.sbf = b
		end,
		OnMAPostReset = function(self)
			local b = ObjectiveTrackerFrame or QuestWatchFrame
			MovAny:UnlockPoint(b)
			--b:ClearAllPoints()
			--b:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -10, 0)
			--b:SetHeight(b:GetTop() - 85)
			UIParent_ManageFramePositions()
		end,
		OnMAScale = function(self)
			local b = ObjectiveTrackerFrame or QuestWatchFrame
			local scaleS = self:GetScale()
			local scaleH = self:GetHeight()
			local scaleW = self:GetWidth()
			b:SetHeight(scaleH)
			b:SetWidth(scaleW)
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				MovAny:LockVisibility(WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and _G["ObjectiveTrackerFrame"] or _G["QuestWatchFrame"])
			else
				MovAny:UnlockVisibility(WOW_PROJECT_ID ~= WOW_PROJECT_CLASSIC and _G["ObjectiveTrackerFrame"] or _G["QuestWatchFrame"])
			end
		end
	},
	ObjectiveTrackerFrameScaleMover = {
		w = 235,
		h = 700,
		point = {"TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -10, 0},
		OnMAHook = function(self)
			local b = ObjectiveTrackerFrame or QuestWatchFrame
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", self, "TOPRIGHT")
			MovAny:LockPoint(b)
			--b.ignoreFramePositionManager = true
			b:SetMovable(true)
			b:SetHeight(self:GetHeight())
			b:SetUserPlaced(true)
			--self.sbf = b
		end,
		OnMAPostReset = function(self)
			local b = ObjectiveTrackerFrame or QuestWatchFrame
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			--b:SetPoint("TOPRIGHT", "MinimapCluster", "BOTTOMRIGHT", -10, 0)
			--b:SetHeight(b:GetTop() - 85)
			UIParent_ManageFramePositions()
		end,
		OnMAScale = function(self)
			local b = ObjectiveTrackerFrame or QuestWatchFrame
			local scaleS = self:GetScale()
			b:SetScale(scaleS)
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				MovAny:LockVisibility(_G["ObjectiveTrackerFrame"] or _G["QuestWatchFrame"])
			else
				MovAny:UnlockVisibility(_G["ObjectiveTrackerFrame"] or _G["QuestWatchFrame"])
			end
		end
	},
	BagItemTooltipMover = {
		frameStrata = "TOOLTIP",
		w = 150,
		h = 80,
		point = {"TOP", "UIParent", 0, 0},
		OnLoad = function(self)
			self:SetFrameLevel(GameTooltip:GetFrameLevel() + 1)
		end,
		OnMAPreReset = function(self)
			local f = _G.GameTooltip
			self.MAE:Reset(f, true)
			f.MAHidden = nil
		end
	},
	BagButtonsMover = {
		w = 170,
		h = 40,
		relPoint = {"BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -4, 6},
		excludes = "BagButtonsVerticalMover",
		children = {
			"MainMenuBarBackpackButton",
			"CharacterBag0Slot",
			"CharacterBag1Slot",
			"CharacterBag2Slot",
			"CharacterBag3Slot"
		},
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("RIGHT", self, "RIGHT", 0, 0)
			else
				child:SetPoint("RIGHT", self.lastChild, "LEFT", -2, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -4, 6)
			else
				child:SetPoint("RIGHT", self.lastChild, "LEFT", -2, 0)
			end
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	BagButtonsVerticalMover = {
		w = 40,
		h = 170,
		relPoint = {"BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -4, 6},
		excludes = "BagButtonsMover",
		notMAParent = true,
		children = {
			"MainMenuBarBackpackButton",
			"CharacterBag0Slot",
			"CharacterBag1Slot",
			"CharacterBag2Slot",
			"CharacterBag3Slot"
		},
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOM", self, "BOTTOM", 0, 0)
			else
				child:SetPoint("BOTTOM", self.lastChild, "TOP", 0, 2)
			end
			child.MAParent = self
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOMRIGHT", "MainMenuBarArtFrame", "BOTTOMRIGHT", -4, 6)
			else
				child:SetPoint("RIGHT", self.lastChild, "LEFT", -2, 0)
			end
			child.MAParent = "BagButtonsMover"
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	BagFrame1 = {
		inherits = "MovableBagFrame",
		id = 0,
	},
	BagFrame2 = {
		inherits = "MovableBagFrame",
		id = 1,
	},
	BagFrame3 = {
		inherits = "MovableBagFrame",
		id = 2,
	},
	BagFrame4 = {
		inherits = "MovableBagFrame",
		id = 3,
	},
	BagFrame5 = {
		inherits = "MovableBagFrame",
		id = 4,
	},
	BankBagItemsMover = {
		w = 331,
		h = 169,
		relPoint = {"TOPLEFT", "BankFrame", "TOPLEFT", 28, - 75},
		children = {
			"BankFrameItem1",
			"BankFrameItem2",
			"BankFrameItem3",
			"BankFrameItem4",
			"BankFrameItem5",
			"BankFrameItem6",
			"BankFrameItem7",
			"BankFrameItem8",
			"BankFrameItem9",
			"BankFrameItem10",
			"BankFrameItem11",
			"BankFrameItem12",
			"BankFrameItem13",
			"BankFrameItem14",
			"BankFrameItem15",
			"BankFrameItem16",
			"BankFrameItem17",
			"BankFrameItem18",
			"BankFrameItem19",
			"BankFrameItem20",
			"BankFrameItem21",
			"BankFrameItem22",
			"BankFrameItem23",
			"BankFrameItem24",
			"BankFrameItem25",
			"BankFrameItem26",
			"BankFrameItem27",
			"BankFrameItem28"
		},
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			elseif child == BankFrameItem8 then
				child:SetPoint("TOPLEFT", "BankFrameItem1", "BOTTOMLEFT", 0, - 7)
			elseif child == BankFrameItem15 then
				child:SetPoint("TOPLEFT", "BankFrameItem8", "BOTTOMLEFT", 0, - 7)
			elseif child == BankFrameItem22 then
				child:SetPoint("TOPLEFT", "BankFrameItem15", "BOTTOMLEFT", 0, - 7)
			else
				child:SetPoint("TOPLEFT", self.lastChild, "TOPRIGHT", 12, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("TOPLEFT", "BankFrame", "TOPLEFT", 28, - 75)
			elseif child == BankFrameItem8 then
				child:SetPoint("TOPLEFT", "BankFrameItem1", "BOTTOMLEFT", 0, - 7)
			elseif child == BankFrameItem15 then
				child:SetPoint("TOPLEFT", "BankFrameItem8", "BOTTOMLEFT", 0, - 7)
			elseif child == BankFrameItem22 then
				child:SetPoint("TOPLEFT", "BankFrameItem15", "BOTTOMLEFT", 0, - 7)
			else
				child:SetPoint("TOPLEFT", self.lastChild, "TOPRIGHT", 12, 0)
			end
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	BankBagSlotsMover = {
		w = 331,
		h = 37,
		relPoint = {"TOPLEFT", "BankFrameItem1", "BOTTOMLEFT", 0, - 164},
		OnMAHook = function(self)
			local b = _G.BankSlotsFrame.Bag1
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("LEFT", self, "LEFT", 0, 0)
			b:SetMovable(true)
			b:SetUserPlaced(true)
		end,
		OnMAPostReset = function(self)
			MovAny:UnlockPoint(ActionButton1)
			local b = _G.BankSlotsFrame.Bag1
			b:SetPoint("TOPLEFT", "BankFrameItem1", "BOTTOMLEFT", 0, - 164)
			b:SetMovable(true)
			b:SetUserPlaced(false)
			b:SetMovable(false)
		end,
		OnMAScale = function(self, scale)
			if type(scale) ~= "number" then
				return
			end
			local children = {
				BankSlotsFrame.Bag1,
				BankSlotsFrame.Bag2,
				BankSlotsFrame.Bag3,
				BankSlotsFrame.Bag4,
				BankSlotsFrame.Bag5,
				BankSlotsFrame.Bag6,
				BankSlotsFrame.Bag7
			}
			for i = 1, #children do
				local b = children[i]
				b:SetScale(scale)
			end
		end
		--[[OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("LEFT", self, "LEFT", 0, 0)
			else
				child:SetPoint("TOPLEFT", self.lastChild, "TOPRIGHT", 12, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("TOPLEFT", "BankFrameItem1", "BOTTOMLEFT", 0, - 164)
			else
				child:SetPoint("TOPLEFT", self.lastChild, "TOPRIGHT", 12, 0)
			end
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren]]
	},
	BankBagFrame1 = {
		inherits = "MovableBagFrame",
		id = 5,
	},
	BankBagFrame2 = {
		inherits = "MovableBagFrame",
		id = 6,
	},
	BankBagFrame3 = {
		inherits = "MovableBagFrame",
		id = 7,
	},
	BankBagFrame4 = {
		inherits = "MovableBagFrame",
		id = 8,
	},
	BankBagFrame5 = {
		inherits = "MovableBagFrame",
		id = 9,
	},
	BankBagFrame6 = {
		inherits = "MovableBagFrame",
		id = 10,
	},
	BankBagFrame7 = {
		inherits = "MovableBagFrame",
		id = 11,
	},
	KeyRingFrame = {
		inherits = "MovableBagFrame",
		id = -2,
	},
	MicroButtonsMover = {
		w = 303,
		h = 37,
		relPoint = {"BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 550, 2},
		excludes = "MicroButtonsSplitMover",
		excludes2 = "MicroButtonsVerticalMover",
		children = {
			"CharacterMicroButton",
			"SpellbookMicroButton",
			"TalentMicroButton",
			"AchievementMicroButton",
			"QuestLogMicroButton",
			"SocialsMicroButton",
			"GuildMicroButton",
			"LFDMicroButton",
			"CollectionsMicroButton",
			"EncounterJournalMicroButton",
			"StoreMicroButton",
			"MainMenuMicroButton"
		},
		OnMAFoundChild = function(self, index, child)
			if child == self.firstChild then
				child:ClearAllPoints()
				child:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 550, 2)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", -3, 0)
			end
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	MicroButtonsSplitMover = {
		w = 154,
		h = 74,
		relPoint = {"BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 550, 2},
		excludes = "MicroButtonsMover",
		excludes2 = "MicroButtonsVerticalMover",
		notMAParent = true,
		children = {
			"CharacterMicroButton",
			"SpellbookMicroButton",
			"TalentMicroButton",
			"AchievementMicroButton",
			"QuestLogMicroButton",
			"SocialsMicroButton",
			"GuildMicroButton",
			"LFDMicroButton",
			"CollectionsMicroButton",
			"EncounterJournalMicroButton",
			"StoreMicroButton",
			"MainMenuMicroButton"
		},
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 20)
			elseif child == PVPMicroButton then
				child:SetPoint("TOP", CharacterMicroButton, "BOTTOM", 0, 24)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", -3, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child.MAParent = "MicroButtonsMover"
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 550, 2)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", -3, 0)
			end
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	MicroButtonsVerticalMover = {
		w = 29,
		h = 413,
		relPoint = {"BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 550, 2},
		excludes = "MicroButtonsMover",
		excludes2 = "MicroButtonsSplitMover",
		notMAParent = true,
		children = {
			"CharacterMicroButton",
			"SpellbookMicroButton",
			"TalentMicroButton",
			"AchievementMicroButton",
			"QuestLogMicroButton",
			"SocialsMicroButton",
			"GuildMicroButton",
			"LFDMicroButton",
			"CollectionsMicroButton",
			"EncounterJournalMicroButton",
			"StoreMicroButton",
			"MainMenuMicroButton"
		},
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("TOP", self, "TOP", 0, 20)
			else
				child:SetPoint("TOP", self.lastChild, "BOTTOM", 0, 24)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child.MAParent = "MicroButtonsMover"
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 550, 2)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", -3, 0)
			end
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	BasicActionButtonsMover = {
		w = 498,
		h = 38,
		relPoint = {"BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 3},
		protected = true,
		excludes = "BasicActionButtonsVerticalMover",
		prefix = "ActionButton",
		count = 12,
		--[[
		prefix1 = "BonusActionButton",
		OnMAFoundChild = function(self, index, child, prefix)
			child:ClearAllPoints()
			if prefix == 0 then
				if index == 1 then
					child:SetPoint("LEFT", self, "LEFT")
				else
					child:SetPoint("LEFT", self.lastChild, "RIGHT", 6, 0)
				end
			else
				child:SetPoint("CENTER", self.prefix..index, "CENTER")
			end
		end,
		OnMAReleaseChild = function(self, index, child, prefix)
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 546, 2)
			else
				child:SetPoint("BOTTOMLEFT", prefix, "BOTTOMRIGHT", -2, 0)
			end
		end,
		]]
		OnMAHook = function(self)
			local b, bab
			ActionButton1:ClearAllPoints()
			if ActionButton1.MASetPoint then
				ActionButton1:MASetPoint("LEFT", self, "LEFT")
			else
				ActionButton1:SetPoint("LEFT", self, "LEFT")
			end
			BonusActionButton1:ClearAllPoints()
			if BonusActionButton1.MASetPoint then
				BonusActionButton1:MASetPoint("LEFT", self, "LEFT")
			else
				BonusActionButton1:SetPoint("LEFT", self, "LEFT")
			end
			ActionBarUpButton:ClearAllPoints()
			ActionBarUpButton:SetPoint("TOPLEFT", "ActionButton12", "TOPRIGHT", 0, 7)
			ActionBarDownButton:ClearAllPoints()
			ActionBarDownButton:SetPoint("BOTTOMLEFT", "ActionButton12", "BOTTOMRIGHT", 0, -9)
			for i = 1, 12, 1 do
				b = _G["ActionButton"..i]
				bab = _G["BonusActionButton"..i]
				if i > 1 then
					b:ClearAllPoints()
					b:SetPoint("LEFT", "ActionButton"..(i - 1), "RIGHT", 6, 0)
					bab:ClearAllPoints()
					bab:SetPoint("CENTER", b, "CENTER")
				end
				b.MAParent = self
				bab.MAParent = self
				tinsert(self.attachedChildren, bab)
			end
			if not MovAny:IsModified("ActionBarUpButton") then
				tinsert(self.attachedChildren, ActionBarUpButton)
			end
			if not MovAny:IsModified("ActionBarDownButton") then
				tinsert(self.attachedChildren, ActionBarDownButton)
			end
			MovAny:LockPoint(ActionButton1)
			MovAny:LockPoint(BonusActionButton1)
		end,
		OnMAPostReset = function(self)
			MovAny:UnlockPoint(ActionButton1)
			MovAny:UnlockPoint(BonusActionButton1)
			local b, pb = _G["ActionButton1"], bab
			b:ClearAllPoints()
			if b.MASetPoint then
				b:MASetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			else
				b:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			end
			pb = b
			b = _G["BonusActionButton1"]
			b:ClearAllPoints()
			if b.MASetPoint then
				b:MASetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			else
				b:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			end
			ActionBarUpButton:ClearAllPoints()
			ActionBarUpButton:SetPoint("CENTER", "MainMenuBarArtFrame", "TOPLEFT", 522, -22)
			ActionBarDownButton:ClearAllPoints()
			ActionBarDownButton:SetPoint("CENTER", "MainMenuBarArtFrame", "TOPLEFT", 522, -42)
			for i = 2, 12, 1 do
				b = _G[ "ActionButton"..i ]
				bab = _G["BonusActionButton"..i]
				b:ClearAllPoints()
				b:SetPoint("LEFT", pb, "RIGHT", 6, 0)
				bab:ClearAllPoints()
				bab:SetPoint("CENTER", b, "CENTER")
				pb = b
			end
		end,
	},
	BasicActionButtonsVerticalMover = {
		w = 38,
		h = 475,
		relPoint = {"BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4},
		protected = true,
		excludes = "BasicActionButtonsMover",
		OnMAHook = function(self)
			local b, pb
			b = _G["ActionButton1"]
			b:ClearAllPoints()
			if b.MASetPoint then
				b:MASetPoint("TOP", self, "TOP")
			else
				b:SetPoint("TOP", self, "TOP")
			end
			pb = b
			b = _G["BonusActionButton1"]
			b:ClearAllPoints()
			if b.MASetPoint then
				b:MASetPoint("TOP", self, "TOP")
			else
				b:SetPoint("TOP", self, "TOP")
			end
			for i = 1, 12, 1 do
				b = _G[ "ActionButton"..i ]
				tinsert(self.attachedChildren, _G[ "ActionButton"..i ])
				tinsert(self.attachedChildren, _G[ "BonusActionButton"..i ])
				if i > 1 then
					b:ClearAllPoints()
					b:SetPoint("TOP", pb, "BOTTOM", 0, -2)
				end
				b.MAParent = self
				pb = b
				--_G[ "BonusActionButton"..i ]:ClearAllPoints()
				--_G[ "BonusActionButton"..i ]:SetPoint("CENTER", b, "CENTER")
			end
			tinsert(self.attachedChildren, ActionBarUpButton)
			tinsert(self.attachedChildren, ActionBarDownButton)
			ActionBarUpButton:ClearAllPoints()
			ActionBarUpButton:SetPoint("TOPLEFT", "ActionButton12", "BOTTOMLEFT", -8, 4)
			ActionBarDownButton:ClearAllPoints()
			ActionBarDownButton:SetPoint("TOPRIGHT", "ActionButton12", "BOTTOMRIGHT", 8, 4)
		end,
		OnMAPostReset = function(self)
			local b, pb
			b = _G["ActionButton1"]
			b:ClearAllPoints()
			if b.MASetPoint then
				b:MASetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			else
				b:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			end
			pb = b
			b = _G["BonusActionButton1"]
			b:ClearAllPoints()
			if b.MASetPoint then
				b:MASetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			else
				b:SetPoint("BOTTOMLEFT", "MainMenuBarArtFrame", "BOTTOMLEFT", 8, 4)
			end
			ActionBarUpButton:ClearAllPoints()
			ActionBarUpButton:SetPoint("CENTER", "MainMenuBarArtFrame", "TOPLEFT", 522, -22)
			ActionBarDownButton:ClearAllPoints()
			ActionBarDownButton:SetPoint("CENTER", "MainMenuBarArtFrame", "TOPLEFT", 522, -42)
			for i = 2, 12, 1 do
				b = _G[ "ActionButton"..i ]
				b.MAParent = BasicActionButtonsMover
				b:ClearAllPoints()
				b:SetPoint("LEFT", pb, "RIGHT", 6, 0)
				--bab = _G[ "BonusActionButton"..i ]
				--bab:ClearAllPoints()
				--bab:SetPoint("CENTER", b, "CENTER")
				pb = b
			end
		end,
	},
	PetActionButtonsMover = {
		w = 375,
		h = 36,
		point = {"CENTER", "UIParent", "CENTER", 0, 0},
		excludes = "PetActionButtonsVerticalMover",
		protected = true,
		prefix = "PetActionButton",
		count = 10,
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			child.MAParent = self
			if index == 1 then
				child:SetPoint("LEFT", self, "LEFT", 0, 0)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", 8, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			child.MAParent = self
			if index == 1 then
				child:SetPoint("BOTTOMLEFT", "PetActionBarFrame", "BOTTOMLEFT", 36, 2)
				child.SetParent = self
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", 8, 0)
				child.SetParent = self
			end
		end,
		OnMAScale = function(self, scale)
			if type(scale) ~= "number" then
				return
			end
			--[[for i = 1, 10 do
				_G["PetActionButton"..i]:SetScale(scale)
			end]]
			PetActionBarFrame:SetScale(scale)
		end,
		OnMAPostReset = function(self)
			--[[for i = 1, 10 do
				_G["PetActionButton"..i]:SetScale(1)
				self:SetScale(1)
			end]]
			PetActionBarFrame:SetScale(1)
			if not PetHasActionBar() then
				RegisterStateDriver(PetActionBarFrame, "visibility", "hide")
				UnregisterStateDriver(PetActionBarFrame, "visibility")
			end
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				HidenFrame.frameinfo["PetActionBarFrame"] = PetActionBarFrame:GetParent()
				PetActionBarFrame:SetParent("HidenFrame")
				PetActionBarFrame:Hide()
				PetActionBarFrame:UnregisterAllEvents()
			else
				if HidenFrame.frameinfo["PetActionBarFrame"] then
					PetActionBarFrame:SetParent(HidenFrame.frameinfo["PetActionBarFrame"])
				end
				PetActionBarFrame:Show()
			end
		end
	},
	PetActionButtonsVerticalMover = {
		w = 36,
		h = 375,
		point = {"BOTTOMLEFT", "PetActionBarFrame", "BOTTOMLEFT", 36, 1},
		excludes = "PetActionButtonsMover",
		notMAParent = true,
		protected = true,
		prefix = "PetActionButton",
		count = 10,
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			child.MAParent = self
			if index == 1 then
				child:SetPoint("TOP", self, "TOP", 0, 0)
			else
				child:SetPoint("TOP", self.lastChild, "BOTTOM", 0, -8)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			child.MAParent = "PetActionButtonsMover"
			if index == 1 then
				child:SetPoint("BOTTOMLEFT", "PetActionBarFrame", "BOTTOMLEFT", 36, 1)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", 8, 0)
			end
		end,
		OnMAScale = function(self, scale)
			if type(scale) ~= "number" then
				return
			end
			for i = 1, 10 do
				_G["PetActionButton"..i]:SetScale(scale)
			end
		end,
		OnMAPostReset = function(self)
			for i = 1, 10 do
				_G["PetActionButton"..i]:SetScale(1)
				self:SetScale(1)
			end
		end
	},
	ExtraActionBarFrameMover = {
		w = 52,
		h = 52,
		point = {"BOTTOM", "MainMenuBar", 0, 160},
		protected = true,
		dontLock = true,
		prefix = "ExtraActionButton",
		count = 1,
		OnMAHook = function(self)
			local b = _G.ExtraActionBarFrame
			b:DisableDrawLayer("BACKGROUND")
			b:DisableDrawLayer("BORDER")
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("BOTTOMLEFT", ExtraActionBarFrameMover, "BOTTOMLEFT", 0, 0)
			MovAny:LockPoint(b)
			b.ignoreFramePositionManager = true
			b:SetMovable(true)
			b:SetUserPlaced(true)
			self.sbf = b
		end,
		OnMAPreReset = function(self)
			local b = self.sbf
			MovAny:UnlockPoint(b)
			b:SetPoint("BOTTOM", _G.MainMenuBar, 0, 160)
			b:EnableDrawLayer("BACKGROUND")
			b:EnableDrawLayer("BORDER")
			b.ignoreFramePositionManager = nil
			b:SetUserPlaced(nil)
			b:SetMovable(nil)
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				MovAny:LockVisibility(self.sbf)
			else
				MovAny:UnlockVisibility(self.sbf)
			end
		end
	},
	ShapeshiftButtonsMover = {
		w = 225,
		h = 32,
		point = {"BOTTOMLEFT", "MainMenuBar", "TOPLEFT", 30, 0},
		excludes = "ShapeshiftButtonsVerticalMover",
		protected = true,
		prefix = "ShapeshiftButton",
		count = 10,
		dontLock = true,
		OnMAHook = function(self)
			local b = _G.ShapeshiftBarFrame
			b:DisableDrawLayer("BACKGROUND")
			b:DisableDrawLayer("BORDER")
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 0, 0)
			MovAny:LockPoint(b)
			b.ignoreFramePositionManager = true
			b:SetMovable(true)
			b:SetUserPlaced(true)
			self.sbf = b
		end,
		OnMAScale = function(self, scale)
			if type(scale) ~= "number" then
				return
			end
			if self.attachedChildren then
				for i, child in pairs(self.attachedChildren) do
					child:SetScale(scale)
				end
			end
		end,
		OnMAPreReset = function(self)
			local b = self.sbf
			MovAny:UnlockPoint(b)
			b:SetPoint("BOTTOMLEFT", _G.MainMenuBar, "TOPLEFT", 30, -5)
			b:EnableDrawLayer("BACKGROUND")
			b:EnableDrawLayer("BORDER")
			b.ignoreFramePositionManager = nil
			b:SetUserPlaced(nil)
			b:SetMovable(nil)
			for i, v in pairs(self.attachedChildren) do
				MovAny:UnlockScale(v)
				v:SetScale(1)
			end
			if GetNumShapeshiftForms() == 0 then
				RegisterStateDriver(ShapeshiftBarFrame, "visibility", "hide")
				UnregisterStateDriver(ShapeshiftBarFrame, "visibility")
			end
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				MovAny:LockVisibility(self.sbf)
				RegisterStateDriver(ShapeshiftBarFrame, "visibility", "hide")
			else
				MovAny:UnlockVisibility(self.sbf)
				RegisterStateDriver(ShapeshiftBarFrame, "visibility", "show")
			end
		end
	},
	ShapeshiftButtonsVerticalMover = {
		w = 32,
		h = 225,
		point = {"BOTTOMLEFT", "ShapeshiftBarFrame", "BOTTOMLEFT", 11, 3},
		excludes = "ShapeshiftButtonsMover",
		notMAParent = true,
		protected = true,
		prefix = "ShapeshiftButton",
		count = 10,
		OnMAHook = function(self)
			local b = _G.ShapeshiftBarFrame
			b:DisableDrawLayer("BACKGROUND")
			b:DisableDrawLayer("BORDER")
			b.ignoreFramePositionManager = true
			b:SetMovable(true)
			b:SetUserPlaced(true)
			self.sbf = b
		end,
		OnMAPostReset = function(self)
			local b = self.sbf
			b:EnableDrawLayer("BACKGROUND")
			b:EnableDrawLayer("BORDER")
			b.ignoreFramePositionManager = nil
			if self.sbf:IsUserPlaced() then
				self.sbf:SetUserPlaced(nil)
			end
			if self.sbf:IsMovable() then
				self.sbf:SetMovable(nil)
			end
		end,
		OnMAScale = function(self, scale)
			if type(scale) ~= "number" then
				return
			end
			if self.attachedChildren then
				for i, child in pairs(self.attachedChildren) do
					child:SetScale(scale)
				end
			end
		end,
		OnMAFoundChild = function(self, index, child)
			child.MAParent = self
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("TOP", self, "TOP", 0, -7)
			else
				child:SetPoint("TOP", self.lastChild, "BOTTOM", 0, -7)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child.MAParent = "ShapeshiftButtonsMover"
			child:ClearAllPoints()
			if child == self.firstChild then
				child:SetPoint("BOTTOMLEFT", self.sbf, "BOTTOMLEFT", 11, 3)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", 8, 0)
			end
			for i, v in pairs(self.attachedChildren) do
				MovAny:UnlockScale(v)
				v:SetScale(1)
			end
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				MovAny:LockVisibility(self.sbf)
				RegisterStateDriver(ShapeshiftBarFrame, "visibility", "hide")
			else
				MovAny:UnlockVisibility(self.sbf)
				RegisterStateDriver(ShapeshiftBarFrame, "visibility", "show")
			end
		end
	},
	MultiBarRightHorizontalMover = {
		w = 498,
		h = 38,
		point = {"BOTTOM", "UIParent", "BOTTOM", 0, 250},
		excludes = "MultiBarRight",
		notMAParent = true,
		protected = true,
		prefix = "MultiBarRightButton",
		count = 12,
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if index == 1 then
				child:SetPoint("TOPLEFT", self)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", 6, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			if index == 1 then
				child:SetPoint("TOPRIGHT", "MultiBarRight")
			else
				child:SetPoint("TOP", self.lastChild, "BOTTOM", 0, -6)
			end
			child.MAParent = nil
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	MultiBarLeftHorizontalMover = {
		w = 498,
		h = 38,
		point = {"BOTTOM", "UIParent", "BOTTOM", 0, 285},
		excludes = "MultiBarLeft",
		notMAParent = true,
		protected = true,
		prefix = "MultiBarLeftButton",
		count = 12,
		OnMAFoundChild = function(self, index, child)
			child:ClearAllPoints()
			if index == 1 then
				child:SetPoint("TOPLEFT", self)
			else
				child:SetPoint("LEFT", self.lastChild, "RIGHT", 6, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			child:ClearAllPoints()
			if index == 1 then
				child:SetPoint("TOPRIGHT", "MultiBarLeft")
			else
				child:SetPoint("TOP", self.lastChild, "BOTTOM", 0, -6)
			end
			child.MAParent = nil
		end,
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	PartyMember1DebuffsMover = {
		w = 66,
		h = 15,
		point = {"TOPLEFT", "PartyMemberFrame1", "TOPLEFT", 48, -32},
		prefix = "PartyMemberFrame1Debuff",
		count = MAX_PARTY_DEBUFFS,
		dontLock = true,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self)
				MovAny:LockPoint(child)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				MovAny:UnlockPoint(child)
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "PartyMemberFrame1", 48, -32)
			end
		end,
		OnMAHook = function(self)
			self:SetScale(_G["PartyMemberFrame1"]:GetEffectiveScale() / UIParent:GetScale())
		end
	},
	PartyMember2DebuffsMover = {
		w = 66,
		h = 15,
		point = {"TOPLEFT", "PartyMemberFrame2", "TOPLEFT", 48, -32},
		prefix = "PartyMemberFrame2Debuff",
		count = MAX_PARTY_DEBUFFS,
		dontLock = true,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self)
				MovAny:LockPoint(child)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				MovAny:UnlockPoint(child)
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "PartyMemberFrame2", 48, -32)
			end
		end,
		OnMAHook = function(self)
			self:SetScale(_G["PartyMemberFrame2"]:GetEffectiveScale() / UIParent:GetScale())
		end
	},
	PartyMember3DebuffsMover = {
		w = 66,
		h = 15,
		point = {"TOPLEFT", "PartyMemberFrame3", "TOPLEFT", 48, -32},
		prefix = "PartyMemberFrame3Debuff",
		count = MAX_PARTY_DEBUFFS,
		dontLock = true,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self)
				MovAny:LockPoint(child)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				MovAny:UnlockPoint(child)
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "PartyMemberFrame3", 48, -32)
			end
		end,
		OnMAHook = function(self)
			self:SetScale(_G["PartyMemberFrame3"]:GetEffectiveScale() / UIParent:GetScale())
		end
	},
	PartyMember4DebuffsMover = {
		w = 66,
		h = 17,
		point = {"TOPLEFT", "PartyMemberFrame4", "TOPLEFT", 48, -32},
		prefix = "PartyMemberFrame4Debuff",
		count = MAX_PARTY_DEBUFFS,
		dontLock = true,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self)
				MovAny:LockPoint(child)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				MovAny:UnlockPoint(child)
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "PartyMemberFrame4", 48, -32)
			end
		end,
		OnMAHook = function(self)
			self:SetScale(_G["PartyMemberFrame4"]:GetEffectiveScale() / UIParent:GetScale())
		end
	},
	PetDebuffsMover = {
		w = 66,
		h = 17,
		point = {"TOPLEFT", "PetFrame", "TOPLEFT", 48, -42},
		prefix = "PetFrameDebuff",
		count = 4,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 1, -1)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "PetFrame", 48, -42)
			end
		end,
		OnMAHook = function(self)
			self:SetScale(_G["PetFrame"]:GetEffectiveScale() / UIParent:GetScale())
		end
	},
	TargetBuffsMover = {
		w = 118,
		h = 21,
		point = {"TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32},
		prefix = "TargetFrameBuff",
		count = MAX_TARGET_BUFFS,
		--dontLock = true,
		OnLoad = function(self)
			if TargetFrame_UpdateAuras then
				hooksecurefunc("TargetFrame_UpdateAuras", function(frame)
					if frame == TargetFrame and self.MAHooked then
						self:MAScanForChildren()
					end
				end)
			end
		end,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				self:SetScale(_G["TargetFrame"]:GetEffectiveScale() / UIParent:GetScale())
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			MovAny:UnlockPoint(child)
			MovAny:UnlockScale(child)
			child:SetScale(1)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32)
			end
		end,
		--[[OnMAHook = function(self)
			MovAny:UnlockScale(self)
			self:SetScale(_G["TargetFrame"]:GetEffectiveScale() / UIParent:GetScale())
			MovAny:LockScale(self)
		end,]]
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	TargetDebuffsMover = {
		w = 118,
		h = 21,
		point = {"TOPLEFT", "TargetFrameBuffs", "BOTTOMLEFT", 0, -6},
		prefix = "TargetFrameDebuff",
		count = MAX_TARGET_DEBUFFS,
		--dontLock = true,
		OnLoad = function(self)
			if TargetFrame_UpdateAuras then
				hooksecurefunc("TargetFrame_UpdateAuras", function(frame)
					if frame == TargetFrame and self.MAHooked then
						self:MAScanForChildren()
					end
				end)
			end
		end,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				self:SetScale(_G["TargetFrame"]:GetEffectiveScale() / UIParent:GetScale())
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			MovAny:UnlockScale(child)
			MovAny:UnlockPoint(child)
			child:SetScale(1)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "TargetFrameBuffs", "BOTTOMLEFT", 0, - 6)
			end
		end,
		--[[OnMAHook = function(self)
			MovAny:UnlockScale(self)
			self:SetScale(_G["TargetFrame"]:GetEffectiveScale() / UIParent:GetScale())
			MovAny:LockScale(self)
		end,]]
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	FocusBuffsMover = {
		w = 118,
		h = 21,
		point = {"TOPLEFT", "FocusFrame", "BOTTOMLEFT", 5, 32},
		prefix = "FocusFrameBuff",
		count = MAX_TARGET_BUFFS,
		--dontLock = true,
		OnLoad = function(self)
			if TargetFrame_UpdateAuras then
				hooksecurefunc("TargetFrame_UpdateAuras", function(frame)
					if frame == FocusFrame and self.MAHooked then
						self:MAScanForChildren()
					end
				end)
			end
		end,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				self:SetScale(_G["TargetFrame"]:GetEffectiveScale() / UIParent:GetScale())
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			MovAny:UnlockScale(child)
			MovAny:UnlockPoint(child)
			child:SetScale(1)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "FocusFrame", "BOTTOMLEFT", 5, 32)
			end
		end,
		--[[OnMAHook = function(self)
			MovAny:UnlockScale(self)
			self:SetScale(_G["FocusFrame"]:GetEffectiveScale() / UIParent:GetScale())
			MovAny:LockScale(self)
		end,]]
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	FocusDebuffsMover = {
		w = 118,
		h = 21,
		point = {"TOPLEFT", "FocusFrameBuffs", "BOTTOMLEFT", 0, -6},
		prefix = "FocusFrameDebuff",
		count = MAX_TARGET_DEBUFFS,
		--dontLock = true,
		OnLoad = function(self)
			if TargetFrame_UpdateAuras then
				hooksecurefunc("TargetFrame_UpdateAuras", function(frame)
					if frame == FocusFrame and self.MAHooked then
						self:MAScanForChildren()
					end
				end)
			end
		end,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				self:SetScale(_G["TargetFrame"]:GetEffectiveScale() / UIParent:GetScale())
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			MovAny:UnlockScale(child)
			MovAny:UnlockPoint(child)
			child:SetScale(1)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "FocusFrameBuffs", "BOTTOMLEFT", 0, - 6)
			end
		end,
		--[[OnMAHook = function(self)
			MovAny:UnlockScale(self)
			self:SetScale(_G["FocusFrame"]:GetEffectiveScale() / UIParent:GetScale())
			MovAny:LockScale(self)
		end,]]
		OnMAScale = ScaleChildren,
		OnMAPreReset = ResetChildren
	},
	TargetFrameToTDebuffsMover = {
		w = 12,
		h = 12,
		point = {"TOPLEFT", "TargetFrameToT", "TOPRIGHT", 4, -10},
		prefix = "TargetFrameToTDebuff",
		count = 4,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", TargetFrameToT, "TOPRIGHT", 4, -10)
			end
			MovAny:UnlockScale(child)
			child:SetScale(_G["TargetFrameToT"]:GetEffectiveScale() / UIParent:GetScale())
		end,
		OnMAHook = function(self)
			self:SetScale(_G["TargetFrameToT"]:GetEffectiveScale() / UIParent:GetScale())
		end,
		OnMAScale = ScaleChildren,
		OnMAPostReset = ResetChildren
	},
	PlayerBuffsMover = {
		w = 30,
		h = 30,
		point = {"TOPRIGHT", "UIParent", "TOPRIGHT", -205, -13},
		children = {"TemporaryEnchantFrame", "ConsolidatedBuffs"},
		prefix = "BuffButton",
		count = 32,
		dontHide = true,
		dontLock = true,
		dontScale = true,
		OnLoad = function(vm)
			if BuffFrame_Update then
				local hBuffFrame_Update = function()
					local opt = vm.opt
					if opt and not opt.disabled and vm.MAE and vm.MAE:IsModified() then
						vm:MAScanForChildren(true, true)
						if opt.scale then
							if not opt.hidden and vm.attachedChildren then
								if GetCVar("consolidateBuffs") == "1" then
									for i, v in pairs(vm.attachedChildren) do
										if v:GetParent():GetName() ~= "ConsolidatedBuffsContainer" then
											v:SetScale(opt.scale)
										else
											v:SetScale(1)
										end
									end
								else
									for i, v in pairs(vm.attachedChildren) do
										v:SetScale(opt.scale)
									end
								end
							end
						end
						MovAny:UnlockPoint(vm.tef)
						vm.tef:ClearAllPoints()
						if BuffFrame.numConsolidated == 0 then
							vm.tef:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPRIGHT", 0, 0)
						else
							vm.tef:SetPoint("TOPRIGHT", ConsolidatedBuffs, "TOPLEFT", -6, 0)
						end
						MovAny:LockPoint(vm.tef)
					end
				end
				local hBuffFrame_ErrorHandler = function()
					--print("Error: "..debugstack(2, 20, 20))
				end
				hooksecurefunc("BuffFrame_Update", function()
					xpcall(hBuffFrame_Update, hBuffFrame_ErrorHandler)
				end)
			end
		end,
		OnMAAlpha = function(self, alpha)
			BuffFrame:SetAlpha(alpha)
		end,
		OnMAScale = function(self, scale)
			if type(scale) ~= "number" then
				return
			end
			if self.attachedChildren then
				if GetCVar("consolidateBuffs") then
					for i, child in pairs(self.attachedChildren) do
						if child:GetParent():GetName() ~= "ConsolidatedBuffsContainer" then
							child:SetScale(scale)
						else
							child:SetScale(1)
						end
					end
				else
					for i, child in pairs(self.attachedChildren) do
						child:SetScale(scale)
					end
				end
			end
		end,
		OnMAHook = function(self)
			local b = _G["BuffFrame"]
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
			MovAny:LockPoint(b)
			b = _G["TemporaryEnchantFrame"]
			MovAny:LockPoint(b)
			self.tef = b
			b = _G["ConsolidatedBuffs"]
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
			MovAny:LockPoint(b)
			if BuffFrame.numConsolidated == 0 then
				b:Hide()
			end
			if self.attachedChildren and self.opt and self.opt.scale then
				if GetCVar("consolidateBuffs") == "1" then
					for i, v in pairs(self.attachedChildren) do
						if v:GetParent():GetName() ~= "ConsolidatedBuffsContainer" then
							v:SetScale(self.opt.scale)
						else
							v:SetScale(1)
						end
					end
				else
					for i, v in pairs(self.attachedChildren) do
						v:SetScale(self.opt.scale)
					end
				end
			end
		end,
		OnMAPreReset = function(self, readOnly)
			if readOnly then
				return true
			end
			MovAny:UnlockPoint(self.tef)
			local b = _G["BuffFrame"]
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -205, -13)
			b = _G["ConsolidatedBuffs"]
			MovAny:UnlockPoint(b)
			b:ClearAllPoints()
			b:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -205, -13)
			for i, v in pairs(self.attachedChildren) do
				MovAny:UnlockScale(v)
				v:SetScale(1)
			end
			self.tef = nil
		end,
		OnMAPostReset = function(self, readOnly)
			if readOnly then
				return true
			end
		end,
		OnMAHide = function(self, hidden)
			if hidden then
				MovAny:LockVisibility(_G["ConsolidatedBuffs"])
				MovAny:LockVisibility(_G["BuffFrame"])
				MovAny:LockVisibility(_G["TemporaryEnchantFrame"])
			else
				MovAny:UnlockVisibility(_G["ConsolidatedBuffs"])
				MovAny:UnlockVisibility(_G["BuffFrame"])
				MovAny:UnlockVisibility(_G["TemporaryEnchantFrame"])
			end
		end
	},
	PlayerDebuffsMover = {
		w = 30,
		h = 30,
		prefix = "DebuffButton",
		count = 16,
		point = {"TOPRIGHT", "ConsolidatedBuffs", "BOTTOMRIGHT", 0, -60},
		OnLoad = function(self)
			if BuffFrame_Update then
				hooksecurefunc("BuffFrame_Update", function()
					if self.MAHooked then
						self:MAScanForChildren()
					end
				end)
			end
		end,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPRIGHT", "ConsolidatedBuffs", "BOTTOMRIGHT", 0, -TempEnchant1:GetHeight() * 3)
			end
			child:SetAlpha(1)
		end,
		OnMAScale = function(self, scale)
			if type(scale) ~= "number" then
				return
			end
			if self.attachedChildren then
				for i, child in pairs(self.attachedChildren) do
					child:SetScale(scale)
				end
			end
		end,
		--[[OnMAHook = function(self)
			self:SetScale(_G["BuffFrame"]:GetEffectiveScale() / UIParent:GetScale())
		end,]]
		OnMAPreReset = function(self, readOnly)
			if readOnly then
				return true
			end
			for i, v in pairs(self.attachedChildren) do
				MovAny:UnlockScale(v)
				v:SetScale(1)
			end
		end
	},
	FocusFrameToTDebuffsMover = {
		w = 12,
		h = 12,
		point = {"TOPLEFT", "FocusFrameToT", "TOPRIGHT", 4, -10},
		prefix = "FocusFrameToTDebuff",
		count = 4,
		OnMAFoundChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", self, 0, 0)
			end
		end,
		OnMAReleaseChild = function(self, index, child)
			if index == 1 then
				child:ClearAllPoints()
				child:SetPoint("TOPLEFT", "FocusFrameToT", "TOPRIGHT", 4, -10)
			end
			MovAny:UnlockScale(child)
			child:SetScale(_G["FocusFrameToT"]:GetEffectiveScale() / UIParent:GetScale())
		end,
		OnMAHook = function(self)
			self:SetScale(_G["FocusFrameToT"]:GetEffectiveScale() / UIParent:GetScale())
		end,
		OnMAScale = ScaleChildren,
		OnMAPostReset = ResetChildren
	},
	RaidUnitFramesMover = {
		linkedSize = "CompactRaidFrameContainer",
		linkedPoint = "CompactRaidFrameContainer",
		children = {"CompactRaidFrameContainer"},
		dontLock = true,
		OnLoad = function(self)
			hooksecurefunc("CompactRaidFrameManager_SetSetting", function(setting, value, skip)
				if skip ~= "MASkip" and setting == "Locked" and IsShiftKeyDown() then
					if not InCombatLockdown() then
						if value then
							MovAny:StopMoving(self:GetName())
						else
							CompactRaidFrameManager_LockContainer(CompactRaidFrameManager)
							if not MovAny:GetMoverByFrame(self:GetName()) then
								MovAny:AttachMover(self:GetName())
							end
						end
					end
				end
			end)
		end,
		OnMAHook = function(self)
			local con = _G["CompactRaidFrameContainer"]
			self.con = con
			MovAny:UnlockPoint(con)
			con:ClearAllPoints()
			con:SetPoint("CENTER", self, "CENTER", 0, 0)
			MovAny:LockPoint(con)
		end,
		OnMAPreReset = function(self)
			if self.con then
				MovAny:UnlockPoint(self.con)
				self.con:SetPoint("TOPLEFT", "CompactRaidFrameManagerContainerResizeFrame", "TOPLEFT", 4, -7)
				self.con = nil
			end
		end,
		OnMADetach = function()
			CompactRaidFrameManager_SetSetting("Locked", "lock", "MASkip")
		end,
		OnMAAttach = function()
			if CompactRaidFrameManager_GetSetting("Locked") == "lock" then
				CompactRaidFrameManager_SetSetting("Locked", "unlock", "MASkip")
				CompactRaidFrameManager_LockContainer(CompactRaidFrameManager)
			end
		end,
		OnMAAlpha = function(self, alpha)
			if self.con then
				if alpha > 0.999 then
					for i = 1, GetNumRaidMembers(), 1 do
						local bg = _G["CompactRaidFrame"..i]
						if bg then
							bg:EnableDrawLayer("BACKGROUND")
							bg:EnableDrawLayer("BORDER")
						end
					end
				else
					for i = 1, GetNumRaidMembers(), 1 do
					local 	bg = _G["CompactRaidFrame"..i]
						if bg then
							bg:DisableDrawLayer("BACKGROUND")
							bg:DisableDrawLayer("BORDER")
						end
					end
				end

				if self.con.groupMode == "discrete" then
					if alpha > 0.999 then
						for i = 1, 8, 1 do
							for j = 1, 5, 1 do
								local bg = _G["CompactRaidGroup"..i.."Member"..j]
								if bg then
									bg:EnableDrawLayer("BACKGROUND")
									bg:EnableDrawLayer("BORDER")
								end
							end
						end
					else
						for i = 1, 8, 1 do
							for j = 1, 5, 1 do
								local bg = _G["CompactRaidGroup"..i.."Member"..j]
								if bg then
									bg:DisableDrawLayer("BACKGROUND")
									bg:DisableDrawLayer("BORDER")
								end
							end
						end
					end
				end
			end
		end
	},
	CompactRaidFrameBuffTooltipsMover = {
		w = 100,
		h = 100,
		point = {"CENTER", "UIParent", "CENTER", 0, 0},
		OnMAHide = function(self, hidden)
			if hidden then
				for i = 1, 40 do
					for k = 1, 3 do
						if _G["CompactRaidFrame"..i.."Buff"..k] then
							_G["CompactRaidFrame"..i.."Buff"..k]:SetScript("OnEnter", function()
								GameTooltip:Hide()
							end)
						end
						if _G["CompactRaidFrame"..i.."Debuff"..k] then
							_G["CompactRaidFrame"..i.."Debuff"..k]:SetScript("OnEnter", function()
								GameTooltip:Hide()
							end)
						end
					end
				end
			else
				for i = 1, 40 do
					for k = 1, 3 do
						if _G["CompactRaidFrame"..i.."Buff"..k] then
							_G["CompactRaidFrame"..i.."Buff"..k]:SetScript("OnEnter", nil)
						end
						if _G["CompactRaidFrame"..i.."Debuff"..k] then
							_G["CompactRaidFrame"..i.."Debuff"..k]:SetScript("OnEnter", nil)
						end
					end
				end
			end
		end,
		OnMAPostReset = function(self)
			for i = 1, 40 do
				for k = 1, 3 do
					if _G["CompactRaidFrame"..i.."Buff"..k] then
						_G["CompactRaidFrame"..i.."Buff"..k]:SetScript("OnEnter", nil)
					end
					if _G["CompactRaidFrame"..i.."Debuff"..k] then
						_G["CompactRaidFrame"..i.."Debuff"..k]:SetScript("OnEnter", nil)
					end
				end
			end
		end
	},
	CompactRaidFrameDebuffTooltipsMover = {
		w = 100,
		h = 100,
		point = {"CENTER", "UIParent", "CENTER", 0, 0},
		OnMAHide = function(self, hidden)
			if hidden then
				for i = 1, 40 do
					for k = 1, 3 do
						if _G["CompactRaidFrame"..i.."Buff"..k] then
							_G["CompactRaidFrame"..i.."Buff"..k]:SetScript("OnEnter", function()
								GameTooltip:Hide()
							end)
						end
						if _G["CompactRaidFrame"..i.."Debuff"..k] then
							_G["CompactRaidFrame"..i.."Debuff"..k]:SetScript("OnEnter", function()
								GameTooltip:Hide()
							end)
						end
					end
				end
			else
				for i = 1, 40 do
					for k = 1, 3 do
						if _G["CompactRaidFrame"..i.."Buff"..k] then
							_G["CompactRaidFrame"..i.."Buff"..k]:SetScript("OnEnter", nil)
						end
						if _G["CompactRaidFrame"..i.."Debuff"..k] then
							_G["CompactRaidFrame"..i.."Debuff"..k]:SetScript("OnEnter", nil)
						end
					end
				end
			end
		end,
		OnMAPostReset = function(self)
			for i = 1, 40 do
				for k = 1, 3 do
					if _G["CompactRaidFrame"..i.."Buff"..k] then
						_G["CompactRaidFrame"..i.."Buff"..k]:SetScript("OnEnter", nil)
					end
					if _G["CompactRaidFrame"..i.."Debuff"..k] then
						_G["CompactRaidFrame"..i.."Debuff"..k]:SetScript("OnEnter", nil)
					end
				end
			end
		end
	},
	--[[RaidUnitFramesManagerMover = {
		linkedSize = "CompactRaidFrameManager",
		point = {"TOPLEFT", "UIParent", "TOPLEFT", -7, -140},
		children = {"CompactRaidFrameManager"},
		dontLock = true,
		OnLoad = function(self)
			local b = CreateFrame("Button", "MACompactRaidFrameManagerToggleButton", UIParent, nil, "MADontHook")
			b:SetSize(16, 64)
			b:SetNormalTexture("Interface\\RaidFrame\\RaidPanel-Toggle")
--			if GetNumRaidMembers() < 1 then
--				b:Hide()
--			end
			local tex = b:GetNormalTexture()
			tex:SetDrawLayer("OVERLAY")
			tex:SetTexCoord(0, .5, 0, 1)
			tex:SetSize(self:GetSize())
			b:SetScript("OnMouseDown", function(self)
				local tex = self:GetNormalTexture()
				tex:ClearAllPoints()
				tex:SetSize(self:GetSize())
				tex:SetPoint("CENTER", 1, 0)
			end)
			b:SetScript("OnMouseUp", function(self)
				self:GetNormalTexture():SetAllPoints()
			end)
			b:SetScript("OnClick", function()
				CompactRaidFrameManager_Expand(CompactRaidFrameManager)
			end)

			local man = _G["CompactRaidFrameManager"]
			local p = {"TOPLEFT", "UIParent", "TOPLEFT", -5, -225}
			b:SetPoint(unpack(p))
			local e = MovAny.API:GetElement(b:GetName())
			if e:IsModified() then
				e:Sync()
			end
			self.button = b

			hooksecurefunc("CompactRaidFrameManager_Expand", function(man)
				if not self.MAHooked then
					return
				end
				if not InCombatLockdown() then
					return
				end
				MovAny:UnlockPoint(man)
				man:ClearAllPoints()
				man:SetPoint("CENTER", self, "CENTER", 0, 0)
				MovAny:LockPoint(man)
				b:Hide()
			end)
			hooksecurefunc("CompactRaidFrameManager_Collapse", function(man)
				if not self.MAHooked then
					return
				end
				if not InCombatLockdown() then
					return
				end
				MovAny:UnlockPoint(man)
				man:ClearAllPoints()
				man:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", 0, 0)
				MovAny:LockPoint(man)
--				if GetNumRaidMembers() > 0 then
--					b:Show()
--				end
			end)
		end,
		OnMAHook = function(self)
			local man = _G["CompactRaidFrameManager"]
			self.man = man
			if not self.opt or not self.opt.hidden then
				if man.collapsed then
					MovAny:UnlockPoint(man)
					man:ClearAllPoints()
					man:SetPoint("BOTTOMRIGHT", UIParent, "TOPLEFT", 0, 0)
					MovAny:LockPoint(man)
--					if GetNumRaidMembers() > 0 then
--						self.button:Show()
--					end
				else
					MovAny:UnlockPoint(man)
					man:ClearAllPoints()
					man:SetPoint("CENTER", self, "CENTER", 0, 0)
					MovAny:LockPoint(man)
					self.button:Hide()
				end
			end
		end,
		OnMAPreReset = function(self)
			local e = MovAny.API:GetElement(self:GetName())
			if InCombatLockdown() then
				return
			end
			MovAny.Position:Reset(e, self.man, true)
			self.button:Hide()
			self.man = nil
		end,
	},]]
	BagsMover = {
		w = 100,
		h = 100,
		point = {"BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -93, 125},
		prefix = "ContainerFrame",
		count = 14,
		dontLock = true,
		dontScale = true,
		dontAlpha = true,
		OnMAFoundChild = function(self, index, child)
			if MovAny:IsModified(MovAny.lTransContainerToBag[child:GetName()]) then
				return
			end
			--child:SetParent(self)
			MovAny:UnlockScale(child)
			child:SetScale(1)
			MovAny:LockScale(child)
		end,
		OnMAReleaseChild = function(self, index, child)
			child:SetParent(UIParent)
			MovAny:UnlockScale(child)
		end,
		OnMAPosition = MovAny.hUpdateContainerFrameAnchors,
		OnMAScale = MovAny.hUpdateContainerFrameAnchors,
		OnMAPreReset = function(self, readOnly)
			if not readOnly then
				if self.attachedChildren then
					table.wipe(self.attachedChildren)
				end
				self:MAScanForChildren()
			end
		end,
		OnMAPostReset = function(self)
			if not readOnly then
				updateContainerFrameAnchors()
			end
		end
	},
	ChatEditBoxesMover = {
		w = 440,
		h = 32,
		point = {"TOPLEFT", "ChatFrame1", "BOTTOMLEFT", -5, -2},
		prefix = "ChatFrame",
		postfix = "EditBox",
		count = 10,
		dontLock = true,
		OnMAHook = function(self)
			self:SetWidth(ChatFrame1:GetWidth() + 10)
			--self:SetHeight(32)
			local b = ChatFrame1EditBox
			b:SetPoint("LEFT", self, "LEFT", 0, 0)
			--b:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
		end,
		OnMAFoundChild = function(self, index, child)
			--MovAny.Position:StoreOrgPoints(child, child)
			--child.MAOrgParent = child:GetParent()
			--child:SetParent(self)
			MovAny:UnlockPoint(child)
			child:ClearAllPoints()
			child:SetPoint("LEFT", self, "LEFT", 0, 0)
			child:SetWidth(ChatFrame1:GetWidth() + 10)
			--child:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0, 0)
			--MovAny:LockPoint(child)
		end,
		OnMAReleaseChild = function(self, index, child)
			--child:SetParent(child.MAOrgParent)
			--child.MAOrgParent = nil
			--MovAny:UnlockPoint(child)
			--child:ClearAllPoints()
			--child:SetPoint("TOPLEFT", "ChatFrame"..index, "BOTTOMLEFT", - 5, - 2)
			--MovAny.Position:RestoreOrgPoints(child, child, true)
		end,
		OnMAScale = function(self, scale)
			for i = 1, 10 do
				_G["ChatFrame"..i.."EditBox"]:SetScale(scale)
			end
		end,
		OnMAPostReset = function(self)
			for i = 1, 10 do
				MovAny:UnlockPoint(_G["ChatFrame"..i.."EditBox"])
				_G["ChatFrame"..i.."EditBox"]:ClearAllPoints()
				_G["ChatFrame"..i.."EditBox"]:SetPoint("TOPLEFT", "ChatFrame"..i, "BOTTOMLEFT", - 5, - 2)
				_G["ChatFrame"..i.."EditBox"]:SetWidth(ChatFrame1:GetWidth() + 10)
			end
		end
	},
}