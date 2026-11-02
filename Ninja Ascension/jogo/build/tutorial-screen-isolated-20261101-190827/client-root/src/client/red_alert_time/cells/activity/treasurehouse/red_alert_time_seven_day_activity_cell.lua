--------------------------------------------------------------------------------------------------------------
--  说明：七日狂欢cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSevenDayActivityCell = class("RedAlertTimeSevenDayActivityCellClass", Window)
RedAlertTimeSevenDayActivityCell.__size = nil
RedAlertTimeSevenDayActivityCell.__root_posy = nil
RedAlertTimeSevenDayActivityCell.__panel_size = nil
RedAlertTimeSevenDayActivityCell.__button_posy = nil
RedAlertTimeSevenDayActivityCell.__text_posy = nil

--创建cell
local red_alert_time_seven_day_activity_cell_create_terminal = {
    _name = "red_alert_time_seven_day_activity_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeSevenDayActivityCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_seven_day_activity_cell_create_terminal)
state_machine.init()

function RedAlertTimeSevenDayActivityCell:ctor()
    self.super:ctor()
    self.roots = {}

    self._index = 0
    self._activity_index = 0
    self._day_index = 0
    self._current_day = 0
    self._info = 0

    self._cell_size = nil

    local function init_red_alert_time_seven_day_activity_cell_terminal()
        local red_alert_time_seven_day_activity_cell_update_info_terminal = {
            _name = "red_alert_time_seven_day_activity_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._index = params.index
                cell._day_index = params.day_index
                cell._current_day = params.current_day
                cell._info = params.info
                if cell._info ~= nil then
                    if cell._index <= 4 then
                        cell:reload()
                        cell:updateDraw()
                    else
                        cell:unload()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_cell_get_reward_terminal = {
            _name = "red_alert_time_seven_day_activity_cell_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if tonumber(cell._info.achieve_state) == 0 then
                    if cell._day_index == 8 then
                        TipDlg.drawTextDailog(activity_str_tip[119])
                        return
                    end
                    if cell._activity_index == 4 and cell._day_index < cell._current_day then
                        TipDlg.drawTextDailog(activity_str_tip[120])
                        return
                    end
                end
                local acitvity = _ED.activity_info["100"]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_top_button",0,"")
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n".."100".."\r\n"..(tonumber(cell._day_index)-1).."\r\n"..(tonumber(cell._info.achieve_index)-1).."\r\n0"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_seven_day_activity_cell_goto_terminal = {
            _name = "red_alert_time_seven_day_activity_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._activity_index == 4 then
                    state_machine.excute("recharge_dialog_window_open", 0, "")
                else
                    local changeType = cell._info.achieve_other_info
                    if tonumber(changeType) ~= -1 then
                        state_machine.excute("short_cut_go_to_other_window",0,{tonumber(changeType)})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_seven_day_activity_cell_update_info_terminal)   
        state_machine.add(red_alert_time_seven_day_activity_cell_get_reward_terminal)   
        state_machine.add(red_alert_time_seven_day_activity_cell_goto_terminal)   
        state_machine.init()
    end 
    init_red_alert_time_seven_day_activity_cell_terminal()
end

function RedAlertTimeSevenDayActivityCell:updateButtonState()
    local root = self.roots[1]
    local Button_seven_day_activity_rec = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec")
    local Button_seven_day_activity_go = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go")
    Button_seven_day_activity_rec:setVisible(true)
    Button_seven_day_activity_go:setVisible(false)
    if self._day_index < 8 and  self._day_index > self._current_day then
        Button_seven_day_activity_rec:setTouchEnabled(false)
        Button_seven_day_activity_rec:setBright(false)
        Button_seven_day_activity_rec:setTitleText(red_alert_time_str[22])
    else
        local state = tonumber(self._info.achieve_state)
        if state == 2 then
            Button_seven_day_activity_rec:setTouchEnabled(false)
            Button_seven_day_activity_rec:setBright(false)
            Button_seven_day_activity_rec:setTitleText(activity_str_tip[2])
        elseif state == 1 then
            Button_seven_day_activity_rec:setTouchEnabled(true)
            Button_seven_day_activity_rec:setBright(true)
            Button_seven_day_activity_rec:setTitleText(activity_str_tip[5])
        else
            if self._day_index == 8 then
                Button_seven_day_activity_rec:setTouchEnabled(true)
                Button_seven_day_activity_rec:setBright(false)
                Button_seven_day_activity_rec:setTitleText(activity_str_tip[5])
            elseif self._activity_index == 4 and self._day_index < self._current_day then
                Button_seven_day_activity_rec:setTouchEnabled(true)
                Button_seven_day_activity_rec:setBright(false)
                Button_seven_day_activity_rec:setTitleText(activity_str_tip[117])
            else
                Button_seven_day_activity_rec:setVisible(false)
                Button_seven_day_activity_go:setVisible(true)
                Button_seven_day_activity_go:setTouchEnabled(true)
                Button_seven_day_activity_go:setBright(true)
                if self._activity_index == 4 then
                    Button_seven_day_activity_go:setTitleText(red_alert_time_str[30])
                else
                    Button_seven_day_activity_go:setTitleText(activity_str_tip[104])
                    if tonumber(self._info.achieve_other_info) == -1 then
                        Button_seven_day_activity_go:setTouchEnabled(false)
                        Button_seven_day_activity_go:setBright(false)
                    end
                end
            end
        end
    end
end

function RedAlertTimeSevenDayActivityCell:setWidgetPosition(add_height)
    local root = self.roots[1]
    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root, "Panel_seven_day_activity_reward")
    root:setPositionY(RedAlertTimeSevenDayActivityCell.__root_posy + add_height)
    Panel_seven_day_activity_reward:setContentSize(cc.size(RedAlertTimeSevenDayActivityCell.__panel_size, RedAlertTimeSevenDayActivityCell.__panel_size.height + add_height))
    self:setContentSize(cc.size(RedAlertTimeSevenDayActivityCell.__size.width, RedAlertTimeSevenDayActivityCell.__size.height + add_height))
    self._cell_size = self:getContentSize()

    local Button_seven_day_activity_rec = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec")
    local Button_seven_day_activity_go = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go")
    local posY = Panel_seven_day_activity_reward:getPositionY() - Panel_seven_day_activity_reward:getContentSize().height / 2
    Button_seven_day_activity_rec:setPositionY(posY)
    Button_seven_day_activity_go:setPositionY(posY)

    local Text_seven_day_act_t = ccui.Helper:seekWidgetByName(root, "Text_seven_day_act_t")
    local Text_seven_day_act_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_act_n")
    posY = RedAlertTimeSevenDayActivityCell.__text_posy + (posY - RedAlertTimeSevenDayActivityCell.__button_posy)
    Text_seven_day_act_t:setPositionY(posY)
    Text_seven_day_act_n:setPositionY(posY)
end

function RedAlertTimeSevenDayActivityCell:updateDraw()
    local root = self.roots[1]
    local Text_seven_day_activity_tit = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_tit")
    local Text_seven_day_activity_progress_t_p = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_progress_t_p")
    local Text_seven_day_act_t = ccui.Helper:seekWidgetByName(root, "Text_seven_day_act_t")
    local Text_seven_day_act_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_act_n")

    Text_seven_day_activity_tit:setString(self._info.achieve_mould_name)

    local reward_info = zstring.split(self._info.achieve_reward, "|")
    if self._day_index < 8 then
        Text_seven_day_act_t:setVisible(true)
        local value = zstring.split(reward_info[1], ",")[3]
        Text_seven_day_act_n:setString("+"..value)
        table.remove(reward_info, 1, 1)
    else
        Text_seven_day_act_t:setVisible(false)
        Text_seven_day_act_n:setString("")
    end

    local complete_count_info = zstring.split(self._info.achieve_complete_count, "/")
    local currnet_count = tonumber(complete_count_info[1])
    local total_count = tonumber(complete_count_info[2])
    currnet_count = math.min(currnet_count, total_count)
    Text_seven_day_activity_progress_t_p:removeAllChildren(true)
    local font_size = Text_seven_day_activity_progress_t_p:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, activity_str_tip[106], config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, currnet_count, config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..total_count, config_res.font.font_name,font_size)
    _richText:pushBackElement(re3)  
    _richText:setPosition(cc.p(Text_seven_day_activity_progress_t_p:getContentSize().width/2,Text_seven_day_activity_progress_t_p:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_seven_day_activity_progress_t_p:getContentSize().width,font_size))
    Text_seven_day_activity_progress_t_p:addChild(_richText)

    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root, "Panel_seven_day_activity_reward")
    Panel_seven_day_activity_reward:removeAllChildren(true)
    local size = RedAlertTimeSevenDayActivityCell.__panel_size
    local reward_count = #reward_info
    local row_count = math.ceil(reward_count / 3) - 1

    local cell_size = nil

    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])

        local cell = createPropIconCell(prop_data, true, true, true)
        Panel_seven_day_activity_reward:addChild(cell)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end

        cell:setAnchorPoint(cc.p(0, 0))
        local row = row_count - math.floor((k - 1) / 3)
        local col = math.floor((k - 1) % 3)
        if row_count == 0 then
            cell:setPosition(cc.p(size.width / 3 * col, 23))
        else
            cell:setPosition(cc.p(size.width / 3 * col, (cell_size.height + 40) * row))
        end
    end

    local add_height = 0
    if row_count > 0 then
        add_height = (cell_size.height + 40) * row_count - 23
    end

    self:setWidgetPosition(add_height)
    self:updateButtonState()
