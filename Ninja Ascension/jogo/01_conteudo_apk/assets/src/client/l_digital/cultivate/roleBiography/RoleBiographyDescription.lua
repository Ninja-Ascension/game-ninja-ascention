--[[ ----------------------------------------------------------------------------
-- 印记详情界面
--]] ----------------------------------------------------------------------------
RoleBiographyDescription = class("RoleBiographyDescriptionClass", Window)

-- 打开窗口
local role_biography_description_window_open_terminal = {
	_name = "role_biography_description_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyDescriptionClass") then
			fwin:open(RoleBiographyDescription:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_description_window_close_terminal = {
	_name = "role_biography_description_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyDescriptionClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_description_window_open_terminal)
state_machine.add(role_biography_description_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyDescription:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies imprint page state machine.
	local function init_role_biography_description_terminal()
		-- 打开角色创建窗口
		local role_biography_description_open_terminal = {
			_name = "role_biography_description_open",
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
		local role_biography_description_close_terminal = {
			_name = "role_biography_description_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_description_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_description_show_terminal = {
			_name = "role_biography_description_show",
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
		local role_biography_description_hide_terminal = {
			_name = "role_biography_description_hide",
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

		-- 
		local role_biography_description_to_get_terminal = {
			_name = "role_biography_description_to_get",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local propId = instance._propId
					state_machine.excute("role_biography_access_window_open", 0, propId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 去合成
		local role_biography_description_to_compound_terminal = {
			_name = "role_biography_description_to_compound",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local propId = instance._propId
					state_machine.excute("role_biography_compound_window_open", 0, propId)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_description_open_terminal)
		state_machine.add(role_biography_description_close_terminal)
		state_machine.add(role_biography_description_show_terminal)
		state_machine.add(role_biography_description_hide_terminal)
		state_machine.add(role_biography_description_to_get_terminal)
		state_machine.add(role_biography_description_to_compound_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies imprint state machine.
	init_role_biography_description_terminal()
end

-- 对象初始化
function RoleBiographyDescription:init(params)
	self._propId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyDescription:updateUI()
	local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.ColorfulImprint)
	if fun_is_open == true then
		local isColorful = RoleBiographyHandle.judgeImprintIsColorful(self._propId)
		self.Text_imprint:setString(isColorful and tipStringInfo_role_biography[23] or tipStringInfo_role_biography[22])

		self.Button_hc:setVisible(isColorful)
		self.Button_to_get:setVisible(not isColorful)
	end

	self:updateLeft()
	self:updateRight()
end

function RoleBiographyDescription:updateLeft()
	local Panel_player_icon_1 = self.Panel_player_icon_1
	Panel_player_icon_1:removeAllChildren(true)

	local propData = {6, self._propId, 0}

	local cell = RoleBiographyHandle.addSpecialIconCell(propData, false, false)
	Panel_player_icon_1:addChild(cell)

	local description = drawPropsDescription(self._propId)
	self.Text_1_0:setString(description)

	local name = setThePropsIcon(self._propId)[2]
	self.Text_character:setString(name)
end

function RoleBiographyDescription:updateRight()
	self:updateRightTop()
	self:updateRightBottom()
end

function RoleBiographyDescription:updateRightTop()
	local Text_teams = self.Text_teams

	local biographies = RoleBiographyHandle.getAllBiographyDatasByPropId(self._propId)
	local haveActivateCount = 0

	for i, v in ipairs(Text_teams) do
		local data = biographies[i]
		if data then
			local name_mould_id = dms.atof(data, biographies_mould.name)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			local name = word_info[3]

			v:setString(name)

			local biographyId = dms.atof(data, biographies_mould.id)
			local isActivate = RoleBiographyHandle.getBiographyIsActivate(biographyId)
			if isActivate then
				v:setColor(cc.c3b(0, 128, 0))
				haveActivateCount = haveActivateCount + 1
			end
			
			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end

	self.Text_2_0:setString(string.format(tipStringInfo_role_biography[9], haveActivateCount))
end

function RoleBiographyDescription:updateRightBottom()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local biographyDatas = RoleBiographyHandle.getAllBiographyDatasByPropId(self._propId)
	for i, v in ipairs(biographyDatas) do
		local cell = state_machine.excute("role_biography_description_cell_create", 0, {index = i, data = v})
		ListView_1:addChild(cell)
	end
	self.ListView_1_poy = self.ListView_1:getInnerContainer():getPositionY()

	ListView_1:jumpToTop()
	ListView_1:requestRefreshView()
end

-- @onUpdate(dt)
function RoleBiographyDescription:onUpdate(dt)
	if self.ListView_1 ~= nil then
		local size = self.ListView_1:getContentSize()
		local posY = self.ListView_1:getInnerContainer():getPositionY()
		if self.ListView_1_poy == posY then
			return
		end
		self.ListView_1_poy = posY
		local items = self.ListView_1:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then	
				v:unload()
			else	
				v:reload()				
			end
		end
	end
end

function RoleBiographyDescription:onUpdateDraw()
	local root = self.roots[1]

	-- 印记名称
	self.Text_character = ccui.Helper:seekWidgetByName(root, "Text_character")

	-- 物品描述
	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")

	-- 已激活列传数量
	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")

	-- 忍列传名称
	self.Text_teams = {}
	for i = 1, 8 do
		local Text_team = ccui.Helper:seekWidgetByName(root, "Text_team_"..i)
		table.insert(self.Text_teams, Text_team)
	end

	-- 详情列表容器
	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")

	self.Text_imprint = ccui.Helper:seekWidgetByName(root, "Text_imprint")

	self:updateUI()
end

function RoleBiographyDescription:onEnterTransitionFinish()
	-- 加载NinjaBiographiesImprintWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_imprint = res/cultivate/ninja_biographies/ninja_biographies_imprint.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_imprint.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 去获取按钮
	self.Button_to_get = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_to_get"), nil,
	{
		terminal_name = "role_biography_description_to_get",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 去合成按钮
	self.Button_hc = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_hc"), nil,
	{
		terminal_name = "role_biography_description_to_compound",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_buy_power_close = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy_power_close"), nil,
	{
		terminal_name = "role_biography_description_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyDescription:onExit()
	-- 释放RoleBiographyDescriptionWindow界面资源.
	state_machine.remove("role_biography_description_open")
	state_machine.remove("role_biography_description_close")
	state_machine.remove("role_biography_description_show")
	state_machine.remove("role_biography_description_hide")
	state_machine.remove("role_biography_description_to_get")
	state_machine.remove("role_biography_description_to_compound")
end

function RoleBiographyDescription:close()
	-- window event : close.
	
end

function RoleBiographyDescription:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
