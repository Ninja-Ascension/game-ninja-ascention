--[[ ----------------------------------------------------------------------------
-- 周登录福利分页
--]] ----------------------------------------------------------------------------
UserReturnMainTab3 = class("UserReturnMainTab3Class", Window)
UserReturnMainTab3.__size = nil
-- 打开窗口
local user_return_main_tab3_window_open_terminal = {
	_name = "user_return_main_tab3_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("UserReturnMainTab3Class") then
			fwin:open(UserReturnMainTab3:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local user_return_main_tab3_window_close_terminal = {
	_name = "user_return_main_tab3_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UserReturnMainTab3Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(user_return_main_tab3_window_open_terminal)
state_machine.add(user_return_main_tab3_window_close_terminal)
state_machine.init()

-- 构造器
function UserReturnMainTab3:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.
	app.load("client.cells.activity.activity_user_return_list_cell")
	-- Initialize user return main tab3 page state machine.
	local function init_user_return_main_tab3_terminal()
		-- 打开角色创建窗口
		local user_return_main_tab3_open_terminal = {
			_name = "user_return_main_tab3_open",
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
		local user_return_main_tab3_close_terminal = {
			_name = "user_return_main_tab3_close",
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
		local user_return_main_tab3_show_terminal = {
			_name = "user_return_main_tab3_show",
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
		local user_return_main_tab3_hide_terminal = {
			_name = "user_return_main_tab3_hide",
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

		-- 刷新列表
		local user_return_main_tab3_refresh_terminal = {
			_name = "user_return_main_tab3_refresh",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					instance:onUpdateDrawEX()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(user_return_main_tab3_open_terminal)
		state_machine.add(user_return_main_tab3_close_terminal)
		state_machine.add(user_return_main_tab3_show_terminal)
		state_machine.add(user_return_main_tab3_hide_terminal)
		state_machine.add(user_return_main_tab3_refresh_terminal)
		state_machine.init()
	end
	-- call func init user return main tab3 state machine.
	init_user_return_main_tab3_terminal()
end

function UserReturnMainTab3:onUpdateDraw()
	local root = self.roots[1]

	-- 周登录福利列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:onUpdateDrawEX()
end

function UserReturnMainTab3:onUpdateDrawEX()
	local root = self.roots[1]
	local activityInfo = _ED.active_activity[164].activity_Info
	
	local listView = self.ListView_1
	
	listView:removeAllItems()
	listView:removeAllChildren()
	local signDatas = {}
	for k,v in pairs(activityInfo) do
		local signData = {}
		signData.rewardData = v.activityInfo_reward_select
		signData.dayNum = v.index
		for m,n in pairs(_ED.user_return_sign_init_data) do
			if tonumber(v.index) == tonumber(n.index) then
				signData.hasGetReward = n.hasGetReward
				signData.canGetReward = n.canGetReward
				signData.hasLoginDay = n.hasLoginDay
				break
			end
		end
		table.insert(signDatas,signData)
	end
	signDatas = self:sortListItems(signDatas)

	for k,v in pairs(signDatas) do
		local cell = state_machine.excute("activity_user_return_list_cell_create",0,{v})
		listView:addChild(cell)
	end
	listView:jumpToTop()
	listView:requestRefreshView()
end

function UserReturnMainTab3:sortListItems(items)
	local result = {}
	local closeItems = {}		-- 已领取
	local drawItems = {}		-- 可领取
	local unGetItems = {}			-- 未达到

	for k,v in pairs(items) do
		if 1 == tonumber(v.canGetReward)  then			-- 可领取
			table.insert(drawItems,v)
		elseif 1 == tonumber(v.hasGetReward) then		-- 已领取
			table.insert(closeItems, v )
		else
			table.insert(unGetItems,v)
		end
	end
	for k,v in pairs(drawItems) do
		table.insert(result,v)
	end
	for k,v in pairs(unGetItems) do
		table.insert(result,v)
	end
	for k,v in pairs(closeItems) do
		table.insert(result,v)
	end
	
	return result
end

function UserReturnMainTab3:onEnterTransitionFinish()
	
end


-- 对象初始化
function UserReturnMainTab3:init(params)
	if nil ~= self.onInit then
		self._rootWindows = params[1]
		self:onInit()
	end
	return self
end

function UserReturnMainTab3:onInit( )
	-- 加载UserReturnMainTab3Window界面资源.
	-- res.activity.user_return.user_return_tab_3 = res/activity/user_return/user_return_tab_3.csb
	local csbNode = csb.createNode("activity/user_return/user_return_tab_3.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
	if nil == UserReturnMainTab3.__size then
		UserReturnMainTab3.__size = root:getContentSize()
	end
	self:setContentSize(UserReturnMainTab3.__size)
	self:onUpdateDraw()
end

function UserReturnMainTab3:onExit()
	-- 释放UserReturnMainTab3Window界面资源.
	state_machine.remove("user_return_main_tab3_open")
	state_machine.remove("user_return_main_tab3_close")
	state_machine.remove("user_return_main_tab3_show")
	state_machine.remove("user_return_main_tab3_hide")
	state_machine.remove("user_return_main_tab3_refresh")
end

function UserReturnMainTab3:close()
	-- window event : close.
	
end

function UserReturnMainTab3:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
