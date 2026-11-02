--------------------------------------------------------------------------------------------------------------
--  说明：阵营对决-战斗
--------------------------------------------------------------------------------------------------------------
CampPkBattle = class("CampPkBattleClass", Window)

--打开界面
local camp_pk_battle_open_terminal = {
	_name = "camp_pk_battle_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("CampPkBattleClass") == nil then
                    fwin:open(CampPkBattle:new():init(params), fwin._ui)
                end
            end
        end
        protocol_command.camp_duel_battle_init.param_list = ""
        NetworkManager:register(protocol_command.camp_duel_battle_init.code, nil, nil, nil, nil, responseCallback, false, nil)
        return true
	end,
	_terminal = nil,
	_terminals = nil
}

local camp_pk_battle_close_terminal = {
    _name = "camp_pk_battle_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CampPkBattleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(camp_pk_battle_open_terminal)
state_machine.add(camp_pk_battle_close_terminal)
state_machine.init()

function CampPkBattle:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    self._current_page = 0
    self._buttons = {}
    self._pages = {}

    self._tick_time = 0
    self._Text_battle_vs_time = nil
    self._camp_info_tick_time = 0
    self._Text_camp_infor_p = nil
    self._show_info = {}

    self._isMoving = false
    self._attack_effect_time = 10

    self._point_action_panel = nil
    self._Panel_battle_vs_fighting_1 = nil
    self._move_time = 0

    self._last_state = nil
    self._Image_camp_battle_choose = nil
    self._change_my_road_state = false
    self._isAddRoadEffect = false

    self._move_state_change = false
    self._play_effect = false
    self._play_effect_init = false

    self._reconnect_count = 0
    self._reconnect_time = 0

    local function init_camp_pk_battle_terminal()
        local camp_pk_battle_change_page_terminal = {
            _name = "camp_pk_battle_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:changeSelectPage(params._datas._page)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_choose_road_move_terminal = {
            _name = "camp_pk_battle_choose_road_move",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.camp_pk_info.state) == 3 then
                    local move_index = params._datas.index
                    if move_index <= 2 or move_index >= 6 then
                        return
                    end
                    local last_line = tonumber(_ED.camp_pk_battle_user_move_info.road_line)
                    local function responseCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                                response.node:createRoad()
                                response.node:updatePointEffectState(2)
                            end
                            if last_line > 0 then
                                if last_line == tonumber(_ED.camp_pk_battle_user_move_info.road_line) then
                                    TipDlg.drawTextDailog(tipStringInfo_campaign_info[54])
                                else
                                    TipDlg.drawTextDailog(tipStringInfo_campaign_info[53])
                                end
                            else
                                TipDlg.drawTextDailog(tipStringInfo_campaign_info[52])
                            end
                        end
                    end
                    protocol_command.camp_duel_choose_line.param_list = ""..(move_index - 3)
                    NetworkManager:register(protocol_command.camp_duel_choose_line.code, nil, nil, nil, instance, responseCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_update_info_terminal = {
            _name = "camp_pk_battle_update_info",
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

        local camp_pk_battle_update_list_info_terminal = {
            _name = "camp_pk_battle_update_list_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateListInfo(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_update_battle_state_info_terminal = {
            _name = "camp_pk_battle_update_battle_state_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateBattleStateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_show_prompt_info_terminal = {
            _name = "camp_pk_battle_show_prompt_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateShowPromptInfo(params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_update_role_move_info_terminal = {
            _name = "camp_pk_battle_update_role_move_info",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:createRoad()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_enter_fight_terminal = {
            _name = "camp_pk_battle_enter_fight",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                _ED._battle_init_type = battle_enum._fight_type._fight_type_208
                _ED._current_scene_id = 0
                _ED._scene_npc_id = 0
                _ED._npc_difficulty_index = 1
                state_machine.excute("fight_window_open", 0, 0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local camp_pk_battle_state_request_terminal = {
            _name = "camp_pk_battle_state_request",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            response.node:updateDraw()
                        end
                    end
                end
                protocol_command.camp_duel_init.param_list = ""
                NetworkManager:register(protocol_command.camp_duel_init.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(camp_pk_battle_change_page_terminal)
        state_machine.add(camp_pk_battle_choose_road_move_terminal)
        state_machine.add(camp_pk_battle_update_info_terminal)
        state_machine.add(camp_pk_battle_update_list_info_terminal)
        state_machine.add(camp_pk_battle_update_battle_state_info_terminal)
        state_machine.add(camp_pk_battle_show_prompt_info_terminal)
        state_machine.add(camp_pk_battle_update_role_move_info_terminal)
        state_machine.add(camp_pk_battle_enter_fight_terminal)
        state_machine.add(camp_pk_battle_state_request_terminal)
        state_machine.init()
    end
    
    init_camp_pk_battle_terminal()
end

function CampPkBattle:updateShowPromptInfo( params )
    local root = self.roots[1]
    local beginPanel = ccui.Helper:seekWidgetByName(root, "Panel_camp_build_".._ED.camp_pk_battle_user_move_info.current_stronghold_id)
    state_machine.excute("camp_pk_battle_up_effect_create", 0, {beginPanel, params})
end

function CampPkBattle:changeSelectPage(page)
    local root = self.roots[1]
    for k,v in pairs(self._buttons) do
        if page == k then
            v:setHighlighted(true)
        else
            v:setHighlighted(false)
        end
    end
    if page == self._current_page then
        return
    end
    self._current_page = page
    self:updateListInfo(false)
end

function CampPkBattle:updateListInfo( isUpdate )
    local root = self.roots[1]
    if isUpdate == true then
        state_machine.excute("camp_pk_battle_my_event_update", 0, nil)
        state_machine.excute("camp_pk_battle_camp_event_update", 0, nil)
        state_machine.excute("camp_pk_battle_my_info_update", 0, nil)
    end
    for k,v in pairs(self._pages) do
        v:setVisible(false)
    end
    if self._pages[""..self._current_page] == nil then
        local Panel_battle_vs_infor = ccui.Helper:seekWidgetByName(root, "Panel_battle_vs_infor")
        if self._current_page == 1 then
            self._pages[""..self._current_page] = state_machine.excute("camp_pk_battle_my_event_open", 0, {Panel_battle_vs_infor})
        elseif self._current_page == 2 then
            self._pages[""..self._current_page] = state_machine.excute("camp_pk_battle_my_camp_open", 0, {Panel_battle_vs_infor})
        elseif self._current_page == 3 then
            self._pages[""..self._current_page] = state_machine.excute("camp_pk_battle_my_info_open", 0, {Panel_battle_vs_infor})
        end
    else
        self._pages[""..self._current_page]:setVisible(true)
    end
    self._Text_camp_infor_p:setVisible(true)
    if self._current_page == 1 then
        -- self._Text_camp_infor_p:setVisible(false)
        state_machine.excute("camp_pk_battle_my_event_update_tick_time", 0, self._tick_time)
    else
        -- self._Text_camp_infor_p:setVisible(true)
        if self._current_page == 2 then
            state_machine.excute("camp_pk_battle_camp_event_update_tick_time", 0, self._tick_time)
        end
    end
end

function CampPkBattle:updateBattleStateInfo(  )
    local root = self.roots[1]
    for i=1,7 do
        local info = _ED.camp_pk_battle_stronghold_info[""..i]
        for j=1,3 do
            local Text_camp_build = ccui.Helper:seekWidgetByName(root, "Text_camp_build_"..i.."_"..j)
            if Text_camp_build ~= nil then
                if j == 1 then
                    Text_camp_build:setString(info.red_count)
                elseif j == 2 then
                    Text_camp_build:setString(info.blue_count)
                else
                    Text_camp_build:setString(info.npc_count)
                end
            end
        end
    end
    self:updatePromptInfo()
end

function CampPkBattle:updatePromptInfo( ... )
    local info = ""
    self._Text_camp_infor_p:removeAllChildren(true)
    self._show_info = {}
    local myStrongholdInfo = _ED.camp_pk_battle_stronghold_info["".._ED.camp_pk_battle_user_move_info.current_stronghold_id]
    if _ED.camp_pk_battle_user_move_info.target_stronghold_id > 0 then      -- 移动中
        if _ED.camp_pk_battle_user_move_info.current_stronghold_id ~= 1
            and _ED.camp_pk_battle_user_move_info.current_stronghold_id ~= 7 then
            self._camp_info_tick_time = (_ED.camp_pk_battle_user_move_info.begin_time + _ED.camp_pk_battle_user_move_info.need_time)/1000 - (_ED.system_time + os.time() - _ED.native_time)
            if self._camp_info_tick_time > 0 then
                self._show_info_type = 19
                local describe = _ED.camp_battle_event_info["19"].info
                local name = dms.string(dms["camp_duel_mould"], _ED.camp_pk_battle_user_move_info.target_stronghold_id, camp_duel_mould.name)
                info = describe
                self._show_info = {ntype = 19, info = describe, time = self._camp_info_tick_time, name = name}
            end
        end
    else
        local camp_duel_elment = dms.element(dms["camp_duel_mould"], _ED.camp_pk_battle_user_move_info.current_stronghold_id)
        local stronghold_id_type = dms.atoi(camp_duel_elment, camp_duel_mould.ntype)
        local camp = dms.atoi(camp_duel_elment, camp_duel_mould.camp)
        if myStrongholdInfo.state == 1 then             -- 自己的据点在修整中
            local name = dms.atos(camp_duel_elment, camp_duel_mould.name)
            if stronghold_id_type == 1 then
                local config_time = dms.int(dms["camp_duel_config"], 3, camp_duel_config.param)
                self._camp_info_tick_time = myStrongholdInfo.start_time/1000 + config_time - (_ED.system_time + os.time() - _ED.native_time)
                if self._camp_info_tick_time > 0 then
                    if tonumber(_ED.camp_pk_user_info.camp_state) ~= camp then
                        local describe = _ED.camp_battle_event_info["21"].info
                        info = describe
                        self._show_info = {ntype = 21, info = describe, time = self._camp_info_tick_time, name = ""}
                    else
                        local describe = _ED.camp_battle_event_info["20"].info
                        info = describe
                        self._show_info = {ntype = 20, info = describe, time = self._camp_info_tick_time, name = name}
                    end
                end
            elseif stronghold_id_type == 2 then
                local config_time = dms.int(dms["camp_duel_config"], 3, camp_duel_config.param)
                self._camp_info_tick_time = myStrongholdInfo.start_time/1000 + config_time - (_ED.system_time + os.time() - _ED.native_time)
                if self._camp_info_tick_time > 0 then
                    local describe = _ED.camp_battle_event_info["20"].info
                    info = describe
                    self._show_info = {ntype = 20, info = describe, time = self._camp_info_tick_time, name = name}
                end
            end
        elseif myStrongholdInfo.state == 2 then         -- 自己的据点在交战中
            local name = dms.atos(camp_duel_elment, camp_duel_mould.name)
            if stronghold_id_type == 1 then
                self._camp_info_tick_time = 1000
                if tonumber(_ED.camp_pk_user_info.camp_state) ~= camp then
                    name = red_alert_campaign_pk_str[7]
                else
                    name = red_alert_campaign_pk_str[8]
                end
            end
            local describe = _ED.camp_battle_event_info["22"].info
            info = describe
            self._show_info = {ntype = 22, info = describe, time = 0, name = name}
        else
            if _ED.camp_pk_battle_user_move_info.road_line == -1 then
                if stronghold_id_type == 0 then
                    local config_time = dms.int(dms["camp_duel_config"], 3, camp_duel_config.param)
                    self._camp_info_tick_time = myStrongholdInfo.start_time/1000 + config_time - (tonumber(_ED.system_time) + os.time() - tonumber(_ED.native_time))
                    if self._camp_info_tick_time > 0 then
                        local describe = _ED.camp_battle_event_info["18"].info
                        info = describe
                        self._show_info = {ntype = 18, info = describe, time = self._camp_info_tick_time, name = ""}
                    end
                end
            end
        end
    end
    self:updateMyStateShowInfo()
end

function CampPkBattle:updateMyStateShowInfo( ... )
    if self._show_info == nil or self._show_info.ntype == nil then
        return
    end
    self._Text_camp_infor_p:removeAllChildren(true)
    local fontSize = self._Text_camp_infor_p:getFontSize()
    local info_str = self._show_info.info
    if self._show_info.name ~= "" and self._show_info.time > 0 then
        info_str = string.gsub(info_str, "!x@", self._show_info.name)
        info_str = string.gsub(info_str, "!y@", math.floor(self._camp_info_tick_time))
    elseif self._show_info.name ~= "" then
        info_str = string.gsub(info_str, "!x@", self._show_info.name)
    else
        info_str = string.gsub(info_str, "!x@", math.floor(self._camp_info_tick_time))
    end

    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false)
    _richText:setAnchorPoint(cc.p(0.5, 0.5))
    _richText:setContentSize(cc.size(self._Text_camp_infor_p:getContentSize().width,fontSize))
    local rt, count, text = draw.richTextCollectionMethod(_richText, 
        info_str, 
        cc.c3b(189, 206, 224),
        cc.c3b(189, 206, 224),
        0, 
        0, 
        config_res.font.font_name, 
        fontSize,
        chat_rich_text_color)
    _richText:setPosition(cc.p(self._Text_camp_infor_p:getContentSize().width/2,self._Text_camp_infor_p:getContentSize().height/2))
    self._Text_camp_infor_p:addChild(_richText)
end

function CampPkBattle:createRoad()
    if _ED.camp_pk_battle_user_move_info.target_stronghold_id <= 0 then
        if (_ED.camp_pk_battle_user_move_info.current_stronghold_id == 1 
            or _ED.camp_pk_battle_user_move_info.current_stronghold_id == 7) 
            -- and _ED.camp_pk_battle_user_move_info.road_line == -1 
            then
            self:reviewMyRole()
        end
        return
    end
    if self._isMoving == true then
        return
    end
    self._move_state_change = true
    local root = self.roots[1]
    local beginPanel = ccui.Helper:seekWidgetByName(root, "Panel_camp_build_".._ED.camp_pk_battle_user_move_info.current_stronghold_id)
    local endPanel = ccui.Helper:seekWidgetByName(root, "Panel_camp_build_".._ED.camp_pk_battle_user_move_info.target_stronghold_id)
    local sx, sy = beginPanel:getPositionX() + beginPanel:getContentSize().width/2, beginPanel:getPositionY() + beginPanel:getContentSize().height/2
    local dx, dy = endPanel:getPositionX() + endPanel:getContentSize().width/2, endPanel:getPositionY() + endPanel:getContentSize().height/2
    self._isMoving = true
    app.load("client.red_alert.battle.battle_macros")
    local s = math.sqrt((dx - sx) * (dx - sx) + (dy - sy) *(dy - sy))

    local parent = cc.Node:create()
    self._Panel_battle_vs_fighting_1:addChild(parent, 100)

    local layerbg = ccui.Layout:create()
    layerbg:setAnchorPoint(cc.p(0, 0.5))
    layerbg:setContentSize(cc.size(s, 16))

    local layer = cc.Node:create()
    layer:setAnchorPoint(cc.p(0, 0))
    layer:setPositionY(8)
    layer:setContentSize(cc.size(s, 16))

    local nCount = s / 12 + 4
    local mx = -12
    for i = 1, nCount do
        local arrow = nil
        if tonumber(_ED.camp_pk_user_info.camp_state) == 0 then
            arrow = cc.Sprite:create("images/ui/share/world_locking_arrow_route.png")
        else
            arrow = cc.Sprite:create("images/ui/share/world_locking_arrow_route_1.png")
        end
        layer:addChild(arrow)

        arrow:setPositionX(mx)
        arrow._mx = mx
        mx = mx + 12
    end
    layer:runAction(cc.RepeatForever:create(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(12, 8)), cc.CallFunc:create(function ( sender ) sender:setPositionX(0) end))))
    layerbg:addChild(layer)
    layerbg:setClippingEnabled(true)

    local angle = CC_POSITIONS_TO_DEGREES(cc.p(sx, sy), cc.p(dx, dy))
    layerbg:setRotation(angle - 90)
    layerbg:setPosition(cc.p(sx, sy))
    parent:addChild(layerbg, 100)

    local at = angle
    if at < 0 then
        at = at - 7.5
    else
        at = at + 7.5
    end
    local actionIndex = math.modf(at / (360.0 / 16.0))
    if actionIndex <= 0 then
        actionIndex = 8 + actionIndex + 8
    end
    if actionIndex > 15 then
        actionIndex = 0
    end

    local ntype = dms.int(dms["camp_duel_mould"], _ED.camp_pk_battle_user_move_info.target_stronghold_id, camp_duel_mould.ntype)
    local config_time = zstring.split(dms.string(dms["camp_duel_config"], 4, camp_duel_config.param), ",")
    local m_stime = (_ED.camp_pk_battle_user_move_info.begin_time + _ED.camp_pk_battle_user_move_info.need_time)/1000 - (tonumber(_ED.system_time) + os.time() - tonumber(_ED.native_time))
    local m_time = config_time[ntype]
    m_stime = math.min(m_time, m_stime)
    local tank = cc.Sprite:create("images/ui/world_route_tank/world_route_tank_".. actionIndex .. ".png")
    parent:addChild(tank, 100)
    tank._parent = parent

    local function requestCheckMoveEnd( tank )
        self._isMoving = false
        self._move_state_change = false
        tank._parent:removeFromParent(true)
        local function responseCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                    response.node:updateBattleStateInfo()
                end
            end
        end
        NetworkManager:register(protocol_command.camp_duel_check_move.code, nil, nil, nil, self, responseCallback, false, nil)
    end
    if m_stime <= 0 then
        requestCheckMoveEnd(tank)
    end

    self._move_time = m_stime
    local moveStartX = sx + (dx - sx)*((m_time - m_stime) / m_time)
    local moveStartY = sy + (dy - sy)*((m_time - m_stime) / m_time)
    tank:setPosition(cc.p(moveStartX, moveStartY))
    tank:runAction(cc.Sequence:create(cc.MoveTo:create(m_stime, cc.p(dx, dy)), cc.CallFunc:create(function (sender)
        requestCheckMoveEnd(sender)
    end)))

    self._point_action_panel:setPosition(cc.p(moveStartX - self._point_action_panel:getContentSize().width/2, moveStartY - self._point_action_panel:getContentSize().height/2))
    self._point_action_panel:runAction(cc.Sequence:create(cc.MoveTo:create(m_stime, cc.p(dx - self._point_action_panel:getContentSize().width/2, dy - self._point_action_panel:getContentSize().height/2)), cc.CallFunc:create(function (sender)
    end)))
end

function CampPkBattle:updateButtonState( ... )
    local root = self.roots[1]
    local Text_camp_infor_t = ccui.Helper:seekWidgetByName(root, "Text_camp_infor_t")
    local fontSize = Text_camp_infor_t:getFontSize()
    Text_camp_infor_t:removeAllChildren(true)
    local _richText = ccui.RichText:create()
    _richText:ignoreContentAdaptWithSize(false) 
    local color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    local re1 = ccui.RichElementText:create(1, color, 255, red_alert_campaign_pk_str[3].."(", "fonts/simhei.ttf", fontSize)
    _richText:pushBackElement(re1)
    if tonumber(_ED.camp_pk_user_info.camp_state) == 0 then
        color = cc.c3b(color_Type[3][1], color_Type[3][2], color_Type[3][3])
        local re2 = ccui.RichElementText:create(1, color, 255, red_alert_campaign_pk_str[9], "fonts/simhei.ttf", fontSize)
        _richText:pushBackElement(re2)
    else
        color = cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3])
        local re2 = ccui.RichElementText:create(1, color, 255, red_alert_campaign_pk_str[10], "fonts/simhei.ttf", fontSize)
        _richText:pushBackElement(re2)
    end
    color = cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])
    local re3 = ccui.RichElementText:create(1, color, 255, ")", "fonts/simhei.ttf", fontSize)
    _richText:pushBackElement(re3)
    _richText:setContentSize(cc.size(Text_camp_infor_t:getContentSize().width, Text_camp_infor_t:getContentSize().height))
    _richText:setPosition(cc.p(Text_camp_infor_t:getContentSize().width/2, Text_camp_infor_t:getContentSize().height/2))
    Text_camp_infor_t:addChild(_richText)
end

function CampPkBattle:reviewMyRole( ... )
    local root = self.roots[1]
    local beginPanel = ccui.Helper:seekWidgetByName(root, "Panel_camp_build_".._ED.camp_pk_battle_user_move_info.current_stronghold_id)
    local sx, sy = beginPanel:getPositionX() + beginPanel:getContentSize().width/2, beginPanel:getPositionY() + beginPanel:getContentSize().width/2
    self._point_action_panel:setPosition(cc.p(sx - self._point_action_panel:getContentSize().width/2, sy - self._point_action_panel:getContentSize().height/2))
end

function CampPkBattle:updateDraw()
    local root = self.roots[1]
    local Text_battle_vs_number_1 = ccui.Helper:seekWidgetByName(root, "Text_battle_vs_number_1")
    local Text_battle_vs_number_2 = ccui.Helper:seekWidgetByName(root, "Text_battle_vs_number_2")
    local Text_camp_build_1_number = ccui.Helper:seekWidgetByName(root, "Text_camp_build_1_number")
    local Text_camp_build_7_number = ccui.Helper:seekWidgetByName(root, "Text_camp_build_7_number")
    local Text_meritorious_me_n = ccui.Helper:seekWidgetByName(root, "Text_meritorious_me_n")
    self._Text_battle_vs_time = ccui.Helper:seekWidgetByName(root, "Text_battle_vs_time")
    self._Text_camp_infor_p = ccui.Helper:seekWidgetByName(root, "Text_camp_infor_p")
    local Image_battle_vs_process_1 = ccui.Helper:seekWidgetByName(root, "Image_battle_vs_process_1")
    local Panel_battle_vs_process_ing = ccui.Helper:seekWidgetByName(root, "Panel_battle_vs_process_ing")
    local Image_vs_pocess_light = ccui.Helper:seekWidgetByName(root, "Image_vs_pocess_light")
    local Text_13 = ccui.Helper:seekWidgetByName(root, "Text_13")
    Text_battle_vs_number_1:setString("".._ED.camp_pk_battle_score_info.blue_score)
    Text_battle_vs_number_2:setString("".._ED.camp_pk_battle_score_info.red_score)
    Text_meritorious_me_n:setString("".._ED.camp_pk_battle_user_info.get_con)
    Text_camp_build_1_number:setString("".._ED.camp_pk_battle_score_info.blue_count)
    Text_camp_build_7_number:setString("".._ED.camp_pk_battle_score_info.red_count)

    local blue_percent = tonumber(_ED.camp_pk_battle_score_info.blue_score)/(tonumber(_ED.camp_pk_battle_score_info.blue_score) + tonumber(_ED.camp_pk_battle_score_info.red_score))
    if tonumber(_ED.camp_pk_battle_score_info.blue_score) == 0 and tonumber(_ED.camp_pk_battle_score_info.red_score) == 0 then
        blue_percent = 0.5
    elseif tonumber(_ED.camp_pk_battle_score_info.blue_score) == 0 then
        blue_percent = 0
    elseif tonumber(_ED.camp_pk_battle_score_info.red_score) == 0 then
        blue_percent = 1
    end
    local width = blue_percent * Image_battle_vs_process_1:getContentSize().width
    Panel_battle_vs_process_ing:setContentSize(cc.size(width, Panel_battle_vs_process_ing:getContentSize().height))
    Image_vs_pocess_light:setPositionX(width)

    if self._last_state == nil or tonumber(_ED.camp_pk_info.state) ~= self._last_state then
        self._last_state = tonumber(_ED.camp_pk_info.state)
        if tonumber(_ED.camp_pk_info.state) == 0 then
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(config_res.images.ui.effice.effect_camp_vic)
            local armature = ccs.Armature:create("effect_camp_vic")
            draw.initArmature(armature, nil, -1, 0, 1)
            local function changeActionCallback( armatureBack )
                armatureBack:removeFromParent(true)
                state_machine.excute("camp_pk_battle_close", 0, nil)
            end
            armature:setPosition(cc.p(self._Panel_battle_vs_fighting_1:getContentSize().width/2, self._Panel_battle_vs_fighting_1:getContentSize().height/2))
            self._Panel_battle_vs_fighting_1:addChild(armature)
            armature._invoke = changeActionCallback
            armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
            if tonumber(_ED.camp_pk_info.win_info) == 0 then
                armature:getAnimation():playWithIndex(1)
            else
                armature:getAnimation():playWithIndex(0)
            end
        -- else
        --     self._tick_time = _ED.camp_pk_info.end_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        end
    end
    self._tick_time = _ED.camp_pk_info.end_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))

    self._reconnect_count = 0
    self._reconnect_time = 0
