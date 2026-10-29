----------------------------------------------------------------------------------------------------
-- 说明：限时优惠全民福利
----------------------------------------------------------------------------------------------------
ActivityLimitPeopleWealListCell = class("ActivityLimitPeopleWealListCellClass", Window)

function ActivityLimitPeopleWealListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._wealData = nil
    self._propIndex = 0
    app.load("client.cells.utils.resources_icon_cell")
    local function init_activity_limit_recharge_icon_cell_terminal()
        --领奖
        local activity_limit_people_weal_lis_cell_get_reward_terminal = {
            _name = "activity_limit_people_weal_lis_cell_get_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= ni and response.node.roots ~= nil then 
                            response.node:onRefreshDraw()
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(67)
                            fwin:open(getRewardWnd, fwin._windows)
                        end
                    end
                end
                local cell = params._datas.cell
                protocol_command.limited_recharge_get_reward.param_list = ""..cell._propIndex
                NetworkManager:register(protocol_command.limited_recharge_get_reward.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_limit_people_weal_lis_cell_get_reward_terminal)
        state_machine.init()
    end
    init_activity_limit_recharge_icon_cell_terminal()
end

function ActivityLimitPeopleWealListCell:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local items = zstring.split(dms.atos(self._wealData,limited_welfare.reward_info),",")
    self._propIndex = dms.atoi(self._wealData,limited_welfare.id)
    rewardIcon = ResourcesIconCell:createCell()      
    rewardIcon:init(items[1], items[3], items[2])
    local propPanel = ccui.Helper:seekWidgetByName(root, "Panel_kfjj_03")
    propPanel:removeAllChildren(true)
    propPanel:addChild(rewardIcon)
    ccui.Helper:seekWidgetByName(root, "Text_kfjj_01"):setString(dms.atos(self._wealData,limited_welfare.reward_name))
    local infoString = string.format(_activity_new_tip_string_info[4],dms.atoi(self._wealData,limited_welfare.limit_person))
    ccui.Helper:seekWidgetByName(root, "Text_kf_2"):setString(infoString)
    self:onRefreshDraw()
end

function ActivityLimitPeopleWealListCell:onRefreshDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local counts = dms.atoi(self._wealData,limited_welfare.limit_person)
    local buyButton = ccui.Helper:seekWidgetByName(root, "Button_kf_01")
    local getImage = ccui.Helper:seekWidgetByName(root, "Image_3")
    local buyCounts = _ED.limit_recharege_info.buy_player_counts
    local states = zstring.split(_ED.limit_recharege_info.get_reward_states,",")
    if buyCounts >= counts and zstring.tonumber(states[self._propIndex]) == 0 then 
        buyButton:setTouchEnabled(true)
        buyButton:setBright(true)
    else
        buyButton:setTouchEnabled(false)
        if zstring.tonumber(states[self._propIndex]) == 1 then 
            buyButton:setVisible(false)
            getImage:setVisible(true)
        else
            buyButton:setVisible(true)
            buyButton:setBright(false)
        end 
    end
end

function ActivityLimitPeopleWealListCell:initDraw()
    local csbActivityLimitPeopleWealListCell= nil

    csbActivityLimitPeopleWealListCell= csb.createNode("activity/wonderful/limited_time_discount_list_3.csb")
  
    local root = csbActivityLimitPeopleWealListCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
    table.insert(self.roots, root)

    local action = csb.createTimeline("activity/wonderful/limited_time_discount_list_3.csb")
    root:runAction(action)
    action:play("list_view_cell_open", false)

    local Panel_kfjj_list = ccui.Helper:seekWidgetByName(root, "Panel_kfjj_list")
    self:setContentSize(Panel_kfjj_list:getContentSize())

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_kf_01"),       nil, 
    {
        terminal_name = "activity_limit_people_weal_lis_cell_get_reward",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)
end

function ActivityLimitPeopleWealListCell:onEnterTransitionFinish()
    if self.roots[1] ~= nil then
        self:onUpdateDraw()
    end
end

function ActivityLimitPeopleWealListCell:onExit()

end

function ActivityLimitPeopleWealListCell:init(data,listView)
    self._wealData = data
    self:initDraw()
    return self
end

function ActivityLimitPeopleWealListCell:createCell()
    local cell = ActivityLimitPeopleWealListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
