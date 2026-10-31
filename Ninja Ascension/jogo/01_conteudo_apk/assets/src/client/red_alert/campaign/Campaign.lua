-----------------------------
--日常 历练
-----------------------------
Campaign = class("CampaignClass", Window)

local campaign_window_open_terminal = {
    _name = "campaign_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(64) == true then
            return
        end
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                local _Window = fwin:find("CampaignClass")
                if nil == _Window then
                    fwin:open(Campaign:new():init(), fwin._view)
                end
                state_machine.excute("campaign_window_show",0,"")
                state_machine.excute("main_window_hide", 0, "")
                state_machine.excute("player_resource_window_open", 0, "")     
                state_machine.excute("home_button_for_action_window_hide",0,"")
                state_machine.excute("chat_view_window_hide",0,"")
                state_machine.excute("duplicate_title_window_hide",0,"")
                state_machine.excute("seven_star_map_ui_window_hide",0,"")
            end
        end
        if _ED.transport_resouce_info == nil or _ED.transport_resouce_info.is_transport == nil then
            NetworkManager:register(protocol_command.ship_military_init.code, nil, nil, nil, nil, responseCallback, false, nil) 
        else
            responseCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local campaign_window_close_terminal = {
    _name = "campaign_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CampaignClass"))

        if fwin:find("NationalWarMapClass") ~= nil then
            -- state_machine.excute("player_resource_window_show",0,"")   
            state_machine.excute("home_button_for_action_window_show",0,"")  
        elseif fwin:find("DuplicateManagerClass") ~= nil then
            state_machine.excute("home_button_for_action_window_show",0,"")  
            state_machine.excute("chat_view_window_show",0,"")
            state_machine.excute("player_resource_window_hide", 0, "")
            state_machine.excute("duplicate_title_window_show",0,"")
        elseif fwin:find("SevenStarClass") ~= nil then
            state_machine.excute("seven_star_map_ui_window_show",0,"")
            state_machine.excute("duplicate_map_window_show",0,"")
            state_machine.excute("player_resource_window_hide",0,"")
            state_machine.excute("home_button_for_action_window_show",0,"")
        elseif fwin:find("DuplicateManagerClass") == nil and fwin:find("DuplicateMapClass") ~= nil then
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
        state_machine.excute("national_city_hide_game_resource_info", 0, nil)
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(campaign_window_open_terminal)
state_machine.add(campaign_window_close_terminal)
state_machine.init()

