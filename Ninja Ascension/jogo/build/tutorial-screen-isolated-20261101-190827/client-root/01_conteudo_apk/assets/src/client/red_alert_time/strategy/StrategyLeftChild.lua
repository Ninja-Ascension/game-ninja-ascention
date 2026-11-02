--------------------------------------------
-- 单个攻略标签
--------------------------------------------
StrategyLeftChild = class("StrategyLeftChildClass", Window)
    
function StrategyLeftChild:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 0
	self.info = nil

    local function init_strategy_left_child_terminal()
		local strategy_left_child_selected_terminal = {
            _name = "strategy_left_child_selected",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				state_machine.excute("strategy_select_left_once", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(strategy_left_child_selected_terminal)
        state_machine.init()
    end
    init_strategy_left_child_terminal()
end

function StrategyLeftChild:changeSelectedState( isSelected )
	local root = self.roots[1]
	ccui.Helper:seekWidgetByName(root, "Image_gv_tab"):setVisible(isSelected)
    if isSelected == true then
        ccui.Helper:seekWidgetByName(root, "Text_gv_name"):setColor(cc.c3b(255,234,198))
    else
        ccui.Helper:seekWidgetByName(root, "Text_gv_name"):setColor(cc.c3b(144,101,65))
    end
end

function StrategyLeftChild:onUpdateDraw()
	local icon = dms.int(dms["kits"], self.index, kits.icon)        --图片                
    local title = dms.string(dms["kits"], self.index, kits.title)   --标题
    local root = self.roots[1]
    local iconPath = string.format("images/ui/raiders_icon/gongluefenye_%d.png", icon)
    ccui.Helper:seekWidgetByName(root, "Panel_gv_icon"):setBackGroundImage(iconPath)
    ccui.Helper:seekWidgetByName(root, "Text_gv_name"):setString(title)
end

function StrategyLeftChild:onEnterTransitionFinish()
	local csbStrategyLeft = csb.createNode(config_csb.system.raiders_xzs_left)
	self:addChild(csbStrategyLeft)
	local root = csbStrategyLeft:getChildByName("root")
	table.insert(self.roots, root)

	self:setContentSize(root:getContentSize())
    local Image_gv_tab = ccui.Helper:seekWidgetByName(root, "Image_gv_tab")
	Image_gv_tab:setVisible(false)

	local Panel_gv_box = ccui.Helper:seekWidgetByName(root, "Panel_gv_box")
	Panel_gv_box:setSwallowTouches(false)

    local function panelTouchListener( sender, eventType )
        local __spoint = sender:getTouchBeganPosition()
        local __mpoint = sender:getTouchMovePosition()
        local __epoint = sender:getTouchEndPosition()

        if eventType == ccui.TouchEventType.began then
        elseif eventType == ccui.TouchEventType.moved then
        elseif eventType == ccui.TouchEventType.canceled then
        elseif eventType == ccui.TouchEventType.ended then
            if math.abs(__spoint.x - __epoint.x) <= 3 and math.abs(__spoint.y - __epoint.y) <= 3 then
                state_machine.excute("strategy_left_child_selected", 0, self.index)
            end
        end
    end
    Panel_gv_box:addTouchEventListener(panelTouchListener)

	self:onUpdateDraw()
end

function StrategyLeftChild:init(index)
	self.index = index
end

function StrategyLeftChild:createCell()
	local cell = StrategyLeftChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end