RoleInfoDebug = class("RoleInfoDebugClass", Window)

local role_info_debug_window_open_terminal = {
    _name = "role_info_debug_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	fwin:open(RoleInfoDebug:new():init(params), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local role_info_debug_window_close_terminal = {
    _name = "role_info_debug_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)

        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(role_info_debug_window_open_terminal)
state_machine.add(role_info_debug_window_close_terminal)
state_machine.init()  
 
function RoleInfoDebug:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- Initialize role info debug state machine.
    local function init_role_info_debug_terminal()
        -- 选择目标
        local role_info_debug_select_role_terminal = {
            _name = "role_info_debug_select_role",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:selectTarget(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(role_info_debug_select_role_terminal)
        state_machine.init()
    end

    -- call func init role info debug state machine.
    init_role_info_debug_terminal()
end

function RoleInfoDebug:init()
	self:onInit()
	return self
end

function RoleInfoDebug:selectTarget( params )
    if nil == _ED._fightModule then
        return
    end

    local camp = params._datas._camp
    local pos = params._datas._pos

    local root  = self.roots[1]

    local Panel_target = ccui.Helper:seekWidgetByName(root, camp == 0 and "Panel_hero" or "Panel_enemy")

    if Panel_target:isVisible() then
        Panel_target:setVisible(false)
        return
    end

    Panel_target:setVisible(true)

    local battleObject = _ED._fightModule:findAppointFightObject(camp, pos)
    if nil ~= battleObject then
        -- 攻击  1
        -- 防御  2
        -- 生命  0
        -- 暴击率  8
        -- 格挡率  10
        -- 暴伤加成  43
        -- 格挡加成  46
        -- 抗暴率  9
        -- 破格挡率  11
        -- 伤害加成  33
        -- 伤害减免  34
        -- 吸血率 40
        -- 反弹率 42
        local property_01 = ccui.Helper:seekWidgetByName(Panel_target, "Text_gj_0") -- 攻击
        local property_08 = ccui.Helper:seekWidgetByName(Panel_target, "Text_bj_0") -- 暴击率
        local property_10 = ccui.Helper:seekWidgetByName(Panel_target, "Text_gdl_0") -- 格挡率
        local property_02 = ccui.Helper:seekWidgetByName(Panel_target, "Text_fy_0") -- 防御
        local property_43 = ccui.Helper:seekWidgetByName(Panel_target, "Text_bsjc_0") -- 暴伤加成
        local property_46 = ccui.Helper:seekWidgetByName(Panel_target, "Text_gdjc_0") -- 格挡加成
        local property_00 = ccui.Helper:seekWidgetByName(Panel_target, "Text_sm_0") -- 生命
        local property_09 = ccui.Helper:seekWidgetByName(Panel_target, "Text_kbl_0") -- 抗暴率
        local property_11 = ccui.Helper:seekWidgetByName(Panel_target, "Text_pgdl_0") -- 破格挡率
        local property_33 = ccui.Helper:seekWidgetByName(Panel_target, "Text_shjc_0") -- 伤害加成
        local property_34 = ccui.Helper:seekWidgetByName(Panel_target, "Text_shjm_0") -- 伤害减免
        local property_40 = ccui.Helper:seekWidgetByName(Panel_target, "Text_xxl_0") -- 吸血率
        local property_42 = ccui.Helper:seekWidgetByName(Panel_target, "Text_ftl_0") -- 反弹率


        property_01:setString(battleObject.attack)
        property_08:setString(battleObject.criticalAdditionalPercent)
        property_10:setString(battleObject.retainAdditionalPercent)
        property_02:setString(battleObject.physicalDefence)
        property_43:setString(battleObject.uniqueSkillDamagePercent)
        property_46:setString(battleObject.uniqueSkillResistancePercent)
        property_00:setString(battleObject.healthPoint)
        property_09:setString(battleObject.criticalResistAdditionalPercent)
        property_11:setString(battleObject.retainBreakAdditionalPercent)
        property_33:setString(battleObject.finalDamagePercent)
        property_34:setString(battleObject.finalLessenDamagePercent)
        property_40:setString(battleObject.inhaleHpDamagePercent)
        property_42:setString(battleObject.reboundDamageValue)
    end
end

function RoleInfoDebug:onInit( ... )
	local csbBattleUI = csb.createNode("battle/battle_UI_0.csb")
    local root = csbBattleUI:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleUI)

    for i = 1, 6 do
        local Image_hero = ccui.Helper:seekWidgetByName(root, "Image_hero_" .. i)
        Image_hero._camp = 0
        Image_hero._pos = i
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_hero_" .. i),       nil, 
        {
            terminal_name = "role_info_debug_select_role",    
            terminal_state = 0, 
            isPressedActionEnabled = true,
            _camp = 0,
            _pos = i,
        }, 
        nil, 0)

        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_enemy_" .. i),       nil, 
        {
            terminal_name = "role_info_debug_select_role",    
            terminal_state = 1,
            isPressedActionEnabled = true,
            _camp = 1,
            _pos = i,
        }, 
        nil, 0)
    end
end

function RoleInfoDebug:onEnterTransitionFinish()
	
end

function RoleInfoDebug:onExit()
	state_machine.remove("role_info_debug_select_role")
end
