--------------------------------------------------------------------------------------------------------------
--  说明：战力排行战斗力奖励cell
--------------------------------------------------------------------------------------------------------------
SmActivityCombatPowerRewardCell = class("SmActivityCombatPowerRewardCellClass", Window)
SmActivityCombatPowerRewardCell.__size = nil

--创建cell
local sm_activity_combat_power_reward_cell_terminal = {
    _name = "sm_activity_combat_power_reward_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityCombatPowerRewardCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_combat_power_reward_cell_terminal)
state_machine.init()

function SmActivityCombatPowerRewardCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize sm_activity_combat_power_reward_cell state machine.
    local function init_sm_activity_combat_power_reward_cell_terminal()
        local sm_activity_combat_power_reward_cell_check_terminal = {
            _name = "sm_activity_combat_power_reward_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.union.meeting.SmUnionPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 

                -- local cells = params._datas.cells
                -- local function responseShowUserInfoCallBack(response)
                --     if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                --         local datainfo = cells.activity
                --         state_machine.excute("sm_union_player_info_window_open", 0, datainfo)
                --     end
                -- end
                -- protocol_command.see_user_info.param_list = cells.activity.user_id
                -- NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_combat_power_reward_cell_check_terminal) 

        state_machine.init()
    end 
    -- call func sm_activity_combat_power_reward_cell create state machine.
    init_sm_activity_combat_power_reward_cell_terminal()

end

function SmActivityCombatPowerRewardCell:updateDrawInfo()
    local root = self.roots[1]
    --战斗力需求
    ccui.Helper:seekWidgetByName(root, "Image_fighting"):setVisible(true)
    local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
    Text_fighting_n:setString(self.activity.activityInfo_name)
    --列表
    local ListView_reward_1 = ccui.Helper:seekWidgetByName(root, "ListView_reward_1")
    ListView_reward_1:removeAllItems()
    if tonumber(self.activity.activityInfo_silver) ~= 0 then
        --金币
        local cell = ResourcesIconCell:createCell()
        cell:init(1, tonumber(self.activity.activityInfo_silver), -1,nil,nil,true,true,1)
        ListView_reward_1:addChild(cell)
    end
    if tonumber(self.activity.activityInfo_gold) ~= 0 then
        --钻石
        local cell = ResourcesIconCell:createCell()
        cell:init(2, tonumber(self.activity.activityInfo_gold), -1,nil,nil,true,true,1)
        ListView_reward_1:addChild(cell)
    end
    if tonumber(self.activity.activityInfo_food) ~= 0 then
        --体力
        local cell = ResourcesIconCell:createCell()
        cell:init(12, tonumber(self.activity.activityInfo_gold), -1,nil,nil,true,true,1)
        ListView_reward_1:addChild(cell)
    end
    if tonumber(self.activity.activityInfo_equip_count) ~= 0 then
        --装备
        local equip_data = self.activity.activityInfo_equip_info[1]
        local cell = ResourcesIconCell:createCell()
        cell:init(7, tonumber(equip_data.propMouldCount), equip_data.propMould,nil,nil,true,true,1)
        ListView_reward_1:addChild(cell)
    end
    if tonumber(self.activity.activityInfo_prop_count) ~= 0 then
        --道具
        for i, v in pairs(self.activity.activityInfo_prop_info) do
            local prop_data = v
            local cell = ResourcesIconCell:createCell()
            cell:init(6, tonumber(prop_data.propMouldCount), prop_data.propMould,nil,nil,true,true,1)
            ListView_reward_1:addChild(cell)
        end
    end
    if tonumber(self.activity.activityInfo_honour) ~= 0 then
        --声望
        local cell = ResourcesIconCell:createCell()
        cell:init(3, tonumber(self.activity.activityInfo_honour), -1,nil,nil,true,true,1)
        ListView_reward_1:addChild(cell)
    end

    local otherRewards = zstring.splits(self.activity.activityInfo_reward_select, "|", ",")
    if #otherRewards > 0 then
        for i, v in pairs(otherRewards) do
            -- 类型、ID、数量、星级
            if #v >= 3 then
                local cell = DrawHandle.drawIcon(v)
                ListView_reward_1:addChild(cell)
            end
        end
    end
    
    ListView_reward_1:requestRefreshView()
end

function SmActivityCombatPowerRewardCell:onUpdate(dt)
    
end

function SmActivityCombatPowerRewardCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/sm_fighting_up_tab_1_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if SmActivityCombatPowerRewardCell.__size == nil then
        SmActivityCombatPowerRewardCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_2"):getContentSize()
    end
    -- if tonumber(self.m_type) == 0 then
    -- 	--
        -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
        -- {
            -- terminal_name = "sm_activity_combat_power_reward_cell_check", 
            -- terminal_state = 0, 
            -- touch_black = true,
    		-- cells = self,
        -- }, nil, 1)
    -- end
    self:clearUIInfo()
	self:updateDrawInfo()
end

function SmActivityCombatPowerRewardCell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function SmActivityCombatPowerRewardCell:clearUIInfo( ... )
    local root = self.roots[1]
    local ListView_reward_1 = ccui.Helper:seekWidgetByName(root, "ListView_reward_1")
    local Image_rank_1 = ccui.Helper:seekWidgetByName(root, "Image_rank_1")
    local Image_rank_2 = ccui.Helper:seekWidgetByName(root, "Image_rank_2")
    local Image_rank_3 = ccui.Helper:seekWidgetByName(root, "Image_rank_3")
    local Text_rank = ccui.Helper:seekWidgetByName(root, "Text_rank")
    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    local Text_player_lv = ccui.Helper:seekWidgetByName(root, "Text_player_lv")
    local Text_player_fighting = ccui.Helper:seekWidgetByName(root, "Text_player_fighting")
    local Text_fighting_n = ccui.Helper:seekWidgetByName(root, "Text_fighting_n")
    local Image_fighting = ccui.Helper:seekWidgetByName(root, "Image_fighting")
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
    if ListView_reward_1 ~= nil then
        ListView_reward_1:removeAllItems()
        Image_rank_1:setVisible(false)
        Image_rank_2:setVisible(false)
        Image_rank_3:setVisible(false)
        Text_rank:setString("")
        Text_player_name:setString("")
        Text_player_lv:setString("")
        Text_player_fighting:setString("")
        Text_fighting_n:setString("")
        Image_fighting:setVisible(false)
        fwin:removeTouchEventListener(Panel_2)
    end
end

function SmActivityCombatPowerRewardCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityCombatPowerRewardCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_fighting_up_tab_1_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function SmActivityCombatPowerRewardCell:init(params)
    self.activity = params[1]
    self.index = params[2]
    if self.index <= 5 then
	   self:onInit()
    end
    self:setContentSize(SmActivityCombatPowerRewardCell.__size)
    return self
end

function SmActivityCombatPowerRewardCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_fighting_up_tab_1_list.csb", self.roots[1])
end