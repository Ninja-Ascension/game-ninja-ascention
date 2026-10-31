-- ------------------------------------------------------------------------------------------------------------
--  说明：配件补给
-- ------------------------------------------------------------------------------------------------------------
PvePartsSupplyTab = class("PvePartsSupplyTabClass", Window)

--打开界面
local pve_parts_supply_tab_open_terminal = {
	_name = "pve_parts_supply_tab_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local panel = PvePartsSupplyTab:new():init(params)
        fwin:open(panel, fwin._ui)
        return panel
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local pve_parts_supply_tab_close_terminal = {
	_name = "pve_parts_supply_tab_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        fwin:close(fwin:find("PvePartsSupplyTabClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(pve_parts_supply_tab_open_terminal)
state_machine.add(pve_parts_supply_tab_close_terminal)
state_machine.init()

function PvePartsSupplyTab:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self.listview = nil
    self.listview_poy = 0
    self.listview_height = 0
    self._Image_player_build_arrow_down = nil
    self._Image_player_build_arrow_up = nil

    self._need_refresh_list = false

    self._attck_index = nil
    self._sweep_index = 0
    self._sweep_name = ""
    self.m_times = 0

	app.load("client.red_alert_time.cells.pve.pve_gain_cell")
    app.load("client.red_alert_time.cells.pve.pve_parts_supply_sweep_cell")
    app.load("client.red_alert_time.pve.PvePartsSupplyInfor")
    app.load("client.red_alert_time.pve.PvePartsSupplyReset")
    app.load("client.red_alert_time.pve.PvePartsSupplySweep")
    app.load("client.red_alert_time.activity.treasurehouse.RedAlertTimeRuleInfor")

    app.load("client.red_alert_time.player.PlayerEnergyAdd")

    local function init_pve_parts_supply_tab_terminal()
        local pve_parts_supply_tab_show_terminal = {
            _name = "pve_parts_supply_tab_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:setVisible(true)
                instance:refreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_parts_supply_tab_hide_terminal = {
            _name = "pve_parts_supply_tab_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新界面
        local pve_parts_supply_tab_update_draw_terminal = {
            _name = "pve_parts_supply_tab_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                _ED._is_update_parts_supply = true
                local posY = instance.listview_poy
                instance:updateDraw()
                if math.abs(posY) > math.abs(instance.listview_height) then
                    posY = instance.listview_height
                end
                instance.listview:getInnerContainer():setPositionY(posY)   
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 扫荡
        local pve_parts_supply_tab_sweep_terminal = {
            _name = "pve_parts_supply_tab_sweep",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(_ED.vip_grade) < 4 then
                    TipDlg.drawTextDailog(red_alert_time_str[111])
                    return
                end
                if instance._sweep_index <= 0 then
                    TipDlg.drawTextDailog(sweep_tip_text[7])
                    return
                end
                if tonumber(_ED.parts_supply_remakes_times) == 0 and tonumber(_ED.user_info.user_food) <= 0 then
                    state_machine.excute("player_energy_add_open", 0, "")
                    return
                end

                local sweep_name = instance._sweep_name
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            state_machine.excute("pve_parts_supply_tab_update_draw", 0, nil)
                        end
                        state_machine.excute("pve_parts_supply_sweep_window_open", 0, {sweep_name})
                        state_machine.excute("notification_center_update", 0, "push_notification_home_button_pve")
                        state_machine.excute("notification_center_update", 0, "push_notification_pve_parts_supply")
                        --debug.print_r(_ED.show_reward_list_group_ex)
                        -- checkRewardObtainDraw()
                    end
                end
                protocol_command.elit_sweep.param_list = ""
                NetworkManager:register(protocol_command.elit_sweep.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重置
        local pve_parts_supply_tab_checkpoint_reset_terminal = {
            _name = "pve_parts_supply_tab_checkpoint_reset",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)  
                instance._attck_index = nil
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_parts_supply_tab_attck_index_terminal = {
            _name = "pve_parts_supply_tab_attck_index",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance._attck_index = params
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_parts_supply_tab_complete_chapter_terminal = {
            _name = "pve_parts_supply_tab_complete_chapter",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:checkCompleteChapter()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_parts_supply_tab_act_rule_terminal = {
            _name = "pve_parts_supply_tab_act_rule",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                state_machine.excute("red_alert_time_rule_infor_window_open",0,"65")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        local pve_parts_supply_tab_activity_end_updata_terminal = {
            _name = "pve_parts_supply_tab_activity_end_updata",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(pve_parts_supply_tab_activity_end_updata_terminal)
        state_machine.add(pve_parts_supply_tab_show_terminal)
        state_machine.add(pve_parts_supply_tab_hide_terminal)
        state_machine.add(pve_parts_supply_tab_update_draw_terminal)
        state_machine.add(pve_parts_supply_tab_sweep_terminal)
        state_machine.add(pve_parts_supply_tab_checkpoint_reset_terminal)
        state_machine.add(pve_parts_supply_tab_attck_index_terminal)
        state_machine.add(pve_parts_supply_tab_complete_chapter_terminal)
        state_machine.add(pve_parts_supply_tab_act_rule_terminal)
        state_machine.init()
    end
    
    init_pve_parts_supply_tab_terminal()
end

function PvePartsSupplyTab:checkCompleteChapter()
    local root = self.roots[1]
    if self._attck_index ~= nil then
        local items = self.listview:getItems()
        local cell = items[self._attck_index]
        if cell ~= nil then
            state_machine.excute("pve_parts_supply_unlock_cell_play_complete_effect", 0, cell)
        end
        self._attck_index = nil
    end
end

-- 重置
function PvePartsSupplyTab:sureCheckpointReset(sure_number)
    if self.roots == nil then
        return
    end
    local root = self.roots[1]
    if root == nil then
        return
    end
    local function responseCallback(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                response.node._attck_index = nil
                state_machine.excute("pve_parts_supply_tab_update_draw", 0, nil)
            end
        end
    end
    if sure_number == 0 then
        protocol_command.reset_elit_copy.param_list = ""
        NetworkManager:register(protocol_command.reset_elit_copy.code, nil, nil, nil, self, responseCallback, false, nil)
    end
end

function PvePartsSupplyTab:refreshListView( ... )
    local root = self.roots[1]
    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_pve_parts")
    ListView:jumpToTop()
    ListView:getInnerContainer():setPositionY(ListView:getInnerContainer():getPositionY() - 1)
    ListView:requestRefreshView()
end

function PvePartsSupplyTab:updateDraw()
    local root = self.roots[1]
    local Button_pve_parts_supply_act = ccui.Helper:seekWidgetByName(root, "Button_pve_parts_supply_act")
    Button_pve_parts_supply_act:setVisible(false)
    if _ED.activity_info["65"] ~= nil then
        Button_pve_parts_supply_act:setVisible(true)
    end
    -- 今日剩余重置次数
    self._sweep_index = 0
    self._sweep_name = ""

    --计算火线支援活动加层
    local activity_add = 0
    if _ED.activity_info["91"] ~= nil then
        local timesData = zstring.split(_ED.activity_info["91"].activity_add_state, ",")
        self.m_times = ((tonumber(timesData[2])/1000-1)-(tonumber(_ED.system_time)+(os.time()-tonumber(_ED.native_time))))
        if self.m_times > 0 then
            activity_add = timesData[3]
        end
    end

    local Text_checkpoint_reset_n = ccui.Helper:seekWidgetByName(root, "Text_checkpoint_reset_n")
    local total_times = dms.int(dms["base_consume"], 22, base_consume.vip_0_value + tonumber(_ED.vip_grade)) + activity_add
    local have_remakes_times = total_times - _ED.parts_supply_remakes_times
    have_remakes_times = math.max(have_remakes_times,0)
    Text_checkpoint_reset_n:setString(have_remakes_times)
    local Button_parts_checkpoint_reset = ccui.Helper:seekWidgetByName(root, "Button_parts_checkpoint_reset")
    Button_parts_checkpoint_reset:setBright(true)
    Button_parts_checkpoint_reset:setTouchEnabled(true)
    if have_remakes_times <= 0 then
        Button_parts_checkpoint_reset:setBright(false)
        Button_parts_checkpoint_reset:setTouchEnabled(false)
    end

    -- 扫荡
    local Button_parts_sweep = ccui.Helper:seekWidgetByName(root, "Button_parts_sweep")
    Button_parts_sweep:setBright(true)
    if tonumber(_ED.vip_grade) < 4 then
        Button_parts_sweep:setBright(false)
    end

    local ListView = ccui.Helper:seekWidgetByName(root, "ListView_pve_parts")
    ListView:jumpToTop()
    ListView:removeAllItems()

    local count = 0
    for k,v in pairs(_ED.scene_current_state) do
        local _scene_type = dms.int(dms["pve_scene"], k, pve_scene.scene_type) 
        if _scene_type == battle_enum._fight_type._fight_type_1 then
            count = count + 1
            local open_level = dms.int(dms["pve_scene"], k, pve_scene.open_level) 
            if tonumber(_ED.user_info.user_grade) >= open_level then
                local cell = state_machine.excute("pve_parts_supply_unlock_create_cell", 0, {count, k, v, 1})
                ListView:addChild(cell)

                local npc_id = dms.int(dms["pve_scene"], k, pve_scene.npcs) 
                local max_times = dms.int(dms["npc"],npc_id,npc.daily_attack_count)
                local scene_name = dms.string(dms["pve_scene"], k, pve_scene.scene_name) 
                local attack_times = _ED.npc_current_attack_count[tonumber(""..npc_id)]
                local times = max_times - attack_times
                local npc_state = zstring.tonumber(_ED.npc_state[tonumber(""..npc_id)])
                if tonumber(v) >= 0 and times > 0 then
                    if zstring.tonumber(_ED.npc_state[tonumber(""..npc_id)]) >= zstring.tonumber(_ED.npc_max_state[tonumber(""..npc_id)]) 
                        and npc_state == 3
                        then
                        self._sweep_index = self._sweep_index + 1
                        if self._sweep_index == 1 then
                            self._sweep_name = scene_name
                        else
                            self._sweep_name = self._sweep_name ..","..scene_name
                        end
                    end
                end
            else
                local cell = state_machine.excute("pve_parts_supply_lock_create_cell", 0, {count, k, v, 1})
                ListView:addChild(cell)
            end
        end
    end

    ListView:requestRefreshView()
    self.listview = ListView
    self.listview_poy = ListView:getInnerContainer():getPositionY()
    self.listview_height = ListView:getInnerContainer():getPositionY()
    self._need_refresh_list = true
end

function PvePartsSupplyTab:onUpdate(dt)
    if self.m_times > 0 then
        self.m_times = self.m_times - dt
        if self.m_times <= 0 then
            self.m_times = 0
            state_machine.excute("pve_parts_supply_tab_activity_end_updata",0,"")
        end
    end
    if self.listview ~= nil then
        if self._need_refresh_list == true then
            self._need_refresh_list = false
            return
        end

        local size = self.listview:getContentSize()
        local posY = self.listview:getInnerContainer():getPositionY()
        if self.listview_height == 0 then
            self.listview_height = posY
        end
        if self.listview_poy <= -30 then
            self._Image_player_build_arrow_down:setVisible(true)
        else
            self._Image_player_build_arrow_down:setVisible(false)
        end
        if self.listview_poy >= self.listview_height + 30 then
            self._Image_player_build_arrow_up:setVisible(true)
        else
            self._Image_player_build_arrow_up:setVisible(false)
        end
        if self.listview_poy == posY then
            return
        end
        self.listview_poy = posY
        local items = self.listview:getItems()
        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempY = v:getPositionY() + posY
            if tempY + itemSize.height * 2 < 0 or tempY > size.height + itemSize.height * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

--初始化
function PvePartsSupplyTab:onInit()
    local csbItem = csb.createNode(config_csb.pve.pve_parts_supply_tab)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_sweep"), nil, 
    {
        terminal_name = "pve_parts_supply_tab_sweep",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_parts_checkpoint_reset"), nil, 
    {
        terminal_name = "pve_parts_supply_reset_open",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_parts_prompt"), nil, 
    {
        terminal_name = "pve_parts_supply_infor_window_open",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    -- 活动规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_pve_parts_supply_act"), nil, 
    {
        terminal_name = "pve_parts_supply_tab_act_rule",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)

    self._Image_player_build_arrow_down = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_down")
    self._Image_player_build_arrow_up = ccui.Helper:seekWidgetByName(root, "Image_production_arrow_up")
    
    local function playActions(sender)
        if sender ~= nil and sender:getParent() ~= nil then
            local fadeOut = cc.FadeOut:create(0.5)
            local fadeIn = cc.FadeIn:create(0.5)
            sender:runAction(cc.Sequence:create(fadeOut, fadeIn, cc.CallFunc:create(playActions)))
        end
    end
    self._Image_player_build_arrow_down:stopAllActions()
    self._Image_player_build_arrow_up:stopAllActions()
    playActions(self._Image_player_build_arrow_down)
    playActions(self._Image_player_build_arrow_up)
    self._Image_player_build_arrow_down:setVisible(false)
    self._Image_player_build_arrow_up:setVisible(false)

    self:updateDraw()
end

function PvePartsSupplyTab:onEnterTransitionFinish()

end

function PvePartsSupplyTab:init(param)
    self._rootWindows = param[1]
	self:onInit()
    return self
end

function PvePartsSupplyTab:onExit()
    state_machine.remove("pve_parts_supply_tab_show")
    state_machine.remove("pve_parts_supply_tab_hide")
    state_machine.remove("pve_parts_supply_tab_update_draw")
    state_machine.remove("pve_parts_supply_tab_sweep")
    state_machine.remove("pve_parts_supply_tab_checkpoint_reset")
    state_machine.remove("pve_parts_supply_tab_attck_index")
    state_machine.remove("pve_parts_supply_tab_complete_chapter")
    state_machine.remove("pve_parts_supply_tab_act_rule")
    state_machine.remove("pve_parts_supply_tab_activity_end_updata")
end