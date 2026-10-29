-- ---------------------------------------------------------------------------------
-- 头像
-- ---------------------------------------------------------------------------------
BattleUIIcon = class("BattleUIIconClass", Window)

app.load("client.mission.missionex.BattleSoftGuide")

local battle_ui_icon_cell_terminal = {
    _name = "battle_ui_icon_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = BattleUIIcon:new()
        local ship = params[1]
        cell:init(ship)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_ui_icon_cell_terminal)
state_machine.init()

function BattleUIIcon:ctor()
    self.super:ctor()
    self.roots = {}

    -- var
    self.ship = nil
    self.role = nil

    -- 怒气满时播放的爆炸特效
    self._fullEffect = nil

    -- 是否为自己战斗
    self._is_auto_fight = false

    -- ui 点击动画的层容器
    self.Panel_push = nil

    -- ui 点击动画
    self.touch_animation = nil

    -- Initialize battle_ui_icon_cell machine.
    local function init_battle_ui_icon_cell_terminal()
        -- 发动技能攻击
        local battle_ui_icon_skill_attack_terminal = {
            _name = "battle_ui_icon_skill_attack",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cell = params._datas.cell
                if cell.showSpEffect == true then
                    state_machine.excute("battle_soft_guide_window_close", 0, 0)
                    state_machine.excute("battle_role_skill_attack", 0, {role = cell.role})
                    if cell._is_auto_fight == false then
                        if config_res.battle ~= nil and config_res.battle.music ~= nil and config_res.battle.music.skill_effect ~= nil then
                            playEffectMusic(config_res.battle.music.skill_effect[1])
                        end
                    end

                    if nil ~= cell.Panel_push and nil ~= cell.touch_animation then
                        cell.Panel_push:setVisible(true)
                        csb.animationChangeToAction(cell.touch_animation, 0, 0, nil)
                        cell.touch_animation._invoke = cell.touch_animation._invoke0
                    end

                    -- 绘制技能释放特效
                    if config_res.battle ~= nil and config_res.battle.effect ~= nil and config_res.battle.effect.skill_effect ~= nil then
                        local spriteId = dms.int(dms["ship_mould"], cell.ship.ship_template_id, ship_mould.ship_pic)
                        state_machine.excute("battle_skill_effect_window_open", 0, spriteId)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新血条
        local battle_ui_icon_cell_update_hp_terminal = {
            _name = "battle_ui_icon_cell_update_hp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params.cell:updateHP(params.role, params.hp, params.maxHp, params.animation, params.delayTime)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新怒气条
        local battle_ui_icon_cell_update_sp_terminal = {
            _name = "battle_ui_icon_cell_update_sp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params.cell:updateSP(params.role, params.sp, params.maxSp, params.showSpEffect)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置角色的显示
        local battle_ui_icon_cell_update_reset_terminal = {
            _name = "battle_ui_icon_cell_update_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                params.cell:updateReset()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 自动战斗状态
        local battle_ui_icon_cell_auto_fight_terminal = {
            _name = "battle_ui_icon_cell_auto_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local role = params[1]
                local auto = params[2]
                role:autoFight(auto)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(battle_ui_icon_skill_attack_terminal)
        state_machine.add(battle_ui_icon_cell_update_hp_terminal)
        state_machine.add(battle_ui_icon_cell_update_sp_terminal)
        state_machine.add(battle_ui_icon_cell_update_reset_terminal)
        state_machine.add(battle_ui_icon_cell_auto_fight_terminal)
        state_machine.init()
    end
    
    -- call func init battle_ui_icon_cell machine.
    init_battle_ui_icon_cell_terminal()
end

function BattleUIIcon:updateHP(role, hp, maxHp, animation, delayTime)
    local root = self.roots[1]
    self.role = role
    local persentHp = (zstring.tonumber(hp) / zstring.tonumber(maxHp) / 2)  * 100
    persentHp = math.max(0, math.min(50, persentHp))

    if true == animation then
        if delayTime <= 0 then
            delayTime = 0.000001
        end
        if nil ~= self.ProgressTimerBarBolld then
            self.ProgressTimerBarBolld:runAction(cc.Sequence:create({
                    cc.DelayTime:create(delayTime),
                    cc.ProgressFromTo:create(1.5, self.ProgressTimerBarBolld:getPercentage(), persentHp)
                }))
        else
            self.LoadingBar_bolld:runAction(cc.Sequence:create({
                    cc.DelayTime:create(delayTime),
                    cc.ProgressFromTo:create(1.5, self.LoadingBar_bolld:getPercentage(), persentHp * 2)
                }))
        end
    else
        if nil ~= self.ProgressTimerBarBolld then
            self.ProgressTimerBarBolld:setPercentage(persentHp)
        else
            self.LoadingBar_bolld:setPercent(persentHp * 2)
        end
    end

    if persentHp <= 0 then
        --死亡
        self.Panel_bolld_un:setVisible(false)
        self.Panel_battle_ui_icon:setColor(cc.c3b(color_Type[13][1],color_Type[13][2],color_Type[13][3]))
        
        self:updateReset()
    elseif persentHp <= 15 then
        --血量过低
        self.Panel_bolld_un:setVisible(true)
        self.Panel_battle_ui_icon:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    else
        self.Panel_bolld_un:setVisible(false)
        self.Panel_battle_ui_icon:setColor(cc.c3b(color_Type[1][1],color_Type[1][2],color_Type[1][3]))
    end

end

function BattleUIIcon:updateSP(role, sp, maxSp, showSpEffect)
    local root = self.roots[1]
    self.role = role
    local persentSp = (zstring.tonumber(sp) / zstring.tonumber(maxSp) / 2)  * 100
    persentSp = math.max(0, math.min(50, persentSp))
    if nil ~= self.ProgressTimerBarBolld2 then
        self.ProgressTimerBarBolld2:setPercentage(persentSp)
    else
        self.LoadingBar_angry:setPercent(persentSp * 2)
    end
    
    if showSpEffect == true 
        and self._is_auto_fight == false
        then
        if persentSp >= 50 then
            --怒气满
            self.Panel_angry_open:setVisible(true)
            self.Panel_angry_open_1:setVisible(true)

            if self._fullEffectShow ~= true then
                if zstring.tonumber(_ED.user_info.user_experience) > 0
                    and zstring.tonumber(_ED.user_info.user_grade) < 5 then
                    state_machine.excute("battle_soft_guide_window_open", 0, self)
                end
                self._fullEffectShow = true
                self._fullEffect:setVisible(true)
                self._fullEffect:setAnimation(0, _spine_effect_animation_names[1], false)

                if config_res.battle ~= nil and config_res.battle.music ~= nil and config_res.battle.music.skill_effect ~= nil then
                    playEffectMusic(config_res.battle.music.skill_effect[3])
                end
            end
            -- if self._is_auto_fight == true then
            --     state_machine.excute("battle_role_skill_attack", 0, {role = self.role})
            -- else
                self.showSpEffect = true
            -- end
        else
            self.Panel_angry_open:setVisible(false)
            self.Panel_angry_open_1:setVisible(false)
            self.showSpEffect = false
            self._fullEffectShow = false
        end
    -- else
    --     if self._is_auto_fight == true and persentSp >= 50 then
    --         state_machine.excute("battle_role_skill_attack", 0, {role = self.role})
    --     end
    end
end

function BattleUIIcon:updateReset()
    if self.showSpEffect == false then
        return
    end
    local root = self.roots[1]
    self.role = role
    
    self.Panel_angry_open:setVisible(false)
    self.Panel_angry_open_1:setVisible(false)
    self.showSpEffect = false
    self._fullEffectShow = false
    state_machine.excute("battle_soft_guide_window_close", 0, 0)
end

function BattleUIIcon:autoFight(auto)
    self._is_auto_fight = auto
    -- if self._is_auto_fight == auto then
        self:updateReset()
    -- end
end

function BattleUIIcon:onUpdateDrawPercentage()

end

function BattleUIIcon:onUpdateDraw()
    local root = self.roots[1]

    local Panel_angry_release = ccui.Helper:seekWidgetByName(root, "Panel_angry_release")
    -- 创建怒气满时播放的爆炸特效
    local baseName = "images/ui/effice/effice_angry_open/effice_angry_open"
    self._fullEffect = sp.spine(baseName .. ".json", baseName .. ".atlas", 1, 0, nil, false, nil)
    Panel_angry_release:addChild(self._fullEffect)
    self._fullEffect:setVisible(false)
    self._fullEffect._self = self

    self._fullEffect:registerSpineEventHandler(function (event)
        event.skeletonAnimation:setVisible(false)
        -- event.skeletonAnimation._self.Panel_angry_open:setVisible(true)
        -- event.skeletonAnimation._self.Panel_angry_open_1:setVisible(true)
    end, sp.EventType.ANIMATION_COMPLETE)

    -- ui 点击动画
    self.Panel_push = ccui.Helper:seekWidgetByName(root, "Panel_push")
    if nil ~= self.Panel_push then
        local function changeActionCallback(armatureBack)
            armatureBack._parent:setVisible(false)
            self.touch_animation._invoke0 = armatureBack._invoke
            armatureBack._invoke = nil
        end
        self.touch_animation = self.Panel_push:getChildByName("ArmatureNode_2")
        draw.initArmature(self.touch_animation, nil, -1, 0, 1)
        self.touch_animation:getAnimation():playWithIndex(0, 0, 0)
        self.touch_animation._invoke0 = changeActionCallback
        self.touch_animation._self = self
        self.touch_animation._parent = self.Panel_push
    end

    -- ui
    self.Panel_bolld_un = ccui.Helper:seekWidgetByName(root,"Panel_bolld_un")
    self.Panel_battle_ui_icon = ccui.Helper:seekWidgetByName(root,"Panel_battle_ui_icon")

    self.Panel_angry_open = ccui.Helper:seekWidgetByName(root,"Panel_angry_open")
    self.Panel_angry_open_1 = ccui.Helper:seekWidgetByName(root,"Panel_angry_open_1")

    self.panel_bolld = ccui.Helper:seekWidgetByName(root, "Panel_bolld")
    if nil ~= self.panel_bolld then
        self.Sprite_bolld = self.panel_bolld:getChildByName("Sprite_bolld")
        local pos = cc.p(self.Sprite_bolld:getPosition())
        local anchor = self.Sprite_bolld:getAnchorPoint()
        local persent_hp = (zstring.tonumber(self.ship.lessHp) / zstring.tonumber(self.ship.maxHp) / 2)  * 100
    	persent_hp = (zstring.tonumber(self.ship.lessHp) / zstring.tonumber(self.ship.maxHp) / 2)  * 100

        self.Sprite_bolld:removeFromParent(false)
        self.ProgressTimerBarBolld = cc.ProgressTimer:create(self.Sprite_bolld)
        self.Sprite_bolld:setAnchorPoint(anchor)
        self.ProgressTimerBarBolld:setPosition(pos)
        self.panel_bolld:addChild(self.ProgressTimerBarBolld)
        self.ProgressTimerBarBolld:setReverseDirection(false)
        self.ProgressTimerBarBolld:setPercentage(persent_hp)
    else
        self.panel_bolld_1 = ccui.Helper:seekWidgetByName(root, "panel_bolld_1")
        self.LoadingBar_bolld = ccui.Helper:seekWidgetByName(root, "LoadingBar_bolld")
    end

    self.panel_angry = ccui.Helper:seekWidgetByName(root, "Panel_angry")
    if nil ~= self.panel_angry then
        self.Sprite_angry = self.panel_angry:getChildByName("Sprite_angry")
        local pos2 = cc.p(self.Sprite_angry:getPosition())
        local anchor2 = self.Sprite_angry:getAnchorPoint()

        local persent_bolld = 0
        self.Sprite_angry:removeFromParent(false)
        self.ProgressTimerBarBolld2 = cc.ProgressTimer:create(self.Sprite_angry)
        self.Sprite_angry:setAnchorPoint(anchor2)
        self.ProgressTimerBarBolld2:setPosition(pos2)
        self.panel_angry:addChild(self.ProgressTimerBarBolld2)
        self.ProgressTimerBarBolld2:setReverseDirection(true)
        self.ProgressTimerBarBolld2:setPercentage(persent_bolld)
    else
        self.Panel_angry_1 = ccui.Helper:seekWidgetByName(root, "Panel_angry_1")
        self.LoadingBar_angry = ccui.Helper:seekWidgetByName(root, "LoadingBar_angry")
    end

    local ship_mould_id = self.ship.ship_template_id
    local quality = self.ship.ship_type
    local Panel_battle_ui_icon = ccui.Helper:seekWidgetByName(root,"Panel_battle_ui_icon")
    local picIndex = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.head_icon)
    Panel_battle_ui_icon:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex)) 
    local Panel_hero_quality = ccui.Helper:seekWidgetByName(root,"Panel_hero_quality")
    Panel_hero_quality:setBackGroundImage(string.format("images/ui/quality/hero_icon_quality_%d.png", quality))
    local Panel_battle_ui_icon_star = ccui.Helper:seekWidgetByName(root,"Panel_battle_ui_icon_star")
    local stars,stars_level = getHeroStars(ship_mould_id)

    local Panel_types = ccui.Helper:seekWidgetByName(root, "Panel_types")
    if Panel_types ~= nil then
        local sign_msg = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.sign_msg)
        if sign_msg > 0 then
            Panel_types:setBackGroundImage(string.format("images/ui/quality/types_%d.png", sign_msg))
        end
    end
    local Text_role_name = ccui.Helper:seekWidgetByName(root, "Text_role_name")
    if Text_role_name ~= nil then
        local captain_name = dms.string(dms["ship_mould"], ship_mould_id, ship_mould.captain_name)
        local ship_type = dms.int(dms["ship_mould"], ship_mould_id, ship_mould.ship_type)
        Text_role_name:setString(captain_name)
        Text_role_name:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality+1][1],tipStringInfo_quality_color_Type[quality+1][2],tipStringInfo_quality_color_Type[quality+1][3]))
    end

    fwin:addTouchEventListener(Panel_battle_ui_icon, nil, 
    {
        terminal_name = "battle_ui_icon_skill_attack", 
        terminal_state = 0, 
        -- touch_scale = true,
        -- touch_scale_xy = 0.95,
        cell = self
    }, nil, 0)
    
    draw.addHeroStar(Panel_battle_ui_icon_star, stars, stars_level)
end

--缓存清理
function BattleUIIcon:close()
    
end

function BattleUIIcon:onInit()
    local csbItem = csb.createNode(config_csb.battle.battle_ui_icon)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(false)

    local __size = root:getContentSize()
    self:setContentSize(__size)
    table.insert(self.roots, root)
    self:addChild(root)
    self:onUpdateDraw() 
end

function BattleUIIcon:init(ship)
    self.ship = ship
    self:onInit()
    return self
end

function BattleUIIcon:onExit()
    local Panel_angry_release = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_angry_release")
    if Panel_angry_release ~= nil then
        Panel_angry_release:removeAllChildren(true)
    end
    local Panel_bolld = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_bolld")
    if Panel_bolld ~= nil then
        Panel_bolld:removeAllChildren(true)
    end
    local panel_angry = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_angry")
    if panel_angry ~= nil then
        panel_angry:removeAllChildren(true)
    end
end
-- ---------------------------------------------------------------------------------