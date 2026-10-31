--[[ ----------------------------------------------------------------------------
-- 属性总览界面
--]] ----------------------------------------------------------------------------
IllustrationAttributes = class("IllustrationAttributesClass", Window)

-- 打开窗口
local illustration_attributes_window_open_terminal = {
	_name = "illustration_attributes_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("IllustrationAttributesClass") then
			fwin:open(IllustrationAttributes:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local illustration_attributes_window_close_terminal = {
	_name = "illustration_attributes_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("IllustrationAttributesClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_attributes_window_open_terminal)
state_machine.add(illustration_attributes_window_close_terminal)
state_machine.init()

-- 构造器
function IllustrationAttributes:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize illustration attributes page state machine.
	local function init_illustration_attributes_terminal()
		-- 打开角色创建窗口
		local illustration_attributes_open_terminal = {
			_name = "illustration_attributes_open",
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
		local illustration_attributes_close_terminal = {
			_name = "illustration_attributes_close",
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
		local illustration_attributes_show_terminal = {
			_name = "illustration_attributes_show",
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
		local illustration_attributes_hide_terminal = {
			_name = "illustration_attributes_hide",
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

		state_machine.add(illustration_attributes_open_terminal)
		state_machine.add(illustration_attributes_close_terminal)
		state_machine.add(illustration_attributes_show_terminal)
		state_machine.add(illustration_attributes_hide_terminal)
		state_machine.init()
	end
	-- call func init illustration attributes state machine.
	init_illustration_attributes_terminal()
end

-- 对象初始化
function IllustrationAttributes:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function IllustrationAttributes:onUpdateDraw()
	local root = self.roots[1]

	for i=1,8 do
		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
		Text_attributes_n:setVisible(false)
		Text_attributes_t:setVisible(false)
	end
	-- 单卡总加成
	local normalAdd,totalScore,totalAdd = IllustrationHandle.getAchieveByServer()
	if "" ~= normalAdd then
		local addDatas = zstring.split(normalAdd,"|")
		for i=1,#addDatas do
			local datas = zstring.split(addDatas[i],",")
			local addType = tonumber(datas[1])
			local addVal = tonumber(datas[2])

			local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)

			local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
			local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)

			Text_attributes_n:setString(propertyName)
			Text_attributes_t:setString(propertyValue)

			Text_attributes_n:setVisible(true)
			Text_attributes_t:setVisible(true)
		end
	else
		for i=1,3 do
			local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
			Text_attributes_n:setString(tipStringInfo_property_name_and_value[tostring(i - 1)])
			local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
			Text_attributes_t:setString("0")
			Text_attributes_n:setVisible(true)
			Text_attributes_t:setVisible(true)
		end
	end
	
	-- 成就值加成
	if "" ~= totalAdd then
		local totalAddDatas = zstring.split(totalAdd,"|")
		local tIndex = 4
		for i=1,#totalAddDatas do
			if 8 < tIndex then
				break
			end
			local datas = zstring.split(totalAddDatas[i],",")
			local addType = tonumber(datas[1])
			local addVal = tonumber(datas[2])

			local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)

			local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..tIndex)
			local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..tIndex)

			Text_attributes_n:setString(propertyName)
			Text_attributes_t:setString(propertyValue)

			Text_attributes_n:setVisible(true)
			Text_attributes_t:setVisible(true)
			tIndex = tIndex + 1
		end
	else
		for i=4,6 do
			local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
			Text_attributes_n:setString(tipStringInfo_property_name_and_value[tostring(i - 4)])
			local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
			Text_attributes_t:setString("0")
			Text_attributes_n:setVisible(true)
			Text_attributes_t:setVisible(true)
		end
	end
	
end

function IllustrationAttributes:onEnterTransitionFinish()
	-- 加载IllustrationAttributesWindow界面资源.
	-- res.cultivate.illustration.illustration_attributes = res/cultivate/illustration/illustration_attributes.csb
	local csbNode = csb.createNode("cultivate/illustration/illustration_attributes.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "illustration_attributes_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function IllustrationAttributes:onExit()
	-- 释放IllustrationAttributesWindow界面资源.
	state_machine.remove("illustration_attributes_open")
	state_machine.remove("illustration_attributes_close")
	state_machine.remove("illustration_attributes_show")
	state_machine.remove("illustration_attributes_hide")
end

function IllustrationAttributes:close()
	-- window event : close.
	
end

function IllustrationAttributes:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
