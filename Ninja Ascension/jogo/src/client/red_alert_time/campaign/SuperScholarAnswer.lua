-- ------------------------------------------------------------------------------------------------------------
--  说明：学霸之战答题
-- ------------------------------------------------------------------------------------------------------------
SuperScholarAnswer = class("SuperScholarAnswerClass", Window)

--打开界面
local super_scholar_answer_open_terminal = {
    _name = "super_scholar_answer_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        local panel = SuperScholarAnswer:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(super_scholar_answer_open_terminal)
state_machine.init()

function SuperScholarAnswer:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- 当前学霸之战答题状态，0：未开启，1：准备开始答题，2：准备下一题，3：开始答题，4：已选择
    self._answer_state = 0

    self._text_time = nil
    self._choose_answer = 0
    self._right_answer = 0

    self._right_count = 0
    self._error_count = 0
    self._leave_count = 0

    local function init_super_scholar_answer_terminal()
        local super_scholar_answer_show_terminal = {
            _name = "super_scholar_answer_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_answer_hide_terminal = {
            _name = "super_scholar_answer_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_answer_update_draw_terminal = {
            _name = "super_scholar_answer_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_answer_choose_terminal = {
            _name = "super_scholar_answer_choose",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local choose = params._datas.choose
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node._choose_answer = choose
                            _ED.last_choose_answer = choose
                            response.node:changeState()
                            response.node:onUpdateDraw()
                        end
                    end
                end
                protocol_command.answer.param_list = ""..choose
                NetworkManager:register(protocol_command.answer.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_answer_update_player_terminal = {
            _name = "super_scholar_answer_update_player",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdatePlayerInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_answer_update_question_terminal = {
            _name = "super_scholar_answer_update_question",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.answer_question_info.state) == 2 then
                    if instance._answer_state == 3 or instance._answer_state == 4 then 
                        state_machine.excute("super_scholar_rank_update_rank_info", 0, "")
                    end
                    if instance._answer_state == 4 and instance._choose_answer == instance._right_answer then
                        checkRewardObtainDraw()
                        state_machine.excute("super_scholar_reward_update_rank_info", 0, "")
                    end
                end
                -- 本轮答题结束
                if tonumber(_ED.answer_question_info.state) == 0 and instance._answer_state > 0 then
                    state_machine.excute("super_scholar_reward_update_rank_info", 0, "")
                    _ED.last_choose_answer = nil
                end

                instance:changeState()
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local super_scholar_answer_open_share_terminal = {
            _name = "super_scholar_answer_open_share",
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

        local super_scholar_answer_close_share_terminal = {
            _name = "super_scholar_answer_close_share",
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

        local super_scholar_answer_share_chat_terminal = {
            _name = "super_scholar_answer_share_chat",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if funOpenDrawTip(237) == true then
                    return
                end 
                if tonumber(params._datas.chat_type) == 14 then
                    if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                        state_machine.excute("super_scholar_answer_close_share", 0, 0)          
                        TipDlg.drawTextDailog(game_share_tip_text[2])
                        return
                    end
                end
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("super_scholar_answer_close_share", 0, 0)                      
                        TipDlg.drawTextDailog(game_share_tip_text[1])
                    end
                end

                local title = dms.string(dms["message_share"], 59, message_share.title)
                if tonumber(title) ~= nil and tonumber(title) < 0 then
                    title = ""
                else
                    title = title.."\r\n"
                end

                local datas = dms.string(dms["message_share"], 59, message_share.content)
                local data1 =  string.gsub(datas, "!x@", instance._right_count)
                local data2 =  string.gsub(data1, "!y@", instance._error_count)
                local data3 =  string.gsub(data2, "!z@", instance._leave_count)
                datas = data3
                local paramsInfo = "0-0,"..instance._right_count..","..instance._error_count..","..instance._leave_count
                local str = ""--title..datas
                if dms.int(dms["message_share"], 59, message_share.jump_type) ~= -1 then
                    str = str..chat_section[1]..dms.int(dms["message_share"], 59, message_share.jump_type)
                end
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n"..params._datas.chat_type.. "\r\n0\r\n59\r\n"..paramsInfo
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, instance, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(super_scholar_answer_show_terminal)
        state_machine.add(super_scholar_answer_hide_terminal)
        state_machine.add(super_scholar_answer_update_draw_terminal)
        state_machine.add(super_scholar_answer_choose_terminal)
        state_machine.add(super_scholar_answer_update_player_terminal)
        state_machine.add(super_scholar_answer_update_question_terminal)
        state_machine.add(super_scholar_answer_open_share_terminal)
        state_machine.add(super_scholar_answer_close_share_terminal)
        state_machine.add(super_scholar_answer_share_chat_terminal)
        state_machine.init()
    end
    init_super_scholar_answer_terminal()
end

function SuperScholarAnswer:changeState()
    if _ED.answer_question_info == nil or tonumber(_ED.answer_question_info.state) == 0 then
        self._answer_state = 0
        self._choose_answer = 0
    elseif tonumber(_ED.answer_question_info.state) == 1 then
        if self._choose_answer == 0 then
            _ED.last_choose_answer = 0
            _ED.answer_choose_info = nil
            self._answer_state = 3
        else
            self._answer_state = 4
        end
    elseif tonumber(_ED.answer_question_info.state) == 2 then
        self._answer_state = 2
        self._choose_answer = 0
    end
end

function SuperScholarAnswer:onUpdatePlayerInfo()
    local root = self.roots[1]
    if self._answer_state ~= 2 and self._answer_state ~= 4 then
        return
    end
    
    -- 选择了答案的玩家
    for i = 1, 3 do
        local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name_"..i)
        local player_str = ""
        local count = 0
        if _ED.answer_choose_info ~= nil and _ED.answer_choose_info[i] ~= nil then
            for k, v in pairs(_ED.answer_choose_info[i]) do
                if count >= 10 then
                    break
                end
                count = count + 1
                player_str = player_str..count.."."..v.."\r\n"
            end
        end
        Text_player_name:setString(player_str)
    end
end

function SuperScholarAnswer:onUpdateDraw()
    local root = self.roots[1]
    for i = 1, 3 do
        local Button_answer_choose = ccui.Helper:seekWidgetByName(root, "Button_answer_choose_"..i)
        local Text_not_start = ccui.Helper:seekWidgetByName(root, "Text_not_start_"..i)
        local Image_correct = ccui.Helper:seekWidgetByName(root, "Image_correct_"..i)
        local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name_"..i)
        if self._answer_state == 3 then
            Button_answer_choose:setBright(true)
            Button_answer_choose:setTouchEnabled(true)
        else
            Button_answer_choose:setBright(false)
            Button_answer_choose:setTouchEnabled(false)
        end
        Button_answer_choose:setTitleText(red_alert_time_str[125])

        if self._answer_state == 0 then
            Text_not_start:setVisible(true)
        else
            Text_not_start:setVisible(false)
        end

        Image_correct:setVisible(false)
        Text_player_name:setString("")
    end

    local Text_super_scholar_answer_p_1 = ccui.Helper:seekWidgetByName(root, "Text_super_scholar_answer_p_1")
    local Text_super_scholar_answer_p_2 = ccui.Helper:seekWidgetByName(root, "Text_super_scholar_answer_p_2")
    local Text_super_scholar_answer_p_3 = ccui.Helper:seekWidgetByName(root, "Text_super_scholar_answer_p_3")
    local Text_answer_begin_time_t = ccui.Helper:seekWidgetByName(root, "Text_answer_begin_time_t")
    local Text_answer_begin_time_n = ccui.Helper:seekWidgetByName(root, "Text_answer_begin_time_n")
    local Text_answer_begin_get_n = ccui.Helper:seekWidgetByName(root, "Text_answer_begin_get_n")
    Text_super_scholar_answer_p_1:setString("")
    Text_super_scholar_answer_p_2:setString("")
    Text_super_scholar_answer_p_3:setString("")
    Text_answer_begin_time_t:setString("")
    Text_answer_begin_time_n:setString("")
    Text_answer_begin_get_n:setString("")
    Text_super_scholar_answer_p_3:removeAllChildren(true)

    -- 答案
    local Text_answer_1 = ccui.Helper:seekWidgetByName(root, "Text_answer_1")
    local Text_answer_2 = ccui.Helper:seekWidgetByName(root, "Text_answer_2")
    local Text_answer_3 = ccui.Helper:seekWidgetByName(root, "Text_answer_3")

    self._text_time = Text_answer_begin_time_n

    local answer_info = _ED.answer_user_info
    if answer_info == nil then
        Text_answer_begin_get_n:setString("0")
    else
        Text_answer_begin_get_n:setString(answer_info.score)
    end

    if self._answer_state == 0 or self._answer_state == 1 then
        Text_super_scholar_answer_p_1:setString(red_alert_time_str[115])
        Text_answer_begin_time_t:setString(red_alert_time_str[117])
        local GMT = ""
        if isContentZh_TW() == true then
            GMT = "(GMT+8)"
        end
        Text_answer_begin_time_n:setString(dms.string(dms["answer_config"], 1, answer_config.param)..GMT)
        -- 上期第一名
        local top_name = ""
        if _ED.answer_rank_list_info ~= nil and _ED.answer_rank_list_info[1] ~= nil then
            top_name = _ED.answer_rank_list_info[1].name
        end
        Text_super_scholar_answer_p_2:setString(string.format(red_alert_time_str[116], top_name))

        Text_answer_1:setString("A")
        Text_answer_2:setString("B")
        Text_answer_3:setString("C")

        
        local right_count = 0       -- 正确个数
        local error_count = 0       -- 错误个数
        local leave_count = dms.int(dms["answer_config"], 2, answer_config.param)       -- 漏答个数

        if answer_info ~= nil then
            right_count = tonumber(answer_info.right_count)
            error_count = tonumber(answer_info.error_count)
            leave_count = leave_count - right_count - error_count
        end

        self._right_count = right_count
        self._error_count = error_count
        self._leave_count = leave_count

        local _richText = ccui.RichText:create()
        _richText:ignoreContentAdaptWithSize(false)       
        local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[119], "fonts/simhei.ttf",18)
        _richText:pushBackElement(re1)  
        local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, right_count, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re2)
        local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[120], "fonts/simhei.ttf",18)
        _richText:pushBackElement(re3)  
        local re4 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, error_count, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re4)
        local re5 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[121], "fonts/simhei.ttf",18)
        _richText:pushBackElement(re5)  
        local re6 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, leave_count, "fonts/simhei.ttf",18)
        _richText:pushBackElement(re6)
        local re7 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[122], "fonts/simhei.ttf",18)
        _richText:pushBackElement(re7) 
        _richText:setPosition(cc.p(Text_super_scholar_answer_p_3:getContentSize().width/2 + 100,Text_super_scholar_answer_p_3:getContentSize().height/2))
        _richText:setContentSize(cc.size(Text_super_scholar_answer_p_3:getContentSize().width,18))
        Text_super_scholar_answer_p_3:addChild(_richText)

    else
        if self._answer_state == 3 or self._answer_state == 4 then
            Text_answer_begin_time_t:setString(red_alert_time_str[118])
        elseif self._answer_state == 2 then
            Text_answer_begin_time_t:setString(red_alert_time_str[127])
        end

        local question_mould = dms.element(dms["answer_library"], _ED.answer_question_info.question_id)
        _ED.answer_question_info.question_type_name = dms.atos(question_mould, answer_library.answer_type_name)
        _ED.answer_question_info.question = dms.atos(question_mould, answer_library.question)
        _ED.answer_question_info.answer_a = dms.atos(question_mould, answer_library.answer_a)
        _ED.answer_question_info.answer_b = dms.atos(question_mould, answer_library.answer_b)
        _ED.answer_question_info.answer_c = dms.atos(question_mould, answer_library.answer_c)

        local right_answer = tonumber(_ED.answer_question_info.right_answer)
        self._right_answer = right_answer

        Text_super_scholar_answer_p_1:setString(string.format(red_alert_time_str[123], _ED.answer_question_info.current_count, _ED.answer_question_info.question_type_name))
        Text_super_scholar_answer_p_2:setString(_ED.answer_question_info.question)

        -- 显示答案
        Text_answer_1:setString("A.".._ED.answer_question_info.answer_a)
        Text_answer_2:setString("B.".._ED.answer_question_info.answer_b)
        Text_answer_3:setString("C.".._ED.answer_question_info.answer_c)

        -- 显示玩家
        self:onUpdatePlayerInfo()

        if self._answer_state == 2 then
            local Image_correct = ccui.Helper:seekWidgetByName(root, "Image_correct_"..right_answer)
            if Image_correct ~= nil then
                Image_correct:setVisible(true)
            end
        end

        if self._answer_state == 2 or self._answer_state == 4 then
            local choose_answer = _ED.last_choose_answer
            local Button_answer_choose = ccui.Helper:seekWidgetByName(root, "Button_answer_choose_"..choose_answer)
            if Button_answer_choose ~= nil then 
                Button_answer_choose:setTitleText(red_alert_time_str[126])
            end
        end

        local leave_time = _ED.answer_question_info.cd_time + _ED.answer_question_info.start_time - (os.time()  + _ED.time_add_or_sub)
        if leave_time < 0 then
            leave_time = 0
        end
        self._text_time:setString(leave_time.."s")
    end
