-- ------------------------------------------------------------------------------------------------------------
--  说明：使用红包
-- ------------------------------------------------------------------------------------------------------------
propsUseRedEnvelopes = class("propsUseRedEnvelopesClass", Window)

--打开界面
local props_use_red_envelopes_window_open_terminal = {
    _name = "props_use_red_envelopes_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("propsUseRedEnvelopesClass") == nil then
            local _win = propsUseRedEnvelopes:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_use_red_envelopes_window_close_terminal = {
    _name = "props_use_red_envelopes_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("propsUseRedEnvelopesClass"))
        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, nil)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_use_red_envelopes_window_open_terminal)
state_machine.add(props_use_red_envelopes_window_close_terminal)
state_machine.init()

function propsUseRedEnvelopes:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop = nil

    app.load("client.red_alert_time.props.propsUseRedEnvelopesGive")
    app.load("client.red_alert_time.props.propsUseRedEnvelopesRob")
     -- Initialize alert_home state machine.
    local function init_props_use_red_envelopes_terminal()
        -- 红包抢夺
        local props_use_red_envelopes_rob_terminal = {
            _name = "props_use_red_envelopes_rob",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("props_use_red_envelopes_rob_window_open",0,{instance._prop})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 赠送好友
        local props_use_red_envelopes_give_terminal = {
            _name = "props_use_red_envelopes_give",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("props_use_red_envelopes_give_window_open",0,{instance._prop})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_use_red_envelopes_rob_terminal)
        state_machine.add(props_use_red_envelopes_give_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_use_red_envelopes_terminal()
end

--显示
function propsUseRedEnvelopes:onShow()
   self:setVisible(true)
end

--隐藏
function propsUseRedEnvelopes:onHide()
   self:setVisible(false)
end

--初始化界面
function propsUseRedEnvelopes:onInit()
    local csbItem = csb.createNode(config_csb.props.props_use_red_envelopes)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_close"), nil, 
    {
        terminal_name = "props_use_red_envelopes_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_use_red_envelopes_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 红包抢夺
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_rob"), nil, 
    {
        terminal_name = "props_use_red_envelopes_rob", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    -- 赠送好友
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_give"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:onUpdateDraw()
end

-- 显示信息
function propsUseRedEnvelopes:onUpdateDraw()
    local root = self.roots[1]
    
end

--初始化
function propsUseRedEnvelopes:init(params)
    self._prop = params[1]
    self:onInit()
end

--移除状态机
function propsUseRedEnvelopes:onExit()
    state_machine.remove("props_use_red_envelopes_rob")
    state_machine.remove("props_use_red_envelopes_give")
end