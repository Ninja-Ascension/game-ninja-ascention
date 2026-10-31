-- ---------------------------
-- 工会战-战斗准备
-- ---------------------------
UnionFightingJoin = class("UnionFightingJoinClass", Window)

local union_fighting_join_window_open_terminal = {
    _name = "union_fighting_join_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if fwin:find("UnionFightingJoinClass") == nil then
            local panel = UnionFightingJoin:new():init(params)
            fwin:open(panel)
            return panel
        end
        return nil
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fighting_join_window_open_terminal)
state_machine.init()

function UnionFightingJoin:ctor()
    self.super:ctor()
    self.roots = {}
    self._last_state = 0

    self._show_round = 0
    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0
    self._tick_time = 0
    self._next_round_cell = nil

    self._need_update_state = false
    self._show_end_state = true
    self._show_index = 0

    self._report_info_list = nil    -- 当前查看战报

    self._dule_match_info = nil     -- 决赛战况
    self._battle_count = 1          -- 当前战场

    local function init_union_fighting_join_terminal()
        local union_fighting_join_update_draw_terminal = {
            _name = "union_fighting_join_update_draw",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                if tonumber(_ED.union.union_fight_battle_info.state) == 3
                    or tonumber(_ED.union.union_fight_battle_info.state) == 4
                    then
                    if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                        instance._need_update_state = true
                        instance:addReport()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_join_update_join_state_terminal = {
            _name = "union_fighting_join_update_join_state",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:updateJoinInfo()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fighting_join_request_join_terminal = {
            _name = "union_fighting_join_request_join",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function responseUnionInitCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        TipDlg.drawTextDailog(tipStringInfo_union_str[71])
                    else
                        state_machine.excute("union_fighting_join_update_join_state", 0, nil)
                    end
                end
                protocol_command.union_warfare_manager.param_list = "0\r\n0\r\n0"
                NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, instance, responseUnionInitCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新决赛战况
        local union_fighting_join_update_dule_report_terminal = {
            _name = "union_fighting_join_update_dule_report",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance._dule_match_info = _ED.union.union_fight_duel_match_info
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 选择决赛战场
        local union_fighting_join_change_dule_battle_count_terminal = {
            _name = "union_fighting_join_change_dule_battle_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                    instance:changeDuleBattleCount(params[1])
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fighting_join_update_draw_terminal)
        state_machine.add(union_fighting_join_update_join_state_terminal)
        state_machine.add(union_fighting_join_request_join_terminal)
        state_machine.add(union_fighting_join_update_dule_report_terminal)
        state_machine.add(union_fighting_join_change_dule_battle_count_terminal)
        state_machine.init()
    end
    init_union_fighting_join_terminal()
end

function UnionFightingJoin:changeDuleBattleCount(battle_count)
    self._battle_count = battle_count

    self._show_round = 0
    self._show_index = 1
    self._show_end_state = true
    self:stopAllActions()
    self:updateDraw()
end

function UnionFightingJoin:loading_cell( ... )
    if self._list_view == nil then
        return
    end

    local myUnionIsEnd = true
    local fightIsEnd = false         -- 比赛结束

    local report_info_list = nil     -- 显示战报
    if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
        myUnionIsEnd = false
        fightIsEnd = false
        if self._dule_match_info ~= nil then
            local battle_info = self._dule_match_info.battle_list[self._battle_count]
            report_info_list = battle_info.report_info_list
            if #report_info_list == battle_info.total_round then
                myUnionIsEnd = true
                fightIsEnd = true
            end
        end
    else
        local current_total_count = 0
        for k,v in pairs(_ED.union.union_fight_member_info) do
            if tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
                if tonumber(v.current_num) > 0 then
                    myUnionIsEnd = false
                end
            end
            current_total_count = current_total_count + tonumber(v.current_num)
        end
        if current_total_count <= 1 then
            fightIsEnd = true
            myUnionIsEnd = true
        end

        report_info_list = _ED.union.union_fight_reports
    end

    local roundInfo = report_info_list[self._show_round]
    if self._show_index <= #roundInfo.report_list then
        self:removeListViewCell(self._round_cell)
        self:removeListViewCell(self._time_cell)
        self._round_cell = nil
        self._time_cell = nil

        local index = #self._list_view:getItems() + 1

        local cell = state_machine.excute("union_fighting_report_cell_create", 0, {index, roundInfo.report_list[self._show_index], self._show_index})
        self:insertListViewCellTop(cell)

        if self._show_index == #roundInfo.report_list then
            -- if fightIsEnd == true then
                -- 公会战结束
            -- else
                local cell = state_machine.excute("union_fighting_report_time_cell_create", 0, {nil, self._show_round, myUnionIsEnd})
                self:insertListViewCellTop(cell)
                self._time_cell = cell
            -- end
        end

        local cell = state_machine.excute("union_fighting_round_cell_create", 0, {self._show_round})
        self:insertListViewCellTop(cell)
        self._round_cell = cell
    else
        -- 显示下一轮
        if fightIsEnd == false and myUnionIsEnd == false then
            self._tick_time = roundInfo.next_begin_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
            local cell = state_machine.excute("union_fighting_report_time_cell_create", 0, {self._tick_time + (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)), self._show_round + 1, myUnionIsEnd})
            self:insertListViewCellTop(cell)
            self._time_cell = cell
            local cell = state_machine.excute("union_fighting_round_cell_create", 0, {self._show_round + 1})
            self:insertListViewCellTop(cell)
            self._round_cell = cell
        end
        self._show_end_state = true
    end
    self._show_index = self._show_index + 1

    self._list_view:requestRefreshView()
    self._list_view:jumpToTop()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
end

function UnionFightingJoin:addReport( ... )
    if self._tick_time <= 0 and self._need_update_state == true and self._show_end_state == true then
    else
        return
    end
    self._need_update_state = false

    local report_info_list = {}     -- 显示战报
    if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
        if self._dule_match_info ~= nil then
            local battle_info = self._dule_match_info.battle_list[self._battle_count]
            report_info_list = battle_info.report_info_list
        end
    else
        report_info_list = _ED.union.union_fight_reports
    end

    local items = self._list_view:getItems()
    local index = #items
    if self._show_round ~= #report_info_list then
        self._show_round = #report_info_list
        local roundInfo = report_info_list[self._show_round]
        self._show_index = 1
        self._show_end_state = false
        for i = 1, #roundInfo.report_list + 1 do
            self:runAction(cc.Sequence:create(
                cc.DelayTime:create((i - 1)*0.7),
                cc.CallFunc:create(function(sender)
                    if sender ~= nil and sender.roots ~= nil and sender.roots[1] ~= nil then
                        sender:loading_cell()
                    end
                end)
                ))
        end
        self._tick_time = roundInfo.next_begin_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:jumpToTop()
end

function UnionFightingJoin:updateDraw()
    local root = self.roots[1]
    local ListView_ghz_zk = ccui.Helper:seekWidgetByName(root, "ListView_ghz_zk")
    self._list_view = ListView_ghz_zk
    self._list_view:jumpToTop()
    self._list_view:removeAllItems()

    self._show_round = 0
    if tonumber(_ED.union.union_fight_battle_info.state) == 3 then
        -- 准备中
        self._tick_time = tonumber(_ED.union.union_fight_battle_info.time)/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
        local cell = state_machine.excute("union_fighting_report_time_cell_create", 0, {self._tick_time + (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)), self._show_round + 1, false})
        self:insertListViewCellTop(cell)
        self._time_cell = cell
        if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
            -- 公会战决赛准备中
            local cell = state_machine.excute("union_fighting_round_cell_create", 0, {0})
            self:insertListViewCellTop(cell)
            self._round_cell = cell
        else
            local cell = state_machine.excute("union_fighting_round_cell_create", 0, {self._show_round + 1})
            self:insertListViewCellTop(cell)
            self._round_cell = cell
        end
    else
        local myUnionIsEnd = true
        local myUnionIsJoin = false      -- 公会是否有参赛
        local fightIsEnd = false         -- 比赛结束

        local report_info_list = nil     -- 显示战报
        local result_info = nil         
        if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
            myUnionIsEnd = false
            fightIsEnd = false
            myUnionIsJoin = true
            if self._dule_match_info ~= nil then
                local battle_info = self._dule_match_info.battle_list[self._battle_count]
                report_info_list = battle_info.report_info_list
                if #report_info_list == battle_info.total_round then
                    myUnionIsEnd = true
                    fightIsEnd = true
                end

                local left_info = nil
                local right_info = nil
                local match_pos = zstring.split(self._dule_match_info.match_pos, ",")
                local battle_type = tonumber(self._dule_match_info.battle_type)
                if battle_type == 1 then
                    for k, v in pairs(_ED.union.union_fight_duel_info.battle_info[""..battle_type]) do
                        if tonumber(k) <= 4 and v.position == tonumber(match_pos[1]) then
                            left_info = v
                        elseif tonumber(k) <= 8 and v.position == tonumber(match_pos[2]) then
                            right_info = v
                        end
                    end
                else
                    left_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[1]]
                    right_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[2]]
                end
                result_info = {}
                local current_num = zstring.split(battle_info.current_num_info, ",")
                if tonumber(current_num[1]) > tonumber(current_num[2]) then
                    result_info.win_union = left_info.union_name
                    result_info.lose_union = right_info.union_name
                else
                    result_info.win_union = right_info.union_name
                    result_info.lose_union = left_info.union_name
                end
                result_info.report_count = battle_info.total_round
            end
        else
            local current_total_count = 0
            for k,v in pairs(_ED.union.union_fight_member_info) do
                if tonumber(v.union_id) == tonumber(_ED.union.union_info.union_id) then
                    myUnionIsJoin = true
                    if tonumber(v.current_num) > 0 then
                        myUnionIsEnd = false
                    end
                end
                current_total_count = current_total_count + tonumber(v.current_num)
            end
            if current_total_count <= 1 then
                fightIsEnd = true
                myUnionIsEnd = true
            end

            report_info_list = _ED.union.union_fight_reports
        end

        local index = 0
        if report_info_list ~= nil and #report_info_list > 0 then
            for round, roundInfo in pairs(report_info_list) do
                if self._show_round < round then
                    self._show_round = round
                end
                for k,v in pairs(roundInfo.report_list) do
                    index = index + 1
                    local cell = state_machine.excute("union_fighting_report_cell_create", 0, {index, v, k})
                    self:insertListViewCellTop(cell)
                end
                local isLastInfo = myUnionIsEnd
                if myUnionIsEnd == true then
                    isLastInfo = #report_info_list == round
                end
                local cell = state_machine.excute("union_fighting_report_time_cell_create", 0, {nil, round, isLastInfo, result_info})
                self:insertListViewCellTop(cell)
                self._time_cell = cell
                local cell = state_machine.excute("union_fighting_round_cell_create", 0, {round})
                self:insertListViewCellTop(cell)
                self._round_cell = cell
                self._tick_time = roundInfo.next_begin_time/1000 - (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time))
            end
        else
            self._tick_time = 0
        end

        if myUnionIsJoin == false then
            -- 公会没有成员参加公会战
            local cell = state_machine.excute("union_fighting_report_time_cell_create", 0, {nil, self._show_round + 1, myUnionIsEnd, {union_is_join = false}})
            self:insertListViewCellTop(cell)
            self._time_cell = cell
        elseif fightIsEnd == false and myUnionIsEnd == false then
            if self._tick_time > 0 then
                local cell = state_machine.excute("union_fighting_report_time_cell_create", 0, {self._tick_time + (tonumber(_ED.system_time)+os.time()-tonumber(_ED.native_time)), self._show_round + 1, myUnionIsEnd})
                self:insertListViewCellTop(cell)
                self._time_cell = cell
                local cell = state_machine.excute("union_fighting_round_cell_create", 0, {self._show_round + 1})
                self:insertListViewCellTop(cell)
                self._round_cell = cell
            end
        end
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()
    self._list_view:jumpToTop()
