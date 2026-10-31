--------------------------------------------------------------------------------------------------------------
--  说明：头像设置
--------------------------------------------------------------------------------------------------------------
PlayerStampSettings = class("PlayerStampSettingsClass", Window)

--打开界面
local player_stamp_settings_open_terminal = {
	_name = "player_stamp_settings_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if fwin:find("PlayerStampSettingsClass") == nil then
    		fwin:open(PlayerStampSettings:new():init(params), fwin._ui)  
        end
	    return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local player_stamp_settings_close_terminal = {
	_name = "player_stamp_settings_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PlayerStampSettingsClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(player_stamp_settings_open_terminal)
state_machine.add(player_stamp_settings_close_terminal)
state_machine.init()

function PlayerStampSettings:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
	self.head_id = 0

    self._list_view = nil
    self._list_view_poy = nil
    self._list_view_height = 0

    self._Image_arrow_down = nil
    self._Image_arrow_up = nil

	app.load("client.red_alert_time.cells.player.player_head_portrait_cell")

    local function init_play_infomation_terminal()
        local player_stamp_settings_show_terminal = {
            _name = "player_stamp_settings_show",
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

        local player_stamp_settings_hide_terminal = {
            _name = "player_stamp_settings_hide",
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
		
		local player_stamp_settings_head_id_recording_terminal = {
            _name = "player_stamp_settings_head_id_recording",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.head_id = tonumber(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local player_stamp_settings_replace_head_id_terminal = {
            _name = "player_stamp_settings_replace_head_id",
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
							state_machine.excute("player_infomation_update_info", 0, nil)
							state_machine.excute("main_window_update_head_info", 0, nil)
						end	
					end
				end
				local head_data = zstring.split(_ED.user_info.user_head_id, ",")
				protocol_command.head_save.param_list = instance.head_id..","..head_data[2]..","..head_data[3]
				NetworkManager:register(protocol_command.head_save.code, nil, nil, nil, self, responseNationalTaskCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		

        state_machine.add(player_stamp_settings_show_terminal)
        state_machine.add(player_stamp_settings_hide_terminal)
        state_machine.add(player_stamp_settings_head_id_recording_terminal)
        state_machine.add(player_stamp_settings_replace_head_id_terminal)
        state_machine.init()
    end
    
    init_play_infomation_terminal()
end

function PlayerStampSettings:updateDraw()
    local root = self.roots[1]
	local ListView_player_head = ccui.Helper:seekWidgetByName(root, "ListView_player_head")
    ListView_player_head:jumpToTop()
	ListView_player_head:removeAllItems()
	for i = 1, 6 do
        if dms.searchs(dms["avatar_head"], avatar_head.sort, i-1) ~= nil 
            and #dms.searchs(dms["avatar_head"], avatar_head.sort, i-1) > 0 then
    		local cell = state_machine.excute("player_head_portrait_cell",0,{i,0})
    		ListView_player_head:addChild(cell)
        end
	end
	ListView_player_head:requestRefreshView()
    self._list_view = ListView_player_head
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    
    for i,v in pairs(ListView_player_head:getItems()) do
        local listInfo = v:getChildByName("root")
        if listInfo ~= nil then
            local cellPanel = listInfo:getChildByName("ScrollView_head_icon"):getChildByName("cellPanel")
            if  cellPanel ~= nil then
                local head_data = zstring.split(_ED.user_info.user_head_id, ",")
                if cellPanel:getChildByTag(tonumber(head_data[1])) ~= nil then
                    self.head_id = tonumber(head_data[1])
                    state_machine.excute("player_head_change_icon_cell_update",0,{_datas={cells = cellPanel:getChildByTag(tonumber(head_data[1]))}})
                    return
                end
            end
        end
    end
end

function PlayerStampSettings:onUpdate(dt)
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
function PlayerStampSettings:onInit()
    local csbItem = csb.createNode(string.format(config_csb.player.player_head_change_tab, "1"))
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)    

    -- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_prestige_up"), nil, 
    -- {
        -- terminal_name = "player_info_prestige_open", 
        -- terminal_state = 0, 
        -- touch_black = true,
    -- }, nil, 1)
	 -- -- 点击
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_player_head_save"), nil, 
    {
        terminal_name = "player_stamp_settings_replace_head_id",
        terminal_state = 0,
		touch_black = true,
    },
    nil,1)

    self._Image_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_player_headarrow_down")
    self._Image_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_player_head_arrow_up")
    
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

function PlayerStampSettings:onEnterTransitionFinish()

end

function PlayerStampSettings:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PlayerStampSettings:onExit()
    state_machine.remove("player_stamp_settings_show")
    state_machine.remove("player_stamp_settings_hide")
end