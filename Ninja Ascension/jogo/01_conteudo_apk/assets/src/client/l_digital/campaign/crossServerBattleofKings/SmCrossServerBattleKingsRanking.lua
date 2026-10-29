-----------------------------
--跨服王者之战排行
-----------------------------
SmCrossServerBattleKingsRanking = class("SmRankKingOfTheWarClass", Window)
SmCrossServerBattleKingsRanking.__size = nil

local sm_cross_server_rank_king_of_the_war_open_terminal = {
    _name = "sm_cross_server_rank_king_of_the_war_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local panel = SmCrossServerBattleKingsRanking:new():init(params)
		fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cross_server_rank_king_of_the_war_open_terminal)
state_machine.init()

function SmCrossServerBattleKingsRanking:ctor()
    self.super:ctor()
    self.roots = {}
    self.starting_point = 1
    self.end_point = 10
    self.isOver = false

    app.load("client.l_digital.cells.activity.wonderful.sm_activity_all_ranking_information_cell")
    local function init_sm_cross_server_rank_king_of_the_war_terminal()
		--显示界面
		local sm_cross_server_rank_king_of_the_war_show_terminal = {
            _name = "sm_cross_server_rank_king_of_the_war_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--隐藏界面
		local sm_cross_server_rank_king_of_the_war_hide_terminal = {
            _name = "sm_cross_server_rank_king_of_the_war_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }	

        local sm_cross_server_rank_king_of_the_war_open_rank_terminal = {
            _name = "sm_cross_server_rank_king_of_the_war_open_rank",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if not _ED.cross_server_battle_kings_score_rank or #_ED.cross_server_battle_kings_score_rank.other_user == 0 then
                    return false
                end
                if self.isOver == false then
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            instance.starting_point = instance.starting_point+10
                            instance.end_point = instance.end_point+10
                            instance:addnewlistCell()
                        end
                    end
                    local energyData = zstring.split(dms.string(dms["user_config"], 8, user_config.param), ",")
                    if tonumber(energyData[6]) <= instance.end_point then
                        instance.isOver = true
                        return
                    end
                    protocol_command.the_kings_battle_self_battle_rank.param_list = "1".."\r\n"..(instance.end_point+10)
                    NetworkManager:register(protocol_command.the_kings_battle_self_battle_rank.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(sm_cross_server_rank_king_of_the_war_show_terminal)	
        state_machine.add(sm_cross_server_rank_king_of_the_war_hide_terminal)
		state_machine.add(sm_cross_server_rank_king_of_the_war_open_rank_terminal)

        state_machine.init()
    end
    init_sm_cross_server_rank_king_of_the_war_terminal()
end

function SmCrossServerBattleKingsRanking:onHide()
    self:setVisible(false)
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self:stopAllActions()
end

function SmCrossServerBattleKingsRanking:onShow()
    self:setVisible(true)
    self:onUpdateDraw()
end

function SmCrossServerBattleKingsRanking:addnewlistCell()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    for i= self.starting_point,self.end_point do
        if _ED.cross_server_battle_kings_score_rank and _ED.cross_server_battle_kings_score_rank.other_user[i] ~= nil then
            local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{_ED.cross_server_battle_kings_score_rank.other_user[i],10})
            ListView_phb:addChild(cell)
        else
            self.isOver = true
        end
    end
    ListView_phb:requestRefreshView()
end

function SmCrossServerBattleKingsRanking:onUpdateDraw()
    local root = self.roots[1]
    local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
    ListView_phb:removeAllItems()
    self.starting_point = 1
    self.end_point = 10
    self.isOver = false
    if nil == _ED.cross_server_battle_kings_score_rank or #_ED.cross_server_battle_kings_score_rank.other_user == 0 then
        for i = 1, 3 do 
            local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{{user_rank = i,},10})
            ListView_phb:addChild(cell)
        end
    else
        for i, v in ipairs(_ED.cross_server_battle_kings_score_rank.other_user) do 
            local cell = state_machine.excute("sm_activity_all_ranking_information_cell",0,{v,10})
            ListView_phb:addChild(cell)
        end
    end
    ListView_phb:requestRefreshView()

    local function scrollViewEvent(sender, evenType)
        if evenType == ccui.ScrollviewEventType.bounceBottom then--6
            --滑到头
            state_machine.excute("sm_cross_server_rank_king_of_the_war_open_rank", 0, nil)
        end
    end
    ListView_phb:addScrollViewEventListener(scrollViewEvent)
end

function SmCrossServerBattleKingsRanking:onUpdate(dt)
    
end

function SmCrossServerBattleKingsRanking:onEnterTransitionFinish()

end

function SmCrossServerBattleKingsRanking:onInit( )
    local csbItem = csb.createNode("system/sm_ranking_listview.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    -- DSC重塑
    if __lua_project_id == __lua_project_l_digital then
        root:setContentSize(self._rootWindows:getContentSize())
        local ListView_phb = ccui.Helper:seekWidgetByName(root, "ListView_phb")
        ListView_phb:setContentSize(self._rootWindows:getContentSize())
    end
    if SmCrossServerBattleKingsRanking.__size == nil then
        SmCrossServerBattleKingsRanking.__size = root:getContentSize()
    end
    self:setContentSize(SmCrossServerBattleKingsRanking.__size)

    self:onUpdateDraw()
end

function SmCrossServerBattleKingsRanking:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
	self:onInit()
    return self
end

function SmCrossServerBattleKingsRanking:onExit()
    state_machine.remove("sm_cross_server_rank_king_of_the_war_show")    
    state_machine.remove("sm_cross_server_rank_king_of_the_war_hide")
end
