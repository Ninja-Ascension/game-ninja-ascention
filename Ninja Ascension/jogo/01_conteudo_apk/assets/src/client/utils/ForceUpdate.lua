-----------------------------
-- 绑定谷歌账号
-----------------------------
ForceUpdate = class("ForceUpdateClass", Window)

local sm_force_update_window_open_terminal = {
    _name = "sm_force_update_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ForceUpdateClass") then
            fwin:open(ForceUpdate:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_force_update_window_close_terminal = {
    _name = "sm_force_update_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("ForceUpdateClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_force_update_window_open_terminal)
state_machine.add(sm_force_update_window_close_terminal)
state_machine.init()

function ForceUpdate:ctor()
    self.super:ctor()
    self.roots = {}


    local function init_sm_force_update_terminal()
        local go_to_google_update_terminal = {
            _name = "go_to_google_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- handlePlatformRequest(0, CC_OPEN_URL_LAYOUT, _web_page_jump[7])
                handlePlatformRequest(0, LOGOUT, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(go_to_google_update_terminal)
        state_machine.init()
    end
    
    init_sm_force_update_terminal()
end

function ForceUpdate:onEnterTransitionFinish()

end

function ForceUpdate:onInit()
    local csbItem = csb.createNode("utils/update_google.csb")
    self:addChild(csbItem)
  	local root = csbItem:getChildByName("root")
  	table.insert(self.roots, root)

    -- local action = csb.createTimeline("utils/accounts_binding_prompt.csb")
    -- table.insert(self.actions, action)
    -- csbItem:runAction(action)
    -- action:play("window_open", false)
    
    -- 前往下载
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_update_google_sure"), nil, 
    {
        terminal_name = "go_to_google_update",
        terminal_state = 0,
        instance = self,
    }, nil, 0)
end

function ForceUpdate:init(params)
	self:onInit()
    return self
end

function ForceUpdate:onExit()
end
