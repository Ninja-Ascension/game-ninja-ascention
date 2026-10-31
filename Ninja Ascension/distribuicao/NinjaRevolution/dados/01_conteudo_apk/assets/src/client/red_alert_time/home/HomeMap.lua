HomeMap = class("HomeMapClass", Window)

--打开界面
local home_map_window_open_terminal = {
	_name = "home_map_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        _ED.current_window_in_main_city = true
        local _homeMapWindow = fwin:find("HomeMapClass")
        if nil == _homeMapWindow then
    		fwin:open(HomeMap:new():init(params))
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local home_map_window_close_terminal = {
	_name = "home_map_window_close",
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

--任务追踪跳转
local home_map_build_tracking_terminal = {
    _name = "home_map_build_tracking",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _homeMapWindow = fwin:find("HomeMapClass")
        if nil ~= _homeMapWindow then
            _homeMapWindow.__tracking_state_machine = params[1]
            _homeMapWindow.__tracking_params = params[2]
            _homeMapWindow.__tracking_state_machine2 = params[3]

            local city_id = _homeMapWindow.__tracking_params[1]
            state_machine.excute("home_map_reset_scale", 0, nil)
            _homeMapWindow:scrollToPanelCity(city_id, true)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(home_map_window_open_terminal)
state_machine.add(home_map_window_close_terminal)
state_machine.add(home_map_build_tracking_terminal)
state_machine.init()

function HomeMap:ctor()
	self.super:ctor()
	self.roots = {}

    self._home_cells = {}
    self._tanke_cells = {}

    self.touches = {}

    self._play_effect = true

    self._touch_time = 0

    app.load("client.red_alert_time.cells.home.home_build_cell")
    app.load("client.red_alert_time.cells.home.home_tanke_cell")
    app.load("client.red_alert_time.cells.home.home_map_patrol_cell")

    local function init_home_map_terminal()
        local home_map_update_build_terminal = {
            _name = "home_map_update_build",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("main_window_update_quick_info", 0, nil)
                instance:updateDrawBuild()
                instance:updateTankeInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 位移至指定建筑显示区域
        local home_map_scroll_to_panel_city_terminal = {
            _name = "home_map_scroll_to_panel_city",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local city_id = params[1]
                -- if missionIsOver() == false then
                    state_machine.excute("home_map_reset_scale", 0, nil)
                -- end
                instance:scrollToPanelCity(city_id, params[2], params[3])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 位移至指定建筑显示区域
        local home_map_scroll_to_position_terminal = {
            _name = "home_map_scroll_to_position",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- if missionIsOver() == false then
                    state_machine.excute("home_map_reset_scale", 0, nil)
                -- end
                instance:scrollToPosition(params[1], params[2], params[3])
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新建筑生产状态
        local home_map_update_prodcution_state_terminal = {
            _name = "home_map_update_prodcution_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                for k, city_id in pairs(params) do
                    if city_id == 7 
                        or city_id == 4 
                        or city_id == 54 
                        then
                        state_machine.excute("home_build_cell_update_leader_info", 0, {self._home_cells[""..city_id]})
                    elseif city_id == 5 then
                        state_machine.excute("home_build_cell_update_campaign_info", 0, {self._home_cells[""..city_id]})
                    elseif city_id == 55 then
                        state_machine.excute("home_build_cell_update_rank_info", {self._home_cells[""..city_id]})
                    else
                        state_machine.excute("home_build_cell_update_production", 0, {self._home_cells[""..city_id]})
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 更新坦克信息
        local home_map_update_tanke_info_terminal = {
            _name = "home_map_update_tanke_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateTankeInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_map_change_home_build_level_state_terminal = {
            _name = "home_map_change_home_build_level_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeHomeBuildLevelState(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_map_change_home_build_top_info_terminal = {
            _name = "home_map_change_home_build_top_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateHomeBuildTopInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_map_change_home_build_legion_info_terminal = {
            _name = "home_map_change_home_build_legion_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateHomeBuildLegionInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_map_all_build_visible_terminal = {
            _name = "home_map_all_build_visible",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:visibleBuild(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 直升机音效
        local home_map_play_openness_effect_terminal = {
            _name = "home_map_play_openness_effect",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local state = params[1]
                self._play_effect = state
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_map_reset_scale_terminal = {
            _name = "home_map_reset_scale",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_home_x = ccui.Helper:seekWidgetByName(root, "Panel_home_x")
                local Panel_map_zoom = ccui.Helper:seekWidgetByName(root, "Panel_map_zoom")
                Panel_home_x:stopAllActions()
                instance.controllerLayer:stopAllActions()
                
                local winSize = instance:getContentSize()
                local mapViewSize = Panel_map_zoom:getContentSize()
                local scale = instance.controllerLayer:getScale()
                local anchorPoint = instance.controllerLayer:getAnchorPoint()

                local pos = cc.p(Panel_home_x:getPosition())

                pos.x = pos.x - winSize.width * anchorPoint.x * scale
                pos.y = pos.x - winSize.height * anchorPoint.y * scale

                instance.controllerLayer:setAnchorPoint(cc.p(0, 0))
                instance.controllerLayer:setScale(config_res.viewMinScale)

                local controllerLayerCurrSize = cc.size(instance.controllerLayer:getBoundingBox().width, instance.controllerLayer:getBoundingBox().height)
                -- 边界控制，约束pos的位置
                pos.x = math.min(pos.x, controllerLayerCurrSize.width * instance.controllerLayer:getAnchorPoint().x)
                pos.x = math.max(pos.x, -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * instance.controllerLayer:getAnchorPoint().x)

                pos.y = math.min(pos.y, controllerLayerCurrSize.height * instance.controllerLayer:getAnchorPoint().y)
                pos.y = math.max(pos.y, -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * instance.controllerLayer:getAnchorPoint().y)

                Panel_home_x:setPosition(cc.p(pos.x, pos.y))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 免费升级
        local home_map_free_build_up_terminal = {
            _name = "home_map_free_build_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local build_id = params[1]
                local level = zstring.tonumber(_ED.home_build[""..build_id].level) + 1
                local buildName = _ED.base_build_info[""..build_id].build_name
                local function responseCallback( response )
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                TipDlg.drawTextDailog(string.format(red_alert_all_str[280], buildName, level))
                            end
                            checkPlayEffect(36)
                            state_machine.excute("build_up_build_quickly_window_close",0,"")
                        end
                    end
                end
                protocol_command.build_speed_up.param_list = _ED.home_build[""..build_id].base_mould_id
                NetworkManager:register(protocol_command.build_speed_up.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local home_map_update_patrol_reward_state_terminal = {
            _name = "home_map_update_patrol_reward_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateHomePatrolRewardState()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

	    state_machine.add(home_map_update_build_terminal)
        state_machine.add(home_map_scroll_to_panel_city_terminal)
        state_machine.add(home_map_scroll_to_position_terminal)
        state_machine.add(home_map_update_prodcution_state_terminal)
        state_machine.add(home_map_update_tanke_info_terminal)
        state_machine.add(home_map_change_home_build_level_state_terminal)
        state_machine.add(home_map_change_home_build_top_info_terminal)
        state_machine.add(home_map_change_home_build_legion_info_terminal)
        state_machine.add(home_map_all_build_visible_terminal)
        state_machine.add(home_map_play_openness_effect_terminal)
        state_machine.add(home_map_reset_scale_terminal)
        state_machine.add(home_map_free_build_up_terminal)
        state_machine.add(home_map_update_patrol_reward_state_terminal)
        state_machine.init()
    end
    init_home_map_terminal()
end

function HomeMap:updateHomePatrolRewardState( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    local total = zstring.tonumber(_ED.home_patrol_reeard_info.normal_reward_times) +
        zstring.tonumber(_ED.home_patrol_reeard_info.high_reward_times)
    local current_reward_count = 0
    for i = 1, 2 do
        local Panel_home_map_effect = ccui.Helper:seekWidgetByName(root, "Panel_home_map_effect_"..i)
        if Panel_home_map_effect ~= nil and Panel_home_map_effect.__armature ~= nil then
            if Panel_home_map_effect.__armature._isCanGetReward == true then
                current_reward_count = current_reward_count + 1
            end
        end
    end
    if total > current_reward_count then
        local index = 1
        while total > current_reward_count do
            local Panel_home_map_effect = ccui.Helper:seekWidgetByName(root, "Panel_home_map_effect_"..index)
            if Panel_home_map_effect ~= nil and Panel_home_map_effect.__armature ~= nil then
                local patrol_cell = Panel_home_map_effect.__armature
                if patrol_cell._isCanGetReward == false then
                    current_reward_count = current_reward_count + 1
                    patrol_cell._isCanGetReward = true
                    state_machine.excute("home_map_patrol_cell_play_animation", 0, {patrol_cell, patrol_cell._animation_index})
                end
            end
            index = index + 1
            if index > 2 then
                return
            end
        end
    elseif total < current_reward_count then
        local index = 1
        while total < current_reward_count do
            local Panel_home_map_effect = ccui.Helper:seekWidgetByName(root, "Panel_home_map_effect_"..index)
            if Panel_home_map_effect ~= nil and Panel_home_map_effect.__armature ~= nil then
                local patrol_cell = Panel_home_map_effect.__armature
                if patrol_cell._isCanGetReward == true then
                    current_reward_count = current_reward_count - 1
                    patrol_cell._isCanGetReward = false
                    state_machine.excute("home_map_patrol_cell_play_animation", 0, {patrol_cell, patrol_cell._animation_index})
                end
            end
            index = index + 1
            if index > 2 then
                return
            end
        end
    end
end

-- 主城动态动画
function HomeMap:playHomeEffect()
    local root = self.roots[1]

    for i = 1, #config_res.effect.effect_home do
        local base_name = config_res.effect.effect_home[i]
        local Panel_map_effect = ccui.Helper:seekWidgetByName(root, "Panel_map_effect_"..i)
        if Panel_map_effect ~= nil then
            Panel_map_effect:removeAllChildren(true)

            skeletonNode = sp.spine(base_name..".json", base_name..".atlas", 1, 0, nil, false, nil)
            skeletonNode:setAnimation(0, "animation", true)
            skeletonNode:setPosition(cc.p(Panel_map_effect:getContentSize().width/2, Panel_map_effect:getContentSize().height/2))
            Panel_map_effect:addChild(skeletonNode)
        end
    end
end

local function getMoveTime(path, speed)
    for i = 1, #path do
        local next_pos = cc.p(path[i].x, path[i].y)
        local current_pos = nil
        if i == 1 then
            current_pos = cc.p(path[#path].x, path[#path].y)
        else
            current_pos = cc.p(path[i-1].x, path[i-1].y)
        end
        local dis = cc.pGetDistance(current_pos,next_pos)
        path[i].move_time = dis / speed
    end
end

-- 直升机动画
function HomeMap:playHelicopterEffect()
    local root = self.roots[1]

    local function moveCallback(sender)
        sender:setVisible(true)
        if self._play_effect == true then
            if _ED.current_window_in_main_city == true then
                checkPlayEffect(70)
            end
        end
        local path = sender.__path
        sender.__pos = sender.__pos + 1
        if sender.__pos > #path then
            sender.__pos = 1
        end
        local pos = sender.__pos
        sender.__armature:getAnimation():play("Animation"..path[pos].direction)
        sender:runAction(cc.Sequence:create(
            cc.MoveTo:create(path[pos].move_time, cc.p(path[pos].x, path[pos].y)),
            cc.CallFunc:create(function (sender)
                sender:setVisible(false)
                sender:runAction(cc.Sequence:create(
                    cc.DelayTime:create(helicopter_interval_time_info),
                    cc.CallFunc:create(moveCallback)
                    ))
                end)
            ))
    end

    local Panel_home_map_effect = ccui.Helper:seekWidgetByName(root, "Panel_home_map_effect_3")
    if Panel_home_map_effect ~= nil then
        Panel_home_map_effect:removeAllChildren(true)
        Panel_home_map_effect.__armature = nil

        local speed = home_map_sprite_move_speed_info[3]
        local interval_time = helicopter_interval_time_info

        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.sprite.spirte_helicopter)
        local armature = ccs.Armature:create("spirte_helicopter")
        Panel_home_map_effect:addChild(armature)
        Panel_home_map_effect:setAnchorPoint(cc.p(0.5, 0.5))
        armature:setPosition(Panel_home_map_effect:getContentSize().width / 2, Panel_home_map_effect:getContentSize().height / 2)
        Panel_home_map_effect.__armature = armature
        
        local path = home_map_sprite_move_path_info[3]
        getMoveTime(path, speed)

        Panel_home_map_effect.__pos = #path
        Panel_home_map_effect.__path = path
        Panel_home_map_effect:setPosition(cc.p(path[Panel_home_map_effect.__pos].x, path[Panel_home_map_effect.__pos].y))
        armature:getAnimation():play("Animation"..path[Panel_home_map_effect.__pos].direction)

        Panel_home_map_effect:runAction(cc.Sequence:create(
                        cc.DelayTime:create(helicopter_interval_time_info),
                        cc.CallFunc:create(moveCallback)
                        ))
    end

    -- 飞艇动画
    local Panel_home_map_effect_4 = ccui.Helper:seekWidgetByName(root, "Panel_home_map_effect_4")
    if Panel_home_map_effect_4 ~= nil then
        Panel_home_map_effect_4:removeAllChildren(true)
        ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.sprite.spirte_airship)
        local armature_airship = ccs.Armature:create("spirte_airship")
        Panel_home_map_effect_4:addChild(armature_airship)
        Panel_home_map_effect_4:setAnchorPoint(cc.p(0.5, 0.5))
        armature_airship:setPosition(Panel_home_map_effect:getContentSize().width / 2, Panel_home_map_effect:getContentSize().height / 2)
        armature_airship:getAnimation():play("Animation1")
    end
end

-- 士兵行走动画
function HomeMap:playSoldierMoveEffect()
    local root = self.roots[1]

    local function moveCallback(sender)
        local path = sender.__path
        sender.__pos = sender.__pos + 1
        if sender.__pos > #path then
            sender.__pos = 1
        end
        local pos = sender.__pos
        state_machine.excute("home_map_patrol_cell_play_animation", 0, {sender.__armature, path[pos].direction})
        sender:runAction(cc.Sequence:create(
            cc.MoveTo:create(path[pos].move_time, cc.p(path[pos].x, path[pos].y)),
            cc.CallFunc:create(moveCallback)
            ))
    end

    for i = 1, 2 do
        local Panel_home_map_effect = ccui.Helper:seekWidgetByName(root, "Panel_home_map_effect_"..i)
        if Panel_home_map_effect ~= nil then
            Panel_home_map_effect:removeAllChildren(true)
            Panel_home_map_effect.__armature = nil

            local armature = state_machine.excute("home_map_patrol_cell_create", 0, {i, 0})
            Panel_home_map_effect:setContentSize(cc.size(80, 50))
            Panel_home_map_effect:addChild(armature)
            Panel_home_map_effect:setAnchorPoint(cc.p(0.5, 0.5))
            armature:setPosition(cc.p(Panel_home_map_effect:getContentSize().width / 2, Panel_home_map_effect:getContentSize().height / 2))
            Panel_home_map_effect.__armature = armature
            
            local speed = home_map_sprite_move_speed_info[1]
            local path = home_map_sprite_move_path_info[i]
            getMoveTime(path, speed)

            Panel_home_map_effect.__pos = #path
            Panel_home_map_effect.__path = path
            Panel_home_map_effect:setPosition(cc.p(path[Panel_home_map_effect.__pos].x, path[Panel_home_map_effect.__pos].y))
            state_machine.excute("home_map_patrol_cell_play_animation", 0, {armature, path[Panel_home_map_effect.__pos].direction})

            moveCallback(Panel_home_map_effect)
        end
    end

    for i = 1, 11 do
        local Panel_home_map_effect_paci = ccui.Helper:seekWidgetByName(root, "Panel_home_map_effect_paci_"..i)
        if Panel_home_map_effect_paci ~= nil then
            Panel_home_map_effect_paci:removeAllChildren(true)
            Panel_home_map_effect_paci.__armature = nil

            local armature = state_machine.excute("home_map_patrol_cell_create", 0, {i, -1})
            Panel_home_map_effect_paci:setContentSize(cc.size(80, 50))
            Panel_home_map_effect_paci:addChild(armature)
            Panel_home_map_effect_paci:setAnchorPoint(cc.p(0.5, 0.5))
            armature:setPosition(cc.p(Panel_home_map_effect_paci:getContentSize().width / 2, Panel_home_map_effect_paci:getContentSize().height / 2))
            Panel_home_map_effect_paci.__armature = armature
            
            local speed = home_map_sprite_move_speed_info[1]
            local path = home_map_sprite_move_path_paci_info[i]
            getMoveTime(path, speed)

            Panel_home_map_effect_paci.__pos = #path
            Panel_home_map_effect_paci.__path = path
            Panel_home_map_effect_paci:setPosition(cc.p(path[Panel_home_map_effect_paci.__pos].x, path[Panel_home_map_effect_paci.__pos].y))
            state_machine.excute("home_map_patrol_cell_play_animation", 0, {armature, path[Panel_home_map_effect_paci.__pos].direction})

            moveCallback(Panel_home_map_effect_paci)
        end
    end
end

-- 战斗机和火车动画
function HomeMap:playActionsTrainAndWarcraft()
    local root = self.roots[1]
    local Panel_fly = ccui.Helper:seekWidgetByName(root, "Panel_fly")
    if Panel_fly ~= nil then
        Panel_fly:setVisible(true)
        Panel_fly:removeAllChildren(true)
        local baseName_1 = config_res.effect.effect_warcraft
        local skeletonNode_1 = sp.spine(baseName_1..".json", baseName_1..".atlas", 1, 0, nil, false, nil)
        skeletonNode_1:setAnimation(0, "animation", true)
        skeletonNode_1:setPosition(cc.p(Panel_fly:getContentSize().width/2, Panel_fly:getContentSize().height/2))
        Panel_fly:addChild(skeletonNode_1)
    end

    local Panel_train = ccui.Helper:seekWidgetByName(root, "Panel_train")
    if Panel_train ~= nil then
        Panel_train:setVisible(true)
        Panel_train:removeAllChildren(true)
        local baseName_2 = config_res.effect.effect_train
        local skeletonNode_2 = sp.spine(baseName_2..".json", baseName_2..".atlas", 1, 0, nil, false, nil)
        skeletonNode_2:setAnimation(0, "animation", true)
        skeletonNode_2:setPosition(cc.p(Panel_train:getContentSize().width/2, Panel_train:getContentSize().height/2))
        Panel_train:addChild(skeletonNode_2)
    end
end

function HomeMap:updateHomeBuildLegionInfo(  )
    for k,v in pairs(self._home_cells) do
        if tonumber(k) == 2 then
            v:updateDraw(_ED.home_build["2"])
        end
    end
end

function HomeMap:updateHomeBuildTopInfo(  )
    for k,v in pairs(self._home_cells) do
        if tonumber(k) == 4 then
            v:updateArenaBuildInfo()
        end
    end
end

function HomeMap:changeHomeBuildLevelState( params )
    for k,v in pairs(self._home_cells) do
        v:changeLevelState(params)
    end
end

function HomeMap:visibleBuild(visible)
    local root = self.roots[1]
    local Panel_home_x = ccui.Helper:seekWidgetByName(root, "Panel_home_x")
    local Panel_map_zoom = ccui.Helper:seekWidgetByName(root, "Panel_map_zoom")

    local city_id = 1
    while true do
        if city_id ~= 9 then
            local panel = Panel_map_zoom:getChildByName("Node_function_build_"..city_id)
            if nil ~= panel then
                panel:setVisible(visible)
            else
                break
            end
        end
        city_id = city_id + 1
    end
end

function HomeMap:scrollToPanelCity(city_id, action, info)
    -- if nil ~= self.__tracking_params then
    --     if true == self.__tracking then
    --         self.__tracking = true
    --         return
    --     end
    -- end
    if self.controllerLayer:getScale() ~= config_res.viewMinScale then
        state_machine.excute("home_map_reset_scale", 0, nil)
    end
    local root = self.roots[1]
    local Panel_home_x = ccui.Helper:seekWidgetByName(root, "Panel_home_x")
    local Panel_map_zoom = ccui.Helper:seekWidgetByName(root, "Panel_map_zoom")
    local panel = Panel_map_zoom:getChildByName("Node_function_build_"..city_id)
    local winSize = self:getContentSize()
    local mapViewSize = Panel_map_zoom:getContentSize()
    local scale = self.controllerLayer:getScale()

    local mpos = cc.p(Panel_home_x:getPosition())
    local pos = cc.p(panel:getPosition())
    local nsize = panel._size
    nsize = nsize or cc.size(120, 120)
    pos.x = (winSize.width - nsize.width * scale) / 2 - pos.x * scale
    pos.y = (winSize.height - nsize.height * scale) / 2 - pos.y * scale

    local controllerLayerCurrSize = cc.size(self.controllerLayer:getBoundingBox().width, self.controllerLayer:getBoundingBox().height)
    -- 边界控制，约束pos的位置
    pos.x = math.min(pos.x, controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)
    pos.x = math.max(pos.x, -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)

    pos.y = math.min(pos.y, controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)
    pos.y = math.max(pos.y, -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)

    local velocity = 15
    local mp = cc.p((pos.x - mpos.x), (pos.y - mpos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / velocity * 0.013
    if true == action then
        if nil ~= self.__tracking_params then
            t = t / 3
            -- _ED.current_window_in_main_city = false
            Panel_home_x:stopAllActions()
            if t < 0.03 then
                t = 0.03
            end
        end
        if missionIsOver() == false then
            fwin._close_touch_end_event = true
        end
        Panel_home_x:runAction(cc.Sequence:create(cc.EaseSineOut:create((cc.MoveTo:create(t, cc.p(pos.x, pos.y)))), cc.CallFunc:create(function ( sender )
            fwin._close_touch_end_event = false
            self.__tracking = false
            -- _ED.current_window_in_main_city = true
            if nil ~= self.__tracking_params then
                if missionIsOver() == true then
                    state_machine.excute(self.__tracking_state_machine, 0, self.__tracking_params)
                    if nil ~= self.__tracking_state_machine2 then
                        state_machine.excute(self.__tracking_state_machine2, 0, 0)
                    end
                end
                self.__tracking_params = nil
            end
            if info ~= nil then
                _ED.build_help_touch = true
                state_machine.excute("tuition_controller_exit", 0, nil)
                state_machine.excute("tuition_controller_touch_normal", 0, {panel, true, info})
            end
        end)))
    else
        Panel_home_x:setPosition(cc.p(pos.x, pos.y))
    end
end

function HomeMap:scrollToPosition(pos, action, time)
    -- if nil ~= self.__tracking_params then
    --     if true == self.__tracking then
    --         self.__tracking = true
    --         return
    --     end
    -- end
    if self.controllerLayer:getScale() ~= config_res.viewMinScale then
        state_machine.excute("home_map_reset_scale", 0, nil)
    end
    local root = self.roots[1]
    local Panel_home_x = ccui.Helper:seekWidgetByName(root, "Panel_home_x")
    -- local Panel_map_zoom = ccui.Helper:seekWidgetByName(root, "Panel_map_zoom")
    -- local panel = Panel_map_zoom:getChildByName("Node_function_build_"..city_id)
    local winSize = self:getContentSize()
    -- local mapViewSize = Panel_map_zoom:getContentSize()
    local scale = self.controllerLayer:getScale()

    local mpos = cc.p(Panel_home_x:getPosition())
    -- local pos = cc.p(panel:getPosition())
    -- local nsize = panel._size
    -- nsize = nsize or cc.size(120, 120)
    -- pos.x = (winSize.width - nsize.width * scale) / 2 - pos.x * scale
    -- pos.y = (winSize.height - nsize.height * scale) / 2 - pos.y * scale

    local controllerLayerCurrSize = cc.size(self.controllerLayer:getBoundingBox().width, self.controllerLayer:getBoundingBox().height)
    -- 边界控制，约束pos的位置
    -- pos.x = math.min(pos.x, controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)
    -- pos.x = math.max(pos.x, -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)

    -- pos.y = math.min(pos.y, controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)
    -- pos.y = math.max(pos.y, -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)

    local velocity = 15
    local mp = cc.p((pos.x - mpos.x), (pos.y - mpos.y))
    local s = math.sqrt(mp.x * mp.x + mp.y * mp.y)
    local t = s / velocity * 0.013
    if true == action then
        if nil ~= self.__tracking_params then
            t = t / 3
            -- _ED.current_window_in_main_city = false
            Panel_home_x:stopAllActions()
            if t < 0.03 then
                t = 0.03
            end
        end
        t = time
        Panel_home_x:runAction(cc.Sequence:create(
            -- cc.EaseSineOut:create((
                cc.MoveTo:create(t, cc.p(pos.x, pos.y))
                -- ))
            , 
            cc.CallFunc:create(function ( sender )
            self.__tracking = false
            -- _ED.current_window_in_main_city = true
            if nil ~= self.__tracking_params then
                if missionIsOver() == true then
                    state_machine.excute(self.__tracking_state_machine, 0, self.__tracking_params)
                    if nil ~= self.__tracking_state_machine2 then
                        state_machine.excute(self.__tracking_state_machine2, 0, 0)
                    end
                end
                self.__tracking_params = nil
            end
        end)))
    else
        Panel_home_x:setPosition(cc.p(pos.x, pos.y))
    end
end

function HomeMap:updateTankeInfo( ... )
    if __lua_project_id == __lua_project_red_alert_time then
        local addTankes = {}
        for k, v in pairs(_ED.user_ship) do
            if v.captain_type ~= 3 then
                local isNew = true
                for k1, v1 in pairs(self._tanke_cells) do
                    if tonumber(v.ship_template_id) == tonumber(k1) then
                        isNew = false
                    end
                end
                if isNew == true then
                    table.insert(addTankes, v)
                end
            end
        end

        for k, v in pairs(self._tanke_cells) do
            if v.updateDraw ~= nil then
                v:updateDraw()
            end
        end
        local root = self.roots[1]
        local Panel_map_zoom = ccui.Helper:seekWidgetByName(root, "Panel_map_zoom")
        for k,v in pairs(addTankes) do
            local base_catalogue_info = _ED.base_catalogue_storage_info[""..v.ship_template_id]
            if base_catalogue_info ~= nil then
                local panle_name = "Node_troops_formation_"..base_catalogue_info.types.."_"..base_catalogue_info.row
                local Node_function_build = Panel_map_zoom:getChildByName(panle_name)
                Node_function_build:removeAllChildren(true)
                
                local cell = state_machine.excute("home_tanke_cell_create", 0, {v.ship_id, Node_function_build})
                Node_function_build:addChild(cell)
                self._tanke_cells[""..v.ship_template_id] = cell
            end
        end
    end
end

function HomeMap:updateDrawBuild()
    local addBuilds = {}
    for k,v in pairs(_ED.home_build) do
        local isNew = true
        for k1,v1 in pairs(self._home_cells) do
            if tonumber(k) == tonumber(k1) then
                isNew = false
            end
        end
        if isNew == true then
            table.insert(addBuilds, k)
        end
    end
    for k,v in pairs(self._home_cells) do
        if v.updateDraw ~= nil then
            v:updateDraw(_ED.home_build[""..k])
        end
    end
    local root = self.roots[1]
    local Panel_map_zoom = ccui.Helper:seekWidgetByName(root, "Panel_map_zoom")
    for k,v in pairs(addBuilds) do
        local Node_function_build = Panel_map_zoom:getChildByName("Node_function_build_"..v)
        if nil ~= Node_function_build then
            if _ED.base_build_info["".._ED.home_build[""..v].build_mould_id] ~= nil then
                Node_function_build:removeAllChildren(true)
                local cell = state_machine.excute("home_build_cell_create", 0, {v, _ED.home_build[""..v], Node_function_build})
                Node_function_build:addChild(cell)
                Node_function_build.roots = cell.roots
                Node_function_build._size = cell._tile_size
                self._home_cells[""..v] = cell
            end
        end
    end
end

function HomeMap:updateDraw()
    self._home_cells = {}
    local root = self.roots[1]
    local Panel_map_zoom = ccui.Helper:seekWidgetByName(root, "Panel_map_zoom")

    -- step one 
    local build_result = {}
    for k,v in pairs(_ED.home_build) do
        table.insert(build_result, v)
    end
    local function sortBuild( a, b )
        return tonumber(a.base_mould_id) < tonumber(b.base_mould_id)
    end
    table.sort(build_result, sortBuild)
    local build_index = 1
    local function createBuildCell( sender )
        for i=1,6 do
            local build_info = build_result[build_index]
            if build_info == nil then
                self:stopActionByTag(50000)
                return
            end
            local Node_function_build = Panel_map_zoom:getChildByName("Node_function_build_"..build_info.base_mould_id)
            if nil ~= Node_function_build then
                Node_function_build:removeAllChildren(true)
                if _ED.base_build_info[""..build_info.build_mould_id] ~= nil then
                    local cell = state_machine.excute("home_build_cell_create", 0, {build_info.base_mould_id, build_info, Node_function_build})
                    Node_function_build:addChild(cell)
                    Node_function_build._size = cell._tile_size
                    Node_function_build.roots = cell.roots
                    self._home_cells[""..build_info.base_mould_id] = cell
                    build_index = build_index + 1
                end
            end
        end
    end
    createBuildCell()
    local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.02), cc.CallFunc:create(createBuildCell)))
    action:setTag(50000)
    self:runAction(action)

    if __lua_project_id == __lua_project_red_alert_time then
        local tank_result = {}
        for k,v in pairs(_ED.user_ship) do
            table.insert(tank_result, v)
        end
        local tank_index = 1
        local function createTankCell( sender )
            for i=1,4 do
                local ship_info = tank_result[tank_index]
                if ship_info == nil then
                    self:stopActionByTag(60000)
                    return
                end
                local base_catalogue_info = _ED.base_catalogue_storage_info[""..ship_info.ship_template_id]
                if base_catalogue_info ~= nil then
                    local panle_name = "Node_troops_formation_"..base_catalogue_info.types.."_"..base_catalogue_info.row
                    local Node_function_build = Panel_map_zoom:getChildByName(panle_name)
                    Node_function_build:removeAllChildren(true)
                    local cell = state_machine.excute("home_tanke_cell_create", 0, {ship_info.ship_id, Node_function_build})
                    Node_function_build:addChild(cell)
                    Node_function_build._size = cell._tile_size
                    Node_function_build.roots = cell.roots
                    self._tanke_cells[""..ship_info.ship_template_id] = cell
                end
                tank_index = tank_index + 1
            end
        end
        createTankCell()
        local action = cc.RepeatForever:create(cc.Sequence:create(cc.DelayTime:create(0.01), cc.CallFunc:create(createTankCell)))
        action:setTag(60000)
        self:runAction(action)
    end

    -- step two
    -- for k,v in pairs(_ED.home_build) do
    --     local Node_function_build = Panel_map_zoom:getChildByName("Node_function_build_"..k)
    --     Node_function_build:removeAllChildren(true)
    --     local cell = state_machine.excute("home_build_cell_create", 0, {k, v, Node_function_build})
    --     Node_function_build:addChild(cell)
    --     Node_function_build._size = cell._tile_size
    --     Node_function_build.roots = cell.roots
    --     self._home_cells[""..k] = cell
    -- end
    -- for k,v in pairs(_ED.user_ship) do
    --     local base_catalogue_info = _ED.base_catalogue_storage_info[""..v.ship_template_id]
    --     if base_catalogue_info ~= nil then
    --         local panle_name = "Node_troops_formation_"..base_catalogue_info.types.."_"..base_catalogue_info.row
    --         local Node_function_build = Panel_map_zoom:getChildByName(panle_name)
    --         Node_function_build:removeAllChildren(true)

    --         local cell = state_machine.excute("home_tanke_cell_create", 0, {k, Node_function_build})
    --         Node_function_build:addChild(cell)
    --         Node_function_build._size = cell._tile_size
    --         Node_function_build.roots = cell.roots
    --         self._tanke_cells[""..v.ship_template_id] = cell
    --     end
    -- end
end

function HomeMap:onInit()
    self:setContentSize(cc.size(fwin._width, fwin._height))
    local csbItem = csb.createNode(config_csb.home.home_main_map)
    -- self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    root:removeFromParent(true)
    self:addChild(root)
    table.insert(self.roots, root)

    self.touches_move_pos = {}

    local Panel_home_x = ccui.Helper:seekWidgetByName(root, "Panel_home_x")

    local Panel_home_u = ccui.Helper:seekWidgetByName(root, "Panel_home_u")
    local usize = Panel_home_u:getContentSize()

    local Panel_home_map = ccui.Helper:seekWidgetByName(root, "Panel_home_map")
    
    local layer = Panel_home_map
    layer:setSwallowTouches(true)
    -- layer:ignoreAnchorPointForPosition(true)
    self.mapViewSize = layer:getContentSize()

    self.currentInnerContainerAnchor = layer:getAnchorPoint()

    local listener = cc.EventListenerTouchAllAtOnce:create()

    local acceleration = 1.0    -- 加速器
    local umtime = 0.15         -- 单位时间
    local umxspace = 10          -- x距离
    local umyspace = 10          -- y距离

    listener:registerScriptHandler(function(touches, event)
        if _ED.current_window_in_main_city == false 
            or false == missionIsOver()
            or _ED.build_help_touch == true
            then
            return
        end
        for i, v in pairs(touches) do
            table.insert(self.touches, v)
            v:retain()
        end
        Panel_home_x:stopAllActions()
        self.controllerLayer:stopAllActions()
        local scale = self.controllerLayer:getScale()
        if scale < config_res.viewMinScale then
            self.controllerLayer:setScale(config_res.viewMinScale)
        elseif scale > config_res.viewMaxScale then
            self.controllerLayer:setScale(config_res.viewMaxScale)
        end
        if #self.touches == 1 then
            local scale = root:getScale()
            local touchOenPosition = self.touches[1]:getLocation()
            local pos = self.controllerLayer:convertTouchToNodeSpace(self.touches[1])
            -- print("当前容器的点....",currentPosition.x,currentPosition.y)
            -- print("点击的坐标点....",touchOenPosition.x,touchOenPosition.y)
            -- print("----转换的坐标点",pos.x,pos.y)
            -- pos.y = math.floor(pos.y -  pos.y%60)
            local cellY = self.controllerSize.height - pos.y -60 
            local mod = cellY%60
            cellY = cellY - mod
            local cellX =  math.abs(pos.x) - self.controllerSize.width/2
            local mod1 = cellX%60
            cellX = cellX - mod1

            self._touch_time = 0

            -- if nil ~= Panel_home_x._umxaction then
            --     Panel_home_x:stopAction(Panel_home_x._umxaction)
            --     Panel_home_x._umxaction = nil
            -- end
            -- if nil ~= Panel_home_x._umyaction then
            --     Panel_home_x:stopAction(Panel_home_x._umyaction)
            --     Panel_home_x._umyaction = nil
            -- end
        elseif #self.touches >= 2 then
            local winSize = self:getContentSize() --cc.Director:getInstance():getWinSize();

            local currentPosition = cc.p(Panel_home_x:getPosition())
            local currentAnchorPoint = cc.p(self.controllerLayer:getAnchorPoint())

            local winSize = self:getContentSize() --cc.Director:getInstance():getWinSize();
            winSize.width = winSize.width - app.baseOffsetX
            winSize.height = winSize.height - app.baseOffsetY

            -- 得到当前两触摸点
            local point1 = self.touches[1]:getLocation();
            local point2 = self.touches[2]:getLocation();

            -- 两触摸点的相对中点
            local pointcx = (point1.x + point1.x) / 2
            local pointcy = (point2.y + point2.y) / 2

            -- 两触摸点的相对中点
            local pointVec11 = self.controllerLayer:convertTouchToNodeSpace(self.touches[1])
            local pointVec21 = self.controllerLayer:convertTouchToNodeSpace(self.touches[2])

            -- 两触摸点的相对中点
            local relMidx = (pointVec11.x + pointVec21.x) / 2
            local relMidy = (pointVec11.y + pointVec21.y) / 2

            -- 计算self.controllerLayer的锚点
            local anchorX = relMidx / self.mapViewSize.width
            local anchorY = relMidy / self.mapViewSize.height

            local scale = self.controllerLayer:getScale()
            local mviewSize = cc.size(self.mapViewSize.width * scale, self.mapViewSize.height * scale)

            local mx = (currentAnchorPoint.x - anchorX) * mviewSize.width
            local my = (currentAnchorPoint.y - anchorY) * mviewSize.height

            self.controllerLayer:setAnchorPoint(cc.p(anchorX, anchorY))

            local currentPosition = cc.p(Panel_home_x:getPosition())
            currentPosition.x = currentPosition.x - mx
            currentPosition.y = currentPosition.y - my
            Panel_home_x:setPosition(currentPosition)
        end
        state_machine.excute("main_window_change_button_fun_state", 0, false)
        state_machine.excute("home_map_change_home_build_level_state", 0, true)
    end, cc.Handler.EVENT_TOUCHES_BEGAN)

    listener:registerScriptHandler(function(touches, event)
        if _ED.current_window_in_main_city == false 
            or false == missionIsOver()
            then
            return
        end
        local winSize = self:getContentSize() --cc.Director:getInstance():getWinSize();
        if #self.touches >= 2 then-- 多点进行缩放
            -- 得到当前两触摸点
            local point1 = self.touches[1]:getLocation()
            local point2 = self.touches[2]:getLocation()

            -- 计算两点之间得距离
            local currDistance = cc.pGetDistance(point1, point2) -- point1.distance(point2);

            -- 计算两触摸点上一时刻之间得距离
            local prevDistance = cc.pGetDistance(self.touches[1]:getPreviousLocation(), self.touches[2]:getPreviousLocation()) -- touches[0]->getPreviousLocation().distance(touches[1]->getPreviousLocation());

            -- 两触摸点与原点的差向量，pointVec1和pointVec2是相对于self.controllerLayer的位置
            local pointVec1 = cc.pSub(point1, self.currentInnerContainerOrigin)
            local pointVec2 = cc.pSub(point2, self.currentInnerContainerOrigin)

            -- 两触摸点的相对中点
            local relMidx = (pointVec1.x + pointVec2.x) / 2
            local relMidy = (pointVec1.y + pointVec2.y) / 2

            -- 计算self.controllerLayer的锚点
            local anchorX = relMidx / self.controllerLayer:getBoundingBox().width
            local anchorY = relMidy / self.controllerLayer:getBoundingBox().height

            -- 相对屏幕的中点
            local absMidx = (point2.x + point1.x) / 2
            local absMidy = (point2.y + point1.y) / 2

            -- 缩放时，为了避免出现空白的区域，需要做以下的边界处理。 
            -- 当self.controllerLayer快要进入到屏幕时，修改self.controllerLayer的位置（既absMidx和absMidy）。
            if self.currentInnerContainerOrigin.x > 0 then
                absMidx = absMidx - self.currentInnerContainerOrigin.x
            end

            if self.currentInnerContainerOrigin.x < -self.controllerLayer:getBoundingBox().width + winSize.width then
                absMidx = absMidx - self.controllerLayer:getBoundingBox().width + winSize.width - self.currentInnerContainerOrigin.x
            end

            if self.currentInnerContainerOrigin.y > 0 then
                absMidy = absMidy - self.currentInnerContainerOrigin.y
            end

            if self.currentInnerContainerOrigin.y < -self.controllerLayer:getBoundingBox().height + winSize.height then
                absMidy = absMidy - self.controllerLayer:getBoundingBox().height + winSize.height - self.currentInnerContainerOrigin.y
            end

            -- -- 重设self.controllerLayer锚点和位置
            -- self.controllerLayer:setAnchorPoint(cc.p(anchorX, anchorY))
            -- self.controllerLayer:setPosition(cc.p(absMidx, absMidy))

            -- 根据两触摸点前后的距离计算缩放倍率
            local scale = self.controllerLayer:getScale() * (currDistance / prevDistance)

            -- 控制缩放倍率在1～2倍之间，最小倍率不能太小，不让背景将不能填充满整个屏幕。
            scale = math.min(config_res.maxScale, math.max(config_res.minScale, scale))

            local currentPosition = cc.p(Panel_home_x:getPosition())
            currentPosition.x = currentPosition.x
            currentPosition.y = currentPosition.y
            local currentAnchorPoint = cc.p(self.controllerLayer:getAnchorPoint())
            local mviewSize = cc.size(self.mapViewSize.width * currentAnchorPoint.x * scale, self.mapViewSize.height * currentAnchorPoint.y * scale)

            if currentPosition.x > mviewSize.width then
                currentPosition.x = mviewSize.width
            end

            if (self.mapViewSize.width * scale - mviewSize.width + currentPosition.x) < winSize.width then
                currentPosition.x = winSize.width - (self.mapViewSize.width * scale - mviewSize.width)
            end

            if currentPosition.y > mviewSize.height then
                currentPosition.y = mviewSize.height
            end

            if (self.mapViewSize.height * scale - mviewSize.height + currentPosition.y) < winSize.height then
                currentPosition.y = winSize.height - (self.mapViewSize.height * scale - mviewSize.height)
            end

            Panel_home_x:setPosition(cc.p(currentPosition.x, currentPosition.y))

            self.controllerLayer:setScale(scale)

            -- 更新原点位置
            self.currentInnerContainerOrigin = cc.pSub(cc.p(absMidx, absMidy), cc.p(self.controllerLayer:getBoundingBox().width * anchorX, self.controllerLayer:getBoundingBox().height * anchorY))

            -- debug.print_r(self.currentInnerContainerOrigin)
        elseif #self.touches == 1 then-- 单点进行移动
            -- 单点时，touches中只有一个Touch对象，所以通过touches[0]就可以得到触摸对象
            local touch = self.touches[1]
            self._touch_time = os.clock()

            -- 计算滑动过程中的滑动增量
            local diff = touch:getDelta()
            diff.x = diff.x / app.scaleFactor 
            diff.y = diff.y / app.scaleFactor
            if diff.x <= 3 and diff.y <= 3 and diff.x >= -3 and diff.y >= -3 then 
                return
            end

            -- 得到当前self.controllerLayer的位置
            -- local currentPos = cc.p(self.controllerLayer:getPosition())
            local currentPos = cc.p(Panel_home_x:getPosition())

            -- 得到滑动后self.controllerLayer应该所在的位置
            local pos = cc.pAdd(currentPos, diff)

            local scale = self.controllerLayer:getScale()
            
            -- 得到此刻self.controllerLayer的尺寸
            local controllerLayerCurrSize = cc.size(self.controllerLayer:getBoundingBox().width, self.controllerLayer:getBoundingBox().height)
            -- local controllerLayerCurrSize = self.controllerLayer:getContentSize()

            -- 边界控制，约束pos的位置
            pos.x = math.min(pos.x, controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)
            pos.x = math.max(pos.x, -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)

            pos.y = math.min(pos.y, controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)
            pos.y = math.max(pos.y, -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)

            -- 重设self.controllerLayer位置
            -- self.controllerLayer:setPosition(pos)
            Panel_home_x:setPosition(pos)
            table.insert(self.touches_move_pos, {pos, self._touch_time})

            -- 更新原点位置
            if pos.x >= controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x 
                or pos.x <= -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x then
                diff.x = 0
            end
             
            if pos.y >= controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y 
                or pos.y <= -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y then
                diff.y = 0
            end

            self.currentInnerContainerOrigin = cc.pAdd(self.currentInnerContainerOrigin, diff)
        end

    end, cc.Handler.EVENT_TOUCHES_MOVED)

    listener:registerScriptHandler(function(touches, event)
        -- if #self.touches > 1 then
            for m, n in pairs(self.touches) do
                n:release()
            end
            self.touches = {}
        -- end
        if _ED.current_window_in_main_city == false 
            or false == missionIsOver()
            then
            return
        end
        local isReviewScale = false
        local scale = self.controllerLayer:getScale()
        if scale < config_res.viewMinScale then
            isReviewScale = true
            self.controllerLayer:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(1, config_res.viewMinScale)))
        elseif scale > config_res.viewMaxScale then
            isReviewScale = true
            self.controllerLayer:runAction(cc.EaseSineOut:create(cc.ScaleTo:create(1, config_res.viewMaxScale)))
        end

        local count = #self.touches_move_pos
        if count > 1 then
            if umxspace > 0 then
                local umxaction = cc.Sequence:create(cc.EaseSineOut:create(cc.MoveBy:create(umtime * umxspace / acceleration, cc.p(0, 0))), 
                    cc.CallFunc:create(function(sender)
                        sender._umxaction = nil
                    end))
                Panel_home_x:runAction(umxaction)
                Panel_home_x._umxaction = umxaction
            end

            if umyspace > 0 then
                local umyaction = cc.Sequence:create(cc.EaseSineOut:create(cc.MoveBy:create(umtime * umxspace / acceleration, cc.p(0, umyspace))), 
                    cc.CallFunc:create(function(sender)
                        sender._umyaction = nil
                    end))
                Panel_home_x:runAction(umyaction)
                Panel_home_x._umyaction = umyaction
            end

            --[[
            local moveX = 0
            local moveY = 0
            local time = 0
            for k,v in pairs(self.touches_move_pos) do
                if k >= 2 then
                    local last_info = self.touches_move_pos[k - 1]
                    local end_info = self.touches_move_pos[k]
                    moveX = moveX + (end_info[1].x - last_info[1].x)
                    moveY = moveY + (end_info[1].y - last_info[1].y)
                    time = time + (end_info[2] - last_info[2])
                end
            end
            moveX = moveX/(count - 1)
            moveY = moveY/(count - 1)
            time = time/(count - 1)
            local s = math.sqrt(moveX * moveX + moveY * moveY)
            if s == 0 then
                s = 0.01
            end
            local speed = s / time
            local towardX = 1
            if moveX < 0 then
                towardX = -1
            elseif moveX == 0 then
                towardX = 0
            end
            local towardY = 1
            if moveY < 0 then
                towardY = -1
            elseif moveY == 0 then
                towardY = 0
            end
            local time = 0.8
            local baseX = speed * time * 2 / 5
            local baseY = speed * time / 4

            local currentPos = cc.p(Panel_home_x:getPosition())
            local pos = cc.pAdd(currentPos, cc.p(towardX * baseX, towardY * baseY))
            ]]

            local moveX = (self.touches_move_pos[count][1].x - self.touches_move_pos[count - 1][1].x)
            local moveY = (self.touches_move_pos[count][1].y - self.touches_move_pos[count - 1][1].y)
            local current_clock = os.clock()
            local clock = current_clock - self._touch_time
            if self._touch_time > 0 and clock < 0.1 then
                if isReviewScale == false and (math.abs(moveX) > 0.1 or math.abs(moveY) > 0.1) then
                    local winSize = self:getContentSize()
                    local currentPos = cc.p(Panel_home_x:getPosition())
                    local pos = nil
                    local time = 0.5
                    if math.abs(moveX) >= 30 then
                        time = 1.2
                        pos = cc.pAdd(currentPos, cc.p(moveX * 60, moveY * 20))
                    elseif math.abs(moveX) <= 5 then
                        time = 1.4
                        if #self.touches_move_pos <= 8 then
                            pos = cc.pAdd(currentPos, cc.p(moveX * 38, moveY * 27))
                        else
                            pos = cc.pAdd(currentPos, cc.p(moveX * 30, moveY * 27))
                        end
                    elseif math.abs(moveX) <= 10 then
                        time = 1.4
                        pos = cc.pAdd(currentPos, cc.p(moveX * 28, moveY * 27))
                    else
                        time = 1.3
                        if #self.touches_move_pos <= 8 then
                            pos = cc.pAdd(currentPos, cc.p(moveX * 20, moveY * 27))
                        else
                            pos = cc.pAdd(currentPos, cc.p(moveX * 24, moveY * 27))
                        end
                    end
                
                    -- 得到此刻self.controllerLayer的尺寸
                    local controllerLayerCurrSize = cc.size(self.controllerLayer:getBoundingBox().width, self.controllerLayer:getBoundingBox().height)

                    -- 边界控制，约束pos的位置
                    pos.x = math.min(pos.x, controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)
                    pos.x = math.max(pos.x, -controllerLayerCurrSize.width + winSize.width + controllerLayerCurrSize.width * self.controllerLayer:getAnchorPoint().x)

                    pos.y = math.min(pos.y, controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)
                    pos.y = math.max(pos.y, -controllerLayerCurrSize.height + winSize.height + controllerLayerCurrSize.height * self.controllerLayer:getAnchorPoint().y)

                    -- 重设self.controllerLayer位置
                    local moveAction = cc.MoveTo:create(time, pos)
                    -- local action = cc.EaseOut:create(moveAction, 4)
                    local action = cc.EaseSineOut:create(moveAction)
                    -- local action = cc.EaseExponentialOut:create(moveAction)
                    -- self.controllerLayer:runAction(action)
                    Panel_home_x:runAction(action)
                end
            end

        end
        self.touches_move_pos = {}
        state_machine.excute("main_window_change_button_fun_state", 0, true)
        state_machine.excute("home_map_change_home_build_level_state", 0, false)
    end, cc.Handler.EVENT_TOUCHES_ENDED)

    local eventDispatcher = layer:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, layer)
    self.controllerLayer = layer
    self.viewSize = self.controllerLayer:getParent():getContentSize()
    self.controllerSize = self.controllerLayer:getContentSize()

    self.currentInnerContainerOrigin = cc.p(self.controllerLayer:getPosition())

    self.controllerLayer:setScale(config_res.viewMinScale)
    
	self:updateDraw()
    self:playSoldierMoveEffect()
    self:playHelicopterEffect()
    self:playHomeEffect()

    self:scrollToPanelCity(1, false)
    self:playActionsTrainAndWarcraft()

    self:updateHomePatrolRewardState()
end

-- function HomeMap:onUpdate( dt )
--     -- local root = self.roots[1]
--     -- local Panel_home_x = ccui.Helper:seekWidgetByName(root, "Panel_home_x")
--     -- debug.print_r(cc.p(Panel_home_x:getPosition()))
-- end

function HomeMap:onEnterTransitionFinish()

end

function HomeMap:onResume( window )
    self._play_effect = true
    -- for i, v in pairs(self._home_cells) do
    --     v:resume()
    -- end
end

function HomeMap:onPause( window )
    self._play_effect = false
    -- for i, v in pairs(self._home_cells) do
    --     v:pause()
    -- end
end

function HomeMap:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
	self:onInit()
    return self
end

function HomeMap:onExit()
    state_machine.remove("home_map_update_build")
    state_machine.remove("home_map_scroll_to_panel_city")
    state_machine.remove("home_map_scroll_to_position")
    state_machine.remove("home_map_update_prodcution_state")
    state_machine.remove("home_map_update_tanke_info")
    state_machine.remove("home_map_change_home_build_level_state")
    state_machine.remove("home_map_change_home_build_top_info")
    state_machine.remove("home_map_change_home_build_legion_info")
    state_machine.remove("home_map_all_build_visible")
    state_machine.remove("home_map_play_openness_effect")
    state_machine.remove("home_map_reset_scale")
    state_machine.remove("home_map_free_build_up")
    state_machine.remove("home_map_update_patrol_reward_state")
end