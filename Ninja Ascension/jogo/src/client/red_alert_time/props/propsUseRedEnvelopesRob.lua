-- ------------------------------------------------------------------------------------------------------------
--  说明：红包抢夺
-- ------------------------------------------------------------------------------------------------------------
propsUseRedEnvelopesRob = class("propsUseRedEnvelopesRobClass", Window)

--打开界面
local props_use_red_envelopes_rob_window_open_terminal = {
    _name = "props_use_red_envelopes_rob_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("propsUseRedEnvelopesRobClass") == nil then
            local prop_id = params[1]
            local user_prop_id = params[2]
            local max_select_num = params[3]
            local pack_type = params[4]
            local _win = propsUseRedEnvelopesRob:new()
            _win:init(prop_id, user_prop_id, max_select_num,pack_type)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_use_red_envelopes_rob_window_close_terminal = {
    _name = "props_use_red_envelopes_rob_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("propsUseRedEnvelopesRobClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_use_red_envelopes_rob_window_open_terminal)
state_machine.add(props_use_red_envelopes_rob_window_close_terminal)
state_machine.init()

function propsUseRedEnvelopesRob:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop = nil
    self._max_select_num = 5
    self._select_num = 2
     -- Initialize alert_home state machine.
    local function init_props_use_red_envelopes_rob_terminal()
        --显示所有
        local props_use_red_envelopes_rob_give_legion_terminal = {
            _name = "props_use_red_envelopes_rob_give_legion",
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
        -- 分享
        local props_use_red_envelopes_rob_give_chat_terminal = {
            _name = "props_use_red_envelopes_rob_give_chat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(params._datas.chat_index) == 2 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("props_use_red_envelopes_rob_window_close", 0, 0)           
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("props_use_red_envelopes_rob_window_close", 0,0)
                        state_machine.excute("props_use_red_envelopes_window_close", 0,0)
                        TipDlg.drawTextDailog(game_share_tip_text[3])
                        -- state_machine.excute("home_horn_red_envelopes_open", 0, {})
                    end
                end
                local datas = dms.string(dms["message_share"], 74, message_share.content)
                local mine_info = _ED.user_info.user_name
                local data1 =  string.gsub(datas, "!x@", mine_info)
                datas = ""--data1
                local str = datas.."|||".."y%"
                local paramsInfo = _ED.user_info.user_name
                if params._datas.chat_index == 2 then
                    protocol_command.share_red_packet.param_list = str.."\r\n".."11".."\r\n".."".."\r\n"..instance._prop.user_prop_id.."\r\n"..instance._select_num.."\r\n0\r\n74\r\n"..paramsInfo
                else
                    protocol_command.share_red_packet.param_list = str.."\r\n".."8".."\r\n".."".."\r\n"..instance._prop.user_prop_id.."\r\n"..instance._select_num.."\r\n0\r\n74\r\n"..paramsInfo
                end
                NetworkManager:register(protocol_command.share_red_packet.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 添加使用数量
        local props_use_red_envelopes_rob_change_num_add_terminal = {
            _name = "props_use_red_envelopes_rob_change_num_add",
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
        local props_use_red_envelopes_rob_change_num_mimus_terminal = {
            _name = "props_use_red_envelopes_rob_change_num_mimus",
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
        local props_use_red_envelopes_rob_update_slider_terminal = {
            _name = "props_use_red_envelopes_rob_update_slider",
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

        state_machine.add(props_use_red_envelopes_rob_give_legion_terminal)
        state_machine.add(props_use_red_envelopes_rob_give_chat_terminal)  
        state_machine.add(props_use_red_envelopes_rob_change_num_add_terminal)  
        state_machine.add(props_use_red_envelopes_rob_change_num_mimus_terminal)  
        state_machine.add(props_use_red_envelopes_rob_update_slider_terminal)  
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_props_use_red_envelopes_rob_terminal()
end


function propsUseRedEnvelopesRob:setSelectNum(select_num)
    self._select_num = select_num
    if self._select_num > self._max_select_num then
        self._select_num = self._max_select_num
    end
    if self._select_num <= 1 then
        self._select_num = 2
    end

    local percent = math.floor((self._select_num-2) * 100 / (self._max_select_num-2))
    self:updateSliderInfo(percent)
end

--初始化界面
function propsUseRedEnvelopesRob:onInit()
    local csbItem = csb.createNode(config_csb.props.props_use_red_envelopes_rob)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_rob_close"), nil, 
    {
        terminal_name = "props_use_red_envelopes_rob_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)   
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_use_red_envelopes_rob_window_close", 
        terminal_state = 0, 
    }, nil, 3) 

    -- 发送到军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_give_legion"), nil, 
    {
        terminal_name = "props_use_red_envelopes_rob_give_chat", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        chat_index = 2,
    }, nil, 1)  

    -- 发送到世界
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_give_world"), nil, 
    {
        terminal_name = "props_use_red_envelopes_rob_give_chat", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        chat_index = 1,
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_add"), nil, 
    {
        terminal_name = "props_use_red_envelopes_rob_change_num_add", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_use_red_envelopes_rob_minus"), nil, 
    {
        terminal_name = "props_use_red_envelopes_rob_change_num_mimus", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)   

    local Slider_use_red_envelopes_rob_num = ccui.Helper:seekWidgetByName(root, "Slider_use_red_envelopes_rob_num")
    local function percentChangedEvent(sender,eventType)
        if eventType == ccui.SliderEventType.percentChanged then
            state_machine.excute("props_use_red_envelopes_rob_update_slider", 0, {sender._self, sender:getPercent()})
        end
    end
    Slider_use_red_envelopes_rob_num._self = self
    Slider_use_red_envelopes_rob_num:addEventListener(percentChangedEvent)

    self:onUpdateDraw()
end

-- 显示信息
function propsUseRedEnvelopesRob:onUpdateDraw()
    local root = self.roots[1]
    -- icon
    local Panel_use_red_envelopes_icon = ccui.Helper:seekWidgetByName(root, "Panel_use_red_envelopes_icon")
    Panel_use_red_envelopes_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{1,1,self._prop.user_prop_template,1})
    Panel_use_red_envelopes_icon:addChild(cell) 

    -- name
    local Text_use_red_envelopes_name = ccui.Helper:seekWidgetByName(root, "Text_use_red_envelopes_name")
    Text_use_red_envelopes_name:setString(self._prop.prop_name)
    -- 数量
    local shop_of_gold = dms.int(dms["prop_mould"], self._prop.user_prop_template, prop_mould.shop_of_gold)
    local Text_use_red_envelopes_gold_n = ccui.Helper:seekWidgetByName(root, "Text_use_red_envelopes_gold_n")
    Text_use_red_envelopes_gold_n:setString(shop_of_gold)
    self:setSelectNum(1)
end

function propsUseRedEnvelopesRob:updateSliderInfo(percent)
    local root = self.roots[1]

    local Slider_use_red_envelopes_rob_num = ccui.Helper:seekWidgetByName(root, "Slider_use_red_envelopes_rob_num")
    local Text_use_red_envelopes_num_n = ccui.Helper:seekWidgetByName(root, "Text_use_red_envelopes_num_n")

    self._current_silder = self._select_num / self._max_select_num * 100

    Text_use_red_envelopes_num_n:setString(self._select_num)
    Slider_use_red_envelopes_rob_num:setPercent(percent)
end

--初始化
function propsUseRedEnvelopesRob:init(prop)
    self._prop = prop
    local prop_number = dms.int(dms["prop_mould"], self._prop.user_prop_template, prop_mould.entire_purchase_count_limit)
    self._max_select_num = tonumber(prop_number)
    self:onInit()
end


--移除状态机
function propsUseRedEnvelopesRob:onExit()
    state_machine.remove("props_use_red_envelopes_rob_give_legion")
    state_machine.remove("props_use_red_envelopes_rob_change_num_mimus")
    state_machine.remove("props_use_red_envelopes_rob_change_num_add")
    state_machine.remove("props_use_red_envelopes_rob_give_chat")
    state_machine.remove("props_use_red_envelopes_rob_update_slider")
end