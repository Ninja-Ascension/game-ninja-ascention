UnionFightingMain = class("UnionFightingMainClass", Window)

local union_fighting_main_open_terminal = {
	_name = "union_fighting_main_open",
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
            TipDlg.drawTextDailog(tipStringInfo_union_str[113])
            state_machine.excute("union_unlock_state_machine", 0, nil)
            return
        end

        if funOpenDrawTip(82) == true then
            state_machine.excute("union_unlock_state_machine", 0, nil)
            return
        end
        if funOpenDrawTip(149) == true then
            state_machine.excute("union_unlock_state_machine", 0, nil)
            return
        end
        local server_time = _ED.system_time + (os.time() - _ED.native_time) - _ED.GTM_Time
        if _ED.union ~= nil 
            and _ED.union.user_union_info ~= nil 
            and _ED.union.user_union_info.union_last_enter_time ~= nil 
            and _ED.union.user_union_info.union_last_enter_time - server_time > 0 then
            TipDlg.drawTextDailog(_new_interface_text[195])
            state_machine.excute("union_unlock_state_machine", 0, nil)
            return
        end
        local function responseUnionInitCallback(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if fwin:find("UnionFightingMainClass") == nil then
                    if params == nil then
                        _ED.unionFightingOpenByUnion = true
                    else
                        _ED.unionFightingOpenByUnion = false
                    end
                    
                    fwin:open(UnionFightingMain:new():init(params), fwin._ui)
                end
            else
                state_machine.excute("union_unlock_state_machine", 0, nil)
            end
        end
        if params ~= nil and params.notReqeust == true then
            if fwin:find("UnionFightingMainClass") == nil then
                NetworkManager:register(protocol_command.union_warfare_init.code, nil, nil, nil, nil, nil, false, nil)
                fwin:open(UnionFightingMain:new():init(params), fwin._ui)
            end
        else
            _ED.union.union_fight_reports = {}
            NetworkManager:register(protocol_command.union_warfare_init.code, nil, nil, nil, nil, responseUnionInitCallback, false, nil)
        end
        return true
	end,
	_terminal = nil,
	_terminals = nil
}

local union_fighting_main_close_terminal = {
	_name = "union_fighting_main_close",
	_init = function (terminal)
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
        state_machine.excute("union_unlock_state_machine", 0, nil)
        NetworkManager:register(protocol_command.union_warfare_exit.code, nil, nil, nil, nil, nil, false, nil)
		fwin:close(fwin:find("UnionFightingMainClass"))
        if _ED.unionFightingOpenByUnion == true then
            state_machine.excute("Union_open", 0, nil)
        else
            if fwin:find("CampaignClass") == nil then
                state_machine.excute("campaign_window_open", 0, nil)
            end
        end

        if fwin:find("HeroIconListViewClass") ~= nil then
            fwin:find("HeroIconListViewClass"):setVisible(true)
        end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_fighting_main_open_terminal)
state_machine.add(union_fighting_main_close_terminal)
state_machine.init()

function UnionFightingMain:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

    self._current_page = 0
    self._dule_panel = nil  -- 主赛场
    self._dule_info_panel = nil
    self._dule_report_panel = nil

    app.load("client.l_digital.union.unionFighting.UnionFightFormation")
    app.load("client.l_digital.union.unionFighting.UnionFightingInfo")
    app.load("client.l_digital.union.unionFighting.UnionFightReport")
    app.load("client.l_digital.union.unionFighting.UnionFightingRank")
    app.load("client.l_digital.union.unionFighting.UnionFightingJoin")
    app.load("client.l_digital.union.unionFighting.UnionFightingRule")
    app.load("client.l_digital.union.unionFighting.UnionFightingAllRank")
    app.load("client.l_digital.union.unionFighting.UnionFightingDule")
    app.load("client.l_digital.union.unionFighting.UnionFightingDuleInfo")
    app.load("client.l_digital.union.unionFighting.UnionFightingDuleReport")

    app.load("client.l_digital.cells.union.unionFighting.union_fighting_join_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_union_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_report_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_round_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_report_time_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_report_ex_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_round_ex_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_report_time_ex_cell")
    app.load("client.l_digital.cells.union.unionFighting.union_fighting_formation_icon")

    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsExchange")
    app.load("client.l_digital.campaign.battleofKings.SmBattleofKingsBetting")
    app.load("client.l_digital.union.player.smUnionUserTopInfo")

    local function init_union_fight_main_terminal()
        local union_fight_main_update_state_terminal = {
            _name = "union_fight_main_update_state",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_main_change_page_terminal = {
            _name = "union_fight_main_change_page",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil then
                    instance:changePage(params._datas.page)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fight_main_update_state_terminal)
        state_machine.add(union_fight_main_change_page_terminal)
        state_machine.init()
    end
    init_union_fight_main_terminal()
end

function UnionFightingMain:changePage(page)
    if tonumber(_ED.union.union_fight_battle_info.battle_times) ~= 5 
        or tonumber(_ED.union.union_fight_battle_info.state) ~= 4 then
        return
    end
    if page == 2 then
        if _ED.union.union_fight_duel_info.user_battle_type == nil then
            TipDlg.drawTextDailog(tipStringInfo_union_str[107])
            return
        end
    end
    local root = self.roots[1]
    self._current_page = page

    local Panel_tab_l = ccui.Helper:seekWidgetByName(root, "Panel_tab_l")
    local Panel_tab_r = ccui.Helper:seekWidgetByName(root, "Panel_tab_r")
    local Panel_tab_3 = ccui.Helper:seekWidgetByName(root, "Panel_tab_3")

    Panel_tab_l:setVisible(false)
    Panel_tab_r:setVisible(false)
    state_machine.excute("union_fighting_dule_hide", 0, "")
    if page == 1 then
        if self._dule_panel == nil then
            Panel_tab_3:removeAllChildren(true)
            self._dule_panel = state_machine.excute("union_fighting_dule_window_open", 0, {Panel_tab_3})
        end
        state_machine.excute("union_fighting_dule_show", 0, "")
    else
        if self._dule_report_panel == nil then
            Panel_tab_r:removeAllChildren(true)
            self._dule_panel = state_machine.excute("union_fighting_join_window_open", 0, {Panel_tab_r})
        end
        if self._dule_info_panel == nil then
            Panel_tab_l:removeAllChildren(true)
            self._dule_panel = state_machine.excute("union_fighting_dule_info_window_open", 0, {Panel_tab_l})
        end
        Panel_tab_l:setVisible(true)
        Panel_tab_r:setVisible(true)
    end
end

function UnionFightingMain:updateDraw()
	local root = self.roots[1]
	if root == nil then
		return
	end
    
    local Panel_tab_l = ccui.Helper:seekWidgetByName(root, "Panel_tab_l")
    local Panel_tab_r = ccui.Helper:seekWidgetByName(root, "Panel_tab_r")
    local Panel_tab_3 = ccui.Helper:seekWidgetByName(root, "Panel_tab_3")
    local Panel_ghz_ks_p = ccui.Helper:seekWidgetByName(root, "Panel_ghz_ks_p")
    Panel_ghz_ks_p:setVisible(false)
    Panel_tab_r:removeAllChildren(true)
    Panel_tab_l:removeAllChildren(true)
    Panel_tab_3:removeAllChildren(true)

    if tonumber(_ED.union.union_fight_battle_info.state) == 3
        or tonumber(_ED.union.union_fight_battle_info.state) == 4
        or tonumber(_ED.union.union_fight_battle_info.state) == 5
        then
        local Text_hgz_c_n = ccui.Helper:seekWidgetByName(root, "Text_hgz_c_n")
        local Text_9_0 = ccui.Helper:seekWidgetByName(root, "Text_9_0")
        local Panel_ghz_c_t = ccui.Helper:seekWidgetByName(root, "Panel_ghz_c_t")
        Panel_ghz_ks_p:setVisible(true)
        Panel_tab_3:removeAllChildren(true)
        self._dule_panel = nil
        self._dule_info_panel = nil
        self._dule_report_panel = nil
        Panel_ghz_c_t:removeBackGroundImage()
        Text_hgz_c_n:setString("")
        if tonumber(_ED.union.union_fight_battle_info.battle_times) == -1 then
            Text_9_0:setString("")
        else
            Text_9_0:setString(tipStringInfo_union_str[tonumber(_ED.union.union_fight_battle_info.battle_times) + 79])
            if tonumber(_ED.union.union_fight_battle_info.battle_times) <= 3 then
                Text_hgz_c_n:setString(string.format(tipStringInfo_union_str[85], tonumber(_ED.union.union_fight_battle_info.battle_times)))
                Panel_ghz_c_t:setBackGroundImage("images/ui/text/GHZ_res/zy_ss_t_1.png")
            elseif tonumber(_ED.union.union_fight_battle_info.battle_times) == 4 then
                Panel_ghz_c_t:setBackGroundImage("images/ui/text/GHZ_res/zy_ss_t_2.png")
            elseif tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
                Panel_ghz_c_t:setBackGroundImage("images/ui/text/GHZ_res/zy_ss_t_3.png")
            end
        end
        if tonumber(_ED.union.union_fight_battle_info.state) == 3
            or tonumber(_ED.union.union_fight_battle_info.state) == 4
            then
            state_machine.excute("union_fight_report_window_close", 0, nil)
            if tonumber(_ED.union.union_fight_battle_info.state) == 4 and tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
            else
                state_machine.excute("union_fighting_join_window_open", 0, {Panel_tab_r})
                state_machine.excute("union_fighting_info_window_open", 0, {Panel_tab_l})
            end
        elseif tonumber(_ED.union.union_fight_battle_info.state) == 5 then
            Text_hgz_c_n:setString("")
            Panel_tab_l:removeAllChildren(true)
            state_machine.excute("union_fighting_rank_window_open", 0, {Panel_tab_3})
        end
    else
        Panel_tab_3:removeAllChildren(true)
        state_machine.excute("union_fighting_join_window_open", 0, {Panel_tab_r})
        state_machine.excute("union_fighting_info_window_open", 0, {Panel_tab_l})
    end

    local Button_tab_3 = ccui.Helper:seekWidgetByName(root, "Button_tab_3")         -- 主赛场
    local Button_tab_4 = ccui.Helper:seekWidgetByName(root, "Button_tab_4")         -- 公会战况
    Button_tab_3:setVisible(false)
    Button_tab_4:setVisible(false)

    if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5
        and tonumber(_ED.union.union_fight_battle_info.state) == 4 
        then
        Button_tab_3:setVisible(true)
        Button_tab_4:setVisible(true)
        Panel_ghz_ks_p:setVisible(false)
        self:changePage(1)
    end
end

function UnionFightingMain:onInit()
	local csbUnion = csb.createNode(config_csb.union_fight.sm_legion_ghz)
    local root = csbUnion:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnion)

    if fwin:find("HeroIconListViewClass") ~= nil then
        fwin:find("HeroIconListViewClass"):setVisible(false)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wzzz_back"), nil, 
    {
        terminal_name = "union_fighting_main_close", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_1"), nil, 
    {
        terminal_name = "union_fight_formation_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_2"), nil, 
    {
        terminal_name = "union_fight_report_window_open", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        battle_type = 1,
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_duihuan"), nil, 
    {
        terminal_name = "sm_battleof_kings_exchange_open", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        from_type = 2,
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ranking"), nil, 
    {
        terminal_name = "union_fighting_all_rank_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_guize"), nil, 
    {
        terminal_name = "union_fighting_rule_open", 
        terminal_state = 0,
        isPressedActionEnabled = true
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_3"), nil, 
    {
        terminal_name = "union_fight_main_change_page", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        page = 1,
    }, 
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_tab_4"), nil, 
    {
        terminal_name = "union_fight_main_change_page", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        page = 2,
    }, 
    nil, 0)
    state_machine.excute("sm_union_user_topinfo_open",0,self)
    
    self:updateDraw()
end

function UnionFightingMain:onEnterTransitionFinish()
end

function UnionFightingMain:init(params)
    self:onInit()
	return self
end

function UnionFightingMain:onExit()
    state_machine.remove("union_fight_main_update_state")
    state_machine.remove("union_fight_main_change_page")
end
