-- ------------------------------------------------------------------------------------------------------------
--  排行榜
-- ------------------------------------------------------------------------------------------------------------
Rank = class("RankClass", Window)

--打开界面
local rank_window_open_terminal = {
	_name = "rank_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(240) == true then
            return
        end 
        state_machine.lock("rank_window_open")
        if fwin:find("RankClass") == nil then
            local list_type = params._datas.list_type
            local function responseCallback( response )
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    fwin:open(Rank:new():init(list_type), fwin._ui)
                    state_machine.unlock("rank_window_open")
                end
            end
            if list_type == 1                     --请求战力排行榜 
                or list_type == 2                 --请求关卡排行榜 
                or list_type == 3 then            --请求军功排行榜 
                protocol_command.order_get_info.param_list = ""..(list_type - 1).. "\r\n" .."1".. "\r\n" .."20"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, nil, responseCallback, false, nil)
            elseif list_type == 4                 
                and _ED.union.rank_union_list_info == nil then             --请求军团排行数据  
                protocol_command.union_order.param_list = "1".. "\r\n" .."20".."\r\n0"
                NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, nil, responseCallback, false, nil)
            elseif list_type == 5
                and (_ED.city_rank == nil or _ED.city_rank.other_user == nil or _ED.city_rank.other_user[1] == nil) then    --请求战地排行数据 
                -- 清除战地排行数据 
                if _ED.city_rank ~= nil and _ED.city_rank.other_user ~= nil then
                    _ED.city_rank.other_user[1] = {}
                end  
                protocol_command.arena_order.param_list = "0".. "\r\n" .."1".. "\r\n" .."20"
                NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, nil, responseCallback, false, nil)
            elseif list_type == 6                 
                and _ED.answer_rank_list_info == nil then                   --请求学霸排行数据  
                protocol_command.answer_init.param_list = ""
                NetworkManager:register(protocol_command.answer_init.code, nil, nil, nil, nil, responseCallback, false, nil)
            elseif list_type == 7                 
                and _ED.user_rebel_haunt_total_rank_info == nil then                   --请求叛军总排行数据  
                protocol_command.rebel_haunt_rank_list_get.param_list = "1".. "\r\n" .."1".. "\r\n" .."20"
                NetworkManager:register(protocol_command.rebel_haunt_rank_list_get.code, nil, nil, nil, nil, responseCallback, false, nil)
            elseif list_type == 8                                     --请求敌军来袭伤害排行数据  
                and (_ED.user_enemy_strike_rank_info == nil or _ED.user_enemy_strike_rank_info.rank_hurt_list == nil) then
                protocol_command.enemy_boss_rank_list_get.param_list = "0"
                NetworkManager:register(protocol_command.enemy_boss_rank_list_get.code, nil, nil, nil, nil, responseCallback, false, nil)
            elseif list_type == 9                                     --请求敌军来袭次数排行数据  
                and (_ED.user_enemy_strike_rank_info == nil or _ED.user_enemy_strike_rank_info.rank_times_list == nil) then
                protocol_command.enemy_boss_rank_list_get.param_list = "1"
                NetworkManager:register(protocol_command.enemy_boss_rank_list_get.code, nil, nil, nil, nil, responseCallback, false, nil)
            else
                responseCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
            end
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local rank_window_close_terminal = {
	_name = "rank_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RankClass"))
        -- 校验开启教学事件
        state_machine.excute("main_window_check_mission", 0, 0)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(rank_window_open_terminal)
state_machine.add(rank_window_close_terminal)
state_machine.init()

