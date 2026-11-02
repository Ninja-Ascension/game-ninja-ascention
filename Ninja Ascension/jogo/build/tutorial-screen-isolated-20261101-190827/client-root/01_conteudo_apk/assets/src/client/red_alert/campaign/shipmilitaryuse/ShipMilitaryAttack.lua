-----------------------------
--掠夺出战界面
-----------------------------
ShipMilitaryAttack = class("ShipMilitaryAttackClass", Window)

local ship_military_attack_window_open_terminal = {
    _name = "ship_military_attack_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)     
        if nil == fwin:find("ShipMilitaryAttackClass") then
            local user_info = params[1]
            fwin:open(ShipMilitaryAttack:new():init(user_info), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local ship_military_attack_window_close_terminal = {
    _name = "ship_military_attack_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ShipMilitaryAttackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(ship_military_attack_window_open_terminal)
state_machine.add(ship_military_attack_window_close_terminal)
state_machine.init()

function ShipMilitaryAttack:ctor()
    self.super:ctor()
    self.roots = {}

    --var
    --运送信息
    self.user_info = nil
    
    --抢夺可得到资源
    self.attack_get_silver = nil

    --军资本地信息 格式化好的
    self.ship_military_info = nil
    -- load lua file
     -- Initialize ship_military_attack state machine.
    local function init_ship_military_attack_terminal()
        -- 出战
        local ship_military_attack_go_to_fight_terminal = {
            _name = "ship_military_attack_go_to_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            local leave_attack_times = tonumber(_ED.transport_resouce_info.leave_attack_times)
            if leave_attack_times <= 0 then 
                TipDlg.drawTextDailog(daily_string[14])
                return
            end
                app.load("client.red_alert.battle.battle_enum")
                
                local scene_npc_tab = dms.string(dms["ship_military_config"],10,ship_military_config.param)
                scene_npc_tab = zstring.split(scene_npc_tab,",")
                local scene_id = tonumber(scene_npc_tab[1])
                local npc_id = tonumber(scene_npc_tab[2])
    
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._npc_difficulty_index = "1"
               
                _ED._battle_init_type = battle_enum._fight_type._fight_type_19
                _ED.attack_user_id = instance.user_info.user_id
                _ED._battle_type_params = {_ED.attack_user_id}
                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.battle_result_verify.param_list = "" .. _ED.attack_user_id
                        app.load("client.red_alert.battle.battle_loading")
                        state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_19)                                            
                    end
                end
                protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_19.."\r\n".._ED.attack_user_id 
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        state_machine.add(ship_military_attack_go_to_fight_terminal)
        state_machine.init()
    end
    
    -- call func ship_military_attack state machine.
    init_ship_military_attack_terminal()
end

function ShipMilitaryAttack:onEnterTransitionFinish()

end

function ShipMilitaryAttack:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.shipmilitaryuse.ship_military_attack)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)
 
    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "ship_military_attack_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
   
   --攻击
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_attack"), nil, 
    {
        terminal_name = "ship_military_attack_go_to_fight", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)
   
    self:onUpdateDraw() 

end

function ShipMilitaryAttack:onUpdateDraw()
    local root = self.roots[1]
    local Panel_camp = ccui.Helper:seekWidgetByName(root,"Panel_camp") -- 阵营
    local Panel_card = ccui.Helper:seekWidgetByName(root,"Panel_card") -- 卡片
    local Text_name = ccui.Helper:seekWidgetByName(root,"Text_name") -- 名字
    local Text_fight = ccui.Helper:seekWidgetByName(root,"Text_fight") --战斗力
    local Text_attack = ccui.Helper:seekWidgetByName(root,"Text_attack") -- 被掠夺次数
    local Text_can_attack = ccui.Helper:seekWidgetByName(root,"Text_can_attack") -- 可掠夺数量
    local Button_attack = ccui.Helper:seekWidgetByName(root,"Button_attack") -- 可掠夺数量
    local Panel_can_attack = ccui.Helper:seekWidgetByName(root,"Panel_can_attack") -- 是否可掠夺
    local Text_lv = ccui.Helper:seekWidgetByName(root,"Text_lv") -- 军资等级
    local Text_prom = ccui.Helper:seekWidgetByName(root,"Text_prom") -- 描述

    local max_attack_times = dms.int(dms["ship_military_config"],9,ship_military_config.param)
    local resource_quality = tonumber(self.user_info.resource_quality)

    Panel_card:setBackGroundImage(string.format(config_res.images.ui.play.shipmilitaryuse.shipmilitaryuse_card, resource_quality))
    Panel_camp:setBackGroundImage(string.format(config_res.images.ui.quality.camp_icon, self.user_info.user_camp))
    Text_name:setString(self.user_info.user_name)
    Text_fight:setString(self.user_info.user_fight)
    Text_attack:setString(string.format(red_alert_all_str[223],""..self.user_info.ready_attack_times))
  
    Text_lv:setString(string.format(red_alert_all_str[117],self.ship_military_info[resource_quality].level))
    Text_can_attack:setString(math.floor(self.attack_get_silver))
    Text_prom:setString("")
    Panel_can_attack:setVisible(false)
    local plunder_time = dms.int(dms["ship_military_config"],15,ship_military_config.param) -- 可被掠夺次数
    if self.user_info.user_id == _ED.user_info.user_id then
        Button_attack:setVisible(false) -- 自己的不能抢
        Text_prom:setString(red_alert_all_str[114])
    -- elseif tonumber(_ED.user_info.user_force) == tonumber(self.user_info.user_camp) then
    --     Button_attack:setVisible(false) -- 同阵营的不能抢 red_alert_all_str[115]
    --     Text_prom:setString(red_alert_all_str[115])
    elseif tonumber(self.user_info.ready_attack_times) >= plunder_time then
        Button_attack:setVisible(false) -- 已经被抢光了 red_alert_all_str[116]
        Text_prom:setString(red_alert_all_str[116])
    else
        Panel_can_attack:setVisible(true)
        Button_attack:setVisible(true)
    end


    -- user_id = 1,
    -- user_name = "yanghan",
    -- user_fight = "10000",
    -- user_level = 50,
    -- user_camp = math.random(1,3),
    -- user_sex = math.random(1,2),
    -- resource_quality = math.random(1,5),--军资品质
    -- ready_attack_times = math.random(0,2), -- 已经被掠夺次数
end

function ShipMilitaryAttack:initData()
-- 解析运送军资数据
    if _ED.ship_military_info == nil or table.nums(_ED.ship_military_info) == 0 then
        initShipMilitaryData()
    end
    local user_level = tonumber(self.user_info.user_level)
    if user_level >= 60 then
        self.ship_military_info = _ED.ship_military_info["150"]
    elseif user_level >= 40 then
        self.ship_military_info = _ED.ship_military_info["60"]
    elseif user_level >= 20 then
        self.ship_military_info = _ED.ship_military_info["40"]
    else
        self.ship_military_info = _ED.ship_military_info["20"]
    end
    local reward_silver_numbers = zstring.split(self.ship_military_info[self.user_info.resource_quality].reward_silver_numbers, "|")
    reward_silver_numbers = zstring.split(reward_silver_numbers[1], ",")
    local reward_multiple = dms.int(dms["ship_military_config"],8,ship_military_config.param) /100
    self.attack_get_silver = tonumber(reward_silver_numbers[3] * reward_multiple)
end

function ShipMilitaryAttack:init(user_info)
    self.user_info = user_info
    self:initData()
    self:onInit()
    return self
end

function ShipMilitaryAttack:onExit()
    state_machine.remove("ship_military_attack_go_to_fight",0,"")
end
