--[[ ----------------------------------------------------------------------------
-- 组合卡扩充界面
--]] ----------------------------------------------------------------------------
CombinationCardBuy = class("CombinationCardBuyClass", Window)

-- 打开窗口
local combination_card_buy_window_open_terminal = {
	_name = "combination_card_buy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CombinationCardBuyClass") then
			fwin:open(CombinationCardBuy:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local combination_card_buy_window_close_terminal = {
	_name = "combination_card_buy_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CombinationCardBuyClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combination_card_buy_window_open_terminal)
state_machine.add(combination_card_buy_window_close_terminal)
state_machine.init()

-- 构造器
function CombinationCardBuy:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	self.cur_expand_num = 0
	self.demond_num = 0
	self.prop_num = 0
	self.prop_need = 0
	-- Initialize combination card buy page state machine.
	local function init_combination_card_buy_terminal()
		-- 打开角色创建窗口
		local combination_card_buy_open_terminal = {
			_name = "combination_card_buy_open",
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
		local combination_card_buy_close_terminal = {
			_name = "combination_card_buy_close",
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
		local combination_card_buy_show_terminal = {
			_name = "combination_card_buy_show",
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
		local combination_card_buy_hide_terminal = {
			_name = "combination_card_buy_hide",
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

		-- 使用钻石或者扩充券窗口
		local combination_card_expand_click_terminal = {
			_name = "combination_card_expand_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.lock("combination_card_expand_click",0,"")
				-- 0 扩充券 1 钻石
				if params then
					local mType = params._datas.m_type

					if 0 == tonumber(mType) and tonumber(instance.prop_num) < tonumber(instance.prop_need) then
						TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[6])
						return true
					end
					local function responseExpandCallBack( response )
						state_machine.unlock("combination_card_expand_click",0,"")
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then 
							TipDlg.drawTextDailog(tipStringInfo_combination_card_tip[5])
							state_machine.excute("combination_card_buy_window_close",0,"")
						end
					end
					protocol_command.combine_ship_filed_expansion.param_list = ""..mType
					NetworkManager:register(protocol_command.combine_ship_filed_expansion.code, nil, nil, nil, instance, responseExpandCallBack, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(combination_card_buy_open_terminal)
		state_machine.add(combination_card_buy_close_terminal)
		state_machine.add(combination_card_buy_show_terminal)
		state_machine.add(combination_card_buy_hide_terminal)
		state_machine.add(combination_card_expand_click_terminal)
		state_machine.init()
	end
	-- call func init combination card buy state machine.
	init_combination_card_buy_terminal()
end

-- 对象初始化
function CombinationCardBuy:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CombinationCardBuy:onUpdateDraw()
	local root = self.roots[1]

	-- 钻石购买数量
	self.Text_zuanshi_n = ccui.Helper:seekWidgetByName(root, "Text_zuanshi_n")
	self.Text_zuanshi_n:setString(""..self.demond_num)
	-- 当前组合卡上阵数
	self.Text_1_0_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0_0")
	self.Text_1_0_0:setString(""..self.cur_expand_num)

	-- 扩充后上阵数
	self.Text_1_0_0_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0_0_0")
	self.Text_1_0_0_0:setString(""..(self.cur_expand_num + 1))

	-- 拥有量
	self.Text_3 = ccui.Helper:seekWidgetByName(root, "Text_shuzi")
	self.Text_3:setString(self.prop_num)

end

function CombinationCardBuy:onEnterTransitionFinish()
	-- 加载CombinationCardbuyWindow界面资源.
	-- res.cultivate.combinationCard.Combination_card_buy = res/cultivate/combinationCard/Combination_card_buy.csb
	local csbNode = csb.createNode("cultivate/Combination_card/Combination_card_goumai.csb")
	local root = csbNode:getChildByName("root")

	local action = csb.createTimeline("cultivate/Combination_card/Combination_card_goumai.csb") 
	
	action:play("window_open", false)
	csbNode:runAction(action)

	table.insert(self.roots, root)
	self:addChild(csbNode)

	
	-- 钻石购买按钮
	self.Button_buy_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_goumai_2"), nil,
	{
		terminal_name = "combination_card_expand_click",
		m_type = 1,
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 扩充卷购买按钮
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_goumai"), nil,
	{
		terminal_name = "combination_card_expand_click",
		m_type = 0,
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "combination_card_buy_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	
	local prop_info = zstring.split(dms.string(dms["play_config"], 177, pirates_config.param),",")
	local prop_id = prop_info[1]
	self.prop_need = prop_info[2]
	if fundPropWidthId(prop_id) then
		self.prop_num = fundPropWidthId(prop_id).prop_number
	end
	self.demond_num = dms.int(dms["play_config"], 178, pirates_config.param)
	self.cur_expand_num = tonumber(_ED.user_comb_can_filed_mould_num)
	self:onUpdateDraw()
end

function CombinationCardBuy:onExit()
	-- 释放CombinationCardbuyWindow界面资源.
	state_machine.remove("combination_card_buy_open")
	state_machine.remove("combination_card_buy_close")
	state_machine.remove("combination_card_buy_show")
	state_machine.remove("combination_card_buy_hide")
	state_machine.remove("combination_card_expand_click")
end

function CombinationCardBuy:close()
	-- window event : close.
	
end

function CombinationCardBuy:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
