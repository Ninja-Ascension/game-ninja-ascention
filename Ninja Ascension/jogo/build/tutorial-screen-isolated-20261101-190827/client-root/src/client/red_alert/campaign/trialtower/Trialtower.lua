-----------------------------
--无双试炼
-----------------------------
Trialtower = class("TrialtowerClass", Window)

local trialtower_window_open_terminal = {
    _name = "trialtower_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)  
        if funOpenDrawTip(126) == true then
            return
        end    
        if nil == fwin:find("TrialtowerClass") then
            fwin:open(Trialtower:new():init(), fwin._view)
        end
        state_machine.excute("campaign_window_hide",0,"")
        state_machine.excute("player_resource_window_hide",0,"")
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local trialtower_window_close_terminal = {
    _name = "trialtower_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("TrialtowerClass"))
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
        else
            state_machine.excute("campaign_window_open",0,"")
            state_machine.excute("player_resource_window_show",0,"")
        end
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(trialtower_window_open_terminal)
state_machine.add(trialtower_window_close_terminal)
state_machine.init()

function Trialtower:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- load lua file
    app.load("client.red_alert.campaign.trialtower.TrialtowerReward")
    app.load("client.red_alert.campaign.trialtower.TrialtowerRanking")
    app.load("client.red_alert.campaign.trialtower.TrialtowerReinforcements")   
    app.load("client.red_alert.campaign.trialtower.TrialtowerRaids")
    app.load("client.red_alert.campaign.trialtower.TrialtowerPassReward")
    app.load("client.red_alert.cells.duplicate.duplicate_current_level_cell")
    app.load("client.red_alert.cells.campaign.trialtower.trialtower_npc_cell")
    -- var 
    -- --当前层数
    -- self.now_floor = nil
    -- --最大层数
    -- self.max_floor = nil
    -- --重置次数
    -- self.reset_times = nil
    --所有英雄动画
    self.heros = {}
    --奖励
    self.reward_data = nil

    self._choose_hero_ship = nil
    -- Initialize trialtower state machine.
    local function init_trialtower_terminal()
         --重置
        local trialtower_reset_terminal = {
            _name = "trialtower_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if self.reset_times == 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[119])
                    return
                end
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("trialtower_update_draw",0,"")
                    end
                end
                NetworkManager:register(protocol_command.three_kings_reset.code, nil, nil, nil, nil, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  
         --扫荡
        local trialtower_sweep_terminal = {
            _name = "trialtower_sweep",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local last_floor = _ED.three_kings_now_floor
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("trialtower_show_sweep_reward",0,{last_floor,_ED.three_kings_max_floor})
                        _ED.show_reward_list_group = {}
                    end
                end
                NetworkManager:register(protocol_command.three_kings_sweep.code, nil, nil, nil, nil, responseCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --显示扫荡奖励
        local trialtower_show_sweep_reward_terminal = {
            _name = "trialtower_show_sweep_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local last_floor = params[1]
                local now_floor = params[2]
                instance:showSweepReward(last_floor,now_floor)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        --刷新
        local trialtower_update_draw_terminal = {
            _name = "trialtower_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local pass_level = params[1]
                instance:onUpdateDraw(pass_level)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --英雄走向攻击点
        local trialtower_hero_attack_move_terminal = {
            _name = "trialtower_hero_attack_move",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._choose_hero_ship = params
                instance:heroAttackMove()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --英雄走向门口
        local trialtower_hero_go_out_terminal = {
            _name = "trialtower_hero_go_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:heroGoOut()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --英雄到达新的关卡
        local trialtower_hero_to_start_pos_terminal = {
            _name = "trialtower_hero_to_start_pos",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:heroToStartPos()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --选择援军
        local trialtower_select_partner_terminal = {
            _name = "trialtower_select_partner",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local partner_npc_id = dms.string(dms["three_kingdoms_config"],_ED.three_kings_now_floor,three_kingdoms_config.partner_npc_id)
                partner_npc_id = zstring.split(partner_npc_id,",")
                state_machine.excute("trialtower_reinforcements_window_open",0,{partner_npc_id})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --英雄停止移动
        local trialtower_hero_stop_run_terminal = {
            _name = "trialtower_hero_stop_run",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:heroStopRun()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(trialtower_reset_terminal)
        state_machine.add(trialtower_sweep_terminal)
        state_machine.add(trialtower_show_sweep_reward_terminal)
        state_machine.add(trialtower_update_draw_terminal)
        state_machine.add(trialtower_hero_attack_move_terminal)
        state_machine.add(trialtower_hero_go_out_terminal)
        state_machine.add(trialtower_hero_to_start_pos_terminal)
        state_machine.add(trialtower_select_partner_terminal)
        state_machine.add(trialtower_hero_stop_run_terminal)
        state_machine.init()
    end
    
    -- call func trialtower state machine.
    init_trialtower_terminal()
end

function Trialtower:showSweepReward(last_floor,now_floor)
    state_machine.excute("trialtower_raids_window_open",0,{last_floor,now_floor})
end

function Trialtower:onUpdateDraw(pass_level)
    local root = self.roots[1]
    local Text_boss_name = ccui.Helper:seekWidgetByName(root,"Text_boss_name") --第几关
    local Image_frist_reward = ccui.Helper:seekWidgetByName(root,"Image_frist_reward")  --首杀奖
    Image_frist_reward:setVisible(true)
    local Panel_enemy = ccui.Helper:seekWidgetByName(root,"Panel_enemy")
    Panel_enemy:setVisible(false)
    local now_floor =  0
    if pass_level == nil then
        now_floor = _ED.three_kings_now_floor
    else
        now_floor = _ED.three_kings_now_floor - 1
    end

    Text_boss_name:setString(now_floor)
    local ListView_reward = ccui.Helper:seekWidgetByName(root,"ListView_reward")
    ListView_reward:removeAllChildren(true)
    local npc_id = dms.int(dms["three_kingdoms_config"],now_floor,three_kingdoms_config.npc_id)
    local first_reward_id = dms.int(dms["three_kingdoms_config"],now_floor,three_kingdoms_config.first_reward_id)
    local reward_items = dms.string(dms["scene_reward"], first_reward_id, scene_reward.reward_items)
    if reward_items ~= nil then 
        reward_items = zstring.split(reward_items,"|")
        for i,reward in ipairs(reward_items) do
            local reward_tab = zstring.split(reward,",")
            local _prop_type = tonumber(reward_tab[2])
            local _prop_item = tonumber(reward_tab[1])
            local _item_value = tonumber(reward_tab[3])
            local data = 
            {
                item_value = _item_value,
                prop_type = _prop_type,
                prop_item = _prop_item,
            }
            local cell = state_machine.excute("all_resource_create_cell",0,{2,data,data,9,0,false,true})
            ListView_reward:addChild(cell)
        end
    end
    ListView_reward:requestRefreshView()

    local Text_reset_time = ccui.Helper:seekWidgetByName(root,"Text_reset_time") -- 重置次数
    local Image_reset_time = ccui.Helper:seekWidgetByName(root,"Image_reset_time") -- 重置背景
    local leave_times = dms.int(dms["base_consume"],51,base_consume.vip_0_value + tonumber(_ED.vip_grade)) - _ED.three_kings_reset_times
    Text_reset_time:setString(leave_times)

   
    local Button_reset = ccui.Helper:seekWidgetByName(root,"Button_reset")
    local Image_reset_time = ccui.Helper:seekWidgetByName(root,"Image_reset_time") -- 重置背景
    if dms.int(dms["base_consume"],51,base_consume.vip_0_value + tonumber(_ED.vip_grade)) > 0 then
        if leave_times > 0 then
            Image_reset_time:setVisible(true)
            Button_reset:setVisible(true)
        else
            Image_reset_time:setVisible(false)
            Button_reset:setVisible(false)
        end
    else
        Button_reset:setVisible(false)
        Image_reset_time:setVisible(false)
    end

    local run_action_npc  = cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(self.drawNpc))
    self:runAction(run_action_npc) 
end

function Trialtower:onEnterTransitionFinish()
    if self.reward_data ~= nil then
        self:playPassLevelAnimation()
    end
end

function Trialtower:playPassLevelAnimation()
    self:playBoxOpenPlayAnimation()
end

function Trialtower:playBoxOpenPlayAnimation()
    state_machine.excute("trialtower_pass_reward_window_open",0,{nil,self.reward_data})
end

function Trialtower:drawNpc()
    --创建npc形象
    if self.reward_data == nil then
        local npc_id = dms.int(dms["three_kingdoms_config"],_ED.three_kings_now_floor,three_kingdoms_config.npc_id)
        local root = self.roots[1]
        local Panel_enemy_role = ccui.Helper:seekWidgetByName(root,"Panel_enemy_role")
        Panel_enemy_role:removeAllChildren(true)
        -- local npc_cell = state_machine.excute("trialtower_npc_create_cell",0,{npc_id})
        -- Panel_enemy_role:addChild(npc_cell)
        local npc_name = dms.string(dms["npc"], npc_id, npc.npc_name)
        local Text_enemy_name = ccui.Helper:seekWidgetByName(root,"Text_enemy_name") 
        Text_enemy_name:setString(npc_name)
        app.load("client.battle.fight.FightEnum")
        local temp_bust_index = dms.int(dms["npc"], npc_id, npc.head_pic)
        temp_bust_index = 10000 + temp_bust_index
        local Panel_enemy = ccui.Helper:seekWidgetByName(root,"Panel_enemy")
        Panel_enemy:setVisible(true)
        local armature = sp.spine_sprite(Panel_enemy_role, temp_bust_index,_spine_sprite_animation_names[_enum_spine_animation_frame_index.animation_standby_dir_11+1], true, nil, nil, cc.p(0.5, 0))
        armature:setPosition(cc.p(Panel_enemy_role:getContentSize().width/2, 0))
        armature:setScaleX(-1)
        self:addCurrentLevel(Panel_enemy_role)
    end
end

--添加箭头
function Trialtower:addCurrentLevel(panle)
    local cell = state_machine.excute("duplicate_current_level_create_cell",0,"")
    local pos_y = cell:getPositionY()
    local height = panle:getContentSize().height
    local width = panle:getContentSize().width
    cell:setPosition(width/2 - 60,pos_y + height + 50)
    panle:addChild(cell)
    panle.short_cut_cell = cell
end

function Trialtower:heroGoOut()
    for i,hero in pairs(self.heros) do
        csb.animationChangeToAction(hero, _enum_spine_animation_frame_index.animation_move_dir_4, 
                                          _enum_spine_animation_frame_index.animation_move_dir_4, true)
    end

    self.actions[1]:play("role_out",false)
end

function Trialtower:heroStopRun()

    for i,hero in pairs(self.heros) do
        csb.animationChangeToAction(hero, _enum_spine_animation_frame_index.animation_standby_dir_4, 
                                          _enum_spine_animation_frame_index.animation_standby_dir_4, true)
    end
end

function Trialtower:heroAttackMove()

    for i,hero in pairs(self.heros) do
        csb.animationChangeToAction(hero, _enum_spine_animation_frame_index.animation_move_dir_4, 
                                          _enum_spine_animation_frame_index.animation_move_dir_4, true)
    end
    self.actions[1]:play("role_attack",false)
end

function Trialtower:heroToStartPos()

    for i,hero in pairs(self.heros) do
        csb.animationChangeToAction(hero, _enum_spine_animation_frame_index.animation_move_dir_4, 
                                          _enum_spine_animation_frame_index.animation_move_dir_4, true)
    end
    self.actions[1]:play("role_in",false)
end

function Trialtower:onUpdateHero()
    local root = self.roots[1]
    self.heros = {}
    local formation_index = tonumber(_ED.formetion[1])
    for i=1,9 do
        local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..i)
        Panel_role:removeAllChildren(true)
        Panel_role:setVisible(false)
    end

    for i,v in pairs(formation_type[formation_index]) do
        local Panel_role = ccui.Helper:seekWidgetByName(root,"Panel_role_"..v)
        Panel_role:setVisible(true)
        if zstring.tonumber(_ED.formetion[i+1]) ~= 0 then
            self:createHero(Panel_role,_ED.formetion[i+1])
        end
    end
        
end

function Trialtower:createHero(Panel_role , ship_id)
    local ship = _ED.user_ship[""..ship_id]
    local ship_mould_id = ship.ship_template_id
    local temp_bust_index = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.bust_index)
    -- temp_bust_index = 10000 + temp_bust_index
    local armature = sp.spine_sprite(Panel_role, temp_bust_index, _spine_sprite_animation_names[17], true, nil, nil, cc.p(0.5, 0))
    armature:setPosition(cc.p(Panel_role:getContentSize().width/2, 0))

    Panel_role.hero = armature 

    armature:addAnimation(0, _spine_sprite_animation_names[5], true)
    sp.initArmature(armature, true)    
    armature.animationNameList = _spine_sprite_animation_names
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)  

    local action_index =  _enum_spine_animation_frame_index.animation_standby_dir_4
    csb.animationChangeToAction(armature,action_index, action_index, true)

    table.insert(self.heros,armature)
end


function Trialtower:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.trialtower.trialtower)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.campaign.trialtower.trialtower)
    table.insert(self.actions, action)
    csbItem:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "role_in_over" then
            state_machine.excute("trialtower_hero_stop_run",0,"")
        elseif str == "role_out_over" then
            self.reward_data = nil
            state_machine.excute("trialtower_hero_stop_run",0,"")
            state_machine.excute("trialtower_update_draw",0,"")
            state_machine.excute("trialtower_hero_to_start_pos")
        elseif str == "role_attack_over" then
            app.load("client.red_alert.battle.battle_enum")
            state_machine.excute("trialtower_hero_stop_run",0,"")
            _ED.tower_partner_shipmould_id = self._choose_hero_ship
            local npc_id = dms.int(dms["three_kingdoms_config"],_ED.three_kings_now_floor,three_kingdoms_config.npc_id)
            local scene_id = dms.int(dms["copy_config"],4,copy_config.npc_id)
            _ED.npc_last_state[npc_id] = "".._ED.npc_state[npc_id]
            _ED._current_scene_id = scene_id
            _ED._scene_npc_id = npc_id
            _ED._npc_difficulty_index = "1"
            _ED._battle_init_type = battle_enum._fight_type._fight_type_102
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    protocol_command.battle_result_verify.param_list = "" .. _ED.three_kings_now_floor
                    app.load("client.red_alert.battle.battle_loading")
                    state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_102)
                end
            end
            protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_102
            NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseCallback, false, nil)
        end  
    end)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil, 
    {
        terminal_name = "trialtower_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

     --扫荡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sweep"), nil, 
    {
        terminal_name = "trialtower_sweep", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_campaign_trialtower",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_sweep"),
    _id = self.id,
    _invoke = nil,
    _interval = 0.5,})

     --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank"), nil, 
    {
        -- func_string = [[funOpenDrawTip(121)]],
        terminal_name = "trialtower_ranking_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

     --奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_reward"), nil, 
    {
        terminal_name = "trialtower_reward_window_open", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --选择援军
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_enemy_role"), nil, 
    {
        terminal_name = "trialtower_select_partner", 
        terminal_state = 0, 
    }, nil, 0)
    
     --重置
    local Button_reset = ccui.Helper:seekWidgetByName(root,"Button_reset")
    fwin:addTouchEventListener(Button_reset, nil, 
    {
        terminal_name = "trialtower_reset", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    if self.reward_data == nil then
        self:onUpdateDraw() 
    else
        self:onUpdateDraw(1) 
    end

    local run_action  = cc.Sequence:create(cc.DelayTime:create(0),cc.CallFunc:create(self.onUpdateHero))
    self:runAction(run_action)
end

function Trialtower:init()
    self.reward_data = getSceneReward(37) 
	self:onInit()
    return self
end

function Trialtower:onExit()
    state_machine.remove("trialtower_reset")
    state_machine.remove("trialtower_sweep")
    state_machine.remove("trialtower_update_draw")
    state_machine.remove("trialtower_hero_attack_move")
    state_machine.remove("trialtower_hero_go_out")
    state_machine.remove("trialtower_hero_to_start_pos")
    state_machine.remove("trialtower_select_partner")
    state_machine.remove("trialtower_show_sweep_reward")
    state_machine.remove("trialtower_hero_stop_run")
end
