-- ------------------------------------------------------------------------------------------------------------
--  说明：装甲查看
-- ------------------------------------------------------------------------------------------------------------
ArmorInfor = class("ArmorInforClass", Window)

--打开界面
local armor_infor_window_open_terminal = {
    _name = "armor_infor_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("ArmorInforClass") == nil then
            local _win = ArmorInfor:new()
            _win:init(params)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local armor_infor_window_close_terminal = {
    _name = "armor_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ArmorInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(armor_infor_window_open_terminal)
state_machine.add(armor_infor_window_close_terminal)
state_machine.init()

function ArmorInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._formation_type = 0
    self._armor_type = 0
    self._armor_info = nil

    local function init_armor_infor_terminal()
        --卸下
        local armor_infor_unload_terminal = {
            _name = "armor_infor_unload",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("armor_install_update", 0, "")
                        state_machine.excute("armor_equipment_update", 0, "")
                        state_machine.excute("armor_pack_update", 0, "")
                        state_machine.excute("armor_infor_window_close", 0, "")
                        TipDlg.drawTextDailog(armor_tip_str[29])
                    end
                end
                protocol_command.armor_wear.param_list = ""..instance._armor_info.formation_type.."\r\n"..instance._armor_info.equip_id.."\r\n".."1"
                NetworkManager:register(protocol_command.armor_wear.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --更换
        local armor_infor_change_terminal = {
            _name = "armor_infor_change",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local params = {instance._formation_type, instance._armor_type, instance._armor_info}
                state_machine.excute("armor_infor_window_close", 0, "")
                state_machine.excute("armor_install_window_open", 0, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --升级
        local armor_infor_up_terminal = {
            _name = "armor_infor_up",
            _init = function (terminal) 

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local armor_info = instance._armor_info
                state_machine.excute("armor_infor_window_close", 0, "")
                state_machine.excute("armor_up_window_open", 0, {armor_info})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --分享打开
        local armor_infor_share_open_terminal = {
            _name = "armor_infor_share_open",
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
        local armor_infor_share_close_terminal = {
            _name = "armor_infor_share_close",
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
        local armor_infor_share_chats_terminal = {
            _name = "armor_infor_share_chats",
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
                        state_machine.excute("armor_infor_share_close", 0, 0)         
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("armor_infor_share_close", 0, 0) 
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("armor_infor_share_close", 0, "")
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                    end
                end
                
                local equip_name = dms.string(dms["equipment_mould"], instance._armor_info.equipment_mould_id, equipment_mould.equipment_name)        -- 名称
                local quality = dms.int(dms["equipment_mould"], instance._armor_info.equipment_mould_id, equipment_mould.grow_level)              -- 品质
                local mine_info = "|"..quality.."|"..equip_name
                local paramsInfo = "5-1-"..instance._armor_info.equipment_mould_id..","..mine_info
                datas = ""
                local str =datas..chat_section[1].."79".."|"..instance._armor_info.equipment_mould_id..","..instance._armor_info.equipment_name..","
                            ..instance._armor_info.upgrade_level..","..instance._armor_info.trace_remarks.."+"..instance._armor_info.attr
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n" .. "79".."\r\n"..paramsInfo
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(armor_infor_unload_terminal)
        state_machine.add(armor_infor_change_terminal)
        state_machine.add(armor_infor_up_terminal)
        state_machine.add(armor_infor_share_open_terminal)    
        state_machine.add(armor_infor_share_close_terminal)    
        state_machine.add(armor_infor_share_chats_terminal) 
        state_machine.init()
    end
    init_armor_infor_terminal()
end

-- 显示信息
function ArmorInfor:onUpdateDraw()
    local root = self.roots[1]
    local Panel_armor_icon = ccui.Helper:seekWidgetByName(root, "Panel_armor_icon")
    local Text_armor_name = ccui.Helper:seekWidgetByName(root, "Text_armor_name")
    local Text_armor_attribute = ccui.Helper:seekWidgetByName(root, "Text_armor_attribute")
    local Text_armor_attribute_infor = ccui.Helper:seekWidgetByName(root, "Text_armor_attribute_infor")

    Panel_armor_icon:removeAllChildren(true)
    local cell = state_machine.excute("props_icon_create_cell", 0, {8, 14, self._armor_info.equipment_mould_id, 15, nil, nil, self._armor_info})
    Panel_armor_icon:addChild(cell)
    Text_armor_name:setString(self._armor_info.equipment_name)
    Text_armor_attribute_infor:setString(self._armor_info.trace_remarks)

    local attr_info = zstring.split(self._armor_info.attr, ",")
    local attr_name = red_alert_time_attribute[tonumber(attr_info[1]) + 1]
    local attr_value = tonumber(attr_info[2])
    Text_armor_attribute:setString(""..attr_name.."+"..attr_value.."%")
end

--初始化界面
function ArmorInfor:onInit()
    local csbItem = csb.createNode(config_csb.armor.armor_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_infor_close"), nil, 
    {
        terminal_name = "armor_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)    

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "armor_infor_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_unload"), nil, 
    {
        terminal_name = "armor_infor_unload", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_change"), nil, 
    {
        terminal_name = "armor_infor_change", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_armor_up"), nil, 
    {
        terminal_name = "armor_infor_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  

    -- 分享打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share"), nil, 
    {
        terminal_name = "armor_infor_share_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)  
    
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    -- 分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "armor_infor_share_close", 
        terminal_state = 0, 
    }, nil, 1)  
    
    -- 分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "armor_infor_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)  
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "armor_infor_share_chats", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1) 

    self:onUpdateDraw()
end

--初始化
function ArmorInfor:init(params)
    self._formation_type = params[1]
    self._armor_type = params[2]
    self._armor_info = params[3]

    self:onInit()
end

--移除状态机
function ArmorInfor:onExit()   
    state_machine.remove("armor_infor_unload")
    state_machine.remove("armor_infor_change")
    state_machine.remove("armor_infor_up")
    state_machine.remove("armor_infor_share_open")
    state_machine.remove("armor_infor_share_close")
    state_machine.remove("armor_infor_share_chats")
end
