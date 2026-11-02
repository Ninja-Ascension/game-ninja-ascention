-- ------------------------------------------------------------------------------------------------------------
--  说明：装备信息提示
-- ------------------------------------------------------------------------------------------------------------
EquipmentInforPrompt = class("EquipmentInforPromptClass", Window)

--打开界面
local equipment_infor_prompt_window_open_terminal = {
    _name = "equipment_infor_prompt_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("EquipmentInforPromptClass") == nil then
            local equipment_mould_id = params[1]
            local equipment_info = params[2]
            local _win = EquipmentInforPrompt:new()
            _win:init(equipment_mould_id, equipment_info)
            fwin:open(_win,fwin._windows)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local equipment_infor_prompt_window_close_terminal = {
    _name = "equipment_infor_prompt_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("EquipmentInforPromptClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(equipment_infor_prompt_window_open_terminal)
state_machine.add(equipment_infor_prompt_window_close_terminal)
state_machine.init()

function EquipmentInforPrompt:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._equipment_mould_id = 0
    self._equipment_info = nil

    app.load("client.red_alert_time.cells.props.props_icon_cell")
     -- Initialize alert_home state machine.
    local function init_equipment_infor_prompt_terminal()
        --分享打开
        local equipment_infor_prompt_share_open_terminal = {
            _name = "equipment_infor_prompt_share_open",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --分享关闭
        local equipment_infor_prompt_share_close_terminal = {
            _name = "equipment_infor_prompt_share_close",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        --分享到聊天
        local equipment_infor_prompt_share_chats_terminal = {
            _name = "equipment_infor_prompt_share_chats",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(params._datas.chat_type) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("equipment_infor_prompt_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("equipment_infor_prompt_share_close", 0, 0) 
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("equipment_infor_prompt_share_close", 0, "")
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                    end
                end
                
                local equip_name = dms.string(dms["equipment_mould"], instance._equipment_mould_id, equipment_mould.equipment_name)        -- 名称
                local quality = dms.int(dms["equipment_mould"], instance._equipment_mould_id, equipment_mould.grow_level)              -- 品质
                local mine_info = "|"..quality.."|"..equip_name
                local paramsInfo = "5-1-"..instance._equipment_mould_id..","..mine_info
                datas = ""
                local str =datas..chat_section[1].."79".."|"..instance._equipment_info.equipment_mould_id..","..instance._equipment_info.equipment_name..","
                            ..instance._equipment_info.upgrade_level..","..instance._equipment_info.trace_remarks.."+"..instance._equipment_info.attr
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n" .. "79".."\r\n"..paramsInfo
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(equipment_infor_prompt_share_open_terminal)    
        state_machine.add(equipment_infor_prompt_share_close_terminal)    
        state_machine.add(equipment_infor_prompt_share_chats_terminal)  
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_equipment_infor_prompt_terminal()
end

--初始化界面
function EquipmentInforPrompt:onInit()
    local csbItem = csb.createNode(config_csb.props.props_infor_prompt)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor_prompt_close"), nil, 
    {
        terminal_name = "equipment_infor_prompt_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "equipment_infor_prompt_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    -- 确定
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_infor_prompt_sure"), nil, 
    {
        terminal_name = "equipment_infor_prompt_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 分享打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_props_share"), nil, 
    {
        terminal_name = "equipment_infor_prompt_share_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  
    
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    -- 分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "equipment_infor_prompt_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
    
    -- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "equipment_infor_prompt_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "equipment_infor_prompt_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1) 

    self:onUpdateDraw()
end

-- 显示信息
function EquipmentInforPrompt:onUpdateDraw()
    local root = self.roots[1]
    
    -- icon
    local Panel_infor_prompt_icon = ccui.Helper:seekWidgetByName(root, "Panel_infor_prompt_icon")
    Panel_infor_prompt_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell",0,{8, 3, self._equipment_mould_id, 15, nil, nil, self._equipment_info})
    Panel_infor_prompt_icon:addChild(cell) 

    -- name
    local Text_infor_prompt_icon_name = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_icon_name")
    local equipment_name = dms.string(dms["equipment_mould"], self._equipment_mould_id, equipment_mould.equipment_name)
    Text_infor_prompt_icon_name:setString(equipment_name)

    -- 描述
    local Text_infor_prompt_t_1 = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_t_1")
    local Text_infor_prompt_t_2 = ccui.Helper:seekWidgetByName(root, "Text_infor_prompt_t_2")
    local Button_props_share = ccui.Helper:seekWidgetByName(root, "Button_props_share")
    local armor_type = dms.int(dms["equipment_mould"], self._equipment_mould_id, equipment_mould.equipment_seat)
    local trace_remarks = dms.string(dms["equipment_mould"], self._equipment_mould_id, equipment_mould.trace_remarks)
    Button_props_share:setVisible(false)
    if armor_type == 0 then
        Text_infor_prompt_t_1:setString(trace_remarks)
        Text_infor_prompt_t_2:setString("")
    else
        Text_infor_prompt_t_2:setString(trace_remarks)
        local attr_info = {}
        if self._equipment_info == nil then
            attr_info = zstring.split(dms.string(dms["equipment_mould"], self._equipment_mould_id, equipment_mould.initial_value), ",")
        else
            Button_props_share:setVisible(true)
            attr_info = zstring.split(self._equipment_info.attr, ",")
        end
        local attr_name = red_alert_time_attribute[tonumber(attr_info[1]) + 1]
        local attr_value = tonumber(attr_info[2])
        Text_infor_prompt_t_1:setString(""..attr_name.."+"..attr_value.."%")
    end
end

--初始化
function EquipmentInforPrompt:init(equipment_mould_id, equipment_info)
    self._equipment_mould_id = equipment_mould_id
    self._equipment_info = equipment_info

    self:onInit()
end

--移除状态机
function EquipmentInforPrompt:onExit()
    state_machine.remove("equipment_infor_prompt_share_open")
    state_machine.remove("equipment_infor_prompt_share_close")
    state_machine.remove("equipment_infor_prompt_share_chats")
end