-- ----------------------------------------------------------------------------------------------------
-- 说明：工会副本战斗胜利界面
-------------------------------------------------------------------------------------------------------
WorldBossFightReward = class("WorldBossFightRewardClass", Window)

local world_boss_fight_reward_open_terminal = {
    _name = "world_boss_fight_reward_open",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("WorldBossFightRewardClass")
        if nil == _homeWindow then
            local panel = WorldBossFightReward:new():init()
            fwin:open(panel,fwin._window)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local world_boss_fight_reward_close_terminal = {
    _name = "world_boss_fight_reward_close",
    _init = function (terminal) 
    
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
		local _homeWindow = fwin:find("WorldBossFightRewardClass")
        if nil ~= _homeWindow then
    		fwin:close(fwin:find("WorldBossFightRewardClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(world_boss_fight_reward_open_terminal)
state_machine.add(world_boss_fight_reward_close_terminal)
state_machine.init()
    
function WorldBossFightReward:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    --防作弊偏移
    -- self._shift_num = 1011
    app.load("client.cells.utils.resources_icon_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    app.load("client.cells.ship.ship_icon_cell")

    local function init_world_boss_fight_reward_terminal()
        -- 显示界面
        local world_boss_fight_reward_display_terminal = {
            _name = "world_boss_fight_reward_display",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local WorldBossFightRewardWindow = fwin:find("WorldBossFightRewardClass")
                if WorldBossFightRewardWindow ~= nil then
                    WorldBossFightRewardWindow:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏界面
        local world_boss_fight_reward_hide_terminal = {
            _name = "world_boss_fight_reward_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local WorldBossFightRewardWindow = fwin:find("WorldBossFightRewardClass")
                if WorldBossFightRewardWindow ~= nil then
                    WorldBossFightRewardWindow:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --退出
        local world_boss_fight_reward_drop_out_terminal = {
            _name = "world_boss_fight_reward_drop_out",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
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
                end
                
                --  app.load("client.l_digital.campaign.worldboss.WorldBossWindow")
                if fwin:find("WorldBossWindowClass") == nil then
                     app.load("client.l_digital.campaign.exploration.ExplorationLoading")
                     fwin:open(ExplorationLoading:new():init(218), fwin._taskbar)
                   -- state_machine.excute("world_boss_window_open", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(world_boss_fight_reward_display_terminal)
        state_machine.add(world_boss_fight_reward_hide_terminal)
        state_machine.add(world_boss_fight_reward_drop_out_terminal)
        
        state_machine.init()
    end
    init_world_boss_fight_reward_terminal()
end

function WorldBossFightReward:onUpdateDraw()
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
    -- if tonumber(_ED.BothSidesFightDamage.our_fight_is_hurt) == 0 then
    --     _ED.BothSidesFightDamage.our_fight_is_hurt = self.maxHP
    -- end

    local maxHp = tonumber(_ED.world_boss_info.maxHp)
    local damageOnBoss = tonumber(_ED.world_boss_user_damage_info.damage)
    damageOnBoss = damageOnBoss >= maxHp and maxHp or damageOnBoss

    Text_legion_battle_jiesuan_pass_n:setString(damageOnBoss)
    --debug.print_r(_ED.union_pve_info)
    -- local maxHp = _ED.union_pve_info[tonumber(_ED.union_attack_data_id)].max_hp

    Text_legion_battle_jiesuan_kill_n:setString(string.format("%0.2f",(damageOnBoss/maxHp*100)).."%")

    local Panel_boss_box = ccui.Helper:seekWidgetByName(root, "Panel_boss_box")
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
    Image_2:setVisible(tonumber(_ED.world_boss_info.lastAttackUser.userId) == tonumber(_ED.user_info.user_id))
    if tonumber(_ED.world_boss_info.lastAttackUser.userId) == tonumber(_ED.user_info.user_id) then
        Panel_boss_box:setVisible(true)
        Text_1:setString(tipStringInfo_world_boss[9])
        local rewardInfo = getSceneReward(7) 
        if rewardInfo ~= nil then
            self:drawReworld(rewardInfo)
        end
    elseif table.nums(_ED.world_boss_info.surprisedRewardUserInfo) > 0 and tonumber(_ED.world_boss_info.surprisedRewardUserInfo[1].userId) == tonumber(_ED.user_info.user_id) and tonumber(_ED.world_boss_info.surprisedRewardUserInfo[1].showReward) == 0 then
        Panel_boss_box:setVisible(true)
        Text_1:setString(tipStringInfo_world_boss[10])
        local rewardInfo = getSceneReward(7) 
        if rewardInfo ~= nil then
            self:drawReworld(rewardInfo)
        end
    else
        Panel_boss_box:setVisible(false)
    end
end

function WorldBossFightReward:drawReworld(rewardInfo)
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

function WorldBossFightReward:init()
	-- self.rewardList = getSceneReward(2)
    self:onInit()
    return self
end

function WorldBossFightReward:onInit()
    local csbWorldBossFightReward = csb.createNode("legion/sm_legion_pve_battle_over.csb")
    local root = csbWorldBossFightReward:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbWorldBossFightReward)
    local action = csb.createTimeline("legion/sm_legion_pve_battle_over.csb")
    table.insert(self.actions, action)
    csbWorldBossFightReward:runAction(action)

    self:onUpdateDraw()

	-- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_legion_battle_jiesuan_bg"), nil, 
    {
        terminal_name = "world_boss_fight_reward_drop_out",
        terminal_state = 0,
        touch_black = true,
    },
    nil,3)
end

function WorldBossFightReward:onExit()
    state_machine.remove("world_boss_fight_reward_display")
    state_machine.remove("world_boss_fight_reward_hide")
end