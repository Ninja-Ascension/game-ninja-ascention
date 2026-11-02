-----------------------------
--王者之战比赛准备界面
-----------------------------
SmCrossServerBattleofKingsPrepareForTheGame = class("SmCrossServerBattleofKingsPrepareForTheGameClass", Window)
SmCrossServerBattleofKingsPrepareForTheGame.__size = nil

local sm_cross_server_battleof_kings_prepare_for_the_game_window_open_terminal = {
    _name = "sm_cross_server_battleof_kings_prepare_for_the_game_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = SmCrossServerBattleofKingsPrepareForTheGame:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cross_server_battleof_kings_prepare_for_the_game_window_open_terminal)
state_machine.init()

function SmCrossServerBattleofKingsPrepareForTheGame:ctor()
    self.super:ctor()
    self.roots = {}
    self.cd_time = 0
    self.down_count = 2
    self.cur_round = 0
    app.load("client.l_digital.cells.campaign.crossServerBattleofKings.sm_cross_server_battle_of_kings_battle_list_cell")
    app.load("client.l_digital.cells.campaign.crossServerBattleofKings.sm_cross_server_battle_of_kings_eliminate_cell")

    local function init_sm_cross_server_battleof_kings_prepare_for_the_game_terminal()
        --显示界面
        local sm_cross_server_battleof_kings_prepare_for_the_game_show_terminal = {
            _name = "sm_cross_server_battleof_kings_prepare_for_the_game_show",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --隐藏界面
        local sm_cross_server_battleof_kings_prepare_for_the_game_hide_terminal = {
            _name = "sm_cross_server_battleof_kings_prepare_for_the_game_hide",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local sm_cross_server_battleof_kings_prepare_for_the_game_update_draw_terminal = {
            _name = "sm_cross_server_battleof_kings_prepare_for_the_game_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cross_server_battleof_kings_prepare_for_the_game_set_formation_terminal = {
            _name = "sm_cross_server_battleof_kings_prepare_for_the_game_set_formation",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsMyGeneralFormation")
                app.load("client.l_digital.campaign.crossServerBattleofKings.SmCrossServerBattleofKingsMyPeakFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 4 then
                    
                    if zstring.tonumber(_ED.cross_server_kings_battle.my_lose_number) >= _ED.cross_server_kings_battle.fail_next_param then
                        TipDlg.drawTextDailog(_new_interface_text[221])
                        return
                    end
                    if _ED.cross_server_kings_battle.peak_number and tonumber(_ED.cross_server_kings_battle.peak_number) > 0 and zstring.tonumber(_ED.cross_server_kings_battle.my_lose_number) < _ED.cross_server_kings_battle.fail_next_param then
                        --巅峰
                        state_machine.excute("sm_cross_server_battleof_kings_my_peak_formation_open", 0, "")
                    else
                        state_machine.excute("sm_cross_server_battleof_kings_my_general_formation_open", 0, "")
                    end
                else
                    state_machine.excute("sm_cross_server_battleof_kings_my_general_formation_open", 0, "")
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cross_server_battleof_kings_prepare_for_the_game_update_draw_list_terminal = {
            _name = "sm_cross_server_battleof_kings_prepare_for_the_game_update_draw_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:addFightingProcessDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_cross_server_battleof_kings_prepare_for_the_game_update_battle_draw_terminal = {
            _name = "sm_cross_server_battleof_kings_prepare_for_the_game_update_battle_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) == 4 then

                    if 1 == params.type then
                        
                    else
                        local index = 1
                        local cur_formation = zstring.split(params.user_formation, "@")
                        if cur_formation then
                            for i,v in pairs(_ED.cross_server_kings_battle.battle_match_info) do
                                if tonumber(v.byAttackUserId) == tonumber(_ED.user_info.user_id) then
                                    v.baseByAttackShip = cur_formation[index].."@"
                                else
                                    v.baseAttackShip = cur_formation[index].."@"
                                end
                                index = index + 1
                            end
                        end
                    end

                    local root = self.roots[1]
                    local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1],"ListView_1")
                    local cells = ListView_1:getItem(0)
                    if cells ~= nil then
                        cells:updateDraw(false)
                    end
                else
                    --未开始比赛时  刷新初始化信息
                    local function responseUpdateCallback(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if nil ~= response.node and nil ~= response.node.roots then
                                local root = self.roots[1]
                                local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1],"ListView_1")
                                local cells = ListView_1:getItem(0)
                                if cells ~= nil then
                                    cells:updateDraw(false)
                                end
                            end
                        end
                    end
                    NetworkManager:register(protocol_command.the_kings_battle_self_init.code, nil, nil, nil, self, responseUpdateCallback, false, nil)  
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cross_server_battleof_kings_prepare_for_the_game_show_terminal) 
        state_machine.add(sm_cross_server_battleof_kings_prepare_for_the_game_hide_terminal)
        state_machine.add(sm_cross_server_battleof_kings_prepare_for_the_game_update_draw_terminal)
        state_machine.add(sm_cross_server_battleof_kings_prepare_for_the_game_set_formation_terminal)
        state_machine.add(sm_cross_server_battleof_kings_prepare_for_the_game_update_draw_list_terminal)
        state_machine.add(sm_cross_server_battleof_kings_prepare_for_the_game_update_battle_draw_terminal)

        state_machine.init()
    end
    init_sm_cross_server_battleof_kings_prepare_for_the_game_terminal()
end

function SmCrossServerBattleofKingsPrepareForTheGame:onHide()
    self:setVisible(false)
end

function SmCrossServerBattleofKingsPrepareForTheGame:onShow()
    self:setVisible(true)
end

--准备阶段中的绘制
function SmCrossServerBattleofKingsPrepareForTheGame:onPreparingDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    if 3 == _ED.cross_server_kings_battle.cross_server_kings_battle_open_type then
        local cell = state_machine.excute("sm_cross_server_battle_of_kings_battle_list_cell", 0, {1,1})
        ListView_1:addChild(cell)
        ListView_1:requestRefreshView()
    end
    
    local Text_zhankuang_n = ccui.Helper:seekWidgetByName(root,"Text_zhankuang_n")
    Text_zhankuang_n:setString(_new_interface_text[156])
    local Text_jifen_n = ccui.Helper:seekWidgetByName(root,"Text_jifen_n")
    Text_jifen_n:setString(_new_interface_text[156])
end

function SmCrossServerBattleofKingsPrepareForTheGame:addFightingProcessDraw()
    if true then
        self:onUpdateDraw()
        return
    end
    
end
--战斗过程的绘制
function SmCrossServerBattleofKingsPrepareForTheGame:onFightingProcessDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    self.oldInfex = 0
    for i,v in ipairs(_ED.cross_server_kings_battle.battle_match_info) do
        
        self.oldInfex = self.oldInfex + 1

        local cell = state_machine.excute("sm_cross_server_battle_of_kings_battle_list_cell", 0, {self.oldInfex,_ED.cross_server_kings_battle.battle_round_my})
        if i == 1 then
            ListView_1:addChild(cell)
        else
            ListView_1:insertCustomItem(cell, 0)
        end
        ListView_1:requestRefreshView()
    end

    --决赛数据
    if false and 4 == _ED.cross_server_kings_battle.round_status and _ED.cross_server_kings_battle.peak_list then
        for i,v in ipairs(_ED.cross_server_kings_battle.peak_list) do
            if tonumber(_ED.user_info.user_id) == v.byAttackUserId or tonumber(_ED.user_info.user_id) == v.attackUserId then
                local cell = state_machine.excute("sm_cross_server_battle_of_kings_battle_list_cell", 0, {i, _ED.cross_server_kings_battle.battle_round})
                ListView_1:insertCustomItem(cell, 0)
                ListView_1:requestRefreshView()
            end
        end
    end
    
    --被淘汰了 TODO:测试淘汰数量
    if tonumber(_ED.cross_server_kings_battle.my_lose_number) >= _ED.cross_server_kings_battle.fail_next_param then
        local cell = state_machine.excute("sm_cross_server_battle_of_kings_eliminate_cell", 0, "")
        ListView_1:insertCustomItem(cell, 0)
        ListView_1:requestRefreshView()
    end

    local Text_zhankuang_n = ccui.Helper:seekWidgetByName(root,"Text_zhankuang_n")
    Text_zhankuang_n:setString(string.format(_new_interface_text[155],zstring.tonumber(_ED.cross_server_kings_battle.my_win_number),zstring.tonumber(_ED.cross_server_kings_battle.my_lose_number)))
    
    local Text_jifen_n = ccui.Helper:seekWidgetByName(root,"Text_jifen_n")
    Text_jifen_n:setString(_ED.cross_server_kings_battle.total_point)
end

function SmCrossServerBattleofKingsPrepareForTheGame:onUpdateDraw()
    local root = self.roots[1]
    local Text_zrysd = ccui.Helper:seekWidgetByName(root,"Text_zrysd")
    local Text_tips = ccui.Helper:seekWidgetByName(root,"Text_tips")
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
        ccui.Helper:seekWidgetByName(root,"Panel_daojishi"):setVisible(true)
        self:onPreparingDraw()
        self.cd_time = tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_next_time)/1000-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        Text_zrysd:setVisible(false)
        Text_tips:setString(battle_of_kings_push_text[5])
    else
        -- ccui.Helper:seekWidgetByName(root,"ListView_1"):removeAllItems()
        ccui.Helper:seekWidgetByName(root,"Panel_daojishi"):setVisible(false)
        self.cur_round = _ED.cross_server_kings_battle.battle_round_my
        Text_zrysd:setVisible(false)
        self:onFightingProcessDraw()
        if tonumber(_ED.cross_server_kings_battle.my_lose_number) >= _ED.cross_server_kings_battle.fail_next_param then
            --淘汰了
            Text_tips:setString(battle_of_kings_push_text[8])
        else
           Text_tips:setString(battle_of_kings_push_text[5])
        end
    end
end

function SmCrossServerBattleofKingsPrepareForTheGame:getTimeDesByInterval( timeInt )
    local result = {}
    local oh     = math.floor(timeInt/3600)
    local om     = math.floor((timeInt - oh*3600)/60)
    local os     = math.floor(timeInt - oh*3600 - om*60)
    local hour = oh 
    local day  = 0
    if(oh>=24) then
        day  = math.floor(hour/24)
        hour = oh - day*24
    end
    if hour > 0 then
        if hour < 10 then
            hour = "0"..hour
        end
    else
        hour = "00"
    end
    if om > 0 then
        if om < 10 then
            om = "0"..om
        end
    else
        om = "00"
    end
    if os > 0 then
        if os < 10 then
            os = "0"..os
        end
    else
        os = "00"
    end
    return hour,om,os
end

function SmCrossServerBattleofKingsPrepareForTheGame:onUpdate(dt)
    if tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) ~= 4 then
        if self.cd_time > 0 then
            self.cd_time = self.cd_time - dt
            local h_times,m_times,s_times = self:getTimeDesByInterval(self.cd_time)
            ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_h"):setString(h_times)
            ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_m"):setString(m_times)
            ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_s"):setString(s_times)
        else
            NetworkManager:register(protocol_command.the_kings_battle_self_init.code, nil, nil, nil, self, nil, false, nil)
            local function requesrDefendCheck(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil then
                        self:onUpdateDraw()
                    end
                else
                    if response.node ~= nil and response.node.roots ~= nil then
                        self:onUpdateDraw()
                    end
                end
            end
            protocol_command.the_kings_battle_self_match_info.param_list ="1".."\r\n".._ED.cross_server_kings_battle.cur_battle_round_by_server
            NetworkManager:register(protocol_command.the_kings_battle_self_match_info.code, nil, nil, nil, self, requesrDefendCheck, false, nil)
        end

    elseif 4 == _ED.cross_server_kings_battle.round_status and 0 >= _ED.cross_server_kings_battle.battle_wait_time then
        self.down_count = self.down_count - dt
        if 0 > self.down_count then
            self.down_count = 2
            local function requesrDefendCheck(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if response.node ~= nil and response.node.roots ~= nil then
                        if 4 < _ED.cross_server_kings_battle.round_status then
                            self:onUpdateDraw()
                        end
                    end
                end
            end
            protocol_command.the_kings_battle_self_match_info.param_list ="1".."\r\n".._ED.cross_server_kings_battle.cur_battle_round_by_server
            NetworkManager:register(protocol_command.the_kings_battle_self_match_info.code, nil, nil, nil, self, requesrDefendCheck, false, nil)
        end
    elseif 4 == tonumber(_ED.cross_server_kings_battle.cross_server_kings_battle_open_type) then
        self.down_count = self.down_count - dt
            if _ED.cross_server_kings_battle.battle_round_my and 10 >= _ED.cross_server_kings_battle.battle_round_my then --普通赛
                if 0 > self.down_count then
                    self.down_count = 2
                    local function requesrDefendCheck(response)
                        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                            if response.node ~= nil and response.node.roots ~= nil then
                                if _ED.cross_server_kings_battle.round_status and 0 < _ED.cross_server_kings_battle.round_status and _ED.cross_server_kings_battle.battle_round_my and self.cur_round < _ED.cross_server_kings_battle.battle_round_my then
                                    self:onUpdateDraw()
                                end
                            end
                        end
                    end
                    protocol_command.the_kings_battle_self_match_info.param_list ="1".."\r\n".._ED.cross_server_kings_battle.cur_battle_round_by_server
                    NetworkManager:register(protocol_command.the_kings_battle_self_match_info.code, nil, nil, nil, self, requesrDefendCheck, false, nil)
                end
            else    --巅峰赛
                if _ED.cross_server_kings_battle.peak_list then
                    for i,v in ipairs(_ED.cross_server_kings_battle.peak_list) do
                        if _ED.user_info.user_id == v.byAttackUserId or _ED.user_info.user_id == v.attackUserId then
                            self:onUpdateDraw()
                        end
                    end
                end 
            end   
    else
        if tonumber(_ED.cross_server_kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) <= 60 then
            if ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):isVisible() == false then
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):setVisible(true)
            end
        else
            if ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):isVisible() == true then
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):setVisible(false)
            end
        end
    end
