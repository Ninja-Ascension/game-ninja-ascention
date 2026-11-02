--------------------------------------------------------------------------------------------------------------
--  说明：跨服排行榜cell
--------------------------------------------------------------------------------------------------------------
Recharge_ranking_cell = class("Recharge_ranking_cellClass", Window)
Recharge_ranking_cell.__size = nil

--创建cell
local sm_activity_recharge_cell_terminal = {
    _name = "sm_activity_recharge_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = Recharge_ranking_cell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_recharge_cell_terminal)
state_machine.init()

function Recharge_ranking_cell:ctor()
	self.super:ctor()
	self.roots = {}
 --   app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize sm_activity_combat_power_reward_cell state machine.
    local function init_sm_activity_recharge_cell_terminal()
        local sm_activity_recharge_cell_check_terminal = {
            _name = "sm_activity_recharge_cell_check",
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

        state_machine.add(sm_activity_recharge_cell_check_terminal) 

        state_machine.init()
    end 
    -- call func sm_activity_combat_power_reward_cell create state machine.
    init_sm_activity_recharge_cell_terminal()

end

function Recharge_ranking_cell:updateDrawInfo()
    local root = self.roots[1]
  
    local Text_loke_on_st = ccui.Helper:seekWidgetByName(root, "Text_loke_on_st")
    Text_loke_on_st:setString(self.activity.rank)
    
    local Text_loke_on_0 = ccui.Helper:seekWidgetByName(root, "Text_loke_on_0")   --name
    Text_loke_on_0:setString(self.activity.info.nickname)

    local Text_loke_on = ccui.Helper:seekWidgetByName(root, "Text_loke_on")   --区服
    local str =  self.activity.info.serverNum
    str = tostring(str)
    -- Pestana del ranking antes de la respuesta del S2C 13037.
    local reward = _ED.recharge_ranking_reward or {}
    Text_loke_on:setString((reward.serverNameInfo or {})[str] or "")

    local Text_loke_on_1 = ccui.Helper:seekWidgetByName(root, "Text_loke_on_1")   --积分
    Text_loke_on_1:setString(self.activity.info.score)
   
                       
    -- --列表
    -- local ListView_reward_1 = ccui.Helper:seekWidgetByName(root, "ListView_loke_on_role")
    -- ListView_reward_1:removeAllItems()

    -- ListView_reward_1:requestRefreshView()
end

function Recharge_ranking_cell:onUpdate(dt)
    
end

function Recharge_ranking_cell:onInit()
    local root = cacher.createUIRef("activity/wonderful/recharge_ranking_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if Recharge_ranking_cell.__size == nil then
        Recharge_ranking_cell.__size = ccui.Helper:seekWidgetByName(root, "Panel_lock_on_list"):getContentSize()
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

function Recharge_ranking_cell:onEnterTransitionFinish()
    local root = self.roots[1]
end

function Recharge_ranking_cell:clearUIInfo( ... )
    local root = self.roots[1]
    local Text_loke_on_st = ccui.Helper:seekWidgetByName(root, "Text_loke_on_st")
    local Text_loke_on = ccui.Helper:seekWidgetByName(root, "Text_loke_on")
    local Text_loke_on_0 = ccui.Helper:seekWidgetByName(root, "Text_loke_on_0")
    local Text_loke_on_1 = ccui.Helper:seekWidgetByName(root, "Text_loke_on_1")
    
    
  
    local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_lock_on_list")
    if Panel_loke_on_role ~= nil then
        Panel_loke_on_role:removeAllItems()
        Text_loke_on_st:setString("")
        Text_loke_on:setString("")
        Text_loke_on_1:setString("")
        
        fwin:removeTouchEventListener(Panel_2)
    end
end

function Recharge_ranking_cell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function Recharge_ranking_cell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/recharge_ranking_list.csb", root)
    root:stopAllActions()
    self:unregisterOnNoteUpdate(self)
    root:removeFromParent(false)
    self.roots = {}
end

function Recharge_ranking_cell:init(params)
     self.activity = params[1]
     --self.index =  params[2]
    
  
  --  if self.index <= 5 then
	   self:onInit()
 --   end
    self:setContentSize(Recharge_ranking_cell.__size)
    return self
end

function Recharge_ranking_cell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/recharge_ranking_list.csb", self.roots[1])
end