--------------------------------------------------------------------------------------------------------------
--  排行榜
--------------------------------------------------------------------------------------------------------------
Ranking = class("RankingClass", Window)

--打开界面
local ranking_window_open_terminal = {
	_name = "ranking_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(65) == true then
            return
        end 

        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("RankingClass") == nil then
                    fwin:open(Ranking:new():init(),fwin._ui)
                end
                state_machine.excute("main_window_hide", 0, "")
                state_machine.excute("player_resource_window_hide", 0, "")     
                state_machine.excute("home_button_for_action_window_hide",0,"")
                state_machine.excute("chat_view_window_hide",0,"")   
            end
        end
        protocol_command.order_get_info.param_list = ""
        NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, nil, responseCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local ranking_window_close_terminal = {
	_name = "ranking_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RankingClass"))

        if fwin:find("NationalWarMapClass") ~= nil then
            -- state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") == nil then
            if fwin:find("DuplicateMapClass") ~= nil then
                state_machine.excute("duplicate_map_window_show", 0, nil)
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
            else
                state_machine.excute("main_window_open",0,"")
                state_machine.excute("player_resource_window_show",0,"")   
                state_machine.excute("home_button_for_action_window_show",0,"")  
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("duplicate_title_window_show",0,"")
            end
        else
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("player_resource_window_hide", 0, "")
            state_machine.excute("duplicate_title_window_show",0,"")
        end     
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        
        -- clear cacher
        cacher.clearWindowCacher()
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(ranking_window_open_terminal)
state_machine.add(ranking_window_close_terminal)
state_machine.init()

