----------------------------------------------------------------------------------------------------
-- 说明：扫荡损失cell
-------------------------------------------------------------------------------------------------------
PveSweepRepairCell = class("PveSweepRepairCellClass", Window)
PveSweepRepairCell.__size = nil

local pve_sweep_repair_create_cell_terminal = {
    _name = "pve_sweep_repair_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveSweepRepairCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_sweep_repair_create_cell_terminal)
state_machine.init()

function PveSweepRepairCell:ctor()
    self.super:ctor()
	self.roots = {}	
	self.old_formation = nil
	self.cell = nil
	
 	local function init_pve_sweep_repair_cell_terminal()
        local pve_sweep_repair_cell_choose_terminal = {
            _name = "pve_sweep_repair_cell_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
		local pve_sweep_repair_cell_request_terminal = {
            _name = "pve_sweep_repair_cell_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local function requesrRepairCallback( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						state_machine.excute("notification_center_update", 0, "push_notification_formation_repair")
					end
				end
				
                protocol_command.ship_repair_ship_count.param_list = "1\r\n" ..params
				NetworkManager:register(protocol_command.ship_repair_ship_count.code, nil, nil, nil, nil, requesrRepairCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_sweep_repair_cell_choose_terminal)
        state_machine.add(pve_sweep_repair_cell_request_terminal)
        state_machine.init()
    end
	init_pve_sweep_repair_cell_terminal()        	
end

function PveSweepRepairCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_consume_gemstone_n = ccui.Helper:seekWidgetByName(root,"Text_consume_gemstone_n")
	
	local ship_id_set = ""
	local repars_ships = {}
	for i,v in pairs(self.old_formation) do
		if tonumber(_ED.user_ship[v.ship_id].lose_ship_count) > 0 then
			table.insert(repars_ships, v)
		end
	end
	local need_repars_gem = 0
	for j, k in pairs(repars_ships) do
		local ship_data = dms.element(dms["ship_mould"], _ED.user_ship[k.ship_id].ship_template_id)
		local cost_gem = dms.atoi(ship_data, ship_mould.price)           -- 维修消耗宝石矿
        need_repars_gem = need_repars_gem + math.ceil(tonumber(_ED.user_ship[k.ship_id].lose_ship_count)*cost_gem)
        if k == #repars_ships then
            ship_id_set = ship_id_set..k.ship_id
        else
            ship_id_set = ship_id_set..k.ship_id..","
        end
    end
    need_repars_gem = math.ceil(need_repars_gem * (1 - zstring.tonumber(_ED.repair_cost_factor) / 100))
	Text_consume_gemstone_n:setString(exChangeNumToString(math.ceil(need_repars_gem)))
	if need_repars_gem > zstring.tonumber(_ED.user_info.user_silver) then
		Text_consume_gemstone_n:setColor(cc.c3b(color_Type[5][1], color_Type[5][2], color_Type[5][3]))
		state_machine.excute("pve_sweep_settlement_cell_stop",0,{_datas = {cell = self.cell}})
	else
		Text_consume_gemstone_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
	end
	
	state_machine.excute("pve_sweep_repair_cell_request", 0, ship_id_set)
end

function PveSweepRepairCell:onEnterTransitionFinish()

end

function PveSweepRepairCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.pve.pve_sweep_cell_consume, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PveSweepRepairCell.__size == nil then
		PveSweepRepairCell.__size = root:getContentSize()
	end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic"), nil, 
    {
        terminal_name = "pve_sweep_repair_cell_choose",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
	
	self:onUpdateDraw()
end

function PveSweepRepairCell:onExit()
	cacher.freeRef(config_csb.cells.pve.pve_sweep_cell_consume, self.roots[1])
end

function PveSweepRepairCell:reload()
	-- local root = self.roots[1]
	-- if root ~= nil then
	-- 	return
	-- end
	-- self:onInit()
end

function PveSweepRepairCell:unload()
	-- local root = self.roots[1]
	-- if root == nil then
	-- 	return
	-- end
	-- cacher.freeRef(config_csb.cells.pve.pve_sweep_cell_consume, root)
	-- root:removeFromParent(false)
	-- self.roots = {}
end

function PveSweepRepairCell:init(params)
	self.old_formation = params[2]
	self.cell = params[1]
    self:onInit()
	self:setContentSize(PveSweepRepairCell.__size)
end

