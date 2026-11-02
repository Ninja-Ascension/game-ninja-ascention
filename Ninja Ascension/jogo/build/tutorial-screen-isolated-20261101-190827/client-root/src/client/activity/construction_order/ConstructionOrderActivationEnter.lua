--[[ ----------------------------------------------------------------------------
-- 激活战令进阶卡界面
--]] ----------------------------------------------------------------------------
ConstructionOrderActivationEnter = class("ConstructionOrderActivationEnterClass", Window)

-- 打开窗口
local construction_order_activation_enter_window_open_terminal = {
    _name = "construction_order_activation_enter_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ConstructionOrderActivationEnterClass") then
            fwin:open(ConstructionOrderActivationEnter:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local construction_order_activation_enter_window_close_terminal = {
    _name = "construction_order_activation_enter_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ConstructionOrderActivationEnterClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_activation_enter_window_open_terminal)
state_machine.add(construction_order_activation_enter_window_close_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderActivationEnter:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
   self.type = 0
   self.stage = 0

    -- Initialize construction_order_activation_enter page state machine.
    local function init_construction_order_activation_enter_terminal()
        -- 打开角色创建窗口
        local construction_order_activation_enter_open_terminal = {
            _name = "construction_order_activation_enter_open",
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
        local construction_order_activation_enter_close_terminal = {
            _name = "construction_order_activation_enter_close",
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
        local construction_order_activation_enter_show_terminal = {
            _name = "construction_order_activation_enter_show",
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
        local construction_order_activation_enter_hide_terminal = {
            _name = "construction_order_activation_enter_hide",
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

        -- 点击激活
        local construction_order_activation_enter_activation_terminal = {
            _name = "construction_order_activation_enter_activation",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 点击激活
                if nil ~= instance then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            -- 激活后的刷新
                            state_machine.excute("construction_order_main_activation_warorder", 0, nil)

                            state_machine.excute("construction_order_activation_enter_window_close", 0, nil)
                        end
                    end
                    local curType = WarOrderAllTypeEnum.ConstructionWarOrder
                    protocol_command.war_order_activation.param_list = "" .. curType .. "\r\n" .. -1
				    NetworkManager:register(protocol_command.war_order_activation.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(construction_order_activation_enter_open_terminal)
        state_machine.add(construction_order_activation_enter_close_terminal)
        state_machine.add(construction_order_activation_enter_show_terminal)
        state_machine.add(construction_order_activation_enter_hide_terminal)
        state_machine.add(construction_order_activation_enter_activation_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_construction_order_activation_enter_terminal()
end

function ConstructionOrderActivationEnter:updateDraw()
    self.Panel_icon:removeAllChildren()
    local propInfo = dms.string(dms["play_config"], 277, play_config.param)
    local iconCell = DrawHandle.drawIcon(propInfo)
    self.Panel_icon:addChild(iconCell) 
end

-- 对象初始化
function ConstructionOrderActivationEnter:init(params)
    self.type = params.type
    self.stage = params.stage
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ConstructionOrderActivationEnter:onInit(params)
    
    local csbNode = csb.createNode("activity/passport/passport_main_jianhao_unlock_0.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)


    -- 关闭界面
    self.Button_close =
    fwin:addTouchEventListener(
    ccui.Helper:seekWidgetByName(root, "Button_1"),
    nil,
    {
        terminal_name = "construction_order_activation_enter_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,
    0
    )

    -- 点击激活
    self.Button_activation =
    fwin:addTouchEventListener(
    ccui.Helper:seekWidgetByName(root, "Button_2"),
    nil,
    {
        terminal_name = "construction_order_activation_enter_activation",
        terminal_state = 0,
        isPressedActionEnabled = true,
        type = self.type,
        stage = self.stage,
    },
    nil,
    0
    )

    -- 激活道具容器
    self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")

    self:updateDraw()
end


function ConstructionOrderActivationEnter:onEnterTransitionFinish()

end

function ConstructionOrderActivationEnter:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("construction_order_activation_enter_open")
    state_machine.remove("construction_order_activation_enter_close")
    state_machine.remove("construction_order_activation_enter_show")
    state_machine.remove("construction_order_activation_enter_hide")
    state_machine.remove("construction_order_activation_enter_activation")
    
end

function ConstructionOrderActivationEnter:close()
    -- window event : close.
end

function ConstructionOrderActivationEnter:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
