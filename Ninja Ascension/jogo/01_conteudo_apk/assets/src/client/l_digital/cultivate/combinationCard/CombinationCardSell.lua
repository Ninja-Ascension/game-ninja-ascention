--[[ ----------------------------------------------------------------------------
-- 组合卡背包
--]] ----------------------------------------------------------------------------
CombinationCardSell = class("CombinationCardSellClass", Window)

-- 打开窗口
local combination_card_sell_window_open_terminal = {
	_name = "combination_card_sell_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CombinationCardSellClass") then
			fwin:open(CombinationCardSell:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local combination_card_sell_window_close_terminal = {
	_name = "combination_card_sell_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if "" ~= params then
			local soltId = params._datas.solt_id
			state_machine.excute("combination_card_unlock_window_refresh",0,soltId)
			fwin:close(fwin:find("CombinationCardSellClass"))
		else
			fwin:close(fwin:find("CombinationCardSellClass"))
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combination_card_sell_window_open_terminal)
state_machine.add(combination_card_sell_window_close_terminal)
state_machine.init()

-- 构造器
function CombinationCardSell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	
	-- var
	self.solt_info = nil
	-- load lua files.
    app.load("client.l_digital.cells.cultivate.combinationCard.combination_card_item_cell")
	-- Initialize combination card sell page state machine.
	local function init_combination_card_sell_terminal()
		-- 打开角色创建窗口
		local combination_card_sell_open_terminal = {
			_name = "combination_card_sell_open",
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
		local combination_card_sell_close_terminal = {
			_name = "combination_card_sell_close",
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
		local combination_card_sell_show_terminal = {
			_name = "combination_card_sell_show",
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
		local combination_card_sell_hide_terminal = {
			_name = "combination_card_sell_hide",
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

		state_machine.add(combination_card_sell_open_terminal)
		state_machine.add(combination_card_sell_close_terminal)
		state_machine.add(combination_card_sell_show_terminal)
		state_machine.add(combination_card_sell_hide_terminal)
		state_machine.init()
	end
	-- call func init combination card sell state machine.
	init_combination_card_sell_terminal()
end



function CombinationCardSell:onUpdateDraw()
	local root = self.roots[1]
    -- 滚动容器
	self.currentScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_sell_props")
	local ScrollView_card = self.currentScrollView
    ScrollView_card:removeAllChildren(true)
    local horizontalNumber = 5
    local panel = ScrollView_card:getInnerContainer()
    panel:setContentSize(ScrollView_card:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = ScrollView_card:getInnerContainerSize()

    local tHeight = 0
    local cellHeight = 0
    
    local wPosition = sWidth/horizontalNumber
    local tWidth = 0
    local Hlindex = 0
	local number = 0
	number = CombinationCardHandle.getCanAddCardUp(self.solt_info.card_id,self.solt_info.solt_id,self.solt_info.ship_mould_id_can,self.solt_info.ship_mould_id_have)

    local m_number = math.ceil(number/horizontalNumber)
    cellHeight = m_number*(ScrollView_card:getContentSize().width/horizontalNumber)
	sHeight = math.max(sHeight, cellHeight)

    panel:setContentSize(ScrollView_card:getContentSize().width, sHeight)
	local index = 1
	if 0 < tonumber(self.solt_info.ship_mould_id_have) then
		-- 可以下阵
		local cell = state_machine.excute("combination_card_item_cell_create",0,{self.solt_info,nil})
		panel:addChild(cell)
		tWidth = tWidth + wPosition
		if (index-1)%horizontalNumber == 0 then
			Hlindex = Hlindex+1
			tWidth = 0
			tHeight = sHeight - wPosition*Hlindex  
		end
		if index <= horizontalNumber then
			tHeight = sHeight - wPosition
		end
		index = index + 1
		cell:setPosition(cc.p(tWidth, tHeight))
	end
	-- 任意槽位
	if -1 == self.solt_info.ship_mould_id_can then
		local shipDatas = CombinationCardHandle.getCanAddCardDatas(self.solt_info.card_id,self.solt_info.solt_id)
		for k,v in pairs(shipDatas) do
			local cell = state_machine.excute("combination_card_item_cell_create",0,{self.solt_info,v.ship_id})
			panel:addChild(cell)
			tWidth = tWidth + wPosition
			if (index-1)%horizontalNumber == 0 then
				Hlindex = Hlindex+1
				tWidth = 0
				tHeight = sHeight - wPosition*Hlindex  
			end
			if index <= horizontalNumber then
				tHeight = sHeight - wPosition
			end
			index = index + 1
			cell:setPosition(cc.p(tWidth, tHeight))
		end
									
	else	-- 固定槽位
		if 0 >= tonumber(self.solt_info.ship_mould_id_have) then
			local shipData = CombinationCardHandle.getCanAddFixCardDatas(self.solt_info.ship_mould_id_can)
			if shipData then
				local cell = state_machine.excute("combination_card_item_cell_create",0,{self.solt_info,shipData.ship_id})
				panel:addChild(cell)
				tWidth = tWidth + wPosition
				if (index-1)%horizontalNumber == 0 then
					Hlindex = Hlindex+1
					tWidth = 0
					tHeight = sHeight - wPosition*Hlindex  
				end
				if index <= horizontalNumber then
					tHeight = sHeight - wPosition
				end
				index = index + 1
				cell:setPosition(cc.p(tWidth, tHeight))
			end
		end
	end

	local panelHeight = panel:getContentSize().width
	local scorollHeight = ScrollView_card:getContentSize().height
	ScrollView_card:jumpToTop()
	self.currentScrollViewInnerContainer = ScrollView_card:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()
	state_machine.excute("connecting_view_window_close",0,"")
end

function CombinationCardSell:onUpdate(dt)
	if self.currentScrollView ~= nil and self.currentScrollViewInnerContainer ~= nil then
		local size = self.currentScrollView:getContentSize()
		local posY = self.currentScrollViewInnerContainer:getPositionY()
		if self.currentScrollViewInnerContainerPosY == posY then
			return
		end
		self.currentScrollViewInnerContainerPosY = posY
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

function CombinationCardSell:onEnterTransitionFinish()
	-- 加载CombinationCardsellWindow界面资源.
	-- res.cultivate.combinationCard.Combination_card_sell = res/cultivate/combinationCard/Combination_card_sell.csb
	local csbNode = csb.createNode("cultivate/Combination_card/Combination_card_sell.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭按钮
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "combination_card_sell_window_close",
		terminal_state = 0,
		solt_id = self.solt_info.solt_id,
		isPressedActionEnabled = true,
	}, nil, 0)	
    

	self:onUpdateDraw()
end

-- 对象初始化
-- {card_id,solt_id,ship_mould_id_can,ship_mould_id_have}
function CombinationCardSell:init(params)
	self.solt_info = params
	return self
end

function CombinationCardSell:onExit()
	-- 释放CombinationCardsellWindow界面资源.
	state_machine.remove("combination_card_sell_open")
	state_machine.remove("combination_card_sell_close")
	state_machine.remove("combination_card_sell_show")
	state_machine.remove("combination_card_sell_hide")
end

function CombinationCardSell:close()
	-- window event : close.
	
end

function CombinationCardSell:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------