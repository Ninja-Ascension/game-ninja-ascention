-----------------------------
-- 山庄主界面
-----------------------------
PersonalFightMain = class("PersonalFightMainClass", Window)

local personal_fight_main_open_terminal = {
	_name = "personal_fight_main_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        if funOpenDrawTipEX(47) == true then
            -- TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], 47, fun_open_condition.tip_info))
            return
        end
        local function respondCallBack( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                fwin:open(PersonalFightMain:new():init(params),fwin._ui)
            end
        end
        NetworkManager:register(protocol_command.user_stronghold_init.code, nil, nil, nil, nil, respondCallBack, false, nil)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local personal_fight_main_close_terminal = {
	_name = "personal_fight_main_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PersonalFightMainClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(personal_fight_main_open_terminal)
state_machine.add(personal_fight_main_close_terminal)
state_machine.init()

function PersonalFightMain:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}
    -- 建筑cell
    self.home_cells = {}
    self._ListView_roleX = 0
    -- 疗伤完成时间显示
    self.Panel_add_bolld = nil
    -- 疗伤剩余时间text
    self.Text_bolld_cd_time = nil
    -- 疗伤剩余时间
    self._tick_time = 0
   
    -- load lua file
    app.load("client.red_alert_time.cells.battle.battle_ui_icon_cell")
    app.load("client.red_alert_time.cells.personal_fight.personal_fight_build_cell")
    app.load("client.red_alert_time.cells.personal_fight.personal_fight_task_cell")
    app.load("client.red_alert_time.personal_fight.PersonalFightAddHp")
    app.load("client.red_alert_time.personal_fight.PersonalFightBattleField")
    app.load("client.red_alert_time.personal_fight.PersonalFightRanking")
    app.load("client.red_alert_time.personal_fight.PersonalFightTask")
    
    app.load("client.utils.ConfirmTip")
    app.load("client.red_alert_time.battle.battle_enum")

    local function init_personal_fight_main_terminal()
        -- 进入江湖
        local personal_fight_main_enter_national_terminal = {
            _name = "personal_fight_main_enter_national",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if fwin:find("NationalWarMapClass") == nil then
                    if funOpenDrawTip(123) == true then
                        return
                    end
                    local function responseholdInit(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if nil ~= fwin:find("DuplicateManagerClass") then
                                state_machine.excute("duplicate_manager_window_close", 0, 0)
                            end
                            state_machine.excute("national_truce_loading_window_open", 0, {_datas = {open_type = 1}})
                        end
                    end
                    local function responseCallback2(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            _ED.personal_defender_battle_report_list = {}
                            for i, data in pairs(_ED.city_resource_battle_report) do
                                if tonumber(data.result) == 0 then
                                    table.insert(_ED.personal_defender_battle_report_list, data)
                                end
                            end
                            -- responseholdInit({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 1})
                            NetworkManager:register(protocol_command.city_resource_hold_init.code, nil, nil, nil, nil, responseholdInit, false, nil)
                        end
                    end
                    local function responseCallback1(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            protocol_command.battlefield_report_get.param_list = battle_enum._fight_type._fight_type_105 + 1000
                            NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, nil, responseCallback2, false, nil)
                        end
                    end
                    protocol_command.user_stronghold_plunder_refresh.param_list = ""
                    NetworkManager:register(protocol_command.user_stronghold_plunder_refresh.code, nil, nil, nil, nil, responseCallback1, false, nil)
                else
                    state_machine.excute("personal_fight_main_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 建筑升级刷新
        local personal_fight_main_update_terminal = {
            _name = "personal_fight_main_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateDrawBuildLevel(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新山庄界面信息
        local personal_fight_main_update_build_terminal = {
            _name = "main_window_update_build",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDrawBuild()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面信息
        local personal_fight_main_update_info_terminal = {
            _name = "personal_fight_main_update_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 疗伤完成时间显示
        local personal_fight_main_update_add_time_hp_terminal = {
            _name = "personal_fight_main_update_add_time_hp",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateAddHpTime()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 清除疗伤时间
        local personal_fight_main_clear_hp_cd_terminal = {
            _name = "personal_fight_main_clear_hp_cd",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local cost = dms.float(dms["user_stronghold_config"], 12, user_stronghold_config.info)
                local time = 0
                local result = ""
                local index = 0
                for k,v in pairs(_ED.user_ship) do
                    if tonumber(v.current_hp) ~= 0 
                        and tonumber(v.current_hp) < tonumber(v.ship_health) 
                        and v.review_time ~= nil
                        and v.review_time > 0
                        then
                        index = index + 1
                        if index == 1 then
                            result = v.ship_base_template_id
                        else
                            result = result.."|"..v.ship_base_template_id
                        end
                        time = time + v.review_time - os.time() - _ED.time_add_or_sub
                    end
                end
                time = instance._tick_time
                instance.result = result
                if math.ceil(time * cost) <= zstring.tonumber(_ED.user_info.user_gold) then
                    local tip = ConfirmTip:new()
                    tip:init(instance, instance.onUpdateSendInfo, string.format(red_alert_all_str[232], time * cost))
                    fwin:open(tip, fwin._ui)
                else
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = string.format(red_alert_all_str[238], zstring.tonumber(time * cost)), 
                        _datas= 
                        {
                        }
                    })
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 领取个人战胜利宝箱
        local personal_fight_task_reward_get_terminal = {
            _name = "personal_fight_task_reward_get",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local task_index = params._datas.task_index
                state_machine.excute("personal_fight_task_window_open", 0, task_index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        -- 刷新个人战胜利宝箱状态
        local personal_fight_task_update_reward_terminal = {
            _name = "personal_fight_update_task_reward",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateTaskReward()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(personal_fight_task_update_reward_terminal)
        state_machine.add(personal_fight_task_reward_get_terminal)
        state_machine.add(personal_fight_main_enter_national_terminal)
        state_machine.add(personal_fight_main_update_terminal)
        state_machine.add(personal_fight_main_update_build_terminal)
        state_machine.add(personal_fight_main_update_info_terminal)
        state_machine.add(personal_fight_main_update_add_time_hp_terminal)
        state_machine.add(personal_fight_main_clear_hp_cd_terminal)
        state_machine.init()
    end
    init_personal_fight_main_terminal()
end
-- 清除疗伤时间二级弹窗
function PersonalFightMain:onUpdateSendInfo( sure_number )
    if sure_number ~= 0 then
        return
    end
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node:updateDraw()
            end
            state_machine.excute("personal_fight_add_hp_update_info", 0, nil)
        end
    end
    protocol_command.user_stronghold_revived.param_list = "1\r\n"..self.result
    NetworkManager:register(protocol_command.user_stronghold_revived.code, nil, nil, nil, self, responseCallback, false, nil)
end
-- 建设升级完成播放动画刷新数据
function PersonalFightMain:updateDrawBuildLevel(build_id)
    state_machine.excute("personal_fight_build_cell_update_level",0,self.home_cells[build_id])
    self:updateDraw(false)
end
-- 疗伤完成时间显示
function PersonalFightMain:updateAddHpTime()
    self._tick_time = 0
    -- 获取疗伤剩余时间
    -- for k,v in pairs(_ED.user_ship) do
    --     if tonumber(v.current_hp) ~= 0 
    --         and tonumber(v.current_hp) < tonumber(v.ship_health)
    --         and v.review_time ~= nil
    --         and v.review_time > 0
    --         then
    --         self._tick_time = self._tick_time + v.review_time - os.time() - _ED.time_add_or_sub
    --     end
    -- end
    if _ED.personal_add_hp_cd_time_end ~= nil then
        self._tick_time = _ED.personal_add_hp_cd_time_end - (os.time() + _ED.time_add_or_sub)
    end
    -- 时间小于0的话隐藏该层
    if self._tick_time > 0 then
        self.Panel_add_bolld:setVisible(true)
    else
        self.Panel_add_bolld:setVisible(false)
    end
end

function PersonalFightMain:onUpdate( dt )
    local current_cd_time = self._tick_time - dt    --疗伤剩余时间
    if self._tick_time <= 0 then                    --没有侠客在疗伤
        self._tick_time = 0
        self.Panel_add_bolld:setVisible(false)
    elseif current_cd_time <= 0 then                --疗伤时间结束
        self._tick_time = 0
        self.Panel_add_bolld:setVisible(false)
        --更新山庄侠客信息
        local function respondCallBack( response )
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:updateFormation()
                end
                state_machine.excute("personal_fight_add_hp_update_info", 0, nil)
            end
        end
        protocol_command.user_stronghold_init.param_list = ""
        NetworkManager:register(protocol_command.user_stronghold_init.code, nil, nil, nil, self, respondCallBack, false, nil)
    else
        self._tick_time = current_cd_time
        self.Text_bolld_cd_time:setString(self:formatTimeString(self._tick_time))
    end
end
-- 时间戳转换
function PersonalFightMain:formatTimeString(_time)
    local timeString = ""
    local now_time = math.max(tonumber(_time), 0)
    timeString = timeString .. string.format("%02d", math.floor(now_time/3600)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor((now_time%3600)/60)) .. ":"
    timeString = timeString .. string.format("%02d", math.floor(now_time%60))
    return timeString
end
-- 如果建筑存在刷新建筑信息
function PersonalFightMain:updateDrawBuild()
    for i = 1,dms.count(dms["build_mould"]) do
        local funopen_id = dms.int(dms["build_mould"],i,build_mould.fun_open_tab_id)
        local open_level = dms.int(dms["fun_open_condition"],funopen_id,fun_open_condition.level)
        if open_level == tonumber(_ED.user_info.user_grade) then
            if self.home_cells[i] ~= nil then
                if self.home_cells[i].updateDraw ~= nil then
                    self.home_cells[i]:updateDraw()
                end
            end
        end
    end
end
-- 绘制山庄界面信息
function PersonalFightMain:updateDraw(isUpdateList)
    local root = self.roots[1]
    local Text_build_name = ccui.Helper:seekWidgetByName(root,"Text_build_name")
    Text_build_name:setString(_ED.user_info.user_name)
    local build_lv = _ED.home_build["19"].level
    local update_id = dms.int(dms["build_mould"],19,build_mould.update_id)
    local info = _ED.build_escalate_info[""..update_id]
    local max_volumn_teams = info[""..build_lv].max_volumn_teams
    max_volumn_teams = zstring.split(max_volumn_teams, ",")
    -- 获取山庄中已积累的资源状态
    for i=1,4 do
        local Text_res_num = ccui.Helper:seekWidgetByName(root,"Text_res_num_"..i)
        Text_res_num:setString("0/"..max_volumn_teams[i])
    end
    local result = {}
    for i=20,26 do
        local build_info = _ED.home_build[""..i]
        -- 获取山庄已积累的资源
        if build_info ~= nil then
            local output_start_time = build_info.output_start_time
            local level = zstring.tonumber(build_info.level)
            local update_id = dms.int(dms["build_mould"], i, build_mould.update_id)
            local escalate_info = _ED.build_escalate_info[""..update_id][""..level]
            local output_count = zstring.tonumber(escalate_info.output_count)
            local output_time = zstring.tonumber(escalate_info.output_time)
            local max_volumn = zstring.tonumber(escalate_info.max_volumn)
            
            local current_count = math.floor((os.time() + _ED.time_add_or_sub - output_start_time)/output_time * output_count)
            if current_count >= max_volumn then
                current_count = max_volumn
            end
            current_count = current_count - zstring.tonumber(build_info.output_deviation)
            if current_count <= 0 then
                current_count = 0
            end

            local temp_type = tonumber(escalate_info.output_type)
            local output_type = temp_type
            if temp_type == 4 then          --侠魂
                output_type = 3
            -- elseif temp_type == 3 then      --元宝
            --     output_type = 4
            else
                output_type = temp_type
            end

            if result[""..output_type] == nil then
                result[""..output_type] = {}
                result[""..output_type].current = 0
                result[""..output_type].max = tonumber(max_volumn_teams[tonumber(output_type)])
            end
            result[""..output_type].current = result[""..output_type].current + current_count
        end
    end

    for k,v in pairs(result) do
        local Text_res_num = ccui.Helper:seekWidgetByName(root,"Text_res_num_"..k)
        Text_res_num:setString(v.current.."/"..v.max)
    end

    -- 显示玩家个人战积分
    Text_score = ccui.Helper:seekWidgetByName(root, "Text_res_num_5")
    Text_score:setString("".._ED.personal_user_score)

    if isUpdateList == false then
    else    -- 添加山庄建筑信息
        self.home_cells = {}
        for i = 1, 8 do
            local panel = ccui.Helper:seekWidgetByName(root, "Panel_res_build_"..i)
            local x = panel:getPositionX() 
            local y = panel:getPositionY() 
            panel:removeAllChildren(true)
            local cell = state_machine.excute("personal_fight_build_cell_create",0,{i,x,y,panel})
            panel:addChild(cell)
            table.insert(self.home_cells, cell)
        end
        self:updateFormation()
        self:updateAddHpTime()
    end

    self:updateTaskReward()
end

-- 刷新个人战胜利宝箱状态
function PersonalFightMain:updateTaskReward()
    local root = self.roots[1]
    local LoadingBar_task = ccui.Helper:seekWidgetByName(root,"LoadingBar_task")
    local Panel_task = ccui.Helper:seekWidgetByName(root,"Panel_task")

    if funOpenDrawTip(123, false) == true then
        Panel_task:setVisible(false)
        return
    else
        Panel_task:setVisible(true)
    end

    local victor_count = -1
    if _ED.user_task_infos["7"] ~= nil then
        for i, data in pairs(_ED.user_task_infos["7"]) do
            local count = zstring.tonumber(data.task_complete_count)
            if count > victor_count then
                victor_count = count
            end
        end
    end

    if victor_count < 0 then        -- 全部已完成
        victor_count = 15
    end
    LoadingBar_task:setPercent(victor_count * 100 / 15)

    for i = 1, 3 do
        local Panel_rew = ccui.Helper:seekWidgetByName(root,"Panel_rew_"..i)
        Panel_rew:removeAllChildren(true)

        local cell = state_machine.excute("personal_player_task_cell_create", 0, {i})
        Panel_rew:addChild(cell)
    end
end

-- 绘制侠客信息
function PersonalFightMain:updateFormation( ... )
    local root = self.roots[1]
    local ListView_role = ccui.Helper:seekWidgetByName(root, "ListView_role")
    ListView_role:removeAllItems()
    local width = 0
    for i=2,6 do
        local ship_id = _ED.formetion[i]
        if tonumber(ship_id) > 0 then
            local ship = _ED.user_ship[""..ship_id]
            if ship ~= nil then
                local v = {shipid = ship.ship_id, lessHp = ship.current_hp, maxHp = ship.ship_health, ship_template_id = ship.ship_template_id, ship_type = ship.ship_type}
                local cell = state_machine.excute("battle_ui_icon_cell",0,{v})
                ListView_role:addChild(cell)
                state_machine.excute("battle_ui_icon_cell_update_hp", 0, {cell = cell, role = nil, shipId = nil, hp = ship.current_hp, maxHp = ship.ship_health})
                width = width + cell:getContentSize().width
            end
        end
    end
    local listViewSize = ListView_role:getContentSize()
    ListView_role:setPositionX(self._ListView_roleX + (listViewSize.width - width) / 2)
end

function PersonalFightMain:onInit()
    local csbItem = csb.createNode(config_csb.palyer_build.palyer_build)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.palyer_build.palyer_build)
    table.insert(self.actions, action)
    action:play("animation0", true)
    csbItem:runAction(action)

    self.Text_bolld_cd_time = ccui.Helper:seekWidgetByName(root,"Text_bolld_cd_time")
    self.Panel_add_bolld = ccui.Helper:seekWidgetByName(root,"Panel_add_bolld")
    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_res_close"), nil, 
    {
        terminal_name = "personal_fight_main_close",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    -- 打开战报
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_battle_field"), nil, 
    {
        terminal_name = "personal_fight_battle_field_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    -- 打开疗伤界面
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_battle_r"), nil, 
    {
        terminal_name = "personal_fight_main_clear_hp_cd",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    -- 进入江湖
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_go_attack"), nil, 
    {
        terminal_name = "personal_fight_main_enter_national",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    -- 清除疗伤时间
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_add_bolld_cd"), nil, 
    {
        terminal_name = "personal_fight_main_clear_hp_cd",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    -- 打开排行榜
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rank"), nil, 
    {
        terminal_name = "personal_fight_ranking_window_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
    },
    nil,0)
    -- 个人宝箱
    for i = 1, 3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Panel_rew_"..i), nil, 
        {
            terminal_name = "personal_fight_task_reward_get",
            terminal_state = 0,
            touch_scale = true,
            touch_scale_xy = 0.95,
            task_index = i,
        },
        nil,0)
    end

    self._ListView_roleX = ccui.Helper:seekWidgetByName(root, "ListView_role"):getPositionX()

    self:updateDraw()
end

function PersonalFightMain:onEnterTransitionFinish()
    
end

function PersonalFightMain:init(params)
	self:onInit()
    return self
end

function PersonalFightMain:onExit()
    state_machine.remove("personal_fight_main_enter_national")
    state_machine.remove("main_window_update_build")
    state_machine.remove("personal_fight_main_update")
    state_machine.remove("personal_fight_main_update_info")
    state_machine.remove("personal_fight_main_update_add_time_hp")
    state_machine.remove("personal_fight_main_clear_hp_cd")
    state_machine.remove("personal_fight_task_reward_get")
    state_machine.remove("personal_fight_update_task_reward")
end