--[[ ----------------------------------------------------------------------------
-- 商店界面
--]] ----------------------------------------------------------------------------
CommandWorldShop = class("CommandWorldShopClass", Window)

-- 打开窗口
local command_world_shop_window_open_terminal = {
	_name = "command_world_shop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CommandWorldShopClass") then
			fwin:open(CommandWorldShop:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local command_world_shop_window_close_terminal = {
	_name = "command_world_shop_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CommandWorldShopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(command_world_shop_window_open_terminal)
state_machine.add(command_world_shop_window_close_terminal)
state_machine.init()

-- 构造器
function CommandWorldShop:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 1豪华 2高级 3金币
	self._tabType = 1

	-- load lua files.

	-- Initialize command world shop page state machine.
	local function init_command_world_shop_terminal()
		-- 打开角色创建窗口
		local command_world_shop_open_terminal = {
			_name = "command_world_shop_open",
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
		local command_world_shop_close_terminal = {
			_name = "command_world_shop_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("command_world_shop_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local command_world_shop_show_terminal = {
			_name = "command_world_shop_show",
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
		local command_world_shop_hide_terminal = {
			_name = "command_world_shop_hide",
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

		-- 切换页签
		local command_world_shop_change_page_terminal = {
			_name = "command_world_shop_change_page",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					local tabType = params._datas.tabType
					instance._tabType = tabType

					instance:changePage()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新道具数量
		local command_world_shop_refresh_bottom_prop_num_terminal = {
			_name = "command_world_shop_refresh_bottom_prop_num",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:updateBottomUI()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 刷新商店
		local command_world_shop_refresh_shop_terminal = {
			_name = "command_world_shop_refresh_shop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance ~= nil then
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(command_world_shop_open_terminal)
		state_machine.add(command_world_shop_close_terminal)
		state_machine.add(command_world_shop_show_terminal)
		state_machine.add(command_world_shop_hide_terminal)
		state_machine.add(command_world_shop_change_page_terminal)
		state_machine.add(command_world_shop_refresh_bottom_prop_num_terminal)
		state_machine.add(command_world_shop_refresh_shop_terminal)
		state_machine.init()
	end
	-- call func init command world shop state machine.
	init_command_world_shop_terminal()
end

-- 对象初始化
function CommandWorldShop:init(params)
	-- 跳转类型 默认豪华商店
	self._tabType = params or 1
	-- 金币数
	self.user_gold = _ED.user_info.user_gold

	return self
end

-- 刷新道具数量
function CommandWorldShop:updateBottomUI()
	local costPropDatas = zstring.splits(dms.string(dms["activity_config"], 76, activity_config.param), "|", ",")

	local Text_Donate_Prop_Num = self.Text_Donate_Prop_Num
	for i, v in ipairs(Text_Donate_Prop_Num) do
		local count = getPropAllCountByMouldId(costPropDatas[i][2])
		v:setString(count)
	end

	if tonumber(self.user_gold) > 1000000 then
		self.Text_ghb:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
	else
		self.Text_ghb:setString(self.user_gold)
	end
end

function CommandWorldShop:changePage()
	local tabType = self._tabType

	self.Button_dh_1:setBright(tabType ~= 1)
	self.Button_dh_2:setBright(tabType ~= 2)
	self.Button_dh_3:setBright(tabType ~= 3)

	self:updateScrollView(tabType)
end

function CommandWorldShop:getSortShopInfo(tabType)
	local shopInfo = CommandWorldHandle.getCommandWorldShopInfoByType(tabType)

	local sortData = {}
	
	local function sortFuc(a, b)
		return tonumber(a.index) < tonumber(b.index)
	end

	-- 还有购买次数
	local temp1 = {}
	-- 没有购买次数了
	local temp2 = {}

	for _, v in pairs(shopInfo) do
		if tonumber(v.maxNumber) ~= tonumber(v.currentNumber)then
			table.insert(temp1, v)
		else
			table.insert(temp2, v)
		end
	end

	table.sort(temp1, sortFuc)
	table.sort(temp2, sortFuc)

	for _, v in ipairs(temp1) do
		table.insert(sortData, v)
	end
	for _, v in ipairs(temp2) do
		table.insert(sortData, v)
	end

	-- debug.print_r(sortData)

	return sortData
end

function CommandWorldShop:updateScrollView(tabType)
	local tSortedHeroes = self:getSortShopInfo(tabType)

	local m_ScrollView = self.ScrollView_commodity
	m_ScrollView:removeAllChildren(true)

	local panel = m_ScrollView:getInnerContainer()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)

	local sSize = panel:getContentSize()
	local sHeight = sSize.height
	local sWidth = sSize.width
	local controlSize = m_ScrollView:getInnerContainerSize()
	local nextY = sSize.height
	local nextX = sSize.width
	local tHeight = 0
	local cellHeight = 0
	local tWidth = 0
	local wPosition = sWidth/3

	local Hlindex = 0
	local number = #tSortedHeroes
	local m_number = math.ceil(number/3)

	-- 单个cell高度200是scrollview的一半
	cellHeight = m_number*(m_ScrollView:getContentSize().height/2)

	sHeight = math.max(sHeight, cellHeight)
	panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
	local first = nil
	for j, v in pairs(tSortedHeroes) do
		local cell = state_machine.excute("command_world_shop_list_create", 0, v)
		panel:addChild(cell)

		local realCellHeight = cell:getContentSize().height
		if j == 1 then
			first = cell
		end
		tWidth = tWidth + wPosition

		if (j-1)%3 ==0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - realCellHeight*Hlindex  
		end
		cell:setPosition(cc.p(tWidth,tHeight))
	end
	m_ScrollView:jumpToTop()

	self.currentScrollView = m_ScrollView
	self.currentInnerContainer = self.currentScrollView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function CommandWorldShop:onUpdate(dt)
	if self.user_gold ~= _ED.user_info.user_gold then
		self.user_gold = _ED.user_info.user_gold

		if tonumber(self.user_gold) > 1000000 then
			self.Text_ghb:setString(math.floor(self.user_gold / 1000) .. string_equiprety_name[40])
		else
			self.Text_ghb:setString(self.user_gold)
		end
	end

    if self.currentScrollView ~= nil and self.currentInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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

function CommandWorldShop:onUpdateDraw()
	local root = self.roots[1]

	-- 商店容器
	self.ScrollView_commodity = ccui.Helper:seekWidgetByName(root, "ScrollView_commodity")

	-- 下忍数值
	self.Text_111 = ccui.Helper:seekWidgetByName(root, "Text_111")
	-- 中忍数值
	self.Text_121 = ccui.Helper:seekWidgetByName(root, "Text_121")
	-- 上忍数值
	self.Text_110 = ccui.Helper:seekWidgetByName(root, "Text_110")

	-- 捐献道具的数量（下忍，中忍，上忍）
	self.Text_Donate_Prop_Num = {}
	table.insert(self.Text_Donate_Prop_Num, self.Text_111)
	table.insert(self.Text_Donate_Prop_Num, self.Text_121)
	table.insert(self.Text_Donate_Prop_Num, self.Text_110)

	-- 金币数量
	self.Text_ghb = ccui.Helper:seekWidgetByName(root, "Text_ghb")
	self.zhanli_tili = ccui.Helper:seekWidgetByName(root, "zhanli_tili")
	self.ghb = ccui.Helper:seekWidgetByName(root, "ghb")

	self:updateBottomUI()
	self:changePage()
end

function CommandWorldShop:onEnterTransitionFinish()
	-- 加载CommandWorldShopWindow界面资源.
	-- res.activity.command_world.command_world_shop = res/activity/command_world/command_world_shop.csb
	local csbNode = csb.createNode("activity/command_world/command_world_shop.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 豪华兑换
	self.Button_dh_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dh_1"), nil,
	{
		terminal_name = "command_world_shop_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabType = 1,
	}, nil, 0)	

	-- 高级兑换
	self.Button_dh_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dh_2"), nil,
	{
		terminal_name = "command_world_shop_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabType = 2,
	}, nil, 0)	

	-- 普通兑换
	self.Button_dh_3 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_dh_3"), nil,
	{
		terminal_name = "command_world_shop_change_page",
		terminal_state = 0,
		isPressedActionEnabled = true,
		tabType = 3,
	}, nil, 0)	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "command_world_shop_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 跳转充值
	self.Button_tili_add = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tili_add"), nil,
	{
		terminal_name = "activity_home_recharge_button",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function CommandWorldShop:onExit()
	-- 释放CommandWorldShopWindow界面资源.
	state_machine.remove("command_world_shop_open")
	state_machine.remove("command_world_shop_close")
	state_machine.remove("command_world_shop_show")
	state_machine.remove("command_world_shop_hide")
	state_machine.remove("command_world_shop_change_page")
	state_machine.remove("command_world_shop_refresh_bottom_prop_num")
	state_machine.remove("command_world_shop_refresh_shop")
end

function CommandWorldShop:close()
	-- window event : close.
	
end

function CommandWorldShop:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