end

function CampPkBattle:updatePointEffectState( state )
    self._change_my_road_state = state
    local root = self.roots[1]
    for i=3,5 do
        local Panel_camp_build_effect = ccui.Helper:seekWidgetByName(root, "Panel_camp_build_"..i.."_effect")
        local Panel_camp_build_effect_0 = ccui.Helper:seekWidgetByName(root, "Panel_camp_build_"..i.."_effect_0")
        Panel_camp_build_effect:setVisible(false)
        Panel_camp_build_effect_0:setVisible(false)
        if self._isAddRoadEffect == false then
            local effice_2 = config_res.images.ui.effice.effice_pve_npc_checkpoint_2
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effice_2)
            local armature_2 = ccs.Armature:create("effice_pve_npc_checkpoint_2")
            draw.initArmature(armature_2, nil, -1, 0, 1)
            armature_2:setPosition(cc.p(Panel_camp_build_effect:getContentSize().width/2, Panel_camp_build_effect:getContentSize().height/2))
            Panel_camp_build_effect:addChild(armature_2)

            local effice_1 = config_res.images.ui.effice.effice_pve_npc_checkpoint_1
            ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effice_1)
            local armature_1 = ccs.Armature:create("effice_pve_npc_checkpoint_1")
            draw.initArmature(armature_1, nil, -1, 0, 1)
            armature_1:setPosition(cc.p(Panel_camp_build_effect_0:getContentSize().width/2, Panel_camp_build_effect_0:getContentSize().height/2))
            Panel_camp_build_effect_0:addChild(armature_1)
        end
        if self._change_my_road_state == 0 then         -- 全部显示
            Panel_camp_build_effect:setVisible(true)
            Panel_camp_build_effect_0:setVisible(true)
        elseif self._change_my_road_state == 1 then         -- 全部隐藏
            -- Panel_camp_build_effect:setVisible(false)
            -- Panel_camp_build_effect_0:setVisible(false)
        else                                            -- 显示选择的路径
            if tonumber(_ED.camp_pk_battle_user_move_info.road_line) >= 0
                and i - tonumber(_ED.camp_pk_battle_user_move_info.road_line) == 3 
                then
                Panel_camp_build_effect:setVisible(true)
                -- Panel_camp_build_effect_0:setVisible(true)
            end
        end
    end

    if self._isAddRoadEffect == false 
        then
        self._isAddRoadEffect = true
    end

