----------------------------------------------------------------------------------------------------
-- 说明：汽泡
-------------------------------------------------------------------------------------------------------
ShipBodyFizzCell = class("ShipBodyFizzCellClass", Window)

function ShipBodyFizzCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.msg = ""
	
	local function init_ship_body_fizz_cell_terminal()
		local ship_body_fizz_cell_show_terminal = {
            _name = "ship_body_fizz_cell_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if fizzCell ~= nil then
	            	local fizzCell = params[1]
	            	fizzCell:setVisible(true)
	            	fizzCell.actions[1]:play("page_qipao", false)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local ship_body_fizz_cell_hide_terminal = {
            _name = "ship_body_fizz_cell_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if fizzCell ~= nil then
	            	local fizzCell = params[1]
	            	fizzCell:setVisible(false)
	            end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(ship_body_fizz_cell_show_terminal)
		state_machine.add(ship_body_fizz_cell_hide_terminal)	
        state_machine.init()
	end
	init_ship_body_fizz_cell_terminal()
end

function ShipBodyFizzCell:onEnterTransitionFinish()
	local csbShipBodyFizzCell = csb.createNode("card/card_role_qipao.csb")
	local root = csbShipBodyFizzCell:getChildByName("root")
	self:addChild(csbShipBodyFizzCell)
	table.insert(self.roots, root)
	
	local action = csb.createTimeline("card/card_role_qipao.csb")
	table.insert(self.actions, action)
    csbShipBodyFizzCell:runAction(action)

	-- 汽泡信息
	ccui.Helper:seekWidgetByName(root, "Text_106_2"):setString(self.msg)
end

function ShipBodyFizzCell:onExit()
	
end

function ShipBodyFizzCell:init(messageInformation)
	self.msg = messageInformation
end

function ShipBodyFizzCell:createCell()
	local cell = ShipBodyFizzCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

