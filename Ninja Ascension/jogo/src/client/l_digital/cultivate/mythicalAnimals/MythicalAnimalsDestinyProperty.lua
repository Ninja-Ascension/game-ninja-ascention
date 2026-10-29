--[[ ----------------------------------------------------------------------------
-- 天命属性总览
--]] ----------------------------------------------------------------------------
MythicalAnimalsDestinyProperty = class("MythicalAnimalsDestinyPropertyClass", Window)

-- 打开窗口
local mythical_animals_destiny_property_window_open_terminal = {
	_name = "mythical_animals_destiny_property_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("MythicalAnimalsDestinyPropertyClass") then
			fwin:open(MythicalAnimalsDestinyProperty:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local mythical_animals_destiny_property_window_close_terminal = {
	_name = "mythical_animals_destiny_property_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("MythicalAnimalsDestinyPropertyClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_destiny_property_window_open_terminal)
state_machine.add(mythical_animals_destiny_property_window_close_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsDestinyProperty:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize lim pool rule page state machine.
	local function init_mythical_animals_destiny_property_terminal()
		-- 打开角色创建窗口
		local mythical_animals_destiny_property_open_terminal = {
			_name = "mythical_animals_destiny_property_open",
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
		local mythical_animals_destiny_property_close_terminal = {
			_name = "mythical_animals_destiny_property_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("mythical_animals_destiny_property_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local mythical_animals_destiny_property_show_terminal = {
			_name = "mythical_animals_destiny_property_show",
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
		local mythical_animals_destiny_property_hide_terminal = {
			_name = "mythical_animals_destiny_property_hide",
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

		state_machine.add(mythical_animals_destiny_property_open_terminal)
		state_machine.add(mythical_animals_destiny_property_close_terminal)
		state_machine.add(mythical_animals_destiny_property_show_terminal)
		state_machine.add(mythical_animals_destiny_property_hide_terminal)
		state_machine.init()
	end
	-- call func init lim pool rule state machine.
	init_mythical_animals_destiny_property_terminal()
end

-- 对象初始化
function MythicalAnimalsDestinyProperty:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function MythicalAnimalsDestinyProperty:onUpdateDraw()
	local root = self.roots[1]

	-- 全体属性
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	-- 神兽属性
	self.ListView_2 = ccui.Helper:seekWidgetByName(root, "ListView_2")

	self:updateUI()
end

function MythicalAnimalsDestinyProperty:updateUI()
	self:updateRoleProperty()
	self:updateAnimalsProperty()
end

function MythicalAnimalsDestinyProperty:updateRoleProperty()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local propertyData = MythicalAnimalsHandle.getDestinyPropertyByType(0)
	local result = self:convertToTwoValueArray(propertyData)

	for _, v in ipairs(result) do
		local cell = state_machine.excute("mythical_animals_destiny_property_cell_create", 0, v)
		ListView_1:addChild(cell)
	end
	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

function MythicalAnimalsDestinyProperty:updateAnimalsProperty()
	local ListView_2 = self.ListView_2
	ListView_2:removeAllItems()

	local propertyData = MythicalAnimalsHandle.getDestinyPropertyByType(1)
	local result = self:convertToTwoValueArray(propertyData)
	for _, v in ipairs(result) do
		local cell = state_machine.excute("mythical_animals_destiny_property_cell_create", 0, v)
		ListView_2:addChild(cell)
	end

	ListView_2:jumpToTop()
	ListView_2:requestRefreshView()
end

function MythicalAnimalsDestinyProperty:convertToTwoValueArray(totalData)
	local result = {}
	local index = 1

	local propertyData = {}
    -- k 属性类型 v属性值
    for k, v in pairs(totalData) do
    	local propertyStr = k .. "," .. v
    	table.insert(propertyData, propertyStr)
    end

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

	return result
end


function MythicalAnimalsDestinyProperty:onEnterTransitionFinish()
	-- 加载MythicalAnimalsDestinyPropertyWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_properties = res/cultivate/Mythical_animals/mythical_animals_properties.csb
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_properties.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Image_1_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_1_1"), nil,
	{
		terminal_name = "mythical_animals_destiny_property_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function MythicalAnimalsDestinyProperty:onExit()
	-- 释放MythicalAnimalsDestinyPropertyWindow界面资源.
	state_machine.remove("mythical_animals_destiny_property_open")
	state_machine.remove("mythical_animals_destiny_property_close")
	state_machine.remove("mythical_animals_destiny_property_show")
	state_machine.remove("mythical_animals_destiny_property_hide")
end

function MythicalAnimalsDestinyProperty:close()
	-- window event : close.
	
end

function MythicalAnimalsDestinyProperty:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
