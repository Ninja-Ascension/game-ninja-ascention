--------------------------------------------------------------------------------------------------------------
--  说明：排行榜活动cell
--------------------------------------------------------------------------------------------------------------
RedAlertTimeVipGiftCell = class("RedAlertTimeVipGiftCellClass", Window)
RedAlertTimeVipGiftCell.__size = nil

--创建cell
local red_alert_time_vip_gift_cell_create_terminal = {
    _name = "red_alert_time_vip_gift_cell_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = RedAlertTimeVipGiftCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(red_alert_time_vip_gift_cell_create_terminal)
state_machine.init()

function RedAlertTimeVipGiftCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._index = 0
    self._info = nil
    self._activity_type = 0
    self._group = 0
    self._can_receive = false
     -- Initialize red_alert_time_act_share_cell state machine.
     
    local function init_red_alert_time_vip_gift_cell_terminal()
        local red_alert_time_vip_gift_cell_receive_award_terminal = {
            _name = "red_alert_time_vip_gift_cell_receive_award",
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
                        state_machine.excute("red_alert_time_vip_gift_update_draw", 0, "")
                    end
                end     
                protocol_command.draw_activity_reward.param_list = activity_info.activity_id .. "\r\n"..activity_info.activity_type.."\r\n"..(tonumber(cell._group)-1).."\r\n"..(tonumber(cell._info.achieve_index)-1)
                NetworkManager:register(protocol_command.draw_activity_reward.code, nil, nil, nil, cell, responseCallback, false, nil)  
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_vip_gift_cell_update_info_terminal = {
            _name = "red_alert_time_vip_gift_cell_update_info",
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
                cell._can_receive = params.can_receive
                if cell._info ~= nil then
                    if cell._index <= 5 then
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

        state_machine.add(red_alert_time_vip_gift_cell_receive_award_terminal)
        state_machine.add(red_alert_time_vip_gift_cell_update_info_terminal)
        state_machine.init()
    end 
    -- call func red_alert_time_act_share_cell create state machine.
    init_red_alert_time_vip_gift_cell_terminal()

end

function RedAlertTimeVipGiftCell:updateDraw()
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

    if tonumber(self._info.achieve_state) == 2 then
        Text_act_share_not:setString(activity_str_tip[2])
    elseif tonumber(self._info.achieve_state) == 1 then
        Button_act_share_rec:setVisible(true)
        Text_act_share_not:setVisible(false)
    end
end

function RedAlertTimeVipGiftCell:onInit()
    local root = cacher.createUIRef(config_csb.cells.shop.vip_privilege_walfare_cell, "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if RedAlertTimeVipGiftCell.__size == nil then
        RedAlertTimeVipGiftCell.__size = root:getContentSize()
    end

    --领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_act_share_rec"), nil, 
    {
        terminal_name = "red_alert_time_vip_gift_cell_receive_award", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        cells = self
    }, nil, 1)

    self:updateDraw()

end

function RedAlertTimeVipGiftCell:onEnterTransitionFinish()
    
end

function RedAlertTimeVipGiftCell:clearUIInfo( ... )
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

function RedAlertTimeVipGiftCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function RedAlertTimeVipGiftCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.shop.vip_privilege_walfare_cell, root)
    root:removeFromParent(false)
    self.roots = {}
end

function RedAlertTimeVipGiftCell:init(params)
    self._index = params[1]
    self._info = params[2]
    self._activity_type = params[3]
    self._group = params[4]
    self._can_receive = params[5]
    if self._index ~= nil and self._index <= 5 then
       self:onInit()
    end

    self:setContentSize(RedAlertTimeVipGiftCell.__size)
    return self
end

function RedAlertTimeVipGiftCell:onExit()
    self:clearUIInfo()
    cacher.freeRef(config_csb.cells.shop.vip_privilege_walfare_cell, self.roots[1])
end