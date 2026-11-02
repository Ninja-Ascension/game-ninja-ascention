--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
CombinationCardItemCell = class("CombinationCardItemCellClass", Window)
CombinationCardItemCell.__size = nil

-- 创建Cell实例
local combination_card_item_cell_create_terminal = {
	_name = "combination_card_item_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if CombinationCardItemCell then
			local cell = CombinationCardItemCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
        	cell:registerOnNoteUpdate(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(combination_card_item_cell_create_terminal)
state_machine.init()

-- 构造器
function CombinationCardItemCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.is_disboard = false 	-- 是否是禁止按钮
	self.ship_id = nil
	-- load lua files.

	-- Initialize combination card item cell page state machine.
	local function init_combination_card_item_cell_terminal()
		-- 打开角色创建窗口
		local combination_card_item_cell_open_terminal = {
			_name = "combination_card_item_cell_open",
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
		local combination_card_item_cell_close_terminal = {
			_name = "combination_card_item_cell_close",
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
		local combination_card_item_cell_show_terminal = {
			_name = "combination_card_item_cell_show",
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
		local combination_card_item_cell_hide_terminal = {
			_name = "combination_card_item_cell_hide",
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

		-- 下阵
		local combination_card_item_cell_disboard_terminal = {
			_name = "combination_card_item_cell_disboard",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cardId = instance.solt_info.card_id
				local soltId = instance.solt_info.solt_id
				local shipId = 0
				local level = CombinationCardHandle.getOneSoltInfoById(soltId).slotLevel
				
				local function responseUpCallBack( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("combination_card_unlock_window_refresh",0,soltId)
						smFightingChange()
						state_machine.excute("combination_card_sell_window_close",0,"")
					end
				end
				
				protocol_command.combine_ship_change_slot.param_list = ""..cardId.."\r\n"..(soltId-1).."\r\n"..shipId.."\r\n"..level.."\r\n".."0"
				NetworkManager:register(protocol_command.combine_ship_change_slot.code, nil, nil, nil, instance, responseUpCallBack, false, nil)
				
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 上阵
		local combination_card_item_cell_pitch_terminal = {
			_name = "combination_card_item_cell_pitch",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cardId = instance.solt_info.card_id
				local soltId = instance.solt_info.solt_id
				local shipId = params._datas.ship_id
				local mouldId = _ED.user_ship[""..shipId].ship_template_id
				local level = CombinationCardHandle.getOneSoltInfoById(soltId).slotLevel
				local lastMouldId = 0
				if _ED.user_ship[""..(instance.solt_info.ship_mould_id_have)] then
					lastMouldId = _ED.user_ship[""..(instance.solt_info.ship_mould_id_have)].ship_template_id
				end
				
				local function responseUpCallBack( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("combination_card_unlock_window_refresh",0,soltId)
						smFightingChange()
						state_machine.excute("combination_card_sell_window_close",0,"")
					end
				end
				
				protocol_command.combine_ship_change_slot.param_list = ""..cardId.."\r\n"..(soltId - 1).."\r\n"..mouldId.."\r\n"..level.."\r\n"..lastMouldId
				NetworkManager:register(protocol_command.combine_ship_change_slot.code, nil, nil, nil, instance, responseUpCallBack, false, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(combination_card_item_cell_open_terminal)
		state_machine.add(combination_card_item_cell_close_terminal)
		state_machine.add(combination_card_item_cell_show_terminal)
		state_machine.add(combination_card_item_cell_hide_terminal)
		state_machine.add(combination_card_item_cell_disboard_terminal)
		state_machine.add(combination_card_item_cell_pitch_terminal)
		state_machine.init()
	end
	-- call func init combination card item cell state machine.
	init_combination_card_item_cell_terminal()
end



function CombinationCardItemCell:onUpdateDraw()
	local root = self.roots[1]

	-- 禁用图片
	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	self.Image_1:setVisible(false)
	-- 道具
	self.Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	self.Panel_prop:removeAllChildren()
	
	if self.is_disboard then	-- 下阵
		self.Image_1:setVisible(true)
		fwin:addTouchEventListener(self.Panel_prop, nil,
		{
			terminal_name = "combination_card_item_cell_disboard",
			terminal_state = 0,
			isPressedActionEnabled = true,
		}, nil, 0)	
	else					--上阵
		local ship = _ED.user_ship[""..self.ship_id]
		local cell = HeroIconListCell:createCell()
		cell:init(ship,nil,false,nil)
		-- local cell = ShipIconCell:createCell()
		-- cell:init(ship,8)
		self.Panel_prop:addChild(cell)

		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_prop"), nil,
		{
			terminal_name = "combination_card_item_cell_pitch",
			terminal_state = 0,
			ship_id = self.ship_id,
			isPressedActionEnabled = true,
		}, nil, 0)
	end

end

function CombinationCardItemCell:onEnterTransitionFinish()
	
end

-- 对象初始化
function CombinationCardItemCell:init(params)
	self.solt_info = params[1]
	if params[2] then
		self.ship_id = tonumber(params[2])
	else
		self.is_disboard = true
	end 
	self:onInit(params)
	return self
end

function CombinationCardItemCell:onInit(params)
	local root = cacher.createUIRef("cultivate/Combination_card/Combination_card_item.csb", "root")
	table.insert(self.roots, root)

	self:addChild(root)
	self:clearUIInfo()
	if CombinationCardItemCell.__size == nil then
		CombinationCardItemCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_prop"):getContentSize()
	end
	self:setContentSize(CombinationCardItemCell.__size)
	self:onUpdateDraw()
end

function CombinationCardItemCell:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
        return
    end
	if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
	local Panel_prop = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	Panel_prop:removeAllChildren()
	fwin:removeTouchEventListener(Panel_prop)

end

function CombinationCardItemCell:onExit()
	-- 释放CombinationCardItemCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Combination_card/Combination_card_item.csb", root)
	-- ]]
end

function CombinationCardItemCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:registerOnNoteUpdate(self)
	self:onInit()
end

function CombinationCardItemCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	cacher.freeRef("cultivate/Combination_card/Combination_card_item.csb", root)
	self:stopAllActions()
	self:unregisterOnNoteUpdate(self)
	root:removeFromParent(false)
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
