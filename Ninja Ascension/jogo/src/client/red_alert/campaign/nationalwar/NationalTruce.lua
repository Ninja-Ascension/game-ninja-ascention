-----------------------------
--国战进入界面
-----------------------------
NationalTruce = class("NationalTruceClass", Window)

local national_truce_open_terminal = {
    _name = "national_truce_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("NationalTruceClass")
        if nil == _Window then
            fwin:open(NationalTruce:new():init(), fwin._view)
        end
        state_machine.excute("player_resource_window_hide", 0, "")     
        state_machine.excute("campaign_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local national_truce_close_terminal = {
    _name = "national_truce_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("NationalTruceClass"))
        if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
            fwin:close(fwin:find("CampaignClass"))
            fwin:cleanView(fwin._view)
            if fwin:find("MenuClass") == nil then
                fwin:open(Menu:new(), fwin._taskbar)
            end
            if fwin:find("HomeClass") == nil then
                state_machine.excute("menu_manager", 0, 
                    {
                        _datas = {
                            terminal_name = "menu_manager",     
                            next_terminal_name = "menu_show_home_page", 
                            current_button_name = "Button_home",
                            but_image = "Image_home",       
                            terminal_state = 0, 
                            isPressedActionEnabled = true
                        }
                    }
                )
            end                
            state_machine.excute("menu_back_home_page", 0, "")
            state_machine.excute("menu_clean_page_state", 0, "")
        else
            state_machine.excute("player_resource_window_show", 0, "")     
            state_machine.excute("campaign_window_open",0,"")     
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(national_truce_open_terminal)
state_machine.add(national_truce_close_terminal)
state_machine.init()

function NationalTruce:ctor()
    self.super:ctor()
    self.roots = {}
    self.last_time = nil
    app.load("client.red_alert.campaign.nationalwar.NationalRank")
    app.load("client.red_alert.campaign.nationalwar.NationalTask")
    app.load("client.red_alert.campaign.nationalwar.NationalWarShop")
    app.load("client.red_alert.campaign.nationalwar.NationalWarVictoryReward")

    if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  then
        app.load("client.notification.push_notification_war_fight")
    end
    -- Initialize national_truce state machine.
    local function init_national_truce_terminal()
        -- 开始
        local national_truce_enter_terminal = {
            _name = "national_truce_enter",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                -- print("进入国战地图")
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("national_truce_loading_window_open",0,{_datas = {open_type = 2, open_info = true}})
                    end
                end
                NetworkManager:register(protocol_command.join_warfare.code, nil, nil, nil,instance, responseCallback, false, nil)
                
                -- TipDlg.drawTextDailog(_function_unopened_tip_string)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 
        state_machine.add(national_truce_enter_terminal)    
        state_machine.init()
    end
    
    -- call func init rebirth state machine.
    init_national_truce_terminal()
end


function NationalTruce:onUpdateDraw()
    local root = self.roots[1]
    local Button_national_truce_begin = ccui.Helper:seekWidgetByName(root,"Button_national_truce_begin")
    local Text_national_truce_out = ccui.Helper:seekWidgetByName(root,"Text_national_truce_out")
    local Text_national_truce_in = ccui.Helper:seekWidgetByName(root,"Text_national_truce_in")
    if _ED.warfar_is_open == 0 then
        Button_national_truce_begin:setBright(false)
        Button_national_truce_begin:setTouchEnabled(false)
        Text_national_truce_out:setVisible(true)
        Text_national_truce_in:setVisible(false)
    else
        Button_national_truce_begin:setBright(true)
        Button_national_truce_begin:setTouchEnabled(true)
        Text_national_truce_out:setVisible(false)
        Text_national_truce_in:setVisible(true)
    end 
end
function NationalTruce:onUpdate(dt)
    local now_time = os.time()
    if now_time > zstring.tonumber(self.last_time) + 5 then  
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                    response.node:onUpdateDraw()
                end
            end
        end
        self.last_time = now_time
        if _ED.warfar_is_open == 0 then
            NetworkManager:register(protocol_command.get_warfare_task.code, nil, nil, nil,self, responseCallback, false, nil)        
        end
    end

end

function NationalTruce:onUpdateDrawDec()
    local root = self.roots[1]
    local ListView_national_truce = ccui.Helper:seekWidgetByName(root,"ListView_national_truce")
    local text_font_size = 20
    local text_one_height = 30
    local text_width = ListView_national_truce:getContentSize().width
    for i,v in pairs(national_truce_dec) do
        local panel = ccui.Layout:create()
        panel:setAnchorPoint(cc.p(0, 0))
        
        local cell_title = cc.Label:createWithTTF(v[1], config_csb.campaign.nationalwar_font, text_font_size,cc.size(text_width - text_font_size*5, 0), 
                cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        cell_title:setAnchorPoint(cc.p(0, 0))
        cell_title:setColor(cc.c3b(color_Type[14][1],color_Type[14][2],color_Type[14][3]))
        local cell = cc.Label:createWithTTF(v[2], config_csb.campaign.nationalwar_font, text_font_size,cc.size(text_width - text_font_size*5, 0), 
                cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
        cell:setAnchorPoint(cc.p(0, 0))
        cell:setPositionX(text_font_size*4)
        -- print("===========",cell:getPositionY())
        
        cell:setColor(cc.c3b(color_Type[15][1],color_Type[15][2],color_Type[15][3]))
        local text_str_number = tonumber(cell:getStringLength())
        if text_str_number > 88 then
            panel:setContentSize(cc.size(text_width,text_one_height*5))     
        elseif text_str_number > 66 then
            panel:setContentSize(cc.size(text_width,text_one_height*4))
        elseif text_str_number > 44 then
            panel:setContentSize(cc.size(text_width,text_one_height*3))
        elseif text_str_number > 22 then
            panel:setContentSize(cc.size(text_width,text_one_height*2))
        elseif text_str_number > 0 then
            panel:setContentSize(cc.size(text_width,text_one_height))
        end
        -- print("================",v[1],cell:getStringLength(),cell:getContentSize().width,cell:getContentSize().height)
        -- debug.print_r(panel:getContentSize())
        cell_title:setPositionY(panel:getContentSize().height - cell_title:getContentSize().height)
        cell:setPositionY(panel:getContentSize().height - cell:getContentSize().height)
        panel:addChild(cell_title)
        panel:addChild(cell)
        
        ListView_national_truce:addChild(panel)
    end
    ListView_national_truce:requestRefreshView()


    local is_league = false
    local city_camp = 0
    if _ED.war_rank_info.country == nil then
        _ED.war_rank_info.country = {}
    end
    for i,v in ipairs(_ED.war_rank_info.country) do
        if zstring.tonumber(v.rank_league) > 0 then
            is_league = true
        end
        if zstring.tonumber(v.rank_league) <= 0 then
            city_camp = tonumber(v.rank_camp)
        end
        -- print("==ca=====",zstring.tonumber(v.rank_league))
    end

    local Text_national_truce_time = ccui.Helper:seekWidgetByName(root,"Text_national_truce_time")
    local Image_national_truce_4 = ccui.Helper:seekWidgetByName(root,"Image_national_truce_4")

    Text_national_truce_time:setString("")
    Image_national_truce_4:setVisible(false)
    -- "群魔乱舞，罗刹白莲围剿龙虎",                                            ------------------58
    -- "天地色变，龙虎白莲决战罗刹",                                            ------------------59
    -- "异军突起，龙虎罗刹奇袭白莲",                                            ------------------60
    -- "开服五日后，势力战开启",                                                ------------------69

    -- print("0000000000000000000000",_ED.open_server_days)
    -- print("0000000000000000000000",dms.int(dms["warfare_config"], 20 , warfare_config.param))
    if _ED.open_server_days ~= nil and _ED.open_server_days < dms.int(dms["warfare_config"], 20 , warfare_config.param) then
        Image_national_truce_4:setVisible(true)
        Text_national_truce_time:setString(red_alert_all_str[69])
    else
        if is_league == true then
            Image_national_truce_4:setVisible(true)
            -- print("==ca=====",city_camp)
            if city_camp == 1 then
                Text_national_truce_time:setString(red_alert_all_str[58])
            elseif city_camp == 2 then
                Text_national_truce_time:setString(red_alert_all_str[59])
            elseif city_camp == 3 then            
                Text_national_truce_time:setString(red_alert_all_str[60])
            end 
        end
    end
end

function NationalTruce:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.nationalwar.national_truce)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    self.open_state = _ED.warfar_is_open
    --关闭

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_national_truce_back"), nil, 
    {
        terminal_name = "national_truce_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 开始
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_truce_begin"), nil, 
    {
        terminal_name = "national_truce_enter",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 军功商店
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_shop"), nil, 
    {
        terminal_name = "national_war_shop_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
   
    -- 排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_truce_ranking"), nil, 
    {
        terminal_name = "national_rank_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 任务
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_truce_task"), nil, 
    {
        terminal_name = "national_task_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 任务推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_war_fight_of_task",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_national_truce_task"),
        _invoke = nil,
        _interval = 0.5,}) 

    --奖励领取
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_national_reward"), nil, 
    {
        terminal_name = "nationalwar_victory_reward_window_open",
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 奖励推送
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_war_fight_of_reward",
        _widget = ccui.Helper:seekWidgetByName(root, "Button_national_reward"),
        _invoke = nil,
        _interval = 0.5,}) 
    
    self:onUpdateDraw() 
    self:onUpdateDrawDec()
end

function NationalTruce:init()
    self:onInit()
    return self
end

function NationalTruce:onExit()
    state_machine.remove("national_truce_enter")
end

