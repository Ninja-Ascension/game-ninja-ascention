-----------------------------
--神兵战斗界面
-----------------------------
GodWeaponryDuplicateInfor = class("GodWeaponryDuplicateInforClass", Window)

local god_weaponry_duplicate_infor_window_open_terminal = {
    _name = "god_weaponry_duplicate_infor_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("GodWeaponryDuplicateInforClass")
        if nil == _Window then
            local god_weaponry_duplicate = params[1]
            local difficulty_index = params[2]
            local npc_state = params[3]
            fwin:open(GodWeaponryDuplicateInfor:new():init(god_weaponry_duplicate,difficulty_index,npc_state), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local god_weaponry_duplicate_infor_window_close_terminal = {
    _name = "god_weaponry_duplicate_infor_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("GodWeaponryDuplicateInforClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(god_weaponry_duplicate_infor_window_open_terminal)
state_machine.add(god_weaponry_duplicate_infor_window_close_terminal)
state_machine.init()

function GodWeaponryDuplicateInfor:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- 次数
    self.current_times = 1
    -- 难度
    self._difficulty_index = 0
    -- npc数据
    self._god_weaponry_duplicate = {}
    --开启状态
    self._npc_state = 0
    -- load lua file
    app.load("client.red_alert.cells.hero.hero_icon_union_team_fight_cell")
    app.load("client.red_alert.god_weaponry.GodWeaponryDuplicateRaids")

    local function init_god_weaponry_duplicate_infor_terminal()
        -- 扫荡
		local god_weaponry_duplicate_infor_sweep_terminal = {
            _name = "god_weaponry_duplicate_infor_sweep",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        state_machine.excute("god_weaponry_duplicate_infor_sweep_reward",0,{instance.current_times,instance._difficulty_index,instance._god_weaponry_duplicate.name})
                        _ED.show_reward_list_group = {}
                    end
                end
                _ED.show_reward_list_group = {}
                protocol_command.sweep.param_list = "" .. instance._god_weaponry_duplicate.npcids .."\r\n".. 1 .."\r\n".. instance.current_times .."\r\n".. 103
                NetworkManager:register(protocol_command.sweep.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --显示扫荡奖励
        local god_weaponry_duplicate_infor_sweep_reward_terminal = {
            _name = "god_weaponry_duplicate_infor_sweep_reward",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local times = params[1]
                local difficulty_index = params[2]
                local name = params[3]
                instance:showSweepReward(times,difficulty_index,name)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }  

        -- 攻击
        local god_weaponry_duplicate_infor_battle_terminal = {
            _name = "god_weaponry_duplicate_infor_battle",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.weaponry_attack_times) <= 0 then
                    TipDlg.drawTextDailog(daily_string[9])
                    return
                end
                local npc_id = tonumber(instance._god_weaponry_duplicate.npcids)
                local scene_id = tonumber(instance._god_weaponry_duplicate.scene_id)
                local open_level = dms.int(dms["npc"],npc_id,npc.attack_level_limit)
                if tonumber(_ED.get_star_count[scene_id]) > 0 then
                    TipDlg.drawTextDailog(red_alert_all_str[124])
                    return
                end
                app.load("client.red_alert.battle.battle_enum")
                -- print("==神兵副本攻击,进入场景,npc_id",npc_id)
                _ED.npc_last_state[npc_id] = "".._ED.npc_state[npc_id]
                _ED._current_scene_id = scene_id
                _ED._scene_npc_id = npc_id
                _ED._god_weaponry_duplicate_level = instance._difficulty_index
                local function responseBattleStartCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        protocol_command.battle_result_verify.param_list = "".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                        app.load("client.red_alert.battle.battle_loading")
                        state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_103)                                            
                    end
                end
                _ED.show_reward_list_group = {}
                _ED._battle_init_type = battle_enum._fight_type._fight_type_103
                protocol_command.battle_result_start.param_list = ""..battle_enum._fight_type._fight_type_103.."\r\n".._ED._current_scene_id.."\r\n".._ED._scene_npc_id
                NetworkManager:register(protocol_command.battle_result_start.code, nil, nil, nil, nil, responseBattleStartCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新扫荡次数
        local god_weaponry_duplicate_infor_change_times_terminal = {
            _name = "god_weaponry_duplicate_infor_change_times",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params._datas.add_times == 0 then
                    instance.current_times = instance._max_times
                else
                    instance.current_times = instance.current_times + params._datas.add_times
                end
                if instance.current_times >= instance._max_times then
                    instance.current_times = instance._max_times
                end
                if instance.current_times < 1 then
                    instance.current_times = 1
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新
        local god_weaponry_duplicate_infor_update_draw_terminal = {
            _name = "god_weaponry_duplicate_infor_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params == true then
                    instance.current_times = 0
                end
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(god_weaponry_duplicate_infor_sweep_terminal)
        state_machine.add(god_weaponry_duplicate_infor_change_times_terminal)	
        state_machine.add(god_weaponry_duplicate_infor_battle_terminal)
        state_machine.add(god_weaponry_duplicate_infor_sweep_reward_terminal)
        state_machine.add(god_weaponry_duplicate_infor_update_draw_terminal)
        state_machine.init()
    end
    
    init_god_weaponry_duplicate_infor_terminal()
end

-- 显示扫荡奖励
function GodWeaponryDuplicateInfor:showSweepReward(times,difficulty_index,name)
    state_machine.excute("god_weaponry_duplicate_raids_window_open",0,{times,difficulty_index,name})
    state_machine.excute("god_weaponry_duplicate_infor_update_draw",0,{true})
    state_machine.excute("god_weaponry_duplicate_update_draw",0,"")
end

function GodWeaponryDuplicateInfor:onUpdateDraw()
    local root = self.roots[1]
    -- 头像
    local Panel_genral_box = ccui.Helper:seekWidgetByName(root, "Panel_genral_box")
    Panel_genral_box:removeAllChildren(true)
    local base_pic = dms.int(dms["npc"], self._god_weaponry_duplicate.npcids, npc.base_pic)
    local herocell = state_machine.excute("hero_icon_union_team_fight_create_cell", 0, {base_pic})
    Panel_genral_box:addChild(herocell)
    -- 名字
    local Text_genral_name = ccui.Helper:seekWidgetByName(root, "Text_genral_name")
    Text_genral_name:setString(gems_duplicate_level[self._difficulty_index].. "·" ..self._god_weaponry_duplicate.name)
    -- 描述
    local Text_genral_skill_introduce = ccui.Helper:seekWidgetByName(root, "Text_genral_skill_introduce")
    Text_genral_skill_introduce:setString(self._god_weaponry_duplicate.msg)
    -- 绘制掉落
    for i=1,4 do
        ccui.Helper:seekWidgetByName(root, "Panel_drop_items_"..i):removeAllChildren(true)
    end
    for i,v in pairs(self._god_weaponry_duplicate.reward_data) do
        local Panel_drop_items = ccui.Helper:seekWidgetByName(root,"Panel_drop_items_"..i)
        Panel_drop_items:removeAllChildren(true)
        local cell = state_machine.excute("all_resource_create_cell",0,{2,v,v,1,0,false,false})
        Panel_drop_items:addChild(cell)
    end
    -- 攻击次数
    local attack_times = zstring.tonumber(_ED.weaponry_attack_times)
    local Text_sweeping_time = ccui.Helper:seekWidgetByName(root, "Text_sweeping_time")
    Text_sweeping_time:setString(self.current_times.."/"..attack_times)
    self._max_times = attack_times

    -- 如果未通关显示攻击按钮/通过关显示扫荡
    local Panel_sweeping = ccui.Helper:seekWidgetByName(root, "Panel_sweeping")
    local Button_sweeping = ccui.Helper:seekWidgetByName(root, "Button_sweeping")
    local Button_battle = ccui.Helper:seekWidgetByName(root, "Button_battle")
    if tonumber(self._npc_state) == 0 then
        Panel_sweeping:setVisible(false)
        Button_sweeping:setVisible(false)
        Button_battle:setVisible(true)
    else
        Panel_sweeping:setVisible(true)
        Button_sweeping:setVisible(true)
        Button_battle:setVisible(false)
    end
end

function GodWeaponryDuplicateInfor:onEnterTransitionFinish()
    
end

function GodWeaponryDuplicateInfor:onInit( )
    local csbItem = csb.createNode(config_csb.god_weaponry.god_weaponry_duplicate_infor)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_genral_infor"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_infor_window_close", 
        terminal_state = 0, 
    }, nil, 0)

    -- 扫荡
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_sweeping"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_infor_sweep", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 攻击
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_battle"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_infor_battle", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 0)

    -- 加一
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_add"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_infor_change_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        add_times = 1,
    }, nil, 0)

    -- 减一
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_reduction"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_infor_change_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        add_times = -1,
    }, nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_max"), nil, 
    {
        terminal_name = "god_weaponry_duplicate_infor_change_times", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        add_times = 0,
    }, nil, 0)

    self:onUpdateDraw()
end

function GodWeaponryDuplicateInfor:init(god_weaponry_duplicate,difficulty_index,npc_state)
    self._god_weaponry_duplicate = god_weaponry_duplicate
    self._difficulty_index = difficulty_index
    self._npc_state = npc_state
	self:onInit()
    return self
end

function GodWeaponryDuplicateInfor:onExit()
    state_machine.remove("god_weaponry_duplicate_infor_sweep")
    state_machine.remove("god_weaponry_duplicate_infor_change_times")
    state_machine.remove("god_weaponry_duplicate_infor_battle")
    state_machine.remove("god_weaponry_duplicate_infor_sweep_reward")
    state_machine.remove("god_weaponry_duplicate_infor_update_draw")
end
