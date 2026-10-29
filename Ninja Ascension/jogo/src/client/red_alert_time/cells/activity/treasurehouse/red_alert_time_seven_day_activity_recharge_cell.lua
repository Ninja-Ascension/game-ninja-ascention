--------------------------------------------------------------------------------------------------------------
--  说明：七日狂欢cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSevenDayActivityRechargeCell = class("RedAlertTimeSevenDayActivityRechargeCellClass", Window)
RedAlertTimeSevenDayActivityRechargeCell.__size = nil
RedAlertTimeSevenDayActivityRechargeCell.__button_posy = nil

--创建cell
local red_alert_time_seven_day_activity_recharge_cell_create_terminal = {
    _name = "red_alert_time_seven_day_activity_recharge_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeSevenDayActivityRechargeCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_seven_day_activity_recharge_cell_create_terminal)
state_machine.init()

function RedAlertTimeSevenDayActivityRechargeCell:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._index = 0
    self._activity_index = 0
    self._day_index = 0
    self._current_day = 0
    self._info = 0

    local function init_red_alert_time_seven_day_activity_recharge_cell_terminal()
        local red_alert_time_seven_day_activity_recharge_cell_update_info_terminal = {
            _name = "red_alert_time_seven_day_activity_recharge_cell_update_info",
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

        local red_alert_time_seven_day_activity_recharge_cell_get_reward_terminal = {
            _name = "red_alert_time_seven_day_activity_recharge_cell_get_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell._day_index == 8 and tonumber(cell._info.achieve_state) == 0 then
                    TipDlg.drawTextDailog(activity_str_tip[119])
                    return
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

        local red_alert_time_seven_day_activity_recharge_cell_goto_terminal = {
            _name = "red_alert_time_seven_day_activity_recharge_cell_goto",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                local complete_count_info = zstring.split(cell._info.achieve_complete_count, "/")
                if tonumber(complete_count_info[1]) == 0 then
                    TipDlg.drawTextDailog(tipString_legion_info[37])
                    return
                end
                -- 购买
                local acitvity = _ED.activity_info["100"]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        checkRewardObtainDraw()
                        state_machine.excute("main_window_update_top_button",0,"")
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n".."100".."\r\n"..(tonumber(cell._day_index)-1).."\r\n"..(tonumber(cell._info.achieve_index)-1).."\r\n1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(red_alert_time_seven_day_activity_recharge_cell_update_info_terminal)   
        state_machine.add(red_alert_time_seven_day_activity_recharge_cell_get_reward_terminal)   
        state_machine.add(red_alert_time_seven_day_activity_recharge_cell_goto_terminal)   
        state_machine.init()
    end 
    init_red_alert_time_seven_day_activity_recharge_cell_terminal()
end

function RedAlertTimeSevenDayActivityRechargeCell:updateButtonState()
    local root = self.roots[1]
    local Button_seven_day_activity_rec = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec")
    local Button_seven_day_activity_go = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go")
    if self._day_index == 8 then
        Button_seven_day_activity_rec:setVisible(true)
        Button_seven_day_activity_go:setVisible(false)
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
            Button_seven_day_activity_rec:setTouchEnabled(true)
            Button_seven_day_activity_rec:setBright(false)
            Button_seven_day_activity_rec:setTitleText(activity_str_tip[5])
        end
    else
        Button_seven_day_activity_rec:setVisible(false)
        Button_seven_day_activity_go:setVisible(true)
        if self._day_index > self._current_day then
            Button_seven_day_activity_go:setTouchEnabled(false)
            Button_seven_day_activity_go:setBright(false)
            Button_seven_day_activity_go:setTitleText(red_alert_time_str[22])
        else
            Button_seven_day_activity_go:setTouchEnabled(true)
            Button_seven_day_activity_go:setTitleText(activity_str_tip[49])
            local complete_count_info = zstring.split(self._info.achieve_complete_count, "/")
            if tonumber(complete_count_info[1]) > 0 then
                Button_seven_day_activity_go:setBright(true)
            else
                Button_seven_day_activity_go:setBright(false)
            end
        end
    end
end

function RedAlertTimeSevenDayActivityRechargeCell:updateDraw()
    local root = self.roots[1]
    local Text_seven_day_activity_tit = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_tit")
    local Text_seven_day_activity_progress_t_p = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_progress_t_p")
    Text_seven_day_activity_tit:setString(self._info.achieve_mould_name)

    local Text_seven_day_activity_buy_t = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_buy_t")
    local Image_gold_icon_1 = ccui.Helper:seekWidgetByName(root, "Image_gold_icon_1")
    local Image_13 = ccui.Helper:seekWidgetByName(root, "Image_13")
    local Image_gold_icon_1_0 = ccui.Helper:seekWidgetByName(root, "Image_gold_icon_1_0")
    local Text_seven_day_activity_dis_t = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_dis_t")
    local Text_seven_day_activity_dis_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_dis_n")
    local Text_seven_day_activity_buy_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_buy_n")
    local Button_seven_day_activity_rec = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec")
    local Button_seven_day_activity_go = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go")
    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root, "Panel_seven_day_activity_reward")
    if self._day_index == 8 then
        Text_seven_day_activity_buy_t:setVisible(false)
        Text_seven_day_activity_buy_n:setVisible(false)
        Image_gold_icon_1:setVisible(false)
        Image_13:setVisible(false)
        Image_gold_icon_1_0:setVisible(false)
        Text_seven_day_activity_dis_t:setVisible(false)
        Text_seven_day_activity_dis_n:setVisible(false)
        local posY = Panel_seven_day_activity_reward:getPositionY() - Panel_seven_day_activity_reward:getContentSize().height / 2
        Button_seven_day_activity_rec:setPositionY(posY)
        Button_seven_day_activity_go:setPositionY(posY)
    else
        Text_seven_day_activity_buy_t:setVisible(true)
        Text_seven_day_activity_buy_n:setVisible(true)
        Image_gold_icon_1:setVisible(true)
        Image_13:setVisible(true)
        Image_gold_icon_1_0:setVisible(true)
        Text_seven_day_activity_dis_t:setVisible(true)
        Text_seven_day_activity_dis_n:setVisible(true)
        Button_seven_day_activity_rec:setPositionY(RedAlertTimeSevenDayActivityRechargeCell.__button_posy)
        Button_seven_day_activity_go:setPositionY(RedAlertTimeSevenDayActivityRechargeCell.__button_posy)

        local moneyData = zstring.split(self._info.achieve_other_info, ",")
        -- --折后价
        Text_seven_day_activity_dis_n:setString(moneyData[3])
        -- --原价
        Text_seven_day_activity_buy_n:setString(moneyData[4])
    end

    local complete_count_info = zstring.split(self._info.achieve_complete_count, "/")
    local currnet_count = tonumber(complete_count_info[1])
    local total_count = tonumber(complete_count_info[2])
    local complete_str = activity_str_tip[106]
    if self._day_index < 8 then
        currnet_count = tonumber(complete_count_info[2]) - tonumber(complete_count_info[1])
        complete_str = activity_str_tip[118]
    end
    currnet_count = math.min(currnet_count, total_count)
    Text_seven_day_activity_progress_t_p:setString("")
    Text_seven_day_activity_progress_t_p:removeAllChildren(true)
    local font_size = Text_seven_day_activity_progress_t_p:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, complete_str, config_res.font.font_name,font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]),255, currnet_count, config_res.font.font_name,font_size)
    _richText:pushBackElement(re2)
    local re3 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..total_count, config_res.font.font_name,font_size)
    _richText:pushBackElement(re3)  
    _richText:setPosition(cc.p(Text_seven_day_activity_progress_t_p:getContentSize().width/2,Text_seven_day_activity_progress_t_p:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_seven_day_activity_progress_t_p:getContentSize().width,font_size))
    Text_seven_day_activity_progress_t_p:addChild(_richText)

    Panel_seven_day_activity_reward:removeAllChildren(true)
    local size = Panel_seven_day_activity_reward:getContentSize()
    local reward_info = zstring.split(self._info.achieve_reward, "|")
    local reward_count = #reward_info

    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])

        local cell = createPropIconCell(prop_data, true, true, true)
        Panel_seven_day_activity_reward:addChild(cell)
        local col = math.floor((k - 1) % 3)
        cell:setPosition(cc.p(size.width / 3 * col, 23))
    end

    self:updateButtonState()