function Ranking:ctor()
	self.super:ctor()
	self.roots = {}
   
    -- var
    --当前排行榜列表类型 1：战力，2：等级，3：侠客行，4：华山论剑，5：帮派
    self._list_type = 1
    --左侧列表
    self._list_view = nil 
    --左侧所有列表项
    self._big_cells = {}
    --右侧所有列表所在父层
    self._panel_listview = nil
    --右侧所有列表项 
    self._right_listview_tab = {}
    -- load lua file
    app.load("client.red_alert.cells.rank.ranking_left_cell_big")
    app.load("client.red_alert.cells.rank.ranking_left_cell_small")
    app.load("client.red_alert.cells.rank.ranking_right_cell")
    app.load("client.red_alert.cells.rank.ranking_right_top_cell")
    app.load("client.red_alert.cells.rank.ranking_union_member_cell")
    app.load("client.red_alert.rank.RankingListview")
    app.load("client.red_alert.rank.RankingSListview")
    app.load("client.red_alert.rank.RankingUnionMember")

	-- Initialize ranking state machine.
    local function init_ranking_terminal()
        --显示界面
        local ranking_window_show_terminal = {
            _name = "ranking_window_show",
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
        local ranking_window_hide_terminal = {
            _name = "ranking_window_hide",
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
        -- 左侧大cell取消所有选中
        local ranking_set_left_big_listview_unselect_terminal = {
            _name = "ranking_set_left_big_listview_unselect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setLeftBigListviewUnselect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        -- 切换列表
        local ranking_change_listview_page_terminal = {
            _name = "ranking_change_listview_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._list_type = params
                instance:changeListviewPage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

          -- 刷新列表
        local ranking_change_listview_refrush_terminal = {
            _name = "ranking_change_listview_refrush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:refrushListview()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(ranking_window_show_terminal)
        state_machine.add(ranking_window_hide_terminal)
        state_machine.add(ranking_set_left_big_listview_unselect_terminal)
        state_machine.add(ranking_change_listview_page_terminal)
        state_machine.add(ranking_change_listview_refrush_terminal)
        state_machine.init()
    end
    
    -- call func ranking create state machine.
    init_ranking_terminal()

end

function Ranking:onHide()
    self:setVisible(false)
end

function Ranking:onShow()
    self:setVisible(true)
end

function Ranking:refrushListview()
    local root = self.roots[1]
    self._list_view:requestRefreshView()
end

function Ranking:updateDraw()
    local root = self.roots[1]    
    for i,v in pairs(ranks_info_str) do
        local cell = state_machine.excute("ranking_left_big_create_cell",0,{i,v})
        self._list_view:addChild(cell)
        table.insert(self._big_cells,cell)
        if i == 1 then
            state_machine.excute("ranking_left_big_cell_click",0,{_datas = { cell = cell}})
        end
    end
end

function Ranking:changeListviewPage()
    local root = self.roots[1]

    -- 显示排行榜玩家列表
    for i,listview in pairs(self._right_listview_tab) do
        listview:setVisible(false)
    end
    if self._right_listview_tab[""..self._list_type] == nil then
        --
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    local listview = state_machine.excute("ranking_listview_window_open",0,{response.node._panel_listview, response.node._list_type})
                    response.node._right_listview_tab[""..response.node._list_type] = listview
                    response.node._right_listview_tab[""..response.node._list_type]:setVisible(true)   
                    response.node:updateRankInfo()
                end
            end
        end
        if self._list_type == 5 then                --请求帮派排行数据
            NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, self, responseCallback, false, nil)
        elseif self._list_type == 4 then            --请求华山论剑排行数据
            protocol_command.arena_order.param_list = "0"
            NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, self, responseCallback, false, nil)
        elseif self._list_type == 2 then            --请求等级排行数据
            protocol_command.get_user_level_rank_info.param_list = ""
            NetworkManager:register(protocol_command.get_user_level_rank_info.code, nil, nil, nil, self, responseCallback, false, nil)
        else
            local listview = state_machine.excute("ranking_listview_window_open",0,{self._panel_listview, self._list_type})
            self._right_listview_tab[""..self._list_type] = listview
            self._right_listview_tab[""..self._list_type]:setVisible(true)   
            self:updateRankInfo()
        end
    else
        self._right_listview_tab[""..self._list_type]:setVisible(true)   
        self:updateRankInfo()        
    end

end

function Ranking:updateRankInfo()
    local root = self.roots[1]
    -- 刷新当前排行榜信息
    local Text_tank_tit_2s = ccui.Helper:seekWidgetByName(root,"Text_tank_tit_2s")
    local Text_tank_tit_3 = ccui.Helper:seekWidgetByName(root,"Text_tank_tit_3")
    local Text_tank_tit_4 = ccui.Helper:seekWidgetByName(root,"Text_tank_tit_4")
    local Text_rank_me_1 = ccui.Helper:seekWidgetByName(root,"Text_rank_me_1")
    
    Text_tank_tit_2s:setString(tipStringInfo_rank_str[self._list_type][1])
    Text_tank_tit_3:setString(tipStringInfo_rank_str[self._list_type][2])
    Text_tank_tit_4:setString(tipStringInfo_rank_str[self._list_type][3])
    Text_rank_me_1:setString(tipStringInfo_rank_str[self._list_type][4])

    -- 显示玩家排行信息
    local Text_number = ccui.Helper:seekWidgetByName(root,"Text_rank_me_2")         -- 玩家战力等信息
    local Text_rank = ccui.Helper:seekWidgetByName(root,"Text_rank_me_4")           -- 玩家排名

    local rank = 0              --我的排名
    if self._list_type == 1 then        --战力
        Text_number:setString(_ED.user_info.fighter_capacity)
        rank = tonumber(_ED.fight_ranks.my_info.now_rank)
    elseif self._list_type == 2 then    --等级
        Text_number:setString(_ED.user_info.user_grade)
        rank = tonumber(_ED.level_rank.my_info.user_rank)   
    elseif self._list_type == 3 then        --侠客行
        Text_number:setString(_ED.trialtower_ranking_info.max_floor)
        rank = tonumber(_ED.trialtower_ranking_info.my_rank)   
    elseif self._list_type == 4 then        --华山论剑
        local arena_id = tonumber(_ED.city_rank.my_info.user_arena_id)
        local arena_name = dms.string(dms["arena_reward_param"], arena_id, arena_reward_param.arena_name)
        local arena_official = tonumber(_ED.city_rank.my_info.user_official)
        arena_name = zstring.split(arena_name,",")
        arena_name = arena_name[tonumber(_ED.user_info.user_force)]
        local name = red_alert_officer[arena_official]..arena_name

        Text_number:setString(name)
        rank = tonumber(_ED.city_rank.my_info.user_rank)             
    elseif self._list_type == 5 then        --帮派
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0
            then                            --没有帮派
            Text_number:setString(tipStringInfo_rank_str[7])
            Text_rank:setString(tipStringInfo_rank_str[8])
        else
            Text_number:setString(_ED.union.union_info.union_name)
            for i, v in pairs(_ED.union.rank_union_list_info) do
                if tonumber(_ED.union.union_info.union_id) == tonumber(v.union_id) then
                    rank = tonumber(v.union_rank)
                    break
                end
            end
        end
    end

    if rank ~= 0 then
        Text_rank:setString(rank)
    else
        Text_rank:setString(tipStringInfo_rank_str[8])
    end
end

function Ranking:setLeftBigListviewUnselect()
    for i,big_cell in pairs(self._big_cells) do
        big_cell._select = false
        big_cell:setSelected()
    end
end

function Ranking:onUpdate(dt)
    
end

function Ranking:onInit()
    local csbItem = csb.createNode(config_csb.rank.ranking)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    --阵营背景
    local Panel_camp_bg = ccui.Helper:seekWidgetByName(root,"Panel_camp_bg")
    Panel_camp_bg:setBackGroundImage("images/ui/bg/shared_bg_".._ED.user_info.user_force..".png")
    
    local ListView_ranking_left = ccui.Helper:seekWidgetByName(root,"ListView_ranking_left")
    self._panel_listview = ccui.Helper:seekWidgetByName(root,"Panel_listview_right")
    self._list_view = ListView_ranking_left
    --关闭 -- 返回主页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ranking_close"), nil, 
    {
        terminal_name = "ranking_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    self:updateDraw()
end

function Ranking:onEnterTransitionFinish()
    
end

function Ranking:init()
	self:onInit()
    return self
end

function Ranking:onExit()
    state_machine.remove("ranking_set_left_big_listview_unselect")
    state_machine.remove("ranking_change_listview_page")
    state_machine.remove("ranking_change_listview_refrush")
    state_machine.remove("ranking_window_show")
    state_machine.remove("ranking_window_hide")
end