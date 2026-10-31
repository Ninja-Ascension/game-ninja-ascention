--[[ ----------------------------------------------------------------------------
-- 碎片捐赠确认弹窗
--]] ----------------------------------------------------------------------------
LegionAssistanceWindow2 = class("LegionAssistanceWindow2Class", Window)

-- 打开窗口
local legion_assistance_window2_window_open_terminal = {
	_name = "legion_assistance_window2_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("LegionAssistanceWindow2Class") then
			fwin:open(LegionAssistanceWindow2:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local legion_assistance_window2_window_close_terminal = {
	_name = "legion_assistance_window2_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("LegionAssistanceWindow2Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(legion_assistance_window2_window_open_terminal)
state_machine.add(legion_assistance_window2_window_close_terminal)
state_machine.init()

-- 构造器
function LegionAssistanceWindow2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.userId = 0
	self.prop_mould_id = 0

	-- load lua files.

	-- Initialize legion assistance window2 page state machine.
	local function init_legion_assistance_window2_terminal()
		-- 打开角色创建窗口
		local legion_assistance_window2_open_terminal = {
			_name = "legion_assistance_window2_open",
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
		local legion_assistance_window2_close_terminal = {
			_name = "legion_assistance_window2_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("legion_assistance_window2_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local legion_assistance_window2_show_terminal = {
			_name = "legion_assistance_window2_show",
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
		local legion_assistance_window2_hide_terminal = {
			_name = "legion_assistance_window2_hide",
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

		-- 确认捐赠
		local legion_assistance_window2_sure_donate_terminal = {
			_name = "legion_assistance_window2_sure_donate",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then  --网络连接判断
							if response.node ~= nil and response.node.roots ~= nil then
								local rewardInfo = getSceneReward(76)
								local rewardItemCount = rewardInfo and rewardInfo.show_reward_item_count or 0
								-- print("rewardItemCount = ", rewardItemCount)
								if rewardItemCount > 0 then
									local getRewardWnd = DrawRareReward:new()
									getRewardWnd:init(76, rewardInfo)
									fwin:open(getRewardWnd, fwin._ui)
								else
									if tipStringInfo_union_donation_tip[4] then 
									else
										TipDlg.drawTextDailog(tipStringInfo_union_donation_tip[3])
									end
								end
								

								-- 刷新公会援助界面
								state_machine.excute("legion_assistance_refresh_main_ui", 0, nil)
								-- 关闭确认捐赠弹窗
								state_machine.excute("legion_assistance_window2_close", 0, nil)
							end
						end
					end

					local prop_msg = '6,'..tostring(self.prop_mould_id)..',1'
					protocol_command.union_assistance_donate.param_list = params._datas.__user_id .. "\r\n" .. prop_msg
					NetworkManager:register(protocol_command.union_assistance_donate.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(legion_assistance_window2_open_terminal)
		state_machine.add(legion_assistance_window2_close_terminal)
		state_machine.add(legion_assistance_window2_show_terminal)
		state_machine.add(legion_assistance_window2_hide_terminal)

		state_machine.add(legion_assistance_window2_sure_donate_terminal)

		state_machine.init()
	end
	-- call func init legion assistance window2 state machine.
	init_legion_assistance_window2_terminal()
end

-- 对象初始化
function LegionAssistanceWindow2:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function LegionAssistanceWindow2:onInit(params)
	self.userId = params[1]
	self.prop_mould_id = tonumber(params[2])
end

function LegionAssistanceWindow2:onUpdateDraw()
	local root = self.roots[1]
	if tipStringInfo_union_donation_tip[4] then 
		self.Text_receive_0 = ccui.Helper:seekWidgetByName(root, "Text_receive_0")
		local maxRewardNum_1 = dms.int(dms["union_config"], 68, union_config.param)
		local maxRewardNum_2 = dms.int(dms["union_config"], 72, union_config.param)
		local haveGetShip = tonumber(_ED.union.union_assistance_info.rewardNumShip)

		local habeGetEquipment = tonumber(_ED.union.union_assistance_info.rewardNumEquipment)
		
		local assistanceStr = tipStringInfo_union_donation_tip[4]
		local shipMouldId = dms.int(dms["prop_mould"], tonumber(self.prop_mould_id), prop_mould.props_type)
		if (shipMouldId == 1 and haveGetShip >= maxRewardNum_1) or (shipMouldId <= 0 and habeGetEquipment >= maxRewardNum_2) then 
			self.Text_receive_0:setString(assistanceStr)
		end
	end
end

function LegionAssistanceWindow2:onEnterTransitionFinish()
	-- 加载LegionAssistanceWindow2Window界面资源.
	-- res.legion.legion_assistance_window_2 = res/legion/legion_assistance_window_2.csb
	local csbNode = csb.createNode("legion/legion_assistance_window_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 确定捐赠
	self.Button_receive = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil,
	{
		terminal_name = "legion_assistance_window2_sure_donate",
		terminal_state = 0,
		isPressedActionEnabled = true,
		__user_id = self.userId
	}, nil, 0)	

	-- 关闭
	self.Button_cancel = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cancel"), nil,
	{
		terminal_name = "legion_assistance_window2_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function LegionAssistanceWindow2:onExit()
	-- 释放LegionAssistanceWindow2Window界面资源.
	state_machine.remove("legion_assistance_window2_open")
	state_machine.remove("legion_assistance_window2_close")
	state_machine.remove("legion_assistance_window2_show")
	state_machine.remove("legion_assistance_window2_hide")

	state_machine.remove("legion_assistance_window2_sure_donate")
end

function LegionAssistanceWindow2:close()
	-- window event : close.
	
end

function LegionAssistanceWindow2:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
