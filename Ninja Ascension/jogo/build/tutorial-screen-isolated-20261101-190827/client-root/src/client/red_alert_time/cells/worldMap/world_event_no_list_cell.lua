-----------------------------
--世界事件列表控件“无”
-----------------------------
WorldEventNoListCell = class("WorldEventNoListCellClass", Window)
WorldEventNoListCell.__size = nil

function WorldEventNoListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.m_object = nil

    local function init_world_nearby_no_list_cell_terminal()
        -- local world_nearby_list_cell_positioning_terminal = {
            -- _name = "world_nearby_list_cell_positioning",
            -- _init = function (terminal)
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- state_machine.excute("adventure_mine_record_view_position", 0, {params._datas.cell.m_object._x,params._datas.cell.m_object._y})
				-- state_machine.excute("adventure_mine_update_view_position", 0, 0)
				
				-- protocol_command.world_map_arena_info_refresh.param_list = "" .. params._datas.cell.m_object._x .. "\r\n" .. params._datas.cell.m_object._y
				-- NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, self, nil, false, nil)
				
				-- state_machine.excute("red_alert_time_mine_view_nearby_close", 0, 0)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
        -- state_machine.add(world_nearby_list_cell_positioning_terminal)
        state_machine.init()
    end
    init_world_nearby_no_list_cell_terminal()
end

function WorldEventNoListCell:onEnterTransitionFinish()

end

function WorldEventNoListCell:onUpdateDraw()
    local root = self.roots[1]
	
	--vip的暂时先去掉
	ccui.Helper:seekWidgetByName(root,"Button_implement_vip_recharge"):setVisible(false)
	ccui.Helper:seekWidgetByName(root,"Text_implement_vip"):setVisible(false)
	ccui.Helper:seekWidgetByName(root,"Text_troops_empty"):setVisible(true)
	--暂时所有的队列开放
	
		
end

function WorldEventNoListCell:init(info)
    -- if index ~= nil and index < 5 then
	self:onInit()
    -- end
	self:setContentSize(WorldEventNoListCell.__size)
    return self
end

function WorldEventNoListCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.world.battle_infor_window_cell_2, "root")
    table.insert(self.roots, root)
    self:addChild(root) 
    if WorldEventNoListCell.__size == nil then
        WorldEventNoListCell.__size = root:getContentSize()
    end  
	
	--定位
    fwin:addTouchEventListener(root , nil, 
    {
        terminal_name = "world_nearby_list_cell_positioning", 
        terminal_state = 0,
        touch_scale = false,
        touch_scale_xy = 0.95,
        touch_black = true, 
		cell = self,
    }, nil, 1)    
    
    self:onUpdateDraw() 
end

function WorldEventNoListCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function WorldEventNoListCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self._is_nil = false
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_2, root)
    root:removeFromParent(false)
    self.roots = {}
end

function WorldEventNoListCell:onExit()
	self._is_nil = false
    cacher.freeRef(config_csb.cells.world.battle_infor_window_cell_2, self.roots[1])
end

function WorldEventNoListCell:createCell()
	local cell = WorldEventNoListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end