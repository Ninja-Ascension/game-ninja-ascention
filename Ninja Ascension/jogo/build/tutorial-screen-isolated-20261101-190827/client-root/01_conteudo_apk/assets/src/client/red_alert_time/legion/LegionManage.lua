-- ------------------------------------------------------------------------------------------------------------
--  说明：军团管理
-- ------------------------------------------------------------------------------------------------------------
LegionManage = class("LegionManageClass", Window)

--打开界面
local legion_manage_window_open_terminal = {
    _name = "legion_manage_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionManageClass") == nil then
            local info_data = params[1]
            local _win = LegionManage:new()
            _win:init(info_data)
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_manage_window_close_terminal = {
    _name = "legion_manage_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionManageClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_manage_window_open_terminal)
state_machine.add(legion_manage_window_close_terminal)
state_machine.init()

function LegionManage:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._text_field_nonice = nil
    self._text_field_watchword = nil
    self._text_nonice = nil
    self._text_watchword = nil

    self._max_nonice_length = 0
    self._max_watchword_length = 0

    self._is_verfication = true

    self._panel_concition_level = nil
    self._panel_concition_fight = nil
    self._text_condition_level = nil
    self._text_condition_fight = nil

    self._condition_fight = 0
    self._condition_level = 0

    self._info_data = nil 

    app.load("client.red_alert_time.cells.player.input_digital_window")
    app.load("client.red_alert_time.mail.MailWriteAn")

     -- Initialize alert_home state machine.
    local function init_legion_manage_terminal()
        -- 保存设置
        local legion_manage_save_terminal = {
            _name = "legion_manage_save",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_manage_close_input_digital", 0, "")
                if #instance._text_field_nonice:getString() == 0 then
                    instance._text_field_nonice:setString(tipString_legion_info[24])
                end
                if #instance._text_field_watchword:getString() == 0 then
                    instance._text_field_watchword:setString(tipString_legion_info[14])
                end
                local nonice_str = zstring.exchangeTo(instance._text_field_nonice:getString())
                if string.utf8.len(instance._text_field_nonice:getString()) > instance._max_nonice_length then
                    TipDlg.drawTextDailog(string.format(tipString_legion_info[41] , instance._max_nonice_length))
                    return
                end

                local declaration_str = zstring.exchangeTo(instance._text_field_watchword:getString())
                if string.utf8.len(instance._text_field_watchword:getString()) > instance._max_watchword_length then
                    TipDlg.drawTextDailog(string.format(tipString_legion_info[16], instance._max_watchword_length))
                    return
                end

                local is_verfication = 0
                if instance._is_verfication == true then
                    is_verfication = 1
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("legion_manage_window_close", 0, "")
                        end
                        TipDlg.drawTextDailog(tipString_legion_info[25])
                        state_machine.excute("legion_infomation_update_draw", 0, "")
                    end
                end
                protocol_command.union_setting_manage.param_list = nonice_str.."\r\n"..declaration_str.."\r\n"..is_verfication.."\r\n"..instance._condition_level.."\r\n"..instance._condition_fight
                NetworkManager:register(protocol_command.union_setting_manage.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 退出军团
        local legion_manage_go_out_terminal = {
            _name = "legion_manage_go_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.union.user_union_info.union_post) == 1 and tonumber(_ED.union.union_info.members) > 1 then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[46])
                else
                    state_machine.excute("legion_exit_prompt_window_open", 0, {instance._info_data.id})
                    -- local tip = ConfirmTip:new()
                    -- tip:init(instance, instance.quxSureTipCallBack, tipStringInfo_union_str[47])
                    -- fwin:open(tip, fwin._ui)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 是否需要验证
        local legion_manage_add_verfication_terminal = {
            _name = "legion_manage_add_verfication",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_manage_close_input_digital", 0, "")
                instance:changeVerfication()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 等级要求
        local legion_manage_add_condition_level_terminal = {
            _name = "legion_manage_add_condition_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_manage_close_input_digital", 0, "")
                local cell = InputDigitalWindow:createCell()
                cell:init(4)
                instance._panel_concition_level:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战力要求
        local legion_manage_add_condition_fight_terminal = {
            _name = "legion_manage_add_condition_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_manage_close_input_digital", 0, "")
                local cell = InputDigitalWindow:createCell()
                cell:init(5)
                instance._panel_concition_fight:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新等级和战力需求
        local legion_manage_update_add_condition_terminal = {
            _name = "legion_manage_update_add_condition",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params[1] ~= nil then
                    instance._condition_level = params[1]
                    instance._text_condition_level:setString(params[1])
                end
                if params[2] ~= nil then
                    instance._condition_fight = params[2]
                    instance._text_condition_fight:setString(exChangeNumToString(params[2]))
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭键盘
        local legion_manage_close_input_digital_terminal = {
            _name = "legion_manage_close_input_digital",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._panel_concition_level:removeAllChildren(true)
                instance._panel_concition_fight:removeAllChildren(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 分享到世界进行招募玩家
        local legion_manage_recruit_player_terminal = {
            _name = "legion_manage_recruit_player",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local now_time = os.time()
                local last_time = zstring.tonumber(cc.UserDefault:getInstance():getStringForKey(getKey("legion_watchword_time")))
                local need_interval_time = dms.int(dms["union_config"], 57, union_config.param)
                if now_time - last_time < need_interval_time * 60 then
                    TipDlg.drawTextDailog(string.format(tipString_legion_info[48], need_interval_time))
                    return
                end

                local recruit_dex = _ED.union.union_info.watchword--self._text_field_watchword:getString()
                local datas = dms.string(dms["message_share"], 52, message_share.content)
                local data1 =  string.gsub(datas, "!x@", _ED.union.union_info.union_name)
                local data2 =  string.gsub(data1, "!y@", recruit_dex)
                datas = data2
                local str = ""--datas
                local paramsInfo = "0-0,".._ED.union.union_info.union_name..","..recruit_dex
                if dms.int(dms["message_share"], 52, message_share.jump_type) ~= -1 then
                    str = str..chat_section[1]..dms.int(dms["message_share"], 52, message_share.jump_type)
                end
                str = str.."|||".._ED.union.union_info.need_verify..",".._ED.union.union_info.union_id..",".._ED.union.union_info.union_grade
                ..",".._ED.union.union_info.union_camp..",".._ED.union.union_info.union_head_name..",".._ED.union.union_info.members
                ..",".._ED.union.union_info.need_level..",".._ED.union.union_info.combat_force..",".._ED.union.union_info.ranking
                ..",".._ED.union.union_info.union_name..",".._ED.union.union_info.watchword..",".._ED.union.union_info.need_combat_force

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local now_time = os.time()
                        cc.UserDefault:getInstance():setStringForKey(getKey("legion_watchword_time"), ""..now_time)
                        TipDlg.drawTextDailog(tipString_legion_info[47])
                    end
                end


                protocol_command.send_message.param_list = zstring.exchangeTo(str).."\r\n13\r\n0\r\n52\r\n"..zstring.exchangeTo(paramsInfo)
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, nil, responseCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 按钮状态刷新
        local legion_manage_update_button_terminal = {
            _name = "legion_manage_update_button",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateButton()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_manage_save_terminal)
        state_machine.add(legion_manage_add_verfication_terminal)
        state_machine.add(legion_manage_add_condition_level_terminal)
        state_machine.add(legion_manage_add_condition_fight_terminal)
        state_machine.add(legion_manage_close_input_digital_terminal)
        state_machine.add(legion_manage_update_add_condition_terminal)
        state_machine.add(legion_manage_go_out_terminal)
        state_machine.add(legion_manage_recruit_player_terminal)
        state_machine.add(legion_manage_update_button_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_manage_terminal()
end


function LegionManage:quxSureTipCallBack(n)
    if n ~= 0 then
        return
    end
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            state_machine.excute("legion_manage_window_close", 0, nil)
            state_machine.excute("legion_clean_all_data", 0, nil)
            state_machine.excute("legion_window_open", 0, "")
        end
    end
    protocol_command.union_appoint.param_list = _ED.union.union_info.union_id.."\r\n"..self._info_data.id.."\r\n5"
    NetworkManager:register(protocol_command.union_appoint.code, nil, nil, nil, self, responseCallback, false, nil)
end

function LegionManage:changeVerfication()
    local root = self.roots[1]
    local Text_add_verfication_t_1 = ccui.Helper:seekWidgetByName(root, "Text_add_verfication_t_1")
    local Text_add_verfication_t_2 = ccui.Helper:seekWidgetByName(root, "Text_add_verfication_t_2")
    local Image_add_verfication_state = ccui.Helper:seekWidgetByName(root, "Image_add_verfication_state")

    if self._is_verfication == true then
        self._is_verfication = false
        Image_add_verfication_state:setPosition(Text_add_verfication_t_2:getPosition())
    else
        self._is_verfication = true
        Image_add_verfication_state:setPosition(Text_add_verfication_t_1:getPosition())
    end
end

-- 显示信息
function LegionManage:onUpdateDraw()
    local root = self.roots[1]
    local Text_legion_name_p = ccui.Helper:seekWidgetByName(root, "Text_legion_name_p")
    local Text_recruit_declaration_p_2 = ccui.Helper:seekWidgetByName(root, "Text_recruit_declaration_p_2")
    Text_legion_name_p:setString(string.format(tipString_legion_info[10], string.utf8.len(self._text_field_nonice:getString()), self._max_nonice_length))
    Text_recruit_declaration_p_2:setString(string.format(tipString_legion_info[10], string.utf8.len(self._text_field_watchword:getString()), self._max_watchword_length))
    self._text_nonice = Text_legion_name_p
    self._text_watchwordt = Text_recruit_declaration_p_2

    local Panel_num_input_lv = ccui.Helper:seekWidgetByName(root, "Panel_num_input_lv")
    local Panel_num_input_fight = ccui.Helper:seekWidgetByName(root, "Panel_num_input_fight")
    local Text_add_condition_lv = ccui.Helper:seekWidgetByName(root, "Text_add_condition_lv")
    local Text_add_condition_fight = ccui.Helper:seekWidgetByName(root, "Text_add_condition_fight")
    self._panel_concition_level = Panel_num_input_lv
    self._panel_concition_fight = Panel_num_input_fight
    self._text_condition_level = Text_add_condition_lv
    self._text_condition_fight = Text_add_condition_fight

    local Text_add_verfication_t_1 = ccui.Helper:seekWidgetByName(root, "Text_add_verfication_t_1")
    local Text_add_verfication_t_2 = ccui.Helper:seekWidgetByName(root, "Text_add_verfication_t_2")
    local Image_add_verfication_state = ccui.Helper:seekWidgetByName(root, "Image_add_verfication_state")
    self._text_field_nonice:setString(_ED.union.union_info.bulletin)
    self._text_field_watchword:setString(_ED.union.union_info.watchword)

    local edit_nonice = self._text_field_nonice:getChildByName("editName")
    if edit_nonice ~= nil then
        edit_nonice:setText(_ED.union.union_info.bulletin)
    end
    local edit_watchword = self._text_field_watchword:getChildByName("editName")
    if edit_watchword ~= nil then
        edit_watchword:setText(_ED.union.union_info.watchword)
    end

    self._condition_level = tonumber(_ED.union.union_info.need_level)
    self._condition_fight = tonumber(_ED.union.union_info.need_combat_force)
    self._text_condition_level:setString(self._condition_level)
    self._text_condition_fight:setString(exChangeNumToString(self._condition_fight))
    if tonumber(_ED.union.union_info.need_verify) == 0 then
        self._is_verfication = false
        Image_add_verfication_state:setPosition(Text_add_verfication_t_2:getPosition())
    else
        self._is_verfication = true
        Image_add_verfication_state:setPosition(Text_add_verfication_t_1:getPosition())
    end

end

function LegionManage:onUpdateButton()
    local root = self.roots[1]
    local Button_legion_recruit = ccui.Helper:seekWidgetByName(root, "Button_legion_recruit")
    local Panel_add_verfication = ccui.Helper:seekWidgetByName(root, "Panel_add_verfication")
    local Image_add_condition_fight = ccui.Helper:seekWidgetByName(root, "Image_add_condition_fight")
    local Image_add_condition_lv = ccui.Helper:seekWidgetByName(root, "Image_add_condition_lv")
    local Button_establish_1 = ccui.Helper:seekWidgetByName(root, "Button_establish_1")
    local Button_establish_0 = ccui.Helper:seekWidgetByName(root, "Button_establish_0")

    if tonumber(_ED.union.user_union_info.union_post) > 2 then
        local edit_nonice = self._text_field_nonice:getChildByName("editName")
        if edit_nonice ~= nil then
            edit_nonice:setTouchEnabled(false)
        end
        local edit_watchword = self._text_field_watchword:getChildByName("editName")
        if edit_watchword ~= nil then
            edit_watchword:setTouchEnabled(false)
        end
        self._text_field_nonice:setTouchEnabled(false)
        self._text_field_watchword:setTouchEnabled(false)
        Button_legion_recruit:setBright(false)
        Button_legion_recruit:setTouchEnabled(false)
        Panel_add_verfication:setTouchEnabled(false)
        Image_add_condition_fight:setTouchEnabled(false)
        Image_add_condition_lv:setTouchEnabled(false)
        Button_establish_1:setBright(false)
        Button_establish_1:setTouchEnabled(false)
        Button_establish_0:setBright(false)
        Button_establish_0:setTouchEnabled(false)
    else
        local edit_nonice = self._text_field_nonice:getChildByName("editName")
        if edit_nonice ~= nil then
            edit_nonice:setTouchEnabled(true)
        end
        local edit_watchword = self._text_field_watchword:getChildByName("editName")
        if edit_watchword ~= nil then
            edit_watchword:setTouchEnabled(true)
        end
        Button_legion_recruit:setBright(true)
        Button_legion_recruit:setTouchEnabled(true)
        Panel_add_verfication:setTouchEnabled(true)
        Image_add_condition_fight:setTouchEnabled(true)
        Image_add_condition_lv:setTouchEnabled(true)
        Button_establish_1:setBright(true)
        Button_establish_1:setTouchEnabled(true)
        Button_establish_0:setBright(true)
        Button_establish_0:setTouchEnabled(true)
    end

    if #self._text_field_nonice:getString() == 0 then
        self._text_field_nonice:setString(tipString_legion_info[24])
    end

    if #self._text_field_watchword:getString() == 0 then
        self._text_field_watchword:setString(tipString_legion_info[14])
    end
    -- self._text_field_nonice:setPlaceHolderColor(cc.c4b(255, 255, 255, 255))
    -- self._text_field_watchword:setPlaceHolderColor(cc.c4b(255, 255, 255, 255))
end

function LegionManage:onUpdate()
    if self.roots ~= nil and self.roots[1] ~= nil then
        self._text_nonice:setString(string.format(tipString_legion_info[10], string.utf8.len(self._text_field_nonice:getString()), self._max_nonice_length))
        self._text_watchwordt:setString(string.format(tipString_legion_info[10], string.utf8.len(self._text_field_watchword:getString()), self._max_watchword_length))
    end
end

--初始化界面
function LegionManage:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_manage)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    local TextField_legion_nonice = ccui.Helper:seekWidgetByName(root, "TextField_legion_nonice")
    local TextField_recruit_declaration = ccui.Helper:seekWidgetByName(root, "TextField_recruit_declaration")

    self._text_field_nonice = TextField_legion_nonice
    self._text_field_watchword = TextField_recruit_declaration

    local nonice_max_length = dms.int(dms["union_config"], 23, union_config.param)
    local declaration_max_length = dms.int(dms["union_config"], 24, union_config.param)
    self._max_nonice_length = nonice_max_length
    self._max_watchword_length = declaration_max_length
    draw:addEditBoxEx(self._text_field_nonice, tipString_legion_info[52], "effect/effice_1500.png", Panel_add_verfication, nonice_max_length, cc.KEYBOARD_RETURNTYPE_DONE, nil, nil, self._text_field_nonice)  
    draw:addEditBoxEx(self._text_field_watchword, tipString_legion_info[9], "effect/effice_1500.png", Panel_add_verfication, declaration_max_length, cc.KEYBOARD_RETURNTYPE_DONE, nil, nil, self._text_field_watchword)  


    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish_close"), nil, 
    {
        terminal_name = "legion_manage_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 保存设置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish_0"), nil, 
    {
        terminal_name = "legion_manage_save", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 协防设置
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish"), nil, 
    {
        terminal_name = "legion_set_attack_help_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 军团邮件
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish_1"), nil, 
    {
        terminal_name = "legion_mail_write_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        ntype = 2,
    }, nil, 1)

    -- 退出军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish_1_0"), nil, 
    {
        terminal_name = "legion_manage_go_out", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 是否需要验证
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_add_verfication"), nil, 
    {
        terminal_name = "legion_manage_add_verfication", 
        terminal_state = 0, 
    }, nil, 1)

    -- 等级要求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_add_condition_lv"), nil, 
    {
        terminal_name = "legion_manage_add_condition_level", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 战力要求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_add_condition_fight"), nil, 
    {
        terminal_name = "legion_manage_add_condition_fight", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_bg"), nil, 
    {
        terminal_name = "legion_manage_close_input_digital", 
        terminal_state = 0, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_res_infor_bg_1"), nil, 
    {
        terminal_name = "legion_manage_close_input_digital", 
        terminal_state = 0, 
    }, nil, 1)

    --军团世界邀请
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_legion_recruit"), nil, 
    {
        terminal_name = "legion_manage_recruit_player", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    self:onUpdateButton()
    self:onUpdateDraw()
end

--初始化
function LegionManage:init(info_data)
    self._info_data = info_data
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function LegionManage:onExit()
    state_machine.remove("legion_manage_save")
    state_machine.remove("legion_manage_add_verfication")
    state_machine.remove("legion_manage_add_condition_level")
    state_machine.remove("legion_manage_add_condition_fight")
    state_machine.remove("legion_manage_close_input_digital")
    state_machine.remove("legion_manage_update_add_condition")
    state_machine.remove("legion_manage_go_out")
    state_machine.remove("legion_manage_update_button")
end