end

function UnionFightingJoin:insertListViewCellTop(cell)
    if self._list_view ~= nil then
        if #self._list_view:getItems() == 0 then
            self._list_view:addChild(cell)
        else
            self._list_view:insertCustomItem(cell, 0)
        end
    end
end

function UnionFightingJoin:removeListViewCell(cell)
    local index = 0
    if self._list_view ~= nil and cell ~= nil then
        for k, v in pairs(self._list_view:getItems()) do
            if cell == v then
                index = k
                break
            end
        end
        if index > 0 then
            self._list_view:removeItem(index - 1)
        end
    end
end

function UnionFightingJoin:onUpdate(dt)
    self._tick_time = self._tick_time - dt
    if self._tick_time <= 0 then
        self._tick_time = 0
        self:addReport()
    end
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        self._list_view_poy = posY
        local items = self._list_view:getItems()
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

function UnionFightingJoin:updateJoinInfo( ... )
    if tonumber(_ED.union.union_fight_battle_info.state) == 3
        or tonumber(_ED.union.union_fight_battle_info.state) == 4
        then
        return
    end
    local root = self.roots[1]
    local Button_ghz_bm = ccui.Helper:seekWidgetByName(root, "Button_ghz_bm")
    local Text_ghz_bm_p = ccui.Helper:seekWidgetByName(root, "Text_ghz_bm_p")
    local Panel_ghz_num_t = ccui.Helper:seekWidgetByName(root, "Panel_ghz_num_t")
    local Button_ghz_stake = ccui.Helper:seekWidgetByName(root, "Button_ghz_stake")
    local Text_ghz_time = ccui.Helper:seekWidgetByName(root, "Text_ghz_time")
    local Panel_ghz_s_t = ccui.Helper:seekWidgetByName(root, "Panel_ghz_s_t")
    local Panel_ghz_s_anm = ccui.Helper:seekWidgetByName(root, "Panel_ghz_s_anm")
    local Panel_ghz_dh_di = ccui.Helper:seekWidgetByName(root, "Panel_ghz_dh_di")
    local Panel_ghz_dh_ding = ccui.Helper:seekWidgetByName(root, "Panel_ghz_dh_ding")
    Button_ghz_stake:setVisible(false)
    Panel_ghz_s_t:removeBackGroundImage()
    Panel_ghz_num_t:removeBackGroundImage()
    Panel_ghz_s_anm:removeBackGroundImage()
    Panel_ghz_dh_di:removeAllChildren(true)
    Panel_ghz_dh_ding:removeAllChildren(true)
    if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
        Panel_ghz_s_anm:setBackGroundImage("images/ui/text/GHZ_res/ghz_open_bg2.png")
        local jsonFile = "images/ui/effice/effect_union_war_finals_ground/effect_union_war_finals_ground.json"
        local atlasFile = "images/ui/effice/effect_union_war_finals_ground/effect_union_war_finals_ground.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_ghz_dh_di:addChild(animation)
        animation:setPosition(cc.p(Panel_ghz_dh_di:getContentSize().width/2, Panel_ghz_dh_di:getContentSize().height/2))
        local jsonFile = "images/ui/effice/effect_union_war_finals_top/effect_union_war_finals_top.json"
        local atlasFile = "images/ui/effice/effect_union_war_finals_top/effect_union_war_finals_top.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_ghz_dh_ding:addChild(animation)
        animation:setPosition(cc.p(Panel_ghz_dh_ding:getContentSize().width/2, Panel_ghz_dh_ding:getContentSize().height/2))
    else
        Panel_ghz_s_anm:setBackGroundImage("images/ui/text/GHZ_res/ghz_open_bg.png")
        local jsonFile = "images/ui/effice/effect_union_war_qualifying_ground/effect_union_war_qualifying_ground.json"
        local atlasFile = "images/ui/effice/effect_union_war_qualifying_ground/effect_union_war_qualifying_ground.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_ghz_dh_di:addChild(animation)
        animation:setPosition(cc.p(Panel_ghz_dh_di:getContentSize().width/2, Panel_ghz_dh_di:getContentSize().height/2))
        local jsonFile = "images/ui/effice/effect_union_war_qualifying_top/effect_union_war_qualifying_top.json"
        local atlasFile = "images/ui/effice/effect_union_war_qualifying_top/effect_union_war_qualifying_top.atlas"
        local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
        Panel_ghz_dh_ding:addChild(animation)
        animation:setPosition(cc.p(Panel_ghz_dh_ding:getContentSize().width/2, Panel_ghz_dh_ding:getContentSize().height/2))
    end
    if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 
        and (tonumber(_ED.union.union_fight_battle_info.state) == 1 
        or tonumber(_ED.union.union_fight_battle_info.state) == 2) 
        then
        Button_ghz_stake:setVisible(true)
    end

    if (tonumber(_ED.union.union_fight_battle_info.state) == 1 
        or tonumber(_ED.union.union_fight_battle_info.state) == 2) 
        and tonumber(_ED.union.union_fight_user_info.join_state) == 0
        then
        Button_ghz_bm:setTouchEnabled(true)
        Button_ghz_bm:setHighlighted(true)
        Button_ghz_bm:setBright(true)
    else
        Button_ghz_bm:setTouchEnabled(false)
        Button_ghz_bm:setHighlighted(false)
        Button_ghz_bm:setBright(false)
    end
    if tonumber(_ED.union.union_fight_user_info.join_state) == 0 then
        Button_ghz_bm:setTitleText(tipStringInfo_union_str[111])
    else
        Button_ghz_bm:setTitleText(tipStringInfo_union_str[112])
    end
    if tonumber(_ED.union.union_fight_battle_info.battle_times) == -1 then
        Text_ghz_bm_p:setString("")
        Panel_ghz_num_t:removeBackGroundImage()
    else
        Text_ghz_bm_p:setString(tipStringInfo_union_str[tonumber(_ED.union.union_fight_battle_info.battle_times) + 79])
        if tonumber(_ED.union.union_fight_battle_info.battle_times) <= 3 then
            Panel_ghz_num_t:setBackGroundImage("images/ui/text/GHZ_res/msz_no".._ED.union.union_fight_battle_info.battle_times..".png")
            Panel_ghz_s_t:setBackGroundImage("images/ui/text/GHZ_res/ghz_big_t_1.png")
        elseif tonumber(_ED.union.union_fight_battle_info.battle_times) == 4 then
            Panel_ghz_s_t:setBackGroundImage("images/ui/text/GHZ_res/ghz_big_t_2.png")
        elseif tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
            Panel_ghz_s_t:setBackGroundImage("images/ui/text/GHZ_res/ghz_big_t_3.png")
        end
    end

    if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5
        and tonumber(_ED.union.union_fight_battle_info.state) == 5 
        then
        Text_ghz_time:setString(tipStringInfo_union_str[96])
    else
        Text_ghz_time:setString(tipStringInfo_union_str[86])
        local union_count = dms.int(dms["union_config"], 59, union_config.param)
        if _ED.union.union_fight_union_info ~= nil then
            if tonumber(_ED.union.union_fight_battle_info.battle_times) == 5 then
                local current_rank = tonumber(_ED.union.union_fight_union_info.current_rank)
                if current_rank > union_count then
                    Text_ghz_time:setString(tipStringInfo_union_str[87])
                    Button_ghz_bm:setTouchEnabled(false)
                    Button_ghz_bm:setHighlighted(false)
                    Button_ghz_bm:setBright(false)
                end
            end
        end
    end