end

function SuperScholarAnswer:onUpdate()
    if self._text_time ~= nil then
        local now_time = os.time()
        if now_time - zstring.tonumber(self.last_time) >= 1 or now_time < zstring.tonumber(self.last_time) then 
            self.last_time = now_time
            local open_time = dms.string(dms["answer_config"], 1, rebel_haunt_config.param)
            open_time = zstring.split(open_time, ":")
            if self._answer_state == 0 then
                local server_time = getCurrentGTM8Time()
                local leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec
                -- 提前10分钟开始倒计时
                if leave_time <= 600  and leave_time > 0 then
                    self._answer_state = 1
                end
            elseif self._answer_state == 1 then
                local server_time = getCurrentGTM8Time()
                local leave_time = (tonumber(open_time[1]) - server_time.hour) * 3600 + (tonumber(open_time[2]) - server_time.min) * 60 + tonumber(open_time[3]) - server_time.sec
                if leave_time < 0 then
                    leave_time = 0
                    NetworkManager:register(protocol_command.answer_init.code, nil, nil, nil, nil, nil, false, nil)
                end
                self._text_time:setString(exChangeTimeToString(leave_time))
            elseif self._answer_state == 2 or self._answer_state == 3 or self._answer_state == 4 then
                local leave_time = _ED.answer_question_info.cd_time + _ED.answer_question_info.start_time - (now_time  + _ED.time_add_or_sub)
                if leave_time < 0 then
                    leave_time = 0
                    NetworkManager:register(protocol_command.answer_init.code, nil, nil, nil, nil, nil, false, nil)
                end
                self._text_time:setString(leave_time.."s")
            end
        end
    end
