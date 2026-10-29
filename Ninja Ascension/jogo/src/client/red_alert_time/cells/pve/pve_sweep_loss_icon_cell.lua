----------------------------------------------------------------------------------------------------
-- 说明：扫荡损失的坦克cell
-------------------------------------------------------------------------------------------------------
PveSweepLossIconCell = class("PveSweepLossIconCellClass", Window)
PveSweepLossIconCell.__size = nil

local pve_sweep_loss_icon_create_cell_terminal = {
    _name = "pve_sweep_loss_icon_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveSweepLossIconCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 1)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_sweep_loss_icon_create_cell_terminal)
state_machine.init()

function PveSweepLossIconCell:ctor()
    self.super:ctor()
	self.roots = {}		
	self.tanke_info = nil
	
 	local function init_pve_sweep_loss_icon_cell_terminal()
        local pve_sweep_loss_icon_cell_choose_terminal = {
            _name = "pve_sweep_loss_icon_cell_choose",
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
        
        state_machine.add(pve_sweep_loss_icon_cell_choose_terminal)
        state_machine.init()
    end
	init_pve_sweep_loss_icon_cell_terminal()        	
end

function PveSweepLossIconCell:onUpdateDraw()
	local root = self.roots[1]
	--画坦克
	local Panel_loss_icon = ccui.Helper:seekWidgetByName(root, "Panel_loss_icon")
	local cell = state_machine.excute("props_icon_create_cell",0,{1,3,_ED.user_ship[self.tanke_info.ship_id].ship_template_id,3})
	Panel_loss_icon:addChild(cell)
	--画数量
	local Text_loss_number = ccui.Helper:seekWidgetByName(root, "Text_loss_number")
	Text_loss_number:setString("X"..self.tanke_info.loss_count)
end

function PveSweepLossIconCell:onEnterTransitionFinish()
	
end

function PveSweepLossIconCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.pve.pve_sweep_loss_icon_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PveSweepLossIconCell.__size == nil then
		PveSweepLossIconCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function PveSweepLossIconCell:onExit()
	cacher.freeRef(config_csb.cells.pve.pve_sweep_loss_icon_cell, self.roots[1])
end

function PveSweepLossIconCell:reload()
	-- local root = self.roots[1]
	-- if root ~= nil then
	-- 	return
	-- end
	-- self:onInit()
end

function PveSweepLossIconCell:unload()
	-- local root = self.roots[1]
	-- if root == nil then
	-- 	return
	-- end
	-- cacher.freeRef(config_csb.cells.pve.pve_sweep_loss_icon_cell, root)
	-- root:removeFromParent(false)
	-- self.roots = {}
end

function PveSweepLossIconCell:init(params)
	self.tanke_info = params
    self:onInit()
	self:setContentSize(PveSweepLossIconCell.__size)
end

