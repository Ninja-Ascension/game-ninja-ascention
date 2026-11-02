----------------------------------------------------------------------------------------------------
-- 说明：阵容武将全身pageview控件
-- 创建时间
-- 作者：李文鋆
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
FormationHeadPageviewCellClass = class("FormationHeadPageviewCellClass", Window)

function FormationHeadPageviewCellClass:ctor()
    self.super:ctor()
	self.roots = {}
	self.ship = nil

	local function init_formation_car_head_info_cell_terminal()
	
		local call_formation_car_head_info_cell_terminal = {
            _name = "call_formation_car_head_info_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("open_formation_head_info", 0, params._datas.ship)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(call_formation_car_head_info_cell_terminal)	
        state_machine.init()
	end
	init_formation_car_head_info_cell_terminal()
end

function FormationHeadPageviewCellClass:onUpdateDraw()
	local root = self.roots[1]
	local shipImage = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local picIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.All_icon)
	shipImage:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", picIndex))
	
	local touchImage = fwin:addTouchEventListener(shipImage, nil, {terminal_name = "call_formation_car_head_info_cell", terminal_state = 0, ship = self.ship}, nil, 0)
end

function FormationHeadPageviewCellClass:onEnterTransitionFinish()
	local csbItem = csb.createNode("formation/line_up_list.csb")
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function FormationHeadPageviewCellClass:onExit()
	
end

function FormationHeadPageviewCellClass:init(ship)
	self.ship = ship
end

function FormationHeadPageviewCellClass:createCell()
	local cell = FormationHeadPageviewCellClass:new()
	cell.types = types
	cell:registerOnNodeEvent(cell)
	return cell
end

