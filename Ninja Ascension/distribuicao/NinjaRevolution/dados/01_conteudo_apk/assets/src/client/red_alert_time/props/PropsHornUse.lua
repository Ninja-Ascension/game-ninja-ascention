-- ------------------------------------------------------------------------------------------------------------
--  说明：道具喇叭使用界面
-- ------------------------------------------------------------------------------------------------------------
PropsHornUse = class("PropsHornUseClass", Window)

--打开界面
local props_horn_use_window_open_terminal = {
    _name = "props_horn_use_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("PropsHornUseClass") == nil then
            local prop = params[1]
            local _win = PropsHornUse:new()
            _win:init(prop)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_horn_use_window_close_terminal = {
    _name = "props_horn_use_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsHornUseClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_horn_use_window_open_terminal)
state_machine.add(props_horn_use_window_close_terminal)
state_machine.init()

function PropsHornUse:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop = nil
    self._text_field = nil

     -- Initialize alert_home state machine.
    local function init_props_horn_use_terminal()
        local props_horn_use_send_terminal = {
            _name = "props_horn_use_send",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local msg = instance._text_field:getString()
                if msg == nil or msg == "" or string.gsub(string.gsub(msg, "^%s+", ""), "%s+$", "") == "" then
                    TipDlg.drawTextDailog(red_alert_time_str[90])
                    return
                end
                local length_info = zstring.split(dms.string(dms["prop_config"], 35, prop_config.param), ",")
                local max_length = 0
                if string.utf8.findChinese(string.utf8.chars(msg)) == true then
                    max_length = tonumber(length_info[2])
                else
                    max_length = tonumber(length_info[1])
                end
                if string.utf8.len(msg) > max_length then
                    TipDlg.drawTextDailog(string.format(red_alert_time_str[88], tonumber(length_info[2])))
                    return
                end

                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("props_horn_use_window_close", 0, "")
                        TipDlg.drawTextDailog(red_alert_time_str[89])
                        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, nil)
                    end
                end
                protocol_command.horn_use.param_list = instance._prop.user_prop_id.."\r\n"..zstring.exchangeTo(msg)
                NetworkManager:register(protocol_command.horn_use.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        state_machine.add(props_horn_use_send_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_horn_use_terminal()
end

-- 显示信息
function PropsHornUse:onUpdateDraw()
    local root = self.roots[1]
    local Text_horn_use_t = ccui.Helper:seekWidgetByName(root, "Text_horn_use_t")
    Text_horn_use_t:setString(string.format(red_alert_time_str[87], self._prop.prop_name))
end

--初始化界面
function PropsHornUse:onInit()
    local csbItem = csb.createNode(config_csb.props.props_horn_use)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    local TextField_horn_infor = ccui.Helper:seekWidgetByName(root, "TextField_horn_infor")
    local length_info = zstring.split(dms.string(dms["prop_config"], 35, prop_config.param), ",")
    TextField_horn_infor = draw:addEditBoxEx(TextField_horn_infor, chat_sent_string[6], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_horn_infor_sent"), tonumber(length_info[1]), cc.KEYBOARD_RETURNTYPE_DONE)     
    self._text_field = TextField_horn_infor

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_props_use_close"), nil, 
    {
        terminal_name = "props_horn_use_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 发送
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_horn_infor_sent"), nil, 
    {
        terminal_name = "props_horn_use_send", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    self:onUpdateDraw()
end

--初始化
function PropsHornUse:init(prop)
    self._prop = prop
    self:onInit()
end

--移除状态机
function PropsHornUse:onExit()
    state_machine.remove("props_horn_use_send")
end