--[[ ----------------------------------------------------------------------------
-- 忍列传主界面
--]] ----------------------------------------------------------------------------
RoleBiographyChapter = class("RoleBiographyChapterClass", Window)

-- 打开窗口
local role_biography_chapter_window_open_terminal = {
	_name = "role_biography_chapter_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyChapterClass") then
			fwin:open(RoleBiographyChapter:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_chapter_window_close_terminal = {
	_name = "role_biography_chapter_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("notification_center_update",0,"push_notification_role_biography")
		fwin:close(fwin:find("RoleBiographyChapterClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_chapter_window_open_terminal)
state_machine.add(role_biography_chapter_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyChapter:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	
	-- load
	app.load("client.l_digital.cultivate.roleBiography.RoleBiography")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyAccess")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyAccessCell")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyAchievement")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyAchievementCell1")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyAchievementCell2")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyCell")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyChapterCell")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyCompound")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyCompoundCell")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyDescription")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyDescriptionCell")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyDivine")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyHandle")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyPropertyPreview")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyRank")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyRankCell")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyRewardsPreview")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyRewardsPreviewCell1")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyRewardsPreviewCell2")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyRule")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyIconCell")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyPropertyCell1")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyPropertyCell2")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyPropertyCell3")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyPropertyCell4")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyPropertyCell5")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyStartReset")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyUpLevel")

	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyBuyProp")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyExchange")

	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyActivateSuccess")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyUpLevelSuccess")
	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyAchieveSuccess")

	app.load("client.l_digital.cultivate.roleBiography.RoleBiographyOneBondSynthesis")
	
	app.load("client.cells.utils.resources_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.prop.prop_money_icon")

	app.load("client.shop.recharge.RechargeDialog")
	app.load("client.shop.recruit.HeroRecruitSuccess")
	app.load("client.shop.recruit.HeroRecruitSuccessTen")

	app.load("client.reward.DrawRareReward")


	-- Initialize role_biography page state machine.
	local function init_role_biography_chapter_terminal()
		-- 打开角色创建窗口
		local role_biography_chapter_open_terminal = {
			_name = "role_biography_chapter_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 关闭角色创建窗口
		local role_biography_chapter_close_terminal = {
			_name = "role_biography_chapter_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_chapter_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_chapter_show_terminal = {
			_name = "role_biography_chapter_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local role_biography_chapter_hide_terminal = {
			_name = "role_biography_chapter_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 成就值排行
		local role_biography_chapter_achievement_rank_window_open_terminal = {
			_name = "role_biography_chapter_achievement_rank_window_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- 刷新界面
						state_machine.excute("role_biography_rank_window_open", 0, nil)
					end
				end
				protocol_command.biographies_rank.param_list = "" .. 0
				NetworkManager:register(protocol_command.biographies_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 印记抽取
		local role_biography_chapter_draw_signet_window_open_terminal = {
			_name = "role_biography_chapter_draw_signet_window_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_divine_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		
		-- 规则按钮
		local role_biography_chapter_rule_window_open_terminal = {
			_name = "role_biography_chapter_rule_window_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_rule_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 成就值界面
		local role_biography_chapter_achievement_open_terminal = {
			_name = "role_biography_chapter_achievement_open",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_achievement_window_open", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 成就值刷新
		local role_biography_chapter_refresh_achieve_value_terminal = {
			_name = "role_biography_chapter_refresh_achieve_value",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateAchievementUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local role_biography_chapter_refresh_ui_terminal = {
			_name = "role_biography_chapter_refresh_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_chapter_open_terminal)
		state_machine.add(role_biography_chapter_close_terminal)
		state_machine.add(role_biography_chapter_show_terminal)
		state_machine.add(role_biography_chapter_hide_terminal)
		state_machine.add(role_biography_chapter_achievement_rank_window_open_terminal)
		state_machine.add(role_biography_chapter_draw_signet_window_open_terminal)
		state_machine.add(role_biography_chapter_rule_window_open_terminal)
		state_machine.add(role_biography_chapter_achievement_open_terminal)
		state_machine.add(role_biography_chapter_refresh_achieve_value_terminal)
		state_machine.add(role_biography_chapter_refresh_ui_terminal)

		state_machine.init()
	end
	-- call func init role_biography state machine.
	init_role_biography_chapter_terminal()
end

-- 对象初始化
function RoleBiographyChapter:init(params)
	

	return self
end

function RoleBiographyChapter:updateUI()
	self:updateChapterList()
	
	self:updateAchievementUI()
end

-- 显示章节
function RoleBiographyChapter:updateChapterList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local chapters = RoleBiographyHandle.getChapterDatas()
	for _, v in ipairs(chapters) do
		local cell = state_machine.excute("role_biography_chapter_cell_create", 0, v)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToLeft()
	ListView_1:requestRefreshView()
end

-- 成就
function RoleBiographyChapter:updateAchievementUI()
	local curAchievementValue = RoleBiographyHandle.getCurAchievementValue()

	-- 成就值
	self.Text_points:setString(curAchievementValue)

	self.Panel_dialog:setVisible(false)
	self.Text_t:setVisible(false)
	self.Text_n1:setVisible(false)
	self.Text_n1_0:setVisible(false)
	self.Text_n2:setVisible(false)


	-- 成就条
	local curAchievementId, curProgressValue, maxProgressValue = RoleBiographyHandle.getAchievementAddValue()

	if curAchievementId then
		self.Text_n1:setString(curProgressValue)
		self.Text_n2:setString(maxProgressValue)

		self.Text_t:setVisible(true)
		self.Text_n1:setVisible(true)
		self.Text_n1_0:setVisible(true)
		self.Text_n2:setVisible(true)
	end
	
	self.LoadingBar_achievement:setPercent(curProgressValue / maxProgressValue * 100)

	-- 成就提示
	local name = RoleBiographyHandle.getNextActivateAchieveName()
	if name then
		self.Panel_dialog:setVisible(true)

		self.Text_0:setString(tipStringInfo_role_biography[1])
		self.Text:setString(name)
		self.Text:setColor(cc.c3b(255, 0, 0))

		self.Text_0_1:setString(tipStringInfo_role_biography[20])
	end
end

function RoleBiographyChapter:onUpdateDraw()
	local root = self.roots[1]

	-- 主题底板
	self.Image_9 = ccui.Helper:seekWidgetByName(root, "Image_9")

	-- 主题标题
	self.Image_4_0 = ccui.Helper:seekWidgetByName(root, "Image_4_0")

	-- 主题背景
	self.Image_bg = ccui.Helper:seekWidgetByName(root, "Image_bg")

	-- 印记数值
	self.Text_points = ccui.Helper:seekWidgetByName(root, "Text_points")

	-- 印记目标值
	self.Text_n1 = ccui.Helper:seekWidgetByName(root, "Text_n1")

	-- 印记当前值
	self.Text_n2 = ccui.Helper:seekWidgetByName(root, "Text_n2")

	-- 忍列传容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	-- 激活成就提醒
	self.Text_0 = ccui.Helper:seekWidgetByName(root, "Text_0")
	self.Text = ccui.Helper:seekWidgetByName(root, "Text_pro") or ccui.Helper:seekWidgetByName(root, "Text")
	self.Text_0_1 = ccui.Helper:seekWidgetByName(root, "Text_0_1")

	-- 向左滑动
	self.Image_left = ccui.Helper:seekWidgetByName(root, "Image_left")

	-- 向右滑动
	self.Image_right = ccui.Helper:seekWidgetByName(root, "Image_right")

	self.LoadingBar_achievement = ccui.Helper:seekWidgetByName(root, "LoadingBar_achievement")

	self.Panel_dialog = ccui.Helper:seekWidgetByName(root, "Panel_dialog")
	self.Text_t = ccui.Helper:seekWidgetByName(root, "Text_t")
	self.Text_n1 = ccui.Helper:seekWidgetByName(root, "Text_n1")
	self.Text_n1_0 = ccui.Helper:seekWidgetByName(root, "Text_n1_0")
	self.Text_n2 = ccui.Helper:seekWidgetByName(root, "Text_n2")
	

	-- 成就提示底图
	self.Image_dialog_bg = ccui.Helper:seekWidgetByName(root, "Image_dialog_bg")
	self.Image_dialog_bg:setTouchEnabled(true)
	fwin:addTouchEventListener(self.Image_dialog_bg, nil,
	{
		terminal_name = "role_biography_chapter_achievement_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Image_6 = ccui.Helper:seekWidgetByName(root, "Image_6")
	self.Image_6:setTouchEnabled(true)
	fwin:addTouchEventListener(self.Image_6, nil,
	{
		terminal_name = "role_biography_chapter_achievement_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:openTopWindow()
	self:updateUI()
end

function RoleBiographyChapter:openTopWindow()
	local userinfo = UserTopInfoA:new()
	userinfo._rootWindows = self
	fwin:open(userinfo, fwin._windows)
end

function RoleBiographyChapter:onEnterTransitionFinish()
	-- 加载NinjaBiographiesWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies = res/cultivate/ninja_biographies/ninja_biographies.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 查看规则
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_help"), nil,
	{
		terminal_name = "role_biography_chapter_rule_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 查看排行
	self.Button_raking = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_raking"), nil,
	{
		terminal_name = "role_biography_chapter_achievement_rank_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转抽卡界面
	self.Button_chouka = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_chouka"), nil,
	{
		terminal_name = "role_biography_chapter_draw_signet_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_chapter_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function RoleBiographyChapter:onExit()
	-- 释放RoleBiographyWindow界面资源.
	state_machine.remove("role_biography_chapter_open")
	state_machine.remove("role_biography_chapter_close")
	state_machine.remove("role_biography_chapter_show")
	state_machine.remove("role_biography_chapter_hide")

	state_machine.remove("role_biography_chapter_achievement_rank_window_open")
	state_machine.remove("role_biography_chapter_draw_signet_window_open")
	state_machine.remove("role_biography_chapter_rule_window_open")
	state_machine.remove("role_biography_chapter_achievement_open")
	state_machine.remove("role_biography_chapter_refresh_achieve_value")
	state_machine.remove("role_biography_chapter_refresh_ui")
end

function RoleBiographyChapter:close()
	-- window event : close.

end

function RoleBiographyChapter:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
