-----------------------------
--试炼VIP扫荡
-----------------------------
SmTrialTowerSweep = class("SmTrialTowerSweepClass", Window)

local sm_trial_tower_sweep_window_open_terminal = {
    _name = "sm_trial_tower_sweep_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        state_machine.excute("sm_trial_tower_vip_skip_tip_close", 0, nil)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("SmTrialTowerSweepClass") == nil then
                    fwin:open(SmTrialTowerSweep:new():init(response.reqeest), fwin._ui)
                end
            end
        end
        if tonumber(_ED.three_kings_vip_sweep_state) == 0 then
            local jumpFloor = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade)) + 1
            local addition_data = zstring.split(dms.string(dms["play_config"], 32, play_config.param),"|")
            local addition_info = 1
            for i,v in pairs(addition_data) do
                local addition = zstring.split(v,",")
                if tonumber(_ED.vip_grade) >= tonumber(addition[1]) then
                    addition_info = 1+tonumber(addition[2])/100
                end
            end
            local integral_Interval = zstring.split(dms.string(dms["play_config"], 23, play_config.param), "!")
            local intervalData = nil
            for i, v in pairs(integral_Interval) do
                local datas = zstring.split(v, "|")
                local levels = zstring.split(datas[1], ",")
                if tonumber(_ED.user_info.user_grade) <= tonumber(levels[2]) then
                    intervalData = datas
                    break
                end
            end
            local interval_info = zstring.split(intervalData[2], ",")
            local tolerance = zstring.split(intervalData[3], ",")
            local Magnification = zstring.split(dms.string(dms["play_config"], 25, play_config.param), ",")

            local totalScore = 0
            local totalStar = 0
            local index = -1
            for i = 1, dms.count(dms["three_kingdoms_config"]) do
                if i < jumpFloor then
                    local npcInfo = dms.string(dms["three_kingdoms_config"], i, three_kingdoms_config.npc_id)
                    if zstring.tonumber(npcInfo) == -1 then
                    else
                        index = index + 1
                        totalStar = totalStar + 3 * 5
                        totalScore = totalScore + math.floor((tonumber(interval_info[3]) + tonumber(tolerance[3]) * index) * addition_info * tonumber(Magnification[3]))
                    end
                end
            end
            protocol_command.three_kingdoms_sweep.param_list = "0\r\n"..totalStar.."\r\n"..totalScore.."\r\n"..jumpFloor.."\r\n0\r\n\r\n0"
            NetworkManager:register(protocol_command.three_kingdoms_sweep.code, nil, nil, nil, nil, responseCallback, false, nil)
        else
            responseCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, reqeest = false})
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local sm_trial_tower_sweep_window_close_terminal = {
    _name = "sm_trial_tower_sweep_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        function responseGetServerListCallback( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                
            end     
        end

        --如果数据没有说明全部满血
        if _ED.user_try_ship_infos == nil or _ED.user_try_ship_infos == "" or table.nums(_ED.user_try_ship_infos) <= 0 then
            _ED.user_try_ship_infos = {}
        end
        for i, v in pairs(_ED.user_ship) do
            local ships = {}
            ships.newHp = v.ship_health
            ships.maxHp = 100                   --血量的百分比
            ships.newanger = 1000
            ships.id = v.ship_id
            if _ED.user_try_ship_infos[""..v.ship_id] == nil then
                _ED.user_try_ship_infos[""..v.ship_id] = ships
            -- else
            --     _ED.user_try_ship_infos[v.ship_id].newHp = tonumber(_ED.user_ship[""..v.ship_id].ship_health)*(tonumber(_ED.user_try_ship_infos[v.ship_id].maxHp)/100)
            end
        end
        --vip跳过之后怒气值是满的，需要传送给服务器进行保存
        local strs = ""
        for j, w in pairs(_ED.user_try_ship_infos) do
            if strs ~= "" then
                strs = strs.."|"..w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
            else
                strs = w.id..":"..w.newHp..","..w.newanger..","..(zstring.tonumber(w.newHp)/zstring.tonumber(_ED.user_ship[""..w.id].ship_health)*100)
            end
        end
        protocol_command.three_kingdoms_sweep.param_list = "1\r\n0\r\n0\r\n0\r\n0\r\n" .. strs .. "\r\n0"
        NetworkManager:register(protocol_command.three_kingdoms_sweep.code, nil, nil, nil, nil, responseGetServerListCallback, false, nil)
        _ED.integral_current_index = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade)) + 1
        state_machine.excute("sm_trial_tower_update_all_info", 0, nil)
        state_machine.excute("sm_trial_tower_skip_tip_close", 0, nil)
        fwin:close(fwin:find("SmTrialTowerSweepClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_trial_tower_sweep_window_open_terminal)
state_machine.add(sm_trial_tower_sweep_window_close_terminal)
state_machine.init()

function SmTrialTowerSweep:ctor()
    self.super:ctor()
    self.roots = {}

    self.base_info = {}
    self._isRequest = false

    local function init_sm_trial_tower_sweep_terminal()
        local sm_trial_tower_sweep_update_terminal = {
            _name = "sm_trial_tower_sweep_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    if zstring.tonumber(params) == 1 then
                        instance._isRequest = false
                    end
                    instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_trial_tower_sweep_update_terminal)
        state_machine.init()
    end
    init_sm_trial_tower_sweep_terminal()
end

function SmTrialTowerSweep:formatSweepConfigInfo( ... )
    local buffInfo = {}
    local boxInfo = {}
    local jumpFloor = dms.int(dms["base_consume"], 66, base_consume.vip_0_value + tonumber(_ED.vip_grade))
    for i = 1, dms.count(dms["three_kingdoms_config"]) do
        if i <= jumpFloor then
            local npcInfo = dms.string(dms["three_kingdoms_config"], i, three_kingdoms_config.npc_id)
            local rewardInfo = dms.string(dms["three_kingdoms_config"], i, three_kingdoms_config.reward_id)
            if zstring.tonumber(npcInfo) == -1 then
                if zstring.tonumber(rewardInfo) == -1 then
                    table.insert(buffInfo, {floor = i})
                else
                    table.insert(boxInfo, {floor = i})
                end
            end
        end
    end
    self.base_info = {buffInfo, boxInfo}
end

function SmTrialTowerSweep:onUpdateDraw()
    local root = self.roots[1]
    local Panel_tab = ccui.Helper:seekWidgetByName(root, "Panel_tab")
    Panel_tab:removeAllChildren(true)
    state_machine.excute("sm_trial_tower_sweep_info_window_open", 0, {Panel_tab, self.base_info, self._isRequest})
end

function SmTrialTowerSweep:onEnterTransitionFinish()

end

function SmTrialTowerSweep:onInit( )
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_rweep.csb")
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)

    self:formatSweepConfigInfo()

    self:onUpdateDraw()
end

function SmTrialTowerSweep:init(params)
    self._isRequest = params
    if self._isRequest ~= false then
        self._isRequest = true
    end
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.TrialTowerBuyBuff)
    if fun_is_open == true then
        _ED.smTrialTower_autoFlag = true
    end
    self:onInit(params)
    return self
end

function SmTrialTowerSweep:onExit()
    state_machine.remove("sm_trial_tower_sweep_update")
end
