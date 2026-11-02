--[[ ----------------------------------------------------------------------------
-- 锦囊分解筛选页面
--]] ----------------------------------------------------------------------------
SilkBagScreen = class("SilkBagScreenClass", Window)

-- 打开窗口
local silkbag_screen_window_open_terminal = {
    _name = "silkbag_screen_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SilkBagScreenClass") then
            fwin:open(SilkBagScreen:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local silkbag_screen_window_close_terminal = {
    _name = "silkbag_screen_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SilkBagScreenClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(silkbag_screen_window_open_terminal)
state_machine.add(silkbag_screen_window_close_terminal)
state_machine.init()

-- 构造器
function SilkBagScreen:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- var
    self._abilitySelect = {0, 0, 0, 0}
    self._abilityIdList = {2, 3, 4, 5} -- 品质 2=蓝 3=紫 4=橙 5=红
    -- load lua files.

    -- Initialize silkbag_screen page state machine.
    local function init_silkbag_screen_terminal()
        -- 打开角色创建窗口
        local silkbag_screen_open_terminal = {
            _name = "silkbag_screen_open",
            _init = function(terminal)
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

        -- 关闭角色创建窗口
        local silkbag_screen_close_terminal = {
            _name = "silkbag_screen_close",
            _init = function(terminal)
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

        -- 显示窗口
        local silkbag_screen_show_terminal = {
            _name = "silkbag_screen_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local silkbag_screen_hide_terminal = {
            _name = "silkbag_screen_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 确定条件
        local silkbag_screen_click_ok_terminal = {
            _name = "silkbag_screen_click_ok",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    local haveList = {}
                    for i, v in ipairs(instance._abilitySelect) do
                        if v == 1 then
                            table.insert(haveList, instance._abilityIdList[i])
                        end
                    end
                    state_machine.excute("silkbag_fast_resolve_screen_refresh",0,{haveList})
                    state_machine.excute("silkbag_screen_window_close",0,"")
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(silkbag_screen_open_terminal)
        state_machine.add(silkbag_screen_close_terminal)
        state_machine.add(silkbag_screen_show_terminal)
        state_machine.add(silkbag_screen_hide_terminal)
        state_machine.add(silkbag_screen_click_ok_terminal)
        state_machine.init()
    end
    -- call func init silkbag_screen state machine.
    init_silkbag_screen_terminal()
end

-- 对象初始化
function SilkBagScreen:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function SilkBagScreen:onInit(params)
    local csbNode = csb.createNode("cultivate/silk_bag_break_down_tab.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:onDrawBtn()
    self:onUpdateDraw()
end

function SilkBagScreen:onDrawBtn()
    local root = self.roots[1]
    -- 关闭
    self.Button_fenjie =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_fenjie"),
        nil,
        {
            terminal_name = "silkbag_screen_click_ok",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "silkbag_screen_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
    
end

function SilkBagScreen:updateSelect()
    local root = self.roots[1]
    for i = 1, 4 do
        local checkbox = ccui.Helper:seekWidgetByName(root, "CheckBox_" .. i)
        local isSelected = self.btnList[i].selectState
        if isSelected then
            self._abilitySelect[i] = 1
        else
            self._abilitySelect[i] = 0
        end
    end
end

function SilkBagScreen:onUpdateDraw()
    local root = self.roots[1]
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
    self.btnList = {
        ccui.Helper:seekWidgetByName(root, "CheckBox_blue"),
        ccui.Helper:seekWidgetByName(root, "CheckBox_purple"),
        ccui.Helper:seekWidgetByName(root, "CheckBox_orange"),
        ccui.Helper:seekWidgetByName(root, "CheckBox_red")
    }
    for i = 1, 4 do
        self.btnList[i]:addTouchEventListener(onOpenTouchEvent)
    end
end

function SilkBagScreen:onEnterTransitionFinish()
end

function SilkBagScreen:onExit()
    -- 释放SilkBagScreenWindow界面资源.
    state_machine.remove("silkbag_screen_open")
    state_machine.remove("silkbag_screen_close")
    state_machine.remove("silkbag_screen_show")
    state_machine.remove("silkbag_screen_hide")
    state_machine.remove("silkbag_screen_click_ok")
end

function SilkBagScreen:close()
    -- window event : close.
end

function SilkBagScreen:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
