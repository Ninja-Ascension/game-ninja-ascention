--[[ ----------------------------------------------------------------------------
-- 属性总览界面
--]] ----------------------------------------------------------------------------
RoleBiographyPropertyPreview = class("RoleBiographyPropertyPreviewClass", Window)

-- 打开窗口
local role_biography_property_preview_window_open_terminal = {
	_name = "role_biography_property_preview_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyPropertyPreviewClass") then
			fwin:open(RoleBiographyPropertyPreview:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_property_preview_window_close_terminal = {
	_name = "role_biography_property_preview_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyPropertyPreviewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_property_preview_window_open_terminal)
state_machine.add(role_biography_property_preview_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyPropertyPreview:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies property page state machine.
	local function init_role_biography_property_preview_terminal()
		-- 打开角色创建窗口
		local role_biography_property_preview_open_terminal = {
			_name = "role_biography_property_preview_open",
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
		local role_biography_property_preview_close_terminal = {
			_name = "role_biography_property_preview_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_property_preview_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_property_preview_show_terminal = {
			_name = "role_biography_property_preview_show",
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
		local role_biography_property_preview_hide_terminal = {
			_name = "role_biography_property_preview_hide",
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

		state_machine.add(role_biography_property_preview_open_terminal)
		state_machine.add(role_biography_property_preview_close_terminal)
		state_machine.add(role_biography_property_preview_show_terminal)
		state_machine.add(role_biography_property_preview_hide_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies property state machine.
	init_role_biography_property_preview_terminal()
end

-- 对象初始化
function RoleBiographyPropertyPreview:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyPropertyPreview:onUpdateDraw()
	local root = self.roots[1]

	local ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
	ListView_1:removeAllItems()
	
	local data = self:getPropertyList()
	for i, v in ipairs(data) do
		local cell = RoleBiographyHandle.addPropertyCell(v, 2)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

function RoleBiographyPropertyPreview:getPropertyList()
	local propertyData = RoleBiographyHandle.getTotalPropertyData()
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

	local sortData = {}
	for k, v in pairs(propertyData) do
		table.insert(sortData, {propertyType = k, propertyValue = v})
	end

	table.sort(sortData, function (a, b)
		return tonumber(a.propertyType) < tonumber(b.propertyType)
	end )

	for _, v in ipairs(sortData) do
		local data = v.propertyType .. "," .. v.propertyValue
		pushData(index, data)
	end

	-- debug.print_r(result)
	return result
end

function RoleBiographyPropertyPreview:onEnterTransitionFinish()
	-- 加载RoleBiographyPropertyPreviewWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_property = res/cultivate/ninja_biographies/ninja_biographies_property.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_property.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "role_biography_property_preview_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyPropertyPreview:onExit()
	-- 释放RoleBiographyPropertyPreviewWindow界面资源.
	state_machine.remove("role_biography_property_preview_open")
	state_machine.remove("role_biography_property_preview_close")
	state_machine.remove("role_biography_property_preview_show")
	state_machine.remove("role_biography_property_preview_hide")
end

function RoleBiographyPropertyPreview:close()
	-- window event : close.
	
end

function RoleBiographyPropertyPreview:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