end

function RedAlertTimeSevenDayActivityCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.activity.treasurehouse.seven_day_activity_cell, 1), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeSevenDayActivityCell.__size == nil then
        RedAlertTimeSevenDayActivityCell.__size = root:getContentSize()
    end

    if RedAlertTimeSevenDayActivityCell.__root_posy == nil then
        RedAlertTimeSevenDayActivityCell.__root_posy = root:getPositionY()
    end

    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root, "Panel_seven_day_activity_reward")
    local Text_seven_day_act_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_act_n")
    local Text_seven_day_act_t = ccui.Helper:seekWidgetByName(root, "Text_seven_day_act_t")
    local Button_seven_day_activity_rec = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec")
    local Button_seven_day_activity_go = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go")
    if RedAlertTimeSevenDayActivityCell.__panel_size == nil then
        RedAlertTimeSevenDayActivityCell.__panel_size = Panel_seven_day_activity_reward:getContentSize()
    end
    if RedAlertTimeSevenDayActivityCell.__button_posy == nil then
        RedAlertTimeSevenDayActivityCell.__button_posy = Button_seven_day_activity_rec:getPositionY()
    end
    if RedAlertTimeSevenDayActivityCell.__text_posy == nil then
        RedAlertTimeSevenDayActivityCell.__text_posy = Text_seven_day_act_n:getPositionY()
    end

    root:setContentSize(RedAlertTimeSevenDayActivityCell.__size)
    root:setPositionY(RedAlertTimeSevenDayActivityCell.__root_posy)
    Panel_seven_day_activity_reward:setContentSize(RedAlertTimeSevenDayActivityCell.__panel_size)
    Text_seven_day_act_n:setPositionY(RedAlertTimeSevenDayActivityCell.__text_posy)
    Text_seven_day_act_t:setPositionY(RedAlertTimeSevenDayActivityCell.__text_posy)
    Button_seven_day_activity_rec:setPositionY(RedAlertTimeSevenDayActivityCell.__button_posy)
    Button_seven_day_activity_go:setPositionY(RedAlertTimeSevenDayActivityCell.__button_posy)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_cell_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_cell_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeSevenDayActivityCell:onEnterTransitionFinish()

end

function RedAlertTimeSevenDayActivityCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeSevenDayActivityCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.activity.treasurehouse.seven_day_activity_cell, 1), root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeSevenDayActivityCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root, "Panel_seven_day_activity_reward")
    local Text_seven_day_activity_tit = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_tit")
    local Text_seven_day_activity_progress_t_p = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_progress_t_p")
    local Text_seven_day_act_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_act_n")
    if Panel_seven_day_activity_reward ~= nil then
        Panel_seven_day_activity_reward:removeAllChildren(true)
        Text_seven_day_activity_tit:setString("")
        Text_seven_day_activity_progress_t_p:removeAllChildren(true)
        Text_seven_day_act_n:setString("")
    end
end

function RedAlertTimeSevenDayActivityCell:init(params)
    self._index = params[1]
    self._activity_index = params[2]
    self._day_index = params[3]
    self._current_day = params[4]
    self._info = params[5]
    if self._index ~= nil and self._index <= 4 then
        self:onInit()
    end
    if self._cell_size == nil then
        self:setContentSize(RedAlertTimeSevenDayActivityCell.__size)
    end
    
    return self
end

function RedAlertTimeSevenDayActivityCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.activity.treasurehouse.seven_day_activity_cell, 1), self.roots[1])
end