end

function SmCrossServerBattleofKingsPrepareForTheGame:onEnterTransitionFinish()

end

function SmCrossServerBattleofKingsPrepareForTheGame:onInit( )
    local csbItem = csb.createNode("campaign/BattleofKingsX/battle_of_kings_x_tab_2.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if SmCrossServerBattleofKingsPrepareForTheGame.__size == nil then
        SmCrossServerBattleofKingsPrepareForTheGame.__size = root:getContentSize()
    end
    self:setContentSize(SmCrossServerBattleofKingsPrepareForTheGame.__size)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buzhen"), nil, 
        {
            terminal_name = "sm_cross_server_battleof_kings_prepare_for_the_game_set_formation", 
            terminal_state = 0, 
            touch_black = true,
        }, nil, 0)
    local function requesrDefendCheckS(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            self:onUpdateDraw()
        else
            self:onUpdateDraw()    
        end
    end
    if 2 < _ED.cross_server_kings_battle.cross_server_kings_battle_open_type then
        protocol_command.the_kings_battle_self_match_info.param_list ="".."1".."\r\n".._ED.cross_server_kings_battle.cur_battle_round_by_server
        NetworkManager:register(protocol_command.the_kings_battle_self_match_info.code, nil, nil, nil, self, requesrDefendCheckS, false, nil)
    else
        self:onUpdateDraw()
    end

end

function SmCrossServerBattleofKingsPrepareForTheGame:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
    self:onInit()
return self
end

function SmCrossServerBattleofKingsPrepareForTheGame:onExit()
    state_machine.remove("sm_cross_server_battleof_kings_prepare_for_the_game_show")    
    state_machine.remove("sm_cross_server_battleof_kings_prepare_for_the_game_hide")
    state_machine.remove("sm_cross_server_battleof_kings_prepare_for_the_game_update_draw")
end
