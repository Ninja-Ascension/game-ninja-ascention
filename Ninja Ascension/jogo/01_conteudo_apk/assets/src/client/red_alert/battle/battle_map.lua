-- ----------------------------------------------------------------------------------------------------
-- 说明：战斗地图
-- ----------------------------------------------------------------------------------------------------
BattleMap = class("BattleMapClass", Window)

local battle_map_window_open_terminal = {
    _name = "battle_map_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("battle_map_window_close", 0, 0)
        local _battleMap = BattleMap:new():init(params)
        fwin:open(_battleMap)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_map_window_close_terminal = {
    _name = "battle_map_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleMapClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_map_window_open_terminal)
state_machine.add(battle_map_window_close_terminal)
state_machine.init()

function BattleMap:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    -- var
    -- 障碍物
    self._obstacles = {}
    self._obstacles2 = {}

    -- 初始坐标
    self._start_pos = nil
    self._move_pos = nil
    self._last_pos = nil

    -- 场景
    self._scene = nil

    -- 地图
    self._map = nil

    -- 地图尺寸
    self._size = nil

    --动画播放中
    self._play_action = false

    -- 寻路
    self._pathfinding = nil
    self._pathfinding_map = nil

    self._pathfinding2 = nil
    self._pathfinding_map2 = nil

    -- 角色层
    self._object_layer = nil
    self._object_effect_layer = nil

    -- X方向移动的范围
    self._move_arena_x = 0

    -- 屏幕移动的速度
    self._velocity = 1.5 * 1.0

    self._effect_list = {}

    self._focusRole = nil

    self._root_ancPos = nil
    self._map_last_pos = nil
    self._root_last_pos = nil

    -- Initialize battle map state machine.
    local function init_battle_map_terminal()
        -- 添加角色对象
        local battle_map_add_object_terminal = {
            _name = "battle_map_add_object",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:addObject(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 添加主公对象
        local battle_map_add_master_terminal = {
            _name = "battle_map_add_master",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:addMaster(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示对象层技能攻击特效
        local battle_map_show_object_layer_skill_effect_terminal = {
            _name = "battle_map_show_object_layer_skill_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:showObjectLayerSkillEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏对象层技能攻击特效
        local battle_map_hide_object_layer_skill_effect_terminal = {
            _name = "battle_map_hide_object_layer_skill_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:hideObjectLayerSkillEffect(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 检测地图碰撞
        local battle_map_check_collision_terminal = {
            _name = "battle_map_check_collision",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:checkCollision(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 添加地图碰撞数据
        local battle_map_add_collision_terminal = {
            _name = "battle_map_add_collision",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:addCollision(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新地图碰撞数据
        local battle_map_update_collision_terminal = {
            _name = "battle_map_update_collision",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:updateCollision(params)
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 地图寻路
        local battle_map_pathfinding_terminal = {
            _name = "battle_map_pathfinding",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return instance:finding(params)
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 地图抖动
        local battle_map_shake_screen_play_terminal = {
            _name = "battle_map_shake_screen_play",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:playAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 地图抖动停止
        local battle_map_shake_screen_play_stop_terminal = {
            _name = "battle_map_shake_screen_play_stop",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:stopPlayAction()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 场景战斗阵营中心锁定
        local battle_map_move_to_camp_center_terminal = {
            _name = "battle_map_move_to_camp_center",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:moveToCampCenter(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 战斗场景坐标复位
        local battle_map_reset_position_terminal = {
            _name = "battle_map_reset_position",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:resetPosition(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 移动到下一个战斗场景
        local battle_map_move_to_next_fight_scene_terminal = {
            _name = "battle_map_move_to_next_fight_scene",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance._effect_list = {}
                instance:moveToNextFightScene(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_map_add_effect_terminal = {
            _name = "battle_map_add_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                table.insert(instance._effect_list, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_map_remove_effect_terminal = {
            _name = "battle_map_remove_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i, v in pairs(instance._effect_list) do
                    if v == params then
                        table.remove(instance._effect_list, i, 1)
                        break
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_map_pause_all_effect_terminal = {
            _name = "battle_map_pause_all_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i, v in pairs(instance._effect_list) do
                    if v.pause ~= nil then
                        v:pause()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local battle_map_resume_all_effect_terminal = {
            _name = "battle_map_resume_all_effect",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                for i, v in pairs(instance._effect_list) do
                    if v.resume ~= nil then
                        v:resume()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 场景缩放特效处理
        local battle_map_scene_scale_effect_terminal = {
            _name = "battle_map_scene_scale_effect",
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

        state_machine.add(battle_map_add_object_terminal)
        state_machine.add(battle_map_add_master_terminal)
        state_machine.add(battle_map_show_object_layer_skill_effect_terminal)
        state_machine.add(battle_map_hide_object_layer_skill_effect_terminal)
        state_machine.add(battle_map_check_collision_terminal)
        -- state_machine.add(battle_map_add_collision_terminal)
        state_machine.add(battle_map_update_collision_terminal)
        state_machine.add(battle_map_pathfinding_terminal)
        state_machine.add(battle_map_shake_screen_play_terminal)
        state_machine.add(battle_map_shake_screen_play_stop_terminal)
        state_machine.add(battle_map_move_to_camp_center_terminal)
        state_machine.add(battle_map_reset_position_terminal)
        state_machine.add(battle_map_move_to_next_fight_scene_terminal)
        state_machine.add(battle_map_add_effect_terminal)
        state_machine.add(battle_map_remove_effect_terminal)
        state_machine.add(battle_map_pause_all_effect_terminal)
        state_machine.add(battle_map_resume_all_effect_terminal)
        state_machine.add(battle_map_scene_scale_effect_terminal)
        state_machine.init()
    end

    -- call func init battle map state machine.
    init_battle_map_terminal()
end

function BattleMap:init(params)
	local rootWindow = params[1]

	self._rootWindows = rootWindow
    local scene = rootWindow
    self._scene = scene

    local mapId = dms.string(dms["npc"], _ED._scene_npc_id, npc.map_index)
    if checkPvpBattleType(self._rootWindows._fight_type) == true then
        mapId = 1
    end
    local mapFile = string.format(config_csb.battle.battle_map.battle_map, mapId)

    local csbBattleMap = csb.createNode(mapFile)
    local root = csbBattleMap:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbBattleMap, _scene_zorder_map)
    if config_res._sync_draw_open~=nil and config_res._sync_draw_open~="" and config_res._sync_draw_open == true then
    	local Panel_earths = ccui.Helper:seekWidgetByName(root, "Panel_earths")
		Panel_earths:removeAllChildren(true)
		local Panel_map_image1 = ccui.Layout:create()
		Panel_map_image1:setContentSize(cc.size(1024, 512))
		Panel_earths:addChild(Panel_map_image1)
		Panel_map_image1:setPosition(cc.p(0,Panel_earths:getPositionY()+262))
		Panel_map_image1:setBackGroundImage(string.format("map/battle/battle_map_%s_01.png", mapId))
		local Panel_map_image2 = ccui.Layout:create()
		Panel_map_image2:setContentSize(cc.size(232, 512))
		Panel_earths:addChild(Panel_map_image2)
		Panel_map_image2:setPosition(cc.p(Panel_map_image1:getPositionX()+Panel_map_image1:getContentSize().width,Panel_map_image1:getPositionY()))
		Panel_map_image2:setBackGroundImage(string.format("map/battle/battle_map_%s_02.png", mapId))
		local Panel_map_image3 = ccui.Layout:create()
		Panel_map_image3:setContentSize(cc.size(1024, 512))
		Panel_earths:addChild(Panel_map_image3)
		Panel_map_image3:setPosition(cc.p(Panel_map_image2:getPositionX()+Panel_map_image2:getContentSize().width,Panel_map_image2:getPositionY()))
		Panel_map_image3:setBackGroundImage(string.format("map/battle/battle_map_%s_03.png", mapId))
		local Panel_map_image4 = ccui.Layout:create()
		Panel_map_image4:setContentSize(cc.size(64, 512))
		Panel_earths:addChild(Panel_map_image4)
		Panel_map_image4:setPosition(cc.p(Panel_map_image3:getPositionX()+Panel_map_image3:getContentSize().width,Panel_map_image3:getPositionY()))
		Panel_map_image4:setBackGroundImage(string.format("map/battle/battle_map_%s_04.png", mapId))
		local Panel_map_image5 = ccui.Layout:create()
		Panel_map_image5:setContentSize(cc.size(1024, 262))
		Panel_earths:addChild(Panel_map_image5)
		Panel_map_image5:setPosition(cc.p(0,0))
		Panel_map_image5:setBackGroundImage(string.format("map/battle/battle_map_%s_05.png", mapId))
		local Panel_map_image6 = ccui.Layout:create()
		Panel_map_image6:setContentSize(cc.size(232, 262))
		Panel_earths:addChild(Panel_map_image6)
		Panel_map_image6:setPosition(cc.p(Panel_map_image5:getPositionX()+Panel_map_image5:getContentSize().width,0))
		Panel_map_image6:setBackGroundImage(string.format("map/battle/battle_map_%s_06.png", mapId))
		local Panel_map_image7 = ccui.Layout:create()
		Panel_map_image7:setContentSize(cc.size(1024, 262))
		Panel_earths:addChild(Panel_map_image7)
		Panel_map_image7:setPosition(cc.p(Panel_map_image6:getPositionX()+Panel_map_image6:getContentSize().width,0))
		Panel_map_image7:setBackGroundImage(string.format("map/battle/battle_map_%s_07.png", mapId))
		local Panel_map_image8 = ccui.Layout:create()
		Panel_map_image8:setContentSize(cc.size(1024, 262))
		Panel_earths:addChild(Panel_map_image8)
		Panel_map_image8:setPosition(cc.p(Panel_map_image7:getPositionX()+Panel_map_image7:getContentSize().width,0))
		Panel_map_image8:setBackGroundImage(string.format("map/battle/battle_map_%s_08.png", mapId))
    end
    -- self._map = csbBattleMap
    self._map = ccui.Helper:seekWidgetByName(root, "Panel_map_layer")
    self._map._self = self

    self._size = root:getContentSize()

    self._move_arena_x = -1 * (self._size.width - (fwin._width - app.baseOffsetX))
    self._move_arena_y = - 1 * (self._size.height - (fwin._height - app.baseOffsetY))
	
	-- 初始化加载抖动动画
	local action = csb.createTimeline(mapFile)
	self._map:runAction(action)
	table.insert(self.actions, action)
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "shake_screen_anim_over" then
            self._play_action = false
        elseif str == "shake_screen_anim_back_over" then
            self._play_action = false
        end
    end)

    if nil ~= rootWindow then
        rootWindow:setContentSize(self._size)
    end

    local Panel_shake_screen = ccui.Helper:seekWidgetByName(root, "Panel_shake_screen")
    fwin:addTouchEventListener(Panel_shake_screen, nil, 
    {
        terminal_name = "battle_scene_show_ui_role_name", 
        terminal_state = 0, 
    }, nil, 0)

    self._object_layer = ccui.Helper:seekWidgetByName(root, "Panel_battle_role")
    self._object_effect_layer = ccui.Helper:seekWidgetByName(root, "Panel_battle_black")

    self._object_layer:reorderChild(self._object_effect_layer, _scene_zorder_object_effect_layer)

    self._front_effect_layer = ccui.Helper:seekWidgetByName(root, "Panel_role_front")

    self._back_effect_layer = ccui.Helper:seekWidgetByName(root, "Panel_role_back")

    local Panel_collision_shelter = ccui.Helper:seekWidgetByName(root, "Panel_collision_shelter")

    -- self._pathfinding = cc.Pathfinding:create(self._size.width / battle_enum._map_cell_size._width, self._size.height / battle_enum._map_cell_size._height, battle_enum._map_cell_size._width, battle_enum._map_cell_size._height)
    -- self._pathfinding:retain()
    -- local map = self._pathfinding:getMap()
    -- self._pathfinding_map = map
    -- self:initPathfindingMap(Panel_collision_shelter, map, self._obstacles, battle_enum._map_cell_size._width, battle_enum._map_cell_size._width)

    -- self._pathfinding2 = cc.Pathfinding:create(self._size.width / battle_enum._map_cell_size2._width, self._size.height / battle_enum._map_cell_size2._height, battle_enum._map_cell_size2._width, battle_enum._map_cell_size2._height)
    -- self._pathfinding2:retain()
    -- local map2 = self._pathfinding2:getMap()
    -- self._pathfinding_map2 = map2
    -- self:initPathfindingMap(Panel_collision_shelter, map2, self._obstacles2, battle_enum._map_cell_size2._width, battle_enum._map_cell_size2._width)
    return self
end

function BattleMap:initPathfindingMap(Panel_collision_shelter, map, _obstacles, cell_width, cell_height)
    local h = map:height()
    local w = map:width()
    for i=1, h do
        for j=1, w do
            local cell = map:get(j - 1, i - 1)

            local pos = cc.p(cell:getX() * cell_width + cell_width / 2, 
                cell:getY() * cell_height + cell_height / 2)
            cell._pos = pos
            cell._r = i
            cell._c = j
        end
    end

    local obstacles = Panel_collision_shelter:getChildren()
    for i, v in pairs(obstacles) do
        local obstacle = {
            name = v:getName(),
            node = v,
            rect = {
                pos = cc.p(v:getPosition()),
                size = v:getContentSize()
            }
        }
        local startX = math.modf(obstacle.rect.pos.x / cell_width)
        local startY = math.modf(obstacle.rect.pos.y / cell_height)

        local colCount = math.modf((obstacle.rect.size.width - 1) / cell_width) + 1
        local rowCount = math.modf((obstacle.rect.size.height - 1) / cell_height) + 1
        for col = 1, colCount do
            for row = 1, rowCount do
                local cell = map:get(startX + col - 1, startY + row - 1)
                if cell ~= nil then
                    -- -- 取消地图的阻挡
                    -- cell:setWeight(4)
                    -- cell:setPassable(false)
                end
            end
        end
        table.insert(_obstacles, obstacle)
    end
end

function BattleMap:onEnterTransitionFinish()
    self._start_pos = cc.p(self:getPosition())
    self._move_pos = cc.p(self._start_pos.x, self._start_pos.y)
    self._last_pos = cc.p(self._start_pos.x, self._start_pos.y)
end

-- 播放抖动动画
function BattleMap:playAction()
	if self.actions ~= nil and self.actions[1] ~= nil then 
        if self._play_action == false then
            self._play_action = true
            local action = self.actions[1]
            action:play("shake_screen_anim", false)
            assert(action:IsAnimationInfoExists("shake_screen_anim") == true, "in animation didn't exist")
        end
	end
end

function BattleMap:sceneScaleEffect(params)
    local camp = params[1]
    local line = params[2]
    local isFly = params[3]
    local isStart = params[4]
    local role = params[5]

    local root = self.roots[1]
    if isStart == false then
        local scale = dms.atof(role._current_skill.skill_element, skill_mould.zoom_ratio)

        -- print("缩小",__fight_recorder_action_time_speed, role._shipName, scale)

        if self._focusRole ~= nil then
            -- self._focusRole = nil
            self._map:stopActionByTag(30)
            self:moveToRoleCenter(self._move_pos, true)
        end
        if scale <= 1 then
            
            return
        end
        -- if self._focusRole ~= nil then
        --     return
        -- end

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
        local size = root:getContentSize()

        local scale = dms.atof(role._current_skill.skill_element, skill_mould.zoom_ratio)

        -- print("放大",__fight_recorder_action_time_speed, role._shipName, scale)

        local movePosition = cc.p(role:getPosition())

        if self._focusRole ~= nil then
            root:stopActionByTag(20)
            self._map:stopActionByTag(30)
            root:setScale(1)
            if self._root_ancPos ~= nil then
                root:setAnchorPoint(cc.p(self._root_ancPos.x, self._root_ancPos.y))
            end
            if self._root_last_pos ~= nil then
                root:setPosition(self._root_last_pos)
            end
            if self._map_last_pos ~= nil then
                self._map:setPosition(self._map_last_pos)
            end
            self._map.back = false
            self._focusRole = nil
            self._root_ancPos = nil
            self._map_last_pos = nil
            self._root_last_pos = nil
            -- return
        end
        self._root_ancPos = root:getAnchorPoint()
        self._map_last_pos = cc.p(self._map:getPosition())
        self._root_last_pos = cc.p(root:getPosition())

        if scale <= 1 then
            local moveVar = {x = movePosition.x, y = movePosition.y, time = 0, v = 5.15, s = 1.6, false}
            self._map:stopActionByTag(30)
            self:moveToRoleCenter(moveVar)
            self._focusRole = role
            return
        end

        root:setAnchorPoint(cc.p(movePosition.x / size.width, movePosition.y / size.height))
        root:setPosition(movePosition)

        root:setScale(root:getScale() + 0.0001)
        root:stopActionByTag(20)
        local scaleTo = cc.ScaleTo:create(0.2 * __fight_recorder_action_time_speed, scale)
        scaleTo:setTag(10)
        root:runAction(scaleTo)
    end
end

-- 抖动动画停止
function BattleMap:stopPlayAction()
	if self.actions ~= nil and self.actions[1] ~= nil then 
		self.actions[1]:play("shake_screen_anim_back_over", false)	
	end
end

function BattleMap:moveToRoleCenter(params, back)
    local winSize = cc.size(fwin._width - app.baseOffsetX, fwin._height - app.baseOffsetY)
    local size = self._map:getContentSize()
    -- params.x = -1 * math.max(0, math.min(size.width - winSize.width, params.x - winSize.width / 2))
    -- params.y = -1 * math.max(0, math.min(size.height - winSize.height, params.y - winSize.height / 2))
    params.x = -(params.x - winSize.width / 2)
    params.y = 0

    if back == true then
        if self._map.pos == nil then
            return
        end
        self._move_pos.x = self._map.pos.x
        self._move_pos.y = self._map.pos.y
        params.x = self._map.pos.x
        params.y = self._map.pos.y
        self._map.pos = nil
    end
    self._map:stopActionByTag(1)
    self._map:stopActionByTag(2)
    local pos = cc.p(self._map:getPosition())

    local mp = cc.p((params.x - pos.x), (params.y - pos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = (s / 15 * 0.013)
    if back == true then
        t = t * 0.3
    end

    local seq = cc.Sequence:create({cc.MoveTo:create(t, params), cc.CallFunc:create(function(sender)
        -- sender._self._last_pos.x = sender._self._move_pos.x 
        -- sender._self._last_pos.y = sender._self._move_pos.y 

        if sender.back == true then
            self._focusRole = nil
        end
    end)})
    seq:setTag(30)
    self._map.back = back
    if back ~= true and self._map.pos == nil then
        self._map.pos = pos
    end
    self._map:runAction(seq)


    -- if params.x == nil or params.y == nil then
    --     params.x = 0 -- self._size.width / 2
    --     params.y = 0 -- self._size.height / 2
    -- end
    -- self._last_pos.x, self._last_pos.y = self._map:getPosition()
    -- local moveX = params.x
    -- local moveY = params.y
    -- local t = params.time
    -- -- local moveToX = self._start_pos.x + (-1) * (moveX - (fwin._width - app.baseOffsetX) / 2)
    -- local moveToX = (-1) * (moveX - (fwin._width - app.baseOffsetX) / 2)
    -- local moveToY = (-1) * (moveY - (fwin._height - app.baseOffsetY) / 2)
    -- moveToX = math.max(self._move_arena_x, math.min(0, moveToX))
    -- moveToY = math.max(self._move_arena_y, math.min(0, moveToY))
    -- if (self._move_pos.x == self._last_pos.x and self._move_pos.y == self._last_pos.y)
    --     or t > 0 
    --     or true
    --     then
    --     local mp = cc.p((moveToX - self._last_pos.x), (moveToY - self._last_pos.y))
    --     local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    --     if s > 20 then
    --         if t == nil or t <= 0 then
    --             t = s / (self._velocity * params.v) * 0.013
    --         end
    --         self._move_pos.x = moveToX
    --         self._move_pos.y = moveToY
    --         if params.stop_actions == true then
    --             self._map:stopActionByTag(1)
    --             self._map:stopActionByTag(2)
    --         end
    --         debug.print_r(self._move_pos)
    --         local speeds1 = cc.Speed:create(cc.MoveTo:create(t, self._move_pos), params.s)
    --         local speeds2 = cc.Sequence:create({cc.DelayTime:create(t),
    --                 cc.CallFunc:create(function(sender)
    --                         sender._self._last_pos.x = sender._self._move_pos.x 
    --                         sender._self._last_pos.y = sender._self._move_pos.y 
    --                     end)
    --             })
    --         speeds1:setTag(1)
    --         speeds2:setTag(2)
    --         self._map:runAction(speeds1)
    --         self._map:runAction(speeds2)
    --     end
    -- end
end

-- 场景战斗阵营中心锁定
function BattleMap:moveToCampCenter(params)
    if self._focusRole ~= nil then
        return
    end
    -- step 1
    -- local moveX = params.x
    -- local t = params.time
    -- -- local moveToX = self._start_pos.x + (-1) * (moveX - (fwin._width - app.baseOffsetX) / 2)
    -- local moveToX = (-1) * (moveX - (fwin._width - app.baseOffsetX) / 2)
    -- moveToX = math.max(self._move_arena_x, math.min(0, moveToX))
    -- if self._move_pos.x == self._last_pos.x or t > 0 then
    --     local s = math.abs(moveToX - self._last_pos.x)
    --     if s > 20 then
    --         if t == nil or t <= 0 then
    --             t = s / (self._velocity * params.v) * 0.013
    --         end
    --         self._move_pos.x = moveToX
    --         if params.stop_actions == true then
    --             self._map:stopActionByTag(1)
    --             self._map:stopActionByTag(2)
    --         end
    --         local speeds1 = cc.Speed:create(cc.MoveTo:create(t, self._move_pos), params.s)
    --         local speeds2 = cc.Sequence:create({cc.DelayTime:create(t),
    --                 cc.CallFunc:create(function(sender)
    --                         sender._self._last_pos.x = sender._self._move_pos.x 
    --                     end)
    --             })
    --         speeds1:setTag(1)
    --         speeds2:setTag(2)
    --         self._map:runAction(speeds1)
    --         self._map:runAction(speeds2)
    --     end
    -- end

    -- step 2
    if params.x == nil or params.y == nil then
        params.x = 0 -- self._size.width / 2
        params.y = 0 -- self._size.height / 2
    end
    local moveX = params.x
    local moveY = params.y
    local t = params.time
    -- local moveToX = self._start_pos.x + (-1) * (moveX - (fwin._width - app.baseOffsetX) / 2)
    local moveToX = (-1) * (moveX - (fwin._width - app.baseOffsetX) / 2)
    local moveToY = (-1) * (moveY - (fwin._height - app.baseOffsetY) / 2)
    moveToX = math.max(self._move_arena_x, math.min(0, moveToX))
    moveToY = math.max(self._move_arena_y, math.min(0, moveToY))
    if (self._move_pos.x == self._last_pos.x and self._move_pos.y == self._last_pos.y)
        or t > 0 
        then
        local mp = cc.p((moveToX - self._last_pos.x), (moveToY - self._last_pos.y))
        local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
        if s > 20 then
            if t == nil or t <= 0 then
                t = s / (self._velocity * params.v) * 0.013
            end
            self._move_pos.x = moveToX
            self._move_pos.y = moveToY
            if params.stop_actions == true then
                self._map:stopActionByTag(1)
                self._map:stopActionByTag(2)
            end
            local speeds1 = cc.Speed:create(cc.MoveTo:create(t, self._move_pos), params.s)
            local speeds2 = cc.Sequence:create({cc.DelayTime:create(t),
                    cc.CallFunc:create(function(sender)
                            sender._self._last_pos.x = sender._self._move_pos.x 
                            sender._self._last_pos.y = sender._self._move_pos.y 
                        end)
                })
            speeds1:setTag(1)
            speeds2:setTag(2)
            self._map:runAction(speeds1)
            self._map:runAction(speeds2)
        end
    end
end

-- 战斗场景坐标复位
function BattleMap:resetPosition(params)
    
end

-- 移动到下一个战斗场景
function BattleMap:moveToNextFightScene(params)
    -- local pos = params
    -- self._start_pos.x = pos.x
    -- self._move_pos.x = self._start_pos.x
    -- self._last_pos.x = self._start_pos.x
    -- -- self:runAction(cc.MoveBy:create(0.5, pos))
    -- self._map:setPositionX(self._move_pos.x)

    -- 改成斜45度度的地图，重新定义坐标
    self._map:setPositionX(self._start_pos.x)
    self._move_pos.x = self._start_pos.x
    self._last_pos.x = self._start_pos.x
end

function BattleMap:onExit()
    state_machine.remove("battle_map_add_object")
    state_machine.remove("battle_map_add_master")
    state_machine.remove("battle_map_show_object_layer_skill_effect")
    state_machine.remove("battle_map_hide_object_layer_skill_effect")
    state_machine.remove("battle_map_check_collision")
    state_machine.remove("battle_map_add_collision")
    state_machine.remove("battle_map_update_collision")
    state_machine.remove("battle_map_pathfinding")
    state_machine.remove("battle_map_shake_screen_play")
    state_machine.remove("battle_map_shake_screen_play_stop")
    state_machine.remove("battle_map_move_to_camp_center")
    state_machine.remove("battle_map_reset_position")
    state_machine.remove("battle_map_move_to_next_fight_scene")
    state_machine.remove("battle_map_add_effect")
    state_machine.remove("battle_map_remove_effect")
    state_machine.remove("battle_map_pause_all_effect")
    state_machine.remove("battle_map_resume_all_effect")
    state_machine.remove("battle_map_scene_scale_effect")
    if nil ~= self._pathfinding then
        self._pathfinding:release()
        self._pathfinding = nil
    end
    if nil ~= self._pathfinding2 then
        self._pathfinding2:release()
        self._pathfinding2 = nil
    end
end

function BattleMap:addObject(params)
    self._object_layer:addChild(params)
    self._object_layer._back_effect_layer = self._back_effect_layer
    self._object_layer._front_effect_layer = self._front_effect_layer
    return self._object_layer
end

function BattleMap:addMaster(params)
    local camp = params[1]
    local master = params[2]

    local root = self.roots[1]
    local Panel_master = ccui.Helper:seekWidgetByName(root, "Panel_master_" .. camp)
    master:setPosition(cc.p(Panel_master:getPosition()))
    self:addChild(master)
    Panel_master._back_effect_layer = self._back_effect_layer
    Panel_master._front_effect_layer = self._front_effect_layer
    return Panel_master
end

function BattleMap:showObjectLayerSkillEffect(params)
    self._object_effect_layer:setVisible(true)
end

function BattleMap:hideObjectLayerSkillEffect(params)
    self._object_effect_layer:setVisible(false)
end

function BattleMap:checkCollision(params)
    -- local rect = params
    -- for i, v in pairs(self._obstacles) do
    --     if rect.pos.x + rect.size.width > v.rect.pos.x
    --         and rect.pos.x < v.rect.pos.x + v.rect.size.width
    --         and rect.pos.y + rect.size.height > v.rect.pos.y
    --         and rect.pos.y < v.rect.pos.y + v.rect.size.height
    --         then
    --         return true, v
    --     end
    -- end
    -- return state_machine.excute("battle_scene_check_collision", 0, params)

    local obstacle = params
    local object = obstacle.object

    local map = nil
    local map_cell_size = nil
    if object._hero_type == object._enum_hero_type._hero then
        map = self._pathfinding_map2
        map_cell_size = battle_enum._map_cell_size2
    else
        map = self._pathfinding_map
        map_cell_size = battle_enum._map_cell_size
    end

    local currCellX = math.modf(obstacle.pos.x / map_cell_size._width)
    local currCellY = math.modf(obstacle.pos.y / map_cell_size._height)

    local currCell = map:get(currCellX, currCellY)
    if currCell ~= nil 
        then
        if currCell._object == nil 
            or currCell._object == currCell
            then
            return false, currCell
        else
            if currCell:getPassable() == false then
                return true, currCell
            else
                return false, currCell
            end
        end
    end
    return false, currCell
end

function BattleMap:addCollision(params)
    local object = params.object

    local map = nil
    local map_cell_size = nil
    if object._hero_type == object._enum_hero_type._hero then
        map = self._pathfinding_map2
        map_cell_size = battle_enum._map_cell_size2
    else
        map = self._pathfinding_map
        map_cell_size = battle_enum._map_cell_size
    end

    local currCellX = math.modf(params.x / map_cell_size._width)
    local currCellY = math.modf(params.y / map_cell_size._height)

    local currCell = map:get(currCellX, currCellY)
    if currCell ~= nil then
        currCell:setPassable(false)
        -- currCell:setWeight(3.9)
    end
    return currCell
end

function BattleMap:updateCollision(params)
    local object = params.object

    local map = nil
    local map_cell_size = nil
    if object._hero_type == object._enum_hero_type._hero then
        map = self._pathfinding_map2
        map_cell_size = battle_enum._map_cell_size2
    else
        map = self._pathfinding_map
        map_cell_size = battle_enum._map_cell_size
    end

    local lastCellX = math.modf(params.lx / map_cell_size._width)
    local lastCellY = math.modf(params.ly / map_cell_size._height)
    local currCellX = math.modf(params.mx / map_cell_size._width)
    local currCellY = math.modf(params.my / map_cell_size._height)

    local lastCell = map:get(lastCellX, lastCellY)
    local currCell = map:get(currCellX, currCellY)

    -- debug.print_r(params)
    -- print(params[1], params[2], params[3], params[3], lastCellX, lastCellY, lastCell, currCellX, currCellY, currCell)

    -- -- if lastCellX ~= currCellX or lastCellY ~= currCellY then
    --     -- local map = self._pathfinding_map

    --     -- local lastCell = map:get(lastCellX, lastCellY)
    --     if lastCell ~= nil and lastCell:getWeight() <= 1 then
    --         lastCell:setPassable(true)
    --         -- lastCell:setWeight(0)
    --     end

    --     -- local currCell = map:get(currCellX, currCellY)
    --     if currCell ~= nil and currCell:getWeight() <= 1 then
    --         currCell:setPassable(false)
    --         -- currCell:setWeight(3.9)
    --         -- -->print("锁定节点：")
    --     end
    -- -- end
    return lastCell, currCell
end

function BattleMap:finding(params)
    local object = params.object
    local startX = params.mx
    local startY = params.my
    local goldX = params.dx
    local goldY = params.dy

    local pathfinding = nil

    local map = nil
    local map_cell_size = nil
    if object._hero_type == object._enum_hero_type._hero then
        map = self._pathfinding_map2
        pathfinding = self._pathfinding2
        map_cell_size = battle_enum._map_cell_size2
    else
        map = self._pathfinding_map
        pathfinding = self._pathfinding
        map_cell_size = battle_enum._map_cell_size
    end

    local lastCellX = math.modf(startX / map_cell_size._width)
    local lastCellY = math.modf(startY / map_cell_size._height)
    local currCellX = math.modf(goldX / map_cell_size._width)
    local currCellY = math.modf(goldY / map_cell_size._height)

    local lastCell = map:get(lastCellX, lastCellY)
    local currCell = map:get(currCellX, currCellY)

    if currCell == nil then
        return nil
    end

    local lastCellPassable = true
    local currCellPassable = true

    if lastCell ~= nil and lastCell:getWeight() <= 1 then
        lastCellPassable = lastCell:getPassable()
        lastCell:setPassable(true)
    end

    if currCell ~= nil and currCell:getWeight() <= 1 then
        currCellPassable = currCell:getPassable()
        currCell:setPassable(true)
    end

    pathfinding:finding(2, startX, startY, goldX, goldY)

    if lastCell ~= nil and lastCell:getWeight() <= 1 then
        lastCell:setPassable(lastCellPassable)
    end

    if currCell ~= nil and currCell:getWeight() <= 1 then
        currCell:setPassable(currCellPassable)
    end

    local cells = pathfinding:getCommandCells()
    -- -- local path = {}
    -- for i, v in pairs(cells) do
    --     print(v._pos.x, v._lineLayer)
        -- v:setPassable(false)
        -- v._lineLayer:setVisible(true)

    -- --     local pos = cc.p(v:getX() * battle_enum._map_cell_size._width + battle_enum._map_cell_size._width / 2, 
    -- --         v:getY() * battle_enum._map_cell_size._height + battle_enum._map_cell_size._height / 2)
    -- --     local cell = {
    -- --         _pos = pos,
    -- --         _node = v,
    -- --         _lineLayer = nil
    -- --     }
    -- --     table.insert(path, cell)

    -- --     local layer = cc.LayerGradient:create(cc.c4b(120,0,0,255), cc.c4b(0,255,0,255), cc.p(0.9, 0.9))
    -- --     -- layer:setAnchorPoint(cc.p(0.5, 0.5))
    -- --     layer:setContentSize(cc.size(battle_enum._map_cell_size._width, battle_enum._map_cell_size._height))
    -- --     self._rootWindows:addChild(layer)
    -- --     layer:setPosition(cc.p(pos.x - battle_enum._map_cell_size._width / 2, pos.y - battle_enum._map_cell_size._height / 2))
    -- --     cell._lineLayer = layer
    -- --     -- cell._lineLayer:setVisible(false)
    -- end
    -- -- return path
    return cells
end

function BattleMap:close()

end

function BattleMap:destroy()
    
end
-- ----------------------------------------------------------------------------------------------------