-- ----------------------------------------------------------------------------------------------------
-- 说明：战场中角色HP信息
-- ----------------------------------------------------------------------------------------------------
BattleRoleHP = class("BattleRoleHPClass", Window)
BattleRoleHP.__name_visible = false

-- 新建战斗对象
local battle_role_hp_terminal = {
    _name = "battle_role_hp",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        return BattleRoleHP:new():init(params)
    end,
    _terminal = nil,
    _terminals = nil
}

-- 更新角色HP
local battle_role_hp_update_terminal = {
    _name = "battle_role_hp_update",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local roleHp = params.roleHP
        if roleHp ~= nil then
            roleHp:updateInfo(params.hp, params.maxHp)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_role_hp_terminal)
state_machine.add(battle_role_hp_update_terminal)
state_machine.init()

function BattleRoleHP:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- load lua file

    -- var
    self.Image_blood = nil          -- bgbar
    self.LoadingBar_bolld = nil     -- hp
    -- 角色名称
    self.Text_role_name = nil
end

function BattleRoleHP:init(params)
    local role = params.role
    local csbItem = csb.createNode(config_csb.battle.battle_enemy_blood)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    -- 角色名称
    self.Text_role_name = ccui.Helper:seekWidgetByName(root,"Text_role_name")
    if nil ~= self.Text_role_name then
        local quality = role._heroBattleObject.quality
        self.Text_role_name:setString(role._shipName)
        self.Text_role_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
        self.Text_role_name:setVisible(BattleRoleHP.__name_visible)
    end

    self.Image_blood = ccui.Helper:seekWidgetByName(root,"Image_blood")
    if nil ~= self.Image_blood then
        self.Image_blood:setVisible(false)
    end
    self.LoadingBar_bolld = ccui.Helper:seekWidgetByName(root,"LoadingBar_bolld")
    if nil ~= self.LoadingBar_bolld then
        -- 区分与敌方的颜色显示
        if role._camp == 0 then
            self.LoadingBar_bolld:loadTexture("images/ui/battle/battle_bolld_me_loading.png", 1)
        end
        self.LoadingBar_bolld:setVisible(false)
    end
    return self
end

function BattleRoleHP:updateInfo(hp, maxHp)
    if nil == self.LoadingBar_bolld then
        return
    end
    local root = self.roots[1]
    local persentHp = (zstring.tonumber(hp) / zstring.tonumber(maxHp)) * 100
    persentHp = math.max(0, math.min(100, persentHp))
    self.LoadingBar_bolld:setPercent(persentHp)
end

function BattleRoleHP:showUIRoleName(visible)
    if nil ~= self.Text_role_name then
        self.Text_role_name:setVisible(visible)
    end
end

function BattleRoleHP:showUIRoleHp(visible)
    if nil ~= self.Image_blood then
        self.Image_blood:setVisible(visible)
    end
    if nil ~= self.LoadingBar_bolld then
        self.LoadingBar_bolld:setVisible(visible)
    end
end

function BattleRoleHP:onEnterTransitionFinish()

end

function BattleRoleHP:close()

end

function BattleRoleHP:destroy()

end
-- ----------------------------------------------------------------------------------------------------