-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本系统
-------------------------------------------------------------------------------------------------------
AdventureDuplicate = class("AdventureDuplicateClass", Window)
AdventureDuplicate.__is_first_init = false
app.load("client.adventure.duplicate.AdventureDuplicateMap")
app.load("client.adventure.duplicate.AdventureDuplicateScene")
app.load("client.adventure.duplicate.AdventureDuplicateDifficulty")
app.load("client.adventure.duplicate.AdventureDuplicateMapListView")
app.load("client.adventure.duplicate.AdventureDuplicateBattleDlg")
app.load("client.adventure.duplicate.AdventureDuplicateCapacityTipDlg")
app.load("client.adventure.duplicate.event.AdventureDuplicateEventBossDlg")
app.load("client.adventure.duplicate.event.AdventureDuplicateEventBoxDlg")
app.load("client.adventure.duplicate.event.AdventureDuplicateEventMeetDlg")

app.load("client.adventure.packs.prop.AdventurePropStorage")
app.load("client.adventure.packs.hero.AdventureHeroStorage")

app.load("client.adventure.utils.AdventureSprite")
app.load("client.adventure.utils.AdventureShareGradeDialog")

app.load("client.loader.formula")
app.load("client.adventure.activity.reward.AdventureRewardCenter")
    
function AdventureDuplicate:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1
    self.selectShowSceneId = -1 
    self.selectNpcId = -1
    self._scene_difficulty_index = 1
    self.sceneDomeId = -1    
    self.copy_controller_status = -1
    self.Panel_event = nil
    self.random_event_type = 0
    self.random_event_id = 0
    self.reaward_center_count = 0
    self.enum_status = {
        COPY_CONTROLLER_STATUS_BATTLE       = 0, -- 战斗事件
        COPY_CONTROLLER_STATUS_NEXT         = 1, -- 下一关卡
        COPY_CONTROLLER_STATUS_NEW          = 2, -- 发现大陆
        COPY_CONTROLLER_STATUS_CD           = 3, -- 等待CD中
    }
    --冒险意外事件
    self.enum_random_envent = {
        DUPLICATE_RANDOM_EVENT_BOSS  = 1, --boss
        DUPLICATE_RANDOM_EVENT_MEET  = 2,  --偶遇
        DUPLICATE_RANDOM_EVENT_BOX   = 3,  --宝箱
        
    }

    -- Initialize adventure duplicate state machine.
    local function init_adventure_duplicate_terminal()
        -- 难度
        local adventure_duplicate_difficulty_terminal = {
            _name = "adventure_duplicate_difficulty",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                  fwin:open(AdventureDuplicateDifficulty:new():init(instance.selectSceneId), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 地图
        local adventure_duplicate_map_list_terminal = {
            _name = "adventure_duplicate_map_list",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("menu_adventure_open_button",0,"")
                instance = fwin:find("AdventureDuplicateClass")
                fwin:open(AdventureDuplicateMapListView:new():init(instance.selectSceneId), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 背包
        local adventure_duplicate_package_terminal = {
            _name = "adventure_duplicate_package",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventurePropStorage:new():init(), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 战斗
        local adventure_duplicate_start_fight_terminal = {
            _name = "adventure_duplicate_start_fight",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                    instance:copyController()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 初始化控制菜单的状态
        local adventure_duplicate_init_copy_controller_status_terminal = {
            _name = "adventure_duplicate_init_copy_controller_status",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                    instance:initControllerStatus()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 队伍强化
        local adventure_duplicate_hero_strengthen_terminal = {
            _name = "adventure_duplicate_hero_strengthen",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("menu_clean_page_state_for_streng", 0,"")
                state_machine.excute("menu_adventure_open_button",0,"")
                fwin:open(AdventureHeroStorage:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换地图
        local adventure_duplicate_change_map_terminal = {
            _name = "adventure_duplicate_change_map",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                    -- 从列表里面切换地图后,默认是第一个 
                    self._scene_difficulty_index = 1
                    instance:changeDifficutlyTitle(1)
                    instance:updateSeeDrawMapLayer(tonumber(params)) 
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换场景
        local adventure_duplicate_change_scene_terminal = {
            _name = "adventure_duplicate_change_scene",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                    state_machine.excute("adventure_duplicate_npc_on_hook", 0, {sceneId = params.sceneId, npcId = params.npcId})
                    instance:selectDuplicate(tonumber(params.sceneId))
                    instance:changeScene(params.sceneId, params.npcId)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 发送NPC挂机请求
        local adventure_duplicate_npc_on_hook_terminal = {
            _name = "adventure_duplicate_npc_on_hook",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                    instance:npcOnHook(params.sceneId, params.npcId)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击下一关后,刷新界面
        local adventure_duplicate_update_next_scene_terminal = {
            _name = "adventure_duplicate_update_next_scene",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                    instance:changeMap(params)
                    state_machine.excute("adventure_duplicate_map_change_scene_with_npc_index", 0, 1)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 绘制攻击按钮
        local adventure_duplicate_show_attack_button_terminal = {
            _name = "adventure_duplicate_show_attack_button",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                    instance:showAttackButton()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换冒险副本难度
        local adventure_duplicate_change_duplicate_difficulty_terminal = {
            _name = "adventure_duplicate_change_duplicate_difficulty",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeDuplicateDifficutly(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --冒险事件
        local adventure_duplicate_click_event_terminal = {
            _name = "adventure_duplicate_click_event",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then
                   -- print(self.random_event_type,"---Type")
                    local function responseOnceCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        end
                    end
                    NetworkManager:register(protocol_command.random_event_open.code, nil, nil, nil, self, responseOnceCallback, false, nil)
                    if self.random_event_type == self.enum_random_envent.DUPLICATE_RANDOM_EVENT_BOSS then 
                        --boss
                        fwin:open(AdventureDuplicateEventBossDlg:new():init(1), fwin._view)
                    elseif self.random_event_type == self.enum_random_envent.DUPLICATE_RANDOM_EVENT_MEET then 
                        fwin:open(AdventureDuplicateEventMeetDlg:new():init(), fwin._view)
                    elseif self.random_event_type == self.enum_random_envent.DUPLICATE_RANDOM_EVENT_BOX then 
                        fwin:open(AdventureDuplicateEventBoxDlg:new():init(), fwin._view)
                    else
                        instance.Panel_event:setVisible(false)
                        TipDlg.drawTextDailog(_string_piece_info[432])
                    end
                end
           
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

         --更新冒险事件
        local adventure_duplicate_random_event_update_terminal = {
            _name = "adventure_duplicate_random_event_update",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            
                instance = fwin:find("AdventureDuplicateClass")
                if instance ~= nil then    
                    instance:updateRandomEventLayer()
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- --更新意外事件奖励
        -- local adventure_duplicate_random_event_reward_update_terminal = {
        --     _name = "adventure_duplicate_random_event_reward_update",
        --     _init = function (terminal)
                
        --     end,
        --     _inited = false,
        --     _instance = self,
        --     _state = 0,
        --     _invoke = function(terminal, instance, params)
        --         instance = fwin:find("AdventureDuplicateClass")
        --         if instance ~= nil then    

        --         end
                
        --         return true
        --     end,
        --     _terminal = nil,
        --     _terminals = nil
        -- }
        
        state_machine.add(adventure_duplicate_difficulty_terminal)
        state_machine.add(adventure_duplicate_map_list_terminal)
        state_machine.add(adventure_duplicate_package_terminal)
        state_machine.add(adventure_duplicate_start_fight_terminal)
        state_machine.add(adventure_duplicate_init_copy_controller_status_terminal)
        state_machine.add(adventure_duplicate_hero_strengthen_terminal)
        state_machine.add(adventure_duplicate_change_map_terminal)
        state_machine.add(adventure_duplicate_change_scene_terminal)
        state_machine.add(adventure_duplicate_npc_on_hook_terminal)
        state_machine.add(adventure_duplicate_show_attack_button_terminal)
        state_machine.add(adventure_duplicate_change_duplicate_difficulty_terminal)
        state_machine.add(adventure_duplicate_update_next_scene_terminal)
        state_machine.add(adventure_duplicate_click_event_terminal)
        state_machine.add(adventure_duplicate_click_event_terminal)
        state_machine.add(adventure_duplicate_random_event_update_terminal)
    
        state_machine.init()
    end
    
    -- call func init adventure duplicate state machine.
    init_adventure_duplicate_terminal()
end

function AdventureDuplicate:init()
    self:onInit()
    if _ED.all_npc_on_hook_time == nil or table.getn(_ED.all_npc_on_hook_time) == 0 then
        local function responseOnHookInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil then
                    response.node:onInit_map_and_scene()
                end
            end
        end

        protocol_command.on_hook_init.param_list = ""
        NetworkManager:register(protocol_command.on_hook_init.code, nil, nil, nil, self, responseOnHookInitCallback, false, nil)
    else
        self:onInit_map_and_scene()
    end
	return self
end

function AdventureDuplicate:onUpdate(dt)
    
end

function AdventureDuplicate:npcOnHook(sceneId, npcId)
    local function responseOnHookCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then
                response.node:changeScene(_ED.on_hook_reward_scene, _ED.on_hook_reward_npc)
            end
        end
    end
    _ED.all_npc_on_hook_os_time = os.time()
    _ED.current_npc_attack_os_time = _ED.all_npc_on_hook_os_time
    protocol_command.on_hook.param_list = "" .. npcId .. "\r\n" .. "" .. sceneId
    NetworkManager:register(protocol_command.on_hook.code, nil, nil, nil, self, responseOnHookCallback, false, nil)
end

function AdventureDuplicate:copyController()
    if self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_BATTLE then
        fwin:open(AdventureDuplicateBattleDlg:new():init(self.selectSceneId, self.selectNpcId, self._scene_difficulty_index), fwin._ui)
    elseif self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_NEXT then
        local sceneMould = dms.element(dms["pve_scene"], self.selectSceneId)
        local npcs = dms.atos(sceneMould, pve_scene.npcs)
        local lists = zstring.split(npcs, "|")
        local list = zstring.split(lists[self._scene_difficulty_index], ",")
        local index = 0
        for i, v in pairs(list) do
            if ""..v == ""..self.selectNpcId then
                index = i
                break
            end
        end
        index = zstring.tonumber(index)
        local currentScceneId = self.selectSceneId
        local currentNpcId = self.selectNpcId
        
        if index == 5 then
            currentScceneId = zstring.tonumber(currentScceneId) + 1
            self:changeMap(currentScceneId).

            sceneMould = dms.element(dms["pve_scene"], self.selectSceneId)
            npcs = dms.atos(sceneMould, pve_scene.npcs)
            lists = zstring.split(npcs, "|")
            list = zstring.split(lists[self._scene_difficulty_index], ",")
            self:changeScene(currentScceneId, list[1])
        else
            if self.selectSceneId ~= self.selectShowSceneId then 
                ---展示场景跟当前选中场景不一致,切换到选中场景
                self:updateDrawMapLayer()

            end

            -- currentNpcId = zstring.tonumber(list[index + 1])
            -- self:changeScene(currentScceneId, currentNpcId)
            -- print("_____3___2_", currentScceneId, currentNpcId)
            index = index + 1
            state_machine.excute("adventure_duplicate_map_change_scene_with_npc_index", 0, index)

        end
    elseif self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_NEW then
        state_machine.excute("adventure_duplicate_scene_updata_explore", 0, 0)
        local currentScceneId = zstring.tonumber(self.selectSceneId) + 1
        local sceneMould = dms.element(dms["pve_scene"], currentScceneId)
        local open_scene =  dms.int(dms["pve_scene"],self.selectSceneId, pve_scene.open_scene)
        if open_scene == -1 then 
            TipDlg.drawTextDailog(_wait_open_tip)
            return
        end
        local npcs = dms.atos(sceneMould, pve_scene.npcs)
        local lists = zstring.split(npcs, "|")
        local list = zstring.split(lists[self._scene_difficulty_index], ",")
        local npcId = list[1]
        local cell = AdventureDuplicateMapListCell:createCell()
        cell:init(sceneMould, currentScceneId, 0)
        if cell:isOpened() == false or cell:checkPreoSceneState() == false then
            fwin:open(AdventureDuplicateCapacityTipDlg:new():init(cell.sceneId), fwin._ui)
            --TipDlg.drawTextDailog(_string_piece_info[387])
            return false
        end
        --跳转关卡的时候弹出提示框
        if cell:isNextScene() == true and tonumber(self.selectSceneId) == tonumber(_ED.max_scene_id) then 
            fwin:open(AdventureDuplicateCapacityTipDlg:new():init(cell.sceneId), fwin._ui)
            return false
        end
        if cell:checkCapacity() == false then
            fwin:open(AdventureDuplicateCapacityTipDlg:new():init(cell.sceneId), fwin._ui)
            return false
        end

        -- local currentScceneId = zstring.tonumber(self.selectSceneId) + 1
        state_machine.excute("adventure_duplicate_change_map", 0, currentScceneId)
        --self:changeMap(currentScceneId)

        -- local sceneMould = dms.element(dms["pve_scene"], self.selectSceneId)
        -- local npcs = dms.atos(sceneMould, pve_scene.npcs)
        -- local lists = zstring.split(npcs, "|")
        -- local list = zstring.split(lists[self._scene_difficulty_index], ",")
        -- -- self:changeScene(currentScceneId, list[1])
        state_machine.excute("adventure_duplicate_map_change_scene_with_npc_index", 0, 1)
    elseif self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_CD then

    end
end

function AdventureDuplicate:selectDuplicate(sceneId)
    if sceneId <= 0 then 
        local scenes = dms.searchs(dms["pve_scene"], pve_scene.scene_type, "0")
        for i, v in pairs(scenes) do
            local sceneId = dms.atoi(v, pve_scene.id)
            if _ED.scene_current_state[sceneId] == nil or _ED.scene_current_state[sceneId] == "" then
                break
            end
            if tonumber(_ED.scene_current_state[sceneId]) < 0 then
                -- 未开启章节
                break
            end
            self.selectSceneId = sceneId
            self.selectShowSceneId = sceneId
        end
    else
        self.selectSceneId = sceneId
        self.selectShowSceneId = sceneId
    end
end

function AdventureDuplicate:updateDrawMapLayer()
    local root = self.roots[1]
    -- 地图
    local map = ccui.Helper:seekWidgetByName(root, "Panel_map")
    local findwindow = fwin:find("AdventureDuplicateMapClass")
    if findwindow ~= nil then 
        fwin:close(findwindow)
    end
    fwin:open(AdventureDuplicateMap:new():init(map, self.selectSceneId, self._scene_difficulty_index))
    -- 绘制副本名称
    ccui.Helper:seekWidgetByName(root, "Text_map_name"):setString(dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.scene_name))
end

--从地图中选择,只做展示,不更新本地场景跟NPC数值
function AdventureDuplicate:updateSeeDrawMapLayer(sceneId)
    local root = self.roots[1]
    -- 地图
    self.selectShowSceneId = sceneId
    local map = ccui.Helper:seekWidgetByName(root, "Panel_map")
    local findwindow = fwin:find("AdventureDuplicateMapClass")
    if findwindow ~= nil then 
        fwin:close(findwindow)
    end
    fwin:open(AdventureDuplicateMap:new():init(map, sceneId, 1))
    -- 绘制副本名称
    ccui.Helper:seekWidgetByName(root, "Text_map_name"):setString(dms.string(dms["pve_scene"], sceneId, pve_scene.scene_name))
end

function AdventureDuplicate:updateRandomEventLayer()
    
    local root = self.roots[1]
    if _ED.random_event ~= nil and tonumber( _ED.random_event.event_id) > 0 then 
        local  moule_data = dms.element(dms["spirite_palace_event_library"], tonumber(_ED.random_event.event_id))
        self.random_event_id = dms.atoi(moule_data, spirite_palace_event_library.event_id)
        self.random_event_type = dms.atoi(moule_data, spirite_palace_event_library.group_type)
        self.Panel_event:setVisible(true)
    else 
        self.Panel_event:setVisible(false)
    end   
end

function AdventureDuplicate:updateDrawSceneLayer(sceneId, npcId)
    local root = self.roots[1]
    -- 场景动画窗口
    --print(" =======  修改:",sceneId,npcId,self._scene_difficulty_index)
    --- 判断选择内存中的难度选项跟当前NPC是否一致
    local difficulty = self._scene_difficulty_index 
    local lastDifficulty = self:changeDifficutly(npcId)
    if difficulty ~= lastDifficulty then 
        --刷新的时候发现难度有变化
        self:changeDifficutlyTitle(lastDifficulty)
        self:updateDrawMapLayer()
    end
    local scene = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
    if fwin:find("AdventureDuplicateSceneClass") == nil then 
        -- 没有这个会重新创建一遍 --这里只会执行一次
        fwin:open(AdventureDuplicateScene:new():init(scene, sceneId, npcId))
        self.sceneDomeId = sceneId
    else 
        if self.selectSceneId == self.sceneDomeId then
            --切换的场景时之前的 不需要动画
            state_machine.excute("adventure_duplicate_scene_change_update",0,{_datas = {_sceneId = sceneId,_npcId = npcId}})
        else
            fwin:open(AdventureDuplicateScene:new():init(scene, sceneId, npcId))
            self.sceneDomeId = sceneId
        end
    end 
    
    self.selectNpcId = npcId

    -- 初始化副本的控制状态
    self:initControllerStatus()

    state_machine.excute("adventure_duplicate_map_on_hook_reward_scene", 0, 0)
end

function AdventureDuplicate:changeMap(sceneId)
    self:selectDuplicate(sceneId)
    -- self:updateDraw()
    self:updateDrawMapLayer()
end

function AdventureDuplicate:changeDifficutly( npcId)
    local sceneMould = dms.element(dms["pve_scene"], self.selectSceneId)
    local npcs = dms.atos(sceneMould, pve_scene.npcs)
    local lists = zstring.split(npcs, "|")
    local list = zstring.split(lists[self._scene_difficulty_index], ",")
    if lists == nil then 
        self._scene_difficulty_index = 1
        return 1
    end
    for i, v in pairs(lists) do
        local list = zstring.split(v, ",")
        for k,v in pairs(list) do
             if ""..v == ""..npcId then
                 self._scene_difficulty_index = i
                return self._scene_difficulty_index
            end
        end 
    end
   self._scene_difficulty_index = 1
   return 1
end

function AdventureDuplicate:changeScene(sceneId, npcId)
    -- self:selectDuplicate(sceneId)
    -- self:updateDraw()
    self:updateDrawSceneLayer(sceneId, npcId)
end

function AdventureDuplicate:updateDraw()
    self:updateDrawMapLayer()
    self:updateDrawSceneLayer()
end

function AdventureDuplicate:showAttackButton()
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(true)
end

function AdventureDuplicate:changeDuplicateDifficutly(params)
    
    if self._scene_difficulty_index == params then
        return
    end
    self._scene_difficulty_index = params

    self:changeDifficutlyTitle(self._scene_difficulty_index)
    self:changeMap(self.selectSceneId)
end

function AdventureDuplicate:changeDifficutlyTitle(params)
    local root = self.roots[1]
    ccui.Helper:seekWidgetByName(root, "Text_jiandan"):setVisible(tonumber(params) == 1)
    ccui.Helper:seekWidgetByName(root, "Text_putong"):setVisible(tonumber(params) == 2)
    ccui.Helper:seekWidgetByName(root, "Text_kunan"):setVisible(tonumber(params) == 3)
end

function AdventureDuplicate:initControllerStatus()
    local root = self.roots[1]
    self.copy_controller_status = -1
    -- 判断当前NPC是否可攻击
    local npcState = tonumber(_ED.npc_state[tonumber(""..self.selectNpcId)])
    if npcState == 0 then
        self.copy_controller_status = self.enum_status.COPY_CONTROLLER_STATUS_BATTLE
        -- 判断当前NPC是否有CD
        local npcId = tonumber(""..self.selectNpcId)
        local interval = (_ED.current_npc_attack_os_time + zstring.tonumber(_ED.all_npc_battle_wait_time[npcId])) - os.time()
        if interval > 0 then
            self.copy_controller_status = self.enum_status.COPY_CONTROLLER_STATUS_CD
        end
    else
        -- -- 查找所有的副本，确认是否有新开启的
        -- for i, v in pairs(_ED.scene_current_state) do
        --     if v == "0" then
        --         self.copy_controller_status = self.enum_status.COPY_CONTROLLER_STATUS_NEW
        --     end
        -- end
        -- 切换新副本
        local sceneMould = dms.element(dms["pve_scene"], self.selectSceneId)
        local npcs = dms.atos(sceneMould, pve_scene.npcs)
        local lists = zstring.split(npcs, "|")
        local list = zstring.split(lists[self._scene_difficulty_index], ",")
        local index = 0
        for i, v in pairs(list) do
            if ""..v == ""..self.selectNpcId then
                index = i
                break
            end
        end
        index = zstring.tonumber(index)
        if index == 5 then
            self.copy_controller_status = self.enum_status.COPY_CONTROLLER_STATUS_NEW
        end

        if self.copy_controller_status ~= self.enum_status.COPY_CONTROLLER_STATUS_NEW then
            -- 判断是否可以进入下一战
            if tonumber(_ED.npc_state[tonumber(""..self.selectNpcId)]) > 0 then
                self.copy_controller_status = self.enum_status.COPY_CONTROLLER_STATUS_NEXT
            end
        end
    end
	ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(true)
    local Button_zhandou = self.Button_zhandou -- ccui.Helper:seekWidgetByName(root, "Button_zhandou")
    local Panel_stage_1 = self.Panel_stage_1 -- ccui.Helper:seekWidgetByName(root, "Panel_stage_1")
    local Panel_stage_2 = self.Panel_stage_2 -- ccui.Helper:seekWidgetByName(root, "Panel_stage_2")
    local Panel_stage_3 = self.Panel_stage_3 -- ccui.Helper:seekWidgetByName(root, "Panel_stage_3")
    local Panel_stage_4 = self.Panel_stage_4 -- ccui.Helper:seekWidgetByName(root, "Panel_stage_4")
    Button_zhandou:setVisible(true)
    Panel_stage_1:setVisible(false)
    Panel_stage_2:setVisible(false)
    Panel_stage_3:setVisible(false)
    Panel_stage_4:setVisible(false)

    Panel_stage_1:setTouchEnabled(false)
    Panel_stage_2:setTouchEnabled(false)
    Panel_stage_3:setTouchEnabled(false)
    Panel_stage_4:setTouchEnabled(false)

    if self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_BATTLE then
        Panel_stage_1:setVisible(true)
    elseif self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_NEXT then
        Panel_stage_2:setVisible(true)
    elseif self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_NEW then
        Panel_stage_3:setVisible(true)
    elseif self.copy_controller_status == self.enum_status.COPY_CONTROLLER_STATUS_CD then
        Panel_stage_4:setVisible(true)
    end
end

function AdventureDuplicate:onEnterTransitionFinish()

     --场景提示
    state_machine.excute("adventure_push_info_open",0,1)
    
    local reward = getSceneReward(51)
    if reward ~= nil then 
        app.load("client.adventure.reward.AdventureTipReward")
        fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
        reward = nil
    end

    self:updateRandomEventLayer()
    self.reaward_center_count = getReardCenterCount()
    local function responsePropCompoundCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if self ~= nil and self.roots ~= nil then 
                local count = getReardCenterCount()
                -- 判断有新奖励了.
                if count > self.reaward_center_count and count > 0  then 
                    local centerWindows = fwin:find("AdventureRewardCenterClass")
                    if centerWindows == nil and missionIsOver() == true then 
                        fwin:open(AdventureRewardCenter:new():init(), fwin._ui)

                    end
                end 
            end
        end
    end
    if AdventureDuplicate.__is_first_init == true and missionIsOver() == true then 
        NetworkManager:register(protocol_command.reward_center_init.code, nil, nil, nil, nil, responsePropCompoundCallback, false, nil)
    end
    AdventureDuplicate.__is_first_init = true
end

function AdventureDuplicate:onInit()
	local csbAdventureDuplicate = csb.createNode("duplicate/maoxian.csb")
    local root = csbAdventureDuplicate:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicate)

    self.Button_zhandou = ccui.Helper:seekWidgetByName(root, "Button_zhandou")
    self.Panel_stage_1 = ccui.Helper:seekWidgetByName(root, "Panel_stage_1")
    self.Panel_stage_2 = ccui.Helper:seekWidgetByName(root, "Panel_stage_2")
    self.Panel_stage_3 = ccui.Helper:seekWidgetByName(root, "Panel_stage_3")
    self.Panel_stage_4 = ccui.Helper:seekWidgetByName(root, "Panel_stage_4")
	
	local reward = getSceneReward(2)
	if reward ~= nil then
		app.load("client.adventure.reward.AdventureTipReward")
		fwin:open(AdventureTipReward:new():init(reward), fwin._ui)
		reward = nil
	end
    -- 难度
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_nandu"),       nil, 
    {
        terminal_name = "adventure_duplicate_difficulty",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 地图
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ditu"),       nil, 
    {
        terminal_name = "adventure_duplicate_map_list",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 背包
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_beibao"),       nil, 
    {
        terminal_name = "adventure_duplicate_package",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 战斗
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_zhandou"),       nil, 
    {
        terminal_name = "adventure_duplicate_start_fight",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 队伍强化
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duiwuqianghua"),       nil, 
    {
        terminal_name = "adventure_duplicate_hero_strengthen",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    self.Panel_event = ccui.Helper:seekWidgetByName(root, "Panel_31")
    self.Panel_event:setVisible(false)
    -- 点击冒险事件
    fwin:addTouchEventListener(self.Panel_event,       nil, 
    {
        terminal_name = "adventure_duplicate_click_event",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    -- --定时器获取冒险事件
    -- state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_home_event",
    -- _widget = eventPanel,
    -- _invoke = nil,
    -- _interval = 12,})
    -- eventPanel:setVisible(true)
    -- ccui.Helper:seekWidgetByName(root, "Panel_11"):setVisible(false)
end

function AdventureDuplicate:onInit_map_and_scene()
    -- 挂机数据
    local sceneId = _ED.on_hook_reward_scene
    local npcId = _ED.on_hook_reward_npc
    if sceneId > 0 then
        self:changeMap(sceneId)
    else
        sceneId = _ED.current_attack_scene
        if sceneId > 0 then
            self:changeMap(sceneId)
        else
            self:changeMap(self.selectSceneId)
        end
    end

    if npcId > 0 then
        self:changeScene(self.selectSceneId, npcId)
        self:changeDifficutly(npcId)
    else
        sceneId = _ED.current_attack_scene
        npcId = _ED.current_attack_npc
        if npcId > 0 then
            self:changeScene(sceneId, npcId)
        else
            self:changeScene(self.selectSceneId, self.selectNpcId)
        end
    end
    
    state_machine.excute("adventure_duplicate_map_check_selected", 0, self.selectNpcId)
end

function AdventureDuplicate:onExit()
    state_machine.excute("adventure_push_info_close",0,0)
    state_machine.remove("adventure_duplicate_difficulty")
    state_machine.remove("adventure_duplicate_map_list")
    state_machine.remove("adventure_duplicate_package")
    state_machine.remove("adventure_duplicate_start_fight")
    state_machine.remove("adventure_duplicate_init_copy_controller_status")
    state_machine.remove("adventure_duplicate_hero_strengthen")
    state_machine.remove("adventure_duplicate_change_map")
    state_machine.remove("adventure_duplicate_change_scene")
    state_machine.remove("adventure_duplicate_npc_on_hook")
    state_machine.remove("adventure_duplicate_show_attack_button")
    state_machine.remove("adventure_duplicate_change_duplicate_difficulty")
    state_machine.remove("adventure_duplicate_click_event")
end