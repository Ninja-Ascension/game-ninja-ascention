-----------------------------
--斩将夺宝
-----------------------------
RaidersCut = class("RaidersCutClass", Window)

local raiders_cut_window_open_terminal = {
    _name = "raiders_cut_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(129) == true then
            return
        end  
        if nil == fwin:find("RaidersCutClass") then
            fwin:open(RaidersCut:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local raiders_cut_window_close_terminal = {
    _name = "raiders_cut_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RaidersCutClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(raiders_cut_window_open_terminal)
state_machine.add(raiders_cut_window_close_terminal)
state_machine.init()

function RaidersCut:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.need_silver = nil

    --load lua file
    app.load("client.red_alert.cells.campaign.raiderscut.raiders_cut_reward_cell")
    -- Initialize raiders_cut state machine.
    local function init_raiders_cut_terminal()
	
		--刷新
		local raiders_cut_change_npc_terminal = {
            _name = "raiders_cut_change_npc",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                --todo 请求改变npc
                local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)
                if _ED.raiders_cut_attack_times >= max_attack_times then
                    TipDlg.drawTextDailog(daily_string[15])
                    return
                end

                if zstring.tonumber(self.need_silver) > zstring.tonumber(_ED.user_info.user_silver) then
                    TipDlg.drawTextDailog(red_alert_all_str[80])
                    return
                end
                
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("raiders_cut_play_change_actions",0,"")
                    end
                end
                NetworkManager:register(protocol_command.raiders_cut_refrush.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --播放动画
        local raiders_cut_play_change_actions_terminal = {
            _name = "raiders_cut_play_change_actions",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:playChangeActions()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --攻击 挑战
        local raiders_cut_attack_terminal = {
            _name = "raiders_cut_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local index = params._datas.index
                local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)
                if _ED.raiders_cut_attack_times >= max_attack_times then
                    TipDlg.drawTextDailog(daily_string[9])
                    return
                end
                app.load("client.red_alert.battle.battle_enum")
                local scene_npc_tab = dms.string(dms["raiders_cut_config"],8,raiders_cut_config.param)
                scene_npc_tab = zstring.split(scene_npc_tab,",")
                local scene_id = tonumber(scene_npc_tab[1])
                local npc_id = tonumber(scene_npc_tab[2])
                
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._npc_difficulty_index = "1"
                _ED.show_reward_list_group = {}
                _ED.last_level = _ED.user_info.user_grade
                _ED.last_user_food = "".. (zstring.tonumber(_ED.user_info.user_food) - zstring.tonumber(instance.need_food))
                _ED._battle_init_type = battle_enum._fight_type._fight_type_10
                _ED.attack_user_id = _ED.raiders_user_info[index].user_id
                _ED.raiders_cut_id = _ED.raiders_user_info[index].raider_id
                -- debug.print_r(_ED.raiders_user_info)
                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.battle_result_verify.param_list = "" .. _ED.raiders_cut_id
                        app.load("client.red_alert.battle.battle_loading")
                        state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_10)                                            
                    end
                end
                -- print("================",_ED.raiders_cut_id,index)
                protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_10.."\r\n".."1".."\r\n".._ED.attack_user_id
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(raiders_cut_change_npc_terminal)
        state_machine.add(raiders_cut_play_change_actions_terminal)
        state_machine.add(raiders_cut_attack_terminal)
        state_machine.init()
    end
    
    -- call func init raiders_cut state machine.
    init_raiders_cut_terminal()
end

function RaidersCut:playChangeActions()
    local action = self.actions[1]
    action:setTimeSpeed(app.getTimeSpeed())
    action:play("change_npc", false)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "change_npc_refresh" then
            self:onUpdateDraw()
        end
    end)
end

function RaidersCut:onUpdateDraw()
    local root = self.roots[1]
    
    for i,v in pairs(_ED.raiders_user_info) do
        local Panel_player_header = ccui.Helper:seekWidgetByName(root,"Panel_player_header_"..i) -- 头像
        Panel_player_header:removeAllChildren(true)
        local Text_player_name = ccui.Helper:seekWidgetByName(root,"Text_player_name_"..i)--名字
        local Text_combat_number = ccui.Helper:seekWidgetByName(root,"Text_combat_number_"..i) -- 战力
        local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i) -- 奖励

        local head_icon = state_machine.excute("user_head_icon_create",0,{v,1})
        Panel_player_header:addChild(head_icon)
        Text_player_name:setString(v.user_name)
        Text_combat_number:setString(v.user_fight)

        local Panel_star = ccui.Helper:seekWidgetByName(root,"Panel_star_"..i)
        Panel_star:removeAllChildren(true)
        self:drawStars(tonumber(v.star_numbers),"images/ui/state/pve_star.png",Panel_star)

        local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
        Panel_reward:removeAllChildren(true)
        local reward_cell = state_machine.excute("raiders_cut_reward_create_cell",0,{v,0})
        Panel_reward:addChild(reward_cell)
    end


    local refrush_times = _ED.raiders_cut_reset_times
    local base_need_silver = dms.int(dms["raiders_cut_config"],1,raiders_cut_config.param)
    local grow_up_silver = dms.int(dms["raiders_cut_config"],2,raiders_cut_config.param)
    local max_silver = dms.int(dms["raiders_cut_config"],3,raiders_cut_config.param)
    local max_attack_times = dms.int(dms["raiders_cut_config"],4,raiders_cut_config.param)
    
    local need_silver = math.min(max_silver,base_need_silver * math.floor(1 / ( refrush_times + 1 )) + refrush_times * grow_up_silver)
    self.need_silver = need_silver
    local Text_spend = ccui.Helper:seekWidgetByName(root,"Text_spend")
    Text_spend:setString(need_silver)
    
    local Text_last_time_number = ccui.Helper:seekWidgetByName(root,"Text_last_time_number")
    Text_last_time_number:setString(max_attack_times - _ED.raiders_cut_attack_times)
end


function RaidersCut:drawStars(stars_number,image_path,panel)
    local sprite_star = cc.Sprite:create(image_path)
    local star_size = sprite_star:getContentSize()
    panel:setContentSize(cc.size(star_size.width*stars_number,star_size.height))
    -- debug.print_r(panel:getContentSize())
    for i=1,stars_number do
        local star = cc.Sprite:create(image_path)
        star:setAnchorPoint(cc.p(0, 0.5))
        star:setPositionX(panel:getContentSize().width/stars_number *(i-1))
        panel:addChild(star)
    end
end

function RaidersCut:onEnterTransitionFinish()
    self:checkReward()
end

function RaidersCut:checkReward()
    state_machine.excute("reward_obtain_window_open",0,{68})
end

function RaidersCut:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.raiderscut.raiders_cut)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.campaign.raiderscut.raiders_cut)
    table.insert(self.actions, action)

    csbItem:runAction(action)

    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "change_npc_infor" then
            self:onUpdateDraw()
        end  
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "raiders_cut_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --改变玩家
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_change"), nil, 
    {
        terminal_name = "raiders_cut_change_npc", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    
    for i = 1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Attack_button_"..i), nil, 
        {
            terminal_name = "raiders_cut_attack", 
            terminal_state = 0, 
            touch_scale = true,
            touch_scale_xy = 0.95, 
            index = i,
        }, nil, 0)
    end
	self:onUpdateDraw()	
end

function RaidersCut:init()
	self:onInit()
    return self
end

function RaidersCut:onExit()
    state_machine.remove("raiders_cut_change_npc")
    state_machine.remove("raiders_cut_play_change_actions")
    state_machine.remove("raiders_cut_attack")
end
