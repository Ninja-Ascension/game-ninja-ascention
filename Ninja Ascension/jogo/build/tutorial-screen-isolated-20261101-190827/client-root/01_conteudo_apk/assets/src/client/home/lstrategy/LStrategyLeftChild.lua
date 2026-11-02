
LStrategyLeftChild = class("LStrategyLeftChildClass", Window)
    
function LStrategyLeftChild:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
	self.info = nil

    local function init_strategy_left_child_terminal()
		local lstrategy_left_child_selected_terminal = {
            _name = "lstrategy_left_child_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("lstrategy_select_left_once", 0, params._datas.selectIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(lstrategy_left_child_selected_terminal)
        state_machine.init()
    end
    init_strategy_left_child_terminal()
end

function LStrategyLeftChild:changeSelectedState( isSelected )
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Image_gv_tab"):setVisible(isSelected)
end

function LStrategyLeftChild:onUpdateDraw()
	local icon = dms.int(dms["kits"], self.index, kits.icon)
    local title = dms.string(dms["kits"], self.index, kits.title)
    local root = self.roots[1]
    local iconPath = string.format("images/ui/function_icon/achieve_icon_%d.png", icon)
    ccui.Helper:seekWidgetByName(root, "Panel_gv_icon"):setBackGroundImage(iconPath)
    ccui.Helper:seekWidgetByName(root, "Text_gv_name"):setString(title)
end

function LStrategyLeftChild:onEnterTransitionFinish()
	local csbStrategyLeft = csb.createNode("system/raiders_xzs_left.csb")
	self:addChild(csbStrategyLeft)
	local root = csbStrategyLeft:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(root:getContentSize())
	ccui.Helper:seekWidgetByName(root, "Image_gv_tab"):setVisible(false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_gv_box"), nil, 
	{
		terminal_name = "lstrategy_left_child_selected", 
		terminal_state = 0,
		selectIndex = self.index,
		isPressedActionEnabled = true
	}, nil, 0)

	self:onUpdateDraw()
end

function LStrategyLeftChild:init(index)
	self.index = index
end

function LStrategyLeftChild:createCell()
	local cell = LStrategyLeftChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end