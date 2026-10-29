--[[ ----------------------------------------------------------------------------
-- 获得途径
--]] ----------------------------------------------------------------------------
MythicalAnimalsObtain = class("MythicalAnimalsObtainClass", Window)

-- 打开窗口
local mythical_animals_obtain_window_open_terminal = {
	_name = "mythical_animals_obtain_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsObtainClass") then
			fwin:open(MythicalAnimalsObtain:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_obtain_window_close_terminal = {
	_name = "mythical_animals_obtain_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsObtainClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_obtain_window_open_terminal)
state_machine.add(mythical_animals_obtain_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsObtain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_obtain_terminal()
		-- 打开角色创建窗口
		local mythical_animals_obtain_open_terminal = {
			_name = "mythical_animals_obtain_open",
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
		local mythical_animals_obtain_close_terminal = {
			_name = "mythical_animals_obtain_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_obtain_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_obtain_show_terminal = {
			_name = "mythical_animals_obtain_show",
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
		local mythical_animals_obtain_hide_terminal = {
			_name = "mythical_animals_obtain_hide",
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

		-- 刷新界面
		local mythical_animals_obtain_update_ui_terminal = {
			_name = "mythical_animals_obtain_update_ui",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_obtain_open_terminal)
		state_machine.add(mythical_animals_obtain_close_terminal)
		state_machine.add(mythical_animals_obtain_show_terminal)
		state_machine.add(mythical_animals_obtain_hide_terminal)
		state_machine.add(mythical_animals_obtain_update_ui_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_obtain_terminal()
end

-- 对象初始化
function MythicalAnimalsObtain:init(params)
	self._prop = params.prop
	self._showType = params.showType

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsObtain:onUpdateDraw()
	local root = self.roots[1]

	-- 道具icon
	self.Panel_mythical_animals = ccui.Helper:seekWidgetByName(root, "Panel_mythical_animals")
	-- 道具名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	-- 拥有数量
	self.Text_quanaity_n = ccui.Helper:seekWidgetByName(root, "Text_quanaity_n")
	-- 途径列表
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self:updateUI()
end

function MythicalAnimalsObtain:updateUI()
	local prop = self._prop

	local count = tonumber(getPropAllCountByMouldId(prop[2]))
	local name = setThePropsIcon(prop[2])[2]
	
	self.Text_name:setString(name)
	self.Text_quanaity_n:setString(count)
	
	local Panel_mythical_animals = self.Panel_mythical_animals
	Panel_mythical_animals:removeAllChildren(true)

	local cell = DrawHandle.drawIcon({prop[1], prop[2], count})
	Panel_mythical_animals:addChild(cell)

	self:updateList()
end

function MythicalAnimalsObtain:updateList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	if self._showType ~= nil then
		local destinyTaskData = MythicalAnimalsHandle.getDestinyTaskData()
		for i, v in ipairs(destinyTaskData) do
			local cell = state_machine.excute("mythical_animals_obtain_cell_create", 0, v)
			ListView_1:addChild(cell)
		end
	else
		for i = 1, 1 do
			local cell = state_machine.excute("mythical_animals_obtain_cell_create", 0, nil)
			ListView_1:addChild(cell)
		end
	end
end

function MythicalAnimalsObtain:onEnterTransitionFinish()
	-- 加载MythicalAnimalsObtainWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_obtain = res/cultivate/Mythical_animals/mythical_animals_obtain.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_obtain.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "mythical_animals_obtain_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function MythicalAnimalsObtain:onExit()
	-- 释放MythicalAnimalsObtainWindow界面资源.
	state_machine.remove("mythical_animals_obtain_open")
	state_machine.remove("mythical_animals_obtain_close")
	state_machine.remove("mythical_animals_obtain_show")
	state_machine.remove("mythical_animals_obtain_hide")
	state_machine.remove("mythical_animals_obtain_update_ui")
end

function MythicalAnimalsObtain:close()
	-- window event : close.
	
end

function MythicalAnimalsObtain:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
