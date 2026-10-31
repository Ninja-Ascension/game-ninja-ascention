--[[ ----------------------------------------------------------------------------
-- 组合卡册激活界面
--]] ----------------------------------------------------------------------------
IllustrationActivate = class("IllustrationActivateClass", Window)

-- 打开窗口
local illustration_activate_window_open_terminal = {
	_name = "illustration_activate_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationActivateClass") then
			fwin:open(IllustrationActivate:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_activate_window_close_terminal = {
	_name = "illustration_activate_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationActivateClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_activate_window_open_terminal)
state_machine.add(illustration_activate_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationActivate:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	-- var
	self._combine_card_data = nil
	self._cardMouldId = nil
	self._card_datas = nil

	-- load lua files.
	app.load("client.l_digital.cells.cultivate.illustration.illustration_condition_cell_first")
	app.load("client.l_digital.cells.cultivate.illustration.illustration_condition_cell_second")
	app.load("client.l_digital.cells.cultivate.illustration.illustration_condition_cell_third")

	-- Initialize illustration levelup page state machine.
	local function init_illustration_activate_terminal()
		-- 打开角色创建窗口
		local illustration_activate_open_terminal = {
			_name = "illustration_activate_open",
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
		local illustration_activate_close_terminal = {
			_name = "illustration_activate_close",
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

		-- 显示窗口
		local illustration_activate_show_terminal = {
			_name = "illustration_activate_show",
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
		local illustration_activate_hide_terminal = {
			_name = "illustration_activate_hide",
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

		-- 激活
		local illustration_activate_click_terminal = {
			_name = "illustration_activate_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local cardMouldId = instance._cardMouldId
					local function responseCallBack( response )
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							TipDlg.drawTextDailog(tipStringInfo_illustration_tip[4])
							state_machine.excute("illustration_refush_bar_list", 0,{cardMouldId})
							state_machine.excute("illustration_activate_window_close", 0, nil)
						end
					end

					protocol_command.user_card_info_activate.param_list = ""..cardMouldId
					NetworkManager:register(protocol_command.user_card_info_activate.code, nil, nil, nil, instance, responseCallBack, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(illustration_activate_open_terminal)
		state_machine.add(illustration_activate_close_terminal)
		state_machine.add(illustration_activate_show_terminal)
		state_machine.add(illustration_activate_hide_terminal)
		state_machine.add(illustration_activate_click_terminal)
		state_machine.init()
	end
	-- call func init illustration levelup state machine.
	init_illustration_activate_terminal()
end

function IllustrationActivate:updateList()
	-- 分三块 基础条件 特殊条件进总进度 特殊条件完成情况
	self.ListView_normal:removeAllItems()

	local base_list = IllustrationHandle.getBaseConditionList(self._combine_card_data)
	for i, v in ipairs(base_list) do
		local cell = state_machine.excute("illustration_condition_cell_first_create", 0, {v})
		self.ListView_normal:addChild(cell)
	end

	local cell = state_machine.excute("illustration_condition_cell_second_create", 0, {self._combine_card_data})
	self.ListView_normal:addChild(cell)

	local special_list = IllustrationHandle.getSpecialConditionList(self._combine_card_data)
	for i, v in ipairs(special_list) do
		local cell = state_machine.excute("illustration_condition_cell_third_create", 0, {self._combine_card_data, v})
		self.ListView_normal:addChild(cell)
	end

	self.ListView_normal:requestRefreshView()
	self.ListView_normal:jumpToTop()
end

-- 0 未激活 1 可激活
function IllustrationActivate:updateButtonState()
	local canUnlock = IllustrationHandle.getCombineCardCanUnlock(self._combine_card_data)
	if canUnlock then
		self.Button_activation:setTouchEnabled(true)
		self.Button_activation:setBright(true)
	else
		self.Button_activation:setTouchEnabled(false)
		self.Button_activation:setBright(false)
	end
end

function IllustrationActivate:onUpdateDraw()
	local root = self.roots[1]
	-- 角色头像
	self.Panel_charactor = ccui.Helper:seekWidgetByName(root, "Panel_charactor")
	self.Panel_charactor:removeAllChildren(true)
	local icon = IllustrationHandle.createHeroIcon(self._cardMouldId, true)
	icon:setAnchorPoint(cc.p(0.5,0.5))
	local size = self.Panel_charactor:getContentSize()
	icon:setPosition(cc.p(size.width/2,size.height/2))
	self.Panel_charactor:addChild(icon)

	-- 角色名称
	self.Text_charactor_name = ccui.Helper:seekWidgetByName(root, "Text_charactor_name")
    local nameStr = IllustrationHandle.getCardName(self._cardMouldId, true)
	self.Text_charactor_name:setString(nameStr)

	-- 列表容器
	self.ListView_normal = ccui.Helper:seekWidgetByName(root, "ListView_normal")
		
	self:updateButtonState()

	self:updateList()
end

function IllustrationActivate:onEnterTransitionFinish()
	-- 加载IllustrationActivateWindow界面资源.
	-- res.cultivate.illustration.illustration_levelup_0 = res/cultivate/illustration/illustration_levelup_0.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_levelup_0.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 激活按钮
	self.Button_activation = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_activation"), nil,
	{
		terminal_name = "illustration_activate_click",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_activate_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

-- 对象初始化
function IllustrationActivate:init(params)
	self._cardMouldId = params[1]
	self._combine_card_data = IllustrationHandle.getCombineCardDataByCardId(self._cardMouldId)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationActivate:onExit()
	-- 释放IllustrationActivateWindow界面资源.
	state_machine.remove("illustration_activate_open")
	state_machine.remove("illustration_activate_close")
	state_machine.remove("illustration_activate_show")
	state_machine.remove("illustration_activate_hide")
	state_machine.remove("illustration_activate_click")
end

function IllustrationActivate:close()
	-- window event : close.
	
end

function IllustrationActivate:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
