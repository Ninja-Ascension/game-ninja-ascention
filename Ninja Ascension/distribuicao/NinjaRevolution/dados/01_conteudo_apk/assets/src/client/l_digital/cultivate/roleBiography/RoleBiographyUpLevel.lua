--[[ ----------------------------------------------------------------------------
-- 升星
--]] ----------------------------------------------------------------------------
RoleBiographyUpLevel = class("RoleBiographyUpLevelClass", Window)

-- 打开窗口
local role_biography_up_level_window_open_terminal = {
	_name = "role_biography_up_level_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyUpLevelClass") then
			fwin:open(RoleBiographyUpLevel:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_up_level_window_close_terminal = {
	_name = "role_biography_up_level_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyUpLevelClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_up_level_window_open_terminal)
state_machine.add(role_biography_up_level_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyUpLevel:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies report page state machine.
	local function init_role_biography_up_level_terminal()
		-- 打开角色创建窗口
		local role_biography_up_level_open_terminal = {
			_name = "role_biography_up_level_open",
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
		local role_biography_up_level_close_terminal = {
			_name = "role_biography_up_level_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_up_level_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_up_level_show_terminal = {
			_name = "role_biography_up_level_show",
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
		local role_biography_up_level_hide_terminal = {
			_name = "role_biography_up_level_hide",
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

		local role_biography_up_level_sure_terminal = {
			_name = "role_biography_up_level_sure",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					state_machine.lock("role_biography_up_level_sure")

					local biographyId = params._datas._biographyId
					local function responseCallback(response)
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							-- 升星成功
							state_machine.excute("role_biography_up_level_success_window_open", 0, biographyId)

							-- 清空原有属性
							RoleBiographyHandle.clearTotalPropertyData()
							-- 战力飘字
							_ED.offCalculateTotalFight = false
							smFightingChange()

							-- 刷新界面
							state_machine.excute("role_biography_refresh_ui", 0, nil)

							state_machine.excute("notification_center_update",0,"push_notification_role_biography")

							state_machine.unlock("role_biography_up_level_sure")

							state_machine.excute("role_biography_up_level_close", 0, nil)
						else
							_ED.offCalculateTotalFight = false
							state_machine.unlock("role_biography_up_level_sure")
						end
					end
					_ED.offCalculateTotalFight = true
					protocol_command.biographies_advance.param_list = "" .. biographyId
					NetworkManager:register(protocol_command.biographies_advance.code, nil, nil, nil, instance, responseCallback, false, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_up_level_open_terminal)
		state_machine.add(role_biography_up_level_close_terminal)
		state_machine.add(role_biography_up_level_show_terminal)
		state_machine.add(role_biography_up_level_hide_terminal)
		state_machine.add(role_biography_up_level_sure_terminal)
		state_machine.init()
	end
	-- call func init ninja biographies report state machine.
	init_role_biography_up_level_terminal()
end

-- 对象初始化
function RoleBiographyUpLevel:init(params)
	self._biographyId = params

	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RoleBiographyUpLevel:updateUI()
	local biographyId = self._biographyId

	-- local pic = dms.int(dms["biographies_mould"], biographyId, biographies_mould.pic)
	-- self.Panel_player_icon_1:removeAllChildren(true)
	-- self.Panel_player_icon_1:setVisible(false)
	-- local headSp = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic))
	-- headSp:setAnchorPoint(0.5, 0.5)
	-- headSp:setPosition(cc.p(self.Panel_player_icon_1:getContentSize().width/2, self.Panel_player_icon_1:getContentSize().height/2))
	-- self.Panel_player_icon_1:addChild(headSp)

	local startLevel = RoleBiographyHandle.getAllBiographyInfo()[self._biographyId]
	if startLevel then
		for i, v in ipairs(self.Image_stars) do
			v:setVisible(startLevel >= i)
		end
		self.Panel_star:setVisible(true)
	else
		self.Panel_star:setVisible(false)
	end

	local name_mould_id = dms.int(dms["biographies_mould"], biographyId, biographies_mould.name)
	local word_info = dms.element(dms["word_mould"], name_mould_id)
	local name = word_info[3]
	self.Text_name:setString(name)

	self:updateList()
	self:updateCostList()
end

function RoleBiographyUpLevel:updateCostList()
	local costStr = RoleBiographyHandle.getUpLevelCostById(self._biographyId)

	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	if costStr and costStr ~= "-1" then
		local cost = zstring.splits(costStr, "|", ",")
		for i, v in ipairs(cost) do
			local cell = self:addResourcesIconCell(v)
			ListView_1:addChild(cell)
		end

		ListView_1:jumpToLeft()
		ListView_1:requestRefreshView()
	end
end

function RoleBiographyUpLevel:updateList()
	local ListView_item = self.ListView_item
	ListView_item:removeAllItems()
	
	local data = self:getPropertyList()
	for i, v in ipairs(data) do
		local cell = RoleBiographyHandle.addPropertyCell(v, 5)
		ListView_item:addChild(cell)
	end

	ListView_item:jumpToTop()
	ListView_item:requestRefreshView()
end

function RoleBiographyUpLevel:getPropertyList()
	local biographyId = self._biographyId

	local property_add = RoleBiographyHandle.getUpLevelPropertyById(biographyId)
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

function RoleBiographyUpLevel:addResourcesIconCell(propData)
	local cell = ResourcesIconCell:createCell()
	local rewardType = tonumber(propData[1])
	if 13 == rewardType then
		local extraTable = {}
		if propData[4] ~= nil and tonumber(propData[4]) ~= -1 then
			extraTable.shipStar = tonumber(propData[4])
		else
			extraTable.shipStar = 0
		end
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true, true, 1, extraTable)
	else
		cell:init(rewardType, tonumber(propData[3]), tonumber(propData[2]), nil, nil, true ,true, 1)
	end
	return cell
end

function RoleBiographyUpLevel:onUpdateDraw()
	local root = self.roots[1]

	self.ListView_item = ccui.Helper:seekWidgetByName(root, "ListView_item")

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")

	-- self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")

	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	self.Image_stars = {}
	for i = 1, 7 do
		local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
		table.insert(self.Image_stars, Image_star)
	end

	self.Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")

	self:updateUI()
end


function RoleBiographyUpLevel:onEnterTransitionFinish()
	-- 加载RoleBiographyUpLevelWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_star = res/cultivate/ninja_biographies/ninja_biographies_star.csb
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_star.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)


	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_up_level_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.Button_up = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_up"), nil,
	{
		terminal_name = "role_biography_up_level_sure",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_biographyId = self._biographyId
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyUpLevel:onExit()
	-- 释放RoleBiographyUpLevelWindow界面资源.
	state_machine.remove("role_biography_up_level_open")
	state_machine.remove("role_biography_up_level_close")
	state_machine.remove("role_biography_up_level_show")
	state_machine.remove("role_biography_up_level_hide")
	state_machine.remove("role_biography_up_level_sure")
end

function RoleBiographyUpLevel:close()
	-- window event : close.
	
end

function RoleBiographyUpLevel:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
