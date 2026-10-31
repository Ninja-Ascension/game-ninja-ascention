--[[ ----------------------------------------------------------------------------
-- 购买弹窗
--]] ----------------------------------------------------------------------------
RoleBiographyBuyProp = class("RoleBiographyBuyPropClass", Window)

-- 打开窗口
local role_biography_buy_window_open_terminal = {
	_name = "role_biography_buy_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RoleBiographyBuyPropClass") then
			fwin:open(RoleBiographyBuyProp:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local role_biography_buy_window_close_terminal = {
	_name = "role_biography_buy_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RoleBiographyBuyPropClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_buy_window_open_terminal)
state_machine.add(role_biography_buy_window_close_terminal)
state_machine.init()

-- 构造器
function RoleBiographyBuyProp:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._select_num = 0
	self._max_select_num = 0

	-- load lua files.

	-- Initialize lim pool buy page state machine.
	local function init_role_biography_buy_terminal()
		-- 打开角色创建窗口
		local role_biography_buy_open_terminal = {
			_name = "role_biography_buy_open",
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
		local role_biography_buy_close_terminal = {
			_name = "role_biography_buy_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_buy_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local role_biography_buy_show_terminal = {
			_name = "role_biography_buy_show",
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
		local role_biography_buy_hide_terminal = {
			_name = "role_biography_buy_hide",
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

		-- 设置最小
		local role_biography_buy_set_min_terminal = {
			_name = "role_biography_buy_set_min",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				 instance:setSelectNum(1)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 设置最大
		local role_biography_buy_set_max_terminal = {
			_name = "role_biography_buy_set_max",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				 instance:setSelectNum(self._max_select_num)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 购买道具
		local role_biography_buy_prop_terminal = {
			_name = "role_biography_buy_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 购买道具数量
				local select_num = instance._select_num
				local buyType_params_1 = instance._buyType_params_1
				local buyType_params_2 = instance._buyType_params_2

				local function responseCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						local getRewardWnd = DrawRareReward:new()
						getRewardWnd:init(7)
						fwin:open(getRewardWnd, fwin._ui)

						-- 刷新道具
						state_machine.excute("role_biography_divine_refresh_ui", 0, 0)
						
						state_machine.excute("role_biography_exchange_close", 0, nil)
						state_machine.excute("role_biography_buy_close", 0, 0)
					end
				end
				-- 金币购买道具
				protocol_command.biographies_buy_prop.param_list = "" .. buyType_params_1 .. "\r\n" .. buyType_params_2 .. "\r\n" .. select_num
				NetworkManager:register(protocol_command.biographies_buy_prop.code, nil, nil, nil, instance, responseCallback, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 拖动滑动条
		local role_biography_buy_use_update_terminal = {
			_name = "role_biography_buy_use_update",
			_init = function (terminal) 

			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local Slider_number_xz = instance.Slider_number_xz
				local select_num = math.ceil(tonumber(Slider_number_xz:getPercent()) * instance._max_select_num / 100)
				instance:setSelectNum(select_num)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_buy_open_terminal)
		state_machine.add(role_biography_buy_close_terminal)
		state_machine.add(role_biography_buy_show_terminal)
		state_machine.add(role_biography_buy_hide_terminal)
		state_machine.add(role_biography_buy_set_min_terminal)
		state_machine.add(role_biography_buy_set_max_terminal)
		state_machine.add(role_biography_buy_prop_terminal)
		state_machine.add(role_biography_buy_use_update_terminal)

		state_machine.init()
	end
	-- call func init lim pool buy state machine.
	init_role_biography_buy_terminal()
end

-- 对象初始化
function RoleBiographyBuyProp:init(params)
	self._buyType_params_1 = params[1]
	self._buyType_params_2 = params[2]

	self._rewads = params[3]

	self._costProp = self._rewads[1]
	self._getProp = self._rewads[2]

	self._unit_price = tonumber(self._costProp[3])
	self._max_select_num = self:getMaxSelectNum()
	return self
end

-- 可买的最大数量
function RoleBiographyBuyProp:getMaxSelectNum()
	local haveCount = 0
	local costPropType = tonumber(self._costProp[1])
	if costPropType == 1 then
		haveCount = tonumber(_ED.user_info.user_silver)
	elseif costPropType == 2 then
		haveCount = tonumber(_ED.user_info.user_gold)
	end

	local maxNum = math.floor(haveCount / self._unit_price)

	-- 购买一次上限999 购买十次上限99
	local maxLimit = self._buyType_params_2 == 0 and 999 or 99

	return math.min(maxNum, maxLimit)
end

function RoleBiographyBuyProp:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end
    local percent = math.floor(self._select_num / self._max_select_num*100)
    self:updateSliderInfo(percent)
end

function RoleBiographyBuyProp:updateSliderInfo(percent)
	if self._max_select_num > 0 and self._select_num == 0 then
		self._select_num = 1
	end
	self.Slider_number_xz:setPercent(percent)
	-- 数量
	local Text_packs_use_n = self.Text_packs_use_n
	Text_packs_use_n:setString(self._select_num.."/"..self._max_select_num)

	-- 总价
	local Text_price = self.Text_price
	local totalPrice = self._unit_price * self._select_num
	if tonumber(totalPrice) > 1000000 then
		Text_price:setString(math.floor(totalPrice / 1000) .. string_equiprety_name[40])
	else
		Text_price:setString(totalPrice)
	end
end

function RoleBiographyBuyProp:updateUI()
	-- 道具图标
	local Panel_packs_props_icon = self.Panel_packs_props_icon
	Panel_packs_props_icon:removeAllChildren(true)

	local propInfo = self._getProp
	local propID = tonumber(propInfo[2])
	local cell = self:addResourcesIconCell(propInfo)
	Panel_packs_props_icon:addChild(cell)

	-- 道具名称
	local Text_packs_props_name = self.Text_packs_props_name
	local name = setThePropsIcon(propID)[2]
	Text_packs_props_name:setString(name)

	local quality = dms.int(dms["prop_mould"], propID, prop_mould.prop_quality) + 1
	Text_packs_props_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1], tipStringInfo_quality_color_Type[quality][2], tipStringInfo_quality_color_Type[quality][3]))

	-- 拥有数量
	local Text_packs = self.Text_packs
	local havePropNum = getPropAllCountByMouldId(propID)
	Text_packs:setString(havePropNum)

	local costPropType = tonumber(self._costProp[1])
	if costPropType == 1 then
		self.Image_zuanshi_2:loadTexture("images/ui/icon/jinbi.png")
	elseif costPropType == 2 then
		self.Image_zuanshi_2:loadTexture("images/ui/icon/zuanshi.png")
	end

	-- 滑动选择
	local Slider_number_xz = self.Slider_number_xz
	local function percentChangedEvent(sender,eventType)
		if eventType == ccui.SliderEventType.percentChanged then
			state_machine.excute("role_biography_buy_use_update", 0, {sender:getPercent()})
		end
	end
	Slider_number_xz:addEventListener(percentChangedEvent)
end

function RoleBiographyBuyProp:addResourcesIconCell(propData)
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

function RoleBiographyBuyProp:onUpdateDraw()
	local root = self.roots[1]

	-- 道具拥有个数
	self.Text_packs = ccui.Helper:seekWidgetByName(root, "Text_packs")

	-- 道具名
	self.Text_packs_props_name = ccui.Helper:seekWidgetByName(root, "Text_packs_props_name")

	-- 购买滑动条
	self.Slider_number_xz = ccui.Helper:seekWidgetByName(root, "Slider_number_xz")

	-- 购买数量
	self.Text_packs_use_n = ccui.Helper:seekWidgetByName(root, "Text_packs_use_n")

	-- 需要金币数量
	self.Text_price = ccui.Helper:seekWidgetByName(root, "Text_price")

	-- 道具图标
	self.Panel_packs_props_icon = ccui.Helper:seekWidgetByName(root, "Panel_packs_props_icon")

	self.Image_zuanshi_2 = ccui.Helper:seekWidgetByName(root, "Image_zuanshi_2")

	self:setSelectNum(1)
	self:updateUI()
end

function RoleBiographyBuyProp:onEnterTransitionFinish()
	-- 加载RoleBiographyBuyPropWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_buy = cultivate/ninja_biographies/ninja_biographies_buy
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_buy.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 最小个数
	self.Button_min = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_min"), nil,
	{
		terminal_name = "role_biography_buy_set_min",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 最大个数
	self.Button_max = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_max"), nil,
	{
		terminal_name = "role_biography_buy_set_max",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 购买
	self.Button_buy = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"), nil,
	{
		terminal_name = "role_biography_buy_prop",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "role_biography_buy_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RoleBiographyBuyProp:onExit()
	-- 释放RoleBiographyBuyPropWindow界面资源.
	state_machine.remove("role_biography_buy_open")
	state_machine.remove("role_biography_buy_close")
	state_machine.remove("role_biography_buy_show")
	state_machine.remove("role_biography_buy_hide")
	state_machine.remove("role_biography_buy_set_min")
	state_machine.remove("role_biography_buy_set_max")
	state_machine.remove("role_biography_buy_prop")
	state_machine.remove("role_biography_buy_use_update")
end

function RoleBiographyBuyProp:close()
	-- window event : close.
	
end

function RoleBiographyBuyProp:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
