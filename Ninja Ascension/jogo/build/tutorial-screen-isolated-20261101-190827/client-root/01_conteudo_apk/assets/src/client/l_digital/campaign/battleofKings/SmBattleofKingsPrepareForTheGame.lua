-----------------------------
--王者之战比赛准备界面
-----------------------------
SmBattleofKingsPrepareForTheGame = class("SmBattleofKingsPrepareForTheGameClass", Window)
SmBattleofKingsPrepareForTheGame.__size = nil

local sm_battleof_kings_prepare_for_the_game_window_open_terminal = {
    _name = "sm_battleof_kings_prepare_for_the_game_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local panel = SmBattleofKingsPrepareForTheGame:new():init(params)
        fwin:open(panel)
        return panel
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battleof_kings_prepare_for_the_game_window_open_terminal)
state_machine.init()

function SmBattleofKingsPrepareForTheGame:ctor()
    self.super:ctor()
    self.roots = {}
    self.cd_time = 0
    app.load("client.l_digital.cells.campaign.battleofKings.sm_battle_of_kings_battle_list_cell")
    app.load("client.l_digital.cells.campaign.battleofKings.sm_battle_of_kings_eliminate_cell")

    local function init_sm_battleof_kings_prepare_for_the_game_terminal()
        --显示界面
        local sm_battleof_kings_prepare_for_the_game_show_terminal = {
            _name = "sm_battleof_kings_prepare_for_the_game_show",
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
        local sm_battleof_kings_prepare_for_the_game_hide_terminal = {
            _name = "sm_battleof_kings_prepare_for_the_game_hide",
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

        --关闭界面
        local sm_battleof_kings_prepare_for_the_game_close_terminal = {
            _name = "sm_battleof_kings_prepare_for_the_game_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                fwin:close(fwin:find("SmBattleofKingsPrepareForTheGameClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }   

        local sm_battleof_kings_prepare_for_the_game_update_draw_terminal = {
            _name = "sm_battleof_kings_prepare_for_the_game_update_draw",
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

        local sm_battleof_kings_prepare_for_the_game_set_formation_terminal = {
            _name = "sm_battleof_kings_prepare_for_the_game_set_formation",
            _init = function (terminal) 
                app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsMyGeneralFormation")
                app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsMyPeakFormation")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

                if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
                    if tonumber(_ED.kings_battle.peak_number) <= 0 and tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) <= 60 then
                        return
                    end
                    if zstring.tonumber(_ED.kings_battle.my_lose_number) >= 3 then
                        TipDlg.drawTextDailog(_new_interface_text[221])
                        return
                    end
                    if tonumber(_ED.kings_battle.peak_number) > 0 and zstring.tonumber(_ED.kings_battle.my_lose_number) < 3 then
                        --巅峰
                        state_machine.excute("sm_battleof_kings_my_peak_formation_open", 0, "")
                    else
                        state_machine.excute("sm_battleof_kings_my_general_formation_open", 0, "")
                    end
                else
                    state_machine.excute("sm_battleof_kings_my_general_formation_open", 0, "")
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_prepare_for_the_game_update_draw_list_terminal = {
            _name = "sm_battleof_kings_prepare_for_the_game_update_draw_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:addFightingProcessDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_prepare_for_the_game_update_battle_draw_terminal = {
            _name = "sm_battleof_kings_prepare_for_the_game_update_battle_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
                    for i,v in pairs(_ED.kings_battle.battle_match_info) do
                        v.my_formation = params
                    end
                    local root = self.roots[1]
                    local ListView_1 = ccui.Helper:seekWidgetByName(instance.roots[1],"ListView_1")
                    local cells = ListView_1:getItem(0)
                    if cells ~= nil then
                        cells:updateDraw(false)
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battleof_kings_prepare_for_the_game_show_terminal) 
        state_machine.add(sm_battleof_kings_prepare_for_the_game_hide_terminal)
        state_machine.add(sm_battleof_kings_prepare_for_the_game_update_draw_terminal)
        state_machine.add(sm_battleof_kings_prepare_for_the_game_set_formation_terminal)
        state_machine.add(sm_battleof_kings_prepare_for_the_game_update_draw_list_terminal)
        state_machine.add(sm_battleof_kings_prepare_for_the_game_update_battle_draw_terminal)
        state_machine.add(sm_battleof_kings_prepare_for_the_game_close_terminal)

        state_machine.init()
    end
    init_sm_battleof_kings_prepare_for_the_game_terminal()
end

function SmBattleofKingsPrepareForTheGame:onHide()
    self:setVisible(false)
end

function SmBattleofKingsPrepareForTheGame:onShow()
    self:setVisible(true)
end

--准备阶段中的绘制
function SmBattleofKingsPrepareForTheGame:onPreparingDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    local cell = state_machine.excute("sm_battle_of_kings_battle_list_cell", 0, {1,1})
    ListView_1:addChild(cell)
    ListView_1:requestRefreshView()

    local Text_zhankuang_n = ccui.Helper:seekWidgetByName(root,"Text_zhankuang_n")
    Text_zhankuang_n:setString(_new_interface_text[156])
    local Text_jifen_n = ccui.Helper:seekWidgetByName(root,"Text_jifen_n")
    Text_jifen_n:setString(_new_interface_text[156])
end

function SmBattleofKingsPrepareForTheGame:addFightingProcessDraw()
    if true then
        self:onUpdateDraw()
        return
    end
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    if tonumber(_ED.kings_battle.match_number) > 10 then
        return
    end
    if _ED.kings_battle.battle_match_info[self.oldInfex + 1] == nil then
        return
    end
    self.oldInfex = self.oldInfex + 1
    local cell = state_machine.excute("sm_battle_of_kings_battle_list_cell", 0, {self.oldInfex,tonumber(_ED.kings_battle.match_number)})
    if i == 1 then
        ListView_1:addChild(cell)
    else
        ListView_1:insertCustomItem(cell, 0)
    end
    ListView_1:requestRefreshView()

    local Text_zhankuang_n = ccui.Helper:seekWidgetByName(root,"Text_zhankuang_n")
    Text_zhankuang_n:setString(string.format(_new_interface_text[155],zstring.tonumber(_ED.kings_battle.my_win_number),zstring.tonumber(_ED.kings_battle.my_lose_number)))
    
    local Text_jifen_n = ccui.Helper:seekWidgetByName(root,"Text_jifen_n")
    Text_jifen_n:setString(_ED.kings_battle.integral)
end
--战斗过程的绘制
function SmBattleofKingsPrepareForTheGame:onFightingProcessDraw()
    local root = self.roots[1]
    local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
    ListView_1:removeAllItems()
    self.oldInfex = 0

    -- 12712  返回王者之战的巅峰对决的信息
    local myPeakInfo = _ED.kings_battle.peak_list[_ED.user_info.user_id]

    -- result_info 所有比赛结果信息
    local result_info = nil

    -- 预赛就被淘汰了 还有几场没打
    local preMatchRemainNum = 0

    -- totalCount 当前比赛总场次
    -- _ED.kings_battle.match_number 是小于 10
    local totalCount = zstring.tonumber(_ED.kings_battle.match_number)

    -- print("myPeakInfo = ", myPeakInfo, " _ED.kings_battle.match_number = ", _ED.kings_battle.match_number)

    if myPeakInfo then
        result_info = zstring.splits(myPeakInfo.result, "|", ",")
        preMatchRemainNum = 10 - totalCount
        totalCount = preMatchRemainNum + #result_info
    end

    -- 12714  返回王者之战的战半匹配信息
    for i = 1, zstring.tonumber(_ED.kings_battle.match_number) do
        self.oldInfex = self.oldInfex + 1

        local cell = state_machine.excute("sm_battle_of_kings_battle_list_cell", 0, {self.oldInfex, totalCount})
        if i == 1 then
            ListView_1:addChild(cell)
        else
            ListView_1:insertCustomItem(cell, 0)
        end
        ListView_1:requestRefreshView()
    end
    
    -- 决赛数据
    -- 巅峰赛开始的场数(可能会小于10场)
    -- print(" totalCount = ", totalCount, " preMatchRemainNum = ", preMatchRemainNum)
    if result_info and totalCount >= 11 then
        for i = 11 , totalCount do
            local battle_info = result_info[i - preMatchRemainNum]
            if battle_info then
                local cell = state_machine.excute("sm_battle_of_kings_battle_list_cell", 0, {i, totalCount})
                ListView_1:insertCustomItem(cell, 0)
                ListView_1:requestRefreshView()
            end
        end
    end

    --被淘汰了
    if tonumber(_ED.kings_battle.my_lose_number) >= 3 then
        local cell = state_machine.excute("sm_battle_of_kings_eliminate_cell", 0, "")
        ListView_1:insertCustomItem(cell, 0)
        ListView_1:requestRefreshView()
    end

    local Text_zhankuang_n = ccui.Helper:seekWidgetByName(root,"Text_zhankuang_n")
    Text_zhankuang_n:setString(string.format(_new_interface_text[155],zstring.tonumber(_ED.kings_battle.my_win_number),zstring.tonumber(_ED.kings_battle.my_lose_number)))
    
    local Text_jifen_n = ccui.Helper:seekWidgetByName(root,"Text_jifen_n")
    Text_jifen_n:setString(_ED.kings_battle.integral)
end

function SmBattleofKingsPrepareForTheGame:onUpdateDraw()
    local root = self.roots[1]
    local Text_zrysd = ccui.Helper:seekWidgetByName(root,"Text_zrysd")
    local Text_tips = ccui.Helper:seekWidgetByName(root,"Text_tips")
    if tonumber(_ED.kings_battle.kings_battle_open_type) ~= 4 then
        ccui.Helper:seekWidgetByName(root,"Panel_daojishi"):setVisible(true)
        self:onPreparingDraw()
        self.cd_time = tonumber(_ED.kings_battle.kings_battle_next_time)/1000-(tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        Text_zrysd:setVisible(false)
        Text_tips:setString(battle_of_kings_push_text[5])
    else
        -- ccui.Helper:seekWidgetByName(root,"ListView_1"):removeAllItems()
        ccui.Helper:seekWidgetByName(root,"Panel_daojishi"):setVisible(false)

        Text_zrysd:setVisible(false)
        self:onFightingProcessDraw()
        if tonumber(_ED.kings_battle.my_lose_number) >= 3 then
            --淘汰了
            Text_tips:setString(battle_of_kings_push_text[8])
        else
           Text_tips:setString(battle_of_kings_push_text[5])
        end
    end
end

function SmBattleofKingsPrepareForTheGame:getTimeDesByInterval( timeInt )

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

function SmBattleofKingsPrepareForTheGame:onUpdate(dt)
    if tonumber(_ED.kings_battle.kings_battle_open_type) ~= 4 then
        if self.cd_time > 0 then
            self.cd_time = self.cd_time - dt
            local h_times,m_times,s_times = self:getTimeDesByInterval(self.cd_time)
            ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_h"):setString(h_times)
            ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_m"):setString(m_times)
            ccui.Helper:seekWidgetByName(self.roots[1],"AtlasLabel_s"):setString(s_times)
            if self.cd_time <= 0 then
                local function requesrDefendCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        self:onUpdateDraw()
                    else
                        self:onUpdateDraw()    
                    end
                end
                protocol_command.the_kings_battle_manager.param_list = "4"
                NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, self, requesrDefendCheck, false, nil)
            end
        end
    else
        if tonumber(_ED.kings_battle.single_field_end_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) <= 60 then
            if ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):isVisible() == false then
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):setVisible(true)
            end
            state_machine.excute("sm_battleof_kings_my_general_formation_close", 0, 0)
        else
            if ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):isVisible() == true then
                ccui.Helper:seekWidgetByName(self.roots[1],"Text_zrysd"):setVisible(false)
            end
        end
    end