end

function SuperScholarAnswer:onInit()
    local csbItem = csb.createNode(string.format(config_csb.campaign.super_scholar_tab, 1))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self._choose_answer = zstring.tonumber(_ED.answer_user_info.choose_answer)
    _ED.last_choose_answer = _ED.last_choose_answer or self._choose_answer

    for i = 1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_answer_choose_"..i), nil, 
        {
            terminal_name = "super_scholar_answer_choose", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            choose = i,
        }, nil, 1)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_super_scholar_share"), nil, 
    {
        terminal_name = "super_scholar_answer_open_share", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    --关闭分享
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "super_scholar_answer_close_share", 
        terminal_state = 0, 
    }, nil, 1)    
    
    --分享到聊天
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_legion_chat"), nil, 
    {
        terminal_name = "super_scholar_answer_share_chat", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 14,
    }, nil, 1)    
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_share_world_chat"), nil, 
    {
        terminal_name = "super_scholar_answer_share_chat", 
        terminal_state = 0, 
        touch_black = true,
        chat_type = 13,
    }, nil, 1)

    self:changeState()
    self:onUpdateDraw()
end

function SuperScholarAnswer:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function SuperScholarAnswer:onExit()
    state_machine.remove("super_scholar_answer_show")
    state_machine.remove("super_scholar_answer_hide")
    state_machine.remove("super_scholar_answer_update_draw")
    state_machine.remove("super_scholar_answer_choose")
    state_machine.remove("super_scholar_answer_update_player")
    state_machine.remove("super_scholar_answer_update_question")
    state_machine.remove("super_scholar_answer_open_share")
    state_machine.remove("super_scholar_answer_close_share")
    state_machine.remove("super_scholar_answer_share_chat")
end