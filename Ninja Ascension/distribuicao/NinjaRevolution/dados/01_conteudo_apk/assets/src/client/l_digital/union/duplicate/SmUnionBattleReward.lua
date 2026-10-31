-- ----------------------------------------------------------------------------------------------------
-- 说明：工会副本战斗胜利界面
-------------------------------------------------------------------------------------------------------
SmUnionBattleReward = class("SmUnionBattleRewardClass", Window)

local sm_union_battle_reward_open_terminal = {
    _name = "sm_union_battle_reward_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionBattleRewardClass")
        if nil == _homeWindow then
            local panel = SmUnionBattleReward:new():init()
            fwin:open(panel,fwin._window)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_union_battle_reward_close_terminal = {
    _name = "sm_union_battle_reward_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("SmUnionBattleRewardClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("SmUnionBattleRewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_union_battle_reward_open_terminal)
state_machine.add(sm_union_battle_reward_close_terminal)
state_machine.init()
    
function SmUnionBattleReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.ship.ship_icon_cell")

    local function init_sm_union_battle_reward_terminal()
        -- 显示界面
        local sm_union_battle_reward_display_terminal = {
            _name = "sm_union_battle_reward_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionBattleRewardWindow = fwin:find("SmUnionBattleRewardClass")
                if SmUnionBattleRewardWindow ~= nil then
                    SmUnionBattleRewardWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local sm_union_battle_reward_hide_terminal = {
            _name = "sm_union_battle_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local SmUnionBattleRewardWindow = fwin:find("SmUnionBattleRewardClass")
                if SmUnionBattleRewardWindow ~= nil then
                    SmUnionBattleRewardWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --退出
        local sm_union_battle_reward_drop_out_terminal = {
            _name = "sm_union_battle_reward_drop_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                NetworkManager:register(protocol_command.union_copy_init.code, nil, nil, nil, nil, nil, false, nil)
                _ED._current_scene_id = 0
                _ED._scene_npc_id = 0
                _ED._current_seat_index = -1
                _ED._npc_difficulty_index = 0
                _ED._npc_addition_params = ""
                local fightType = instance._fight_type
                fwin:close(instance)
                fwin:close(fwin:find("BattleSceneClass"))

                cacher.cleanSystemCacher()
                cacher.destoryRefPools()
                cacher.cleanActionTimeline()
                checkTipBeLeave()            
                cacher.removeAllTextures()
                fwin:reset(nil)

                app.load("client.home.Menu")
                if fwin:find("MenuClass") == nil then
                    fwin:open(Menu:new(), fwin._taskbar)
                    local windowMusicParams = dms.searchs(dms["sound_effect_param"], sound_effect_param.class_name, "MenuClass")
                    if windowMusicParams ~= nil and windowMusicParams[1] ~= nil then
                        playBgm(formatMusicFile("background", windowMusicParams[1][4]))
                    end
                end
                
                app.load("client.l_digital.union.duplicate.SmUnionDuplicate")
                state_machine.excute("sm_union_duplicate_open", 0, nil)
                app.load("client.l_digital.union.duplicate.SmUnionPveBattleWindow")
                local function responseCallback( response )
                    NetworkManager:register(protocol_command.union_persion_list.code, nil, nil, nil, nil, nil, false, nil)
                    state_machine.excute("sm_union_pve_battle_window_open", 0, {_ED.union_attack_npc_id,_ED.union_attack_data_id})
                end
                protocol_command.union_copy_look_npc_info.param_list = "0".."\r\n"..tonumber(_ED.union_attack_data_id)-1
                NetworkManager:register(protocol_command.union_copy_look_npc_info.code, nil, nil, nil, nil, responseCallback, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_union_battle_reward_display_terminal)
        state_machine.add(sm_union_battle_reward_hide_terminal)
        state_machine.add(sm_union_battle_reward_drop_out_terminal)
        
        state_machine.init()
    end
    init_sm_union_battle_reward_terminal()
end

function SmUnionBattleReward:onUpdateDraw()
    local root = self.roots[1]
    if root == nil then 
        return
    end

    ccui.Helper:seekWidgetByName(root, "Panel_legion_battle_jiesuan_S_1"):setVisible(true)
    ccui.Helper:seekWidgetByName(root, "Panel_legion_battle_jiesuan_S_2"):setVisible(true)

    local Text_legion_battle_jiesuan_lv_n = ccui.Helper:seekWidgetByName(root, "Text_legion_battle_jiesuan_lv_n")
    local Text_legion_battle_jiesuan_exp_n = ccui.Helper:seekWidgetByName(root, "Text_legion_battle_jiesuan_exp_n")
    local Text_legion_battle_jiesuan_icon_n = ccui.Helper:seekWidgetByName(root, "Text_legion_battle_jiesuan_icon_n")
    Text_legion_battle_jiesuan_lv_n:setString(_ED.user_info.user_grade)
    Text_legion_battle_jiesuan_exp_n:setString("0")
    Text_legion_battle_jiesuan_icon_n:setString("0")

    local Text_legion_battle_jiesuan_pass_n = ccui.Helper:seekWidgetByName(root, "Text_legion_battle_jiesuan_pass_n")
    local Text_legion_battle_jiesuan_kill_n = ccui.Helper:seekWidgetByName(root, "Text_legion_battle_jiesuan_kill_n")
    if tonumber(_ED.BothSidesFightDamage.our_fight_is_hurt) == 0 then
        _ED.BothSidesFightDamage.our_fight_is_hurt = self.maxHP
    end
    Text_legion_battle_jiesuan_pass_n:setString(_ED.BothSidesFightDamage.our_fight_is_hurt)
    --debug.print_r(_ED.union_pve_info)
    local maxHp = _ED.union_pve_info[tonumber(_ED.union_attack_data_id)].max_hp
    Text_legion_battle_jiesuan_kill_n:setString(string.format("%0.2f",(tonumber(_ED.BothSidesFightDamage.our_fight_is_hurt)/tonumber(maxHp)*100)).."%")

    local rewardInfo = getSceneReward(25) 
    if rewardInfo ~= nil then
        self:drawReworld(rewardInfo)
    end
end

function SmUnionBattleReward:drawReworld(rewardInfo)
    local root = self.roots[1]
    local ListView_legion_battle_jiesuan_icon = ccui.Helper:seekWidgetByName(root, "ListView_legion_battle_jiesuan_icon")
    ListView_legion_battle_jiesuan_icon:removeAllItems()
    for i,v in pairs(rewardInfo.show_reward_list) do
        local reward = ResourcesIconCell:createCell()
        reward:init(tonumber(v.prop_type), tonumber(v.item_value), tonumber(v.prop_item),nil,nil,true,true)
        ListView_legion_battle_jiesuan_icon:addChild(reward)
    end
    ListView_legion_battle_jiesuan_icon:requestRefreshView()
end

function SmUnionBattleReward:init()
	-- self.rewardList = getSceneReward(2)
    self:onInit()
    return self
end

function SmUnionBattleReward:onInit()
    local csbSmUnionBattleReward = csb.createNode("legion/sm_legion_pve_battle_over.csb")
    local root = csbSmUnionBattleReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbSmUnionBattleReward)
    local action = csb.createTimeline("legion/sm_legion_pve_battle_over.csb")
    table.insert(self.actions, action)
    csbSmUnionBattleReward:runAction(action)
    -- self:onUpdateDraw()

    state_machine.lock("sm_union_battle_reward_drop_out")
    local function responseBattleStartCallback( response )
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:onUpdateDraw()
                state_machine.unlock("sm_union_battle_reward_drop_out")
            else
                state_machine.unlock("sm_union_battle_reward_drop_out")
            end
        else
            self:onUpdateDraw()
            state_machine.unlock("sm_union_battle_reward_drop_out")
        end
        state_machine.unlock("sm_union_battle_reward_drop_out")
    end
    -- 公会副本战斗接口
    -- 序列号
    -- union_copy_fight
    -- 用户id
    -- npc下标
    -- 造成的伤害
    -- 最大血量

    --先找最大的血量
    self.maxHP = 0
    local environment_formation1 = dms.int(dms["npc"], zstring.tonumber(_ED.union_attack_npc_id), npc.environment_formation1)
    for i=1, 6 do
        local environment_ship_id = dms.int(dms["environment_formation"], zstring.tonumber(environment_formation1), environment_formation.seat_one+i-1)
        if environment_ship_id ~= 0 then
            self.maxHP = dms.int(dms["environment_ship"], environment_ship_id, environment_ship.power)
            break
        end
    end

    -- 原来的血量
    local oldHP = tonumber(_ED.union_pve_info[tonumber(_ED.union_copy_fight_data_id)].current_hp)

    local lessHealthPoint = 0
    if table.nums(_ED._fightModule.byAttackObjects) == 0 then
        lessHealthPoint = oldHP
    else
        for i,v in pairs(_ED._fightModule.byAttackObjects) do
            if tonumber(oldHP) == 0 then
                lessHealthPoint = math.ceil(tonumber(self.maxHP) - tonumber(v.healthPoint))
            else
                lessHealthPoint = math.ceil(oldHP - tonumber(v.healthPoint))
            end
            break
        end
    end
    local formationInfo = ""
    for i, v in pairs(_ED.user_formetion_status) do
        local ship = _ED.user_ship[""..v]
        if ship ~= nil then
            if formationInfo == "" then
                formationInfo = ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
            else
                formationInfo = formationInfo.."|"..ship.ship_template_id..","..ship.ship_grade..","..ship.StarRating..","..ship.Order
            end
        else
            if formationInfo == "" then
                formationInfo = "0,0,0,0"
            else
                formationInfo = formationInfo.."|".."0,0,0,0"
            end
        end
    end
    protocol_command.union_copy_fight.param_list = (tonumber(_ED.union_copy_fight_data_id)-1).."\r\n"..lessHealthPoint.."\r\n"..self.maxHP.."\r\n"..formationInfo
    NetworkManager:register(protocol_command.union_copy_fight.code, nil, nil, nil, self, responseBattleStartCallback, false, nil)
    -- self:showImageAnimation()
	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_legion_battle_jiesuan_bg"), nil, 
    {
        terminal_name = "sm_union_battle_reward_drop_out",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function SmUnionBattleReward:onExit()
    state_machine.remove("sm_union_battle_reward_display")
    state_machine.remove("sm_union_battle_reward_hide")
end