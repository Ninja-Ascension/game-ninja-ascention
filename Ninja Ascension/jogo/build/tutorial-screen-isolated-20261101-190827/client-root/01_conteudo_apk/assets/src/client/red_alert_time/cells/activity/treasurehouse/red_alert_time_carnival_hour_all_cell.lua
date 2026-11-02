--------------------------------------------------------------------------------------------------------------
--  说明：狂欢时刻cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeCarnivalHourAllCell = class("RedAlertTimeCarnivalHourAllCellClass", Window)
RedAlertTimeCarnivalHourAllCell.__size = nil

--创建cell
local red_alert_time_carnival_hour_all_cell_create_terminal = {
    _name = "red_alert_time_carnival_hour_all_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeCarnivalHourAllCell:new()
        local activity_type = params[1]
        local index = tonumber(params[2])
        local a_type = tonumber(params[3]) or 0
        local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_carnival_hour_all_cell_create_terminal)
state_machine.init()

function RedAlertTimeCarnivalHourAllCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self.index = index
    self.group = group

    self._need_online_time = 0
    self._have_online_time = 0
    self._last_end_time = 0
    self._text_time = nil

    self._receive_state = 0         -- 0：领取，1：充值
     
    local function init_red_alert_time_carnival_hour_all_cell_terminal()
        local red_alert_time_carnival_hour_all_cell_receive_award_terminal = {
            _name = "red_alert_time_carnival_hour_all_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("活动领取接口")
                local cell = params._datas.cells
                if cell._receive_state == 1 then
                    state_machine.excute("recharge_dialog_window_open", 0, "")
                    return
                else
                    local acitvity = _ED.activity_info[""..cell.a_type]
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:updateDraw()
                            end
                            checkRewardObtainDraw()
                            state_machine.excute("main_window_update_top_button", 0, nil)
                            state_machine.excute("red_alert_time_carnival_hour_online_update_draw", 0, "")
                        end
                    end     
                    protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..(tonumber(cell._activity_type.achieve_index)-1).."\r\n".."0"
                    NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_carnival_hour_all_cell_goto_terminal = {
            _name = "red_alert_time_carnival_hour_all_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local changeType = cell._activity_type.achieve_other_info
                if tonumber(changeType) ~= -1 then
                    state_machine.excute("short_cut_go_to_other_window",0,{tonumber(changeType)})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_carnival_hour_all_cell_update_info_terminal = {
            _name = "red_alert_time_carnival_hour_all_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._activity_type = params.info
                cell.a_type = params.a_type
                cell.index = params.index
                cell.group = params.group
                cell._text_time = nil
                if cell._activity_type ~= nil then
                    -- if cell._index <= 4 then
                        cell:reload()
                        cell:updateDraw()
                    -- else
                    --     cell:unload()
                    -- end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_carnival_hour_all_cell_receive_award_terminal)
        state_machine.add(red_alert_time_carnival_hour_all_cell_goto_terminal)
        state_machine.add(red_alert_time_carnival_hour_all_cell_update_info_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_carnival_hour_all_cell_terminal()

end

function RedAlertTimeCarnivalHourAllCell:updateDraw()
    local root = self.roots[1]
    local Text_carnival_hour_all_cell_tit = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_all_cell_tit")
    local Text_carnival_hour_all_p = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_all_p")
    local Text_carnival_hour_all_time = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_all_time")
    local Button_carnival_hour_all_go = ccui.Helper:seekWidgetByName(root,"Button_carnival_hour_all_go")
    local Button_carnival_hour_recharge = ccui.Helper:seekWidgetByName(root,"Button_carnival_hour_recharge")
    local Text_lingqu = ccui.Helper:seekWidgetByName(root,"Text_lingqu")
    Text_carnival_hour_all_p:removeAllChildren(true)

    Text_carnival_hour_all_cell_tit:setString(self._activity_type.achieve_mould_name)
    Text_carnival_hour_all_p:setString(self._activity_type.achieve_mould_dec)

    if Text_lingqu ~= nil then
        Text_lingqu:setString("")
    end

    self._receive_state = 0
    if self.group == 1 then       
        if self._activity_type.achieve_other_info == "-1" then
            -- 在线奖励
            local activity_info = _ED.activity_info[""..self.a_type]
            -- activity_add_state = "活动起始时间,活动关闭时间,领奖时间,当前时间,上次在线结算时间,已结算在线时长|附加参数"
            local activity_add_state_arr = zstring.split(activity_info.activity_add_state,"|")
            local datas = zstring.split(activity_add_state_arr[1],",")

            local countdatas = zstring.split(self._activity_type.achieve_complete_count, "/")
            self._need_online_time = tonumber(countdatas[2]) * 60
            self._have_online_time = tonumber(datas[6]) / 1000
            self._last_end_time = tonumber(datas[5]) / 1000

            self.m_time = self._have_online_time + (os.time() + _ED.time_add_or_sub - self._last_end_time)
            Text_carnival_hour_all_time:setString(_string_piece_info[268]..math.floor(self.m_time / 60)..tipStringInfo_time_info[6])
            self._text_time = Text_carnival_hour_all_time

            Text_carnival_hour_all_p:setString("")
            Text_carnival_hour_all_p:removeAllChildren(true)
            local font_size = Text_carnival_hour_all_p:getFontSize()
            local _richText = ccui.RichText:create()
            _richText:ignoreContentAdaptWithSize(false)       
            local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[150], "fonts/simhei.ttf",font_size)
            _richText:pushBackElement(re1)  
            local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, countdatas[2], "fonts/simhei.ttf",font_size)
            _richText:pushBackElement(re2)  
            local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[151], "fonts/simhei.ttf",font_size)
            _richText:pushBackElement(re3)
            _richText:setPosition(cc.p(Text_carnival_hour_all_p:getContentSize().width/2,Text_carnival_hour_all_p:getContentSize().height/2))
            _richText:setContentSize(cc.size(Text_carnival_hour_all_p:getContentSize().width,font_size))
            Text_carnival_hour_all_p:addChild(_richText)


            Button_carnival_hour_all_go:setVisible(false)
            Button_carnival_hour_recharge:setVisible(true)
            if tonumber(self._activity_type.achieve_state) == 2 then
                Button_carnival_hour_recharge:setTouchEnabled(false)
                Button_carnival_hour_recharge:setBright(false)
                Button_carnival_hour_recharge:setTitleText(activity_str_tip[2])
                if verifySupportLanguage(_lua_release_language_en) == true then
                    Button_carnival_hour_recharge:setVisible(false)
                    Text_lingqu:setString(activity_str_tip[2])
                end
            elseif self.m_time >= self._need_online_time then
                self._activity_type.achieve_state = 1
                Button_carnival_hour_recharge:setTouchEnabled(true)
                Button_carnival_hour_recharge:setBright(true)
                Button_carnival_hour_recharge:setTitleText(activity_str_tip[5])
            else
                Button_carnival_hour_recharge:setTouchEnabled(false)
                Button_carnival_hour_recharge:setBright(false)
                Button_carnival_hour_recharge:setTitleText(activity_str_tip[147])
                if verifySupportLanguage(_lua_release_language_en) == true then
                    Button_carnival_hour_recharge:setVisible(false)
                end
            end
        else 
            Button_carnival_hour_all_go:setVisible(true)
            Button_carnival_hour_recharge:setVisible(false)
            Button_carnival_hour_all_go:setTitleText(activity_str_tip[104])
        end
    elseif self.group == 2 then
        if self.index > 1 then
            local complete_count = zstring.split(self._activity_type.achieve_complete_count, "/")
            local total_count = tonumber(complete_count[2])
            local current_count = math.min(tonumber(complete_count[1]), total_count)
            Text_carnival_hour_all_p:setString(activity_str_tip[149]..current_count.."/"..total_count)
        end
        Button_carnival_hour_all_go:setVisible(false)
        Button_carnival_hour_recharge:setVisible(true)
        if tonumber(self._activity_type.achieve_state) == 2 then
            Button_carnival_hour_recharge:setTouchEnabled(false)
            Button_carnival_hour_recharge:setBright(false)
            Button_carnival_hour_recharge:setTitleText(activity_str_tip[2])
            if verifySupportLanguage(_lua_release_language_en) == true then
                Button_carnival_hour_recharge:setVisible(false)
                Text_lingqu:setString(activity_str_tip[2])
            end
        elseif tonumber(self._activity_type.achieve_state) == 1 then
            Button_carnival_hour_recharge:setTouchEnabled(true)
            Button_carnival_hour_recharge:setBright(true)
            Button_carnival_hour_recharge:setTitleText(activity_str_tip[5])
        else
            Button_carnival_hour_recharge:setTouchEnabled(true)
            Button_carnival_hour_recharge:setBright(true)
            self._receive_state = 1
            if self.index == 1 then
                Button_carnival_hour_recharge:setTitleText(activity_str_tip[148])
            else
                Button_carnival_hour_recharge:setTitleText(activity_str_tip[199])
            end
        end
    end

    local ListView_carnival_hour_all_reward = ccui.Helper:seekWidgetByName(root,"ListView_carnival_hour_all_reward")
    ListView_carnival_hour_all_reward:removeAllItems()
    local reward_info = zstring.split(self._activity_type.achieve_reward, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])

        local cell = nil
        if self.group == 1 and self._activity_type.achieve_other_info ~= "-1" then
            cell = createPropIconCell(prop_data, false, false, false)
        else
            cell = createPropIconCell(prop_data, true, true, true)
        end
        ListView_carnival_hour_all_reward:addChild(cell)
    end
    ListView_carnival_hour_all_reward:requestRefreshView()