end

function CampPkBattle:onUpdate( dt )
    -- self._tick_time = self._tick_time - dt
    self._tick_time = _ED.camp_pk_info.end_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
    self._camp_info_tick_time = self._camp_info_tick_time - dt
    self._attack_effect_time = self._attack_effect_time - dt
    self._move_time = self._move_time - dt

    if self._tick_time <= 0 then
        self._Text_battle_vs_time:setString("")
        if self._tick_time <= -1 and tonumber(_ED.camp_pk_info.state) == 3 then
            if self._reconnect_count <= 2 then
                if self._reconnect_time <= 0 then
                    self._reconnect_count = self._reconnect_count + 1
                    self._reconnect_time = 3
                    state_machine.excute("camp_pk_battle_state_request", 0, "")
                else
                    self._reconnect_time = self._reconnect_time - dt
                end
            end
        end
    else
        if tonumber(_ED.camp_pk_info.state) == 3 then
            self._Text_battle_vs_time:setString(exChangeNumTimeString(self._tick_time, 2))
        end
    end
    if self._camp_info_tick_time <= 0 then
        self._show_info = {}
        self._Text_camp_infor_p:removeAllChildren(true)
    else
        self:updateMyStateShowInfo()
    end
    self._point_action_panel:updateInfo(self._move_time)

    if self._attack_effect_time <= 0 then
        self._attack_effect_time = 5
        local root = self.roots[1]
        if self._play_effect == false then
            for i=1,7 do
                local info = _ED.camp_pk_battle_stronghold_info[""..i]
                if info.state == 2 then
                    if self._play_effect_init == false then
                        self._play_effect = true
                        self._play_effect_init = true
                    end
                    local panel = ccui.Helper:seekWidgetByName(root, "Panel_camp_build_"..i)
                    self:addAttackEffect(panel)
                end
            end
        end
    end

    if _ED.camp_pk_battle_user_move_info ~= nil then
        if (tonumber(_ED.camp_pk_battle_user_move_info.current_stronghold_id) == 1
            or tonumber(_ED.camp_pk_battle_user_move_info.current_stronghold_id) == 7)
            then
            if tonumber(_ED.camp_pk_battle_user_move_info.target_stronghold_id) == -1 then
                if tonumber(_ED.camp_pk_battle_user_move_info.road_line) == -1 then
                    self._Image_camp_battle_choose:setVisible(true)
                    self:updatePointEffectState(0)
                else
                    self._Image_camp_battle_choose:setVisible(false)
                    self:updatePointEffectState(2)
                end
            else
                self._Image_camp_battle_choose:setVisible(false)
                if self._move_state_change == true then
                    self._move_state_change = false
                    self:updatePointEffectState(1)
                end
            end
        else
            self._Image_camp_battle_choose:setVisible(false)
            if self._move_state_change == true then
                self._move_state_change = false
                self:updatePointEffectState(1)
            end
        end
    end

    -- if _ED.camp_pk_battle_user_move_info ~= nil then
    --     -- and tonumber(_ED.camp_pk_battle_user_move_info.target_stronghold_id) == -1 
    --     if tonumber(_ED.camp_pk_battle_user_move_info.road_line) == -1
    --         -- and (tonumber(_ED.camp_pk_battle_user_move_info.current_stronghold_id) == 1
    --         --     or tonumber(_ED.camp_pk_battle_user_move_info.current_stronghold_id) == 7)
    --         then
    --         self._Image_camp_battle_choose:setVisible(true)
    --         if self._change_my_road_state == false then
    --             self:updatePointEffectState(true)
    --         end
    --     else
    --         -- if self._change_my_road_state == true then
    --             self:updatePointEffectState(false)
    --         -- end
    --         self._Image_camp_battle_choose:setVisible(false)
    --     end
    -- end
