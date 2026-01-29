local NAME, _ = ...

local DEFAULTS = {
	micromenu = { name = 'MicroMenu', val = true, ele = nil },
	bagsbar = { name = 'Bagsbar', val = true, ele = nil },
	minimap = { name = 'Minimap', val = true, ele = nil },
	social = { name = 'Social', val = true, ele = nil },
	buffs = { name = 'Buffs', val = true, ele = nil },
	debuffs = { name = 'Debuffs', val = true, ele = nil },
	chatbar = { name = 'ChatBar', val = true, ele = nil },
	objectives = { name = 'Objectives', val = true, ele = nil }
}

local function setup_options(f)
	f.panel = CreateFrame('Frame')
	f.panel.name = NAME

	local index = 1
	for k, v in pairs(jhideDB) do
		local b = CreateFrame("CheckButton", nil, f.panel, "InterfaceOptionsCheckButtonTemplate")
		b:SetPoint("TOPLEFT", 20, index * (-20))
		b.Text:SetText(v.name)
		b:HookScript("OnClick", function(_, btn, down)
			v.val = b:GetChecked()
		end)
		b:SetChecked(v.val)
		index = index + 1
	end

	local cat = Settings.RegisterCanvasLayoutCategory(f.panel, f.panel.name, f.panel.name);
	cat.ID = f.panel.name
	Settings.RegisterAddOnCategory(cat)
end

local function hide_self(self)
	self:Hide()
end

local function setup_hide()
	for k, v in pairs(jhideDB) do
		if v.val then
			v.ele:Hide()
			v.ele:HookScript('OnShow', function(self) self:Hide() end)
		end
	end
end

local function on_event(frame, event, name)
	if name ~= NAME or event ~= 'ADDON_LOADED' then
		return
	end
	jhideDB = jhideDB or CopyTable(DEFAULTS)
	jhideDB.micromenu.ele = MicroMenu;
	jhideDB.bagsbar.ele = BagsBar;
	jhideDB.minimap.ele = MinimapCluster;
	jhideDB.social.ele = QuickJoinToastButton;
	jhideDB.buffs.ele = BuffFrame;
	jhideDB.debuffs.ele = DebuffFrame;
	jhideDB.chatbar.ele = ChatFrame1ButtonFrame;
	jhideDB.objectives.ele = ObjectiveTrackerFrame;
	setup_options(frame)
	setup_hide()
end

local F = CreateFrame("Frame")
F:RegisterEvent('ADDON_LOADED')
F:SetScript("OnEvent", on_event)