end

function RedAlertTimeSevenDayActivityRechargeCell:onInit()
    local root = cacher.createUIRef(string.format(config_csb.cells.activity.treasurehouse.seven_day_activity_cell, 2), "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeSevenDayActivityRechargeCell.__size == nil then
        RedAlertTimeSevenDayActivityRechargeCell.__size = root:getContentSize()
    end

    local Button_seven_day_activity_rec = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec")
    local Button_seven_day_activity_go = ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go")
    if RedAlertTimeSevenDayActivityRechargeCell.__button_posy == nil then
        RedAlertTimeSevenDayActivityRechargeCell.__button_posy = Button_seven_day_activity_rec:getPositionY()
    end
    Button_seven_day_activity_rec:setPositionY(RedAlertTimeSevenDayActivityRechargeCell.__button_posy)
    Button_seven_day_activity_go:setPositionY(RedAlertTimeSevenDayActivityRechargeCell.__button_posy)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_rec"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_recharge_cell_get_reward", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_seven_day_activity_go"), nil, 
    {
        terminal_name = "red_alert_time_seven_day_activity_recharge_cell_goto", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95,
        cell = self,
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeSevenDayActivityRechargeCell:onEnterTransitionFinish()

end

function RedAlertTimeSevenDayActivityRechargeCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeSevenDayActivityRechargeCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.activity.treasurehouse.seven_day_activity_cell, 2), root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeSevenDayActivityRechargeCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root, "Panel_seven_day_activity_reward")
    local Text_seven_day_activity_tit = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_tit")
    local Text_seven_day_activity_progress_t_p = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_progress_t_p")
    local Text_seven_day_activity_dis_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_dis_n")
    local Text_seven_day_activity_buy_n = ccui.Helper:seekWidgetByName(root, "Text_seven_day_activity_buy_n")
    if Panel_seven_day_activity_reward ~= nil then
        Panel_seven_day_activity_reward:removeAllChildren(true)
        Text_seven_day_activity_tit:setString("")
        Text_seven_day_activity_progress_t_p:setString("")
        Text_seven_day_activity_progress_t_p:removeAllChildren(true)
        Text_seven_day_activity_dis_n:setString("")
        Text_seven_day_activity_buy_n:setString("")
    end
end

function RedAlertTimeSevenDayActivityRechargeCell:init(params)
    self._index = params[1]
    self._activity_index = params[2]
    self._day_index = params[3]
    self._current_day = params[4]
    self._info = params[5]
    if self._index ~= nil and self._index <= 4 then
        self:onInit()
    end
    self:setContentSize(RedAlertTimeSevenDayActivityRechargeCell.__size)
    return self
end

function RedAlertTimeSevenDayActivityRechargeCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(string.format(config_csb.cells.activity.treasurehouse.seven_day_activity_cell, 2), self.roots[1])
end