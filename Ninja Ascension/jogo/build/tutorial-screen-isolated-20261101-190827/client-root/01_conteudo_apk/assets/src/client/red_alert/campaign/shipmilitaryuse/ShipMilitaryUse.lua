-----------------------------
--运送军资
-----------------------------
ShipMilitaryUse = class("ShipMilitaryUseClass", Window)

local ship_military_use_window_open_terminal = {
    _name = "ship_military_use_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(120) == true then
            return
        end
        local function responseCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if nil == fwin:find("ShipMilitaryUseClass") then
                    fwin:open(ShipMilitaryUse:new():init(), fwin._view)
                end
                state_machine.excute("campaign_window_hide",0,"")
                state_machine.excute("chat_view_window_show",0,"")
                state_machine.excute("player_resource_window_hide",0,"")
                state_machine.excute("home_button_for_action_window_hide",0,"") 
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

local ship_military_use_window_close_terminal = {
    _name = "ship_military_use_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ShipMilitaryUseClass"))
        if fwin:find("TaskClass") ~= nil then
            state_machine.excute("campaign_window_close",0,"") 
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("duplicate_title_window_hide",0,"")  
            state_machine.excute("duplicate_map_window_hide",0,"")   
            state_machine.excute("duplicate_manager_window_hide",0,"")   
            state_machine.excute("seven_star_map_ui_window_hide",0,"")
        elseif fwin:find("HeroMainClass") ~= nil then
            state_machine.excute("campaign_window_close",0,"") 
            state_machine.excute("task_window_show",0,"") 
            state_machine.excute("player_resource_window_hide",0,"") 
            state_machine.excute("home_button_for_action_window_hide",0,"") 
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("duplicate_title_window_hide",0,"")  
            state_machine.excute("duplicate_map_window_hide",0,"")   
            state_machine.excute("duplicate_manager_window_hide",0,"")   
        else
            state_machine.excute("campaign_window_open",0,"")
            state_machine.excute("chat_view_window_hide",0,"")
            state_machine.excute("player_resource_window_show",0,"")
        end
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ship_military_use_window_open_terminal)
state_machine.add(ship_military_use_window_close_terminal)
state_machine.init()

