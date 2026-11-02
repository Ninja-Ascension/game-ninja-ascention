-----------------------------
--武器
-----------------------------
Weaponry = class("WeaponryClass", Window)

local weaponry_window_open_terminal = {
    _name = "weaponry_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)   
        if funOpenDrawTip(111) == true then
            return
        end   
        if nil == fwin:find("WeaponryClass") then
            fwin:open(Weaponry:new():init(), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local weaponry_window_close_terminal = {
    _name = "weaponry_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("WeaponryClass"))
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
        end
        -- clear cacher
        cacher.clearWindowCacher()
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(weaponry_window_open_terminal)
state_machine.add(weaponry_window_close_terminal)
state_machine.init()

function Weaponry:ctor()
    self.super:ctor()
    self.roots = {}

    -- load lua file
    app.load("client.red_alert.cells.campaign.weaponry.weaponry_cell")
    -- var 
    -- npc id 
    self.npc_id = nil
    -- Initialize weaponry state machine.
    local function init_weaponry_terminal()
        --取消选择
        local weaponry_un_setselect_terminal = {
            _name = "weaponry_un_setselect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:unSetSelect()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --刷新 绘制右侧
        local weaponry_updatedraw_right_terminal = {
            _name = "weaponry_updatedraw_right",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local npc_info = params[1]
                instance:onUpdateDrawRight(npc_info)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   
        --扫荡
        local weaponry_sweep_terminal = {
            _name = "weaponry_sweep",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local leave_times = dms.int(dms["base_consume"],69,base_consume.vip_0_value + tonumber(_ED.vip_grade)) - tonumber(_ED.npc_equip_all_attack_times)
                if leave_times <= 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[124])
                    return
                end         
                local npc_id = instance.npc_id
                local scene_id = instance.scene_id
                local function responsePlotCopySweepCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("reward_obtain_window_open",0,{2})
                        state_machine.excute("weaponry_updatedraw_attack_times",0,"")
                        state_machine.excute("campaign_updatedraw_cell",0,{4})
                        state_machine.excute("packs_scrollview_all_update_draw",0,"")
                        state_machine.excute("packs_scrollview_equip_onupdate_all_equip",0,"")
                    end
                end
                _ED.show_reward_list_group = {}
                protocol_command.equip_sweep.param_list = "" .. npc_id .."\r\n".. "1" .."\r\n".. "1" .."\r\n".. scene_id
                NetworkManager:register(protocol_command.equip_sweep.code, nil, nil, nil, instance, responsePlotCopySweepCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }     
         --攻击
        local weaponry_attack_terminal = {
            _name = "weaponry_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local leave_times = dms.int(dms["base_consume"],69,base_consume.vip_0_value + tonumber(_ED.vip_grade)) - tonumber(_ED.npc_equip_all_attack_times)
                if leave_times <= 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[124])
                    return
                end
                app.load("client.red_alert.battle.battle_enum")

                local npc_id = instance.npc_id
                local scene_id = instance.scene_id
                _ED.npc_last_state[npc_id] = "".._ED.npc_state[npc_id]
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._npc_difficulty_index = "1"
                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.battle_result_verify.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                        app.load("client.red_alert.battle.battle_loading")
                        state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_17)                                            
                    end
                end
                _ED.show_reward_list_group = {}
                _ED._battle_init_type = battle_enum._fight_type._fight_type_17
                protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_17.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }    

        --刷新攻击次数
        local weaponry_updatedraw_attack_times_terminal = {
            _name = "weaponry_updatedraw_attack_times",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onUpdateDrawAttackTimes()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        state_machine.add(weaponry_un_setselect_terminal)
        state_machine.add(weaponry_updatedraw_right_terminal)
        state_machine.add(weaponry_sweep_terminal)
        state_machine.add(weaponry_attack_terminal)
        state_machine.add(weaponry_updatedraw_attack_times_terminal)
        state_machine.init()
    end
    
    -- call func init_weaponry_terminal state machine.
    init_weaponry_terminal()
end

function Weaponry:onUpdateDrawAttackTimes()
    local root = self.roots[1]
    local Text_last_time_number = ccui.Helper:seekWidgetByName(root,"Text_last_time_number") -- 剩余挑战次数
    local leave_times = dms.int(dms["base_consume"],69,base_consume.vip_0_value + tonumber(_ED.vip_grade)) - _ED.npc_equip_all_attack_times
    Text_last_time_number:setString(leave_times) 
end

function Weaponry:onUpdateDraw()
    local root = self.roots[1]
    -- 绘制左侧列表
    local ListView_left = ccui.Helper:seekWidgetByName(root,"ListView_left")
    ListView_left:removeAllItems()
    local index = 0 
    for i,v in pairs(_ED.weapon_duplicate_info) do
        local cell = state_machine.excute("weaponry_create_cell",0,{v})
        ListView_left:addChild(cell)
        for k,weaponry_info in pairs(v) do
            if tonumber(_ED.npc_state[weaponry_info.npc_id]) >= 0 then
                index = i 
            end
        end
    end
    ListView_left:refreshView()
    ListView_left:getInnerContainer():setPosition(cc.p(0,index * WeaponryCell.__size.height - ListView_left:getInnerContainer():getContentSize().height))

    local Text_last_time_number = ccui.Helper:seekWidgetByName(root,"Text_last_time_number") -- 剩余挑战次数
    local leave_times = dms.int(dms["base_consume"],69,base_consume.vip_0_value + tonumber(_ED.vip_grade)) - _ED.npc_equip_all_attack_times
    Text_last_time_number:setString(leave_times) 
end

function Weaponry:unSetSelect()
    local root = self.roots[1]
    local ListView_left = ccui.Helper:seekWidgetByName(root,"ListView_left")
    for i,cell in pairs(ListView_left:getItems()) do
        cell:unSetSelect()
    end
end


function Weaponry:onUpdateDrawRight(npc_info)
    local root = self.roots[1]
    local npc_id = npc_info.npc_id
    self.npc_id = npc_info.npc_id
    self.scene_id = npc_info.scene_id
    local Panel_header = ccui.Helper:seekWidgetByName(root,"Panel_header") -- npc头像
    Panel_header:removeAllChildren(true)
    local herocell = state_machine.excute("hero_icon_create_cell",0,{npc_info,4,0,false})
    Panel_header:addChild(herocell)

    local Text_boss_name = ccui.Helper:seekWidgetByName(root,"Text_boss_name") -- npc名字
    local npc_name = dms.string(dms["npc"],npc_id,npc.npc_name)
    Text_boss_name:setString(npc_name)

    local Text_boss_introduce = ccui.Helper:seekWidgetByName(root,"Text_boss_introduce") --npc介绍
    Text_boss_introduce:setString(npc_info.dec)
    for i=1,3 do
        local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
        Panel_reward:removeAllChildren(true)
    end
    for i,v in pairs(npc_info.reward_data) do
        local Panel_reward = ccui.Helper:seekWidgetByName(root,"Panel_reward_"..i)
        local cell = nil
        if tonumber(v.prop_type) == 6 then
            cell = state_machine.excute("all_resource_create_cell",0,{3,v,v,1,0,false,false})
        else
            cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,false,false})
        end
        Panel_reward:removeAllChildren(true)
        Panel_reward:addChild(cell)
    end

    local Button_sweep = ccui.Helper:seekWidgetByName(root,"Button_sweep")
    local Button_challenge = ccui.Helper:seekWidgetByName(root,"Button_challenge")
    local Text_can_not_pass = ccui.Helper:seekWidgetByName(root,"Text_can_not_pass")
    Text_can_not_pass:setString("")
    Text_can_not_pass:setColor(cc.c3b(color_Type[12][1],color_Type[12][2],color_Type[12][3]))
    Button_challenge:setVisible(true)
    Button_challenge:setVisible(true)
    Text_can_not_pass:setVisible(false)

    if tonumber(_ED.npc_state[npc_id]) < 0 then
        Text_can_not_pass:setString(red_alert_all_str[144])    
        Button_sweep:setVisible(false)
        Button_challenge:setVisible(false)
        Text_can_not_pass:setVisible(true)
    elseif tonumber(_ED.npc_state[npc_id]) == 0 then
        Button_sweep:setVisible(false)
        Button_challenge:setVisible(true)
    elseif tonumber(_ED.npc_state[npc_id]) > 0 then
        Button_sweep:setVisible(true)
        Button_challenge:setVisible(false)
    end

    local attack_level_limit = dms.int(dms["npc"],npc_id,npc.attack_level_limit)
    if attack_level_limit > tonumber(_ED.user_info.user_grade) then
        Text_can_not_pass:setString(string.format(red_alert_all_str[107],attack_level_limit))
        Text_can_not_pass:setVisible(true)
        Button_challenge:setVisible(false)
        Button_challenge:setVisible(false)
    end

end

function Weaponry:onEnterTransitionFinish()

end

function Weaponry:onInit( )
    local csbItem = csb.createNode(config_csb.campaign.weaponry.weaponry)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    --关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "weaponry_window_close", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --攻击
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_challenge"), nil, 
    {
        terminal_name = "weaponry_attack", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    --扫荡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_sweep"), nil, 
    {
        terminal_name = "weaponry_sweep", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

	self:onUpdateDraw()	
end

function Weaponry:init()
	self:onInit()
    return self
end

function Weaponry:onExit()
    state_machine.remove("weaponry_un_setselect")
    state_machine.remove("weaponry_updatedraw_right")
    state_machine.remove("weaponry_sweep")
    state_machine.remove("weaponry_attack")
    state_machine.remove("weaponry_updatedraw_attack_times")
end
