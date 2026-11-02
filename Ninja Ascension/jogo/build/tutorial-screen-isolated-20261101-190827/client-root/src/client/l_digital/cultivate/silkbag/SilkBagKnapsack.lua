--[[ ----------------------------------------------------------------------------
-- 锦囊背包界面
--]] ----------------------------------------------------------------------------
SilkBagKnapsack = class("SilkBagKnapsackClass", Window)

-- 打开窗口
local silk_bag_knapsack_window_open_terminal = {
	_name = "silk_bag_knapsack_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SilkBagKnapsackClass") then
			fwin:open(SilkBagKnapsack:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local silk_bag_knapsack_window_close_terminal = {
	_name = "silk_bag_knapsack_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SilkBagKnapsackClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(silk_bag_knapsack_window_open_terminal)
state_machine.add(silk_bag_knapsack_window_close_terminal)
state_machine.init()

-- 构造器
function SilkBagKnapsack:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self.scroll_view = nil
	self.scroll_view_poy = nil
	self._open_type = nil			-- 1:专属 2:普通 3:护佑	
	self._exclusive_type = nil		--打开的专属锦囊的模型ID
	-- var

	-- load lua files.

	app.load("client.l_digital.cells.cultivate.silkbag.sm_cultivate_silkbag_prop_icon_cell")
	
	-- Initialize silk bag knapsack page state machine.
	local function init_silk_bag_knapsack_terminal()
		-- 打开角色创建窗口
		local silk_bag_knapsack_open_terminal = {
			_name = "silk_bag_knapsack_open",
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
		local silk_bag_knapsack_close_terminal = {
			_name = "silk_bag_knapsack_close",
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
		local silk_bag_knapsack_show_terminal = {
			_name = "silk_bag_knapsack_show",
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
		local silk_bag_knapsack_hide_terminal = {
			_name = "silk_bag_knapsack_hide",
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

		-- 刷新背包
		local silk_bag_knapsack_update_terminal = {
			_name = "silk_bag_knapsack_update",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:onUpdateDraw()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(silk_bag_knapsack_open_terminal)
		state_machine.add(silk_bag_knapsack_close_terminal)
		state_machine.add(silk_bag_knapsack_show_terminal)
		state_machine.add(silk_bag_knapsack_hide_terminal)
		state_machine.add(silk_bag_knapsack_update_terminal)
		state_machine.init()
	end
	-- call func init silk bag knapsack state machine.
	init_silk_bag_knapsack_terminal()
end

-- 对象初始化
function SilkBagKnapsack:init(params)
	if params and "" ~= params then
		self._open_type = params.openType 
		self._exclusive_type = params.exclusiveId
	end
	return self
end

function SilkBagKnapsack:onUpdateDraw()
	local root = self.roots[1]
	if nil == _ED.silkbag_pack_info then
    	return
    end
	-- 滚动容器
	local ScrollView_silk_bag = ccui.Helper:seekWidgetByName(root, "ScrollView_silk_bag")

    ScrollView_silk_bag:removeAllChildren(true)

    local horizontalNumber = 6
    local panel = ScrollView_silk_bag:getInnerContainer()
    panel:setContentSize(ScrollView_silk_bag:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = ScrollView_silk_bag:getInnerContainerSize()

    local tHeight = 0
    local cellHeight = 0
    
    local wPosition = sWidth/horizontalNumber
    local tWidth = 0
    local Hlindex = 0
    local number = 0
    for k,v in pairs(_ED.silkbag_pack_info) do
		if -1 == v.onUseIndex then
			local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)
			if self._open_type == 1 then		--专属
				local eType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.exclusive_id)
				if mType == 2 and self._exclusive_type == eType then
					number = number+1
				end
			elseif self._open_type == 2 then 	-- 普通
				if mType == 1 then
					number = number+1
				end
			elseif self._open_type == 3 then 	-- 护佑
				if mType == 3 then 
					number = number+1
				end
			end
    	end
    end
    local m_number = math.ceil(number/horizontalNumber)
    cellHeight = m_number*(ScrollView_silk_bag:getContentSize().width/horizontalNumber)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(ScrollView_silk_bag:getContentSize().width, sHeight)
    
    local index = 1
	for j, v in pairs(_ED.silkbag_pack_info) do
			
		if -1 == tonumber(v.onUseIndex) then
			local mType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.mould_type)
				--专属锦囊列表
			if self._open_type == 1 then
				local excluShipId = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.exclusive_id)
				if mType == 2 and self._exclusive_type == excluShipId then
					local cell = SmCultivateSilkbagPropIconCell:createCell()
					local propInfo = {}
					propInfo.addBaseProperty = v.addBaseProperty
					propInfo.level = v.level
					cell:init(-1,v.silkBagMouldId,v.id,propInfo)
					panel:addChild(cell)
					tWidth = tWidth + wPosition
					if (index-1)%horizontalNumber == 0 then
						Hlindex = Hlindex+1
						tWidth = 0
						tHeight = sHeight - (wPosition + 2)*Hlindex  
					end
					if index <= horizontalNumber then
						tHeight = sHeight - wPosition
					end
					index = index + 1
					cell:setPosition(cc.p(tWidth, tHeight))
				end
			elseif self._open_type == 2 then --普通锦囊
				local mouldType = dms.int(dms["ship_silk_bag_mould"],tonumber(v.silkBagMouldId),ship_silk_bag_mould.exclusive_id)
				if mType == 1 and mouldType == - 1 then
					local cell = SmCultivateSilkbagPropIconCell:createCell()
					local propInfo = {}
					propInfo.addBaseProperty = v.addBaseProperty
					propInfo.level = v.level
					cell:init(-1,v.silkBagMouldId,v.id,propInfo)
					panel:addChild(cell)
					tWidth = tWidth + wPosition
					if (index-1)%horizontalNumber == 0 then
						Hlindex = Hlindex+1
						tWidth = 0
						tHeight = sHeight - (wPosition + 2)*Hlindex  
					end
					if index <= horizontalNumber then
						tHeight = sHeight - wPosition
					end
					index = index + 1
					cell:setPosition(cc.p(tWidth, tHeight))
				end
			elseif self._open_type == 3 then 	-- 护佑锦囊
				if mType == 3 then 
					local cell = SmCultivateSilkbagPropIconCell:createCell()
					local propInfo = {}
					propInfo.addBaseProperty = v.addBaseProperty
					propInfo.level = v.level
					cell:init(-1,v.silkBagMouldId,v.id,propInfo)
					panel:addChild(cell)
					tWidth = tWidth + wPosition
					if (index-1)%horizontalNumber == 0 then
						Hlindex = Hlindex+1
						tWidth = 0
						tHeight = sHeight - (wPosition + 2)*Hlindex  
					end
					if index <= horizontalNumber then
						tHeight = sHeight - wPosition
					end
					index = index + 1
					cell:setPosition(cc.p(tWidth, tHeight))
				end
			end
		end
    end
    ScrollView_silk_bag:jumpToTop()

end

function SilkBagKnapsack:onEnterTransitionFinish()
	-- 加载SilkBagKnapsackWindow界面资源.
	-- res.cultivate.silk_bag_knapsack = res/cultivate/silk_bag_knapsack.csb
	local csbNode = csb.createNode("cultivate/silk_bag_knapsack.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "silk_bag_knapsack_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function SilkBagKnapsack:onExit()
	-- 释放SilkBagKnapsackWindow界面资源.
	state_machine.remove("silk_bag_knapsack_open")
	state_machine.remove("silk_bag_knapsack_close")
	state_machine.remove("silk_bag_knapsack_show")
	state_machine.remove("silk_bag_knapsack_hide")
	state_machine.remove("silk_bag_knapsack_update")
	
end

function SilkBagKnapsack:close()
	-- window event : close.
	
end

function SilkBagKnapsack:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
