-- ----------------------------------------------------------------------------------------------------
-- 说明：系统设置界面
-------------------------------------------------------------------------------------------------------
RedAlertTimeSystemGameSet = class("RedAlertTimeSystemGameSetClass", Window)

local red_alert_time_system_game_set_open_terminal = {
    _name = "red_alert_time_system_game_set_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemGameSetClass")
        if nil == _homeWindow then
    		fwin:open(RedAlertTimeSystemGameSet:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_system_game_set_close_terminal = {
    _name = "red_alert_time_system_game_set_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("RedAlertTimeSystemGameSetClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("RedAlertTimeSystemGameSetClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_system_game_set_open_terminal)
state_machine.add(red_alert_time_system_game_set_close_terminal)
state_machine.init()
    
function RedAlertTimeSystemGameSet:ctor()
    self.super:ctor()
    self.roots = {}
	
	self.music_state = nil
    self.sound_state = nil
	
	app.load("client.red_alert_time.system.RedAlertTimeSystemExchangePacks")
    app.load("client.red_alert_time.cells.system.set_up_cell")

	local function init_red_alert_time_system_game_set_terminal()
		
		
		-- -- 
        -- local red_alert_time_mine_detect_result_attack_terminal = {
            -- _name = "red_alert_time_mine_detect_result_attack",
            -- _init = function (terminal)
				-- app.load("client.red_alert_time.formation.Formation")
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = self.m_object.info ,playersOrmine = 0}})
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		--音效
        local red_alert_time_system_change_sound_terminal = {
            _name = "red_alert_time_system_change_sound",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.sound_state == true then
                    instance.sound_state = false
                    muteSoundEffect()
                else
                    instance.sound_state = true
                    openSoundEffect()
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--音乐
        local red_alert_time_system_change_music_terminal = {
            _name = "red_alert_time_system_change_music",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance.music_state == true then
                    muteBgm()
                    instance.music_state = false
                else
                    openBgm()
                    instance.music_state = true
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 天气
        local red_alert_time_system_change_weather_terminal = {
            _name = "red_alert_time_system_change_weather",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(instance.weather_state) == 1 then
                    cc.UserDefault:getInstance():setStringForKey("weather_state","0")
                    instance.weather_state = "0"
                else
                    cc.UserDefault:getInstance():setStringForKey("weather_state","1")
                    instance.weather_state = "1"
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        -- 自动补兵
        local red_alert_time_system_change_team_up_terminal = {
            _name = "red_alert_time_system_change_team_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(instance.team_up_state) == 1 then
                    cc.UserDefault:getInstance():setStringForKey("team_up_state","0")
                    instance.team_up_state = "0"
                else
                    cc.UserDefault:getInstance():setStringForKey("team_up_state","1")
                    instance.team_up_state = "1"
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 免打扰
        local red_alert_time_system_change_dont_disturb_time_terminal = {
            _name = "red_alert_time_system_change_dont_disturb_time",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:UpdateDontDisturb(params[1],params[2])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        state_machine.add(red_alert_time_system_change_sound_terminal)
        state_machine.add(red_alert_time_system_change_music_terminal)
        state_machine.add(red_alert_time_system_change_weather_terminal)
        state_machine.add(red_alert_time_system_change_team_up_terminal)
        state_machine.add(red_alert_time_system_change_dont_disturb_time_terminal)
	
		state_machine.init()
	end
	
	init_red_alert_time_system_game_set_terminal()
end

function RedAlertTimeSystemGameSet:init()
	self:initDatas()
    self:onInit()
    return self
end

function RedAlertTimeSystemGameSet:onUpdateDraw()
	local root = self.roots[1]
	local Button_set_up_2 = ccui.Helper:seekWidgetByName(root,"Button_set_up_2")
	local Button_set_up_3 = ccui.Helper:seekWidgetByName(root,"Button_set_up_3")
    local Button_set_up_4 = ccui.Helper:seekWidgetByName(root,"Button_set_up_4")
    local Button_set_up_5 = ccui.Helper:seekWidgetByName(root,"Button_set_up_5")
    local Text_set_up_infor_1_2 = ccui.Helper:seekWidgetByName(root,"Text_set_up_infor_1_2")
	local Text_set_up_infor_2_2 = ccui.Helper:seekWidgetByName(root,"Text_set_up_infor_2_2")
	local Text_set_up_infor_3_2 = ccui.Helper:seekWidgetByName(root,"Text_set_up_infor_3_2")
    local Text_set_up_infor_4_2 = ccui.Helper:seekWidgetByName(root,"Text_set_up_infor_4_2")
    local Text_set_up_infor_5_2 = ccui.Helper:seekWidgetByName(root,"Text_set_up_infor_5_2")
	local _sound = iscurrentBgm()
    local _music = isBgmOpen()
	if _music == true then
        Button_set_up_2:setHighlighted(true)
		Button_set_up_2:setTitleText(_app_system_text[2]) 
		Text_set_up_infor_2_2:setString(_app_system_text[3])
    else
		Button_set_up_2:setHighlighted(false)
		Button_set_up_2:setTitleText(_app_system_text[1]) 
		Text_set_up_infor_2_2:setString(_app_system_text[4])
    end
    if _sound == true then
        Button_set_up_3:setHighlighted(true)
		Button_set_up_3:setTitleText(_app_system_text[2]) 
		Text_set_up_infor_3_2:setString(_app_system_text[3])
    else
        Button_set_up_3:setHighlighted(false)
		Button_set_up_3:setTitleText(_app_system_text[1]) 
		Text_set_up_infor_3_2:setString(_app_system_text[4])
    end
    if tonumber(self.team_up_state) == 1 then
        Button_set_up_4:setHighlighted(true)
        Button_set_up_4:setTitleText(_app_system_text[2]) 
        Text_set_up_infor_4_2:setString(_app_system_text[3])
    else
        Button_set_up_4:setHighlighted(false)
        Button_set_up_4:setTitleText(_app_system_text[1]) 
        Text_set_up_infor_4_2:setString(_app_system_text[4])
    end
    if tonumber(self.weather_state) == 1 then
        Button_set_up_5:setHighlighted(true)
        Button_set_up_5:setTitleText(_app_system_text[2]) 
        Text_set_up_infor_5_2:setString(_app_system_text[3])
    else
        Button_set_up_5:setHighlighted(false)
        Button_set_up_5:setTitleText(_app_system_text[1]) 
        Text_set_up_infor_5_2:setString(_app_system_text[4])
    end

    local dont_disturb_time = zstring.split(self.dont_disturb_time,",")
    Text_set_up_infor_1_2:setString(string.format(_app_system_text[6],dont_disturb_time[1],dont_disturb_time[2]))

    local ListView_game_set_up = ccui.Helper:seekWidgetByName(root,"ListView_game_set_up")
    if ListView_game_set_up:getChildByTag(1000) ~= nil then
        ListView_game_set_up:removeChildByTag(1000)
    end    
    ListView_game_set_up:jumpToTop()
    local cell = state_machine.excute("set_up_cell",0, 0)
    cell:setTag(1000)
    ListView_game_set_up:addChild(cell)

    ListView_game_set_up:requestRefreshView()
end

function RedAlertTimeSystemGameSet:UpdateDontDisturb(coordinate_1,coordinate_2)
    local root = self.roots[1]
    local Text_set_up_infor_1_2 = ccui.Helper:seekWidgetByName(root,"Text_set_up_infor_1_2")
    Text_set_up_infor_1_2:setString(string.format(_app_system_text[6],coordinate_1,coordinate_2))
end

function RedAlertTimeSystemGameSet:initDatas()
    self.weather_state = cc.UserDefault:getInstance():getStringForKey("weather_state")
    self.team_up_state = cc.UserDefault:getInstance():getStringForKey("team_up_state")
    self.dont_disturb_state = cc.UserDefault:getInstance():getStringForKey("dont_disturb_state")
    self.dont_disturb_time = cc.UserDefault:getInstance():getStringForKey("dont_disturb_time")
    if self.weather_state == "" then
        cc.UserDefault:getInstance():setStringForKey("weather_state","1")
        self.weather_state = "1"
    end
    if self.team_up_state == "" then
        cc.UserDefault:getInstance():setStringForKey("team_up_state","1")
        self.team_up_state = "1"
    end
    if self.dont_disturb_state == "" then
        cc.UserDefault:getInstance():setStringForKey("dont_disturb_state","1")
        self.dont_disturb_state = "1"
    end
    if self.dont_disturb_time == "" then
        cc.UserDefault:getInstance():setStringForKey("dont_disturb_time","20,8")
        self.dont_disturb_time = "20,8"
    end
    self.music_state = iscurrentBgm()
    self.sound_state = isBgmOpen()
end

function RedAlertTimeSystemGameSet:onInit()
    local csbRedAlertTimeSystemGameSet = csb.createNode(config_csb.system.red_alert_time_game_set)
    local root = csbRedAlertTimeSystemGameSet:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbRedAlertTimeSystemGameSet)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_close"), nil, 
    {
        terminal_name = "red_alert_time_system_game_set_close",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
	
	-- 免打扰
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_1"), nil, 
    {
        terminal_name = "red_alert_time_system_dont_disturb_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 背景音
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_2"), nil, 
    {
        terminal_name = "red_alert_time_system_change_music",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 按钮音
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_3"), nil, 
    {
        terminal_name = "red_alert_time_system_change_sound",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 基地设防后自动补兵
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_4"), nil, 
    {
        terminal_name = "red_alert_time_system_change_team_up",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	-- 天气效果
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_set_up_5"), nil, 
    {
        terminal_name = "red_alert_time_system_change_weather",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
	
	
	self:onUpdateDraw()
end

function RedAlertTimeSystemGameSet:onExit()
	state_machine.remove("red_alert_time_system_change_music")
    state_machine.remove("red_alert_time_system_change_sound")
    state_machine.remove("red_alert_time_system_change_team_up")
    state_machine.remove("red_alert_time_system_change_weather")
    state_machine.remove("red_alert_time_system_change_dont_disturb_time")
end