function Campaign:ctor()
    self.super:ctor()
    self.roots = {}

    --load lua file
    app.load("client.red_alert.cells.campaign.campaign_cell")
    app.load("client.red_alert.campaign.nationalwar.NationalTruce")
    app.load("client.red_alert.campaign.nationalwar.NationalTruceLoading")
    app.load("client.red_alert.campaign.raiderscut.RaidersCut")
    app.load("client.red_alert.campaign.soul_duplicate.SoulDuplicate")
    app.load("client.red_alert.campaign.gemduplicate.GemDuplicate")
    app.load("client.red_alert.campaign.weaponry.Weaponry")
    app.load("client.red_alert.campaign.shipmilitaryuse.ShipMilitaryUse")
    app.load("client.red_alert.campaign.trialtower.Trialtower")
    app.load("client.red_alert.notification.push_notification_campaign_cell")
    app.load("client.red_alert.big_map.MapRattlingRanking")
    app.load("client.red_alert.big_map.MapRattling")
    
    

    -- Initialize DuplicateTitle state machine.
    local function init_campaign_terminal()
	
        --
        local campaign_click_child_page_terminal = {
            _name = "campaign_click_child_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --1 资源点，2 镖车，3 守卫襄阳，4 装备，5 宝石，6 一代宗师， 7 侠客行
                local id = params._datas.cell.id
                if id == 1 then
                    -- 八点之前点击提示未开启
                    local server_time = _ED.system_time + (os.time() - _ED.native_time)
                    server_time = os.date("*t", zstring.tonumber(server_time))
                    if server_time.hour < 8 then
                        TipDlg.drawTextDailog(red_alert_all_str[136])
                        return
                    end
                    local function enterMapRattling( city_id )
                        local function responseCallback( response )
                            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                local info = _ED.city_resource_hold_resource_infos[1]
                                local function responseCallback1( response )
                                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                                        state_machine.excute("map_rattling_window_open", 0, {info.city_id, info.mould_id, 1})
                                    end
                                end
                                protocol_command.city_resource_hold_get_resource_users.param_list = info.city_id.."\r\n"..info.id
                                NetworkManager:register(protocol_command.city_resource_hold_get_resource_users.code, nil, nil, nil, nil, responseCallback1, false, nil)
                            end
                        end
                        protocol_command.city_resource_hold_get_city_resource.param_list = city_id
                        NetworkManager:register(protocol_command.city_resource_hold_get_city_resource.code, nil, nil, nil, nil, responseCallback, false, nil)
                    end

                    local function responseholdInit( response )
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if _ED.city_resource_user_info == nil or tonumber(_ED.city_resource_user_info.my_city_id) <= 0 then
                                state_machine.excute("map_rattling_window_open", 0, {0, 0, 0})
                            else
                                enterMapRattling(tonumber(_ED.city_resource_user_info.my_city_id))
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.city_resource_hold_init.code, nil, nil, nil, nil, responseholdInit, false, nil)
                elseif id == 2 then
                    state_machine.excute("ship_military_use_window_open",0,"")
                elseif id == 3 then
                    state_machine.excute("raiders_cut_window_open",0,"")
                elseif id == 4 then
                    state_machine.excute("weaponry_window_open",0,"")
                elseif id == 5 then
                    state_machine.excute("gem_duplicate_window_open",0,"")
                elseif id == 6 then
                    state_machine.excute("soul_duplicate_window_open",0,"")
                elseif id == 7 then
                    state_machine.excute("trialtower_window_open",0,"")
                    
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --
        local campaign_window_show_terminal = {
            _name = "campaign_window_show",
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
        --
        local campaign_window_hide_terminal = {
            _name = "campaign_window_hide",
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

        --刷新日常副本列表
        local campaign_updatedraw_cell_terminal = {
            _name = "campaign_updatedraw_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local id = params[1]
                instance:UpdateDrawCell(id)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }    
        state_machine.add(campaign_click_child_page_terminal)
        state_machine.add(campaign_window_show_terminal)
        state_machine.add(campaign_window_hide_terminal)
        state_machine.add(campaign_updatedraw_cell_terminal)
        state_machine.init()
    end
    
    init_campaign_terminal()
end

function Campaign:onHide( ... )
    self:setVisible(false)
end

function Campaign:onShow( ... )
    self:setVisible(true)
end

function Campaign:UpdateDrawCell(id)
    local root = self.roots[1]
    local ListView_campaign = ccui.Helper:seekWidgetByName(root,"ListView_campaign")
    for i,cell in pairs(ListView_campaign:getItems()) do
        if cell ~= nil and cell.onUpdateDraw and id == cell.id then
            cell:onUpdateDraw()
        end
    end
end

function Campaign:onUpdateDraw()
    local root = self.roots[1]
    local ListView_campaign = ccui.Helper:seekWidgetByName(root,"ListView_campaign")
    ListView_campaign:removeAllItems()
    for i=1,7 do
        local cell = state_machine.excute("campaign_create_cell",0,{i})
        ListView_campaign:addChild(cell)
    end
    ListView_campaign:requestRefreshView()
end

function Campaign:onEnterTransitionFinish()

end

function Campaign:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.campaign)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_campaign_back"), nil, 
    {
        terminal_name = "campaign_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end


function Campaign:init()
	self:onInit()
    return self
end

function Campaign:onExit()
    state_machine.remove("campaign_click_child_page")
    state_machine.remove("campaign_window_show")
    state_machine.remove("campaign_window_hide")
    state_machine.remove("campaign_updatedraw_cell")
end