function ShipMilitaryUse:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert.campaign.shipmilitaryuse.ShipMilitarySelect")
    app.load("client.red_alert.campaign.shipmilitaryuse.ShipGrand")
    app.load("client.red_alert.cells.campaign.shipmilitaryuse.ship_military_use_cell")
    app.load("client.red_alert.campaign.shipmilitaryuse.ShipMilitaryAttack")
    app.load("client.utils.ConfirmTip")
    
    -- var
    --剩余运送时间
    self.level_time = nil

    --上次刷新时间 
    self.last_time = nil

    --显示隐藏本国参数
    self.show_same_country = 1 -- 0不显示 1 显示

    --马cell
    self.horse_cells = {}

    --上下区间
    self.pos_max = {}

    --每排最多几匹马
    self.col = 3

    --移动距离
    self.move_max = nil

    --上次马刷新时间
    self.last_horse_time = nil

    -- Initialize ship_military_use state machine.
    local function init_ship_military_use_terminal()
        --检测运送军资完毕
        local ship_military_use_check_finish_terminal = {
            _name = "ship_military_use_check_finish",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.lock("ship_military_use_check_finish")
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then    
                        if _ED.transport_resouce_info.is_transport == 0 then
                            state_machine.excute("reward_obtain_window_open",0,{70})
                            state_machine.excute("ship_military_use_remove_my_horses",0,"")
                        end
                        state_machine.excute("ship_military_use_update_draw",0,"")
                        state_machine.unlock("ship_military_use_check_finish")
                    else
                        state_machine.excute("ship_military_use_update_draw",0,"")
                        state_machine.unlock("ship_military_use_check_finish")
                    end
                end
                NetworkManager:register(protocol_command.ship_military_check_transport_end.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        -- 加速
        local ship_military_use_speed_up_terminal = {
            _name = "ship_military_use_speed_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local need_gold = math.abs(math.ceil(math.ceil(_ED.transport_resouce_info.now_leave_time)/60.0/2/10)*10)
                if need_gold > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end

                local tip = ConfirmTip:new()
                local info = string.format(red_alert_all_str[142],need_gold)
                tip:init(instance, instance.sureSpeedUp, info)
                fwin:open(tip,fwin._windows) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 换一批
        local ship_military_use_change_terminal = {
            _name = "ship_military_use_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then    
                        state_machine.excute("ship_military_use_update_horses",0,"")
                    end
                end
                NetworkManager:register(protocol_command.ship_military_change_users.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        -- 加速
        local ship_military_use_speed_up_terminal = {
            _name = "ship_military_use_speed_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local need_gold = math.abs(math.ceil(math.ceil(_ED.transport_resouce_info.now_leave_time)/60.0/2/10)*10)
                if need_gold > tonumber(_ED.user_info.user_gold) then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end

                local tip = ConfirmTip:new()
                local info = string.format(red_alert_all_str[142],need_gold)
                tip:init(instance, instance.sureSpeedUp, info)
                fwin:open(tip,fwin._windows) 

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local ship_military_use_add_times_terminal = {
            _name = "ship_military_use_add_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local config_count_cost = dms.string(dms["ship_military_config"],13,ship_military_config.param)
                config_count_cost = zstring.split(config_count_cost,",")

                local need_gem = 0
                local count = _ED.transport_resouce_info.buy_count + 1
                if count > #config_count_cost then
                    need_gem = tonumber(config_count_cost[#config_count_cost])
                else
                    need_gem = tonumber(config_count_cost[count])
                end
                if tonumber(_ED.user_info.user_gold) <= need_gem then
                    TipDlg.drawTextDailog(red_alert_all_str[79])
                    return
                end

                local tip = ConfirmTip:new()

                local info = string.format(red_alert_all_str[213],need_gem)
                
                tip:init(instance, instance.buyCount, info)
                fwin:open(tip,fwin._windows)                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 显示隐藏本国
        local ship_military_use_show_or_hidden_my_country_terminal = {
            _name = "ship_military_use_show_or_hidden_my_country",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local show_index = params._datas.show_index
                instance.show_same_country = show_index
                if instance.show_same_country == 0 then
                    instance:HideMyCountry()
                elseif instance.show_same_country == 1 then
                    instance:ShowMyCountry()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 刷新绘制
        local ship_military_use_update_draw_terminal = {
            _name = "ship_military_use_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        } 

        -- 刷新马匹绘制
        local ship_military_use_update_horses_terminal = {
            _name = "ship_military_use_update_horses",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:drawHorses()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 移除自己的马匹
        local ship_military_use_remove_my_horses_terminal = {
            _name = "ship_military_use_remove_my_horses",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:removeMyHorse()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }     
        state_machine.add(ship_military_use_check_finish_terminal)
        state_machine.add(ship_military_use_speed_up_terminal)
        state_machine.add(ship_military_use_change_terminal)
        state_machine.add(ship_military_use_add_times_terminal)
        state_machine.add(ship_military_use_show_or_hidden_my_country_terminal)
        state_machine.add(ship_military_use_update_draw_terminal)
        state_machine.add(ship_military_use_update_horses_terminal)
        state_machine.add(ship_military_use_remove_my_horses_terminal)
        state_machine.init()
    end
    
    -- call func ship_military_use state machine.
    init_ship_military_use_terminal()
end

function ShipMilitaryUse:buyCount(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.onUpdateDrawAttackCount ~= nil then
                response.node:onUpdateDraw()
            end
        end
    end
    if sure_number == 0 then
        -- protocol_command.ship_military_buyrob_count.param_list = "0"
        NetworkManager:register(protocol_command.ship_military_buyrob_count.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function ShipMilitaryUse:onUpdateDrawAttackCount()
    local root = self.roots[1]
    local Text_lasting_number = ccui.Helper:seekWidgetByName(root,"Text_lasting_number") -- 剩余次数
    local max_times = dms.int(dms["arena_config"],1,arena_config.param)
    Text_lasting_number:setString(_ED.transport_resouce_info.leave_attack_times .. "/".. max_times)
end

--加速
function ShipMilitaryUse:sureSpeedUp(sure_number)
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.onUpdateDraw ~= nil then
                state_machine.excute("ship_military_use_update_draw",0,"")
                state_machine.excute("ship_military_use_remove_my_horses",0,"")
                state_machine.excute("reward_obtain_window_open",0,{70})
                playEffect(formatMusicFile("effect", 10015))
            end
        end
    end

    if sure_number == 0 then
       NetworkManager:register(protocol_command.ship_military_speed_transport.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function ShipMilitaryUse:ShowMyCountry()
    local root = self.roots[1]
    local Button_hide_national = ccui.Helper:seekWidgetByName(root,"Button_hide_national")
    local Button_show_same_national = ccui.Helper:seekWidgetByName(root,"Button_show_same_national")
    Button_hide_national:setVisible(true)
    Button_show_same_national:setVisible(false)

    for i,cell in pairs(self.horse_cells) do
        if tonumber(cell.user_info.user_camp) == tonumber(_ED.user_info.user_force) then
            cell:setVisible(true)
        end
    end 
end

function ShipMilitaryUse:HideMyCountry()
    local root = self.roots[1]
    local Button_hide_national = ccui.Helper:seekWidgetByName(root,"Button_hide_national")
    local Button_show_same_national = ccui.Helper:seekWidgetByName(root,"Button_show_same_national")    
    Button_hide_national:setVisible(false)
    Button_show_same_national:setVisible(true)   

    for i,cell in pairs(self.horse_cells) do
        if tonumber(cell.user_info.user_camp) == tonumber(_ED.user_info.user_force) then
            cell:setVisible(false)
        end
    end 
end

function ShipMilitaryUse:onEnterTransitionFinish()
    self:checkRobReward()
    local reward_data = nil
    local function responseCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            reward_data = getSceneReward(70) 
            if reward_data ~= nil then
                state_machine.excute("reward_obtain_window_open",0,{nil,reward_data})
                state_machine.excute("ship_military_use_remove_my_horses",0,"")
                state_machine.excute("ship_military_use_update_draw",0,"")
            end
        end
    end
    NetworkManager:register(protocol_command.ship_military_check_transport_end.code, nil, nil, nil, nil, responseCallback, false, nil)
end

function ShipMilitaryUse:checkRobReward()
    state_machine.excute("reward_obtain_window_open",0,{71})
end

function ShipMilitaryUse:onInit()
    -- 运送军资地图动画资源加载
    for i, v in pairs(config_res.sprites_cached["ship_military"]) do
        cc.SpriteFrameCache:getInstance():addSpriteFrames(v)
    end
    local effect_paths = config_res.images.ui.effice.effice_ship_bg
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)
    
    local csbItem = csb.createNode(config_csb.campaign.shipmilitaryuse.ship_military_use)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "ship_military_use_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 换一批
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_change"), nil, 
    {
        terminal_name = "ship_military_use_change", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 加速
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_go_on"), nil, 
    {
        terminal_name = "ship_military_use_speed_up", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 战报
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_grand"), nil, 
    {
        terminal_name = "ship_grand_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    -- 运镖
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_transport"), nil, 
    {
        terminal_name = "ship_military_select_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --显示本国
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_show_same_national"), nil, 
    {
        terminal_name = "ship_military_use_show_or_hidden_my_country", 
        terminal_state = 0, 
        show_index = 1,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
  
    --隐藏本国
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_hide_national"), nil, 
    {
        terminal_name = "ship_military_use_show_or_hidden_my_country", 
        terminal_state = 0, 
        show_index = 0,
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add_time"), nil, 
    {
        terminal_name = "ship_military_use_add_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)  

	self:onUpdateDraw()	
    state_machine.excute("ship_military_use_show_or_hidden_my_country",0,{_datas = { show_index = 1}})

    local function drawHorse()
        self:drawHorses()
    end 
    local action = cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(drawHorse))
    self:runAction(action)  
end

function ShipMilitaryUse:onUpdateDraw()
    local root = self.roots[1]
    local Text_transport_number = ccui.Helper:seekWidgetByName(root,"Text_transport_number") --剩余运送次数
    Text_transport_number:setString(_ED.transport_resouce_info.leave_tran_times)
    local Text_plunder_number = ccui.Helper:seekWidgetByName(root,"Text_plunder_number") -- 剩余攻击次数
    Text_plunder_number:setString(_ED.transport_resouce_info.leave_attack_times)

    local Button_transport = ccui.Helper:seekWidgetByName(root,"Button_transport") --运送军资
    local Panel_leave_attack_times = ccui.Helper:seekWidgetByName(root,"Panel_leave_attack_times") -- 当前运送剩余时间层

    local Text_time = ccui.Helper:seekWidgetByName(root,"Text_time") -- 剩余时间
    self.leave_time = Text_time:setString(self:formatTimeString(_ED.transport_resouce_info.now_leave_time))

    if zstring.tonumber(_ED.transport_resouce_info.is_transport) == 0 then
        Button_transport:setVisible(true)
        Panel_leave_attack_times:setVisible(false)
    elseif zstring.tonumber(_ED.transport_resouce_info.is_transport) == 1 then
        Button_transport:setVisible(false)
        Panel_leave_attack_times:setVisible(true)
    end

end

function ShipMilitaryUse:removeMyHorse()
    for i,horse_cell in pairs(self.horse_cells) do
        if horse_cell.user_id == _ED.user_info.user_id then
            horse_cell:removeFromParent()
            table.remove(self.horse_cells,i)
        end
    end
end

function ShipMilitaryUse:drawHorses()
    local root = self.roots[1]

    local col = self.col --一共分三排

    local getHorsePosition = nil
    local moveToStart = nil
    local runToEnd = nil

    local Panel_horse = ccui.Helper:seekWidgetByName(root,"Panel_horse")
    Panel_horse:removeAllChildren(true)

    local csbItem = csb.createNode(config_csb.cells.campaign.shipmilitrayuse.ship_military_use_cell)
    local horse_root = csbItem:getChildByName("root")

    local panel_size = Panel_horse:getContentSize()
    local panel_height = panel_size.height - horse_root:getContentSize().height
    local panel_width = panel_size.width

    local pos_max = {}
    for i = 1,col + 1 do
        pos_max[i] = math.floor(panel_height*(i-1)/col)
    end

    self.move_max = panel_size.width
    getHorsePosition = function(heght_index)
        local x = math.random(pos_max[heght_index],pos_max[heght_index+1])
        return x
    end

    moveToStart = function(sender)
        local horse_run_action = cc.RepeatForever:create(
            cc.Sequence:create(
                cc.MoveTo:create(sender:getPositionX()/5,cc.p(0,sender.y))
                )
            )
        sender:runAction()
    end

    runToEnd = function(sender)
       
    end
    self.horse_cells = {}
    for i,v in pairs(_ED.transport_resouce_user_infos) do

        local leave_time = tonumber(v.leave_time) - (os.time() - tonumber(v.leave_time_os_time))
        if leave_time > 0 then
            local horse_cell = state_machine.excute("ship_military_use_create_cell",0,{v})
            
            local heght_index = i % col + 1
            pos_y = getHorsePosition(heght_index)
            -- print("======pos_y",pos_y)
            Panel_horse:addChild(horse_cell,panel_height-pos_y)
            if v.user_id == _ED.user_info.user_id then
                horse_cell:setPosition(cc.p(0,pos_y))  
            else
                horse_cell:setPosition(cc.p(math.random(0,panel_width/3),pos_y))
            end

            horse_cell.user_id = v.user_id

            table.insert(self.horse_cells,horse_cell)
            
            local horse_run_action = cc.MoveTo:create((horse_cell:getPositionX())/5,cc.p(0,pos_y))
            
            local my_horse_run_action = cc.MoveTo:create(self.move_max/2/110,cc.p(self.move_max/2,pos_y))

            if v.user_id == _ED.user_info.user_id then
                horse_cell:runAction(my_horse_run_action)
            else
                horse_cell:runAction(horse_run_action)
            end
        end
       
    end
    if self.show_same_country == 0 then
        self:HideMyCountry()
    elseif self.show_same_country == 1 then
        self:ShowMyCountry()
    end
end

function ShipMilitaryUse:onUpdateHorseRun()
    local now_time = os.time()
    if now_time - zstring.tonumber(self.last_horse_time) > 2 then
        for i,horse_cell in pairs(self.horse_cells) do
            -- print("==================",horse_cell:getPositionX())
            local start_length = math.random(20,180)
            if horse_cell.user_id ~= _ED.user_info.user_id then
                if horse_cell:getPositionX() < start_length then
                    local random_run_to_pos = math.random(self.move_max/2+1,self.move_max/2+100)
                    local horse_run_action = cc.MoveTo:create(random_run_to_pos/110,cc.p(random_run_to_pos,horse_cell:getPositionY()))
                    horse_cell:stopAllActions()
                    horse_cell:runAction(horse_run_action)
                end
                if horse_cell:getPositionX() >= self.move_max/2 then
                    local horse_run_action =  cc.MoveTo:create(horse_cell:getPositionX()/5,cc.p(0,horse_cell:getPositionY()))
                    horse_cell:stopAllActions()
                    horse_cell:runAction(horse_run_action)
                end
            else
                if horse_cell:getPositionX() >= self.move_max / 2 then
                    local horse_run_action = cc.MoveTo:create(horse_cell:getPositionX()/5,cc.p(0,horse_cell:getPositionY()))
                    horse_cell:stopAllActions()
                    horse_cell:runAction(horse_run_action)
                end
                if horse_cell:getPositionX() < start_length then
                    local random_run_to_pos = math.random(self.move_max/2+1,self.move_max/2+50)
                    local horse_run_action = cc.MoveTo:create(random_run_to_pos/110,cc.p(random_run_to_pos,horse_cell:getPositionY()))
                    horse_cell:stopAllActions()
                    horse_cell:runAction(horse_run_action)
                end
            end
        end
        self.last_horse_time = now_time
    end
end

function ShipMilitaryUse:onUpdateSportTime()
    local now_time = os.time()
    if self.leave_time ~= nil then
        if zstring.tonumber(_ED.transport_resouce_info.is_transport) == 1 then     
            if now_time - zstring.tonumber(self.last_time) >= 1 then
                local leave_time = _ED.transport_resouce_info.now_leave_time - (now_time - _ED.transport_resouce_info.now_leave_time_os_times)
                leave_time = math.max(0,leave_time)
                self.leave_time:setString(self:formatTimeString(leave_time))
                self.last_time = now_time

                if leave_time == 0 then
                    state_machine.excute("ship_military_use_check_finish",0,"")
                end
            end
        end
    end
end

function ShipMilitaryUse:onUpdate()
    self:onUpdateSportTime()
    self:onUpdateHorseRun()
end

function ShipMilitaryUse:formatTimeString(_time)    --系统时间转换
    local timeString = ""
    local now_time = math.max(tonumber(_time),0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end

function ShipMilitaryUse:init()
	self:onInit()
    return self
end

function ShipMilitaryUse:onExit()
    state_machine.remove("ship_military_use_check_finish")
    state_machine.remove("ship_military_use_speed_up")
    state_machine.remove("ship_military_use_change")
    state_machine.remove("ship_military_use_add_times")
    state_machine.remove("ship_military_use_show_or_hidden_my_country")
    state_machine.remove("ship_military_use_update_draw")
    state_machine.remove("ship_military_use_update_horses")
    state_machine.remove("ship_military_use_remove_my_horses")
end
