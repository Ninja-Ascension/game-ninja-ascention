-- 粉丝也跳转
SmGotoFansWindow = class("SmGotoFansWindowClass", Window)

local sm_goto_fans_window_open_terminal = {
    _name = "sm_goto_fans_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmGotoFansWindowClass") == nil then
            fwin:open(SmGotoFansWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_goto_fans_window_close_terminal = {
    _name = "sm_goto_fans_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params and params._datas.callback then
            params._datas.callback()
        end
        fwin:close(fwin:find("SmGotoFansWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_goto_fans_window_open_terminal)
state_machine.add(sm_goto_fans_window_close_terminal)
state_machine.init()

function SmGotoFansWindow:ctor()
    self.super:ctor()

    self.roots = {}
    self._close_callback = nil

    local function init_sm_goto_fans_window_terminal()
        -- 跳转粉丝页
        local sm_goto_fans_window_goto_web_page_terminal = {
            _name = "sm_goto_fans_window_goto_web_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_goto_fans_window_goto_web_page", 0, "")
                if tipStringInfo_customer_service_tips[1] and tipStringInfo_customer_service_tips[1] ~= "" then 
                    handlePlatformRequest(0, CC_OPEN_URL, tipStringInfo_customer_service_tips[1])
                end
                state_machine.unlock("sm_goto_fans_window_goto_web_page", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_goto_fans_window_goto_web_page_terminal)
        state_machine.init()
    end
    init_sm_goto_fans_window_terminal()
end

function SmGotoFansWindow:onUpdateDraw()
    local root = self.roots[1]
    local Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18")
    Text_18:setString(tipStringInfo_customer_service_tips[4])
end

function SmGotoFansWindow:drawBtn()
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "sm_goto_fans_window_close",
            terminal_state = 0,
            touch_black = true,
            callback = self._close_callback
        },
        nil,
        3
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_join"),
        nil,
        {
            terminal_name = "sm_goto_fans_window_goto_web_page",
            terminal_state = 0,
            touch_black = true
        },
        nil,
        3
    )
end

function SmGotoFansWindow:init(params)
    self._close_callback = params.closeCallback
    self:onInit()
    return self
end

function SmGotoFansWindow:onInit()
    local csbItem = csb.createNode("activity/wonderful/fan_page.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    self:onUpdateDraw()
    self:drawBtn()
end

function SmGotoFansWindow:onEnterTransitionFinish()
end

function SmGotoFansWindow:onExit()
    state_machine.remove("sm_goto_fans_window_goto_web_page")
end
