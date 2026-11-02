----------------------------------------------------------------------------------------------------
-- 说明：邀请好友列表
----------------------------------------------------------------------------------------------------
ActivityInviteFriendListCell = class("ActivityInviteFriendListCellClass", Window)

function ActivityInviteFriendListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self._inviteData = nil
    app.load("client.cells.equip.equip_icon_cell")
    app.load("client.cells.prop.prop_icon_cell")
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.prop.prop_money_icon")

    local function init_activity_invite_friend_list_cell_terminal()
        --领奖
        local activity_invite_friend_list_cell_recive_terminal = {
            _name = "activity_invite_friend_list_cell_recive",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseDrawWeekRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        response.node:isDrawedUpdateDraw()
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(47)
                        fwin:open(getRewardWnd, fwin._ui)
                    end
                end
                local cell = params._datas.cell
                protocol_command.draw_week_reward.param_list = ""..cell.command_param_list
                NetworkManager:register(protocol_command.draw_week_reward.code, nil, nil, nil, cell, responseDrawWeekRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_invite_friend_list_cell_recive_terminal)
        state_machine.init()
    end
    init_activity_invite_friend_list_cell_terminal()
end

function ActivityInviteFriendListCell:drawReward(reward)
    local rewardType = zstring.tonumber(reward[1])
    local rewardIcon = nil
    if rewardType == 6 then     --道具
        rewardIcon = PropIconCell:createCell()
        -- rewardIcon:init(16, reward[2], reward[3])
        rewardIcon:init(24, tostring(reward[2]), reward[3])
    elseif rewardType == 7 then     --装备
        rewardIcon = EquipIconCell:createCell()
        -- rewardIcon:init(8, nil, reward[2], nil)
        rewardIcon:init(10, nil, reward[2], nil)
    else
        if rewardType == 1 then
            rewardIcon = propMoneyIcon:createCell()
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._fundName)
        elseif rewardType == 2 then
            rewardIcon = propMoneyIcon:createCell()
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._crystalName)
		elseif rewardType == 3 then
            rewardIcon = propMoneyIcon:createCell()
            rewardIcon:init(""..6, reward[3], _All_tip_string_info._glories)
        elseif rewardType == 5 then
            rewardIcon = propMoneyIcon:createCell()
            rewardIcon:init(""..rewardType, reward[3], _All_tip_string_info._soulName)
        else
            rewardIcon = ResourcesIconCell:createCell()      
            rewardIcon:init(rewardType, -1, -1)
        end
    end
 
    return rewardIcon
end

function ActivityInviteFriendListCell:onUpdateDraw()
   local root = self.roots[1]

end

function ActivityInviteFriendListCell:initDraw()
    local csbActivityInviteFriendListCell= nil

    csbActivityInviteFriendListCell= csb.createNode("activity/wonderful/invite_friend_list.csb")
  
    local root = csbActivityInviteFriendListCell:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
    table.insert(self.roots, root)

    self:setContentSize(root:getContentSize())

    -- 绘制奖励信息
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_11")
    listView:setSwallowTouches(false)
    
    listView:removeAllItems()
    -- for i, v in pairs(rewards) do
    --     local reward = zstring.split(v, ",")
    --     listView:addChild(self:drawReward(reward))
    -- end
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_recive"),       nil, 
    {
        terminal_name = "activity_invite_friend_list_cell_recive",      
        terminal_state = 0, 
        cell = self,
        isPressedActionEnabled = true
    }, 
    nil, 0):setSwallowTouches(false)
    self:onUpdateDraw()
end

function ActivityInviteFriendListCell:onEnterTransitionFinish()
    if self.roots[1] ~= nil then
        self:onUpdateDraw()
    end
end

function ActivityInviteFriendListCell:onExit()

end

function ActivityInviteFriendListCell:init(inviteData,listView)
    self._inviteData = inviteData
    self.listView = listView
    self:initDraw()
    return self
end

function ActivityInviteFriendListCell:createCell()
    local cell = ActivityInviteFriendListCell:new()
    cell:registerOnNodeEvent(cell)
    return cell
end