end

function UnionFightingJoin:onEnterTransitionFinish()

end

function UnionFightingJoin:onInit( )
    local csbItem = nil
    if tonumber(_ED.union.union_fight_battle_info.state) == 3
        or tonumber(_ED.union.union_fight_battle_info.state) == 4
        then
        csbItem = csb.createNode(string.format(config_csb.union_fight.sm_legion_ghz_tab, 4))
    else
        csbItem = csb.createNode(string.format(config_csb.union_fight.sm_legion_ghz_tab, 2))
    end
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local Button_ghz_bm = ccui.Helper:seekWidgetByName(root, "Button_ghz_bm")
    if Button_ghz_bm ~= nil then
        fwin:addTouchEventListener(Button_ghz_bm, nil, 
        {
            terminal_name = "union_fighting_join_request_join", 
            terminal_state = 0,
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end

    -- 下注
    local Button_ghz_stake = ccui.Helper:seekWidgetByName(root, "Button_ghz_stake")
    if Button_ghz_stake ~= nil then
        fwin:addTouchEventListener(Button_ghz_stake, nil, 
        {
            terminal_name = "sm_battleof_kings_betting_open", 
            terminal_state = 0,
            isPressedActionEnabled = true,
            from_type = 2,
        }, 
        nil, 0)

        state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "sm_push_notification_center_union_battle_stake",
        _widget = Button_ghz_stake,
        _invoke = nil,
        _interval = 0.5,})
    end

    if tonumber(_ED.union.union_fight_battle_info.state) == 3
        or tonumber(_ED.union.union_fight_battle_info.state) == 4
        then
        self:updateDraw()
    else
        self:updateJoinInfo()
    end
end

function UnionFightingJoin:init(params)
    local rootWindow = params[1]
    self._rootWindows = rootWindow
    self:onInit()
    return self
end

function UnionFightingJoin:onExit()
    state_machine.remove("union_fighting_join_update_draw")
    state_machine.remove("union_fighting_join_update_join_state")
    state_machine.remove("union_fighting_join_request_join")
    state_machine.remove("union_fighting_join_update_dule_report")
    state_machine.remove("union_fighting_join_change_dule_battle_count")
end
