--[[ ----------------------------------------------------------------------------
-- 组合卡列表界面
--]] ----------------------------------------------------------------------------
CombinationCardWindow = class("CombinationCardWindowClass", Window)

-- 打开窗口
local combination_card_window_open_terminal = {
	_name = "combination_card_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CombinationCardWindowClass") then
			fwin:open(CombinationCardWindow:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local combination_card_window_close_terminal = {
	_name = "combination_card_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		state_machine.excute("notification_center_update", 0, "push_notification_cultivate_combination_card")
		fwin:close(fwin:find("CombinationCardWindowClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combination_card_window_open_terminal)
state_machine.add(combination_card_window_close_terminal)
state_machine.init()

-- 构造器
function CombinationCardWindow:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.currentScrollView = nil
	self.ship_list_data = nil
	-- load lua files.
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardHandle")
	app.load("client.l_digital.cells.cultivate.combinationCard.combination_card_cell")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardTabWindow")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardBuy")
	app.load("client.l_digital.cultivate.combinationCard.CombinationCardInfo")
	-- Initialize combination card window page state machine.
	local function init_combination_card_window_terminal()

		-- 显示窗口
		local combination_card_window_show_terminal = {
			_name = "combination_card_window_show",
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
		local combination_card_window_hide_terminal = {
			_name = "combination_card_window_hide",
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

		--左滑右滑
		local combination_card_left_right_terminal = {
			_name = "combination_card_left_right",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					instance.currentScrollView:jumpToPercentHorizontal(params._datas.index * 100)
				end

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		--下一个卡牌下标
		local hero_list_view_get_next_ship_info_terminal = {
            _name = "hero_list_view_get_next_ship_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
            	return instance:getNextPageShipInfo(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 刷新界面数据
		local combination_card_refresh_list_terminal = {
            _name = "combination_card_refresh_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
			_invoke = function(terminal, instance, params)
				if instance then
					local function responseInitCallBack( response )
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
								response.node:onUpdateDraw()
							end
						end
					end
					protocol_command.combine_ship_init.param_list = "" 
					NetworkManager:register(protocol_command.combine_ship_init.code, nil, nil, nil, instance, responseInitCallBack, false, nil)
				end
				
            	return true
            end,
            _terminal = nil,
            _terminals = nil
		}
		
		--刷新滑动列表位置
		local combination_card_local_list_terminal = {
			_name = "combination_card_local_list",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local chooseIndex = params
				local percentNum = params/(#instance.ship_list_data)*100
				if instance then
					instance.currentScrollView:jumpToPercentHorizontal(percentNum)
				end

				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(combination_card_window_show_terminal)
		state_machine.add(combination_card_window_hide_terminal)
		state_machine.add(combination_card_left_right_terminal)
		state_machine.add(hero_list_view_get_next_ship_info_terminal)
		state_machine.add(combination_card_refresh_list_terminal)
		state_machine.add(combination_card_local_list_terminal)
		state_machine.init()
	end
	-- call func init combination card window state machine.
	init_combination_card_window_terminal()
end



function CombinationCardWindow:onUpdateDraw()
	local root = self.roots[1]

	-- 组合卡容器
	local ListViewCard = self.ListView_card
    ListViewCard:removeAllItems()

	local cardListData = self:sortShip(CombinationCardHandle.getCardList())
	self.ship_list_data = cardListData
	local index = 1
	for i,v in ipairs(cardListData) do
		local cell = CombinationCardCell:createCell()
		cell:init({v,index})
		ListViewCard:addChild(cell)
		index = index + 1
	end
	-- 敬请期待
	local cell = CombinationCardCell:createCell()
	cell:init({nil,index,0})
	ListViewCard:addChild(cell)
	ListViewCard:requestRefreshView()
	
	self.currentScrollView = ListViewCard

	
	
	--用户信息
	local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)
end

-- 排序
function CombinationCardWindow:sortShip(cardListData)
	local function fightingCapacity(a,b)
		local al = tonumber(a.ship_order)
		local bl = tonumber(b.ship_order)
		local result = false
		if al < bl then
			result = true
		end
		return result 
	end
	
	local unlockListData = {}
	-- TODO:
	for i,v in ipairs(_ED.combine_card_list_info.comb_mould_list) do
		if v.isUnlock then
			table.insert(unlockListData,v.shipId)
		end
	end
	

	local arrLockList = {}		--未解锁
	local arrUnlockList ={}		--已解锁
	local arrResultList = {}
	for i,v in ipairs(cardListData) do
		local breakFlag = false
		local temp = {}
		for k,m in ipairs(unlockListData) do
			if tonumber(m) == tonumber(v) then
				
				temp.ship_id = tonumber(v)
				temp.ship_order = CombinationCardHandle.getSortByShipId(v)
				table.insert(arrUnlockList,temp)
				breakFlag = true
				break
			end
		end
		if not breakFlag then
			temp.ship_id = tonumber(v)
			temp.ship_order = CombinationCardHandle.getSortByShipId(v)
			table.insert(arrLockList,temp)
		end
	end
	
	table.sort(arrLockList, fightingCapacity)
	table.sort(arrUnlockList, fightingCapacity)

	for i,v in ipairs(arrUnlockList) do
		table.insert( arrResultList, ""..v.ship_id)
	end

	for j,m in ipairs(arrLockList) do
		table.insert( arrResultList, ""..m.ship_id)
	end

	return arrResultList
end


function CombinationCardWindow:onUpdate( dt )
	if self.currentScrollView then
		local posX = self.currentScrollView:getInnerContainer():getPositionX()
		if posX <= -20 then
			self.leftButton:setVisible(true)
		else
			self.leftButton:setVisible(false)
		end
		if posX >= self.currentScrollView:getContentSize().width - self.currentScrollView:getInnerContainer():getContentSize().width + 20 then
			self.rightButton:setVisible(true)
		else
			self.rightButton:setVisible(false)
		end
	end
    
end

--获取下一个卡牌数据
function CombinationCardWindow:getNextPageShipInfo( _chooseIndex )
	local chooseIndex =  _chooseIndex
	if 1 > chooseIndex then
		chooseIndex = #self.ship_list_data
	elseif #self.ship_list_data < chooseIndex then
		chooseIndex = 1
	end

	state_machine.excute("combination_card_local_list",0,chooseIndex)
	local ship_id = nil
	local index = 1
	for k,v in pairs(self.ship_list_data) do
		if index == tonumber(chooseIndex)  then
			ship_id = v
		end
		index = index + 1
	end
	
	return zstring.tonumber(ship_id), chooseIndex
end

function CombinationCardWindow:onEnterTransitionFinish()
	-- 加载CombinationCardWindowWindow界面资源.
	-- res.cultivate.combinationCard.Combination_card = res/cultivate/combinationCard/Combination_card.csb
	local csbNode = csb.createNode("cultivate/Combination_card/Combination_card.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 退出按钮
	self.Button_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), nil,
	{
		terminal_name = "combination_card_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 向右按钮
	self.rightButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_r"), nil,
	{
		terminal_name = "combination_card_left_right",
		terminal_state = 0,
		touch_black = true,
        index = 1,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 向左按钮
	self.leftButton = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_l"), nil,
	{
		terminal_name = "combination_card_left_right",
		terminal_state = 0,
		touch_black = true,
        index = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	-- 提示按钮
	self.Button_help = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_bangzhu"), nil,
	{
		terminal_name = "comb_card_Info_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self.ListView_card = ccui.Helper:seekWidgetByName(root, "ListView_liebiao")
	-- TODO:
	local function responseCallBack( response )
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			self:onUpdateDraw()
		end
	end
	protocol_command.combine_ship_init.param_list = "" 
	NetworkManager:register(protocol_command.combine_ship_init.code, nil, nil, nil, instance, responseCallBack, false, nil)
end

-- 对象初始化
function CombinationCardWindow:init(params)
	
	
	return self
end

function CombinationCardWindow:onExit()
	-- 释放CombinationCardWindowWindow界面资源.
	state_machine.remove("combination_card_window_show")
	state_machine.remove("combination_card_window_hide")
	state_machine.remove("combination_card_left_right")
	state_machine.remove("hero_list_view_get_next_ship_info")
	state_machine.remove("combination_card_refresh_list")
	state_machine.remove("combination_card_local_list")
end

function CombinationCardWindow:close()
	-- window event : close.
	
end

function CombinationCardWindow:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
