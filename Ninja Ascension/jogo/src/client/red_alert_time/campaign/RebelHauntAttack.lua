-----------------------------
--叛军出没--攻击
-----------------------------
RebelHauntAttack = class("RebelHauntAttackClass", Window)

local rebel_haunt_attack_open_terminal = {
    _name = "rebel_haunt_attack_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local _Window = fwin:find("RebelHauntAttackClass")
        if nil == _Window then
            fwin:open(RebelHauntAttack:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_haunt_attack_close_terminal = {
    _name = "rebel_haunt_attack_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebelHauntAttackClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_haunt_attack_open_terminal)
state_machine.add(rebel_haunt_attack_close_terminal)
state_machine.init()

function RebelHauntAttack:ctor()
    self.super:ctor()
    self.roots = {}
    
    self._cell = nil
    self._info = nil

    self._text_time = nil
    self._leave_time = 0

    app.load("client.red_alert_time.worldMap.redAlertTimeMineReconnaissance")

    local function init_rebel_haunt_attack_terminal()
        local rebel_haunt_attack_fight_terminal = {
            _name = "rebel_haunt_attack_fight",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- _ED._battle_init_type = battle_enum._fight_type._fight_type_203
                -- _ED._current_scene_id = 0
                -- _ED._scene_npc_id = 0
                -- _ED._npc_difficulty_index = instance._info._mould_id
                -- state_machine.excute("formation_window_open", 0, {_datas = {form_type = 7}})
                if __lua_project_id == __lua_project_pacific_rim then
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance._cell.info ,playersOrmine = 0, attack_type = 203,
                        next_terminal = "formation_defend_add_investigate_formation_info", next_terminal_params = {instance._cell, false}}})
                else
                    state_machine.excute("formation_window_open", 0, {_datas = {form_type = 2, attack_cell = instance._cell.info ,playersOrmine = 0, attack_type = 203}})
                end
				state_machine.excute("rebel_haunt_attack_close", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local rebel_haunt_attack_look_info_terminal = {
            _name = "rebel_haunt_attack_look_info",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local cells = instance._cell
                if instance._leave_time > 0 then
                    state_machine.excute("red_alert_time_mine_reconnaissance_investigate", 0, {cells, 0})
                else
                    state_machine.excute("red_alert_time_mine_reconnaissance_open",0,{_datas = {cells = cells ,m_type = 3}})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 打开分享
        local rebel_haunt_attack_open_share_terminal = {
            _name = "rebel_haunt_attack_open_share",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(true)
                Panel_share_close:setVisible(true)
                Animations_PlayOpenMainUI({Panel_share}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_SLIDE_DOWN, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 关闭分享
        local rebel_haunt_attack_close_share_terminal = {
            _name = "rebel_haunt_attack_close_share",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local root = instance.roots[1]
                local Panel_share = ccui.Helper:seekWidgetByName(root, "Panel_share")
                local Panel_share_close = ccui.Helper:seekWidgetByName(root, "Panel_share_close")
                Panel_share:setVisible(false)
                Panel_share_close:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        -- 分享到军团
        local rebel_haunt_attack_share_legion_terminal = {
            _name = "rebel_haunt_attack_share_legion",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if _ED.union.union_info == nil 
                    or _ED.union.union_info == {} 
                    or _ED.union.union_info.union_id == nil 
                    or _ED.union.union_info.union_id == "" 
                    or tonumber(_ED.union.union_info.union_id) == 0 
                    then
                    state_machine.excute("rebel_haunt_attack_close_share", 0, 0)            
                    TipDlg.drawTextDailog(game_share_tip_text[2])
                    return
                end
                if funOpenDrawTip(237) == true then
                    state_machine.excute("rebel_haunt_attack_close_share", 0, 0)     
                    return
                end 
                local function responseSendMessageCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then
                            state_machine.excute("rebel_haunt_attack_close_share", 0, 0)
                            TipDlg.drawTextDailog(game_share_tip_text[1])
                        end 
                    end
                end

                local npcId = dms.int(dms["rebel_haunt_mould"], instance._cell.info._mould_id, rebel_haunt_mould.npc_mould_id)
                local quality = dms.int(dms["rebel_haunt_mould"], instance._cell.info._mould_id, rebel_haunt_mould.nType) + 1
                local npcName = dms.string(dms["npc"], npcId, npc.npc_name)
                local level = _ED.world_level
                local datas = dms.string(dms["message_share"], 1, message_share.content)
                local mine_info = npcName..string.format(red_alert_all_str[13], ""..level).."["..instance._cell.info._x..","..instance._cell.info._y.."]"
                mine_info = "|"..quality.."|"..mine_info
                local data1 =  string.gsub(datas, "!x@", mine_info)
                datas = data1
                -- local paramsInfo = "|"..quality.."|"..mine_info
                local paramsInfo = "4-1-"..instance._cell.info._mould_id.."-".._ED.world_level.."-"..instance._cell.info._x.."-"..instance._cell.info._y..","..mine_info
                local str = chat_section[1]..dms.string(dms["message_share"], 1, message_share.jump_type).."|"..instance._cell.info._x..","..instance._cell.info._y
                str = zstring.exchangeTo(str)
                protocol_command.send_message.param_list = str.."\r\n".."14".. "\r\n0\r\n1\r\n" .. paramsInfo
                -- NetworkManager:register(protocol_command.send_message.code, nil, nil, nil, self, responseSendMessageCallback, false, nil)
                NetworkAdaptor.socketSend(NetworkProtocol.command_func(protocol_command.send_message.code))
                responseSendMessageCallback({node=instance, RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(rebel_haunt_attack_fight_terminal)
        state_machine.add(rebel_haunt_attack_look_info_terminal)
        state_machine.add(rebel_haunt_attack_open_share_terminal)
        state_machine.add(rebel_haunt_attack_close_share_terminal)
        state_machine.add(rebel_haunt_attack_share_legion_terminal)
        state_machine.init()
    end
    init_rebel_haunt_attack_terminal()
end

function RebelHauntAttack:onUpdateDraw( ... )
    local root = self.roots[1]
    local Panel_build_icon = ccui.Helper:seekWidgetByName(root,"Panel_build_icon")
    local Panel_tank_icon = ccui.Helper:seekWidgetByName(root,"Panel_tank_icon")
    local Text_rebel_haunt_attack_xy_n = ccui.Helper:seekWidgetByName(root,"Text_rebel_haunt_attack_xy_n")
    local Text_rec_fight_n = ccui.Helper:seekWidgetByName(root,"Text_rec_fight_n")
    local Text_arr_time_n = ccui.Helper:seekWidgetByName(root,"Text_arr_time_n")
    local Text_rebel_haunt_attack_name_lv = ccui.Helper:seekWidgetByName(root,"Text_rebel_haunt_attack_name_lv")

    local npc_id = dms.int(dms["rebel_haunt_mould"], self._info._mould_id, rebel_haunt_mould.npc_mould_id)
    local name = dms.string(dms["npc"], npc_id, npc.npc_name)
    local head_pic = zstring.split(dms.string(dms["npc"], npc_id, npc.head_pic), ",")

    Panel_build_icon:removeBackGroundImage()
    Panel_tank_icon:removeBackGroundImage()
    Panel_build_icon:setBackGroundImage(string.format(config_res.images.ui.home.home_build, head_pic[1]))
    Panel_tank_icon:setBackGroundImage(string.format(config_res.images.ui.props.tank, head_pic[2]))

    Text_rebel_haunt_attack_name_lv:setString(name)
    Text_rebel_haunt_attack_name_lv:setColor(cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3]))

    Text_rebel_haunt_attack_xy_n:setString("("..self._info._x..","..self._info._y..")")
    local a_times = getWorldTwopointMovementTime(_ED.world_map.position_coordinates_x,
            _ED.world_map.position_coordinates_y, self._info._x, self._info._y, true)
    Text_arr_time_n:setString(exChangeTimeToString(a_times))
	
	--推荐战力
	local environment_formation_id	= dms.int(dms["npc"], npc_id, npc.environment_formation1)
	local combat_force = dms.string(dms["environment_formation"], environment_formation_id, environment_formation.combat_force)
	Text_rec_fight_n:setString(exChangeNumToString(combat_force))

    self:updateInvestigateInfo()
end

function RebelHauntAttack:updateInvestigateInfo()
    local root = self.roots[1]
    -- 侦查剩余时间
    local Text_world_surplus_t = ccui.Helper:seekWidgetByName(root,"Text_world_surplus_t")
    local Text_world_surplus_n = ccui.Helper:seekWidgetByName(root,"Text_world_surplus_n")

    local leave_time = 0
    if zstring.tonumber(_ED.world_investigate_end_time) > 0 then
        leave_time = _ED.world_investigate_end_time - (os.time() - _ED.world_investigate_start_time)
    end
    if leave_time > 0 then
        Text_world_surplus_t:setVisible(true)
        Text_world_surplus_n:setVisible(true)

        Text_world_surplus_n:setString(exChangeTimeToString(leave_time))
    else
        Text_world_surplus_t:setVisible(false)
        Text_world_surplus_n:setVisible(false)
    end
    self._text_time = Text_world_surplus_n
    self._leave_time = leave_time
end

function RebelHauntAttack:onUpdate(dt)
    if self._text_time ~= nil and self._leave_time > 0 then
        self._leave_time = self._leave_time - dt
        self._text_time:setString(exChangeTimeToString(self._leave_time))
        if self._leave_time <= 0 then
            self._text_time = nil
            self:updateInvestigateInfo()
        end
    end
end

function RebelHauntAttack:onEnterTransitionFinish()

end

function RebelHauntAttack:onInit(params)
    local csbItem = csb.createNode(config_csb.campaign.rebel_haunt_attack)
    self:addChild(csbItem)
	local root = csbItem:getChildByName("root")
	table.insert(self.roots, root)
    
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt_attack_close"), nil, 
    {
        terminal_name = "rebel_haunt_attack_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Image_window_bg"), nil, 
    {
        terminal_name = "rebel_haunt_attack_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt_attack"), nil, 
    {
        terminal_name = "rebel_haunt_attack_fight", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_rebel_haunt_attack_spy"), nil, 
    {
        terminal_name = "rebel_haunt_attack_look_info", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
    }, nil, 1)

    --分享打开
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share"), nil, 
    {
        terminal_name = "rebel_haunt_attack_open_share",
        terminal_state = 0,
        touch_scale = true,
        touch_scale_xy = 0.95,
        touch_black = true,
    },
    nil,1)
    ccui.Helper:seekWidgetByName(root,"Panel_share_close"):setSwallowTouches(false)
    --分享关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_share_close"), nil, 
    {
        terminal_name = "rebel_haunt_attack_close_share", 
        terminal_state = 0, 
    }, nil, 1)
    
    --分享到军团
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_share_legion_chat"), nil, 
    {
        terminal_name = "rebel_haunt_attack_share_legion",
        terminal_state = 0,
        touch_black = true,
    },
    nil,1)
	
	self:onUpdateDraw()
end

function RebelHauntAttack:init(params)
    self._cell = params._datas.cell
    self._info = self._cell.info
	self:onInit(params)
    return self
end

function RebelHauntAttack:onExit()
    state_machine.remove("rebel_haunt_attack_fight")
    state_machine.remove("rebel_haunt_attack_look_info")
    state_machine.remove("rebel_haunt_attack_open_share")
    state_machine.remove("rebel_haunt_attack_close_share")
    state_machine.remove("rebel_haunt_attack_share_legion")
end
