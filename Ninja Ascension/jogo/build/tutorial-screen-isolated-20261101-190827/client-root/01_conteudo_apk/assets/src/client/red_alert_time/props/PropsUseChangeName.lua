-- ------------------------------------------------------------------------------------------------------------
--  说明：改名卡
-- ------------------------------------------------------------------------------------------------------------
PropsUseChangeName = class("PropsUseChangeNameClass", Window)

--打开界面
local props_use_change_name_window_open_terminal = {
    _name = "props_use_change_name_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("PropsUseChangeNameClass") == nil then
            local prop = params[1]
            local prop_type = 1
            local change_user_name_id = tonumber(zstring.split(dms.string(dms["prop_config"], 27, prop_config.param), ",")[1])
            local change_user_legion_id = dms.int(dms["prop_config"], 28, prop_config.param)
            if tonumber(prop.user_prop_template) == change_user_name_id then
                prop_type = 1
            elseif tonumber(prop.user_prop_template) == change_user_legion_id then
                prop_type = 2
            end

            if prop_type == 2 then
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                    TipDlg.drawTextDailog(game_share_tip_text[2])
                    return
                elseif tonumber(_ED.union.user_union_info.union_post) ~= 1 then
                    TipDlg.drawTextDailog(red_alert_time_str[279])
                    return
                end
            end
            fwin:open(PropsUseChangeName:new():init(prop, prop_type), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local props_use_change_name_window_close_terminal = {
    _name = "props_use_change_name_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PropsUseChangeNameClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(props_use_change_name_window_open_terminal)
state_machine.add(props_use_change_name_window_close_terminal)
state_machine.init()

function PropsUseChangeName:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._prop = nil
    self._prop_type = 0

    local function init_props_use_change_name_terminal()
        local props_use_change_name_delete_terminal = {
            _name = "props_use_change_name_delete",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local root = instance.roots[1]
                local TextField_change_name = ccui.Helper:seekWidgetByName(root, "TextField_change_name")
                TextField_change_name:setString("")
                cleanEditBoxString(TextField_change_name)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local props_use_change_name_ok_terminal = {
            _name = "props_use_change_name_ok",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local roleName = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_change_name")
                local roleNameTextFieldString = roleName:getString()
                if instance._prop_type == 1 then
                    if checkUserNameLength(roleNameTextFieldString) ~= true then
                        return
                    end
                else
                    if checkLegionNameLength(roleNameTextFieldString) ~= true then
                        return
                    end
                end
                
                if instance:filter_spec_chars(roleNameTextFieldString) == true then
                    TipDlg.drawTextDailog(_string_piece_info[119])
                    return
                end 
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(red_alert_time_str[257])
                        state_machine.excute("props_use_change_name_window_close", 0, nil)
                        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, nil)
                        state_machine.excute("adventure_mine_update_user_city", 0, "")
                    end
                end

                protocol_command.prop_use.param_list = instance._prop.user_prop_id.."\r\n1\r\n6\r\n"..zstring.exchangeTo(roleNameTextFieldString)
                NetworkManager:register(protocol_command.prop_use.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(props_use_change_name_delete_terminal)
        state_machine.add(props_use_change_name_ok_terminal)
        state_machine.init()
    end
    init_props_use_change_name_terminal()
end

function PropsUseChangeName:filter_spec_chars(s)  
    local k = 1
    while k <= #s do
        local c = string.byte(s,k)  
        if not c then break end  
        if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) then  
        elseif c>=228 and c<=233 then  
            local c1 = string.byte(s,k+1)  
            local c2 = string.byte(s,k+2)  
            if c1 and c2 then  
                local a1,a2,a3,a4 = 128,191,128,191  
                if c == 228 then a1 = 184  
                elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165  
                end  
                if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then  
                    k = k + 2      
                end  
            end  
        else
            return true  
        end 
        k = k + 1 
    end  
    return false
end  

function PropsUseChangeName:onInit()
    local csbItem = csb.createNode(config_csb.props.props_use_change_name)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_name_close"), nil, 
    {
        terminal_name = "props_use_change_name_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_window_bg"), nil, 
    {
        terminal_name = "props_use_change_name_window_close", 
        terminal_state = 0, 
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_name_sure"), nil, 
    {
        terminal_name = "props_use_change_name_ok", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_change_name_delete"), nil, 
    {
        terminal_name = "props_use_change_name_delete", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
    }, nil, 1)

    self:onUpdateDraw()
end

-- 显示信息
function PropsUseChangeName:onUpdateDraw()
    local root = self.roots[1]

    local Text_change_name_title = ccui.Helper:seekWidgetByName(root, "Text_change_name_title")
    local Text_change_name_p = ccui.Helper:seekWidgetByName(root, "Text_change_name_p")
    local TextField_change_name = ccui.Helper:seekWidgetByName(root, "TextField_change_name")
    if self._prop_type == 1 then
        local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
        TextField_change_name = draw:addEditBoxEx(TextField_change_name, chat_sent_string[3], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_change_name_sure"), tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE) 
        Text_change_name_title:setString(red_alert_time_str[275])
        Text_change_name_p:setString(red_alert_time_str[277])
    elseif self._prop_type == 2 then
        local name_need_length = zstring.split(dms.string(dms["union_config"], 58, union_config.param), ",")
        TextField_change_name = draw:addEditBoxEx(TextField_change_name, tipString_legion_info[8], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_change_name_sure"),tonumber(name_need_length[2]), cc.KEYBOARD_RETURNTYPE_DONE)  
        Text_change_name_title:setString(red_alert_time_str[276])
        Text_change_name_p:setString(red_alert_time_str[278])
    end
end

--初始化
function PropsUseChangeName:init(prop, prop_type)
    self._prop = prop
    self._prop_type = prop_type
    self:onInit()
    return self
end

--移除状态机
function PropsUseChangeName:onExit()
    state_machine.remove("props_use_change_name_delete")
    state_machine.remove("props_use_change_name_ok")
end