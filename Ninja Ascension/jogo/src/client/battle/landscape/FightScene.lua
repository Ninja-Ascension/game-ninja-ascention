FightScene = class("FightSceneClass", Window)

function FightScene:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.group = {
        _background_view = nil,
        _far_view = nil,
        _earth_view = nil,
        _role_view = nil,
        _near_view = nil,
    }
    
    self._isPvEFight = false
    self._map_index = "0"
    self._npc_type = "0"

    self._dir = 0
    self._camera_pos = cc.p(0, 0)
    self._camera_move_pos = cc.p(0, 0)
    self._camera_pos_end = cc.p(0, 0)

    self._center_position = cc.p(0, 0)
    self._original_position = cc.p(0, 0)
    self._move_size = cc.size(0, 0)
    self._view_size = cc.size(0, 0)

    self._moveMode = 0
    self._dir_enum = {
        _NIL = 0,           -- 静止
        _TOP = 1,           -- 上  
        _RIGHT = 2,         -- 右
        _BOTTOM = 3,        -- 下
        _LEFT = 4           -- 左
    }

    self.shake_action = nil
    self.blink_black_action = nil
    self.blink_white_action = nil
    self.shake_layer = nil
    self.blink_black_layer = nil
    self.blink_white_layer = nil

    self.isWhideScene = false
    self.isBlackEnterScene = false
    self.isBlackIngScene = false
    self.isBlackOutScene = false

    self.isNeedUpdateFocus = false

    -- Initialize fight scene state machine.
    local function init_fight_scene_terminal()
        local fight_scene_change_to_next_fight_scene_terminal = {
            _name = "fight_scene_change_to_next_fight_scene",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:changeToNextFightScene(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_scene_change_to_fight_scene_terminal = {
            _name = "fight_scene_change_to_fight_scene",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- eg: state_machine.excute("fight_scene_change_to_fight_scene", 0, 1)
                return instance:changeToFightScene(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_scene_camera_focussing_terminal = {
            _name = "fight_scene_camera_focussing",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:cameraFocussing(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_scene_views_visible_terminal = {
            _name = "fight_scene_views_visible",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                self.group._background_view:setVisible(params[1])
                self.group._far_view:setVisible(params[2])
                self.group._earth_view:getChildByName("Panel_battle_3"):setVisible(params[3])
                self.group._role_view:setVisible(params[4])
                self.group._near_view:setVisible(params[5])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 初始化战斗场景
        local fight_scene_initialize_scene_terminal = {
            _name = "fight_scene_initialize_scene",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:initializeScene()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 战斗场景中的抖屏
        local fight_scene_shake_terminal = {
            _name = "fight_scene_shake",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if __lua_project_id == __lua_project_gragon_tiger_gate 
                    or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
                    or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
                    or __lua_project_id == __lua_project_l_naruto 
                    or __lua_project_id == __lua_project_red_alert 
                    then
                    state_machine.excute("fight_ui_shake_ui", o, nil)
                    state_machine.excute("fight_qte_controller_shake_ui", 0, nil)
                    instance:shake(params)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 战斗场景中的闪屏
        local fight_scene_blink_black_terminal = {
            _name = "fight_scene_blink_black",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:blinkBlack(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗场景中的白屏
        local fight_scene_blink_white_terminal = {
            _name = "fight_scene_blink_white",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:blinkWhite(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_scene_add_shake_ui_terminal = {
            _name = "fight_scene_add_shake_ui",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addShakeUILayer(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 场景缩放特效处理
        local fight_scene_scene_scale_effect_terminal = {
            _name = "fight_scene_scene_scale_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:sceneScaleEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择被攻击的目标
        local fight_scene_play_power_skill_screen_effect_terminal = {
            _name = "fight_scene_play_power_skill_screen_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:palyerPowerSkillScreenEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local fight_scene_play_by_attack_screen_bottom_effect_terminal = {
            _name = "fight_scene_play_by_attack_screen_bottom_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:palyByAttackScreenBottomEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        state_machine.add(fight_scene_change_to_next_fight_scene_terminal)
        state_machine.add(fight_scene_change_to_fight_scene_terminal)
        state_machine.add(fight_scene_camera_focussing_terminal)
        state_machine.add(fight_scene_views_visible_terminal)
        state_machine.add(fight_scene_initialize_scene_terminal)
        state_machine.add(fight_scene_shake_terminal)
        state_machine.add(fight_scene_blink_black_terminal)
        state_machine.add(fight_scene_blink_white_terminal)
        state_machine.add(fight_scene_add_shake_ui_terminal)
        state_machine.add(fight_scene_scene_scale_effect_terminal)
        state_machine.add(fight_scene_play_power_skill_screen_effect_terminal)
        state_machine.add(fight_scene_play_by_attack_screen_bottom_effect_terminal)
        state_machine.init()
    end

    -- call func init fight scene state machine.
    init_fight_scene_terminal()
end

function FightScene:init(mapIndex, _npc_type, isPveFight)
    self._map_index = zstring.split(mapIndex, ",")
    self._npc_type = _npc_type
    self._isPvEFight = isPveFight

    self._load_over = false
    self:onLoad()
    return self
end

function FightScene.onImageLoaded(texture)
    
end

function FightScene:onArmatureDataLoad(percent)
    
end

function FightScene:onArmatureDataLoadEx(percent)
    -- if percent >= 1 then
    --  if self._load_over == false then
    --      self._load_over = true
    --      self:onInit()
    --  end
    -- end
end

function FightScene:onLoad()
    -- local effect_paths = {
    --  "images/ui/effice/effect_22/effect_22.ExportJson",
    --  "images/ui/effice/effect_26/effect_26.ExportJson"
    -- }
    -- for i, v in pairs(effect_paths) do
    --  local fileName = v
    --  ccs.ArmatureDataManager:getInstance():addArmatureFileInfoAsync(fileName, self.onArmatureDataLoad, self.onArmatureDataLoadEx, self)
    -- end

    -- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
    -- cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.onInit, self, true)

    self:onInit()
end

function FightScene:addMapLayerScaleAction(_layer, _scale, _interval)
    _layer:runAction(cc.ScaleTo:create(_interval * __fight_recorder_action_time_speed, _scale))
    -- _layer:setScale(_scale)
end

function FightScene:getCameraController()
    local currentController = self._camera._controller
    local spaceWidth = self._camera._vxyz._right.x - self._camera._vxyz._left.x
    self._camera._vxyz._bottom.y = 0
    local spaceHeight = self._camera._vxyz._bottom.y
    for i, v in pairs(_camera_controller) do
        if v._half_width >= spaceWidth and v._half_height >= spaceHeight then
            currentController = v
            break;
        end
    end
    return currentController
end

function FightScene:initializeScene()
    self._scale_to = 0.9 --0.42253521084785
    self._swap_position.x = 0
    self._swap_position.y = 0
    local root = self.roots[1]
    root:setScale(1)
    self.isNeedUpdateFocus = false
    while true do
        self:onUpdate(0.1)
        if self._scale == self._scale_to
            and self._move_position.x == self._swap_position.x
            and self._move_position.y == self._swap_position.y
            then
            break
        end
    end
end

function FightScene:sceneScaleEffect(params)
    local camp = params[1]
    local line = params[2]
    local isFly = params[3]
    local isStart = params[4]

    self.group._earth_view:stopAllActions()
    self.group._far_view:stopAllActions()
    self.group._near_view:stopAllActions()

    local root = self.roots[1]
    if isStart == false then
        -- print("缩小",__fight_recorder_action_time_speed)
        root:stopActionByTag(10)
        local function scaleFuncEnd( sender )
            if sender ~= nil then
                self.isNeedUpdateFocus = false
            end
        end
        local array = {}
        table.insert(array, cc.ScaleTo:create(0.2 * __fight_recorder_action_time_speed, 1))
        table.insert(array, cc.CallFunc:create(scaleFuncEnd))
        local seq = cc.Sequence:create(array)
        seq:setTag(20)
        root:runAction(seq)
    else
        -- print("放大",__fight_recorder_action_time_speed)
        if isFly == true then
            line = 1
        end

        self.isNeedUpdateFocus = true

        local size = root:getContentSize()

        local role = params[5]
        local scale = 0
        if role ~= nil then
            scale = dms.atoi(role.armature._sed_action, skill_mould.zoom_ratio)
        end
        -- 计算缩放值
        if scale > 0 then
            scale = scale / 100
        end
        
        if scale <= 0 then
            self.isNeedUpdateFocus = false
            return
        end
        -- print(scale)

        -- if root:getScale() > 1 then
        --     return
        -- end

        -- debug.print_r(params)

        -- Reset root anchor point and position.
        local previousAnchor = root:getAnchorPoint()
        local previousPosition = cc.p(root:getPosition())
        local nextAnchor = cc.p(0, 0)
        local nextPosition = cc.p(0, 0)
        local movePosition = cc.p(0, 0)

        -- if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        --     or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        --     -- or __lua_project_id == __lua_project_l_naruto 
        --     then
        --     movePosition.x = 1 * (fwin._width - app.baseOffsetX)
        -- else
            movePosition.x = camp * (fwin._width - app.baseOffsetX)
        -- end
        movePosition.y = _battle_controller._solid_position[line]

        nextAnchor.x = movePosition.x / size.width
        nextAnchor.y = movePosition.y / size.height

        nextPosition.x = movePosition.x
        nextPosition.y = movePosition.y

        root:setAnchorPoint(nextAnchor)
        root:setPosition(nextPosition)

        root:setScale(root:getScale() + 0.0001)
        root:stopActionByTag(20)
        local scaleTo = cc.ScaleTo:create(0.2 * __fight_recorder_action_time_speed, scale)
        scaleTo:setTag(10)
        root:runAction(scaleTo)
    end
end

function FightScene:shake(params)
    self.shake_action:gotoFrameAndPlay(0, self.shake_action:getDuration(), false)
end

function FightScene:blinkBlack(params)
    -- print("动作启动黑屏帧事件------------------", self.isBlackEnterScene, self.isBlackIngScene, self.isBlackOutScene)
    self.blink_black_layer:setVisible(true)

    if self.isBlackEnterScene == true then

    elseif self.isBlackIngScene == true then
        self.isBlackIngScene = true
        self.blink_black_action:play("heiping_chixu", false)
    elseif self.isBlackOutScene == true then
        self.isBlackEnterScene = true
        self.blink_black_action:play("heiping_danru", false)
    else
        self.isBlackEnterScene = true
        self.blink_black_action:play("heiping_danru", false)
    end
end

function FightScene:blinkWhite()
    -- print("blinkWhite:::", blinkWhite)
    self.isWhideScene = true
    self.blink_white_layer:setVisible(true)
    self.blink_white_action:gotoFrameAndPlay(0, self.blink_white_action:getDuration(), false)
end

function FightScene:addShakeUILayer( canSkipFighting )
    local obj = FightUI:new():init(canSkipFighting, self._isPvEFight)
    self._rootWindows = self.topLayer
    fwin:open(obj, fwin._view)
end

function FightScene:onInit()
    local csbFightScene = csb.createNode(string.format("battle/battle_map_heng_mian.csb", self._map_index[1]))
    local root = csbFightScene:getChildByName("root")
    table.insert(self.roots, root)
    -- self:addChild(csbFightScene)

    self.topLayer = csbFightScene
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        self.group._background_view = ccui.Helper:seekWidgetByName(root, "Panel_map_bg")
        local mapLayer = csb.createNode(string.format("battle/battle_map_heng_%s.csb", self._map_index[1]))
        self.group._background_view:addChild(mapLayer)
    else
        self.group._background_view = ccui.Helper:seekWidgetByName(root, "Panel_bg_1")
    end
    self.group._far_view = ccui.Helper:seekWidgetByName(root, "Panel_bg_2")
    self.group._earth_view = ccui.Helper:seekWidgetByName(root, "Panel_bg_3")
    self.group._role_view = ccui.Helper:seekWidgetByName(root, "Panel_role_layer")
    self.group._near_view = ccui.Helper:seekWidgetByName(root, "Panel_bg_4")
    self.group._near_view:setTouchEnabled(false)

    self.shake_layer = csb.createNode("battle/battle_map_heng_dt.csb")
    local shakeSceneRoot = self.shake_layer:getChildByName("root")
    local shake_action = csb.createTimeline("battle/battle_map_heng_dt.csb")
    self.shake_action = shake_action
    self.shake_layer:runAction(shake_action)
    self:addChild(self.shake_layer)
    local panel = ccui.Helper:seekWidgetByName(shakeSceneRoot, "Panel_ditu_doudong")
    panel:addChild(csbFightScene)

    self.blink_black_layer = csb.createNode("battle/battle_map_heng_sp_hei.csb")
    local blink_action = csb.createTimeline("battle/battle_map_heng_sp_hei.csb")
    self.blink_black_action = blink_action
    self.blink_black_layer:runAction(blink_action)
    self.group._earth_view:getChildByName("Panel_baiping"):addChild(self.blink_black_layer)
    self.blink_black_layer:setVisible(false)

    self.blink_black_action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        -- print("黑屏帧事件------------------", str)
        if str == "heiping_danru_over" then
            self.isBlackEnterScene = false
            self.isBlackIngScene = true
            self.blink_black_action:play("heiping_chixu", false)
        elseif str == "heiping_chixu_over" then
            self.isBlackIngScene = false
            self.isBlackOutScene = true
            self.blink_black_action:play("heiping_danchu", false)
        elseif str == "heiping_danchu_over" then
            self.isBlackEnterScene = false
            self.isBlackIngScene = false
            self.isBlackOutScene = false
            self.blink_black_layer:setVisible(false)
        end
    end)

    self.blink_white_layer = csb.createNode("battle/battle_map_heng_sp_bai.csb")
    local white_action = csb.createTimeline("battle/battle_map_heng_sp_bai.csb")
    self.blink_white_action = white_action
    self.blink_white_layer:runAction(white_action)
    self.group._earth_view:getChildByName("Panel_baiping"):addChild(self.blink_white_layer)
    self.blink_white_layer:setVisible(false)

    self.blink_white_action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end
        local str = frame:getEvent()
        if str == "baiping_dh_over" then
            self.isWhideScene = false
            self.blink_white_layer:setVisible(false)
        end
    end)
    

    -- self.group._far_view:ignoreAnchorPointForPosition(true)
    -- self.group._earth_view:ignoreAnchorPointForPosition(true)
    -- self.group._role_view:ignoreAnchorPointForPosition(true)
    -- self.group._near_view:ignoreAnchorPointForPosition(true)

    -- self:setPositionX(-1 * app.baseOffsetX / 2)

    self.group._background_view:setPositionX(self.group._background_view:getPositionX()-1 * app.baseOffsetX / 2)

    self._view_size = cc.size(fwin._width -1 * app.baseOffsetX, fwin._height)
    self._original_position = cc.p(self._view_size.width / 2, 0)

    self._map_size = self.group._earth_view:getContentSize()
    self._center_position = cc.p(self._map_size.width / 2, 0)

    self._move_size = cc.size((self._map_size.width - self._view_size.width), (self._map_size.height - self._view_size.height))
    self._delta_position = cc.p(0, 0)
    self._move_position = cc.p(0, 0)
    self._swap_position = cc.p(0, 0)
    self._scale = 1
    self._scale_to = 0.6 --0.42253521084785

    local tempSize = self.group._earth_view:getContentSize()
    self.group._earth_view._scale_a = self._view_size.width / tempSize.width
    self.group._earth_view._scale_b = tempSize.width / self._view_size.width
    self.group._earth_view._scale_m = 1.0 --1 + 0.5
    self.group._earth_view._scale_c = self.group._earth_view._scale_m - self.group._earth_view._scale_a
    tempSize = cc.size((tempSize.width - self._view_size.width), (tempSize.height - self._view_size.height))
    self.group._earth_view._ratio_x = tempSize.width / self._move_size.width
    self.group._earth_view._ratio_y = tempSize.height / self._move_size.height
    -- self.group._earth_view:setScale(self.group._earth_view._scale_m)


    tempSize = self.group._far_view:getContentSize()
    self.group._far_view._scale_a = self._view_size.width / tempSize.width
    self.group._far_view._scale_b = tempSize.width / self._view_size.width
    self.group._far_view._scale_m = 1.0 --1 + 0.25 -- 0.5 * self.group._far_view._scale_b / self.group._earth_view._scale_b
    self.group._far_view._scale_c = self.group._far_view._scale_m - self.group._far_view._scale_a
    tempSize = cc.size((tempSize.width - self._view_size.width), (tempSize.height - self._view_size.height))
    self.group._far_view._ratio_x = tempSize.width / self._move_size.width
    self.group._far_view._ratio_y = tempSize.height / self._move_size.height
    -- self.group._far_view:setScale(self.group._far_view._scale_m)

    tempSize = self.group._near_view:getContentSize()
    self.group._near_view._scale_a = self._view_size.width / tempSize.width
    self.group._near_view._scale_b = tempSize.width / self._view_size.width
    self.group._near_view._scale_m = 1.0 --1 + 0.75 -- 0.5 * self.group._near_view._scale_b / self.group._earth_view._scale_b
    self.group._near_view._scale_c = self.group._near_view._scale_m - self.group._near_view._scale_a
    tempSize = cc.size((tempSize.width - self._view_size.width), (tempSize.height - self._view_size.height))
    self.group._near_view._ratio_x = tempSize.width / self._move_size.width
    self.group._near_view._ratio_y = tempSize.height / self._move_size.height
    -- self.group._near_view:setScale(self.group._near_view._scale_m)

    -- print(self.group._far_view._scale_a, self.group._far_view._scale_b, self.group._far_view._scale_m, self.group._far_view._ratio_x, self.group._far_view._ratio_y)
    -- print(self.group._earth_view._scale_a, self.group._earth_view._scale_b, self.group._earth_view._scale_m, self.group._earth_view._ratio_x, self.group._earth_view._ratio_y)
    -- print(self.group._near_view._scale_a, self.group._near_view._scale_b, self.group._near_view._scale_m, self.group._near_view._ratio_x, self.group._near_view._ratio_y)

    -- self._scale_to = 1.5
    -- print(1 + (self._scale_to - 1) * self.group._near_view._scale_b / self.group._earth_view._scale_b)
    -- local scale = self.group._earth_view:getScale() - self.group._earth_view._scale_a
    -- self._move_position.x = self._move_position.x * scale
    -- self._move_position.y = self._move_position.y * scale

    -- self:initializeScene()

    --[[app.load("client.battle.landscape.FightTeamController")
    -- fwin:open(FightTeamController:new():init(), fwin._view)
    self.fightTeamController = FightTeamController:new():init()
    self.fightTeamController:retain()

    app.load("client.battle.landscape.FightQTEController")
    -- state_machine.excute("fight_qte_controller_open_window", 0, 0)
    self.fightQTEController = FightQTEController:new():init()
    self.fightQTEController:retain()

    -- init role layer
    app.load("client.battle.landscape.FightRoleController")
    -- self.group._role_view:addChild(FightRoleController:new():init(self._isPvEFight))
    self.fightRoleController = FightRoleController:new():init(self._isPvEFight)
    self.fightRoleController:retain()]]

    fwin:addTouchEventListener(self.group._near_view, nil, 
    {
        terminal_name = "fight_role_controller_hero_info_ui_show", 
        terminal_state = 0, 
        _type = 1,
    },
    nil,-1)
end

function FightScene:loadFightTeamController( ... )
    app.load("client.battle.landscape.FightTeamController")
    -- fwin:open(FightTeamController:new():init(), fwin._view)
    self.fightTeamController = FightTeamController:new():init()
    self.fightTeamController:retain()
end

function FightScene:loadFightQTEController( ... )
    app.load("client.battle.landscape.FightQTEController")
    -- state_machine.excute("fight_qte_controller_open_window", 0, 0)
    self.fightQTEController = FightQTEController:new():init(self._isPvEFight)
    self.fightQTEController:retain()
end

function FightScene:loadFightRoleController( ... )
    app.load("client.battle.landscape.FightRoleController")
    -- self.group._role_view:addChild(FightRoleController:new():init(self._isPvEFight))
    self.fightRoleController = FightRoleController:new():init(self._isPvEFight)
    self.fightRoleController:retain()
end

function FightScene:addTigerGateFight( ... )
    self:initializeScene()

    fwin:open(self.fightTeamController, fwin._view)
    fwin:open(self.fightQTEController, fwin._view)
    -- self.group._role_view:addChild(self.fightRoleController)
    self.fightRoleController._rootWindows = self.group._role_view
    fwin:open(self.fightRoleController)
    table.insert(self.roots, self.fightRoleController.roots[1])
    -- self.fightRoleController:loadSuccess()
    self.fightTeamController:release()
    self.fightQTEController:release()
    self.fightRoleController:release()

    state_machine.excute("fight_qte_controller_on_init_with_role_layer", 0, {self.fightRoleController, self.fightRoleController.csbFightRoleController, "battle/battle_map_heng_role.csb"})
end

function FightScene:cameraFocussing(params)
    -- local root = self.roots[1]
    -- if root:getScale() ~= 1 then
    --     return
    -- end
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece 
        or __lua_project_id == __lua_project_l_naruto 
        then
        return
    end
    if self.isNeedUpdateFocus == true then
        return
    end

    self._swap_position = params[1]
    -- self._swap_position.x = self._swap_position.x - self._center_position.x
    self._swap_position.x = params[5]

    -- local twidth = self._view_size.width + self._swap_position.x  --params[3].x - params[2].x + (self._swap_position.y < _battle_controller._camp_attack_space and 0 or self._swap_position.y * 3)

    local twidth = params[3].x - params[2].x + (self._swap_position.y < _battle_controller._camp_attack_space and 0 or self._swap_position.y * 3)


    local role = params[4]
    local scale = 0
    if role ~= nil then
        scale = dms.atoi(role.armature._sed_action, skill_mould.zoom_ratio)
    end
    -- 计算缩放值
    if scale > 0 then
        self._scale_to = scale / 100
    else
        self._scale_to = self._view_size.width / math.ceil(((twidth - 1)/320) * 320 + 320)
        if self._scale_to > 1 then
            self._scale_to = 1
        elseif _battle_controller._screen_scale_min > self._scale_to then
            self._scale_to = _battle_controller._screen_scale_min
        end
    end
    --self._scale_to = math.max(self.group._earth_view._scale_a, math.min(self._scale_to, self.group._earth_view._scale_m))
end

function FightScene:changeToNextFightScene(currentFightCount)
    state_machine.excute("fight_role_controller_request_next_fight", 0, 0)
    
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        self.group._background_view:removeAllChildren(true)

        local mapIndex = self._map_index[currentFightCount + 1] or self._map_index[#self._map_index]
        local bgLayer = csb.createNode(string.format("battle/battle_map_heng_%s.csb", mapIndex))
        self.group._background_view:addChild(bgLayer)
    end
    return true
end

function FightScene:changeToFightScene(mapIndex)    
    self.group._background_view:removeAllChildren(true)

    local bgLayer = csb.createNode(string.format("battle/battle_map_heng_%s.csb", mapIndex))
    self.group._background_view:addChild(bgLayer)
    return true
end

function FightScene:palyerPowerSkillScreenEffect( params )
    local Panel_super_skill_bg = ccui.Helper:seekWidgetByName(self.group._earth_view, "Panel_super_skill_bg")
    if Panel_super_skill_bg._role == params._role then
        Panel_super_skill_bg._role = nil
        Panel_super_skill_bg:removeAllChildren(true)
    end
    if params._unload == true then
        return
    end

    Panel_super_skill_bg._role = params._role
    local armature = draw.createEffect("effice_super_skill_bg", "images/ui/effice/effice_super_skill_bg/effice_super_skill_bg.ExportJson", Panel_super_skill_bg, 1, 0)
    armature._role = params._role
    armature._invoke = function ( armatureBack )
        -- state_machine.excute("skill_closeup_window_open", 0, {armatureBack._role, armatureBack._role.roleCamp, armatureBack._role._info._head})
        -- draw.deleteEffect(armatureBack)
    end
end

function FightScene:palyByAttackScreenBottomEffect( params )
    local root = self.roots[1]
    local Panel_super_skill_bg_1 = ccui.Helper:seekWidgetByName(root, "Panel_super_skill_bg_1")
    if nil ~= Panel_super_skill_bg_1 then
        Panel_super_skill_bg_1:removeAllChildren()
        Panel_super_skill_bg_1:addChild(params)
    end
end

function FightScene:roaming(dt)
    
end

function FightScene:onUpdate(dt)
    -- local root = self.roots[1]
    -- if root:getScale() ~= 1 then
    --     return
    -- end
    if self.isNeedUpdateFocus == true then
        return
    end
    if self._scale ~= self._scale_to then
        if self._scale > self._scale_to then
            self._scale = self._scale - 0.03
            if self._scale < self._scale_to then
                self._scale = self._scale_to
                -- self._scale_to = 1.5
            end
        else
            self._scale = self._scale + 0.03
            if self._scale > self._scale_to then
                self._scale = self._scale_to
                -- self._scale_to = 0.6
            end
        end
        local sc = self._scale - self.group._earth_view._scale_a
        self.group._earth_view:setScale(self._scale)
        self.group._far_view:setScale(self.group._far_view._scale_a + (sc * (self.group._far_view._scale_c / self.group._earth_view._scale_c)))
        self.group._near_view:setScale(self.group._near_view._scale_a + (sc * (self.group._near_view._scale_c / self.group._earth_view._scale_c)))

        -- if self._scale >= 1 then
            -- self.group._far_view:setScale(1 + (self._scale - 1) * self.group._far_view._scale_b / self.group._earth_view._scale_b)
        -- else
            -- self.group._far_view:setScale(self.group._far_view._scale_a + (self._scale - self.group._far_view._scale_a) * self.group._far_view._scale_b / self.group._earth_view._scale_b)
        -- end
        -- if self._scale >= 1 then
            -- self.group._near_view:setScale(1 + (self._scale - 1) * self.group._near_view._scale_b / self.group._earth_view._scale_b)
        -- else
            -- self.group._near_view:setScale(self.group._near_view._scale_a + (self._scale - self.group._near_view._scale_a) * self.group._near_view._scale_b / self.group._earth_view._scale_b)
        -- end
    end
    if 
        -- self._swap_position.x ~= self._move_position.x
        -- or self._swap_position.y ~= self._move_position.y
        true
        then
        if self._move_position.x > self._swap_position.x then
            local mw = (self._move_position.x - self._swap_position.x) / 20
            if mw < 12 then
                mw = 12
            end
            self._move_position.x = self._move_position.x - mw
            if self._move_position.x < self._swap_position.x then
                self._move_position.x = self._swap_position.x
            end
        else
            local mw = (self._swap_position.x - self._move_position.x) / 20
            if mw < 12 then
                mw = 12
            end
            self._move_position.x = self._move_position.x + mw
            if self._move_position.x > self._swap_position.x then
                self._move_position.x = self._swap_position.x
            end
        end

        if self._move_position.y > self._swap_position.y then
            self._move_position.y = self._move_position.y - 12
            if self._move_position.y < self._swap_position.y then
                self._move_position.y = self._swap_position.y
            end
        else
            self._move_position.y = self._move_position.y + 12
            if self._move_position.y > self._swap_position.y then
                self._move_position.y = self._swap_position.y
            end
        end

        local scale = self.group._earth_view:getScale()
        local half_size = cc.size((self._map_size.width * scale - self._view_size.width) / 2, (self._map_size.height * scale - self._view_size.height))
        local tempx = (self._delta_position.x - self._move_position.x)
        local tempy = (self._delta_position.y - self._move_position.y)
        tempx = math.max(-1 * half_size.width, math.min(half_size.width, tempx))
        tempy = math.max(0, math.min(half_size.height, tempy))

        self.group._earth_view:setPosition(cc.p((self._original_position.x + tempx), 
            (self._original_position.y + tempy)))

        scale = self.group._far_view:getScale()
        local tempSize = self.group._far_view:getContentSize()
        tempSize = cc.size((tempSize.width * scale - self._view_size.width) / 2, (tempSize.height * scale - self._view_size.height) / 2)
        self.group._far_view._ratio_x = half_size.width == 0 and 0 or (tempSize.width / half_size.width)
        self.group._far_view._ratio_y = half_size.height == 0 and 0 or (tempSize.height / half_size.height)
        self.group._far_view:setPosition(cc.p((self._original_position.x + tempx * self.group._far_view._ratio_x), 
            (self._original_position.y + tempy * self.group._far_view._ratio_y)))

        scale = self.group._near_view:getScale()
        tempSize = self.group._near_view:getContentSize()
        tempSize = cc.size((tempSize.width * scale - self._view_size.width) / 2, (tempSize.height * scale - self._view_size.height) / 2)
        self.group._near_view._ratio_x = half_size.width == 0 and 0 or (tempSize.width / half_size.width)
        self.group._near_view._ratio_y = half_size.height == 0 and 0 or (tempSize.height / half_size.height)
        self.group._near_view:setPosition(cc.p((self._original_position.x + tempx * self.group._near_view._ratio_x), 
            (self._original_position.y + tempy * self.group._near_view._ratio_y)))
    end
end

function FightScene:onEnterTransitionFinish()

end

function FightScene:onExit()
    state_machine.remove("fight_scene_change_to_next_fight_scene")
    state_machine.remove("fight_scene_change_to_fight_scene")
    state_machine.remove("fight_scene_camera_focussing")
    state_machine.remove("fight_scene_initialize_scene")
    state_machine.remove("fight_scene_shake")
    state_machine.remove("fight_scene_blink_black")
    state_machine.remove("fight_scene_blink_white")
    state_machine.remove("fight_scene_add_shake_ui")
    state_machine.remove("fight_scene_scene_scale_effect")
    state_machine.remove("fight_scene_play_power_skill_screen_effect")
    state_machine.remove("fight_scene_play_by_attack_screen_bottom_effect")
end
