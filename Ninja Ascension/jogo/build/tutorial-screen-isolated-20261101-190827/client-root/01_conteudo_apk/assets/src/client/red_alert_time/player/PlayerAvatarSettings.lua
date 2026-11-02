--------------------------------------------------------------------------------------------------------------
--  说明：挂饰设置
--------------------------------------------------------------------------------------------------------------
PlayerAvatarSettings = class("PlayerAvatarSettingsClass", Window)

--打开界面
local player_avatar_settings_open_terminal = {
	_name = "player_avatar_settings_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerAvatarSettingsClass") == nil then
    		fwin:open(PlayerAvatarSettings:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_avatar_settings_close_terminal = {
	_name = "player_avatar_settings_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerAvatarSettingsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_avatar_settings_open_terminal)
state_machine.add(player_avatar_settings_close_terminal)
state_machine.init()

function PlayerAvatarSettings:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self.ornament_id = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

	app.load("client.red_alert_time.cells.player.player_head_portrait_cell")
	
    local function init_play_infomation_terminal()
        local player_avatar_settings_show_terminal = {
            _name = "player_avatar_settings_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
				-- instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local player_avatar_settings_hide_terminal = {
            _name = "player_avatar_settings_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local player_stamp_settings_ornament_id_recording_terminal = {
            _name = "player_stamp_settings_ornament_id_recording",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.ornament_id = tonumber(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local player_avatar_settings_take_off_terminal = {
            _name = "player_avatar_settings_take_off",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local function responseNationalTaskCallback( response )
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							TipDlg.drawTextDailog(red_alert_time_str[101])
							state_machine.excute("main_window_update_head_info",0,0)
							state_machine.excute("player_infomation_update_info",0,0)
                            state_machine.excute("player_ornaments_change_icon_cell_update",0, {_datas = {}})
						end	
					end
				end
                local head_data = zstring.split(_ED.user_info.user_head_id, ",")
				protocol_command.head_save.param_list = head_data[1]..",0,"..head_data[3]
				NetworkManager:register(protocol_command.head_save.code, nil, nil, nil, instance, responseNationalTaskCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local player_avatar_settings_save_ornaments_terminal = {
            _name = "player_avatar_settings_save_ornaments",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if tonumber(instance.ornament_id) > 0 then
					local function responseNationalTaskCallback( response )
						if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
							if response.node ~= nil and response.node.roots ~= nil then
								TipDlg.drawTextDailog(red_alert_time_str[101])
								state_machine.excute("main_window_update_head_info",0,0)
								state_machine.excute("player_infomation_update_info",0,0)
							end	
						end
					end
					local head_data = zstring.split(_ED.user_info.user_head_id, ",")
					protocol_command.head_save.param_list = head_data[1]..","..instance.ornament_id..","..head_data[3]
					NetworkManager:register(protocol_command.head_save.code, nil, nil, nil, instance, responseNationalTaskCallback, false, nil)
				else
                    TipDlg.drawTextDailog(red_alert_time_str[212])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(player_avatar_settings_show_terminal)
        state_machine.add(player_avatar_settings_hide_terminal)
        state_machine.add(player_stamp_settings_ornament_id_recording_terminal)
        state_machine.add(player_avatar_settings_take_off_terminal)
        state_machine.add(player_avatar_settings_save_ornaments_terminal)
        state_machine.init()
    end
    
    init_play_infomation_terminal()
end

function PlayerAvatarSettings:updateDraw()
    local root = self.roots[1]

    local head_data = zstring.split(_ED.user_info.user_head_id, ",")
    self.ornament_id = tonumber(head_data[2])

	local ListView_head_ornaments = ccui.Helper:seekWidgetByName(root, "ListView_head_ornaments")
    ListView_head_ornaments:jumpToTop()
	ListView_head_ornaments:removeAllItems()
	for i = 7, 10 do
        if dms.searchs(dms["avatar_head"], avatar_head.sort, i-1) ~= nil 
            and #dms.searchs(dms["avatar_head"], avatar_head.sort, i-1) > 0 then
    		local cell = state_machine.excute("player_head_portrait_cell",0,{i,1})
    		ListView_head_ornaments:addChild(cell)
        end
	end
	ListView_head_ornaments:requestRefreshView()
    self._list_view = ListView_head_ornaments
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    for i,v in pairs(ListView_head_ornaments:getItems()) do
        local listInfo = v:getChildByName("root")
        if listInfo ~= nil then
            local cellPanel = listInfo:getChildByName("ScrollView_head_icon"):getChildByName("cellPanel")
            if  cellPanel ~= nil then
                if cellPanel:getChildByTag(self.ornament_id) ~= nil then
                    state_machine.excute("player_ornaments_change_icon_cell_update",0,{_datas={cells = cellPanel:getChildByTag(self.ornament_id)}})
                    return
                end
            end
        end
    end
end

function PlayerAvatarSettings:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_height == 0 then
            self._list_view_height = posY
        end
        if self._list_view_poy <= -30 then
            self._Image_arrow_down:setVisible(true)
        else
            self._Image_arrow_down:setVisible(false)
        end
        if self._list_view_poy >= self._list_view_height + 30 then
            self._Image_arrow_up:setVisible(true)
        else
            self._Image_arrow_up:setVisible(false)
        end
        if self._list_view_poy == posY then
            return
        end
        self._list_view_poy = posY
    end
end


--初始化
function PlayerAvatarSettings:onInit()
    local csbItem = csb.createNode(string.format(config_csb.player.player_head_change_tab, "2"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

	--脱下
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_head_ornaments_off"), nil, 
    {
        terminal_name = "player_avatar_settings_take_off", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)
	--保存
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_head_ornaments_save"), nil, 
    {
        terminal_name = "player_avatar_settings_save_ornaments", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_ornaments_arrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_ornaments_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_arrow_down:stopAllActions()
    self._Image_arrow_up:stopAllActions()
    playActions(self._Image_arrow_down)
    playActions(self._Image_arrow_up)
    self._Image_arrow_down:setVisible(false)
    self._Image_arrow_up:setVisible(false)

    self:updateDraw()
end

function PlayerAvatarSettings:onEnterTransitionFinish()

end

function PlayerAvatarSettings:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PlayerAvatarSettings:onExit()
    state_machine.remove("player_avatar_settings_show")
    state_machine.remove("player_avatar_settings_hide")
end