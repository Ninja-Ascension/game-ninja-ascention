-- ------------------------------------------------------------------------------------------------------------
--  说明：红包赠送
-- ------------------------------------------------------------------------------------------------------------
propsUseRedEnvelopesGive = class("propsUseRedEnvelopesGiveClass", Window)

--打开界面
local props_use_red_envelopes_give_window_open_terminal = {
    _name = "props_use_red_envelopes_give_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("propsUseRedEnvelopesGiveClass") == nil then
            local prop = params[1]
            local _win = propsUseRedEnvelopesGive:new()
            _win:init(prop)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_use_red_envelopes_give_window_close_terminal = {
    _name = "props_use_red_envelopes_give_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("propsUseRedEnvelopesGiveClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_use_red_envelopes_give_window_open_terminal)
state_machine.add(props_use_red_envelopes_give_window_close_terminal)
state_machine.init()

function propsUseRedEnvelopesGive:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop = nil
    self._max_select_num = 100
    self._select_num = 1
    self._text_field_nonice = nil
    self._user_info = nil
    app.load("client.red_alert_time.chat.ChatFriendWindow")
    app.load("client.red_alert_time.chat.ChatFriendWindowListview")
    app.load("client.red_alert_time.cells.chats.chat_friend_cell")
    local function init_props_use_red_envelopes_give_terminal()
        local props_use_red_envelopes_give_change_num_add_terminal = {
            _name = "props_use_red_envelopes_give_change_num_add",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num + 1
                if select_num > instance._max_select_num then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 减少使用数量
        local props_use_red_envelopes_give_change_num_mimus_terminal = {
            _name = "props_use_red_envelopes_give_change_num_mimus",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance._max_select_num == 0 then
                    return
                end
                local select_num = instance._select_num - 1
                if select_num < 0 then
                    return
                end
                instance:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 滑块选择
        local props_use_red_envelopes_give_update_slider_terminal = {
            _name = "props_use_red_envelopes_give_update_slider",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local select_num = math.ceil(tonumber(params[2]) * params[1]._max_select_num / 100)
                params[1]:setSelectNum(select_num)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 使用
        local props_use_red_envelopes_give_sure_give_terminal = {
            _name = "props_use_red_envelopes_give_sure_give",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("props_use_red_envelopes_give_window_close", 0,0)
                        state_machine.excute("props_use_red_envelopes_window_close", 0,0)
                        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, "")
                        state_machine.excute("red_alert_time_largesse_give_hot_buy_update", 0, nil)
                        TipDlg.drawTextDailog(game_share_tip_text[3])
                    end
                end

                local user_name = instance._text_field_nonice:getString()
                if user_name == nil or user_name == "" then
                    TipDlg.drawTextDailog(chat_sent_string[8])
                    return
                end

                if user_name == _ED.user_info.user_name then
                    state_machine.excute("props_use_red_envelopes_give_window_close", 0,0)
                    state_machine.excute("props_use_red_envelopes_window_close", 0,0)
                    TipDlg.drawTextDailog(chat_sent_string[17])
                    return
                end

                local datas = dms.string(dms["message_share"], 74, message_share.content)
                local mine_info = _ED.user_info.user_name
                local data1 =  string.gsub(datas, "!x@", mine_info)
                datas = data1   
                local str = datas..chat_section[1].."74"
                protocol_command.share_red_packet.param_list = datas.."\r\n".."1".."\r\n"..user_name.."\r\n"..instance._prop.user_prop_id.."\r\n"..instance._select_num.."\r\n0\r\n0\r\n"
                NetworkManager:register(protocol_command.share_red_packet.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local props_use_red_envelopes_give_update_draw_terminal = {
            _name = "props_use_red_envelopes_give_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local user_info = params[1]
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._user_info = user_info
                    instance._text_field_nonice:setString(user_info.name)
                    local editName = instance._text_field_nonice:getChildByName("editName")
                    if editName ~= nil then
                        editName:setText(user_info.name)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 删除
        local props_use_red_envelopes_give_delete_terminal = {
            _name = "props_use_red_envelopes_give_delete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:detachWithIME()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_use_red_envelopes_give_change_num_add_terminal)  
        state_machine.add(props_use_red_envelopes_give_change_num_mimus_terminal)  
        state_machine.add(props_use_red_envelopes_give_update_slider_terminal)  
        state_machine.add(props_use_red_envelopes_give_sure_give_terminal) 
        state_machine.add(props_use_red_envelopes_give_update_draw_terminal) 
        state_machine.add(props_use_red_envelopes_give_delete_terminal) 
        state_machine.init()
    end
    init_props_use_red_envelopes_give_terminal()
end

function propsUseRedEnvelopesGive:detachWithIME()
    local root = self.roots[1]
    local roleName = ccui.Helper:seekWidgetByName(root, "TextField_use_red_envelopes_give_name")
    cleanEditBoxString(ccui.Helper:seekWidgetByName(root, "TextField_use_red_envelopes_give_name"))
    roleName:setString("")
    --roleName:didNotSelectSelf()
    cleanEditBoxString(roleName)
end

function propsUseRedEnvelopesGive:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 0 then
        self._select_num = 1
    end

    local percent = math.floor(self._select_num * 100 / self._max_select_num)
    self:updateSliderInfo(percent)
end

-- 显示信息
function propsUseRedEnvelopesGive:onUpdateDraw()
    local root = self.roots[1]

    local Text_use_red_envelopes_num_n = ccui.Helper:seekWidgetByName(root, "Text_use_red_envelopes_num_n")
    Text_use_red_envelopes_num_n:setString(""..self._select_num)

    local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
    local editName = draw:addEditBoxEx(self._text_field_nonice, chat_sent_string[20].."|"..chat_sent_string[18], "effect/effice_1500.png", nil, tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE)
    self:setSelectNum(self._select_num)
    self._text_field_nonice = editName

    -- self._text_field_nonice:setPlaceHolder(chat_sent_string[20])
    -- self._text_field_nonice:setPlaceHolderColor(cc.c4b(255, 255, 255, 255))
end

function propsUseRedEnvelopesGive:updateSliderInfo(percent)
    local root = self.roots[1]

    local Slider_use_red_envelopes_rob_num = ccui.Helper:seekWidgetByName(root, "Slider_use_red_envelopes_rob_num")
    local Text_use_red_envelopes_num_n = ccui.Helper:seekWidgetByName(root, "Text_use_red_envelopes_num_n")

    Text_use_red_envelopes_num_n:setString(self._select_num)
    Slider_use_red_envelopes_rob_num:setPercent(percent)
end

--初始化界面
function propsUseRedEnvelopesGive:onInit()
    local csbItem = csb.createNode(config_csb.props.props_use_red_envelopes_give)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    local TextField_use_red_envelopes_give_name = ccui.Helper:seekWidgetByName(root, "TextField_use_red_envelopes_give_name")
    self._text_field_nonice = TextField_use_red_envelopes_give_name

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_rob_close"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 取消
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_give_world"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)
    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_give_legion"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give_sure_give", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_add"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give_change_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_rob_minus"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give_change_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_give_delete"), nil, 
    {
        terminal_name = "props_use_red_envelopes_give_delete", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)   
    -- 联系人
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_give_person"), nil, 
    {
        terminal_name = "chat_friend_window_window_open", 
        terminal_state = 0, 
        touch_black = true,
        from_type = 4,
    }, nil, 1)

    local Slider_use_red_envelopes_rob_num = ccui.Helper:seekWidgetByName(root, "Slider_use_red_envelopes_rob_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("props_use_red_envelopes_give_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_use_red_envelopes_rob_num._self = self
    Slider_use_red_envelopes_rob_num:addEventListener(percentChangedEvent)

    self:onUpdateDraw()
end

--初始化
function propsUseRedEnvelopesGive:init(prop)
    self._prop = prop
    self._max_select_num = tonumber(prop.prop_number)
    self:onInit()
end

function propsUseRedEnvelopesGive:onExit()
    state_machine.remove("props_use_red_envelopes_give_change_num_add")
    state_machine.remove("props_use_red_envelopes_give_change_num_mimus")
    state_machine.remove("props_use_red_envelopes_give_update_slider")
    state_machine.remove("props_use_red_envelopes_give_sure_give")
    state_machine.remove("props_use_red_envelopes_give_update_draw")
    state_machine.remove("props_use_red_envelopes_give_delete")
end