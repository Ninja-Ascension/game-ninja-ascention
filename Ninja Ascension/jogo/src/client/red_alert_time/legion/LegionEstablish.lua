-- ------------------------------------------------------------------------------------------------------------
--  说明：创建军团
-- ------------------------------------------------------------------------------------------------------------
LegionEstablish = class("LegionEstablishClass", Window)

--打开界面
local legion_establish_window_open_terminal = {
    _name = "legion_establish_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if fwin:find("LegionEstablishClass") == nil then
            local _win = LegionEstablish:new()
            _win:init()
            fwin:open(_win,fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local legion_establish_window_close_terminal = {
    _name = "legion_establish_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LegionEstablishClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(legion_establish_window_open_terminal)
state_machine.add(legion_establish_window_close_terminal)
state_machine.init()

function LegionEstablish:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self._text_field_name = nil
    self._text_field_watchword = nil
    self._text_name = nil
    self._text_watchword = nil

    self._is_verfication = true

    self._panel_concition_level = nil
    self._panel_concition_fight = nil
    self._text_condition_level = nil
    self._text_condition_fight = nil

    self._condition_fight = 0
    self._condition_level = 0

    self._check_box_res = nil
    self._check_box_gold = nil

    self._need_vip_level = 0

    self._need_resource = 0             -- 缺少的资源

    self._max_name_length = 0           -- 军团名最大长度
    self._max_watchwordt_length = 0     -- 招募宣言最大长度

    app.load("client.red_alert_time.cells.player.input_digital_window")

     -- Initialize alert_home state machine.
    local function init_legion_establish_terminal()
        -- 创建军团
        local legion_establish_establish_legion_terminal = {
            _name = "legion_establish_establish_legion",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_establish_close_input_digital", 0, "")

                if #instance._text_field_watchword:getString() == 0 then
                    instance._text_field_watchword:setString(tipString_legion_info[14])
                end
                local legion_name = instance._text_field_name:getString()
                if zstring.checkNikenameChar(legion_name) == true then
                    TipDlg.drawTextDailog(tipStringInfo_union_str[37])
                    return
                end
                local name_str = zstring.exchangeTo(legion_name)
                if checkLegionNameLength(name_str) ~= true then
                    return
                end

                if instance:filter_spec_chars(name_str) == true then
                    TipDlg.drawTextDailog(tipString_legion_info[51])
                    return
                end

                local declaration_str = zstring.exchangeTo(instance._text_field_watchword:getString())
                if string.utf8.len(declaration_str) > instance._max_watchwordt_length then
                    TipDlg.drawTextDailog(tipString_legion_info[16])
                    return
                end

                local establish_type = 0
                if instance._check_box_res:isSelected() == true then
                    establish_type = 1
                elseif tonumber(_ED.vip_grade) >= tonumber(instance._need_vip_level) then
                    establish_type = 2
                end

                local res_id = {1, 33, 41, 42}
                if establish_type == 1 then
                    if self._need_resource > 0 then
                        TipDlg.drawTextDailog(reward_prop_list[res_id[self._need_resource]]..red_alert_time_str[247])
                        return
                    end
                end

                local is_verfication = 0
                if instance._is_verfication == true then
                    is_verfication = 1
                end

                local function sendEstablishMessage()
                    local datas = dms.string(dms["message_notification_param"], 146, message_notification_param.content)
                    local data1 =  string.gsub(datas, "!x@", _ED.user_info.user_name)
                    local data2 =  string.gsub(data1, "!y@", _ED.union.union_info.union_name)
                    datas = data2
                    local paramsInfo = _ED.user_info.user_name.."|".._ED.union.union_info.union_name
                    -- local paramsInfo = "0-0,".._ED.user_info.user_name..",".._ED.union.union_info.union_name
                    local str = ""--datas
                    if dms.int(dms["message_notification_param"], 146, message_notification_param.jump_type) ~= -1 then
                        str = str..chat_section[1]..dms.int(dms["message_notification_param"], 146, message_notification_param.jump_type)
                    end
                    str = str.."|||".._ED.union.union_info.need_verify..",".._ED.union.union_info.union_id..",".._ED.union.union_info.union_grade
                    ..",".._ED.union.union_info.union_camp..",".._ED.union.union_info.union_head_name..",".._ED.union.union_info.members
                    ..",".._ED.union.union_info.need_level..",".._ED.union.union_info.combat_force..",".._ED.union.union_info.ranking
                    ..",".._ED.union.union_info.union_name..",".._ED.union.union_info.watchword..",".._ED.union.union_info.need_combat_force

                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            local now_time = os.time()
                            cc.UserDefault:getInstance():setStringForKey(getKey("legion_watchword_time"), ""..now_time)
                        end
                    end
                    protocol_command.send_message.param_list = zstring.exchangeTo(str).."\r\n".."12".. "\r\n0\r\n146\r\n" .. zstring.exchangeTo(paramsInfo)
                    -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, nil, responseCallback, false, nil)
                    NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                    responseCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                end

                local function responseUnionCreateCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("legion_establish_window_close", 0, "")
                            sendEstablishMessage()
                        end
                        state_machine.excute("legion_window_open", 0, "")
                    end
                end
                protocol_command.union_create.param_list = name_str.."\r\n"..establish_type.."\r\n"..declaration_str.."\r\n"..is_verfication.."\r\n"..instance._condition_level.."\r\n"..instance._condition_fight
                NetworkManager:register(protocol_command.union_create.code, nil, nil, nil, instance, responseUnionCreateCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 是否需要验证
        local legion_establish_add_verfication_terminal = {
            _name = "legion_establish_add_verfication",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_establish_close_input_digital", 0, "")
                instance:changeVerfication()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 等级要求
        local legion_establish_add_condition_level_terminal = {
            _name = "legion_establish_add_condition_level",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_establish_close_input_digital", 0, "")
                local cell = InputDigitalWindow:createCell()
                cell:init(2)
                instance._panel_concition_level:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战力要求
        local legion_establish_add_condition_fight_terminal = {
            _name = "legion_establish_add_condition_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_establish_close_input_digital", 0, "")
                local cell = InputDigitalWindow:createCell()
                cell:init(3)
                instance._panel_concition_fight:addChild(cell)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新等级和战力需求
        local legion_establish_update_add_condition_terminal = {
            _name = "legion_establish_update_add_condition",
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
        local legion_establish_close_input_digital_terminal = {
            _name = "legion_establish_close_input_digital",
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

        -- 选择创建消耗
        local legion_establish_select_terminal = {
            _name = "legion_establish_select",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("legion_establish_close_input_digital", 0, "")
                instance._check_box_res:setSelected(false)
                instance._check_box_gold:setSelected(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(legion_establish_establish_legion_terminal)
        state_machine.add(legion_establish_add_verfication_terminal)
        state_machine.add(legion_establish_add_condition_level_terminal)
        state_machine.add(legion_establish_add_condition_fight_terminal)
        state_machine.add(legion_establish_close_input_digital_terminal)
        state_machine.add(legion_establish_update_add_condition_terminal)
        state_machine.add(legion_establish_select_terminal)
        state_machine.init()
    end
    -- call func alert_home create state machine.
    init_legion_establish_terminal()
end

function LegionEstablish:filter_spec_chars(s)  
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

function LegionEstablish:changeVerfication()
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
function LegionEstablish:onUpdateDraw()
    local root = self.roots[1]
    local Text_legion_name_p = ccui.Helper:seekWidgetByName(root, "Text_legion_name_p")
    local Text_recruit_declaration_p_2 = ccui.Helper:seekWidgetByName(root, "Text_recruit_declaration_p_2")
    Text_legion_name_p:setString(string.format(tipString_legion_info[54], string.utf8.len(self._text_field_name:getString()), self._max_name_length))
    Text_recruit_declaration_p_2:setString(string.format(tipString_legion_info[10], string.utf8.len(self._text_field_watchword:getString()), self._max_watchwordt_length))
    self._text_name = Text_legion_name_p
    self._text_watchwordt = Text_recruit_declaration_p_2

    local Panel_num_input_lv = ccui.Helper:seekWidgetByName(root, "Panel_num_input_lv")
    local Panel_num_input_fight = ccui.Helper:seekWidgetByName(root, "Panel_num_input_fight")
    local Text_add_condition_lv = ccui.Helper:seekWidgetByName(root, "Text_add_condition_lv")
    local Text_add_condition_fight = ccui.Helper:seekWidgetByName(root, "Text_add_condition_fight")
    self._panel_concition_level = Panel_num_input_lv
    self._panel_concition_fight = Panel_num_input_fight
    self._text_condition_level = Text_add_condition_lv
    self._text_condition_fight = Text_add_condition_fight

    local Text_add_verfication_t_2 = ccui.Helper:seekWidgetByName(root, "Text_add_verfication_t_2")
    local Image_add_verfication_state = ccui.Helper:seekWidgetByName(root, "Image_add_verfication_state")
    self._is_verfication = false
    Image_add_verfication_state:setPosition(Text_add_verfication_t_2:getPosition())

    -- 拥有资源状态
    local Text_gem_n = ccui.Helper:seekWidgetByName(root, "Text_gem_n")
    local Text_iron_ore_n = ccui.Helper:seekWidgetByName(root, "Text_iron_ore_n")
    local Text_petroeum_n = ccui.Helper:seekWidgetByName(root, "Text_petroeum_n")
    local Text_lead_ore_n = ccui.Helper:seekWidgetByName(root, "Text_lead_ore_n")
    local Text_gold_n = ccui.Helper:seekWidgetByName(root, "Text_gold_n")

    local establish_cost_info = zstring.split(dms.string(dms["union_config"], 21, union_config.param), "!")
    local need_resource_info = zstring.split(establish_cost_info[1], "|")
    local need_gold = tonumber(establish_cost_info[2])
    local need_vip_level = tonumber(establish_cost_info[3])
    local need_resource = {}
    for k, v in pairs(need_resource_info) do
        local info = zstring.split(v, ",")
        local cost = tonumber(info[3])
        table.insert(need_resource, cost)
    end
    self._need_vip_level = need_vip_level
    
    Text_gem_n:setString(exChangeNumToString(need_resource[1]))
    if tonumber(_ED.user_info.user_silver) < tonumber(need_resource[1]) then
        Text_gem_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        if self._need_resource == 0 then
            self._need_resource = 1
        end
    else
        Text_gem_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end

    Text_iron_ore_n:setString(exChangeNumToString(need_resource[2]))
    if tonumber(_ED.user_info.user_iron) < tonumber(need_resource[2]) then
        Text_iron_ore_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        if self._need_resource == 0 then
            self._need_resource = 2
        end
    else
        Text_iron_ore_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end

    Text_petroeum_n:setString(exChangeNumToString(need_resource[3]))
    if tonumber(_ED.user_info.oil_field) < tonumber(need_resource[1]) then
        Text_petroeum_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        if self._need_resource == 0 then
            self._need_resource = 3
        end
    else
        Text_petroeum_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end

    Text_lead_ore_n:setString(exChangeNumToString(need_resource[4]))
    if tonumber(_ED.user_info.exploits) < tonumber(need_resource[4]) then
        Text_lead_ore_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
        if self._need_resource == 0 then
            self._need_resource = 4
        end
    else
        Text_lead_ore_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end

    Text_gold_n:setString(exChangeNumToString(need_gold))
    if tonumber(_ED.user_info.user_gold) < tonumber(need_gold) then
        Text_gold_n:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
    else
        Text_gold_n:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
    end

    local CheckBox_choose_consume_1 = ccui.Helper:seekWidgetByName(root, "CheckBox_choose_consume_1")
    local CheckBox_choose_consume_2 = ccui.Helper:seekWidgetByName(root, "CheckBox_choose_consume_2")
    CheckBox_choose_consume_1:setSelected(true)
    CheckBox_choose_consume_2:setSelected(false)
    self._check_box_res = CheckBox_choose_consume_1
    self._check_box_gold = CheckBox_choose_consume_2

    local Text_vip_free_establish = ccui.Helper:seekWidgetByName(root, "Text_vip_free_establish")
    local Image_gold = ccui.Helper:seekWidgetByName(root, "Image_gold")
    Text_vip_free_establish:setString("")
    if tonumber(_ED.vip_grade) >= need_vip_level then
        Text_vip_free_establish:setString(string.format(tipString_legion_info[17], need_vip_level))
        Image_gold:setVisible(false)
        Text_gold_n:setString("")
    end

    if #self._text_field_watchword:getString() == 0 then
        self._text_field_watchword:setString(tipString_legion_info[14])
    end
    -- self._text_field_watchword:setPlaceHolderColor(cc.c4b(255, 255, 255, 255))
end

function LegionEstablish:onUpdate()
    if self.roots ~= nil and self.roots[1] ~= nil then
        self._text_name:setString(string.format(tipString_legion_info[54], string.utf8.len(self._text_field_name:getString()), self._max_name_length))
        self._text_watchwordt:setString(string.format(tipString_legion_info[10], string.utf8.len(self._text_field_watchword:getString()), self._max_watchwordt_length))
    end
end

--初始化界面
function LegionEstablish:onInit()
    local csbItem = csb.createNode(config_csb.legion.legion_establish)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root) 

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    local name_need_length = zstring.split(dms.string(dms["union_config"], 58, union_config.param), ",")
    local declaration_need_length = dms.int(dms["union_config"], 24, union_config.param)

    local TextField_legion_name = ccui.Helper:seekWidgetByName(root, "TextField_legion_name")
    TextField_legion_name = draw:addEditBoxEx(TextField_legion_name, tipString_legion_info[8], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Panel_add_verfication"), name_need_length[2], cc.KEYBOARD_RETURNTYPE_DONE)  
    local TextField_recruit_declaration = ccui.Helper:seekWidgetByName(root, "TextField_recruit_declaration")
    draw:addEditBoxEx(TextField_recruit_declaration, tipString_legion_info[9], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Panel_add_verfication"), declaration_need_length, cc.KEYBOARD_RETURNTYPE_DONE, nil, nil, TextField_recruit_declaration)  

    self._text_field_name = TextField_legion_name
    self._text_field_watchword = TextField_recruit_declaration

    local legion_name_info = zstring.split(dms.string(dms["union_config"], 25, union_config.param), ",")
    self._max_name_length = tonumber(legion_name_info[2])
    --TextField_legion_name:setPlaceHolder(string.format(tipString_legion_info[53], tonumber(legion_name_info[1]), tonumber(legion_name_info[2])))
    
    self._max_watchwordt_length = declaration_need_length
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish_close"), nil, 
    {
        terminal_name = "legion_establish_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)    

    -- 创建军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_establish"), nil, 
    {
        terminal_name = "legion_establish_establish_legion", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    -- 是否需要验证
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_add_verfication"), nil, 
    {
        terminal_name = "legion_establish_add_verfication", 
        terminal_state = 0, 
    }, nil, 1)

    -- 等级要求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_add_condition_lv"), nil, 
    {
        terminal_name = "legion_establish_add_condition_level", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    -- 战力要求
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_add_condition_fight"), nil, 
    {
        terminal_name = "legion_establish_add_condition_fight", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_bg"), nil, 
    {
        terminal_name = "legion_establish_close_input_digital", 
        terminal_state = 0, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_res_infor_bg_1"), nil, 
    {
        terminal_name = "legion_establish_close_input_digital", 
        terminal_state = 0, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_choose_consume_1"), nil, 
    {
        terminal_name = "legion_establish_select", 
        terminal_state = 0, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "CheckBox_choose_consume_2"), nil, 
    {
        terminal_name = "legion_establish_select", 
        terminal_state = 0, 
    }, nil, 1)

    self:onUpdateDraw()
end

--初始化
function LegionEstablish:init()
    self:setTouchEnabled(true)
    self:onInit()
end

--移除状态机
function LegionEstablish:onExit()
    state_machine.remove("legion_establish_establish_legion")
    state_machine.remove("legion_establish_add_verfication")
    state_machine.remove("legion_establish_add_condition_level")
    state_machine.remove("legion_establish_add_condition_fight")
    state_machine.remove("legion_establish_close_input_digital")
    state_machine.remove("legion_establish_update_add_condition")
    state_machine.remove("legion_establish_select")
end