end

function CampPkBattle:addAttackEffect( panel )
    panel:removeAllChildren(true)
    local baseName = config_res.sprite.spirte_campfight
    local armature = sp.spine(baseName..".json", baseName..".atlas", 1, 0, nil, false, nil)
    sp.initArmature(armature, false)
    armature:setAnimation(0, "animation", true)

    local function changeActionCallback( armatureBack )
        if self._play_effect_init == true then
            self._play_effect = false
            self._play_effect_init = false
        end
        armatureBack:removeFromParent(true)
    end
    armature._invoke = changeActionCallback
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
    armature:setPosition(cc.p(panel:getContentSize().width/2, panel:getContentSize().height/2))
    panel:addChild(armature)
end

function CampPkBattle:onInit()
    local csbItem = csb.createNode(config_csb.campaign.camp_pk_battle)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_camp_pk_battle_close"), nil, 
    {
        terminal_name = "camp_pk_battle_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self._buttons = {ccui.Helper:seekWidgetByName(root, "Button_battle_vs_me"),
                ccui.Helper:seekWidgetByName(root, "Button_battle_vs_camp"),
                ccui.Helper:seekWidgetByName(root, "Button_battle_vs_infor")}

    for k,v in pairs(self._buttons) do
        fwin:addTouchEventListener(v, nil, 
        {
            terminal_name = "camp_pk_battle_change_page", 
            terminal_state = 0, 
            touch_black = true,
            _page = k,
        }, nil, 1)
    end

    for i=1,7 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_camp_build_"..i), nil, 
        {
            terminal_name = "camp_pk_battle_choose_road_move", 
            terminal_state = 0, 
            touch_black = true,
            index = i,
        }, nil, 1)
    end
    self._Panel_battle_vs_fighting_1 = ccui.Helper:seekWidgetByName(root, "Panel_battle_vs_fighting_1")
    self._point_action_panel = state_machine.excute("camp_pk_battle_act_create", 0, {self._Panel_battle_vs_fighting_1})
    self._Image_camp_battle_choose = ccui.Helper:seekWidgetByName(root, "Image_camp_battle_choose")
    self._Image_camp_battle_choose:setVisible(false)

    self:reviewMyRole()
    self:updateDraw()
    self:updateBattleStateInfo()
    self:updateButtonState()
    self:changeSelectPage(1)
    self:createRoad()

    local Panel_legion_chat_view = ccui.Helper:seekWidgetByName(root, "Panel_legion_chat_view")
    Panel_legion_chat_view:removeAllChildren(true)
    state_machine.excute("legion_chats_view_open", 0, {Panel_legion_chat_view, 1})
end

function CampPkBattle:onEnterTransitionFinish()

end

function CampPkBattle:init(param)
	self:onInit()
    return self
end

function CampPkBattle:onExit()
    state_machine.remove("camp_pk_battle_change_page")
    state_machine.remove("camp_pk_battle_choose_road_move")
    state_machine.remove("camp_pk_battle_update_info")
    state_machine.remove("camp_pk_battle_update_list_info")
    state_machine.remove("camp_pk_battle_update_battle_state_info")
    state_machine.remove("camp_pk_battle_show_prompt_info")
    state_machine.remove("camp_pk_battle_update_role_move_info")
    state_machine.remove("camp_pk_battle_enter_fight")
    state_machine.remove("camp_pk_battle_state_request")
end