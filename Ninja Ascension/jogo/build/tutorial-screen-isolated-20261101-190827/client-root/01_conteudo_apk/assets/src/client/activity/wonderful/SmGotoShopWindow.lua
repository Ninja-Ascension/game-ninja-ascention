-- 下包跳转商店页主界面
SmGotoShopWindow = class("SmGotoShopWindowClass", Window)

local sm_goto_shop_window_open_terminal = {
    _name = "sm_goto_shop_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("SmGotoShopWindowClass") == nil then
            fwin:open(SmGotoShopWindow:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_goto_shop_window_close_terminal = {
    _name = "sm_goto_shop_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params and params._datas.callback then
            params._datas.callback()
        end
        fwin:close(fwin:find("SmGotoShopWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_goto_shop_window_open_terminal)
state_machine.add(sm_goto_shop_window_close_terminal)
state_machine.init()

function SmGotoShopWindow:ctor()
    self.super:ctor()

    self.roots = {}
    self._close_callback = nil
    self._open_times = 0
    self._max_times = 0

    local function init_sm_goto_shop_window_terminal()
        -- 跳转网页
        local sm_goto_shop_window_goto_web_page_terminal = {
            _name = "sm_goto_shop_window_goto_web_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.lock("sm_goto_shop_window_goto_web_page", 0, "")
                local function responseOpenCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if _ED.push_goto_shop_page_url then
                            cc.Application:getInstance():openURL(_ED.push_goto_shop_page_url)
                        end
                        state_machine.unlock("sm_goto_shop_window_goto_web_page", 0, "")
                    else
                        state_machine.unlock("sm_goto_shop_window_goto_web_page", 0, "")
                    end
                end
                -- 发送用户请求跳转广告页
                protocol_command.jump_page_get_reward.param_list = ""
                NetworkManager:register(protocol_command.jump_page_get_reward.code, nil, nil, nil, instance, responseOpenCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_goto_shop_window_goto_web_page_terminal)
        state_machine.init()
    end
    init_sm_goto_shop_window_terminal()
end

function SmGotoShopWindow:handleData()
    local configInfo = dms.int(dms["user_config"], 30, user_config.param)
    if configInfo ~= nil then
        self._max_times = configInfo
    end
    local openTimesStr = "goto_shop_page_push_times"
    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_naruto then 
        -- DB和HY重置跳过
        openTimesStr = "go_store_page_push_times"
    end
    local openTimes = readKey(openTimesStr)
    local times = 1
    if openTimes ~= nil and openTimes ~= "" then
        times = tonumber(openTimes) + 1
    end
    self._open_times = times
    writeKey(openTimesStr, times)
end

function SmGotoShopWindow:onUpdateDraw()
    local root = self.roots[1]
    local Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
    if self._open_times >= self._max_times then
        Panel_1:setVisible(true)
    else
        Panel_1:setVisible(false)
    end

    local skipState = readKey("goto_shop_page_push_skip") --跳过:1
    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_naruto then 
        -- DB和HY重置跳过
        skipState = readKey("go_store_page_push_skip")
    end
    local CheckBox_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_1")
    if skipState ~= nil and (skipState == "" or tostring(skipState) ~= "1") then
        -- 关闭
        CheckBox_1:setSelected(false)
    else
        -- 打开
        CheckBox_1:setSelected(true)
    end
end
function SmGotoShopWindow:updateSelect()
    local root = self.roots[1]
    local checkbox = ccui.Helper:seekWidgetByName(root, "CheckBox_1")
    local isSelected = checkbox.selectState
    local push_key_str = "goto_shop_page_push_skip"
    if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_naruto then 
        -- DB和HY重置跳过
        push_key_str = "go_store_page_push_skip"
    end
    if isSelected then
        writeKey(push_key_str, "1")
    else
        writeKey(push_key_str, "0")
    end
end

function SmGotoShopWindow:drawBtn()
    local root = self.roots[1]
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "sm_goto_shop_window_close",
            terminal_state = 0,
            touch_black = true,
            callback = self._close_callback
        },
        nil,
        3
    )

    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_7"),
        nil,
        {
            terminal_name = "sm_goto_shop_window_goto_web_page",
            terminal_state = 0,
            touch_black = true
        },
        nil,
        3
    )
    local function onOpenTouchEvent(sender, eventType)
        if eventType == ccui.TouchEventType.ended or eventType == ccui.TouchEventType.canceled then
            if sender.selectState then
				sender.selectState = false
			else
				sender.selectState = true
			end
            self:updateSelect()
        end
    end
    local CheckBox_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_1")
    CheckBox_1:addTouchEventListener(onOpenTouchEvent)
end

function SmGotoShopWindow:init(params)
    self._close_callback = params.closeCallback
    self:onInit()
    return self
end

function SmGotoShopWindow:onInit()
    local csbItem = csb.createNode("utils/Official_Notice.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    self:handleData()
    self:onUpdateDraw()
    self:drawBtn()
end

function SmGotoShopWindow:onEnterTransitionFinish()
end

function SmGotoShopWindow:onExit()
    state_machine.remove("sm_goto_shop_window_goto_web_page")
end
