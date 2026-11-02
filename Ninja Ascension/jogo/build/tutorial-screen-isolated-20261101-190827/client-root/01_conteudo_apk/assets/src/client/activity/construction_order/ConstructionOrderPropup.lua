-----------------------------
-- 战令激活道具弹窗
-----------------------------
ConstructionOrderPropup = class("ConstructionOrderPropupClass", Window)

local construction_order_propup_window_open_terminal = {
    _name = "construction_order_propup_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        -- if nil == fwin:find("ConstructionOrderPropupClass") then
            fwin:open(ConstructionOrderPropup:new():init(params), fwin._windows)
        -- end       
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local construction_order_propup_window_close_terminal = {
    _name = "construction_order_propup_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ConstructionOrderPropupClass"))  
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_propup_window_open_terminal)
state_machine.add(construction_order_propup_window_close_terminal)
state_machine.init()

function ConstructionOrderPropup:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.propInfo = {}

    local function init_construction_order_propup_terminal()
		local construction_order_propup_choose_terminal = {
            _name = "construction_order_propup_choose",
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

        local construction_order_propup_goto_terminal = {
            _name = "construction_order_propup_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("user_information_home_click_email_manager", 0, nil)
                state_machine.excute("construction_order_propup_window_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_propup_goto_terminal)
		state_machine.add(construction_order_propup_choose_terminal)
        state_machine.init()
    end
    
    init_construction_order_propup_terminal()
end

function ConstructionOrderPropup:onSelectChoose()
    local root = self.roots[1]
end

function ConstructionOrderPropup:onEnterTransitionFinish()

end

function ConstructionOrderPropup:onInit()
    local csbItem = csb.createNode("activity/passport/passport_popup_drawtips.csb")
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    -- local action = csb.createTimeline("activity/passport/passport_popup_drawtips.csb")
    -- if action:IsAnimationInfoExists("window_open") == true then
    --     csbRechargeTipDialog:runAction(action)
    --     action:play("window_open", false)
    -- end
    local action = csb.createTimeline("activity/passport/passport_popup_drawtips.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:play("window_open", false)

    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
    {
        terminal_name = "construction_order_propup_goto",
        terminal_state = 0,
        instance = self
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "construction_order_propup_window_close",
        terminal_state = 0,
        instance = self
    }, nil, 0)

    self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    self.Panel_icon:removeAllChildren()
    local cell = DrawHandle.drawIcon(self.propInfo)
    self.Panel_icon:addChild(cell)

end

function ConstructionOrderPropup:init(params)
    self.propInfo = params.propInfo
	self:onInit()
    return self
end

function ConstructionOrderPropup:onExit()

    state_machine.remove("construction_order_propup_goto")
    state_machine.remove("construction_order_propup_choose")
end
