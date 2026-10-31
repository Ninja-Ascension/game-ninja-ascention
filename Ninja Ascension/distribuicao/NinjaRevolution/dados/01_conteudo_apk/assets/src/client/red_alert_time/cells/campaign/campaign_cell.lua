-----------------------------
--日常 历练 控件
-----------------------------
CampaignCell = class("CampaignCellClass", Window)
CampaignCell.__size = nil

local campaign_create_cell_terminal = {
    _name = "campaign_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = CampaignCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(campaign_create_cell_terminal)
state_machine.init()

function CampaignCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._info = nil
    self._nType = 0
    self._Text_campaign_lv_prompt = nil
    self._open_day = 0
    self._level = 0

    self._end_time = 0
    self._state = nil

    app.load("client.red_alert_time.legion.LegionHegemonyHelp")

    local function init_campaign_cell_terminal()
        local campaign_cell_enter_terminal = {
            _name = "campaign_cell_enter",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                
                local index = tonumber(cell._index)
                local nType = tonumber(cell._nType)
                if nType == 2 and index == 5 then
                else
                    if funOpenDrawTip(cell._info.fun_open_condition) == true then
                        return
                    end 
                end    
                if nType == 1 then
                    if index == 1 then
                        state_machine.excute("arena_window_open",0,"")
                    elseif index == 2 then
                        state_machine.excute("expedition_manager_window_open",0,"")
                    elseif index == 3 then
                        state_machine.excute("super_scholar_window_open",0,"")
                    elseif index == 4 then
                        local base_info = zstring.split(zstring.split(dms.string(dms["enemy_boss_config"], 14, enemy_boss_config.param), "|")[1], ",")
                        local _x, _y = zstring.tonumber(base_info[1]), zstring.tonumber(base_info[2])
                        state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                        state_machine.excute("adventure_mine_record_view_position", 0, {_x, _y})
                        state_machine.excute("adventure_mine_update_view_position", 0, 0)
                        state_machine.excute("world_input_window_close", 0, 0)
                        protocol_command.world_map_arena_info_refresh.param_list = "" .. _x.."\r\n".._y
                        NetworkManager:register(protocol_command.world_map_arena_info_refresh.code, nil, nil, nil, nil, nil, false, nil)
                        _ED.world_map_focus = {_x, _y}
                        state_machine.excute("adventure_mine_enemy_boss_change_state", 0, nil)
                        state_machine.excute("enemy_strike_world_box_open",0,"")
                        state_machine.excute("campaign_window_close", 0, nil)
                    elseif index == 5 then
                        state_machine.excute("rebel_haunt_open", 0, {})
                    elseif index == 6 then
                        state_machine.excute("limit_dekaron_window_open", 0, "")
                    end
                elseif nType == 2 then
                    if index == 1 then
                        if _ED.union.union_info == nil 
                            or _ED.union.union_info == {} 
                            or _ED.union.union_info.union_id == nil 
                            or _ED.union.union_info.union_id == "" 
                            or tonumber(_ED.union.union_info.union_id) == 0 then
                            TipDlg.drawTextDailog(red_alert_time_str[158])
                            return
                        end
                        state_machine.excute("legion_hegemony_window_open", 0, nil)
                    elseif index == 2 then
                        state_machine.excute("camp_pk_open", 0, "")
                    elseif index == 3 then
                        state_machine.excute("guard_battle_window_open", 0, "")
                    elseif index == 5 then
                        if _ED.union.union_info == nil 
                            or _ED.union.union_info == {} 
                            or _ED.union.union_info.union_id == nil 
                            or _ED.union.union_info.union_id == "" 
                            or tonumber(_ED.union.union_info.union_id) == 0 then
                            TipDlg.drawTextDailog(red_alert_time_str[158])
                            return
                        end
                        state_machine.excute("legion_city_open", 0, nil)
                    end
                else
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local campaign_cell_show_info_terminal = {
            _name = "campaign_cell_show_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cell = params._datas.cell
                local index = tonumber(cell._index)
                local nType = tonumber(cell._nType)
                if nType == 1 then
                    state_machine.excute("expedition_rule_infor_window_open",0,index)
                elseif nType == 2 then
                    if index == 1 then
                        state_machine.excute("legion_hegemony_help_window_open",0, {_datas = {infor_type = 1}})
                    elseif index == 2 then
                        state_machine.excute("expedition_rule_infor_window_open",0,12)
                    elseif index == 3 then
                        state_machine.excute("expedition_rule_infor_window_open",0,13)
                    elseif index == 5 then
                        state_machine.excute("legion_city_rule_infor_window_open", 0, {_datas = {infor_type = 1}})
                    end
                else
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(campaign_cell_enter_terminal)
        state_machine.add(campaign_cell_show_info_terminal)
        state_machine.init()
    end
    
    init_campaign_cell_terminal()
end

--刷新列表数据
function CampaignCell:onUpdateDraw()
    local root = self.roots[1]
    local Text_campaign_name = ccui.Helper:seekWidgetByName(root,"Text_campaign_name")
    local Panel_campaign_icon = ccui.Helper:seekWidgetByName(root,"Panel_campaign_icon")
    self._Text_campaign_lv_prompt = ccui.Helper:seekWidgetByName(root,"Text_campaign_lv_prompt")
    self._Text_campaign_lv_prompt:setString("")
    self._Text_campaign_lv_prompt:removeAllChildren(true)
    self._Text_campaign_time = ccui.Helper:seekWidgetByName(root,"Text_campaign_time")
    self._Text_campaign_time:setString("")
    self._Text_campaign_time:removeAllChildren(true)

    Text_campaign_name:setString(self._info.list_type_name)
    local fontName = config_res.font.font_name
    if isContentZh_TW() == true then
        fontName = ""
    end
    local describe_1 = ""
    local describe_2 = ""
    local quality_1 = 1
    local quality_2 = 1
    local fun_open_state = false
    local element = dms.element(dms["fun_open_condition"], self._info.fun_open_condition)
    self._open_day = dms.atoi(element, fun_open_condition.open_day)
    self._level = dms.atoi(element, fun_open_condition.level)
    local tip_info = dms.atos(element, fun_open_condition.tip_info)
    local day = (tonumber(_ED.system_time) - tonumber(_ED.open_server_time)/1000 + (os.time()-tonumber(_ED.native_time)))/86400
    if tonumber(self._nType) == 2 and tonumber(self._index) == 5 then
        self._level = -1
    end
    if day < self._open_day then
        describe_1 = tip_info
        quality_1 = 6
    elseif tonumber(_ED.user_info.user_grade) < self._level then
        if self._open_day > 1 then
            if tonumber(self._nType) == 2 and tonumber(self._index) == 3 then
            else
                tip_info = string.format(tipStringInfo_campaign_info[56],self._level)
            end
        end
        describe_1 = tip_info
        quality_1 = 6
    else
        fun_open_state = true
        if tonumber(self._nType) == 1 then
            describe_1 = limit_dekaron_tip_daily[self._index]
            if tonumber(self._index) == 1 then
                quality_2 = 7
                if _ED.mould_function_push_info["1"] ~= nil then
                    local params = zstring.split(_ED.mould_function_push_info["1"].params, ",") 
                    if params[1] == nil 
                        or params[1] == "" then
                        describe_2 = arena_tip_text[33]
                        fontName = config_res.font.font_name
                    else
                        describe_2 = params[1]
                    end
                end
            elseif tonumber(self._index) == 2 then 
                
            elseif tonumber(self._index) == 3 then
                describe_1 = ""
                local push_info = _ED.mould_function_push_info["3"]
                if push_info ~= nil then
                    self._state = push_info.state
                    self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
                end
            elseif tonumber(self._index) == 4 then
                describe_1 = ""
                local push_info = _ED.mould_function_push_info["4"]
                if push_info ~= nil then
                    self._state = push_info.state
                    self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
                end
            elseif tonumber(self._index) == 5 then
                describe_1 = ""
                local push_info = _ED.mould_function_push_info["5"]
                if push_info ~= nil then
                    self._state = push_info.state
                    self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
                end
            elseif tonumber(self._index) == 6 then
                describe_1 = ""
            end
        elseif tonumber(self._nType) == 2 then
            -- describe_1 = limit_dekaron_tip_spacing[self._index]
            if tonumber(self._index) == 1 then
                -- local state = 0
                -- if _ED.mould_function_push_info["9"] ~= nil then
                --     state = _ED.mould_function_push_info["9"].state
                -- end
                -- if zstring.tonumber(state) == 0 then
                -- elseif zstring.tonumber(state) == 1 then
                --     describe_1 = tipStringInfo_campaign_info[25]
                -- elseif zstring.tonumber(state) == 2 then
                --     describe_1 = tipStringInfo_campaign_info[26]
                -- elseif zstring.tonumber(state) == 3 then
                --     describe_1 = tipStringInfo_campaign_info[23]
                -- elseif zstring.tonumber(state) == 4 then
                --     describe_1 = tipStringInfo_campaign_info[24]
                -- end
                describe_1 = ""

                local push_info = _ED.mould_function_push_info["9"]
                if push_info ~= nil then
                    self._state = push_info.state
                    self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
                end
            elseif tonumber(self._index) == 2 then
                describe_1 = ""

                local push_info = _ED.mould_function_push_info["10"]
                if push_info ~= nil then
                    self._state = push_info.state
                    local time_info = zstring.split(push_info.params, ",")
                    self._end_time = tonumber(time_info[3]) / 1000 + push_info.start_time
                end
            elseif tonumber(self._index) == 3 then
                describe_1 = ""

                local push_info = _ED.mould_function_push_info["13"]
                if push_info ~= nil then
                    self._state = push_info.state
                    self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
                end
            elseif tonumber(self._index) == 5 then      -- 城市战
                describe_1 = ""
                local push_info = _ED.mould_function_push_info["14"]
                if push_info ~= nil then
                    self._state = push_info.state
                    self._end_time = tonumber(push_info.params) / 1000 + push_info.start_time
                end
            end
        else
            describe_1 = limit_dekaron_tip_cross[self._index]
        end
    end
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_1][1],color_Type[quality_1][2],color_Type[quality_1][3]),255, describe_1, config_res.font.font_name,20)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[quality_2][1],color_Type[quality_2][2],color_Type[quality_2][3]),255, describe_2, fontName,20)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(self._Text_campaign_lv_prompt:getContentSize().width/2,self._Text_campaign_lv_prompt:getContentSize().height/2))
    _richText:setContentSize(cc.size(self._Text_campaign_lv_prompt:getContentSize().width,20))
    self._Text_campaign_lv_prompt:addChild(_richText)

    if tonumber(self._nType) == 1 and tonumber(self._index) == 1 then
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_no1)
        --local posX = self._Text_campaign_lv_prompt:getContentSize().width/2
        local posY = self._Text_campaign_lv_prompt:getContentSize().height/2
        local len = 0
        local len = 0
        local map = string.utf8.chars(describe_2)
        for k, v in pairs(map) do
            if string.len(v) == 1 then
                len = len + 1
            else
                len = len + 2
            end
        end
        len = math.ceil(len / 2)

        local width1 = self:widthSingle(describe_1)+8

        for i = 1, len do
            local armature = ccs.Armature:create("effect_no1")
            armature:getAnimation():playWithIndex(0)
            armature:setPosition(cc.p(width1+20*(i-1),posY))
            self._Text_campaign_lv_prompt:addChild(armature)
        end

    end

    Panel_campaign_icon:removeBackGroundImage()
    Panel_campaign_icon:removeAllChildren(true)
    -- local cell = state_machine.excute("props_icon_create_cell",0,{1,3,self._info.id,13})
    -- Panel_campaign_icon:addChild(cell) 
    Panel_campaign_icon:setBackGroundImage(string.format(config_res.images.ui.combat.campaign_function_list, self._nType, self._index))

    -- if tonumber(self._nType) == 1 
    --     and fun_open_state == true
    --     and (tonumber(self._index) == 1 or tonumber(self._index) == 2 or tonumber(self._index) == 6)
    --     then
        local time_info_2 = cc.Label:createWithTTF("", config_res.font.font_name, 18 / CC_CONTENT_SCALE_FACTOR())
        time_info_2:setName("time_info_2")
        time_info_2:setAnchorPoint(cc.p(1, 0.5))
        time_info_2:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
        time_info_2:setPositionX(self._Text_campaign_time:getContentSize().width - 110)
        time_info_2:setPositionY(self._Text_campaign_time:getContentSize().height / 2)
        time_info_2:setTag(200)
        self._Text_campaign_time:addChild(time_info_2)
        local time_int_2 = cc.Label:createWithTTF("", config_res.font.font_name, 18 / CC_CONTENT_SCALE_FACTOR())
        time_int_2:setName("time_int_2")
        time_int_2:setAnchorPoint(cc.p(0, 0.5))
        time_int_2:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        time_int_2:setPositionX(self._Text_campaign_time:getContentSize().width - 110)
        time_int_2:setPositionY(self._Text_campaign_time:getContentSize().height / 2)
        time_int_2:setTag(100)
        self._Text_campaign_time:addChild(time_int_2)
    -- end

    -- 活动开启高亮
    local Panel_campaign_effect = ccui.Helper:seekWidgetByName(root,"Panel_campaign_effect")
    if Panel_campaign_effect ~= nil then
        Panel_campaign_effect:removeAllChildren(true)
        if self._state ~= nil and tonumber(self._state) > 0 and tonumber(self._state) < 4 then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_combat)
            local armature = ccs.Armature:create("effect_combat")
            Panel_campaign_effect:addChild(armature)
            armature:setPosition(Panel_campaign_effect:getContentSize().width / 2, Panel_campaign_effect:getContentSize().height / 2)
            armature:getAnimation():playWithIndex(0)
        end
    end
