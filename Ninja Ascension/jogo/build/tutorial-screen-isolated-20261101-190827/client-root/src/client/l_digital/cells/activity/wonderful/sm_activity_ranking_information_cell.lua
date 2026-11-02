--------------------------------------------------------------------------------------------------------------
--  说明：战力排行活动排行cell
--------------------------------------------------------------------------------------------------------------
SmActivityRankingInformationCell = class("SmActivityRankingInformationCellClass", Window)
SmActivityRankingInformationCell.__size = nil

--创建cell
local sm_activity_ranking_information_cell_terminal = {
    _name = "sm_activity_ranking_information_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = SmActivityRankingInformationCell:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        cell:registerOnNoteUpdate(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_activity_ranking_information_cell_terminal)
state_machine.init()

function SmActivityRankingInformationCell:ctor()
	self.super:ctor()
	self.roots = {}
    app.load("client.cells.utils.resources_icon_cell")
	 -- Initialize sm_activity_ranking_information_cell state machine.
    local function init_sm_activity_ranking_information_cell_terminal()
        local sm_activity_ranking_information_cell_check_terminal = {
            _name = "sm_activity_ranking_information_cell_check",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.arena.ArenaPlayerInfoWindow")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cells = params._datas.cells
                local function responseShowUserInfoCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        local datainfo = cells.activity
                        datainfo.icon = cells.activity.user_head
                        datainfo.name = cells.activity.user_name
                        datainfo.level = cells.activity.user_level
                        datainfo.rank = cells.activity.order_value
                        datainfo.force = cells.activity.user_fighting
                        datainfo.vip = cells.activity.vip_grade
                        datainfo.template = {}
                        datainfo.template[1] = _ED.chat_user_info.formation
                        datainfo.arame = "?"
                        state_machine.excute("sm_arena_player_info_window_open",0,datainfo)
                    end
                end
                protocol_command.see_user_info.param_list = cells.activity.user_id
                NetworkManager:register(protocol_command.see_user_info.code, nil, nil, nil, cells, responseShowUserInfoCallBack, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_activity_ranking_information_cell_check_terminal) 

        state_machine.init()
    end 
    -- call func sm_activity_ranking_information_cell create state machine.
    init_sm_activity_ranking_information_cell_terminal()

end

function SmActivityRankingInformationCell:updateDraw()
    local root = self.roots[1]
    for i=1,3 do
        ccui.Helper:seekWidgetByName(root, "Image_rank_"..i):setVisible(false)
    end
    if tonumber(self.activity.order) <=3 then
        ccui.Helper:seekWidgetByName(root, "Image_rank_"..self.activity.order):setVisible(true)
        ccui.Helper:seekWidgetByName(root, "Text_rank"):setString("")
    else
        ccui.Helper:seekWidgetByName(root, "Text_rank"):setString(self.activity.order)
    end

    local Text_player_name = ccui.Helper:seekWidgetByName(root, "Text_player_name")
    Text_player_name:setString(self.activity.user_name)
    local Text_player_lv = ccui.Helper:seekWidgetByName(root, "Text_player_lv")
    Text_player_lv:setString(self.activity.user_level)
    local Text_player_fighting = ccui.Helper:seekWidgetByName(root, "Text_player_fighting")
    Text_player_fighting:setString(self.activity.user_fighting)
    
end

function SmActivityRankingInformationCell:onUpdate(dt)
    
end

function SmActivityRankingInformationCell:onInit()
    local root = cacher.createUIRef("activity/wonderful/sm_fighting_up_tab_1_list.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)
    
    if SmActivityRankingInformationCell.__size == nil then
        SmActivityRankingInformationCell.__size = ccui.Helper:seekWidgetByName(root, "Panel_2"):getContentSize()
    end
    self:clearUIInfo()
    -- if tonumber(self.m_type) == 0 then
    -- 	--
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_2"), nil, 
        {
            terminal_name = "sm_activity_ranking_information_cell_check", 
            terminal_state = 0, 
            touch_black = true,
    		cells = self,
        }, nil, 1)
    -- end

	self:updateDraw()
end

function SmActivityRankingInformationCell:onEnterTransitionFinish()

end

function SmActivityRankingInformationCell:clearUIInfo( ... )
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

function SmActivityRankingInformationCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:registerOnNoteUpdate(self)
    self:onInit()
end

function SmActivityRankingInformationCell:unload()
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

function SmActivityRankingInformationCell:init(params)
    self.activity = params[1]
    self.index = params[2]
    if self.index <= 5 then
	   self:onInit()
    end
    self:setContentSize(SmActivityRankingInformationCell.__size)
    return self
end

function SmActivityRankingInformationCell:onExit()
	self:clearUIInfo()
    cacher.freeRef("activity/wonderful/sm_fighting_up_tab_1_list.csb", self.roots[1])
end