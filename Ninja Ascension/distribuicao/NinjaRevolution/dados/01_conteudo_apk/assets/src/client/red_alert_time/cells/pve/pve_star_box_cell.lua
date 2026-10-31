----------------------------------------------------------------------------------------------------
-- 说明：宝箱cell
-------------------------------------------------------------------------------------------------------
PveStarBoxCell = class("PveStarBoxCellClass", Window)
PveStarBoxCell.__size = nil

local pve_star_box_create_cell_terminal = {
    _name = "pve_star_box_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)    
        local cell = PveStarBoxCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell, 0.5)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(pve_star_box_create_cell_terminal)
state_machine.init()

function PveStarBoxCell:ctor()
    self.super:ctor()
	self.roots = {}		

    -- 章节ID
	self._scene_id = 0
    -- 需要星数
    self._need_star = 0
 	local function init_pve_star_box_cell_terminal()
        local pve_star_box_cell_choose_terminal = {
            _name = "pve_star_box_cell_choose",
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
        
        state_machine.add(pve_star_box_cell_choose_terminal)
        state_machine.init()
    end
	init_pve_star_box_cell_terminal()        	
end

function PveStarBoxCell:onUpdateDraw()
	local root = self.roots[1]
    local Text_star_n = ccui.Helper:seekWidgetByName(root, "Text_star_n")
    Text_star_n:setString(self._need_star)
end

function PveStarBoxCell:onEnterTransitionFinish()

end

function PveStarBoxCell:onInit()
	local root = cacher.createUIRef(config_csb.cells.pve.pve_star_box_cell, "root")
    table.insert(self.roots, root)
 	self:addChild(root) 
    
	if PveStarBoxCell.__size == nil then
		PveStarBoxCell.__size = root:getContentSize()
	end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_chapter_pic"), nil, 
    {
        terminal_name = "pve_star_box_cell_choose",
        terminal_state = 0,
        cell = self,
        touch_black = true,
    },
    nil,1)
	
	self:onUpdateDraw()
end

function PveStarBoxCell:onExit()
	cacher.freeRef(config_csb.cells.pve.pve_star_box_cell, self.roots[1])
end

function PveStarBoxCell:reload()
	-- local root = self.roots[1]
	-- if root ~= nil then
	-- 	return
	-- end
	-- self:onInit()
end

function PveStarBoxCell:unload()
	-- local root = self.roots[1]
	-- if root == nil then
	-- 	return
	-- end
	-- cacher.freeRef(config_csb.cells.pve.pve_star_box_cell, root)
	-- root:removeFromParent(false)
	-- self.roots = {}
end

function PveStarBoxCell:init(params)
    self._index = params[1]
    self._need_star = params[2]
    self._scene_id = params[2]
    self:onInit()
	self:setContentSize(PveStarBoxCell.__size)
end

