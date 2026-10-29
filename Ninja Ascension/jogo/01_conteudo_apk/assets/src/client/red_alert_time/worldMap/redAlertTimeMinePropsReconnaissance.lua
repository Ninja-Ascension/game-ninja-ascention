-- ----------------------------------------------------------------------------------------------------
-- 说明：道具侦察
-------------------------------------------------------------------------------------------------------
redAlertTimeMinePropsReconnaissance = class("redAlertTimeMinePropsReconnaissanceClass", Window)

local red_alert_time_mine_props_reconnaissance_open_terminal = {
    _name = "red_alert_time_mine_props_reconnaissance_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMinePropsReconnaissanceClass")
        if nil == _homeWindow then
    		fwin:open(redAlertTimeMinePropsReconnaissance:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local red_alert_time_mine_props_reconnaissance_close_terminal = {
    _name = "red_alert_time_mine_props_reconnaissance_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("redAlertTimeMinePropsReconnaissanceClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("redAlertTimeMinePropsReconnaissanceClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(red_alert_time_mine_props_reconnaissance_open_terminal)
state_machine.add(red_alert_time_mine_props_reconnaissance_close_terminal)
state_machine.init()
    
function redAlertTimeMinePropsReconnaissance:ctor()
    self.super:ctor()
    self.roots = {}
	
    app.load("client.red_alert_time.chat.ChatFriendWindow")
    app.load("client.adventure.campaign.mine.AdventureMineManager")
	-- app.load("client.red_alert_time.cells.worldMap.world_nearby_list_cell")

    local function init_red_alert_time_mine_props_reconnaissance_terminal()
        
		
		--侦察
        local red_alert_time_mine_props_reconnaissance_reconnaissance_terminal = {
            _name = "red_alert_time_mine_props_reconnaissance_reconnaissance",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local text = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_props_spy_name")
                local str = zstring.exchangeTo(text:getString())
                if str == nil or str == "" then
                    TipDlg.drawTextDailog(chat_sent_string[8])
                    return
                end
                --翻页资源和玩家
				local function responseNearbyCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node ~= nil and response.node.roots ~= nil then
							-- instance.update_type = 1
							-- instance:changeSelectPage(zstring.tonumber(self._current_page))
       --                      if fwin:find("PropsShopPacksClass") ~= nil then
       --                          state_machine.excute("props_shop_packs_window_close", 0, 0)
       --                      end
                            -- state_machine.excute("red_alert_time_mine_props_reconnaissance_close", 0, 0)
       --                      state_machine.excute("home_button_select_page", 0, {_datas = {select_page = 2}})
                        end
						-- state_machine.excute("adventure_mine_update_view_position", 0, 0)
                        state_machine.excute("red_alert_time_mine_props_reconnaissance_close", 0, 0)
                        state_machine.excute("props_shop_packs_packs_tab_update_draw", 0, nil)

                        fwin:addService({
                            callback = function ( params )
                                state_machine.excute("adventure_mine_update_map_draw", 0, 0)
                            end,
                            delay = 0.05,
                            params = nil
                        })
                    end
                end
				local objects = nil
				if instance.m_id == dms.int(dms["prop_config"], 23, prop_config.param) then
					objects = 0
				else
					objects = 1
				end
				protocol_command.world_info_scout.param_list = objects.."\r\n"..str
				NetworkManager:register(protocol_command.world_info_scout.code, nil, nil, nil, self, responseNearbyCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --设置玩家
        local red_alert_time_mine_props_reconnaissance_private_chat_terminal = {
            _name = "red_alert_time_mine_props_reconnaissance_private_chat",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_props_spy_name"):setString(params.user_name)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local red_alert_time_mine_props_reconnaissance_delete_terminal = {
            _name = "red_alert_time_mine_props_reconnaissance_delete",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local TextField_props_spy_name = ccui.Helper:seekWidgetByName(instance.roots[1], "TextField_props_spy_name")
                TextField_props_spy_name:setString("")
                cleanEditBoxString(TextField_props_spy_name)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(red_alert_time_mine_props_reconnaissance_reconnaissance_terminal)
        state_machine.add(red_alert_time_mine_props_reconnaissance_private_chat_terminal)
        state_machine.add(red_alert_time_mine_props_reconnaissance_delete_terminal)
        state_machine.init()
    end
    
    -- call func init adventure mine state machine.
    init_red_alert_time_mine_props_reconnaissance_terminal()
end

function redAlertTimeMinePropsReconnaissance:init(params)
	self.m_id = tonumber(params)
    self:onInit()
    return self
end

function redAlertTimeMinePropsReconnaissance:updateDraw()
	local root = self.roots[1]
	local Text_props_spy_title = ccui.Helper:seekWidgetByName(root,"Text_props_spy_title")
    local Text_props_spy_p_2 = ccui.Helper:seekWidgetByName(root,"Text_props_spy_p_2")
	local propMould = dms.element(dms["prop_mould"], tonumber(self.m_id))
	Text_props_spy_title:setString(dms.atos(propMould,prop_mould.prop_name))

    local objects = nil
    if self.m_id == dms.int(dms["prop_config"], 23, prop_config.param) then
        objects = 0
    else
        objects = 1
    end

    if objects == 0 then
        Text_props_spy_p_2:setVisible(false)
    else
        Text_props_spy_p_2:setVisible(true)
    end
	
end

function redAlertTimeMinePropsReconnaissance:onInit()
    local csbredAlertTimeMinePropsReconnaissance = csb.createNode(config_csb.world_map.world_map_res_props_spy)
    local root = csbredAlertTimeMinePropsReconnaissance:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbredAlertTimeMinePropsReconnaissance)
	
	local text = ccui.Helper:seekWidgetByName(root, "TextField_props_spy_name")
    text:setString("")
    local nameData = zstring.split(dms.string(dms["user_config"],36,user_config.param),",")
    draw:addEditBoxEx(text, _wonderful_string[2], "effect/effice_1500.png", ccui.Helper:seekWidgetByName(root, "Button_res_spy_search"), tonumber(nameData[2]), cc.KEYBOARD_RETURNTYPE_DONE)
	
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_spy_close"), nil, 
    {
        terminal_name = "red_alert_time_mine_props_reconnaissance_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,3)
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "red_alert_time_mine_props_reconnaissance_close",
        terminal_state = 0,
    },
    nil,3)

	-- 搜索
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_spy_search"), nil, 
    {
        terminal_name = "red_alert_time_mine_props_reconnaissance_reconnaissance",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    -- 联系人
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_spy_contact_person"), nil, 
    {
        terminal_name = "chat_friend_window_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
        from_type = 2,
    },
    nil,1)

    -- 删除
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_props_spy_delete"), nil, 
    {
        terminal_name = "red_alert_time_mine_props_reconnaissance_delete",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    
	
	self:updateDraw()
end

function redAlertTimeMinePropsReconnaissance:onExit()
    state_machine.remove("red_alert_time_mine_props_reconnaissance_reconnaissance")
    state_machine.remove("red_alert_time_mine_props_reconnaissance_private_chat")
	state_machine.remove("red_alert_time_mine_props_reconnaissance_delete")
end