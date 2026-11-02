-----------------------------
-- 王者之战主界面
-----------------------------
SmBattleofKingsWindow = class("SmBattleofKingsWindowClass", Window)

--打开界面
local sm_battleof_kings_window_open_terminal = {
    _name = "sm_battleof_kings_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if funOpenDrawTip(81) == true then
            return
        end
        if fwin:find("SmBattleofKingsWindowClass") == nil then
            fwin:open(SmBattleofKingsWindow:new():init(), fwin._ui)     
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local sm_battleof_kings_window_close_terminal = {
    _name = "sm_battleof_kings_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- fwin:close(fwin:find("UserTopInfoAClass"))
        fwin:close(fwin:find("SmBattleofKingsWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battleof_kings_window_open_terminal)
state_machine.add(sm_battleof_kings_window_close_terminal)
state_machine.init()

function SmBattleofKingsWindow:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0
    self._main_stadium = nil
    self._my_schedule = nil
    self._review = nil
    self._isBattle = nil

    self._activity_times = 0
    
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsSignUp")
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsReview")
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsPrepareForTheGame")
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsInTheGame")
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsRule")
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsExchange")

    local function init_sm_battleof_kings_terminal()
        local sm_battleof_kings_change_page_terminal = {
            _name = "sm_battleof_kings_change_page",
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
        
        local sm_battleof_kings_open_my_schedule_terminal = {
            _name = "sm_battleof_kings_open_my_schedule",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.kings_battle.kings_battle_open_type) ~= 0 and (tonumber(_ED.kings_battle.kings_battle_type) == 1 or tonumber(_ED.kings_battle.kings_battle_type) == 2) then
                    --报名中
                    instance:changeSelectPage(params._datas._page)
                elseif tonumber(_ED.kings_battle.kings_battle_open_type) ~= 0 and (tonumber(_ED.kings_battle.kings_battle_type) == 3 or tonumber(_ED.kings_battle.kings_battle_type) == 4) then  --比赛中，被淘汰
                    instance:changeSelectPage(params._datas._page)
                else
                    --还没报名
                    TipDlg.drawTextDailog(_new_interface_text[151])
                    return
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        
        local sm_battleof_kings_open_Looking_back_yesterday_terminal = {
            _name = "sm_battleof_kings_open_Looking_back_yesterday",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if tonumber(_ED.kings_battle.kings_battle_open_type) ~= 4 then
                    --还么开始战斗
                    instance:changeSelectPage(params._datas._page)
                else
                    --开始战斗了
                    TipDlg.drawTextDailog(_new_interface_text[128])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_battleof_kings_open_system_ranking_terminal = {
            _name = "sm_battleof_kings_open_system_ranking",
            _init = function (terminal)
                app.load("client.l_digital.system.SmRankingMainInterface")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil and response.node.roots[1] ~= nil then
                            if _ED.battle_kings_score_rank ~= nil and _ED.battle_kings_score_rank.other_user ~= nil and #_ED.battle_kings_score_rank.other_user > 0 then
                                state_machine.excute("sm_ranking_main_interface_open", 0, 6)
                            else
                                TipDlg.drawTextDailog(_new_interface_text[334])
                            end
                        end
                    end
                end

                -- 只查找1个数据
                local m_type = 7
                protocol_command.order_get_info.param_list = m_type.."\r\n".."1".."\r\n".."1"
                NetworkManager:register(protocol_command.order_get_info.code, nil, nil, nil, instance, responseCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battleof_kings_change_page_terminal)
        state_machine.add(sm_battleof_kings_open_my_schedule_terminal)
        state_machine.add(sm_battleof_kings_open_Looking_back_yesterday_terminal)
        state_machine.add(sm_battleof_kings_open_system_ranking_terminal)
        state_machine.init()
    end
    init_sm_battleof_kings_terminal()
end

function SmBattleofKingsWindow:changeSelectPage( page )
    if _ED.kings_battle.enterBattleFromKingsReview == true then
        page = 3
    end
    _ED.kings_battle.enterBattleFromKingsReview = false

    local root = self.roots[1]
    local Panel_tab = ccui.Helper:seekWidgetByName(root, "Panel_tab")
    local Button_tab_1 = ccui.Helper:seekWidgetByName(root, "Button_tab_1")
    local Button_tab_2 = ccui.Helper:seekWidgetByName(root, "Button_tab_2")
    local Button_tab_3 = ccui.Helper:seekWidgetByName(root, "Button_tab_3")
    if page == self._current_page then
        if page == 1 then
            Button_tab_1:setHighlighted(true)
        elseif page == 2 then
            Button_tab_2:setHighlighted(true)
        elseif page == 3 then
            Button_tab_3:setHighlighted(true)
        end
        return
    end
    self._current_page = page
    Button_tab_1:setHighlighted(false)
    Button_tab_2:setHighlighted(false)
    Button_tab_3:setHighlighted(false)
    state_machine.excute("sm_battleof_kings_sign_up_hide", 0, nil)
    -- state_machine.excute("sm_battleof_kings_prepare_for_the_game_hide", 0, nil)
    state_machine.excute("sm_battleof_kings_prepare_for_the_game_close", 0, nil)
    state_machine.excute("sm_battleof_kings_review_hide", 0, nil)
    state_machine.excute("sm_battleof_kings_in_the_game_hide", 0, nil)
    
    if page == 1 then
        Button_tab_1:setHighlighted(true)
        if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
            --已经开始打了
            if fwin:find("SmBattleofKingsReviewClass") ~= nil then
                fwin:close(fwin:find("SmBattleofKingsReviewClass"))
            end
            if fwin:find("SmBattleofKingsInTheGameClass") ~= nil then
                fwin:close(fwin:find("SmBattleofKingsInTheGameClass"))
            end
            -- if self._isBattle == nil then
                if (tonumber(_ED.kings_battle.kings_battle_next_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))) <= 15*60 then
                    --巅峰的
                    state_machine.excute("sm_battleof_kings_review_window_open", 0, {Panel_tab})
                else
                    state_machine.excute("sm_battleof_kings_in_the_game_window_open", 0, {Panel_tab})
                end
            -- else
   --              if tonumber(_ED.kings_battle.activity_remaining_cd)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)) <= 20*60 then
   --                  --巅峰的
   --                  state_machine.excute("sm_battleof_kings_review_show", 0, nil)
   --              else
   --               state_machine.excute("sm_battleof_kings_in_the_game_show", 0, nil)
   --              end
            -- end
        else
            --还没开打
            if fwin:find("SmBattleofKingsSignUpClass") ~= nil then
                fwin:close(fwin:find("SmBattleofKingsSignUpClass"))
            end
            state_machine.excute("sm_battleof_kings_sign_up_window_open", 0, {Panel_tab})
        end
        
    elseif page == 2 then
        Button_tab_2:setHighlighted(true)
        -- if self._my_schedule == nil then
            self._my_schedule = state_machine.excute("sm_battleof_kings_prepare_for_the_game_window_open", 0, {Panel_tab})
        -- else
        --     state_machine.excute("sm_battleof_kings_prepare_for_the_game_show", 0, nil)
        -- end
    else
        Button_tab_3:setHighlighted(true)
        if self._review == nil then
            self._review = state_machine.excute("sm_battleof_kings_review_window_open", 0, {Panel_tab})
        else
            state_machine.excute("sm_battleof_kings_review_show", 0, nil)
        end
    end
end

function SmBattleofKingsWindow:init()
    self:setTouchEnabled(true)
    self:onInit()
    return self
end

function SmBattleofKingsWindow:onInit()
    local csbItem = csb.createNode("campaign/BattleofKings/battle_of_kings.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_wzzz_back"), nil, 
    {
        terminal_name = "sm_battleof_kings_window_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --主赛场
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_1"), nil, 
    {
        terminal_name = "sm_battleof_kings_change_page", 
        terminal_state = 0, 
        _page = 1,
    }, nil, 1)
    
    --我的赛程
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_2"), nil, 
    {
        terminal_name = "sm_battleof_kings_open_my_schedule", 
        terminal_state = 0, 
        _page = 2,
    }, nil, 1)

    --昨日回顾
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_tab_3"), nil, 
    {
        terminal_name = "sm_battleof_kings_open_Looking_back_yesterday", 
        terminal_state = 0, 
        _page = 3,
    }, nil, 1)
    
    --兑换
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_duihuan"), nil, 
    {
        terminal_name = "sm_battleof_kings_exchange_open", 
        terminal_state = 0, 
        from_type = 1,
    }, nil, 1)
    
    --排行
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_ranking"), nil, 
    {
        terminal_name = "sm_battleof_kings_open_system_ranking", 
        terminal_state = 0, 
    }, nil, 1)
    
    --规则
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_guize"), nil, 
    {
        terminal_name = "sm_battleof_kings_rule_open", 
        terminal_state = 0, 
    }, nil, 1)

    
    local function requesrDefendCheck(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 or tonumber(_ED.kings_battle.kings_battle_open_type) == 1 or tonumber(_ED.kings_battle.kings_battle_open_type) == 2 then
                self:changeSelectPage(1)
            elseif tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
                if tonumber(_ED.kings_battle.kings_battle_type) == 0 then  --没报名
                    self:changeSelectPage(1)
                else
                    if tonumber(_ED.kings_battle.peak_number) > 0 then
                        self:changeSelectPage(1)
                    else
                        self:changeSelectPage(2)
                    end
                end  
            else
                self:changeSelectPage(1)
            end
            self:timingUpdate()
        else
           self:changeSelectPage(1) 
           self:timingUpdate()
        end
    end
    NetworkManager:register(protocol_command.the_kings_battle_init.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  

    local userinfo = UserTopInfoA:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)
end

function SmBattleofKingsWindow:timingUpdate()
    local m_times = tonumber(_ED.kings_battle.kings_battle_next_time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))+0.5
    if tonumber(_ED.kings_battle.kings_battle_open_type) == 4 and m_times-0.5 > 15*60 then
        m_times = m_times - 15*60
    end
    if m_times < 0 then
        m_times = 60
    end
    fwin:addService({
        callback = function ( params )
            if params ~= nil and params.roots ~= nil and params.roots[1] ~= nil then
                local function requesrDefendCheck(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        self._current_page = 0
                        if tonumber(_ED.kings_battle.kings_battle_open_type) == 0 or tonumber(_ED.kings_battle.kings_battle_open_type) == 1 or tonumber(_ED.kings_battle.kings_battle_open_type) == 2 then
                            self:changeSelectPage(1)
                        elseif tonumber(_ED.kings_battle.kings_battle_open_type) == 4 then
                            if tonumber(_ED.kings_battle.kings_battle_type) == 0 then  --没报名
                                self:changeSelectPage(1)
                            else
                                if tonumber(_ED.kings_battle.peak_number) > 0 then
                                    self:changeSelectPage(1)
                                else
                                    self:changeSelectPage(2)
                                end
                            end  
                        else
                            self:changeSelectPage(1)
                        end
                        self:timingUpdate()
                    else
                        if self._current_page ~= 1 then
                           self:changeSelectPage(1) 
                        end
                    end
                end
                NetworkManager:register(protocol_command.the_kings_battle_init.code, nil, nil, nil, self, requesrDefendCheck, false, nil)  
            end
        end,
        delay = m_times,
        params = self
    })
end

function SmBattleofKingsWindow:onEnterTransitionFinish()
    
end

function SmBattleofKingsWindow:onExit()
    state_machine.remove("sm_battleof_kings_change_page")
end

function SmBattleofKingsWindow:destroy( window )
    if nil ~= sp.SkeletonRenderer.clear then
        sp.SkeletonRenderer:clear()
    end
    audioUtilUncacheAll()
    cacher.cleanSystemCacher()
end