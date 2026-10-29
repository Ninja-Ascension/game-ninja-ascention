--------------------------------------------------------------------------------------------------------------
-- 排行
--------------------------------------------------------------------------------------------------------------
TourneyfieldRanking = class("TourneyfieldRankingClass", Window)

--打开界面
local tourneyfield_ranking_window_open_terminal = {
	_name = "tourneyfield_ranking_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)   
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("TourneyfieldRankingClass") == nil then
                    fwin:open(TourneyfieldRanking:new():init(),fwin._ui)
                end
            end
        end
        protocol_command.arena_order.param_list = "0"
        NetworkManager:register(protocol_command.arena_order.code, nil, nil, nil, nil, responseCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local tourneyfield_ranking_window_close_terminal = {
	_name = "tourneyfield_ranking_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TourneyfieldRankingClass"))
     
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(tourneyfield_ranking_window_open_terminal)
state_machine.add(tourneyfield_ranking_window_close_terminal)
state_machine.init()

function TourneyfieldRanking:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- load lua file
    app.load("client.red_alert.rank.RankingListview")
    app.load("client.red_alert.cells.rank.ranking_right_cell")
    --var
    self._list_view = {}

    self._panel_listview = nil

	 -- Initialize tourneyfield_ranking state machine.
    
    local function init_tourneyfield_ranking_terminal()
       --管理
        local tourneyfield_ranking_manager_terminal = {
        _name = "tourneyfield_ranking_manager",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params)  

            -- if terminal.last_terminal_name ~= params._datas.next_terminal_name then
                -- hide child window
                terminal.last_terminal_name = params._datas.next_terminal_name
                state_machine.excute(params._datas.next_terminal_name, 0, params)
            -- end 
            -- set select ui button is highlighted
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(false)
                terminal.select_button:setTouchEnabled(true)
            end
            terminal.page_name = params._datas.but_image
            if terminal.select_button == nil and params._datas.current_button_name ~= nil then
                terminal.select_button = ccui.Helper:seekWidgetByName(instance.roots[1], params._datas.current_button_name)
            else
                terminal.select_button = params
            end
            if terminal.select_button ~= nil and terminal.select_button.setHighlighted ~= nil then
                terminal.select_button:setHighlighted(true)
                terminal.select_button:setTouchEnabled(false)
            end
            return true
        end,
        _terminal = nil,
        _terminals = nil
        }
        --切换界面
        local tourneyfield_ranking_change_terminal = {
        _name = "tourneyfield_ranking_change",
        _init = function (terminal)
            
        end,
        _inited = false,
        _instance = self,
        _state = 0,
        _invoke = function(terminal, instance, params) 
            local from_type = params._datas.from_type
            for i,v in pairs(instance._list_view) do
                v:setVisible(false)
            end
        
            if instance._list_view[""..from_type] == nil then
               instance._list_view[""..from_type] = state_machine.excute("ranking_listview_window_open",0,{instance._panel_listview,from_type})
            end
            instance._list_view[""..from_type]:setVisible(true)
            return true
        end,
        _terminal = nil,
        _terminals = nil
        } 
        
        state_machine.add(tourneyfield_ranking_manager_terminal)
        state_machine.add(tourneyfield_ranking_change_terminal)
        state_machine.init()
    end
    
    -- call func tourneyfield_ranking create state machine.
    init_tourneyfield_ranking_terminal()

end

--初始化界面
function TourneyfieldRanking:onInit()
    local csbItem = csb.createNode(config_csb.campaign.tourneyfield.tourneyfield_ranking)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
    {
        terminal_name = "tourneyfield_ranking_window_close", 
        terminal_state = 0, 
        cell = self, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)     
    
    self._panel_listview = ccui.Helper:seekWidgetByName(root,"Panel_rank")
    for i = 1 ,3 do 
        local Button_national = ccui.Helper:seekWidgetByName(root,"Button_national_"..i)
        fwin:addTouchEventListener(Button_national, nil, 
        {
            terminal_name = "tourneyfield_ranking_manager",     
            next_terminal_name = "tourneyfield_ranking_change", 
            current_button_name = "Button_national_"..i,   
            but_image = "",     
            terminal_state = 0, 
            from_type = 4,
            touch_scale = true,
            touch_scale_xy = 0.95,  
        }, nil, 3)       
    end

    self:onUpdateDraw()
    state_machine.excute("tourneyfield_ranking_manager",0,{ 
        _datas = {
            terminal_name = "tourneyfield_ranking_manager",     
            next_terminal_name = "tourneyfield_ranking_change", 
            current_button_name = "Button_national_1",   
            but_image = "",     
            terminal_state = 0, 
            from_type = 4,
            touch_scale = true,
            touch_scale_xy = 0.95,  
        }
    })
end

function TourneyfieldRanking:onEnterTransitionFinish()

end

function TourneyfieldRanking:onUpdateDraw()
    local root = self.roots[1]   
    -- 排名
    local Text_rank = ccui.Helper:seekWidgetByName(root,"Text_rank_me_2")           
    if tonumber(_ED.city_rank.my_info.user_rank) ~= 0 then
        Text_rank:setString(_ED.city_rank.my_info.user_rank)
    else  -- 未上榜
        Text_rank:setString(tipStringInfo_rank_str[8])
    end
    -- 江湖地位
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_rank_me_4")         
    local arena_id = tonumber(_ED.city_rank.my_info.user_arena_id)
    local arena_name = dms.string(dms["arena_reward_param"], arena_id, arena_reward_param.arena_name)
    local arena_official = tonumber(_ED.city_rank.my_info.user_official)
    arena_name = zstring.split(arena_name,",")
    arena_name = arena_name[tonumber(_ED.user_info.user_force)]
    local name = red_alert_officer[arena_official]..arena_name
    Text_name:setString(name)
end

function TourneyfieldRanking:close()

end

--初始化
function TourneyfieldRanking:init()
    --皇城排行模拟数据
    -- _ED.city_rank = {}
    -- _ED.city_rank.other_user = {}
    -- _ED.city_rank.other_user[1] = {}
    -- _ED.city_rank.other_user[2] = {}
    -- _ED.city_rank.other_user[3] = {}
    -- for i=1,10 do
    --     _ED.city_rank.other_user[1][i] = {
    --         user_id = i,
    --         user_name = "朱立鑫",
    --         user_camp = 1,
    --         user_rank = i,
    --         user_sex = math.random(1,2),
    --         user_level = math.random(20,99),
    --         user_fight = math.random(1,100),
    --         user_official = math.random(1,9)
    --     } 
    --     _ED.city_rank.other_user[2][i] = {
    --         user_id = i,
    --         user_name = "朱立鑫",
    --         user_camp = 2,
    --         user_rank = i,
    --         user_sex = math.random(1,2),
    --         user_level = math.random(20,99),
    --         user_fight = math.random(1,100),
    --         user_official = math.random(1,9)
    --     } 
    --     _ED.city_rank.other_user[3][i] = {
    --        user_id = i,
    --         user_name = "朱立鑫",
    --         user_camp = 3,
    --         user_rank = i,
    --         user_sex = math.random(1,2),
    --         user_level = math.random(20,99),
    --         user_fight = math.random(1,100),
    --         user_official = math.random(1,9)
    --     } 
    -- end
	self:onInit()
    return self
end

--移除状态机
function TourneyfieldRanking:onExit()
    state_machine.remove("tourneyfield_ranking_manager")
    state_machine.remove("tourneyfield_ranking_change")
end