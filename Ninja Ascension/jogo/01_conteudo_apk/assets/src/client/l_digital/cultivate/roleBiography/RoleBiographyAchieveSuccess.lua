--[[ ----------------------------------------------------------------------------
-- 成就激活成功界面
--]] ----------------------------------------------------------------------------
RoleBiographyAchieveSuccess = class("RoleBiographyAchieveSuccessClass", Window)

-- 打开窗口
local role_biography_achieve_success_window_open_terminal = {
	_name = "role_biography_achieve_success_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyAchieveSuccessClass") then
			fwin:open(RoleBiographyAchieveSuccess:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_achieve_success_window_close_terminal = {
	_name = "role_biography_achieve_success_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyAchieveSuccessClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_achieve_success_window_open_terminal)
state_machine.add(role_biography_achieve_success_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyAchieveSuccess:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies levelup page state machine.
	local function init_role_biography_achieve_success_terminal()
		-- 打开角色创建窗口
		local role_biography_achieve_success_open_terminal = {
			_name = "role_biography_achieve_success_open",
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
		local role_biography_achieve_success_close_terminal = {
			_name = "role_biography_achieve_success_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_achieve_success_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_achieve_success_show_terminal = {
			_name = "role_biography_achieve_success_show",
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
		local role_biography_achieve_success_hide_terminal = {
			_name = "role_biography_achieve_success_hide",
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

		state_machine.add(role_biography_achieve_success_open_terminal)
		state_machine.add(role_biography_achieve_success_close_terminal)
		state_machine.add(role_biography_achieve_success_show_terminal)
		state_machine.add(role_biography_achieve_success_hide_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies levelup state machine.
	init_role_biography_achieve_success_terminal()
end

-- 对象初始化
function RoleBiographyAchieveSuccess:init(params)
	self._achieveId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyAchieveSuccess:updateUI()
	local achieveId = self._achieveId
	
	local name_mould_id = dms.int(dms["biographies_achieve"], achieveId, biographies_achieve.name)
	local word_info = dms.element(dms["word_mould"], name_mould_id)
	local name = word_info[3]
	self.Text_task:setString(string.format(tipStringInfo_role_biography[19], name))

	self:updateBottomProperty()
end

function RoleBiographyAchieveSuccess:updateBottomProperty()
	local ListView_2 = self.ListView_2
	ListView_2:removeAllItems()
	
	local data = self:getPropertyList()
	for i, v in ipairs(data) do
		local cell = RoleBiographyHandle.addPropertyCell(v, 4)
		ListView_2:addChild(cell)
	end

	ListView_2:jumpToTop()
	ListView_2:requestRefreshView()
end

function RoleBiographyAchieveSuccess:getPropertyList()
	local achieveId = self._achieveId
	local property_add = dms.string(dms["biographies_achieve"], achieveId, biographies_achieve.property_add)
	local propertyData = zstring.split(property_add, "|")
	local result = {}
	local index = 1

	local function pushData(index, data)
		if result[index] == nil then
			result[index] = {}
		end
		if #result[index] < 2 then
			table.insert(result[index], data)
		else
			index = index + 1
			pushData(index, data)
		end
	end

	for _, v in ipairs(propertyData) do
		pushData(index, v)
	end
	-- debug.print_r(result)
	return result
end

function RoleBiographyAchieveSuccess:onUpdateDraw()
	local root = self.roots[1]

	-- 忍列传名称
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- 印记增长数值
	self.Text_name_0 = ccui.Helper:seekWidgetByName(root, "Text_name_0")

	self.Text_task = ccui.Helper:seekWidgetByName(root, "Text_task")

	self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")

	self.Panel_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil,
	{
		terminal_name = "role_biography_achieve_success_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self:updateUI()
end

function RoleBiographyAchieveSuccess:onEnterTransitionFinish()
	-- 加载RoleBiographyAchieveSuccessWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_task_levelup = res/cultivate/ninja_biographies/ninja_biographies_task_levelup.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_task_levelup.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local action = csb.createTimeline("cultivate/ninja_biographies/ninja_biographies_task_levelup.csb")
	table.insert(self.actions, action)
	csbNode:runAction(action)

	action:play("window_open", false)

	self:onUpdateDraw()
end

function RoleBiographyAchieveSuccess:onExit()
	-- 释放RoleBiographyAchieveSuccessWindow界面资源.
	state_machine.remove("role_biography_achieve_success_open")
	state_machine.remove("role_biography_achieve_success_close")
	state_machine.remove("role_biography_achieve_success_show")
	state_machine.remove("role_biography_achieve_success_hide")
end

function RoleBiographyAchieveSuccess:close()
	-- window event : close.
	
end

function RoleBiographyAchieveSuccess:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
