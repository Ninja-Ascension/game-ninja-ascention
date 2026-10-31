--------------------------------------------------------------------------------------------------------------
--  说明：跨服排行奖励cell
--------------------------------------------------------------------------------------------------------------
Recharge_ranking_information_cell = class("Recharge_ranking_information_cellClass", Window)
Recharge_ranking_information_cell.__size = nil

--创建cell
local sm_activity_recharge_reward_cell_terminal = {
    _name = "sm_activity_recharge_reward_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = Recharge_ranking_information_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_recharge_reward_cell_terminal)
state_machine.init()

function Recharge_ranking_information_cell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize sm_activity_combat_power_reward_cell state machine.
    local function init_sm_activity_recharge_reward_cell_terminal()
        local sm_activity_recharge_reward_cell_check_terminal = {
            _name = "sm_activity_recharge_reward_cell_check",
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

        state_machine.add(sm_activity_recharge_reward_cell_check_terminal) 

        state_machine.init()
    end 
    -- call func sm_activity_combat_power_reward_cell create state machine.
    init_sm_activity_recharge_reward_cell_terminal()

end

function Recharge_ranking_information_cell:updateDrawInfo()
    local root = self.roots[1]
  
    local Text_loke_on_st = ccui.Helper:seekWidgetByName(root, "Text_loke_on_st")
    local temp = zstring.split(self.activity.rankValue,",")  
   
    if tonumber(temp[1])== 0 or tonumber(temp[1]) == tonumber(temp[2]) then
        Text_loke_on_st:setString(tipStringInfo_pokemon_recharge_rank_tips[1]..temp[2]..tipStringInfo_pokemon_recharge_rank_tips[3])
    else
        Text_loke_on_st:setString(tipStringInfo_pokemon_recharge_rank_tips[1]..temp[1]..tipStringInfo_pokemon_recharge_rank_tips[2]..temp[2]..tipStringInfo_pokemon_recharge_rank_tips[3])
    end
    local Text_loke_on = ccui.Helper:seekWidgetByName(root, "Text_loke_on")
    Text_loke_on:setString(string.format(tipStringInfo_pokemon_recharge_rank_tips[4], temp[3]))

    
    --列表
    local ListView_reward_1 = ccui.Helper:seekWidgetByName(root, "ListView_loke_on_role")
    ListView_reward_1:removeAllItems()

   -- debug.print_r(self.activity)
    -- -- 奖励
    local rewards = zstring.splits(self.activity.reward, "|", ",")

    -- debug.print_r(rewards)
  --  print("输出奖励updateDrawInfo")
    local activity_count = tonumber(#rewards)
    for i, reward in ipairs(rewards) do
        local rewardType = zstring.tonumber(reward[1])
        local cell = ResourcesIconCell:createCell()
        if 13 == rewardType then
            local table = {}
            if reward[4] ~= nil and tonumber(reward[4]) ~= -1 then
                table.shipStar = tonumber(reward[4])
            end
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1,table)
        else
            cell:init(rewardType, tonumber(reward[3]), tonumber(reward[2]),nil,nil,true,true,1)
        end
     ListView_reward_1:addChild(cell)
    end

    ListView_reward_1:requestRefreshView()
end

function Recharge_ranking_information_cell:onUpdate(dt)
    
end

function Recharge_ranking_information_cell:onInit()
    local root = cacher.createUIRef("activity/wonderful/recharge_ranking_tab.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if Recharge_ranking_information_cell.__size == nil then
        Recharge_ranking_information_cell.__size = ccui.Helper:seekWidgetByName(root, "Panel_lock_on_list"):getContentSize()
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

function Recharge_ranking_information_cell:onEnterTransitionFinish()
    local root = self.roots[1]
   
end

function Recharge_ranking_information_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Panel_loke_on_role = ccui.Helper:seekWidgetByName(root, "ListView_loke_on_role")
    local Text_loke_on_st = ccui.Helper:seekWidgetByName(root, "Text_loke_on_st")
    local Text_loke_on = ccui.Helper:seekWidgetByName(root, "Text_loke_on")
  
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_lock_on_list")
    if Panel_loke_on_role ~= nil then
        Panel_loke_on_role:removeAllItems()
        Text_loke_on_st:setString("")
        Text_loke_on:setString("")
        
        fwin:removeTouchEventListener(Panel_2)
    end
end

function Recharge_ranking_information_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function Recharge_ranking_information_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/recharge_ranking_tab.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function Recharge_ranking_information_cell:init(params)
    self.activity = params[1]
    -- debug.print_r(self.activity)
    -- print("排行奖励")
    self.index =  params[2]
  --  if self.index <= 5 then
	   self:onInit()
 --   end
    self:setContentSize(Recharge_ranking_information_cell.__size)
    return self
end

function Recharge_ranking_information_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/recharge_ranking_tab.csb", self.roots[1])
end