function Rank:ctor()
	self.super:ctor()
	self.roots = {}
   
    -- var
    --当前排行榜列表类型 1战力，2关卡，3军功，4军团，5战地，6学霸，7平叛，8歼敌，9参战
    self._list_type = 1
    --右侧所有列表所在父层
    self._panel_listview = nil
    self._list_view_height = 0

    self._listview_tab = {}
    -- load lua file
    app.load("client.red_alert_time.rank.RankListview")
    app.load("client.red_alert_time.cells.rank.rank_cell")

	-- Initialize rank state machine.
    local function init_rank_terminal()
        --显示界面
        local rank_window_show_terminal = {
            _name = "rank_window_show",
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
        local rank_window_hide_terminal = {
            _name = "rank_window_hide",
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
        -- 切换列表
        local rank_change_listview_page_terminal = {
            _name = "rank_change_listview_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._list_type = params._datas.index
                instance:changeListviewPage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 刷新列表
        local rank_update_draw_list_view_terminal = {
            _name = "rank_update_draw_list_view",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local list_type = params[1]
                local listview = instance._listview_tab[""..list_type]
                if listview ~= nil then
                    state_machine.excute("rank_listview_update_draw", 0, listview)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(rank_window_show_terminal)
        state_machine.add(rank_window_hide_terminal)
        state_machine.add(rank_change_listview_page_terminal)
        state_machine.add(rank_update_draw_list_view_terminal)
        state_machine.init()
    end
    
    -- call func rank create state machine.
    init_rank_terminal()

end

function Rank:onHide()
    self:setVisible(false)
end

function Rank:onShow()
    self:setVisible(true)
end

function Rank:updateDraw()
    local root = self.roots[1]    
    local type_info = {"0", "0", "0", "0", "0", "0", "0", "0", "0"}

    -- 我的排名
    local Text_rank_me_t = ccui.Helper:seekWidgetByName(root,"Text_rank_me_t")
    local Text_rank_me_n = ccui.Helper:seekWidgetByName(root,"Text_rank_me_n")
    Text_rank_me_t:setString(red_alert_time_str[102])
    Text_rank_me_n:setString(red_alert_time_str[1])
    Text_rank_me_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    local level = _ED.user_info.user_grade
    if self._list_type == 1 then
        if _ED.fight_ranks ~= nil 
            and _ED.fight_ranks.my_info ~= nil 
            and zstring.tonumber(_ED.fight_ranks.my_info.now_rank) > 0 
            then
            Text_rank_me_n:setString(_ED.fight_ranks.my_info.now_rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        end
        type_info[1] = exChangeNumToString(_ED.user_info.fighter_capacity)
    elseif self._list_type == 2 then
        if _ED.npc_rank ~= nil 
            and _ED.npc_rank.my_info ~= nil 
            and zstring.tonumber(_ED.npc_rank.my_info.user_rank) > 0 
            then
            Text_rank_me_n:setString(_ED.npc_rank.my_info.user_rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        end

        -- 计算关卡星数
        local total_count = 0
        for i = 1, _ED.easy_now_scene_id do
            total_count = total_count + _ED.get_star_count[i]
        end
        type_info[2] = ""..total_count
    elseif self._list_type == 3 then 
        if _ED.exploit_rank ~= nil 
            and _ED.exploit_rank.my_info ~= nil
            and zstring.tonumber(_ED.exploit_rank.my_info.user_rank) > 0 then
            Text_rank_me_n:setString(_ED.exploit_rank.my_info.user_rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        end
        type_info[3] = exChangeNumToString(_ED.user_info.total_war_industry)
    elseif self._list_type == 4 then
        if _ED.union.union_info == nil 
            or _ED.union.union_info == {} 
            or _ED.union.union_info.union_id == nil 
            or _ED.union.union_info.union_id == "" 
            or tonumber(_ED.union.union_info.union_id) == 0 
            then
            Text_rank_me_n:setString(tipStringInfo_union_str[3])
            Text_rank_me_n:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
            level = 0
            type_info[4] = "0"
        else
            Text_rank_me_n:setString(_ED.union.union_info.ranking)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            
            level = _ED.union.union_info.union_grade
            type_info[4] = exChangeNumToString(_ED.union.union_info.combat_force)
        end
        Text_rank_me_t:setString(red_alert_time_str[103])
    elseif self._list_type == 5 then
        local user_info = nil
        if _ED.city_rank ~= nil and _ED.city_rank.other_user ~= nil and _ED.city_rank.other_user[1] ~= nil then
            for k, v in pairs(_ED.city_rank.other_user[1]) do
                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                    user_info = v
                end
            end
        end
        if user_info ~= nil then
            Text_rank_me_n:setString(user_info.user_rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
        end
        type_info[5] = exChangeNumToString(_ED.user_info.fighter_capacity)
    elseif self._list_type == 6 then
        if _ED.answer_user_info ~= nil and zstring.tonumber(_ED.answer_user_info.rank) > 0 then
            Text_rank_me_n:setString(_ED.answer_user_info.rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            type_info[6] = exChangeNumToString(_ED.answer_user_info.score)
        end
    elseif self._list_type == 7 then
        local user_info = nil
        if _ED.user_rebel_haunt_total_rank_info ~= nil then
            for k, v in pairs(_ED.user_rebel_haunt_total_rank_info) do
                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                    user_info = v
                end
            end
        end
        if user_info ~= nil then
            Text_rank_me_n:setString(user_info.rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            type_info[7] = user_info.score
        end
    elseif self._list_type == 8 then
        local user_info = nil
        if _ED.user_enemy_strike_rank_info ~= nil and _ED.user_enemy_strike_rank_info.rank_hurt_list ~= nil then
            for k, v in pairs(_ED.user_enemy_strike_rank_info.rank_hurt_list) do
                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                    user_info = v
                end
            end
        end
        if user_info ~= nil then
            Text_rank_me_n:setString(user_info.rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            type_info[8] = exChangeNumToString(user_info.total_value)
        end
    elseif self._list_type == 9 then
        local user_info = nil
        if _ED.user_enemy_strike_rank_info ~= nil and _ED.user_enemy_strike_rank_info.rank_times_list ~= nil then
            for k, v in pairs(_ED.user_enemy_strike_rank_info.rank_times_list) do
                if tonumber(v.user_id) == tonumber(_ED.user_info.user_id) then
                    user_info = v
                end
            end
        end
        if user_info ~= nil then
            Text_rank_me_n:setString(user_info.rank)
            Text_rank_me_n:setColor(cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]))
            type_info[9] = ""..user_info.total_value
        end
    else
        level = _ED.user_info.user_grade
    end
    -- 我的等级
    local Text_lv_me = ccui.Helper:seekWidgetByName(root,"Text_lv_me")
    local fontSize1 = Text_lv_me:getFontSize()
    Text_lv_me:removeAllChildren(true)
    local _richText_1 = ccui.RichText:create()
    _richText_1:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, red_alert_time_str[2], "fonts/simhei.ttf",fontSize1)
    _richText_1:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, level, "fonts/simhei.ttf",fontSize1)
    _richText_1:pushBackElement(re2)
    _richText_1:setPosition(cc.p(Text_lv_me:getContentSize().width/2,Text_lv_me:getContentSize().height/2))
    _richText_1:setContentSize(cc.size(Text_lv_me:getContentSize().width,fontSize1))
    Text_lv_me:addChild(_richText_1)

    -- type
    local Text_rank_type_me = ccui.Helper:seekWidgetByName(root,"Text_rank_type_me")
    local fontSize2 = Text_rank_type_me:getFontSize()
    Text_rank_type_me:removeAllChildren(true)
    local _richText_2 = ccui.RichText:create()
    _richText_2:ignoreContentAdaptWithSize(false)       
    local re1 = ccui.RichElementText:create(1, cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]),255, tipStringInfo_rank_type[self._list_type].."：", "fonts/simhei.ttf",fontSize2)
    _richText_2:pushBackElement(re1)  
    local re2 = ccui.RichElementText:create(1, cc.c3b(color_Type[7][1],color_Type[7][2],color_Type[7][3]),255, type_info[self._list_type], "fonts/simhei.ttf",fontSize2)
    _richText_2:pushBackElement(re2)
    _richText_2:setPosition(cc.p(Text_rank_type_me:getContentSize().width/2,Text_rank_type_me:getContentSize().height/2))
    _richText_2:setContentSize(cc.size(Text_rank_type_me:getContentSize().width,fontSize2))
    Text_rank_type_me:addChild(_richText_2)

    local Text_rank_type_t = ccui.Helper:seekWidgetByName(root,"Text_rank_type_t")
    Text_rank_type_t:setString(tipStringInfo_rank_type[self._list_type])

    -- 标题
    local Text_rank_title_name = ccui.Helper:seekWidgetByName(root,"Text_rank_title_name")
    Text_rank_title_name:setString(tipStringInfo_rank_type[9 + self._list_type])
end

function Rank:showListViewPage()
    for k, v in pairs(self._listview_tab) do
        v:setVisible(false)
    end
    if self._listview_tab[""..self._list_type] ~= nil then
        self._listview_tab[""..self._list_type]:setVisible(true)
    end
end

function Rank:changeListviewPage(isInit)
    local root = self.roots[1]
    for i=1,9 do
        local Button_rank_type = ccui.Helper:seekWidgetByName(root,"Button_rank_type_"..i)
        Button_rank_type:setHighlighted(false)
        Button_rank_type:setTouchEnabled(true)
    end
    local Button_rank_type = ccui.Helper:seekWidgetByName(root,"Button_rank_type_"..self._list_type)
    Button_rank_type:setHighlighted(true)
    Button_rank_type:setTouchEnabled(false)

    -- for k, v in pairs(self._listview_tab) do
    --     v:setVisible(false)
    -- end
    local Panel_rank_tab_box = ccui.Helper:seekWidgetByName(root,"Panel_rank_tab_box")
    self._panel_listview = Panel_rank_tab_box
    if self._listview_tab[""..self._list_type] == nil then
        --
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    if response.node._listview_tab[""..response.node._list_type] == nil then
                        local listview = state_machine.excute("rank_listview_window_open",0,{response.node._panel_listview, response.node._list_type})
                        response.node._listview_tab[""..response.node._list_type] = listview
                    end
                    response.node:showListViewPage()
                    response.node:updateDraw()
                end
            end
        end
        if isInit == true then
            responseCallback({node = self, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
        else
            if self._list_type == 1                     --请求战力排行榜 
                or self._list_type == 2                 --请求关卡排行榜 
                or self._list_type == 3 then            --请求军功排行榜 
                protocol_command.order_get_info.param_list = ""..(self._list_type - 1).. "\r\n" .."1".. "\r\n" .."20"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, self, responseCallback, false, nil)
            elseif self._list_type == 4                 
                -- and _ED.union.rank_union_list_info == nil 
                then             --请求军团排行数据  
                protocol_command.union_order.param_list = "1".. "\r\n" .."20".."\r\n0"
                NetworkManager:register(protocol_command.union_order.code, nil, nil, nil, self, responseCallback, false, nil)
            elseif self._list_type == 5
                -- and (_ED.city_rank == nil or _ED.city_rank.other_user == nil or _ED.city_rank.other_user[1] == nil or #_ED.city_rank.other_user[1] == 0) 
                then    --请求战地排行数据 
                -- 清除战地排行数据 
                if _ED.city_rank ~= nil and _ED.city_rank.other_user ~= nil then
                    _ED.city_rank.other_user[1] = {}
                end  
                protocol_command.arena_order.param_list = "0".. "\r\n" .."1".. "\r\n" .."20"
                NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, self, responseCallback, false, nil)
            elseif self._list_type == 6                 
                and _ED.answer_rank_list_info == nil then                   --请求学霸排行数据  
                protocol_command.answer_init.param_list = ""
                NetworkManager:register(protocol_command.answer_init.code, nil, nil, nil, self, responseCallback, false, nil)
            elseif self._list_type == 7                 
                -- and _ED.user_rebel_haunt_total_rank_info == nil 
                then                   --请求叛军总排行数据  
                protocol_command.rebel_haunt_rank_list_get.param_list = "1".. "\r\n" .."1".. "\r\n" .."20"
                NetworkManager:register(protocol_command.rebel_haunt_rank_list_get.code, nil, nil, nil, self, responseCallback, false, nil)
            elseif self._list_type == 8                                     --请求敌军来袭伤害排行数据  
                and (_ED.user_enemy_strike_rank_info == nil or _ED.user_enemy_strike_rank_info.rank_hurt_list == nil) then
                protocol_command.enemy_boss_rank_list_get.param_list = "0"
                NetworkManager:register(protocol_command.enemy_boss_rank_list_get.code, nil, nil, nil, self, responseCallback, false, nil)
            elseif self._list_type == 9                                     --请求敌军来袭次数排行数据  
                and (_ED.user_enemy_strike_rank_info == nil or _ED.user_enemy_strike_rank_info.rank_times_list == nil) then
                protocol_command.enemy_boss_rank_list_get.param_list = "1"
                NetworkManager:register(protocol_command.enemy_boss_rank_list_get.code, nil, nil, nil, self, responseCallback, false, nil)
            else
                local listview = state_machine.excute("rank_listview_window_open",0,{self._panel_listview, self._list_type})
                self._listview_tab[""..self._list_type] = listview
                self:showListViewPage()
                self:updateDraw()
            end
        end
    else
        self:showListViewPage()
        self:updateDraw()        
    end 
end

function Rank:onInit()
    local csbItem = csb.createNode(config_csb.rank.rank)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    self.__check_covers = true
    root.__cwindow = self
    Animations_PlayOpenMainUI({root}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_LEFT_IN)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_close"), nil, 
    {
        terminal_name = "rank_window_close", 
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)

    for i=1,9 do
        --关闭
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank_type_"..i), nil, 
        {
            terminal_name = "rank_change_listview_page", 
            terminal_state = 0,
            index = i,
        },
        nil,1)
    end

    self:changeListviewPage(true)
end

function Rank:onEnterTransitionFinish()
    
end

function Rank:init(list_type)
    self._list_type = list_type
    self:setTouchEnabled(true)
	self:onInit()
    return self
end

function Rank:onExit()
    state_machine.remove("rank_change_listview_page")
    state_machine.remove("rank_window_show")
    state_machine.remove("rank_window_hide")
    state_machine.remove("rank_update_draw_list_view")
end