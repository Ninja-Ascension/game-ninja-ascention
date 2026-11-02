--------------------------------------------------------------------------------------------------------------
--  开服冲top
--------------------------------------------------------------------------------------------------------------
ServerTopRank = class("ServerTopRankClass", Window)

--打开界面
local server_top_rank_window_open_terminal = {
	_name = "server_top_rank_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTip(65) == true then
            return
        end 
        cc.UserDefault:getInstance():setStringForKey(getKey("server_top_rank_push_state"), "0")
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("ServerTopRankClass") == nil then
                    fwin:open(ServerTopRank:new():init(),fwin._ui)
                end
                state_machine.excute("main_window_hide", 0, "")
                state_machine.excute("player_resource_window_hide", 0, "")     
                state_machine.excute("home_button_for_action_window_hide",0,"")
                state_machine.excute("chat_view_window_hide",0,"")   
            end
        end
        if _ED.activity_info["23"] ~= nil then
            protocol_command.get_open_server_rank_info.param_list = "23"
        else
            protocol_command.get_open_server_rank_info.param_list = "40"
        end
        NetworkManager:register(protocol_command.get_open_server_rank_info.code, nil, nil, nil, nil, responseCallback, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local server_top_rank_window_close_terminal = {
	_name = "server_top_rank_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ServerTopRankClass"))

        if fwin:find("NationalWarMapClass") ~= nil then
            -- state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") == nil then
            state_machine.excute("main_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("duplicate_title_window_show",0,"")
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
state_machine.add(server_top_rank_window_open_terminal)
state_machine.add(server_top_rank_window_close_terminal)
state_machine.init()

function ServerTopRank:ctor()
	self.super:ctor()
	self.roots = {}

	self._left_index = -1
	self._top_index = -1
	self._tab_left = {}
	self._tab_top = {}
	self._listViews = {}

    -- load lua file
    -- app.load("client.red_alert.activity.server_top_rank.ServerTopRankRight")
    app.load("client.red_alert.activity.server_top_rank.RankingListviewTop")
    app.load("client.red_alert.cells.activity.server_top_rank.server_top_rank_rihgt_cell")
		 -- Initialize alert_home state machine.
    local function init_server_top_rank_terminal()
        --管理左侧按钮
        local server_top_rank_maneger_terminal = {
	        _name = "server_top_rank_maneger",
	        _init = function (terminal)
	            
	        end,
	        _inited = false,
	        _instance = self,
	        _state = 0,
	        _invoke = function(terminal, instance, params)
	        	instance:updateDraw(params._datas.left_index, instance._top_index)
	            return true
	        end,
	        _terminal = nil,
	        _terminals = nil
        }
        --管理顶部按钮
        local server_top_rank_maneger_top_terminal = {
	        _name = "server_top_rank_maneger_top",
	        _init = function (terminal)
	            
	        end,
	        _inited = false,
	        _instance = self,
	        _state = 0,
	        _invoke = function(terminal, instance, params)
	        	instance:updateDraw(instance._left_index, params._datas.top_index)
	            return true
	        end,
	        _terminal = nil,
	        _terminals = nil
        }

        state_machine.add(server_top_rank_maneger_terminal)
        state_machine.add(server_top_rank_maneger_top_terminal)
        state_machine.init()
    end
    
    -- call func ranking create state machine.
    init_server_top_rank_terminal()
end

function ServerTopRank:updateDraw(left_index, top_index)
    local root = self.roots[1]
    for i=1,5 do
        local Text_top = ccui.Helper:seekWidgetByName(root,"Text_top_"..i)
        Text_top:setVisible(false)
    end
    
    -- 左侧按钮状态
    for k,v in pairs(self._tab_left) do
        local Text_top = ccui.Helper:seekWidgetByName(root,"Text_top_"..k)
    	if k == left_index then
    		v:setHighlighted(true)
            Text_top:setVisible(true)
    	else
    		v:setHighlighted(false)
    	end
    end
    -- 顶部按钮状态
    for k,v in pairs(self._tab_top) do
    	if k == top_index then
    		v:setHighlighted(true)
    	else
    		v:setHighlighted(false)
    	end
    end
    if left_index == self._left_index and self._top_index == top_index then
        return
    end
    self._left_index = left_index
    self._top_index = top_index
    -- 隐藏其他类型cell
    for k,list in pairs(self._listViews) do
    	if list ~= nil then
    		for k1,v in pairs(list) do
    			if v ~= nil then
    				v:setVisible(false)
    			end
    		end
    	end
    end
    local BitmapFontLabel_rank_x = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_rank_x")      -- 排名类型
    local BitmapFontLabel_rank_me = ccui.Helper:seekWidgetByName(root,"BitmapFontLabel_rank_me")    -- 排名
    BitmapFontLabel_rank_x:setString(tipStringInfo_server_top_rank[self._left_index+6])
    --掌门排名
    if self._left_index == 1 then       -- 等级榜
    	if tonumber(_ED.server_rank_info_level) == 0 then
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[11]))
    	else
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[12],_ED.server_rank_info_level))
    	end
    elseif self._left_index == 2 then   -- 战力榜
    	if tonumber(_ED.server_rank_info_power) == 0 then
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[11]))
    	else
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[12],_ED.server_rank_info_power))
    	end
    elseif self._left_index == 3 then   -- 侠客行
    	if tonumber(_ED.server_rank_info_checkpoint) == 0 then
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[11]))
    	else
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[12],_ED.server_rank_info_checkpoint))
    	end
    elseif self._left_index == 4 then   -- 星星榜
    	if tonumber(_ED.server_rank_info_stars) == 0 then
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[11]))
    	else
    		BitmapFontLabel_rank_me:setString(string.format(tipStringInfo_server_top_rank[12],_ED.server_rank_info_stars))
    	end
    end

    if self._top_index == 4 then    --说明按钮
        self._panel_listview:setVisible(false)
        for i=1,5 do
            if i == self._left_index then
                ccui.Helper:seekWidgetByName(root,"Text_raiders_"..i):setVisible(true)
            else
                ccui.Helper:seekWidgetByName(root,"Text_raiders_"..i):setVisible(false)
            end
        end
        return
    else
        for i=1,5 do
            ccui.Helper:seekWidgetByName(root,"Text_raiders_"..i):setVisible(false)
        end
    end
    self._panel_listview:setVisible(true)
    -- 绘制列表
    if self._listViews[""..self._left_index] == nil then
        self._listViews[""..self._left_index] = {}
        self._listViews[""..self._left_index][""..self._top_index] = {}

        local window = state_machine.excute("ranking_listview_top_window_open",0,{self._panel_listview, left_index, top_index})

        self._listViews[""..self._left_index][""..self._top_index] = window
    else
        if self._listViews[""..self._left_index][""..self._top_index] == nil then
            self._listViews[""..self._left_index][""..self._top_index] = {}
            local window = state_machine.excute("ranking_listview_top_window_open",0,{self._panel_listview, left_index, top_index})

            self._listViews[""..self._left_index][""..self._top_index] = window
        else
            self._listViews[""..self._left_index][""..self._top_index]:setVisible(true)
        end
    end
