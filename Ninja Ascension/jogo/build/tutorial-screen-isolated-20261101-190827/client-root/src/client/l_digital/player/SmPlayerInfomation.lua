-- ----------------------------------------------------------------------------------------------------
-- 说明：数码点击顶部用户信息弹出框
-------------------------------------------------------------------------------------------------------
SmPlayerInfomation = class("SmPlayerInfomationClass", Window)
local sm_player_infomation_window_open_terminal = {
    _name = "sm_player_infomation_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        local _window = fwin:find("SmPlayerInfomationClass")
        if _window == nil then
        	fwin:open(SmPlayerInfomation:new(),fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭
local sm_player_infomation_close_terminal = {
    _name = "sm_player_infomation_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
        fwin:close(fwin:find("SmPlayerInfomationClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_player_infomation_window_open_terminal)
state_machine.add(sm_player_infomation_close_terminal)
state_machine.init()
    
function SmPlayerInfomation:ctor()
    self.super:ctor()
   	self.actions = {}
	self.roots = {}
	self.page = 1
	self.page_group = {}
    self.button_group = {}
    self.button_text = {}   -- DSc重塑
	self.terminal_group = {}
	
	app.load("client.cells.ship.ship_head_cell")
	app.load("client.l_digital.player.SmPlayerInfomationPage")
	app.load("client.l_digital.player.SmPlayerSystemSetPage")
	app.load("client.l_digital.player.SmPlayerSceneSetPage")
	app.load("client.l_digital.player.SmPlayerMusicSetPage")
	
    local function init_sm_player_infomation_terminal()
        --切换标签
        local sm_player_infomation_change_page_terminal = {
            _name = "sm_player_infomation_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if self.page == params._datas._page then
            		return
            	end
                self.page = params._datas._page
                instance:changePage()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(sm_player_infomation_change_page_terminal)
        state_machine.init()
    end
    
    init_sm_player_infomation_terminal()
end
function SmPlayerInfomation:changePage()
	local root = self.roots[1]
	local Panel_xinxi = ccui.Helper:seekWidgetByName(root, "Panel_xinxi")
	for i = 1 , 4 do 
        state_machine.excute(self.terminal_group[i][3],0,"") -- 全隐藏
        
        if i == self.page then
            -- DSc重塑
            if self.button_text[i] ~= nil then 
                self.button_text[i]:setVisible(true)
                self.button_group[i]:setEnabled(false)
            end
            self.button_group[i]:setHighlighted(true)
			if self.page_group[i] == nil then
				self.page_group[i] = state_machine.excute(self.terminal_group[i][1],0,Panel_xinxi)
				Panel_xinxi:addChild(self.page_group[i])
			else
				state_machine.excute(self.terminal_group[i][2],0,"")
			end
        else
            -- DSc重塑
            if self.button_text[i] ~= nil then 
                self.button_text[i]:setVisible(false)
                self.button_group[i]:setEnabled(true)
            end
			self.button_group[i]:setHighlighted(false)
		end
	end
end

function SmPlayerInfomation:onEnterTransitionFinish()
	local csbUserInfo = csb.createNode("player/role_information.csb")
	self:addChild(csbUserInfo)
	local root = csbUserInfo:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("player/role_information.csb")
	table.insert(self.actions, action)
    csbUserInfo:runAction(action)
    action:play("window_open", false)

    self.button_group = {
    	ccui.Helper:seekWidgetByName(root, "Button_player_info"),
    	ccui.Helper:seekWidgetByName(root, "Button_system_setup"),
    	ccui.Helper:seekWidgetByName(root, "Button_home_bg_setup"),
    	ccui.Helper:seekWidgetByName(root, "Button_bgm_setup"),
    }
    
    -- DSc重塑
    self.button_text = {
        ccui.Helper:seekWidgetByName(root, "Text__player_info_l"),
        ccui.Helper:seekWidgetByName(root, "Text_system_setup_l"),
        nil,
        ccui.Helper:seekWidgetByName(root, "Text_bgm_setup_l"),
    }

	--打开，显示，隐藏
	self.terminal_group = {
		{"sm_player_infomation_page_open","sm_player_infomation_page_show","sm_player_infomation_page_hide"},
    	{"sm_player_system_set_page_open","sm_player_system_set_page_show","sm_player_system_set_page_hide"},
    	{"sm_player_scene_set_page_open","sm_player_scene_set_page_show","sm_player_scene_set_page_hide"},
    	{"sm_player_music_set_page_open","sm_player_music_set_page_show","sm_player_music_set_page_hide"},
	}
    for i = 1 , 4 do
		fwin:addTouchEventListener(self.button_group[i],nil, 
	    {
	        terminal_name = "sm_player_infomation_change_page",     
	        terminal_state = 0, 
	        _page = i,
            isPressedActionEnabled = false
	    }, 
	    nil, 0)
    end
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),nil, 
    {
        terminal_name = "sm_player_infomation_close",     
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    ccui.Helper:seekWidgetByName(root, "Panel_xinxi"):removeAllChildren(true)
	self:changePage()
    if self.button_group[4]._w == nil then
       self.button_group[4]._w = self.button_group[4]:getPositionX()
    end
    -- DSC重塑
    local Text_system_setup_d = ccui.Helper:seekWidgetByName(root, "Text_system_setup_d")   -- 系统设置文字
    local Text_bgm_setup_d = ccui.Helper:seekWidgetByName(root, "Text_bgm_setup_d")         -- 音乐设置文字
	if __lua_project_id == __lua_project_l_digital and Text_system_setup_d and Text_bgm_setup_d then
		if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
            self.button_group[2]:setVisible(true)
            Text_system_setup_d:setVisible(true)
            self.button_group[4]:setPositionY(self.button_group[4]:getPositionY())
            Text_bgm_setup_d:setPositionY(self.button_group[4]:getPositionY())
        else
            self.button_group[2]:setVisible(false)
            Text_system_setup_d:setVisible(false)
            self.button_group[4]:setPositionY(self.button_group[2]:getPositionY())
            Text_bgm_setup_d:setPositionY(self.button_group[2]:getPositionY())
        end
	else
        if zstring.tonumber(_ED.server_review) ~= 1 then  -- 1评审, 其他非
            self.button_group[2]:setVisible(true)
            self.button_group[4]:setPositionX(self.button_group[4]._w)
        else
            self.button_group[2]:setVisible(false)
            self.button_group[4]:setPositionX(self.button_group[2]:getPositionX())
        end
    end
end

function SmPlayerInfomation:onExit()
	state_machine.remove("sm_player_infomation_change_page")
end

function SmPlayerInfomation:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end