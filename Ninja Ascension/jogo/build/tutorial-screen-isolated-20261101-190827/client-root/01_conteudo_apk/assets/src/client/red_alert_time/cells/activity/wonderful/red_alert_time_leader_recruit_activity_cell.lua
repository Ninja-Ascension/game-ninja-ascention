--------------------------------------------------------------------------------------------------------------
--  说明：排行榜活动cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeLeaderRecruitActivityCell = class("RedAlertTimeLeaderRecruitActivityCellClass", Window)
RedAlertTimeLeaderRecruitActivityCell.__size = nil

--创建cell
local red_alert_time_leader_recruit_activity_cell_create_terminal = {
    _name = "red_alert_time_leader_recruit_activity_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeLeaderRecruitActivityCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_leader_recruit_activity_cell_create_terminal)
state_machine.init()

function RedAlertTimeLeaderRecruitActivityCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = 0
    self._info = nil
    self._activity_type = 0
    self._group = 0
     -- Initialize red_alert_time_act_share_cell state machine.
     
    local function init_red_alert_time_leader_recruit_activity_cell_terminal()
        local red_alert_time_leader_recruit_activity_cell_receive_award_terminal = {
            _name = "red_alert_time_leader_recruit_activity_cell_receive_award",
            _init = function (terminal)       
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cells
                local activity_info = _ED.activity_info[""..cell._activity_type]
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                        checkRewardObtainDraw()
                    end
                end     
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n"..(tonumber(cell._group)-1).."\r\n"..(tonumber(cell._info.achieve_index)-1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_leader_recruit_activity_cell_update_info_terminal = {
            _name = "red_alert_time_leader_recruit_activity_cell_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params.cell
                cell._index = params.index
                cell._info = params.info
                cell._group = params.group
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

        state_machine.add(red_alert_time_leader_recruit_activity_cell_receive_award_terminal)
        state_machine.add(red_alert_time_leader_recruit_activity_cell_update_info_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_leader_recruit_activity_cell_terminal()

end

function RedAlertTimeLeaderRecruitActivityCell:updateDraw()
    local root = self.roots[1]
    local Text_act_share_tit = ccui.Helper:seekWidgetByName(root,"Text_act_share_tit")
    local Text_act_share_progress_t = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t")
    local Text_act_share_not = ccui.Helper:seekWidgetByName(root,"Text_act_share_not")
    local ListView_act_share_reward = ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")
    local Button_act_share_rec = ccui.Helper:seekWidgetByName(root,"Button_act_share_rec")

    Text_act_share_progress_t:setVisible(false)
    Text_act_share_tit:setString(self._info.achieve_mould_name)
    Text_act_share_tit:setContentSize(cc.size(root:getContentSize().width, Text_act_share_tit:getContentSize().height))

    -- 奖励
    ListView_act_share_reward:removeAllItems()

    local reward_info = zstring.split(self._info.achieve_reward, "|")
    for k, v in pairs(reward_info) do
        local info = zstring.split(v, ",")
        local prop_data = {}
        prop_data.prop_item = tonumber(info[1])
        prop_data.prop_type = tonumber(info[2])
        prop_data.item_value = tonumber(info[3])
        local cell = createPropIconCell(prop_data, true, true, true)
        ListView_act_share_reward:addChild(cell)
    end
    ListView_act_share_reward:requestRefreshView()

    -- 领取状态
    Button_act_share_rec:setVisible(false)
    Text_act_share_not:setVisible(true)
    Text_act_share_not:setString(activity_str_tip[8])
    if verifySupportLanguage(_lua_release_language_en) == true then
        Text_act_share_not:setString("")
    end

    local activity_info = _ED.activity_info[""..self._activity_type]
    local complete_info = zstring.split(self._info.achieve_complete_count, "/")
    if tonumber(self._info.achieve_state) == 2 then
        Text_act_share_not:setString(activity_str_tip[2])
    elseif tonumber(self._info.achieve_state) == 1 or tonumber(complete_info[1]) >= tonumber(complete_info[2]) then
        Button_act_share_rec:setVisible(true)
        Text_act_share_not:setVisible(false)
    end
end

function RedAlertTimeLeaderRecruitActivityCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.activity.act_share_cell_1, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeLeaderRecruitActivityCell.__size == nil then
        RedAlertTimeLeaderRecruitActivityCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"), nil, 
    {
        terminal_name = "red_alert_time_leader_recruit_activity_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()

end

function RedAlertTimeLeaderRecruitActivityCell:onEnterTransitionFinish()
    
end

function RedAlertTimeLeaderRecruitActivityCell:clearUIInfo( ... )
    local root = self.roots[1]  
    local Text_act_share_tit = ccui.Helper:seekWidgetByName(root,"Text_act_share_tit")
    local Text_act_share_progress_t = ccui.Helper:seekWidgetByName(root,"Text_act_share_progress_t")
    local Text_act_share_not = ccui.Helper:seekWidgetByName(root,"Text_act_share_not")
    local ListView_act_share_reward = ccui.Helper:seekWidgetByName(root,"ListView_act_share_reward")
    local Button_act_share_rec = ccui.Helper:seekWidgetByName(root,"Button_act_share_rec")

    if Text_act_share_tit ~= nil then
        Text_act_share_tit:setString("")
        Text_act_share_progress_t:setVisible(true)
        Text_act_share_not:setVisible(true)
        Text_act_share_not:setString(activity_str_tip[8])
        ListView_act_share_reward:removeAllItems()
        Button_act_share_rec:setVisible(false)
    end
end

function RedAlertTimeLeaderRecruitActivityCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeLeaderRecruitActivityCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_share_cell_1, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeLeaderRecruitActivityCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._activity_type = params[3]
    self._group = params[4]
    if self._index ~= nil and self._index <= 4 then
       self:onInit()
    end

    self:setContentSize(RedAlertTimeLeaderRecruitActivityCell.__size)
    return self
end

function RedAlertTimeLeaderRecruitActivityCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.activity.act_share_cell_1, self.roots[1])
end