end 

function RedAlertTimeCarnivalHourAllCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.carnival_hour_all_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeCarnivalHourAllCell.__size == nil then
        RedAlertTimeCarnivalHourAllCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_carnival_hour_recharge"), nil, 
    {
        terminal_name = "red_alert_time_carnival_hour_all_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    --前往
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_carnival_hour_all_go"), nil, 
    {
        terminal_name = "red_alert_time_carnival_hour_all_cell_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeCarnivalHourAllCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlertTimeCarnivalHourAllCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_carnival_hour_all_cell_tit = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_all_cell_tit")
    local Text_carnival_hour_all_p = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_all_p")
    local Text_carnival_hour_all_time = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_all_time")
    local ListView_carnival_hour_all_reward = ccui.Helper:seekWidgetByName(root,"ListView_carnival_hour_all_reward")
    local Text_lingqu = ccui.Helper:seekWidgetByName(root,"Text_lingqu")
    if Text_carnival_hour_all_cell_tit ~= nil then
        Text_carnival_hour_all_cell_tit:setString("")
        Text_carnival_hour_all_p:setString("")
        Text_carnival_hour_all_p:removeAllChildren(true)
        Text_carnival_hour_all_time:setString("")
        ListView_carnival_hour_all_reward:removeAllItems()
    end
    if Text_lingqu ~= nil then
        Text_lingqu:setString("")
    end
    self._text_time = nil
    self:unregisterOnNoteUpdate(self)
end

function RedAlertTimeCarnivalHourAllCell:onUpdate()
    if self._text_time ~= nil and self.group == 1 then
        local activity_info = _ED.activity_info[""..self.a_type]
        self.m_time = self._have_online_time + (os.time() + _ED.time_add_or_sub - self._last_end_time)
        self._text_time:setString(_string_piece_info[268]..math.floor(self.m_time / 60)..tipStringInfo_time_info[6])
        if self.m_time >= self._need_online_time then
            if tonumber(self._activity_type.achieve_state) <= 0 then
                self:updateDraw()
            end
        end
    end
end

function RedAlertTimeCarnivalHourAllCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function RedAlertTimeCarnivalHourAllCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.carnival_hour_all_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeCarnivalHourAllCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    -- if index ~= nil and index < 8 then
       self:onInit()
    -- end

    self:setContentSize(RedAlertTimeCarnivalHourAllCell.__size)
    return self
end

function RedAlertTimeCarnivalHourAllCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.carnival_hour_all_cell, self.roots[1])
end