end

function CampaignCell:widthSingle(inputstr)
    -- 计算字符串宽度
    -- 可以计算出字符宽度，用于显示使用
   local lenInByte = #inputstr
   local width = 0
   local i = 1
    while (i<=lenInByte) 
    do
        local curByte = string.byte(inputstr, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1                                               --1字节字符
            if curByte >= 48 and curByte<=57 
                or curByte >= 97 and curByte<=122  then
                width = width + 12
            elseif curByte >= 65 and curByte<=90 then
                if curByte==87 then
                    width = width + 21.3
                elseif curByte == 81 then
                    width = width + 17.5    
                elseif curByte == 77 then
                    width = width + 18.2  
                elseif curByte == 82 then
                    width = width + 16.5    
                else
                    width = width + 15
                end
            elseif curByte == 64 or curByte == 37 then
                width = width + 22
            else
                width = width + 12    
            end
        elseif curByte>=192 and curByte<=223 then
            byteCount = 2                                               --双字节字符
            width = width + 22
        elseif curByte>=224 and curByte<=239 then
            byteCount = 3                                               --汉字
            width = width + 22
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4                                               --4字节字符
            width = width + 22
        end
         
        local char = string.sub(inputstr, i, i+byteCount-1)
        -- print(char)                                                          --看看这个字是什么
        i = i + byteCount                                              -- 重置下一字节的索引
        -- width = width + 1                                             -- 字符的个数（长度）
    end
    return width
end

function CampaignCell:onUpdate( dt )
    local server_time = _ED.system_time + (os.time() - _ED.native_time)
    local day = (_ED.system_time - tonumber(_ED.open_server_time)/1000)/86400
    if day < self._open_day or tonumber(_ED.user_info.user_grade) < self._level then
        return
    end
    local server_week = os.date("%w", zstring.tonumber(server_time) - _ED.GTM_Time)
    server_time = getCurrentGTM8Time()
    local update_time = 86400 - (server_time.hour * 3600 + server_time.min * 60 + server_time.sec)
    local state = 0
    if tonumber(self._nType) == 1 then
        if tonumber(self._index) == 1 then
            if self._Text_campaign_time:getChildByTag(100) ~= nil then
                self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(update_time))
            end
            if self._Text_campaign_time:getChildByTag(200) ~= nil then
                self._Text_campaign_time:getChildByTag(200):setString(activity_str_tip[94])
            end
        elseif tonumber(self._index) == 2 then
            if self._Text_campaign_time:getChildByTag(100) ~= nil then
                self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(update_time))
            end
            if self._Text_campaign_time:getChildByTag(200) ~= nil then
                self._Text_campaign_time:getChildByTag(200):setString(activity_str_tip[94])
            end
        elseif tonumber(self._index) == 3 then      -- 学霸之战
            if _ED.mould_function_push_info["3"] ~= nil then
                state = _ED.mould_function_push_info["3"].state
            end
            if tonumber(state) == 0 then
                local open_time = dms.string(dms["answer_config"], 1, answer_config.param)
                open_time = zstring.split(open_time, ":")
                local time = 0
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[3])
                if server_time.hour < tonumber(open_time[1]) or 
                    (server_time.hour == tonumber(open_time[1]) and server_time.min < tonumber(open_time[2])) then
                    time = (open_time[1] - server_time.hour) * 3600 + (open_time[2] - server_time.min) * 60 - server_time.sec
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[5]..time)
                else
                    time = (open_time[1] - server_time.hour + 24) * 3600 + (open_time[2] - server_time.min) * 60 - server_time.sec
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[5]..time)
                end
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(time)
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_daily[5])
                end
            else
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[11])
            end
        elseif tonumber(self._index) == 4 then  -- 敌军来袭
            -- if _ED.mould_function_push_info["4"] ~= nil then
            --     state = _ED.mould_function_push_info["4"].state
            -- end
            -- local open_time = dms.string(dms["enemy_boss_config"], 1, enemy_boss_config.param)
            -- open_time = zstring.split(open_time, ":")
            local state = self._state
            local time = self._end_time - (os.time() + _ED.time_add_or_sub)
            if tonumber(state) == 0 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[12])
                -- if server_time.hour < tonumber(open_time[1]) or 
                --     (server_time.hour == tonumber(open_time[1]) and server_time.min < tonumber(open_time[2])) then
                --     -- time = (open_time[1] - server_time.hour) * 3600 + (open_time[2] - server_time.min) * 60 - server_time.sec
                --     time = getRedAlertTimeActivityFormat(time)
                --     -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[5]..time)
                -- else
                --     -- time = (open_time[1] - server_time.hour + 24) * 3600 + (open_time[2] - server_time.min) * 60 - server_time.sec
                --     time = getRedAlertTimeActivityFormat(time)
                --     -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[5]..time)
                -- end
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_daily[5])
                end
            else
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[10])
            end
            if time <= -1 then
                self:onUpdateDraw()
            end
        elseif tonumber(self._index) == 5 then      -- 叛军出没
            local open_time = dms.string(dms["rebel_haunt_config"], 1, rebel_haunt_config.param)
            local continue_time = dms.int(dms["rebel_haunt_config"], 2, rebel_haunt_config.param)
            open_time = zstring.split(open_time, ",")
            local open_time_one = zstring.split(open_time[1], ":")
            local open_time_two = zstring.split(open_time[2], ":")
            if _ED.mould_function_push_info["5"] ~= nil then
                state = _ED.mould_function_push_info["5"].state
            end
            local time = 0
            if tonumber(state) == 0 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[13])
                if server_time.hour < tonumber(open_time_one[1]) then
                    time = (open_time_one[1] - server_time.hour) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[self._index]..time)
                elseif server_time.hour < tonumber(open_time_two[1]) then
                    time = (open_time_two[1] - server_time.hour) * 3600 + (open_time_two[2] - server_time.min) * 60 - server_time.sec
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[self._index]..time)
                else
                    time = (24 - server_time.hour + open_time_one[1]) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[self._index]..time)
                end
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(time)
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_daily[5])
                end
            else
                if server_time.hour < tonumber(open_time_one[1]) + continue_time/3600 then
                    time = (continue_time/3600) - (open_time_one[1] - server_time.hour) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[self._index]..time)
                elseif server_time.hour < tonumber(open_time_two[1]) + continue_time/3600 then
                    time = (continue_time/3600) - (open_time_two[1] - server_time.hour) * 3600 + (open_time_two[2] - server_time.min) * 60 - server_time.sec + continue_time
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[self._index]..time)
                else
                    time = (24 - server_time.hour + open_time_one[1] + (continue_time/3600)) * 3600 + (open_time_one[2] - server_time.min) * 60 - server_time.sec + continue_time
                    time = getRedAlertTimeActivityFormat(time)
                    -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[self._index]..time)
                end
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(time)
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[9])
                end
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[8])
            end
        elseif tonumber(self._index) == 6 then   
            if self._Text_campaign_lv_prompt ~= nil then
                local attack_times = dms.int(dms["limit_challenge_config"],2,limit_challenge_config.param)
                local reset_times = attack_times
                local current_npc_count = 0
                if _ED.mould_function_push_info["6"] ~= nil 
                    and _ED.user_extreme_info.reset_times == nil
                    then
                    local params = zstring.split(_ED.mould_function_push_info["6"].params, ",") 
                    reset_times = attack_times - tonumber(params[1])
                    current_npc_count = tonumber(params[2])
                else
                    if _ED.user_extreme_info.reset_times ~= nil then
                        reset_times = attack_times - zstring.tonumber(_ED.user_extreme_info.reset_times)
                        current_npc_count = zstring.tonumber(_ED.user_extreme_info.current_npc_count)
                    end
                end
                if funOpenDrawTip(self._info.fun_open_condition,false) == false then
                    self._Text_campaign_lv_prompt:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))
                    if current_npc_count == 0 then
                        self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[self._index]..reset_times)
                    else
                        self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[9])
                    end
                end
            end
            if self._Text_campaign_time:getChildByTag(100) ~= nil then
                self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(update_time))
            end
            if self._Text_campaign_time:getChildByTag(200) ~= nil then
                self._Text_campaign_time:getChildByTag(200):setString(activity_str_tip[94])
            end
        end
    elseif tonumber(self._nType) == 2 then
        if tonumber(self._index) == 1 then      -- 军团争霸
            local state = self._state
            local end_time = self._end_time - (os.time() + _ED.time_add_or_sub)
            -- local time_info = zstring.split(dms.string(dms["union_fight_config"], 5, union_fight_config.param), "|")[2]
            -- time_info = zstring.split(time_info, ",")
            if zstring.tonumber(state) == 3 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[8])
            elseif zstring.tonumber(state) == 2 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[11])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[7])
                end
            elseif zstring.tonumber(state) == 1 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[10])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[6])
                end
            else
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[1])
                local tick_time = end_time
                -- local time = 0
                -- if tonumber(server_week) <= 1 then
                --     time = (1-tonumber(server_week)) * 86400 + tick_time
                -- elseif tonumber(server_week) > 1 and tonumber(server_week) <= 3 then
                --     time = (3-tonumber(server_week)) * 86400 + tick_time
                --     if time < 0 then
                --         time = (5-tonumber(server_week)) * 86400 + time
                --     end
                -- elseif tonumber(server_week) > 3 and tonumber(server_week) <= 5 then
                --     time = (5-tonumber(server_week)) * 86400 + tick_time
                --     if time < 0 then
                --         time = (8-tonumber(server_week)) * 86400 + time
                --     end
                -- elseif tonumber(server_week) <= 7 then
                --     time = (8-tonumber(server_week)) * 86400 + tick_time
                -- end
                -- if time < 0 then
                --     time = 24 * 3600 + time
                -- end
                -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[5]..getRedAlertTimeActivityFormat(time))
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_daily[5])
                end
            end
            if end_time <= -1 then
                self:onUpdateDraw()
            end
        elseif tonumber(self._index) == 2 then      -- 阵营对决
            local state = self._state
            local end_time = self._end_time - (os.time() + _ED.time_add_or_sub)
            -- local time_info = zstring.split(dms.string(dms["camp_duel_config"], 1, union_fight_config.param), "|")[2]
            -- time_info = zstring.split(time_info, ",")
            if zstring.tonumber(state) == 3 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[8])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[9])
                end
            elseif zstring.tonumber(state) == 2 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[11])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[7])
                end
            elseif zstring.tonumber(state) == 1 then
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[10])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[6])
                end
            else
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[5])
                local tick_time = end_time
                -- local time = 0
                -- if tonumber(server_week) <= 2 then
                --     time = (2-tonumber(server_week)) * 86400 + tick_time
                -- elseif tonumber(server_week) > 2 and tonumber(server_week) <= 4 then
                --     time = (4-tonumber(server_week)) * 86400 + tick_time
                --     if time < 0 then
                --         time = (9-tonumber(server_week)) * 86400 + time
                --     end
                -- elseif tonumber(server_week) > 4 and tonumber(server_week) <= 7 then
                --     time = (8-tonumber(server_week)) * 86400 + tick_time
                -- end
                -- if time < 0 then
                --     time = 24 * 3600 + time
                -- end
                -- self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_daily[5]..getRedAlertTimeActivityFormat(time))
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_daily[5])
                end
            end
            if end_time <= -1 then
                self:onUpdateDraw()
            end
        elseif tonumber(self._index) == 3 then      -- 守卫战
            local state = self._state
            local end_time = self._end_time - (os.time() + _ED.time_add_or_sub)
            -- local time_info = zstring.split(dms.string(dms["camp_duel_config"], 1, union_fight_config.param), "|")[2]
            -- time_info = zstring.split(time_info, ",")
            if zstring.tonumber(state) == 2 then
                self._Text_campaign_lv_prompt:setString(tipStringInfo_campaign_info[19])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[9])
                end
            elseif zstring.tonumber(state) == 1 then
                self._Text_campaign_lv_prompt:setString(tipStringInfo_campaign_info[18])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_spacing[12])
                end
            else
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[3])
                local tick_time = end_time
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(tick_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_daily[5])
                end
            end
            if end_time <= -1 then
                self:onUpdateDraw()
            end
        elseif tonumber(self._index) == 5 then      -- 城市战
            local open_state = self._state
            local end_time = self._end_time - (os.time() + _ED.time_add_or_sub)
            if tonumber(open_state) == 0 then     -- 未开启
                self._Text_campaign_lv_prompt:setString(limit_dekaron_tip_spacing[1])

                -- local open_time = zstring.split(dms.string(dms["world_city_config"], 1, world_city_config.param), "|")
                -- local open_week = zstring.split(open_time[1], ",")
                -- open_time = zstring.split(open_time[2], ",")
                -- open_time = zstring.split(open_time[1], ":")
                -- local tick_time = (open_time[1] - server_time.hour) * 3600 + (open_time[2] - server_time.min) * 60 - server_time.sec
                -- local current_week = tonumber(server_week)
                -- if tick_time < 0 then
                --     current_week = current_week + 1
                --     tick_time = tick_time + 86400
                -- end
                -- -- local tick_time = end_time
                -- local time = 0

                -- for k, week in pairs(open_week) do
                --     if current_week <= tonumber(week) then
                --         time = (tonumber(week) - current_week) * 86400 + tick_time
                --         break
                --     end

                --     if k == #week then
                --         time = (7 + tonumber(open_week[1]) - current_week) * 86400 + tick_time
                --     end
                -- end

                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(end_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(limit_dekaron_tip_daily[5])
                end
            elseif tonumber(open_state) == 1 then     -- 准备中
                self._Text_campaign_lv_prompt:setString(world_city_tip_str[23])
                -- local open_time = zstring.split(dms.string(dms["world_city_config"], 1, world_city_config.param), "|")
                -- open_time = zstring.split(open_time[2], ",")
                -- open_time = zstring.split(open_time[2], ":")
                -- local tick_time = (open_time[1] - server_time.hour) * 3600 + (open_time[2] - server_time.min) * 60 - server_time.sec
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(end_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(world_city_tip_str[25])
                end
            elseif tonumber(open_state) == 2 then     -- 争夺中
                self._Text_campaign_lv_prompt:setString(world_city_tip_str[24])
                -- local open_time = zstring.split(dms.string(dms["world_city_config"], 1, world_city_config.param), "|")
                -- open_time = zstring.split(open_time[2], ",")
                -- open_time = zstring.split(open_time[3], ":")
                -- local tick_time = (open_time[1] - server_time.hour) * 3600 + (open_time[2] - server_time.min) * 60 - server_time.sec
                if self._Text_campaign_time:getChildByTag(100) ~= nil then
                    self._Text_campaign_time:getChildByTag(100):setString(getRedAlertTimeActivityFormat(end_time))
                end
                if self._Text_campaign_time:getChildByTag(200) ~= nil then
                    self._Text_campaign_time:getChildByTag(200):setString(world_city_tip_str[26])
                end
            end
            if end_time <= -1 then
                self:onUpdateDraw()
            end
        end
    end
end

function CampaignCell:onEnterTransitionFinish()

end

function CampaignCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_campaign_icon = ccui.Helper:seekWidgetByName(root, "Panel_campaign_icon")
    local Text_campaign_name = ccui.Helper:seekWidgetByName(root, "Text_campaign_name")
    local Text_campaign_lv_prompt = ccui.Helper:seekWidgetByName(root, "Text_campaign_lv_prompt")
    if Panel_campaign_icon ~= nil then
        Text_campaign_name:removeAllChildren(true)
        Text_campaign_name:setString("")
        Text_campaign_lv_prompt:removeAllChildren(true)
        Text_campaign_lv_prompt:setString("")
        Panel_campaign_icon:removeAllChildren(true)
        Panel_campaign_icon:removeBackGroundImage()
    end
end

--初始化列表
function CampaignCell:onInit( )
    local root = cacher.createUIRef(config_csb.cells.campaign.campaign_cell, "root")
    root:removeFromParent(false)
    self:addChild(root)
	
	table.insert(self.roots, root)
    if CampaignCell.__size == nil then
        CampaignCell.__size = root:getContentSize()
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_campaign_icon"), nil, 
    {
        terminal_name = "campaign_cell_enter", 
        terminal_state = 0, 
        cell = self,
        touch_black = true,
        -- touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_campaign_go"), nil, 
    {
        terminal_name = "campaign_cell_enter", 
        terminal_state = 0, 
        cell = self,
        touch_black = true,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_campaign_infor"), nil, 
    {
        terminal_name = "campaign_cell_show_info", 
        terminal_state = 0, 
        cell = self,
        touch_black = true,
    }, nil, 1)

    local widget = root
    if widget._nodeChild ~= nil then
        widget:removeChild(widget._nodeChild, true)
        widget._nodeChild = nil
        widget._istips = false
    end
    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_campaign_cell",
        _widget = root,
        _id = self._index,
        _type = self._nType,
        _invoke = nil,
        _interval = 0.2,})
    
    self:onUpdateDraw()	
end

function CampaignCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._nType = params[3]
	self:onInit()
    self:setContentSize(CampaignCell.__size)
    return self
end

function CampaignCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.campaign.campaign_cell, self.roots[1])
end