end

function ServerTopRank:onInit()
    local csbItem = csb.createNode(config_csb.rank.ranking_top)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    
    self._panel_listview = ccui.Helper:seekWidgetByName(root,"Panel_listview_right")
    --关闭 -- 返回主页
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ranking_close"), nil, 
    {
        terminal_name = "server_top_rank_window_close", 
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    },
    nil,0)

    -- 左侧按钮
    for i=1,5 do
    	local Button_rank_top = ccui.Helper:seekWidgetByName(root,"Button_rank_top_"..i)
    	table.insert(self._tab_left, Button_rank_top)
    	fwin:addTouchEventListener(Button_rank_top, nil, 
	    {
	        terminal_name = "server_top_rank_maneger", 
	        terminal_state = 0,
	        touch_scale = true,
	        touch_scale_xy = 0.95, 
	        left_index = i,
	    },
	    nil,0)
    end

    -- 顶部按钮
    for i=1,4 do
    	local Button_reward = ccui.Helper:seekWidgetByName(root,"Button_reward_"..i)
    	table.insert(self._tab_top,Button_reward)
	    fwin:addTouchEventListener(Button_reward, nil, 
	    {
	        terminal_name = "server_top_rank_maneger_top", 
	        terminal_state = 0,
	        touch_scale = true,
	        touch_scale_xy = 0.95, 
	        top_index = i,
	    },
	    nil,0)
    end

    self:updateDraw(1,1)
end

function ServerTopRank:onEnterTransitionFinish()
    
end

function ServerTopRank:init()
	self:onInit()
    return self
end

function ServerTopRank:onExit()
    state_machine.remove("server_top_rank_maneger")
    state_machine.remove("server_top_rank_maneger_top")
end