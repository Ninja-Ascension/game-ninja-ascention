--[[ ----------------------------------------------------------------------------
-- 超值回归礼包分页
--]] ----------------------------------------------------------------------------
UserReturnMainTab2 = class("UserReturnMainTab2Class", Window)
UserReturnMainTab2.__size = nil
-- 打开窗口
local user_return_main_tab2_window_open_terminal = {
	_name = "user_return_main_tab2_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("UserReturnMainTab2Class") then
			fwin:open(UserReturnMainTab2:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local user_return_main_tab2_window_close_terminal = {
	_name = "user_return_main_tab2_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UserReturnMainTab2Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(user_return_main_tab2_window_open_terminal)
state_machine.add(user_return_main_tab2_window_close_terminal)
state_machine.init()

-- 构造器
function UserReturnMainTab2:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	self._get_type = 0			-- 去充值还是领奖
	-- Initialize user return main tab2 page state machine.
	local function init_user_return_main_tab2_terminal()
		-- 打开角色创建窗口
		local user_return_main_tab2_open_terminal = {
			_name = "user_return_main_tab2_open",
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
		local user_return_main_tab2_close_terminal = {
			_name = "user_return_main_tab2_close",
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
		local user_return_main_tab2_show_terminal = {
			_name = "user_return_main_tab2_show",
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
		local user_return_main_tab2_hide_terminal = {
			_name = "user_return_main_tab2_hide",
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

		-- 去充值或领取奖励
		local user_return_main_tab2_get_reward_terminal = {
			_name = "user_return_main_tab2_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if 0 == instance._get_type then
					-- 调用充值
					state_machine.excute("shortcut_open_recharge_window", 0, "")
				else
					local function responseChangeCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							app.load("client.reward.DrawRareReward")
							local getRewardWnd = DrawRareReward:new()
							getRewardWnd:init(7)
							fwin:open(getRewardWnd,fwin._ui)
							state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 164)
							state_machine.excute("user_return_window_refresh_red_tip",0,"")
							state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "sm_role_strengthen_tab_rising_star_update_draw.")
							response.node:onUpdateDrawEx()
						end
					end
					protocol_command.old_user_back_recharge_get_reward.param_list = "1"
					NetworkManager:register(protocol_command.old_user_back_recharge_get_reward.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新界面
		local user_return_main_tab2_refresh_terminal = {
			_name = "user_return_main_tab2_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					local function responseChargeCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 164)
								state_machine.excute("user_return_window_refresh_red_tip",0,"")
								response.node:onUpdateDrawEx()
							end
						end
					end
	
					NetworkManager:register(protocol_command.old_user_back_recharge_init.code, nil, nil, nil, instance, responseChargeCallback, false, nil)
					
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(user_return_main_tab2_open_terminal)
		state_machine.add(user_return_main_tab2_close_terminal)
		state_machine.add(user_return_main_tab2_show_terminal)
		state_machine.add(user_return_main_tab2_hide_terminal)
		state_machine.add(user_return_main_tab2_get_reward_terminal)
		state_machine.add(user_return_main_tab2_refresh_terminal)


		state_machine.init()
	end
	-- call func init user return main tab2 state machine.
	init_user_return_main_tab2_terminal()
end

function UserReturnMainTab2:onUpdateDraw()
	local activityInfo = self.activity.activity_Info

	local propDatas = zstring.splits(activityInfo[2].activityInfo_reward_select, "|", ",")
	
	

	local root = self.roots[1]
	-- 奖励道具容器
	for i=1,5 do
		local Panel_return_gift_icon = ccui.Helper:seekWidgetByName(root, "Panel_return_gift_icon_"..i)
		Panel_return_gift_icon:removeAllChildren(true)
		Panel_return_gift_icon:setVisible(false)
	end
	
	for i=1,#propDatas do
		
		local Panel_return_gift_icon = ccui.Helper:seekWidgetByName(root, "Panel_return_gift_icon_"..i)
		Panel_return_gift_icon:setVisible(true)

		local propData = propDatas[i]
		local propType = propData[1]

		local cell = ResourcesIconCell:createCell()
		if 13 == propType then
			local extraTable = {}
			if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
				extraTable.shipStar = tonumber(propData[4])
			else
				extraTable.shipStar = 0
			end
			cell:init(propType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
		else
			cell:init(propType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
		end
		Panel_return_gift_icon:addChild(cell)
	end


	-- 充值图片
	self.Image_receive = ccui.Helper:seekWidgetByName(root, "Image_receive")

	-- 限购次数
	self.Text_cs_t1 = ccui.Helper:seekWidgetByName(root, "Text_cs_t1")

	-- 限购次数上限
	self.Text_cs_t3 = ccui.Helper:seekWidgetByName(root, "Text_cs_t3")
	self:onUpdateDrawEx()
end

function UserReturnMainTab2:onUpdateDrawEx()
	self._get_type = 0
	local canReward = tonumber(_ED.user_return_recharge_init_data.canGetRechargeReward)
	local hasReward = tonumber(_ED.user_return_recharge_init_data.hasRechargeRewardNumber)
	local maxRewardCount = tonumber(_ED.user_return_recharge_init_data.rechargeRewardMaxNumber)	-- 可领取次数

	if 0 ~= canReward then
		self._get_type = 1
		self.Image_receive:loadTexture("images/ui/text/sm_hd/sm_special_lq.png")
		self.Button_recruit_card_send_rec:setEnabled(true)
		self.Button_recruit_card_send_rec:setBright(true)
	else
		if 0 >= (maxRewardCount - hasReward) then
			self.Image_receive:loadTexture("images/ui/text/sm_hd/sm_special_ylq.png")
			self.Button_recruit_card_send_rec:setEnabled(false)
			self.Button_recruit_card_send_rec:setBright(false)
		else
			self._get_type = 0 
			self.Image_receive:loadTexture(string.format("images/ui/text/sm_hd/sm_special_%s.png", tostring(_ED.user_return_recharge_gear_data)))
			self.Button_recruit_card_send_rec:setEnabled(true)
			self.Button_recruit_card_send_rec:setBright(true)
		end
	end
	-- 充值图片
	self.Image_receive:setVisible(true)

	self.Text_cs_t1:setString(tostring(hasReward))
	self.Text_cs_t3:setString(tostring(maxRewardCount))
end

function UserReturnMainTab2:onEnterTransitionFinish()
	
end

-- 对象初始化
function UserReturnMainTab2:init(params)
	if nil ~= self.onInit then
		self._rootWindows = params[1]
		self:onInit()
	end
	return self
end

function UserReturnMainTab2:onInit()
	-- 加载UserReturnMainTab2Window界面资源.
	-- res.activity.user_return.user_return_tab_2 = res/activity/user_return/user_return_tab_2.csb
	local csbNode = csb.createNode("activity/user_return/user_return_tab_2.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	if nil == UserReturnMainTab2.__size then
		UserReturnMainTab2.__size = root:getContentSize()
	end

	self:setContentSize(UserReturnMainTab2.__size)
	-- 领取/已领取按钮
	self.Button_recruit_card_send_rec = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil,
	{
		terminal_name = "user_return_main_tab2_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.activity = _ED.active_activity[165]
	
	self:onUpdateDraw()
end

function UserReturnMainTab2:onExit()
	-- 释放UserReturnMainTab2Window界面资源.
	state_machine.remove("user_return_main_tab2_open")
	state_machine.remove("user_return_main_tab2_close")
	state_machine.remove("user_return_main_tab2_show")
	state_machine.remove("user_return_main_tab2_hide")
	state_machine.remove("user_return_main_tab2_get_reward")
	state_machine.remove("user_return_main_tab2_refresh")
end

function UserReturnMainTab2:close()
	-- window event : close.
	
end

function UserReturnMainTab2:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
