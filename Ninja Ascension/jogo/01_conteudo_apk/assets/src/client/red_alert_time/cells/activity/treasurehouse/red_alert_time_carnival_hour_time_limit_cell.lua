--------------------------------------------------------------------------------------------------------------
--  说明：狂欢时刻cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeCarnivalHourTimeLimitCell = class("RedAlertTimeCarnivalHourTimeLimitCellClass", Window)
RedAlertTimeCarnivalHourTimeLimitCell.__size = nil

--创建cell
local red_alert_time_carnival_hour_time_limit_cell_create_terminal = {
    _name = "red_alert_time_carnival_hour_time_limit_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeCarnivalHourTimeLimitCell:new()
        local activity_type = params[1]
        local index = tonumber(params[2])
        local a_type = tonumber(params[3]) or 0
        local group = tonumber(params[4]) or 0
        cell:init(activity_type,index,a_type,group)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_carnival_hour_time_limit_cell_create_terminal)
state_machine.init()

function RedAlertTimeCarnivalHourTimeLimitCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self.index = index
    self.group = group

    self._need_online_time = 0
    self._have_online_time = 0
    self._text_time = nil
     
    local function init_red_alert_time_carnival_hour_time_limit_cell_terminal()
        local red_alert_time_carnival_hour_time_limit_cell_receive_award_terminal = {
            _name = "red_alert_time_carnival_hour_time_limit_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("活动领取接口")
                local cell = params._datas.cells
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
                local index = 0
                if _ED.carnival_hour_shop_list ~= nil then
                    index = zstring.tonumber(_ED.carnival_hour_shop_list[tonumber(cell._activity_type.achieve_index)])
                end
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..(tonumber(cell._activity_type.achieve_index) - 1).."\r\n".."1"
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_carnival_hour_time_limit_cell_goto_terminal = {
            _name = "red_alert_time_carnival_hour_time_limit_cell_goto",
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

        local red_alert_time_carnival_hour_time_limit_cell_update_info_terminal = {
            _name = "red_alert_time_carnival_hour_time_limit_cell_update_info",
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

        state_machine.add(red_alert_time_carnival_hour_time_limit_cell_receive_award_terminal)
        state_machine.add(red_alert_time_carnival_hour_time_limit_cell_goto_terminal)
        state_machine.add(red_alert_time_carnival_hour_time_limit_cell_update_info_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_carnival_hour_time_limit_cell_terminal()

end

function RedAlertTimeCarnivalHourTimeLimitCell:updateDraw()
    local root = self.roots[1]
    local Text_carnival_hour_time_limit_name = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_name")

    local Text_carnival_hour_time_limit_price_old = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_price_old")
    local Text_carnival_hour_time_limit_price = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_price")
    local Text_carnival_hour_time_limit_times_n = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_times_n")
    local Button_carnival_hour_time_limit_buy = ccui.Helper:seekWidgetByName(root,"Button_carnival_hour_time_limit_buy")
    
    local moneyData = zstring.split(self._activity_type.achieve_other_info, ",")
    -- --折后价
    Text_carnival_hour_time_limit_price:setString(moneyData[3])
    -- --原价
    Text_carnival_hour_time_limit_price_old:setString(moneyData[4])

    local complete_count_info = zstring.split(self._activity_type.achieve_complete_count, "/")
    local total_count = tonumber(complete_count_info[2])
    local current_count = tonumber(complete_count_info[2]) - tonumber(complete_count_info[1])

    Text_carnival_hour_time_limit_times_n:setString("")
    Text_carnival_hour_time_limit_times_n:removeAllChildren(true)
    local font_size = Text_carnival_hour_time_limit_times_n:getFontSize()
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[5][1],color_Type[5][2],color_Type[5][3]),255, ""..current_count, "fonts/simhei.ttf",font_size)
    _richText:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, "/"..total_count, "fonts/simhei.ttf",font_size)
    _richText:pushBackElement(re2)
    _richText:setPosition(cc.p(Text_carnival_hour_time_limit_times_n:getContentSize().width/2,Text_carnival_hour_time_limit_times_n:getContentSize().height/2))
    _richText:setContentSize(cc.size(Text_carnival_hour_time_limit_times_n:getContentSize().width,font_size))
    Text_carnival_hour_time_limit_times_n:addChild(_richText)

    if current_count < total_count then
        Button_carnival_hour_time_limit_buy:setTouchEnabled(true)
        Button_carnival_hour_time_limit_buy:setBright(true)
        Button_carnival_hour_time_limit_buy:setTitleText(activity_str_tip[49])
    else
        Button_carnival_hour_time_limit_buy:setTouchEnabled(false)
        Button_carnival_hour_time_limit_buy:setBright(false)
        Button_carnival_hour_time_limit_buy:setTitleText(red_alert_time_str[231])
    end

    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root,"Panel_seven_day_activity_reward")
    Panel_seven_day_activity_reward:removeAllChildren(true)

    local info = zstring.split(self._activity_type.achieve_reward, ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(info[1])
    prop_data.prop_type = tonumber(info[2])
    prop_data.item_value = tonumber(info[3])
    cell = createPropIconCell(prop_data, false, false, true)
    Panel_seven_day_activity_reward:addChild(cell)

    Text_carnival_hour_time_limit_name:setString(self._activity_type.achieve_mould_name.."*"..prop_data.item_value)

    --折扣标签
    if tonumber(moneyData[5]) > 0 then
        local discountCell = state_machine.excute("red_alert_time_discount_label_cell",0,{moneyData[5]})
        Panel_seven_day_activity_reward:addChild(discountCell,100)
    end
end 

function RedAlertTimeCarnivalHourTimeLimitCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.carnival_hour_time_limit_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeCarnivalHourTimeLimitCell.__size == nil then
        RedAlertTimeCarnivalHourTimeLimitCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_carnival_hour_time_limit_buy"), nil, 
    {
        terminal_name = "red_alert_time_carnival_hour_time_limit_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeCarnivalHourTimeLimitCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlertTimeCarnivalHourTimeLimitCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_carnival_hour_time_limit_name = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_name")
    local Text_carnival_hour_time_limit_price_old = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_price_old")
    local Text_carnival_hour_time_limit_price = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_price")
    local Text_carnival_hour_time_limit_times_n = ccui.Helper:seekWidgetByName(root,"Text_carnival_hour_time_limit_times_n")
    local Panel_seven_day_activity_reward = ccui.Helper:seekWidgetByName(root,"Panel_seven_day_activity_reward")
    if Text_carnival_hour_time_limit_name ~= nil then
        Text_carnival_hour_time_limit_name:setString("")
        Text_carnival_hour_time_limit_price_old:setString("")
        Text_carnival_hour_time_limit_price:setString("")
        Text_carnival_hour_time_limit_times_n:setString("")
        Text_carnival_hour_time_limit_times_n:removeAllChildren(true)
        Panel_seven_day_activity_reward:removeAllChildren(true)
    end
end

function RedAlertTimeCarnivalHourTimeLimitCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeCarnivalHourTimeLimitCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.carnival_hour_time_limit_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeCarnivalHourTimeLimitCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    -- if index ~= nil and index < 8 then
       self:onInit()
    -- end

    self:setContentSize(RedAlertTimeCarnivalHourTimeLimitCell.__size)
    return self
end

function RedAlertTimeCarnivalHourTimeLimitCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.carnival_hour_time_limit_cell, self.roots[1])
end