-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗地图
-------------------------------------------------------------------------------------------------------
AdventureBattleMap = class("AdventureBattleMapClass", Window)

app.load("client.adventure.battle.AdventureBattleRole")
    
function AdventureBattleMap:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    self.fightIndex = 1
    self.bgIndex = 1

    self._hero_formation_ex = {}
    self._master_formation_ex = {}
    -- 我方显示背景层
    self.bg_own = nil
    -- 敌法显示背景层
    self.bg_enemy = nil

    self._root_index_enum = {
        _ENUM_MAP_LAYER_ROOT_INDEX = 1,         -- 地表层的root索引
        _ENUM_ROLE_LAYER_ROOT_INDEX = 2,        -- 角色层的root索引
        _ENUM_SKILL_LAYER_ROOT_INDEX = 3,       -- 技能层的root索引
    }

    self._action_info_enum = {
        _ENUM_ATTACKER_ATTACK_INFO = {  -- 1、我方攻击动画
            INDEX = 1, 
            ACTION_NAME = "own_walk", 
            ACTION_TURN_RIGHT_OWN_FRAME_NAME = "turn_right_own", 
            ACTION_TURN_FRONT_OWN_FRAME_NAME = "turn_front_own",
            ACTION_OVER_FRAME_NAME = "own_walk_over"
        },
        _ENUM_DEFENDER_ATTACK_INFO = {  -- 2、敌方攻击动画
            INDEX = 2, 
            ACTION_NAME = "enemy_walk", 
            ACTION_TURN_RIGHT_OWN_FRAME_NAME = "turn_left_enemy", 
            ACTION_TURN_FRONT_OWN_FRAME_NAME = "turn_front_enemy",
            ACTION_OVER_FRAME_NAME = "enemy_walk_over"
        },
        _ENUM_ATTACKER_SKILL_INFO = {  -- 3、绘制我方技能名称
            INDEX = 3, 
            ACTION_NAME = "skill_own",
            ACTION_OVER_FRAME_NAME = "skill_own_over"
        },
        _ENUM_DEFENDER_SKILL_INFO = {  -- 4、绘制敌方技能名称
            INDEX = 4, 
            ACTION_NAME = "skill_enemy",
            ACTION_OVER_FRAME_NAME = "skill_enemy_over"
        },
        _ENUM_ATTACKER_DAMAGE_INFO = {  -- 5、绘制我方伤害信息
            INDEX = 5, 
            ACTION_NAME = "own_diaoxue",
            ACTION_OVER_FRAME_NAME = "own_diaoxue_over"
        },
        _ENUM_DEFENDER_DAMAGE_INFO = {  -- 6、绘制敌方伤害信息
            INDEX = 6, 
            ACTION_NAME = "enemy_diaoxue",
            ACTION_OVER_FRAME_NAME = "enemy_diaoxue_over"
        },
        _ENUM_ATTACKER_HP_GAIN_INFO = {  -- 7、绘制我方加血信息
            INDEX = 7, 
            ACTION_NAME = "own_addxue",
            ACTION_OVER_FRAME_NAME = "own_addxue_over"
        },
        _ENUM_DEFENDER_HP_GAIN_INFO = {  -- 8、绘制敌方加血信息
            INDEX = 8, 
            ACTION_NAME = "enemy_addxue",
            ACTION_OVER_FRAME_NAME = "enemy_addxue_over"
        },
        _ENUM_MAP_SHAKE_INFO = {  -- 9、绘制地图的抖动
            INDEX = 9, 
            ACTION_NAME = "douping",
            ACTION_OVER_FRAME_NAME = "douping_over"
        },
        _ENUM_SCENE_EFFECT_INFO = {  -- 10-13、绘制地图的场景特效
            INDEX = 10, 
            ACTION_NAME = "douping",
            ACTION_OVER_FRAME_NAME = "douping_over"
        },
        _ENUM_ATTACKER_DAMAGE_UI_INFO = {  -- 14、我方承受UI动画
            INDEX = 14, 
            ACTION_NAME = "own_hurt_",
            ACTION_OVER_FRAME_NAME = "own_hurt_over"
        },
        _ENUM_DEFENDER_DAMAGE_UI_INFO = {  -- 15、敌方承受UI动画
            INDEX = 15, 
            ACTION_NAME = "enemy_hurt_",
            ACTION_OVER_FRAME_NAME = "enemy_hurt_over"
        },
        _ENUM_ATTACKER_MISS_INFO = {  -- 16、我方MISS动画
            INDEX = 16, 
            ACTION_NAME = "miss_own",
            ACTION_OVER_FRAME_NAME = "miss_own_over"
        },
        _ENUM_DEFENDER_MISS_INFO = {  -- 17、敌方MISS动画
            INDEX = 17, 
            ACTION_NAME = "miss_enemy",
            ACTION_OVER_FRAME_NAME = "miss_enemy_over"
        },
    }

    -- Initialize adventure battle map state machine.
    local function init_adventure_battle_map_terminal()
        -- 绘制攻击的技能名称特效
        local adventure_battle_map_draw_attack_skill_name_effect_terminal = {
            _name = "adventure_battle_map_draw_attack_skill_name_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:drawAttackSkillNameEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 移动到发动攻击的目标的
        local adventure_battle_map_move_attacker_terminal = {
            _name = "adventure_battle_map_move_attacker",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:playMoveAction(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 在地图中的绘制特效
        local adventure_battle_map_draw_effect_terminal = {
            _name = "adventure_battle_map_draw_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self:drawEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗场景中的抖屏
        local adventure_battle_map_draw_shake_terminal = {
            _name = "adventure_battle_map_draw_shake",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:shake(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 战斗场景中的闪屏
        local adventure_battle_map_draw_blink_terminal = {
            _name = "adventure_battle_map_draw_blink",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:blink(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 绘制战场中的伤害与增益
        local adventure_battle_map_draw_damage_and_buff_terminal = {
            _name = "adventure_battle_map_draw_damage_and_buff",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawDamageAndBuffNumbeAction(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制战斗MISS
        local adventure_battle_map_draw_miss_terminal = {
            _name = "adventure_battle_map_draw_miss",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawMiss(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 绘制战斗结束
        local adventure_battle_map_draw_battle_over_terminal = {
            _name = "adventure_battle_map_draw_battle_over",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:drawBattleOver(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(adventure_battle_map_draw_attack_skill_name_effect_terminal)
        state_machine.add(adventure_battle_map_move_attacker_terminal)
        state_machine.add(adventure_battle_map_draw_effect_terminal)
        state_machine.add(adventure_battle_map_draw_shake_terminal)
        state_machine.add(adventure_battle_map_draw_blink_terminal)
        state_machine.add(adventure_battle_map_draw_damage_and_buff_terminal)
        state_machine.add(adventure_battle_map_draw_miss_terminal)
        state_machine.add(adventure_battle_map_draw_battle_over_terminal)
        state_machine.init()
    end
    
    -- call func init adventure battle map state machine.
    init_adventure_battle_map_terminal()
end

function AdventureBattleMap:init(bgIndex)
    self.bgIndex = bgIndex or self.bgIndex
	if zstring.tonumber(_ED._battle_map_type) == 0 then
		local mapIndex = dms.int(dms["npc"], zstring.tonumber(_ED._scene_npc_id), npc.battle_background)
		self.bgIndex = mapIndex
	else
		self.bgIndex = math.random(1, 10)
	end
    return self
end

function AdventureBattleMap:initBackgroundImage(root)
    local bg = ccui.Helper:seekWidgetByName(root, "Panel_map")
    bg:removeBackGroundImage()
	bg:setBackGroundImage("map/battle/battle_"..self.bgIndex.."_0.png")
end

function AdventureBattleMap:initHero(root)
    local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_own")
    local index = 1
    for i=1, 25 do
        local hrole = _ED.battleData._heros["" .. i]
        local hero = nil
        if hrole ~= nil then
            local tile = rolePanel:getChildByName("Panel_role_"..index)
            tile:removeAllChildren(true)
            -- tile:setBackGroundImage("images/ui/bg/shadow.png")
            index = index + 1
            local role = AdventureBattleRole:new():init(tile, tile:getContentSize(), 0, hrole)
            table.insert(self._hero_formation_ex, role)
            tile:addChild(role, 1)
        end
    end
end

function AdventureBattleMap:initMaster(root)
    local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_enemy")
    local index = 1
    for i=1, 25 do
        local hrole = _ED.battleData._armys[self.fightIndex]._data["" .. i]
        local hero = nil
        if hrole ~= nil then
            local tile = rolePanel:getChildByName("Panel_role_"..index)
            tile:removeAllChildren(true)
            -- tile:setBackGroundImage("images/ui/bg/shadow.png")
            index = index + 1
            local role = AdventureBattleRole:new():init(tile, tile:getContentSize(), 1, hrole)
            table.insert(self._master_formation_ex, role)
            tile:addChild(role, 1)
        end
    end
end

--播放开始技能效果
function AdventureBattleMap:drawPlayBeganSkill(head_template_id)

    local params = self.m_skill_data
    local attacker = params[1]
    local skillElementData = params[2]
    local skillInfluenceElementData = params[3]
    local camp = attacker
    local size = self:getContentSize()
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("sprite/hero_head_effect/hero_head_effect.ExportJson")
    local armature = ccs.Armature:create("hero_head_effect")
    
    armature:getAnimation():playWithIndex(0)
    local root = self.roots[self._root_index_enum._ENUM_SKILL_LAYER_ROOT_INDEX]
    armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc)
    armature:getAnimation():setSpeedScale(1.0/__fight_recorder_action_time_speed)
    armature.__camp = camp
    armature._invoke = function(armatureBack)
        if armature.__camp == 0 then 
            --我方
            local action = self.actions[self._action_info_enum._ENUM_ATTACKER_SKILL_INFO.INDEX]
            action:play(self._action_info_enum._ENUM_ATTACKER_SKILL_INFO.ACTION_NAME, false)
            local Panel_skill_own = ccui.Helper:seekWidgetByName(root, "Panel_skill_own")
            Panel_skill_own:setVisible(false)
        else
            --敌方
            local action = self.actions[self._action_info_enum._ENUM_DEFENDER_SKILL_INFO.INDEX]
            action:play(self._action_info_enum._ENUM_DEFENDER_SKILL_INFO.ACTION_NAME, false)
            local Panel_skill_enemy = ccui.Helper:seekWidgetByName(root, "Panel_skill_enemy")
            Panel_skill_enemy:setVisible(false)

        end
        AdventureBattle.deleteEffectFile(armatureBack)
    end
    
    local root = self.roots[2]
    root:addChild(armature)
    local showPos = cc.p(0,0)
    if camp == 0 then
        -- -- 绘制我方图片
       local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_own")
       showPos = cc.p(size.width/2,rolePanel:getPositionY() + rolePanel:getContentSize().height)
    else
        -- 绘制敌法图片
        local rolePanel = ccui.Helper:seekWidgetByName(root, "Panel_enemy") 
        showPos = cc.p(size.width/2,rolePanel:getPositionY() + rolePanel:getContentSize().height/2)
    end
    armature:setPosition(showPos)
    local imageNamePath = ""
    local imageRolePath = ""
    
    imageNamePath = string.format("images/face/rage_head/effice_name_%s.png", "" ..head_template_id) 
    
    imageRolePath = string.format("images/face/rage_head/head_%s.png", "" ..head_template_id) 
    
    local skill_name1 = ccs.Skin:create(imageNamePath)
    local skill_name2 = ccs.Skin:create(imageNamePath)
    local skill_name3 = ccs.Skin:create(imageNamePath)
    local skill_role = ccs.Skin:create(imageRolePath)
    armature:getBone("name_1"):addDisplay(skill_name1, 0)   
    armature:getBone("name_2"):addDisplay(skill_name2, 0)   
    armature:getBone("name_3"):addDisplay(skill_name3, 0)   
    armature:getBone("fit_1"):addDisplay(skill_role, 0)   

end

--正常播放普通技能
function AdventureBattleMap:drawPlayNomalSkill()
    local root = self.roots[self._root_index_enum._ENUM_SKILL_LAYER_ROOT_INDEX]
    local params = self.m_skill_data
    local attacker = params[1]
    local skillElementData = params[2]
    local skillInfluenceElementData = params[3]
    local camp = attacker
     
    self.bg_own:removeBackGroundImage()
    self.bg_enemy:removeBackGroundImage()
    if camp == 0 then
        -- -- 绘制我方图片
        local Panel_skill_own = ccui.Helper:seekWidgetByName(root, "Panel_skill_own")
        Panel_skill_own:setVisible(true)
        if params[4] > 0 then
            local headImg = _ED.battleData._heros["" .. params[4]]
            if headImg ~= nil   then
                local imageName = string.format("images/face/big_head/big_head_%s.png", headImg._head)
                self.bg_own:setBackGroundImage(imageName)
            end 
        end
        local action = self.actions[self._action_info_enum._ENUM_ATTACKER_SKILL_INFO.INDEX]
        action:play(self._action_info_enum._ENUM_ATTACKER_SKILL_INFO.ACTION_NAME, false)

        local Text_skill_own = ccui.Helper:seekWidgetByName(root, "Text_skill_own")
        Text_skill_own:setVisible(true)
        local skillName = dms.atos(skillElementData, skill_mould.skill_name)
        Text_skill_own:setString(skillName)
    else
        -- 绘制敌法图片
         if params[4] > 0 then
            local Panel_skill_enemy = ccui.Helper:seekWidgetByName(root, "Panel_skill_enemy")
            Panel_skill_enemy:setVisible(true)

            local headImg = _ED.battleData._armys[1]._data["" .. params[4]]
                
            if headImg ~= nil   then
                local imageName = string.format("images/face/big_head/big_head_%s.png", headImg._head)
                self.bg_enemy:setBackGroundImage(imageName) 
            end 
        end
        local action = self.actions[self._action_info_enum._ENUM_DEFENDER_SKILL_INFO.INDEX]
        action:play(self._action_info_enum._ENUM_DEFENDER_SKILL_INFO.ACTION_NAME, false)

        local Text_skill_own = ccui.Helper:seekWidgetByName(root, "Text_skill_enemy")
        Text_skill_own:setVisible(true)
        local skillName = dms.atos(skillElementData, skill_mould.skill_name)
        Text_skill_own:setString(skillName)
    end
end

--播放技能
function AdventureBattleMap:drawAttackSkillNameEffect(params)
    self.m_skill_data = params
    local root = self.roots[self._root_index_enum._ENUM_SKILL_LAYER_ROOT_INDEX]
    local attacker = params[1]
    local skillElementData = params[2]
    local skillInfluenceElementData = params[3]
    local skillId = dms.atoi(skillElementData, skill_mould.id)
    local camp = attacker
     if camp == 0 then
        -- -- 绘制我方图片
        if params[4] > 0 then
            local head_template = _ED.battleData._heros["" .. params[4]]
            if head_template ~= nil then 
                local pic = dms.int(dms["ship_mould"],head_template._mouldId, ship_mould.screen_attack_effect)
                if pic ~= nil and pic ~= -1 and skillId ~= 5 then 
                    if zstring.tonumber(_game_platform_version_type) == 1 or zstring.tonumber(_game_platform_version_type) == 4 then 
                        self:drawPlayBeganSkill(pic)
                    else
                        self:drawPlayNomalSkill()  
                    end
                    
                    --
                    --self:drawPlayBeganSkill(61)
                else
                    self:drawPlayNomalSkill()
                end
            else
                self:drawPlayNomalSkill()
            end
        else
            self:drawPlayNomalSkill()
        end
    else
        -- 绘制敌法图片
        if params[4] > 0 then
            local head_template = _ED.battleData._armys[1]._data["" .. params[4]]

            if head_template ~= nil then
                
                local directing = nil
                local pic = nil
                if (zstring.tonumber(_ED.battleData.battle_init_type) >= 0 
                --PVE 
                    and zstring.tonumber(_ED.battleData.battle_init_type) <= 9 )
                    or zstring.tonumber(_ED.battleData.battle_init_type) == 14 then 
                    directing = dms.string(dms["environment_ship"], head_template._mouldId, environment_ship.directing)
                    pic = dms.int(dms["ship_mould"], directing, ship_mould.screen_attack_effect)
                else
                --PVP 
                    pic = dms.int(dms["ship_mould"], head_template._mouldId, ship_mould.screen_attack_effect)
                end
                if pic~= nil and pic ~= -1 and skillId ~= 5 then 
                    if zstring.tonumber(_game_platform_version_type) == 1 or zstring.tonumber(_game_platform_version_type) == 4 then 
                        self:drawPlayBeganSkill(pic)
                    else
                        self:drawPlayNomalSkill()    
                    end
                else
                    self:drawPlayNomalSkill()
                end
            else
                self:drawPlayNomalSkill()
            end 
        else
            self:drawPlayNomalSkill()
        end
    end
end

function AdventureBattleMap:drawMiss(params)
    local camp = params
    if camp == 0 then
        local action = self.actions[self._action_info_enum._ENUM_ATTACKER_MISS_INFO.INDEX]
        action:play(self._action_info_enum._ENUM_ATTACKER_MISS_INFO.ACTION_NAME, false)
        self:animationChangeToAction(self._hero_formation_ex, _enum_animation_adventure_frame_index.animation_is_miss, _enum_animation_adventure_frame_index.animation_down)
    else
        local action = self.actions[self._action_info_enum._ENUM_DEFENDER_MISS_INFO.INDEX]
        action:play(self._action_info_enum._ENUM_DEFENDER_MISS_INFO.ACTION_NAME, false)
        self:animationChangeToAction(self._master_formation_ex, _enum_animation_adventure_frame_index.animation_is_miss, _enum_animation_adventure_frame_index.animation_down)
    end
end

function AdventureBattleMap:drawBattleOver(params)
    local win = zstring.tonumber(params)
    local heroActionIndex = _enum_animation_adventure_frame_index.animation_win_action
    local masterActionIndex = _enum_animation_adventure_frame_index.animation_is_death
    if win == 0 then
        heroActionIndex = _enum_animation_adventure_frame_index.animation_is_death
        masterActionIndex = _enum_animation_adventure_frame_index.animation_win_action
    end

    self:animationChangeToAction(self._hero_formation_ex, heroActionIndex, heroActionIndex)

    self:animationChangeToAction(self._master_formation_ex, masterActionIndex, masterActionIndex)
end

function AdventureBattleMap:animationChangeToAction(formationBack, actionIndex, nextIndex)
    for i, v in pairs(formationBack) do
        csb.animationChangeToAction(v.armature, actionIndex, nextIndex, false)
    end
end

function AdventureBattleMap:playMoveAction(params)
    local action = nil -- self.actions[1]
    local camp = params
    if camp == 0 then
        action = self.actions[self._action_info_enum._ENUM_ATTACKER_ATTACK_INFO.INDEX]
        action:play(self._action_info_enum._ENUM_ATTACKER_ATTACK_INFO.ACTION_NAME, false)

        -- self:animationChangeToAction(self._hero_formation_ex, _enum_animation_adventure_frame_index.animation_right, _enum_animation_adventure_frame_index.animation_down)
    else
        action = self.actions[self._action_info_enum._ENUM_DEFENDER_ATTACK_INFO.INDEX]
        action:play(self._action_info_enum._ENUM_DEFENDER_ATTACK_INFO.ACTION_NAME, false)

        -- self:animationChangeToAction(self._master_formation_ex, _enum_animation_adventure_frame_index.animation_right, _enum_animation_adventure_frame_index.animation_down)
    end
end

function AdventureBattleMap:drawEffect(params)
    local root = self.roots[self._root_index_enum._ENUM_ROLE_LAYER_ROOT_INDEX]
    local drawNode = nil
    local camp = params[1]
    local armatureEffect = params[2]
    if camp == 0 then
        drawNode = ccui.Helper:seekWidgetByName(root, "Panel_effect_attack_own")
    else
        drawNode = ccui.Helper:seekWidgetByName(root, "Panel_effect_attack_enemy")
    end
    drawNode:addChild(armatureEffect)
    return drawNode
end

function AdventureBattleMap:shake(params)
    local action = self.actions[9]
    action:play("douping", false)
end

function AdventureBattleMap:blink(params)
    local typeIndex = params
    local action = self.actions[self._action_info_enum._ENUM_SCENE_EFFECT_INFO.INDEX + typeIndex]
    if action ~= nil then
        local action_names = {
            "battle_hong",          -- 红色背景
            "battle_yellow",        -- 黄色背景
            "battle_purple",        -- 紫色背景
            "battle_black",         -- 黑色背景
        }
        action:play(action_names[typeIndex + 1], false)
    end
end

function AdventureBattleMap:drawDamageAndBuffNumbeAction(params)
    local root = self.roots[self._root_index_enum._ENUM_ROLE_LAYER_ROOT_INDEX]
    local camp = zstring.tonumber(params[1])
    local value = zstring.tonumber(params[2])
    local skillInfluenceElementData = params[3]
    local tempString = ""..dms.atos(skillInfluenceElementData, skill_influence.scene_effect)
    local skill_effect = zstring.tonumber(zstring.split(tempString, ",")[2])
    local action_index = _enum_animation_adventure_frame_index.animation_be_attaked
    if skill_effect == 2 then
        action_index = _enum_animation_adventure_frame_index.animation_be_attaked_1
    elseif skill_effect == 3 then
        action_index = _enum_animation_adventure_frame_index.animation_be_attaked_1
    end
    if camp == 0 then
        if value > 0 then
            ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_2"):setString("+"..value)
            self.actions[self._action_info_enum._ENUM_ATTACKER_HP_GAIN_INFO.INDEX]:play(self._action_info_enum._ENUM_ATTACKER_HP_GAIN_INFO.ACTION_NAME, false)
        else
            ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_1"):setString(""..value)
            self.actions[self._action_info_enum._ENUM_ATTACKER_DAMAGE_INFO.INDEX]:play(self._action_info_enum._ENUM_ATTACKER_DAMAGE_INFO.ACTION_NAME, false)
            self.actions[self._action_info_enum._ENUM_ATTACKER_DAMAGE_UI_INFO.INDEX]:play(self._action_info_enum._ENUM_ATTACKER_DAMAGE_UI_INFO.ACTION_NAME .. skill_effect, false)
            self:animationChangeToAction(self._hero_formation_ex, action_index, _enum_animation_adventure_frame_index.animation_down)
        end
    else
        if value > 0 then
            ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_4"):setString("+"..value)
            self.actions[self._action_info_enum._ENUM_DEFENDER_HP_GAIN_INFO.INDEX]:play(self._action_info_enum._ENUM_DEFENDER_HP_GAIN_INFO.ACTION_NAME, false)
        else
            ccui.Helper:seekWidgetByName(root, "BitmapFontLabel_3"):setString(""..value)
            self.actions[self._action_info_enum._ENUM_DEFENDER_DAMAGE_INFO.INDEX]:play(self._action_info_enum._ENUM_DEFENDER_DAMAGE_INFO.ACTION_NAME, false)
            self.actions[self._action_info_enum._ENUM_DEFENDER_DAMAGE_UI_INFO.INDEX]:play(self._action_info_enum._ENUM_DEFENDER_DAMAGE_UI_INFO.ACTION_NAME .. skill_effect, false)
            self:animationChangeToAction(self._master_formation_ex, action_index, _enum_animation_adventure_frame_index.animation_down)
        end
    end
end

function AdventureBattleMap:onEnterTransitionFinish()
    local csbAdventureBattleMap = csb.createNode("battle/battle_map_tile.csb")
    local root = csbAdventureBattleMap:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureBattleMap)

    -- initailize map background iamge
    self:initBackgroundImage(root)

    local csbBattleMapAtteck = csb.createNode("battle/battle_map_atteck.csb")
    root = csbBattleMapAtteck:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleMapAtteck)

    -- initailize hero
    self:initHero(root)

    -- initailize master
    self:initMaster(root)

    -- initailize action
    -- 战斗红黑效果 battle_hong  battle_hong_over
    -- 战斗中我方移动 own_walk  own_walk_over
    -- 战斗中敌方移动 enemy_walk  enemy_walk_over
    
    -- 添加动画：1、我方攻击动画
    local action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("战斗中的动画事件帧", str)
        if str == self._action_info_enum._ENUM_ATTACKER_ATTACK_INFO.ACTION_TURN_RIGHT_OWN_FRAME_NAME then -- 攻击前的转向
            self:animationChangeToAction(self._hero_formation_ex, _enum_animation_adventure_frame_index.animation_up, _enum_animation_adventure_frame_index.animation_up)
        elseif str == self._action_info_enum._ENUM_ATTACKER_ATTACK_INFO.ACTION_OVER_FRAME_NAME then
            state_machine.excute("adventure_battle_execute_attack", 0, 0)
        elseif str == self._action_info_enum._ENUM_ATTACKER_ATTACK_INFO.ACTION_TURN_FRONT_OWN_FRAME_NAME then -- 攻击完成后的转向
            self:animationChangeToAction(self._hero_formation_ex, _enum_animation_adventure_frame_index.animation_down, _enum_animation_adventure_frame_index.animation_down)
        end
    end)

    -- 添加动画：2、敌方攻击动画
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("战斗中的动画事件帧", str)
        if str == self._action_info_enum._ENUM_DEFENDER_ATTACK_INFO.ACTION_TURN_RIGHT_OWN_FRAME_NAME then -- 攻击前的转向
            self:animationChangeToAction(self._master_formation_ex, _enum_animation_adventure_frame_index.animation_right, _enum_animation_adventure_frame_index.animation_right)
        elseif str == self._action_info_enum._ENUM_DEFENDER_ATTACK_INFO.ACTION_OVER_FRAME_NAME  then
            state_machine.excute("adventure_battle_execute_attack", 0, 0)
        elseif str == self._action_info_enum._ENUM_DEFENDER_ATTACK_INFO.ACTION_TURN_FRONT_OWN_FRAME_NAME then -- 攻击完成后的转向
            self:animationChangeToAction(self._master_formation_ex, _enum_animation_adventure_frame_index.animation_right, _enum_animation_adventure_frame_index.animation_down)
        end
    end)

    -- 添加动画：3、绘制我方技能名称
    local csbBattleSkillTxt = csb.createNode("battle/battle_skilltxt.csb")
    local root = csbBattleSkillTxt:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleSkillTxt)

    self.bg_own = ccui.Helper:seekWidgetByName(self.roots[self._root_index_enum._ENUM_SKILL_LAYER_ROOT_INDEX], "Panel_own_skill")
    self.bg_enemy = ccui.Helper:seekWidgetByName(self.roots[self._root_index_enum._ENUM_SKILL_LAYER_ROOT_INDEX], "Panel_enemy_skill")
    -- action = csb.createTimeline("battle/battle_map.csb")
    -- table.insert(self.actions, action)
    -- csbAdventureBattleMap:runAction(action)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end

    --     local str = frame:getEvent()
    --     -->__crint("我方攻击技能名称动画帧事件名称：", str)
    --     if str == "skill_own_over" then
    --         state_machine.excute("adventure_battle_execute_skill_name_effect_over", 0, 0)
    --     end
    -- end)

    action = csb.createTimeline("battle/battle_skilltxt.csb")
    table.insert(self.actions, action)
    csbBattleSkillTxt:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("我方攻击技能名称动画帧事件名称：", str)
        if str == self._action_info_enum._ENUM_ATTACKER_SKILL_INFO.ACTION_OVER_FRAME_NAME then
            state_machine.excute("adventure_battle_execute_skill_name_effect_over", 0, 0)
        end
    end)

    -- 添加动画：4、绘制敌方技能名称
    -- action = csb.createTimeline("battle/battle_map.csb")
    -- table.insert(self.actions, action)
    -- csbAdventureBattleMap:runAction(action)
    -- action:setFrameEventCallFunc(function (frame)
    --     if nil == frame then
    --         return
    --     end

    --     local str = frame:getEvent()
    --     -->__crint("敌方攻击技能名称动画帧事件名称：", str)
    --     if str == "skill_enemy_over" then
    --         state_machine.excute("adventure_battle_execute_skill_name_effect_over", 0, 0)
    --     end
    -- end)

    action = csb.createTimeline("battle/battle_skilltxt.csb")
    table.insert(self.actions, action)
    csbBattleSkillTxt:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("我方攻击技能名称动画帧事件名称：", str)
        if str == self._action_info_enum._ENUM_DEFENDER_SKILL_INFO.ACTION_OVER_FRAME_NAME then
            state_machine.excute("adventure_battle_execute_skill_name_effect_over", 0, 0)
        end
    end)

    -- 添加动画：5、绘制我方伤害信息
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制我方伤害信息动画帧事件名称：", str)
        if str == self._action_info_enum._ENUM_ATTACKER_DAMAGE_INFO.ACTION_OVER_FRAME_NAME then
            
        end
    end)

    -- 添加动画：6、绘制敌方伤害信息
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制敌方伤害信息动画帧事件名称：", str)
        if str == self._action_info_enum._ENUM_DEFENDER_DAMAGE_INFO.ACTION_OVER_FRAME_NAME then

        end
    end)

    -- 添加动画：7、绘制我方加血信息
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制我方伤害信息动画帧事件名称：", str)
        if str == self._action_info_enum._ENUM_ATTACKER_HP_GAIN_INFO.ACTION_OVER_FRAME_NAME then
            
        end
    end)

    -- 添加动画：8、绘制敌方加血信息
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制敌方伤害信息动画帧事件名称：", str)
        if str == self._action_info_enum._ENUM_DEFENDER_HP_GAIN_INFO.ACTION_OVER_FRAME_NAME then
            
        end
    end)

    -- 添加动画：9、绘制地图的抖动
    action = csb.createTimeline("battle/battle_map_tile.csb")
    table.insert(self.actions, action)
    csbAdventureBattleMap:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制地图的抖动：", str)
        if str == "" then
            
        end
    end)

    -- 添加动画：10-13、绘制地图的场景特效
    for i = 1, 4 do
        action = csb.createTimeline("battle/battle_map_tile.csb")
        table.insert(self.actions, action)
        csbAdventureBattleMap:runAction(action)
        action:setFrameEventCallFunc(function (frame)
            if nil == frame then
                return
            end

            local str = frame:getEvent()
            -->__crint("绘制地图的场景特效：", str)
            if str == "" then
                
            end
        end)
    end

    -- 添加动画：14、我方承受UI动画
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制地图的抖动：", str)
        if str == "" then
            
        end
    end)

    -- 添加动画：15、敌方承受UI动画
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制地图的抖动：", str)
        if str == "" then
            
        end
    end)

    -- 添加动画：16、我方MISS动画
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制地图的抖动：", str)
        if str == "" then
            
        end
    end)

    -- 添加动画：17、敌方MISS动画
    action = csb.createTimeline("battle/battle_map_atteck.csb")
    table.insert(self.actions, action)
    csbBattleMapAtteck:runAction(action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -->__crint("绘制地图的抖动：", str)
        if str == "" then
            
        end
    end)
end

function AdventureBattleMap:onExit()
    state_machine.remove("adventure_battle_map_draw_attack_skill_name_effect")
    state_machine.remove("adventure_battle_map_move_attacker")
    state_machine.remove("adventure_battle_map_draw_effect")
    state_machine.remove("adventure_battle_map_draw_shake")
    state_machine.remove("adventure_battle_map_draw_blink")
    state_machine.remove("adventure_battle_map_draw_damage_and_buff")
    state_machine.remove("adventure_battle_map_draw_miss")
    state_machine.remove("adventure_battle_map_draw_battle_over") 
end