--[[ ----------------------------------------------------------------------------
-- 回归福利分页
--]] ----------------------------------------------------------------------------
UserReturnMainTab1 = class("UserReturnMainTab1Class", Window)
UserReturnMainTab1.__size = nil
-- 打开窗口
local user_return_main_tab1_window_open_terminal = {
	_name = "user_return_main_tab1_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("UserReturnMainTab1Class") then
			fwin:open(UserReturnMainTab1:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local user_return_main_tab1_window_close_terminal = {
	_name = "user_return_main_tab1_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UserReturnMainTab1Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(user_return_main_tab1_window_open_terminal)
state_machine.add(user_return_main_tab1_window_close_terminal)
state_machine.init()

-- 构造器
function UserReturnMainTab1:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.cells.utils.resources_icon_cell")

	-- Initialize user return main tab1 page state machine.
	local function init_user_return_main_tab1_terminal()
		-- 打开角色创建窗口
		local user_return_main_tab1_open_terminal = {
			_name = "user_return_main_tab1_open",
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
		local user_return_main_tab1_close_terminal = {
			_name = "user_return_main_tab1_close",
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
		local user_return_main_tab1_show_terminal = {
			_name = "user_return_main_tab1_show",
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
		local user_return_main_tab1_hide_terminal = {
			_name = "user_return_main_tab1_hide",
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

		-- 领取奖励
		local user_return_main_tab1_get_reward_terminal = {
			_name = "user_return_main_tab1_get_reward",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)

				local function responseChangeCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd,fwin._ui)
						state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 164)
						state_machine.excute("user_return_window_refresh_red_tip",0,"")
                        state_machine.excute("sm_role_strengthen_tab_rising_star_update_draw", 0 , "sm_role_strengthen_tab_rising_star_update_draw.")
						instance:onUpdateDraw()
					end
                end
                protocol_command.old_user_back_recharge_get_reward.param_list = "0"
                NetworkManager:register(protocol_command.old_user_back_recharge_get_reward.code, nil, nil, nil, instance, responseChangeCallback, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(user_return_main_tab1_open_terminal)
		state_machine.add(user_return_main_tab1_close_terminal)
		state_machine.add(user_return_main_tab1_show_terminal)
		state_machine.add(user_return_main_tab1_hide_terminal)
		state_machine.add(user_return_main_tab1_get_reward_terminal)
		state_machine.init()
	end
	-- call func init user return main tab1 state machine.
	init_user_return_main_tab1_terminal()
end

function UserReturnMainTab1:onUpdateDraw()
	local activityInfo = _ED.active_activity[165].activity_Info

	local propDatas = zstring.splits(activityInfo[1].activityInfo_reward_select, "|", ",")
	
	

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

	-- 领取文字
	self.Image_receive = ccui.Helper:seekWidgetByName(root, "Image_receive")
	-- 已领取文字
	self.Image_received = ccui.Helper:seekWidgetByName(root, "Image_received")

	self:onUpdateDrawEX()
end

function UserReturnMainTab1:onUpdateDrawEX()
	local canReward = tonumber(_ED.user_return_recharge_init_data.canGetNormalReward)
	local hasReward = tonumber(_ED.user_return_recharge_init_data.hasNormalReward)
	local maxRewardCount = tonumber(_ED.user_return_recharge_init_data.canGetNormalRewardMaxNumber)	-- 可领取次数

	-- 领取文字
	self.Image_receive:setVisible(false)
	-- 已领取文字
	self.Image_received:setVisible(false)
	
	if 1 == canReward then
		self.Image_receive:setVisible(true)
		self.Button_recruit_card_send_rec:setEnabled(true)
		self.Button_recruit_card_send_rec:setBright(true)
	else
		if 0 >= (maxRewardCount - hasReward) then
			self.Image_received:setVisible(true)
			self.Button_recruit_card_send_rec:setEnabled(false)
			self.Button_recruit_card_send_rec:setBright(false)
		else
			self.Image_receive:setVisible(true)
			self.Button_recruit_card_send_rec:setEnabled(true)
			self.Button_recruit_card_send_rec:setBright(true)
		end
	end

end

function UserReturnMainTab1:onEnterTransitionFinish()
	
end

-- 对象初始化
function UserReturnMainTab1:init(params)
	if nil ~= self.onInit then
		self._rootWindows = params[1]
		self:onInit()
	end
	return self
end

function UserReturnMainTab1:onInit()
	-- 加载UserReturnMainTab1Window界面资源.
	-- res.activity.user_return.user_return_tab_1 = res/activity/user_return/user_return_tab_1.csb
	local csbNode = csb.createNode("activity/user_return/user_return_tab_1.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	if UserReturnMainTab1.__size == nil then
        UserReturnMainTab1.__size = root:getContentSize()
    end
    self:setContentSize(UserReturnMainTab1.__size)
	-- 领取/已领取按钮
	self.Button_recruit_card_send_rec = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_receive"), nil,
	{
		terminal_name = "user_return_main_tab1_get_reward",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function UserReturnMainTab1:onExit()
	-- 释放UserReturnMainTab1Window界面资源.
	state_machine.remove("user_return_main_tab1_open")
	state_machine.remove("user_return_main_tab1_close")
	state_machine.remove("user_return_main_tab1_show")
	state_machine.remove("user_return_main_tab1_hide")
	state_machine.remove("user_return_main_tab1_get_reward")
end

function UserReturnMainTab1:close()
	-- window event : close.
	
end

function UserReturnMainTab1:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
