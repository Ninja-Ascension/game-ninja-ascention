-- ----------------------------------------------------------------------------------------------------
-- 说明：功能开启浏览
-------------------------------------------------------------------------------------------------------
SmModelOpenPushScan = class("SmModelOpenPushScanClass", Window)
local sm_model_open_push_scan_open_terminal = {
    _name = "sm_model_open_push_scan_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmModelOpenPushScanClass")
        if _window == nil then
            fwin:open(SmModelOpenPushScan:new():init(params),fwin._ui)
        end
    	return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_model_open_push_scan_open_terminal)
state_machine.init()
    
function SmModelOpenPushScan:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
    self.currId = 1
    local function init_sm_model_open_push_scan_terminal()
        --关闭
        local sm_model_open_push_scan_close_terminal = {
            _name = "sm_model_open_push_scan_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(sm_model_open_push_scan_close_terminal)
        state_machine.init()
    end
    
    init_sm_model_open_push_scan_terminal()
end

function SmModelOpenPushScan:onUpdateDraw()
    local root = self.roots[1]
    --图标
    local Panel_fun_icon = ccui.Helper:seekWidgetByName(root, "Panel_fun_icon")
    Panel_fun_icon:removeAllChildren(true)
    Panel_fun_icon:setBackGroundImage(string.format("images/ui/text/XTZY/fun_icon_%d.png",self.currId))
    --名称
    local Panel_fun_title_name = ccui.Helper:seekWidgetByName(root, "Panel_fun_title_name")
    Panel_fun_title_name:removeAllChildren(true)
    Panel_fun_title_name:setBackGroundImage(string.format("images/ui/text/XTZY/fun_title_name_%d.png",self.currId))
    --描述
    local Panel_fun_info = ccui.Helper:seekWidgetByName(root, "Panel_fun_info")
    Panel_fun_info:removeAllChildren(true)
    Panel_fun_info:setBackGroundImage(string.format("images/ui/text/XTZY/fun_info_%d.png",self.currId))

    --说明
    local Text_fun_open_info = ccui.Helper:seekWidgetByName(root, "Text_fun_open_info")
    Text_fun_open_info:setString(_model_open_push_tip[self.currId][2])

end

function SmModelOpenPushScan:onEnterTransitionFinish()
	local csbModelOpenPushScan = csb.createNode("home/home_fun_open_window.csb")
	self:addChild(csbModelOpenPushScan)
	local root = csbModelOpenPushScan:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline("home/home_fun_open_window.csb")
    table.insert(self.actions, action)
    csbModelOpenPushScan:runAction(action)
    action:play("window_open", false)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"),nil, 
    {
        terminal_name = "sm_model_open_push_scan_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_20"),nil, 
    {
        terminal_name = "sm_model_open_push_scan_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self:onUpdateDraw()

end

function SmModelOpenPushScan:init(params)
    self.currId = params
    return self
end

function SmModelOpenPushScan:onExit()
    state_machine.remove("sm_model_open_push_scan_close")
end
