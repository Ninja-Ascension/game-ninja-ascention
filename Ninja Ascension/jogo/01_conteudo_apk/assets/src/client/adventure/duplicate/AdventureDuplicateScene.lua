-- ----------------------------------------------------------------------------------------------------
-- 说明：冒险副本场景
-------------------------------------------------------------------------------------------------------
AdventureDuplicateScene = class("AdventureDuplicateSceneClass", Window)

app.load("client.adventure.duplicate.AdventureDuplicateStrategy")
app.load("client.adventure.duplicate.AdventureDuplicateSceneCDReward")
app.load("client.adventure.duplicate.demo.AdventureDemoScene")
app.load("client.utils.TimeUtil")

function AdventureDuplicateScene:ctor()
    self.super:ctor()
    self.roots = {}

    self.selectSceneId = -1
    self.npcId = -1

    self.interval = 0
    self.search_interval = 0
    self.interval_wait_time = 1
    self.search_interval_wait_time = 1

    self.isRunning = false
    self.needHook = false
    self.attack_wait_time = 0

    fwin:close(fwin:find("AdventureDuplicateSceneClass"))
    
    -- Initialize adventure duplicate scene state machine.
    local function init_adventure_duplicate_scene_terminal() 
        -- 副本攻略
        local adventure_duplicate_scene_strategy_terminal = {
            _name = "adventure_duplicate_scene_strategy",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance = fwin:find("AdventureDuplicateSceneClass")
                fwin:open(AdventureDuplicateStrategy:new():init(instance.selectSceneId), fwin._ui)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 探索上限道具使用刷新
        local adventure_duplicate_box_reward_count_update_terminal = {
            _name = "adventure_duplicate_box_reward_count_update",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawRewardInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        

        local adventure_duplicate_scene_change_update_terminal = {
                _name = "adventure_duplicate_scene_change_update",
                _init = function (terminal)

                end,
                _inited = false,
                _instance = self,
                _state = 0,
                _invoke = function(terminal, instance, params)
                    --debug.print_r(params)
                    self:onUpdateChangeScene(params._datas._sceneId,params._datas._npcId)
                    return true
                end,
                _terminal = nil,
                _terminals = nil
            }
        -- 挂机奖励
        local adventure_duplicate_scene_cd_reward_terminal = {
            _name = "adventure_duplicate_scene_cd_reward",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if funOpenConditionJudge(55) == false then
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 55, fun_open_condition.tip_info))
					return
				end
                instance = fwin:find("AdventureDuplicateSceneClass")
                local npcId = tonumber(""..instance.npcId)
                local rewardCount = zstring.tonumber(_ED.all_npc_reward_count[npcId])
                if rewardCount <= 0 then
                    TipDlg.drawTextDailog(_string_piece_info[378])
                    return false
                end

                fwin:open(AdventureDuplicateSceneCDReward:new():init(instance.selectSceneId, instance.npcId), fwin._ui)

                local function responseDrawOnHookRewardCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            _ED.on_hook_reward_count = 0
                            _ED.all_npc_reward_count[_ED.on_hook_reward_npc] =  _ED.on_hook_reward_count
                            response.node:updateDrawRewardInfo()
                        end
                    end
                end
                protocol_command.draw_on_hook_reward.param_list = "" .. instance.npcId
                NetworkManager:register(protocol_command.draw_on_hook_reward.code, nil, nil, nil, instance, responseDrawOnHookRewardCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_duplicate_scene_change_update_terminal)
        state_machine.add(adventure_duplicate_scene_strategy_terminal)
        state_machine.add(adventure_duplicate_scene_cd_reward_terminal)
        state_machine.add(adventure_duplicate_box_reward_count_update_terminal)
        state_machine.init()
    end
    
    -- call func init adventure duplicate scene state machine.
    init_adventure_duplicate_scene_terminal()
end

function AdventureDuplicateScene:init(window, sceneId, npcId)
    self._rootWindows = window
    self.selectSceneId = sceneId
    self.npcId = npcId
    self.needHook = zstring.tonumber(_ED.all_npc_reward_count[npcId]) < zstring.tonumber(_ED.max_box_reward_count)
	return self
end

function AdventureDuplicateScene:updateSceneAttackCd()
    local root = self.roots[1]
    local LoadingBar_cd = ccui.Helper:seekWidgetByName(root, "LoadingBar_cd")
    local wait_time = self.interval_wait_time -- dms.int(dms["npc"], self.npcId, npc.wait_time)
    local update_interval = (_ED.current_npc_attack_os_time + _ED.current_npc_attack_wait_time) - os.time()
    
    if self.interval <= 0 or update_interval <=0 then
        LoadingBar_cd:setPercent(100)
        self.interval = 0 
        local interval = (_ED.current_npc_attack_os_time + _ED.current_npc_attack_wait_time) - os.time()
        if interval <= 0 then
            -- cd or ∞
            ccui.Helper:seekWidgetByName(root, "Text_cd"):setString("∞")

            state_machine.excute("adventure_duplicate_show_attack_button", 0, 0)
            if self.isRunning == true then
                state_machine.excute("adventure_duplicate_init_copy_controller_status", 0, 0)
            end
        else
            self.interval = 0.01
        end
    else
        self.interval = (_ED.current_npc_attack_os_time + _ED.current_npc_attack_wait_time) - os.time()
        LoadingBar_cd:setPercent(100 - self.interval / wait_time * 100.0)

        local timeTabel = formatTime(self.interval)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_cd"):setString(str)
    end
end

function AdventureDuplicateScene:updateSceneSearchCd()
    local root = self.roots[1]
    local LoadingBar_cd = ccui.Helper:seekWidgetByName(root, "LoadingBar_1")
    local wait_time = self.search_interval_wait_time -- dms.int(dms["npc"], self.npcId, npc.wait_time)
       local interval = (_ED.on_hook_reward_os_time + _ED.on_hook_reward_time) - os.time()
    if interval <= 0 then
        LoadingBar_cd:setPercent(0)
        ccui.Helper:seekWidgetByName(root, "Text_cd_2"):setString("00:00:00")

        state_machine.excute("adventure_duplicate_show_attack_button", 0, 0)
        if self.needHook == true and self.isRunning == true then
            self.needHook = false
            -- CD为0时后台刷新CD
            state_machine.excute("adventure_duplicate_npc_on_hook", 0, {sceneId = self.selectSceneId, npcId = self.npcId})
        end
    else
        self.search_interval = math.max(0, self.search_interval)
        LoadingBar_cd:setPercent(self.search_interval / wait_time * 100.0)

        local timeTabel = formatTime(self.search_interval)
        local str = timeTabel.hour
        str = str .. string.format(":%02d", timeTabel.minute)
        str = str .. string.format(":%02d", timeTabel.second)

        ccui.Helper:seekWidgetByName(root, "Text_cd_2"):setString(str)
        if self.search_interval <= 0 then
            self.search_interval = 1
        end
    end
end

function AdventureDuplicateScene:onUpdate(dt)
    -- 更新关卡开启的CD
    if self.interval > 0 then
        -- local interval = self.interval - dt -- (_ED.current_npc_attack_os_time + _ED.current_npc_attack_wait_time) - os.time()
        -- if self.interval ~= interval then
        --     self.interval = interval
        --     self:updateSceneAttackCd()
        -- end
        self.interval = self.interval - dt
        self:updateSceneAttackCd()
    end

    -- 更新探索的CD
    if self.search_interval > 0 then
        -- local interval = self.search_interval - dt -- (_ED.on_hook_reward_os_time + _ED.on_hook_reward_time) - os.time()
        -- if self.search_interval ~= interval then
        --     self.search_interval = interval
        --     self:updateSceneSearchCd()
        -- end

        self.search_interval = self.search_interval - dt
        self:updateSceneSearchCd()
    end
end

function AdventureDuplicateScene:updateDrawRewardInfo()
    local root = self.roots[1]
    
    local npcId = tonumber(""..self.npcId)

    self.search_interval_wait_time = dms.int(dms["npc"], self.npcId, npc.wait_time)

    -- 绘制探索的数量信息
    ccui.Helper:seekWidgetByName(root, "Text_jd"):setString("" .. _ED.all_npc_reward_count[npcId] .."/".._ED.max_box_reward_count)
    -- 绘制探索的CD信息
    -- self.search_interval = (_ED.on_hook_reward_os_time + _ED.on_hook_reward_time) - os.time()
    _ED.on_hook_reward_time = zstring.tonumber(_ED.all_npc_on_hook_time[npcId])
    self.search_interval = (_ED.on_hook_reward_os_time + _ED.on_hook_reward_time) - os.time()
    self:updateSceneSearchCd()
end

function AdventureDuplicateScene:onEnterTransitionFinish()
	local csbAdventureDuplicateScene = csb.createNode("duplicate/maoxian_donghua.csb")
    local root = csbAdventureDuplicateScene:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbAdventureDuplicateScene)

    -- 最佳掉落
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_diaoluo"),       nil, 
    {
        terminal_name = "adventure_duplicate_best_drop_reward",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    
    -- 副本攻略
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_gongnue"),       nil, 
    {
        terminal_name = "adventure_duplicate_scene_strategy",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 挂机奖励
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_search"),       nil, 
    {
        terminal_name = "adventure_duplicate_scene_cd_reward",         
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_adventure_home_changenpcid",0,self.npcId)
	state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_adventure_home_adventure",
     _widget = ccui.Helper:seekWidgetByName(root, "Button_search"),
     _invoke = nil,
	 _npcId = self.npcId,
     terminal_state = 0, 
     _interval = 0.5,})

    -- 绘制副本信息
    -- 1-1
    local cinfo = "" .. self.selectSceneId .. "-" --  ..self.npcId
    local npcs = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.npcs)
    local lists = zstring.split(npcs, "|")
    for i, v in pairs(lists) do
        if v ~= "" then
            local list = zstring.split(v, ",")
            for m, n in pairs(list) do
                if n == ""..self.npcId then
                    cinfo = cinfo .. m
                    break
                end
            end
        end
    end
    self:onUpdateInfo(self.selectSceneId,self.npcId)

    -- 绘制场景中探索的动画
    local demoAnimPanel = ccui.Helper:seekWidgetByName(root, "Panel_donghua")

    demoAnimPanel:addChild(AdventureDemoScene:createCell():init(self.selectSceneId, self.npcId))

    self.isRunning = true
