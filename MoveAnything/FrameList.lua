local _G = _G
local ipairs = ipairs
local hooksecurefunc = hooksecurefunc

local MovAny = _G.MovAny
local MOVANY = _G.MOVANY

local cats = {
	{name = "Achievements & Quests"},
	{name = "Arena"},
	{name = "Blizzard Action Bars"},
	{name = "Blizzard Bags"},
	{name = "Blizzard Bank"},
	{name = "Blizzard Bottom Bar"},
	{name = "Battlegrounds & PvP"},
	{name = "Class Specific"},
	{name = "Dungeons & Raids"},
	{name = "Game Menu"},
	{name = "Guild"},
	{name = "Info Panels"},
	{name = "Loot"},
	{name = "Minimap"},
	{name = "Miscellaneous"},
	{name = "MoveAnything"},
	{name = "Unit: Focus"},
	{name = "Unit: Party"},
	{name = "Unit: Pet"},
	{name = "Unit: Player"},
	{name = "Unit: Target"},
	{name = "Vehicle"},
}

local API

local NEW_ICON = "|TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:0:0:0:-1|t"

local m = {
	Enable = function(self)
		API = MovAny.API
		self:LoadList()
		MovAny:DeleteModule(self)
		API = nil
		--m = nil
	end,
	LoadList = function(self)
		API.default = true
		for i, c in ipairs(cats) do
			API:AddCategory(c)
		end
		cats = nil
		local c, e
		c = API:GetCategory("Achievements & Quests")
		API:AddElement({name = "AchievementFrame", displayName = "Achievements", runOnce = function()
			AchievementFrame_LoadUI()
		end}, c)
		API:AddElement({name = "AchievementAlertFrame1", displayName = "Achievement Alert 1", runOnce = AchievementFrame_LoadUI, create = "AchievementAlertFrameTemplate"}, c)
		API:AddElement({name = "AchievementAlertFrame2", displayName = "Achievement Alert 2", runOnce = AchievementFrame_LoadUI, create = "AchievementAlertFrameTemplate"}, c)
--		local gcaf = API:AddElement({name = "GuildChallengeAlertFrame", displayName = "Guild Challenge Achievement Alert"}, c)
		if ObjectiveTrackerFrame or QuestWatchFrame then
		--	API:AddElement({name = "ObjectiveTrackerFrameMover", displayName = "Objectives Window", scaleWH = 1}, c)
		--	API:AddElement({name = "ObjectiveTrackerFrameScaleMover", displayName = "Objectives Window Scale"}, c)
			if ObjectiveTrackerBonusBannerFrame then
				API:AddElement({name = "ObjectiveTrackerBonusBannerFrame", displayName = "Objectives Banner Frame"}, c)
			end
		else
			API:AddElement({name = "WatchFrameMover", displayName = "Objectives Window", scaleWH = 1}, c)
		end
		local qldf = API:AddElement({name = "QuestLogDetailFrame", displayName = "Quest Details", runOnce = function()
			if not QuestLogDetailFrame:IsShown() then
				ShowUIPanel(QuestLogDetailFrame)
				HideUIPanel(QuestLogDetailFrame)
			end
		end}, c)
--		API:AddElement({name = "QuestNPCModel", displayName = "Quest Log NPC Model"}, c)
		local qlf = API:AddElement({name = "QuestLogFrame", displayName = "Quest Log"}, c)
--[[
		local qf = API:AddElement({name = "QuestFrame", displayName = "Quest Offer / Return", runOnce = function()
			hooksecurefunc(QuestFrame, "Show", function()
				if MovAny:IsModified("QuestFrame") then
					HideUIPanel(GossipFrame)
				end
			end)
			hooksecurefunc("DeclineQuest", function()
				HideUIPanel(GossipFrame)
			end)
		end}, c)
--]]
--		API:AddElement({name = "QuestTimerFrame", displayName = "Quest Timer"}, c)

		c = API:GetCategory("Arena")
		API:AddElement({name = "ArenaEnemyFrame1", displayName = "Arena Enemy 1", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame2", displayName = "Arena Enemy 2", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame3", displayName = "Arena Enemy 3", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame4", displayName = "Arena Enemy 4", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		API:AddElement({name = "ArenaEnemyFrame5", displayName = "Arena Enemy 5", create = "ArenaEnemyFrameTemplate", runOnce = Arena_LoadUI}, c)
		local ttt1 = API:AddElement({name = "TimerTrackerTimer1", displayName = NEW_ICON .. "Timer tracker", onlyOnceCreated = 1}, c)
		API:AddElement({name = "PVPTeamDetails", displayName = "Arena Team Details"}, c)
		API:AddElement({name = "ArenaFrame", displayName = "Arena Queue List"}, c)
		API:AddElement({name = "ArenaRegistrarFrame", displayName = "Arena Registrar"}, c)
		API:AddElement({name = "PVPBannerFrame", displayName = "Arena Banner"}, c)

		c = API:GetCategory("Battlegrounds & PvP")
		local pvpf = API:AddElement({name = "PVPFrame", displayName = "PVP Window"}, c)
		API:AddElement({name = "BattlefieldMinimap", displayName = "Battlefield Mini Map"}, c)
--		API:AddElement({name = "MiniMapBattlefieldFrame", displayName = "Battleground Minimap Button"}, c)
		ttt1:AddCategory(c)
		API:AddElement({name = "BattlefieldFrame", displayName = "Battleground Queue"}, c)
		API:AddElement({name = "WorldStateScoreFrame", displayName = "Battleground Score"}, c)
		API:AddElement({name = "WorldStateCaptureBar1", displayName = "Flag Capture Timer Bar", onlyOnceCreated = 1}, c)
		API:AddElement({name = "WorldStateTopCenterFrame", displayName = NEW_ICON .. "Battleground Info"}, c)
		API:AddElement({name = "WorldStateTopCenterFrameLeftBar", displayName = NEW_ICON .. "Battleground Info - Alliance progress bar"}, c)
		API:AddElement({name = "WorldStateTopCenterFrameRightBar", displayName = NEW_ICON .. "Battleground Info - Horde progress bar"}, c)
		local wsauf = API:AddElement({name = "WorldStateAlwaysUpFrame", displayName = "Top Center Status Display", noUnanchorRelatives = 1}, c)
		API:AddElement({name = "AlwaysUpFrame1", displayName = "AlwaysUp Frame 1", create = "WorldStateAlwaysUpTemplate", onlyOnceCreated = 1}, c)
		API:AddElement({name = "AlwaysUpFrame2", displayName = "AlwaysUp Frame 2", create = "WorldStateAlwaysUpTemplate", onlyOnceCreated = 1}, c)
		API:AddElement({name = "AlwaysUpFrame3", displayName = "AlwaysUp Frame 3", create = "WorldStateAlwaysUpTemplate", onlyOnceCreated = 1}, c)

		c = API:GetCategory("Blizzard Bags")
--		API:AddElement({name = "BagsMover", displayName = NEW_ICON .. "All Bags", noHide = 1}, c)
		API:AddElement({name = "BagButtonsMover", displayName = "Bag Buttons"}, c)
		API:AddElement({name = "BagButtonsVerticalMover", displayName = "Bag Buttons - Vertical"}, c)
		API:AddElement({name = "BagFrame1", displayName = "Backpack"}, c)
		API:AddElement({name = "BagFrame2", displayName = "Bag 1"}, c)
		API:AddElement({name = "BagFrame3", displayName = "Bag 2"}, c)
		API:AddElement({name = "BagFrame4", displayName = "Bag 3"}, c)
		API:AddElement({name = "BagFrame5", displayName = "Bag 4"}, c)
		API:AddElement({name = "KeyRingFrame", displayName = "Key Ring"}, c)
		API:AddElement({name = "MainMenuBarBackpackButton", displayName = "Backpack Button"}, c)
		API:AddElement({name = "CharacterBag0Slot", displayName = "Bag Button 1"}, c)
		API:AddElement({name = "CharacterBag1Slot", displayName = "Bag Button 2"}, c)
		API:AddElement({name = "CharacterBag2Slot", displayName = "Bag Button 3"}, c)
		API:AddElement({name = "CharacterBag3Slot", displayName = "Bag Button 4"}, c)
		API:AddElement({name = "KeyRingButton", displayName = "Key Ring Button"}, c)

		c = API:GetCategory("Blizzard Action Bars")
		API:AddElement({name = "BasicActionButtonsMover", displayName = "Action Bar", linkedScaling = {"ActionBarDownButton", "ActionBarUpButton"}}, c)
		API:AddElement({name = "BasicActionButtonsVerticalMover", displayName = "Action Bar - Vertical"}, c)
		API:AddElement({name = "MultiBarBottomLeft", displayName = "Bottom Left Action Bar"}, c)
		API:AddElement({name = "MultiBarBottomRight", displayName = "Bottom Right Action Bar"}, c)
		API:AddElement({name = "MultiBarRight", displayName = "Right Action Bar", run = function()
			if MovAny:IsModified("MultiBarRightHorizontalMover") then
				MovAny:ResetFrame("MultiBarRightHorizontalMover")
			end
		end}, c)
		API:AddElement({name = "MultiBarRightHorizontalMover", displayName = "Right Action Bar - Horizontal"}, c)
		API:AddElement({name = "MultiBarLeft", displayName = "Right Action Bar 2", run = function()
			if MovAny:IsModified("MultiBarLeftHorizontalMover") then
				MovAny:ResetFrame("MultiBarLeftHorizontalMover")
			end
		end}, c)
		API:AddElement({name = "MultiBarLeftHorizontalMover", displayName = "Right Action Bar 2 - Horizontal"}, c)
		API:AddElement({name = "MainMenuBarPageNumber", displayName = "Action Bar Page Number"}, c)
		API:AddElement({name = "ActionBarUpButton", displayName = "Action Bar Page Up"}, c)
		API:AddElement({name = "ActionBarDownButton", displayName = "Action Bar Page Down"}, c)
		API:AddElement({name = "PetActionButtonsMover", displayName = "Pet Action Bar"}, c)
		API:AddElement({name = "PetActionButtonsVerticalMover", displayName = "Pet Action Bar - Vertical"}, c)
		API:AddElement({name = "SlidingActionBarTexture0", displayName = "Pet Action Bar Texture 0"}, c)
		API:AddElement({name = "SlidingActionBarTexture1", displayName = "Pet Action Bar Texture 1"}, c)
		API:AddElement({name = "ShapeshiftButtonsMover", displayName = "Stance / Aura / Shapeshift Buttons", onlyOnceCreated = nil}, c)
		API:AddElement({name = "ShapeshiftButtonsVerticalMover", displayName = "Stance / Aura / Shapeshift - Vertical", onlyOnceCreated = nil}, c)

		c = API:GetCategory("Blizzard Bank")
		local bf = API:AddElement({name = "BankFrame", displayName = "Bank"}, c)
		API:AddElement({name = "BankBagFrame1", displayName = "Bank Bag 1", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)
		API:AddElement({name = "BankBagFrame2", displayName = "Bank Bag 2", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)
		API:AddElement({name = "BankBagFrame3", displayName = "Bank Bag 3", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)
		API:AddElement({name = "BankBagFrame4", displayName = "Bank Bag 4", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)
		API:AddElement({name = "BankBagFrame5", displayName = "Bank Bag 5", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)
		API:AddElement({name = "BankBagFrame6", displayName = "Bank Bag 6", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)
		API:AddElement({name = "BankBagFrame7", displayName = "Bank Bag 7", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)

		c = API:GetCategory("Blizzard Bottom Bar")
		API:AddElement({name = "MainMenuBar", displayName = "Main Bar", run = function ()
			if not MovAny:IsModified(VehicleMenuBar, pos) then
				local v = _G["VehicleMenuBar"]
				v:ClearAllPoints()
				v:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", (UIParentGetWidth() / 2) - (v:GetWidth() / 2), 0)
			end
		end, hideList = {
			{"MainMenuBarArtFrame", "BACKGROUND","ARTWORK"},
			{"PetActionBarFrame", "OVERLAY"},
			{"ShapeshiftBarFrame", "OVERLAY"},
			{"MainMenuBar", "DISABLEMOUSE"},
			{"BonusActionBarFrame", "OVERLAY", "DISABLEMOUSE"},
			}
		}, c)
		API:AddElement({name = "MainMenuBarLeftEndCap", displayName = "Left Gryphon"}, c)
		API:AddElement({name = "MainMenuBarRightEndCap", displayName = "Right Gryphon"}, c)
		API:AddElement({name = "MainMenuExpBar", displayName = "Experience Bar", scaleWH = 1, hideOnScale = {
			MainMenuXPBarTexture0,
			MainMenuXPBarTexture1,
			MainMenuXPBarTexture2,
			MainMenuXPBarTexture3,
			ExhaustionTick,
			ExhaustionTickNormal,
			ExhaustionTickHighlight,
			ExhaustionLevelFillBar,
			MainMenuXPBarTextureLeftCap,
			MainMenuXPBarTextureRightCap,
			MainMenuXPBarTextureMid,
			MainMenuXPBarDiv1,
			MainMenuXPBarDiv2,
			MainMenuXPBarDiv3,
			MainMenuXPBarDiv4,
			MainMenuXPBarDiv5,
			MainMenuXPBarDiv6,
			MainMenuXPBarDiv7,
			MainMenuXPBarDiv8,
			MainMenuXPBarDiv9,
			MainMenuXPBarDiv10,
			MainMenuXPBarDiv11,
			MainMenuXPBarDiv12,
			MainMenuXPBarDiv13,
			MainMenuXPBarDiv14,
			MainMenuXPBarDiv15,
			MainMenuXPBarDiv16,
			MainMenuXPBarDiv17,
			MainMenuXPBarDiv18,
			MainMenuXPBarDiv19,
			}
		}, c)
		API:AddElement({name = "MainMenuBarMaxLevelBar", displayName = "Max Level Bar Filler", noFE = 1, noScale = 1}, c)
		API:AddElement({name = "ReputationWatchBar", displayName = "Reputation Tracker Bar", runOnce = function()
			if ReputationWatchBar_Update then
				hooksecurefunc("ReputationWatchBar_Update", MovAny.hReputationWatchBar_Update)
			end
		end, scaleWH = 1, linkedScaling = {"ReputationWatchStatusBar"}, hideOnScale = {
			ReputationWatchBarTexture0,
			ReputationWatchBarTexture1,
			ReputationWatchBarTexture2,
			ReputationWatchBarTexture3,
			ReputationXPBarTexture0,
			ReputationXPBarTexture1,
			ReputationXPBarTexture2,
			ReputationXPBarTexture3,
			}
		}, c)
		API:AddElement({name = "MicroButtonsMover", displayName = "Micro Menu"}, c)
		API:AddElement({name = "MicroButtonsVerticalMover", displayName = "Micro Menu - Vertical"}, c)
		API:AddElement({name = "MainMenuBarVehicleLeaveButton", displayName = "Leave Vehicle Button"}, c)

		c = API:GetCategory("Class Specific")
		API:AddElement({name = "RuneFrame", displayName = "Deathknight Runes"}, c)
--		API:AddElement({name = "EclipseBarFrame", displayName = "Druid Eclipse Bar"}, c)
--		API:AddElement({name = "PaladinPowerBar", displayName = "Paladin Holy Power Bar"}, c)
		API:AddElement({name = "MultiCastActionBarFrame", displayName = NEW_ICON .. "Shaman Totem bar"}, c)
		API:AddElement({name = "TotemFrame", displayName = "Shaman Totem Timers"}, c)
--		API:AddElement({name = "ShardBarFrame", displayName = "Warlock Soul Shards"}, c)

		c = API:GetCategory("Dungeons & Raids")
		API:AddElement({name = "LFDParentFrame", displayName = "Dungeon Finder"}, c)
		API:AddElement({name = "EncounterJournal", displayName = NEW_ICON .. "Dungeon Journal"}, c)
--		API:AddElement({name = "LFGSearchStatus", displayName = "Dungeon/Raid Finder Queue Status"}, c)
		API:AddElement({name = "DungeonCompletionAlertFrame1", displayName = "Dungeon Completion Alert"}, c)
--[[
		API:AddElement({name = "LFDSearchStatus", displayName = "Dungeon Search Status Tooltip", run = function()
			local opt = MovAny:GetUserData("LFDSearchStatus")
			if not opt or not opt.frameStrata then
				LFDSearchStatus:SetFrameStrata(TOOLTIP)
			end
		 end}, c)
--]]
		API:AddElement({name = "QueueStatusFrame", displayName = NEW_ICON .. "Queue Status Tooltip", run = function()
			local opt = MovAny:GetUserData("QueueStatusFrame")
			if not opt or not opt.frameStrata then
				QueueStatusFrame:SetFrameStrata(TOOLTIP)
			end
		 end}, c)
		API:AddElement({name = "QueueStatusMinimapButton", displayName = NEW_ICON .. "Queue Status Button"}, c)
		API:AddElement({name = "LFDDungeonReadyDialog", displayName = "Dungeon Ready Dialog"}, c)
		API:AddElement({name = "LFDDungeonReadyPopup", displayName = "Dungeon Ready Popup"}, c)
		API:AddElement({name = "LFDDungeonReadyStatus", displayName = "Dungeon Ready Status"}, c)
		API:AddElement({name = "LFDRoleCheckPopup", displayName = "Dungeon Role Check Popup"}, c)
--		local rbab = API:AddElement({name = "PlayerPowerBarAlt", displayName = "Raid Boss Alternative Bar"}, c, API:GetCategory("Unit: Player"))
		API:AddElement({name = "RaidBossEmoteFrame", displayName = "Raid Boss Emote Display"}, c)
		API:AddElement({name = "Boss1TargetFrame", displayName = "Raid Boss Health Bar 1"}, c)
		API:AddElement({name = "Boss2TargetFrame", displayName = "Raid Boss Health Bar 2"}, c)
		API:AddElement({name = "Boss3TargetFrame", displayName = "Raid Boss Health Bar 3"}, c)
		API:AddElement({name = "Boss4TargetFrame", displayName = "Raid Boss Health Bar 4"}, c)
		API:AddElement({name = "LFRParentFrame", displayName = "Raid Browser"}, c)
		API:AddElement({name = "CompactRaidGroup1", displayName = NEW_ICON .. "Raid Group 1", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidGroup2", displayName = NEW_ICON .. "Raid Group 2", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidGroup3", displayName = NEW_ICON .. "Raid Group 3", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidGroup4", displayName = NEW_ICON .. "Raid Group 4", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidGroup5", displayName = NEW_ICON .. "Raid Group 5", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidGroup6", displayName = NEW_ICON .. "Raid Group 6", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidGroup7", displayName = NEW_ICON .. "Raid Group 7", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidGroup8", displayName = NEW_ICON .. "Raid Group 8", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidFrameManager", displayName = NEW_ICON .. "Raid Manager"}, c)
		API:AddElement({name = "CompactRaidFrameManagerToggleButton", displayName = NEW_ICON .. "Raid Manager Toggle Button", onlyOnceCreated = 1}, c)
		API:AddElement({name = "CompactRaidFrameBuffTooltipsMover", displayName = NEW_ICON .. "Raid Frame Buff Tooltips"}, c)
		API:AddElement({name = "CompactRaidFrameDebuffTooltipsMover", displayName = NEW_ICON .. "Raid Frame Debuff Tooltips"}, c)
--		API:AddElement({name = "RolePollPopup", displayName = "Raid Role Popup"}, c)
		API:AddElement({name = "RaidUnitFramesMover", displayName = NEW_ICON .. "Raid Unit Frames"}, c)
--		API:AddElement({name = "RaidPullout1", displayName = "Raid Group Pullout 1"}, c)
--		API:AddElement({name = "RaidPullout2", displayName = "Raid Group Pullout 2"}, c)
--		API:AddElement({name = "RaidPullout3", displayName = "Raid Group Pullout 3"}, c)
--		API:AddElement({name = "RaidPullout4", displayName = "Raid Group Pullout 4"}, c)
--		API:AddElement({name = "RaidPullout5", displayName = "Raid Group Pullout 5"}, c)
--		API:AddElement({name = "RaidPullout6", displayName = "Raid Group Pullout 6"}, c)
--		API:AddElement({name = "RaidPullout7", displayName = "Raid Group Pullout 7"}, c)
--		API:AddElement({name = "RaidPullout8", displayName = "Raid Group Pullout 8"}, c)
		API:AddElement({name = "RaidWarningFrame", displayName = "Raid Warnings"}, c)
		API:AddElement({name = "ReadyCheckFrame", displayName = "Ready Check"}, c)

		c = API:GetCategory("Game Menu")
		API:AddElement({name = "GameMenuFrame", displayName = "Game Menu",
			hideList = {
				{"GameMenuFrame", "BACKGROUND","ARTWORK","BORDER"},
			}
		}, c)
		API:AddElement({name = "VideoOptionsFrame", displayName = "Video Options", runOnce = function()
				hooksecurefunc(VideoOptionsFrame, "Show", function()
					if MovAny:IsModified("VideoOptionsFrame") then
						HideUIPanel(GameMenuFrame)
					end
				end)
			end, positionReset = function(self, f, opt, readOnly)
		end}, c)
		API:AddElement({name = "AudioOptionsFrame", displayName = "Sound Options", runOnce = function()
			hooksecurefunc(AudioOptionsFrame, "Show", function()
				if MovAny:IsModified("AudioOptionsFrame") then
					HideUIPanel(GameMenuFrame)
				end
			end)
		end}, c)
		API:AddElement({name = "InterfaceOptionsFrame", displayName = "Interface Options", runOnce = function()
			hooksecurefunc(InterfaceOptionsFrame, "Show", function()
				if MovAny:IsModified("InterfaceOptionsFrame") then
					HideUIPanel(GameMenuFrame)
				end
			end)
		end}, c)
		API:AddElement({name = "KeyBindingFrame", displayName = "Keybinding Options", runOnce = function()
			KeyBindingFrame_LoadUI()
		end}, c)
		c = API:GetCategory("Guild")
		API:AddElement({name = "GuildFrame", displayName = NEW_ICON .. "Guild"}, c)
		API:AddElement({name = "GuildBankFrame", displayName = "Guild Bank", refuseSync = MOVANY.FRAME_ONLY_WHEN_BANK_IS_OPEN}, c)
--		gcaf:AddCategory(c)
		API:AddElement({name = "GuildControlPopupFrame", displayName = "Guild Control"}, c)
		local lfgf = API:AddElement({name = "LookingForGuildFrame", displayName = NEW_ICON .. "Guild Finder"}, c)
		API:AddElement({name = "GuildInfoFrame", displayName = "Guild Info"}, c)
		API:AddElement({name = "GuildInviteFrame", displayName = NEW_ICON .. "Guild Invite"}, c)
		API:AddElement({name = "GuildLogFrame", displayName = NEW_ICON .. "Guild Log"}, c)
		API:AddElement({name = "GuildMemberDetailFrame", displayName = "Guild Member Details"}, c)
		API:AddElement({name = "GuildRegistrarFrame", displayName = "Guild Registrar"}, c)

		c = API:GetCategory("Info Panels")
		API:AddElement({name = "UIPanelMover1", displayName = "Generic Info Panel 1 Left", noHide = 1}, c)
		API:AddElement({name = "UIPanelMover2", displayName = "Generic Info Panel 2 Center", noHide = 1}, c)
		API:AddElement({name = "UIPanelMover3", displayName = "Generic Info Panel 3 Right", noHide = 1}, c)
		bf:AddCategory(c)
		API:AddElement({name = "CharacterFrame", displayName = "Character / Reputation / Currency"}, c)
		API:AddElement({name = "DressUpFrame", displayName = "Dressing Room"}, c)
--		API:AddElement({name = "LFDParentFrame", displayName = "Dungeon Finder"}, c)
		API:AddElement({name = "TaxiFrame", displayName = "Flight Paths"}, c)
		lfgf:AddCategory(c)
		API:AddElement({name = "GossipFrame", displayName = "Gossip"}, c)
		API:AddElement({name = "InspectFrame", displayName = "Inspect", runOnce = function()
			InspectFrame_LoadUI()
		end}, c)
		API:AddElement({name = "LFRParentFrame", displayName = "Looking For Raid"}, c)
		API:AddElement({name = "MacroFrame", displayName = "Macros"}, c)
		API:AddElement({name = "MailFrame", displayName = "Mailbox"}, c)
		API:AddElement({name = "MerchantFrame", displayName = "Merchant"}, c)
		API:AddElement({name = "OpenMailFrame", displayName = "Open Mail"}, c)
		API:AddElement({name = "PetStableFrame", displayName = "Pet Stable"}, c)
		API:AddElement({name = "FriendsFrame", displayName = "Social - Friends / Who / Guild / Chat / Raid"}, c)
		pvpf:AddCategory(c)
		qldf:AddCategory(c)
		qlf:AddCategory(c)
--		qf:AddCategory(c)
		API:AddElement({name = "SpellBookFrame", displayName = "Spellbook / Professions / Mounts / Companions"}, c)
		API:AddElement({name = "TabardFrame", displayName = "Tabard Design"}, c)
		API:AddElement({name = "PlayerTalentFrame", displayName = "Talents / Glyphs", refuseSync = MOVANY.FRAME_ONLY_ONCE_OPENED}, c)
		API:AddElement({name = "TradeFrame", displayName = "Trade"}, c)
		API:AddElement({name = "TradeSkillFrame", displayName = "Trade Skills"}, c)
		API:AddElement({name = "ClassTrainerFrame", displayName = "Trainer"}, c)

		c = API:GetCategory("Loot")
		API:AddElement({name = "LootFrame", displayName = "Loot"}, c)
		API:AddElement({name = "GroupLootFrame1", displayName = "Loot Roll 1", create = "GroupLootFrameTemplate"}, c)
		API:AddElement({name = "GroupLootFrame2", displayName = "Loot Roll 2", create = "GroupLootFrameTemplate"}, c)
		API:AddElement({name = "GroupLootFrame3", displayName = "Loot Roll 3", create = "GroupLootFrameTemplate"}, c)
		API:AddElement({name = "GroupLootFrame4", displayName = "Loot Roll 4", create = "GroupLootFrameTemplate"}, c)

		c = API:GetCategory("Minimap")
		API:AddElement({name = "MinimapCluster", displayName = "Minimap"}, c)
		API:AddElement({name = "MinimapBorder", displayName = "Minimap Border Texture"}, c)
		API:AddElement({name = "MinimapZoneTextButton", displayName = "Minimap Zone Text"}, c)
		API:AddElement({name = "MinimapBorderTop", displayName = "Minimap Top Border", noScale = 1}, c)
--		API:AddElement({name = "MinimapBackdrop", displayName = "Minimap Round Border", noAlpha = 1, noMove = 1, noScale = 1, hideList = {{"MinimapBackdrop", "ARTWORK"}}}, c)
--		API:AddElement({name = "MinimapNorthTag", displayName = "Minimap North Indicator", noAlpha = 1, noMove = 1, noScale = 1}, c)
		API:AddElement({name = "GameTimeFrame", displayName = "Minimap Calendar Button"}, c)
		API:AddElement({name = "TimeManagerClockButton", displayName = "Minimap Clock Button"}, c)
		API:AddElement({name = "MiniMapInstanceDifficulty", displayName = "Minimap Dungeon Difficulty"}, c)
--		API:AddElement({name = "GuildInstanceDifficulty", displayName = "Minimap Guild Group Flag"}, c)
--		API:AddElement({name = "MiniMapLFGFrame", displayName = "Minimap LFDR Button"}, c)
		API:AddElement({name = "MiniMapMailFrame", displayName = "Minimap Mail Notification"}, c)
		API:AddElement({name = "MiniMapTracking", displayName = "Minimap Tracking Button"}, c)
		API:AddElement({name = "MinimapZoomIn", displayName = "Minimap Zoom In Button"}, c)
		API:AddElement({name = "MinimapZoomOut", displayName = "Minimap Zoom Out Button"}, c)
		API:AddElement({name = "MiniMapWorldMapButton", displayName = "Minimap World Map Button"}, c)

		c = API:GetCategory("Miscellaneous")
		API:AddElement({name = "TimeManagerFrame", displayName = "Alarm Clock"}, c)
		API:AddElement({name = "BlackMarketFrame", displayName = NEW_ICON .. "Black Market Auction", runOnce = BlackMarketFrame_Show}, c)
--[[
		API:AddElement({name = "AuctionFrame", displayName = "Auction House", runOnce = function()
			local af = _G.AuctionFrame
			if not af then
				return true
			end
			local f = _G.SideDressUpFrame
			if f and not MovAny:IsModified(f) then
				f:ClearAllPoints()
				f:SetPoint("TOPLEFT", af, "TOPRIGHT", -2, -28)
			end
		end}, c)
--]]
--		API:AddElement({name = "SideDressUpFrame", displayName = "Auction House Dressing Room"}, c)
		API:AddElement({name = "AuctionHouseFrame", displayName = "Auction House"}, c)
--		API:AddElement({name = "AuctionProgressFrame", displayName = "Auction Creation Progress"}, c)
--		API:AddElement({name = "BarberShopFrame", displayName = "Barber Shop"}, c)
--		API:AddElement({name = "BNToastFrame", displayName = "Battle.Net Popup Message"}, c)
		API:AddElement({name = "MirrorTimer1", displayName = "BreathFatigue Bar"}, c)
		API:AddElement({name = "CalendarFrame", displayName = "Calendar"}, c)
		API:AddElement({name = "CalendarViewEventFrame", displayName = "Calendar Event"}, c)
		API:AddElement({name = "ChannelPullout", displayName = "Channel Pullout"}, c)
		API:AddElement({name = "ChatConfigFrame", displayName = "Chat Channel Configuration"}, c)
--		API:AddElement({name = "ChatEditBoxesMover", displayName = NEW_ICON .. "Chat Edit Box"}, c)
		API:AddElement({name = "ColorPickerFrame", displayName = "Color Picker"}, c)
		API:AddElement({name = "TokenFramePopup", displayName = "Currency Options"}, c)
		API:AddElement({name = "ItemRefTooltip", displayName = "Chat Popup Tooltip"}, c)
		API:AddElement({name = "DurabilityFrame", displayName = "Durability Figure"}, c)
		API:AddElement({name = "UIErrorsFrame", displayName = "Errors & Warning Display"}, c)
		API:AddElement({name = "FramerateLabel", displayName = "Framerate", noAlpha = 1, noHide = 1, noScale = 1, noUnanchorRelatives = 1}, c)
		API:AddElement({name = "GearManagerDialog", displayName = "Equipment Manager"}, c)
		API:AddElement({name = "ItemSocketingFrame", displayName = "Gem Socketing"}, c)
		API:AddElement({name = "HelpFrame", displayName = "GM Help"}, c)
--		API:AddElement({name = "LevelUpDisplay", displayName = "Level Up Display"}, c)
		API:AddElement({name = "MacroPopupFrame", displayName = "Macro Name & Icon"}, c)
		API:AddElement({name = "StaticPopup1", displayName = "Static Popup 1"}, c)
		API:AddElement({name = "StaticPopup2", displayName = "Static Popup 2"}, c)
		API:AddElement({name = "StaticPopup3", displayName = "Static Popup 3"}, c)
		API:AddElement({name = "StaticPopup4", displayName = "Static Popup 4"}, c)
--		API:AddElement({name = "StreamingIcon", displayName = "Streaming Download Icon"}, c)
		API:AddElement({name = "ItemTextFrame", displayName = "Reading Materials"}, c)
		API:AddElement({name = "ReputationDetailFrame", displayName = "Reputation Details"}, c)
		API:AddElement({name = "GhostFrame", displayName = NEW_ICON .. "Return to Graveyard Button"}, c)
		API:AddElement({name = "TicketStatusFrame", displayName = "Ticket Status"}, c)
		API:AddElement({name = "TooltipMover", displayName = "Tooltip"}, c)
		API:AddElement({name = "BagItemTooltipMover", displayName = "Tooltip - Bag Item"}, c)
		wsauf:AddCategory(c)
--		API:AddElement({name = "TutorialFrame", displayName = "Tutorials"}, c)
--		API:AddElement({name = "TutorialFrameAlertButton", displayName = "Tutorials Alert Button"}, c)
--		API:AddElement({name = "VoiceChatTalkers", displayName = "Voice Chat Talkers"}, c)
		API:AddElement({name = "ZoneTextFrame", displayName = "Zoning Zone Text"}, c)
		API:AddElement({name = "SubZoneTextFrame", displayName = "Zoning Subzone Text"}, c)

		c = API:GetCategory("MoveAnything")
		API:AddElement({name = "MAOptions", displayName = "MoveAnything Window",
			hideList = {
				{"MAOptions", "ARTWORK","BORDER"},
			}
		}, c)
--		API:AddElement({name = "MA_FEMover", displayName = NEW_ICON .. "MoveAnything Frame Editor Config", noHide = 1, noMove = 1}, c)
		API:AddElement({name = "MANudger", displayName = "MoveAnything Nudger"}, c)
		API:AddElement({name = "GameMenuButtonMoveAnything", displayName = "MoveAnything Game Menu Button"}, c)

		c = API:GetCategory("Unit: Focus")
		API:AddElement({name = "FocusFrame", displayName = "Focus"}, c)
		API:AddElement({name = "FocusFrameTextureFramePVPIcon", displayName = NEW_ICON .. "Focus PVP Icon"}, c)
		API:AddElement({name = "FocusFrameTextureFrameRenegadeIcon", displayName = NEW_ICON .. "Focus Renegade Icon"}, c)
		API:AddElement({name = "FocusBuffsMover", displayName = "Focus Buffs"}, c)
		API:AddElement({name = "FocusDebuffsMover", displayName = "Focus Debuffs"}, c)
		API:AddElement({name = "FocusFrameSpellBar", displayName = "Focus Casting Bar", noAlpha = 1}, c)
		API:AddElement({name = "FocusFrameToT", displayName = "Target of Focus"}, c)
		API:AddElement({name = "FocusFrameToTDebuffsMover", displayName = "Target of Focus Debuffs"}, c)

		c = API:GetCategory("Unit: Party")
		API:AddElement({name = "PartyMemberFrame1", displayName = "Party Member 1"}, c)
		API:AddElement({name = "PartyMember1DebuffsMover", displayName = "Party Member 1 Debuffs"}, c)
		API:AddElement({name = "PartyMemberFrame2", displayName = "Party Member 2"}, c)
		API:AddElement({name = "PartyMember2DebuffsMover", displayName = "Party Member 2 Debuffs"}, c)
		API:AddElement({name = "PartyMemberFrame3", displayName = "Party Member 3"}, c)
		API:AddElement({name = "PartyMember3DebuffsMover", displayName = "Party Member 3 Debuffs"}, c)
		API:AddElement({name = "PartyMemberFrame4", displayName = "Party Member 4"}, c)
		API:AddElement({name = "PartyMember4DebuffsMover", displayName = "Party Member 4 Debuffs"}, c)

		c = API:GetCategory("Unit: Pet")
		API:AddElement({name = "PetFrame", displayName = "Pet"}, c)
		API:AddElement({name = "PetDebuffsMover", displayName = "Pet Debuffs"}, c)
		API:AddElement({name = "PartyMemberFrame1PetFrame", displayName = "Party Pet 1"}, c)
		API:AddElement({name = "PartyMemberFrame2PetFrame", displayName = "Party Pet 2"}, c)
		API:AddElement({name = "PartyMemberFrame3PetFrame", displayName = "Party Pet 3"}, c)
		API:AddElement({name = "PartyMemberFrame4PetFrame", displayName = "Party Pet 4"}, c)

		c = API:GetCategory("Unit: Player")
		API:AddElement({name = "PlayerFrame", displayName = "Player", linkedScaling = {"ComboFrame"}}, c)
		API:AddElement({name = "PVPIconFrame", displayName = NEW_ICON .. "Player PVP Icon"}, c)
		API:AddElement({name = "PlayerBuffsMover", displayName = "Player Buffs"}, c)
		API:AddElement({name = "ConsolidatedBuffsTooltip", displayName = "Player Buffs - Consolidated Buffs Tooltip"}, c)
		API:AddElement({name = "PlayerDebuffsMover", displayName = "Player Debuffs"}, c)
		API:AddElement({name = "CastingBarFrame", displayName = "Casting Bar", noAlpha = 1}, c)
--		API:AddElement({name = "LossOfControlFrame", displayeName = "Loss Of Control"}, c)
--		rbab:AddCategory(c)
		API:AddElement({name = "SpellActivationOverlayFrame", displayName = NEW_ICON .. "Class Ability Proc"}, c)
		API:AddElement({name = "RatedBattlegroundRankFrame", displayName = NEW_ICON .. "Player Rank"}, c)
		API:AddElement({name = "PlayerTalentFrame", displayName = "Talents / Glyphs"}, c)

		c = API:GetCategory("Unit: Target")
		API:AddElement({name = "TargetFrame", displayName = "Target"}, c)
		API:AddElement({name = "TargetFrameTextureFramePVPIcon", displayName = NEW_ICON .. "Target PVP Icon"}, c)
		API:AddElement({name = "TargetFrameTextureFrameRenegadeIcon", displayName = NEW_ICON .. "Target Renegade Icon"}, c)
		API:AddElement({name = "TargetBuffsMover", displayName = "Target Buffs"}, c)
		API:AddElement({name = "TargetDebuffsMover", displayName = "Target Debuffs"}, c)
		API:AddElement({name = "ComboFrame", displayName = "Target Combo Points Display"}, c)
		API:AddElement({name = "TargetFrameSpellBar", displayName = "Target Casting Bar", noAlpha = 1}, c)
		API:AddElement({name = "TargetFrameToT", displayName = "Target of Target"}, c)
		API:AddElement({name = "TargetFrameToTDebuffsMover", displayName = "Target of Target Debuffs"}, c)
		API:AddElement({name = "TargetFrameNumericalThreat", displayName = NEW_ICON .. "Target Threat Indicator"}, c)
--		API:AddElement({name = "RatedBattlegroundRankTargetFrame", displayName = NEW_ICON .. "Target Player Rank"}, c)

		c = API:GetCategory("Vehicle")
		API:AddElement({name = "VehicleMenuBar", displayName = "Vehicle Bar",
			hideList = {
				{"VehicleMenuBar", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
				{"VehicleMenuBarArtFrame", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
				{"VehicleMenuBarActionButtonFrame", "ARTWORK","BACKGROUND","BORDER","OVERLAY"},
			}
		}, c)
		API:AddElement({name = "VehicleMenuBarActionButtonFrame", displayName = "Vehicle Action Bar", runOnce = function()
			VehicleMenuBarActionButtonFrame:SetSize((VehicleMenuBarActionButton1:GetWidth() + 2) * VEHICLE_MAX_ACTIONBUTTONS, VehicleMenuBarActionButton1:GetHeight() + 2)
		 end}, c)
		API:AddElement({name = "VehicleMenuBarHealthBar", displayName = "Vehicle Health Bar", onlyOnceCreated = 1}, c)
		API:AddElement({name = "VehicleMenuBarPowerBar", displayName = "Vehicle Power Bar", onlyOnceCreated = 1}, c)
		API:AddElement({name = "VehicleMenuBarLeaveButton", displayName = "Vehicle Leave Button"}, c)
		API:AddElement({name = "VehicleSeatIndicator", displayName = "Vehicle Seat Indicator"}, c)


		c = API:AddCategory({name = "MA Internal Elements"})
		API:AddElement({name = "MainMenuBarArtFrame", hidden = 1, noScale = 1}, c)
		API:AddElement({name = "WorldMapFrame", hidden = 1, refuseSync = "Unsuppported", unsupported = 1}, c)
		API:AddElement({name = "PaperDollFrame", hidden = 1, unsupported = 1}, c)

		API.default = nil

		API.customCat = API:AddCategory({name = "Custom Frames"})
	end
}

MovAny:AddCore("FrameList", m)