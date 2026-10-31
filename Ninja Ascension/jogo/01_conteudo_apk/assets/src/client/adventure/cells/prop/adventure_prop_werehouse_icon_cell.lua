----------------------------------------------------------------------------------------------------
-- 说明：道具仓库图标绘制
----------------------------------------------------------------------------------------------------
AdventurePropWerehouseIconCell = class("AdventurePropWerehouseIconCellClass", Window)
AdventurePropWerehouseIconCell.__size = nil

function AdventurePropWerehouseIconCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

	self.current_type = 0
	self.enum_type = {
		_TYPE_NORMAL = 0,					-- 静态的UI显示
		_PROP_USE = 1,						-- 道具使用
		_WAREHOUSE_UNLOCK = 99,				-- 仓库解锁
	}

	self.drawHeadType = 0
	self.ifdim = nil
	self.numbers = nil
	self.capadility = nil
	self.level = nil
	self.awaken = nil
	self.drawIndex = 0
	self.Panel_choose = nil
	self.isSelcet = false
	self.show_number = nil
	-- Initialize adventure hero icon cell state machine.
	local function init_adventure_prop_werehouse_icon_cell_terminal()
		local adventure_prop_werehouse_icon_cell_unlock_terminal = {
            _name = "adventure_prop_werehouse_icon_cell_unlock",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				-- local function responseBattleInitCallback(response)
					-- if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						-- state_machine.excute("adventure_prop_storage_update_prop", 0, params)
					-- end
				-- end
				-- protocol_command.basic_consumption.param_list = "6\r\n0,0"
				-- NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, nil, responseBattleInitCallback, true, nil)
				
				
				app.load("client.adventure.packs.prop.AdventurePropUnlockTip")
				fwin:open(AdventurePropUnlockTip:new():init(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_prop_werehouse_icon_cell_warehouse_larger_terminal = {
            _name = "adventure_prop_werehouse_icon_cell_warehouse_larger",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				if terminal.largerId ~= nil and terminal.largerId == cell then
					return false
				end
				if terminal.largerId ~= nil and terminal.largerId ~= cell then
					
					--ccui.Helper:seekWidgetByName(terminal.largerId.roots[1], "Panel_choose"):setVisible(false)
					terminal.largerId:setSelectState(false)
					terminal.largerId = cell
					terminal.largerId:setSelectState(true)
					--ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose"):setVisible(true)
					return false
				end
				if terminal.largerId == nil then
					terminal.largerId = cell
					--ccui.Helper:seekWidgetByName(cell.roots[1], "Panel_choose"):setVisible(true)
					cell:setSelectState(true)
					
					return false
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local adventure_prop_werehouse_icon_selected_terminal = {
            _name = "adventure_prop_werehouse_icon_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params._datas.cell
				state_machine.excute("adventure_prop_storage_update_on_info", 0, params)
				state_machine.excute("adventure_prop_werehouse_icon_cell_warehouse_larger", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(adventure_prop_werehouse_icon_cell_unlock_terminal)
		state_machine.add(adventure_prop_werehouse_icon_cell_warehouse_larger_terminal)
		state_machine.add(adventure_prop_werehouse_icon_selected_terminal)
        state_machine.init()
	end

	-- call func init adventure hero icon cell state machine.
	init_adventure_prop_werehouse_icon_cell_terminal()
end

function AdventurePropWerehouseIconCell:updateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
	local Panel_bg = ccui.Helper:seekWidgetByName(root, "Panel_pingzhi")
	local quality = 1
	local picIndex = 0
	if self.mould_data ~= nil then
		quality = dms.atoi(self.mould_data, prop_mould.prop_quality)+1
	else
		quality = 1
	end
	
	local qualityImage = nil
	
	qualityImage = string.format("images/ui/quality/icon_prop_%d.png", quality)
	Panel_bg:setBackGroundImage(qualityImage)


	local Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item_1")
	local picIndex = 0
	ccui.Helper:seekWidgetByName(root, "Text_jiesuo"):setVisible(false)
	local itemnumText = ccui.Helper:seekWidgetByName(root, "Text_item_number")
	itemnumText:setString("")
	Panel_item:setVisible(false)
	if self.enum_type._PROP_USE	== self.current_type then
		Panel_item:setVisible(true)
		picIndex = dms.atos(self.mould_data, prop_mould.pic_index)
		Panel_item:setBackGroundImage(string.format("images/ui/props/porps_%d.png", zstring.tonumber(picIndex)))
		Panel_bg:setVisible(true)
	elseif self.enum_type._TYPE_NORMAL	== self.current_type then
		Panel_item:setVisible(false)
		Panel_bg:setVisible(false)
	elseif self.enum_type._WAREHOUSE_UNLOCK	== self.current_type then
		Panel_item:setVisible(false)
		ccui.Helper:seekWidgetByName(root, "Text_jiesuo"):setVisible(true)
		Panel_bg:setVisible(false)
	end
	if self.show_number ~= nil then 
		itemnumText:setString("" .. self.show_number)
	end
	self.Panel_choose:setVisible(self.isSelcet)
end

function AdventurePropWerehouseIconCell:onInit()
	self.roots = {}
	local root = cacher.createUIRef("icon/item.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
	ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(true)
	self.Panel_choose = ccui.Helper:seekWidgetByName(root, "Panel_choose")

	self.item_order_level = ccui.Helper:seekWidgetByName(root, "Label_l-order_level")  --右下角等级
	if self.item_order_level._x == nil then
		self.item_order_level._x = self.item_order_level:getPositionX()
	end

 	if self.enum_type._PROP_USE == self.current_type then
	    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"),       nil, 
	    {
	        terminal_name = "adventure_prop_werehouse_icon_selected",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._WAREHOUSE_UNLOCK == self.current_type then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"),       nil, 
	    {
	        terminal_name = "adventure_prop_werehouse_icon_cell_unlock",
	        cell = self,        
	        terminal_state = 0, 
	        isPressedActionEnabled = false
	    }, 
	    nil, 0)
	elseif self.enum_type._TYPE_NORMAL == self.current_type then
		ccui.Helper:seekWidgetByName(root, "Panel_prop"):setTouchEnabled(false)
	end
		
	self:updateDraw()
	
	-- Get size for root node.
	if AdventurePropWerehouseIconCell.__size == nil then
		local size = root:getContentSize()
		AdventurePropWerehouseIconCell.__size = size
	end
end

function AdventurePropWerehouseIconCell:onExit()
	cacher.freeRef("icon/item.csb", self.roots[1])
	self.roots = {}

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
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
	    local Label_l_order_level = ccui.Helper:seekWidgetByName(root,"Label_l-order_level")
	    if Label_l_order_level ~= nil then 
	    	Label_l_order_level:setVisible(true)
	    	if Label_l_order_level._x then
		    	Label_l_order_level:setPositionX(Label_l_order_level._x)
		    end
	        Label_l_order_level:setString("")
	    end
	end
end

function AdventurePropWerehouseIconCell:setSelectState(isSelcet)
	self.isSelcet = isSelcet
	self:updateDraw()
end

-- /**
-- * interfaceType	逻辑类型
-- * hero			实例对象
-- * drawIndex		一个屏幕内显示最多的数量,也是当前在阵容中的位置
-- * show_number	显示数量
-- */
function AdventurePropWerehouseIconCell:init(interfaceType, prop, drawIndex,show_number)
	self.current_type = interfaceType
	self.prop = prop
	self.drawIndex = drawIndex
	self.show_number = show_number
	self.mould_data = prop.mould_data or dms.element(dms["prop_mould"], self.prop.user_prop_template)
	
	if drawIndex ~= nil and drawIndex < 45 then
		self:onInit()
	end
	
	self:setContentSize(AdventurePropWerehouseIconCell.__size)
	return self
end

function AdventurePropWerehouseIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function AdventurePropWerehouseIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("icon/item.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function AdventurePropWerehouseIconCell:createCell()
	local cell = AdventurePropWerehouseIconCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