end

function AdventureDuplicateScene:onUpdateInfo()
    local root = self.roots[1]   
    -- 绘制副本信息
    -- 1-1
    local cinfo = "" .. self.selectSceneId .. "-" --  ..self.npcId
    local npcs = dms.string(dms["pve_scene"], self.selectSceneId, pve_scene.npcs)
    local lists = zstring.split(npcs, "|")
    for i, v in pairs(lists) do
        if v ~= "" then
            local list = zstring.split(v, ",")
            for m, n in pairs(list) do
                if n == ""..self.npcId then
                    cinfo = cinfo .. m
                    break
                end
            end
        end
    end
    ccui.Helper:seekWidgetByName(root, "Text_guanka"):setString(cinfo)

    -- _ED.current_attack_scene = npos(list)
    -- _ED.current_attack_npc = npos(list)
    -- _ED.current_npc_attack_wait_time = npos(list)
    -- _ED.current_npc_attack_os_time = os.time()

    -- 关卡名称
    local npcSign = dms.string(dms["npc"], self.npcId, npc.sign_msg)
    ccui.Helper:seekWidgetByName(root, "Text_description"):setString(npcSign)

    -- 绘制攻击CD进度条
    -- self.interval = (_ED.current_npc_attack_os_time + _ED.current_npc_attack_wait_time) - os.time()
    local npcId = tonumber(""..self.npcId)
    self.interval_wait_time = dms.int(dms["npc"], self.npcId, npc.wait_time)
    _ED.current_npc_attack_wait_time = zstring.tonumber(_ED.all_npc_battle_wait_time[npcId])
    --print(" 攻击时间,等待时间",_ED.current_npc_attack_os_time,_ED.current_npc_attack_wait_time)
    self.interval = (_ED.current_npc_attack_os_time + _ED.current_npc_attack_wait_time) - os.time()
    self.attack_wait_time = _ED.current_npc_attack_wait_time
   -- print("最后等待时间:",self.interval)
    self.interval = self.attack_wait_time
    self:updateSceneAttackCd()

    -- 绘制攻略数量
    ccui.Helper:seekWidgetByName(root, "Text_4"):setString("0")

    -- 绘制探索信息
    self:updateDrawRewardInfo()

    self.isRunning = true
end

function AdventureDuplicateScene:onExit()
    state_machine.remove("adventure_duplicate_scene_strategy")
    state_machine.remove("adventure_duplicate_scene_cd_reward")
    state_machine.remove("adventure_duplicate_scene_battle_request_dlg")
end

function AdventureDuplicateScene:onUpdateChangeScene(sceneId, npcId)
    self.selectSceneId = sceneId
    self.npcId = npcId
    state_machine.excute("push_notification_center_adventure_home_changenpcid",0,npcId)

    self.needHook = zstring.tonumber(_ED.all_npc_reward_count[npcId]) < zstring.tonumber(_ED.max_box_reward_count)
    self.isRunning = true
    self:onUpdateInfo()
end