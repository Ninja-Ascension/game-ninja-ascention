--------------------------------------------------------------------------------------------------------------
--  说明：夺取黑匣子cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeSnatchRebelHauntPackCell = class("RedAlertTimeSnatchRebelHauntPackCellClass", Window)
RedAlertTimeSnatchRebelHauntPackCell.__size = nil

--创建cell
local red_alert_time_snatch_rebel_haunt_pack_cell_create_terminal = {
    _name = "red_alert_time_snatch_rebel_haunt_pack_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeSnatchRebelHauntPackCell:new()
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
state_machine.add(red_alert_time_snatch_rebel_haunt_pack_cell_create_terminal)
state_machine.init()

function RedAlertTimeSnatchRebelHauntPackCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._activity_type = nil
    self.a_type = 0
    self.index = index
    self.group = group

    self._cost_count = 0
     
    local function init_red_alert_time_snatch_rebel_haunt_pack_cell_terminal()
        local red_alert_time_snatch_rebel_haunt_pack_cell_receive_award_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_pack_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- print("活动领取接口")
                local cell = params._datas.cells
                local acitvity = _ED.activity_info[""..cell.a_type]

                local activity_add_state_arry = zstring.split(activity_info.activity_add_state, "!")
                local activity_add_state = zstring.split(activity_add_state_arry[1], ",")
                local have_count = tonumber(activity_add_state[11])
                if have_count < cell._cost_count then
                    TipDlg.drawTextDailog(activity_str_tip[175])
                    return
                end

                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()  
                        end
                        checkRewardObtainDraw()
                    end
                end     
                protocol_command.draw_activity_reward.param_list = acitvity.activity_id .. "\r\n"..cell.a_type.."\r\n"..(tonumber(cell.group)-1).."\r\n"..tonumber(cell._activity_type.achieve_index)-1
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_snatch_rebel_haunt_pack_cell_update_info_terminal = {
            _name = "red_alert_time_snatch_rebel_haunt_pack_cell_update_info",
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
                    if cell._index <= 3 then
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

        state_machine.add(red_alert_time_snatch_rebel_haunt_pack_cell_receive_award_terminal)
        state_machine.add(red_alert_time_snatch_rebel_haunt_pack_cell_update_info_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_snatch_rebel_haunt_pack_cell_terminal()

end

function RedAlertTimeSnatchRebelHauntPackCell:updateDraw()
    self._activity_type = {
        achieve_index = self.index,
        achieve_complete_count = "1/1",
        achieve_state = "1",
        achieve_mould_name = "大型资源箱",
        achieve_other_info = "100",             -- 兑换话费黑匣子
        achieve_mould_dec = "——",
        achieve_reward = "247,6,1",
    }
    local root = self.roots[1]

    local Panel_snatch_rebel_haunt_pack_reward = ccui.Helper:seekWidgetByName(root,"Panel_snatch_rebel_haunt_pack_reward") 
    local Text_snatch_rebel_haunt_pack_tit = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_pack_tit")  
    local Text_snatch_rebel_haunt_pack_exchange_n = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_pack_exchange_n")      
    local Text_snatch_rebel_haunt_pack_gold_n = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_pack_gold_n")     
    local Button_snatch_rebel_haunt_pack_buy = ccui.Helper:seekWidgetByName(root,"Button_snatch_rebel_haunt_pack_buy")     

    Panel_snatch_rebel_haunt_pack_reward:removeAllChildren(true)
    local prop_info = zstring.split(self._activity_type.achieve_reward, ",")
    local prop_data = {}
    prop_data.prop_item = tonumber(prop_info[1])
    prop_data.prop_type = tonumber(prop_info[2])
    prop_data.item_value = tonumber(prop_info[3])
    local cell = createPropIconCell(prop_data, true, false, true)
    Panel_snatch_rebel_haunt_pack_reward:addChild(cell)

    Text_snatch_rebel_haunt_pack_tit:setString(self._activity_type.achieve_mould_name)

    local achieve_complete_count = zstring.split(self._activity_type.achieve_complete_count, "/")
    local current_count = tonumber(achieve_complete_count[2]) - tonumber(achieve_complete_count[1])
    local total_count = tonumber(achieve_complete_count[2])
    Text_snatch_rebel_haunt_pack_exchange_n:setString(""..current_count.."/"..total_count)

    if current_count >= total_count then
        Button_snatch_rebel_haunt_pack_buy:setTitleText(red_alert_time_str[231])
        Button_snatch_rebel_haunt_pack_buy:setTouchEnabled(false)
        Button_snatch_rebel_haunt_pack_buy:setBright(false)
    else
        Button_snatch_rebel_haunt_pack_buy:setTitleText(red_alert_time_str[133])
        Button_snatch_rebel_haunt_pack_buy:setTouchEnabled(true)
        Button_snatch_rebel_haunt_pack_buy:setBright(true)
    end

    local cost = tonumber(self._activity_type.achieve_other_info)
    Text_snatch_rebel_haunt_pack_gold_n:setString(cost)
    self._cost_count = cost
end 

function RedAlertTimeSnatchRebelHauntPackCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.treasurehouse.snatch_rebel_haunt_pack_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeSnatchRebelHauntPackCell.__size == nil then
        RedAlertTimeSnatchRebelHauntPackCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_snatch_rebel_haunt_pack_buy"), nil, 
    {
        terminal_name = "red_alert_time_snatch_rebel_haunt_pack_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()
end

function RedAlertTimeSnatchRebelHauntPackCell:onEnterTransitionFinish()
    local root = self.roots[1]
    
end

function RedAlertTimeSnatchRebelHauntPackCell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_snatch_rebel_haunt_pack_reward = ccui.Helper:seekWidgetByName(root,"Panel_snatch_rebel_haunt_pack_reward") 
    local Text_snatch_rebel_haunt_pack_tit = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_pack_tit")  
    local Text_snatch_rebel_haunt_pack_exchange_n = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_pack_exchange_n")      
    local Text_snatch_rebel_haunt_pack_gold_n = ccui.Helper:seekWidgetByName(root,"Text_snatch_rebel_haunt_pack_gold_n")     
    if Panel_snatch_rebel_haunt_pack_reward ~= nil then
        Panel_snatch_rebel_haunt_pack_reward:removeAllChildren(true)
        Text_snatch_rebel_haunt_pack_tit:setString("")
        Text_snatch_rebel_haunt_pack_exchange_n:setString("")
        Text_snatch_rebel_haunt_pack_gold_n:setString("")
    end
end

function RedAlertTimeSnatchRebelHauntPackCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeSnatchRebelHauntPackCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.snatch_rebel_haunt_pack_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeSnatchRebelHauntPackCell:init(activity_type,index,a_type,group)
    self._activity_type = activity_type
    self.index = index
    self.a_type = a_type
    self.group = group
    if index ~= nil and index <= 3 then
       self:onInit()
    end
    self:setContentSize(RedAlertTimeSnatchRebelHauntPackCell.__size)
    return self
end

function RedAlertTimeSnatchRebelHauntPackCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.treasurehouse.snatch_rebel_haunt_pack_cell, self.roots[1])
end