end

function SmBattleofKingsPrepareForTheGame:onEnterTransitionFinish()

end

function SmBattleofKingsPrepareForTheGame:onInit( )
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings_tab_2.csb")
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    if SmBattleofKingsPrepareForTheGame.__size == nil then
        SmBattleofKingsPrepareForTheGame.__size = root:getContentSize()
    end
    self:setContentSize(SmBattleofKingsPrepareForTheGame.__size)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_buzhen"), nil, 
        {
            terminal_name = "sm_battleof_kings_prepare_for_the_game_set_formation", 
            terminal_state = 0, 
            touch_black = true,
        }, nil, 0)

    if tonumber(_ED.kings_battle.kings_battle_open_type) ~= 4 then
        self:onUpdateDraw()
    else
        local function requesrDefendCheck(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                self:onUpdateDraw()
            else
                self:onUpdateDraw()    
            end
        end
        protocol_command.the_kings_battle_manager.param_list = "4"
        NetworkManager:register(protocol_command.the_kings_battle_manager.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
    end
end

function SmBattleofKingsPrepareForTheGame:init(params)
    local rootWindow = params[1] 
    self._rootWindows = rootWindow      
    self:onInit()
    return self
end

function SmBattleofKingsPrepareForTheGame:onExit()
    state_machine.remove("sm_battleof_kings_prepare_for_the_game_show")    
    state_machine.remove("sm_battleof_kings_prepare_for_the_game_hide")
    state_machine.remove("sm_battleof_kings_prepare_for_the_game_update_draw")
    state_machine.remove("sm_battleof_kings_prepare_for_the_game_close")
end
