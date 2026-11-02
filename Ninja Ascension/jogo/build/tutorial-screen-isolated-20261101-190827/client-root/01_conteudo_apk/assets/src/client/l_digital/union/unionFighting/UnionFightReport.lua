-- ---------------------------
-- 工会战-战报
-- ---------------------------
UnionFightReport = class("UnionFightReportClass", Window)

local union_fight_report_window_open_terminal = {
    _name = "union_fight_report_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local battle_type = params._datas.battle_type
        local position = params._datas.position
        if battle_type == 1 then
            if not _ED.union.union_fight_reports or table.nums(_ED.union.union_fight_reports) <= 0 then
                return
            end
            if (tonumber(_ED.union.union_fight_battle_info.battle_times) == 5
                and tonumber(_ED.union.union_fight_battle_info.state) == 5)
                or (tonumber(_ED.union.union_fight_battle_info.battle_times) <= 1
                and tonumber(_ED.union.union_fight_battle_info.state) < 3)
                then
                state_machine.excute("union_fighting_dule_report_open", 0, nil)
                return
            end
            if tonumber(_ED.union.union_fight_battle_info.state) == 3
                or tonumber(_ED.union.union_fight_battle_info.state) == 4 
                then
                TipDlg.drawTextDailog(tipStringInfo_union_str[76])
                return
            end
            
            if fwin:find("UnionFightReportClass") == nil then
                fwin:open(UnionFightReport:new():init(battle_type), fwin._ui)
            end
        else
            local look_battle_type = 0      -- 赛次
            local leftUnionId = 0
            local rightUnionId = 0
            if position <= 4 then
                look_battle_type = 0
                local index = position * 2
                local left_union = _ED.union.union_fight_duel_info.battle_info[""..look_battle_type][""..(index - 1)]
                local right_union = _ED.union.union_fight_duel_info.battle_info[""..look_battle_type][""..index]
                leftUnionId = left_union.union_id
                rightUnionId = right_union.union_id
            elseif position <= 6 then
                look_battle_type = 1
                for k, v in pairs(_ED.union.union_fight_duel_info.battle_info[""..look_battle_type]) do
                    if v.position == position + 4 then
                        if leftUnionId == 0 then
                            leftUnionId = v.union_id
                        elseif v.union_id ~= leftUnionId then
                            rightUnionId = v.union_id
                        end
                    end
                end
            else
                look_battle_type = 2
                if _ED.union.union_fight_duel_info.battle_info[""..look_battle_type] ~= nil then
                    for k,v in pairs(_ED.union.union_fight_duel_info.battle_info[""..look_battle_type]) do
                        if leftUnionId == 0 then
                            leftUnionId = v.union_id
                        else
                            rightUnionId = v.union_id
                        end
                    end
                end
            end
            local function responseCallback(response)
                if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                    if fwin:find("UnionFightReportClass") == nil then
                        fwin:open(UnionFightReport:new():init(battle_type), fwin._ui)
                    end
                end
            end
            protocol_command.union_warfare_manager.param_list = "6\r\n5\r\n"..(leftUnionId..","..rightUnionId).."\r\n"..look_battle_type
            NetworkManager:register(protocol_command.union_warfare_manager.code, nil, nil, nil, nil, responseCallback, false, nil)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local union_fight_report_window_close_terminal = {
    _name = "union_fight_report_window_close",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("UnionFightReportClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(union_fight_report_window_open_terminal)
state_machine.add(union_fight_report_window_close_terminal)
state_machine.init()

function UnionFightReport:ctor()
    self.super:ctor()
    self.roots = {}

    self._current_page = 0          -- 1：公会战况，2：个人战况
    self._battle_type = 1           -- 1：预选赛，复赛，2：决赛
    self._battle_count = 0          -- 战场类型

    self._report_list = {}          -- 战报
    self._left_info = nil           -- 查看公会信息
    self._right_info = nil
    self._left_current_num = {0, 0, 0}      -- 剩余人数
    self._right_current_num = {0, 0, 0}
    self._result_info = {}         -- 决赛战报结果信息

    self._list_view = nil
    self._list_view_poy = 0
    self._list_view_height = 0

    local function init_union_fight_report_terminal()
        local union_fight_report_change_page_terminal = {
            _name = "union_fight_report_change_page",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                instance:changeSelectPage(tonumber(params._datas._page))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_report_change_battle_count_terminal = {
            _name = "union_fight_report_change_battle_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local change_count = params._datas.change_count
                local battle_count = instance._battle_count + change_count
                if battle_count < 1 then
                    battle_count = 1
                end
                if battle_count > 3 then
                    battle_count = 3 
                end
                instance:changeBattleCount(battle_count)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local union_fight_report_select_battle_count_terminal = {
            _name = "union_fight_report_select_battle_count",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                local battle_count = params._datas.battle_count
                if battle_count < 1 then
                    battle_count = 1
                end
                if battle_count > 3 then
                    battle_count = 3 
                end
                instance:changeBattleCount(battle_count)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(union_fight_report_change_page_terminal)
        state_machine.add(union_fight_report_change_battle_count_terminal)
        state_machine.add(union_fight_report_select_battle_count_terminal)
        state_machine.init()
    end
    init_union_fight_report_terminal()
end

function UnionFightReport:updateInfo( ... )
    local root = self.roots[1]
    local Panel_ghz_yss_t = ccui.Helper:seekWidgetByName(root, "Panel_ghz_yss_t")
    local Text_ghz_jf_n = ccui.Helper:seekWidgetByName(root, "Text_ghz_jf_n")
    local Text_ghz_jf_ls_n = ccui.Helper:seekWidgetByName(root, "Text_ghz_jf_ls_n")
    local Text_hgz_c_n = ccui.Helper:seekWidgetByName(root, "Text_hgz_c_n")

    Panel_ghz_yss_t:removeBackGroundImage()

    -- 策划需求，积分直接写死为0
    Text_ghz_jf_n:setString("0")
    Text_ghz_jf_ls_n:setString("")
    Text_hgz_c_n:setString("")

    if _ED.union.union_fight_union_info ~= nil then
        -- Text_ghz_jf_n:setString(_ED.union.union_fight_union_info.current_score)
        if _ED.union.union_fight_union_info.max_win_name == "" then
            Text_ghz_jf_ls_n:setString(_new_interface_text[156])
        else
            Text_ghz_jf_ls_n:setString(_ED.union.union_fight_union_info.max_win_name)
        end
    end

    -- 上一场战斗类型
    local battle_times = tonumber(_ED.union.union_fight_battle_info.battle_times)
    if tonumber(_ED.union.union_fight_battle_info.state) == 0
        or tonumber(_ED.union.union_fight_battle_info.state) == 1
        or tonumber(_ED.union.union_fight_battle_info.state) == 2 
        then
        if battle_times == 1 then
            battle_times = 5
        else
            battle_times = battle_times - 1
        end
    end

    if battle_times <= 3 then
        Text_hgz_c_n:setString(string.format(tipStringInfo_union_str[85], battle_times))
        Panel_ghz_yss_t:setBackGroundImage("images/ui/text/GHZ_res/zy_ss_t_1.png")
    elseif battle_times == 4 then
        Panel_ghz_yss_t:setBackGroundImage("images/ui/text/GHZ_res/zy_ss_t_2.png")
    elseif battle_times == 5 then
        Panel_ghz_yss_t:setBackGroundImage("images/ui/text/GHZ_res/zy_ss_t_3.png")
    end
end

function UnionFightReport:changeBattleCount(battle_count)
    if battle_count < 1 or battle_count > 3 then
        return
    end
    local root = self.roots[1]

    local Image_zc_1_1 = ccui.Helper:seekWidgetByName(root, "Image_zc_1_1")
    local Image_zc_1_2 = ccui.Helper:seekWidgetByName(root, "Image_zc_1_2")
    local Image_zc_2_1 = ccui.Helper:seekWidgetByName(root, "Image_zc_2_1")
    local Image_zc_2_2 = ccui.Helper:seekWidgetByName(root, "Image_zc_2_2")
    local Image_zc_3_1 = ccui.Helper:seekWidgetByName(root, "Image_zc_3_1")
    local Image_zc_3_2 = ccui.Helper:seekWidgetByName(root, "Image_zc_3_2")
    local Button_ghz_zc_1 = ccui.Helper:seekWidgetByName(root, "Button_ghz_zc_1")
    local Button_ghz_zc_2 = ccui.Helper:seekWidgetByName(root, "Button_ghz_zc_2")
    local Button_ghz_zc_3 = ccui.Helper:seekWidgetByName(root, "Button_ghz_zc_3")
    Image_zc_1_1:setVisible(false)
    Image_zc_1_2:setVisible(false)
    Image_zc_2_1:setVisible(false)
    Image_zc_2_2:setVisible(false)
    Image_zc_3_1:setVisible(false)
    Image_zc_3_2:setVisible(false)
    Button_ghz_zc_1:setHighlighted(false)
    Button_ghz_zc_2:setHighlighted(false)
    Button_ghz_zc_3:setHighlighted(false)

    if battle_count == 1 then
        Image_zc_1_2:setVisible(true)
        Image_zc_2_1:setVisible(true)
        Image_zc_3_1:setVisible(true)
        Button_ghz_zc_1:setHighlighted(true)
    elseif battle_count == 2 then
        Image_zc_1_1:setVisible(true)
        Image_zc_2_2:setVisible(true)
        Image_zc_3_1:setVisible(true)
        Button_ghz_zc_2:setHighlighted(true)
    elseif battle_count == 3 then
        Image_zc_1_1:setVisible(true)
        Image_zc_2_1:setVisible(true)
        Image_zc_3_2:setVisible(true)
        Button_ghz_zc_3:setHighlighted(true)
    end
    
    if self._battle_count == battle_count then
        return
    end
    self._battle_count = battle_count

    local Panel_js_zc_t = ccui.Helper:seekWidgetByName(root, "Panel_js_zc_t")
    Panel_js_zc_t:removeBackGroundImage()
    Panel_js_zc_t:setBackGroundImage(string.format("images/ui/text/GHZ_res/zc%d.png", battle_count))

    self:updateTopUnionInfo()
    self:onUpdateDraw()
end

function UnionFightReport:changeSelectPage( page )
    local root = self.roots[1]
    local Image_yss_1_1 = ccui.Helper:seekWidgetByName(root, "Image_yss_1_1")
    local Image_yss_1_2 = ccui.Helper:seekWidgetByName(root, "Image_yss_1_2")
    local Image_yss_2_1 = ccui.Helper:seekWidgetByName(root, "Image_yss_2_1")
    local Image_yss_2_2 = ccui.Helper:seekWidgetByName(root, "Image_yss_2_2")
    local Button_ghz_yss_1 = ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_1")
    local Button_ghz_yss_2 = ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_2")
    Image_yss_1_1:setVisible(false)
    Image_yss_1_2:setVisible(false)
    Image_yss_2_1:setVisible(false)
    Image_yss_2_2:setVisible(false)
    Button_ghz_yss_1:setHighlighted(false)
    Button_ghz_yss_2:setHighlighted(false)
    if page == 1 then
        Image_yss_1_2:setVisible(true)
        Image_yss_2_1:setVisible(true)
        Button_ghz_yss_1:setHighlighted(true)
    elseif page == 2 then
        Image_yss_1_1:setVisible(true)
        Image_yss_2_2:setVisible(true)
        Button_ghz_yss_2:setHighlighted(true)
    end
    if page == self._current_page then
        return
    end
    self._current_page = page

    self:onUpdateDraw()
    self:updateInfo()
end

function UnionFightReport:updateTopUnionInfo()
    local root = self.roots[1]
    local Panel_js_zk = root:getChildByName("Panel_js_zk")
    local Panel_legion_vs = Panel_js_zk:getChildByName("Panel_legion_vs")
    local Panel_vs_1 = Panel_legion_vs:getChildByName("Panel_vs_1")
    local Panel_vs_2 = Panel_legion_vs:getChildByName("Panel_vs_2")

    local Panel_role_icon_xy_1 = Panel_vs_1:getChildByName("Panel_role_icon_xy_1")
    local Text_player_name_1 = Panel_vs_1:getChildByName("Text_player_name_1")
    local Text_legion_name_1 = Panel_vs_1:getChildByName("Text_legion_name_1")
    Panel_role_icon_xy_1:removeBackGroundImage()
    if self._left_info ~= nil then
        Panel_role_icon_xy_1:setBackGroundImage(string.format("images/ui/union_logo/union_logo_%d.png", self._left_info.union_pic))
        Text_player_name_1:setString(self._left_info.union_name)
        Text_legion_name_1:setString(""..self._left_current_num[self._battle_count].."/"..self._left_info.join_num)
    end

    local Panel_role_icon_xy_2 = Panel_vs_2:getChildByName("Panel_role_icon_xy_2")
    local Text_player_name_2 = Panel_vs_2:getChildByName("Text_player_name_2")
    local Text_legion_name_2 = Panel_vs_2:getChildByName("Text_legion_name_2")
    Panel_role_icon_xy_2:removeBackGroundImage()
    if self._right_info ~= nil then
        Panel_role_icon_xy_2:setBackGroundImage(string.format("images/ui/union_logo/union_logo_%d.png", self._right_info.union_pic))
        Text_player_name_2:setString(self._right_info.union_name)
        Text_legion_name_2:setString(""..self._right_current_num[self._battle_count].."/"..self._right_info.join_num)
    end
end

function UnionFightReport:onUpdateDraw()
    local root = self.roots[1]

    self._list_view:removeAllItems()
    self._list_view:jumpToTop()

    local report_list = {}
    local result_info = nil
    if self._battle_type == 1 then
        report_list = self._report_list[1]
    else
        report_list = self._report_list[self._battle_count]
        result_info = self._result_info[self._battle_count]
    end

    local result = {}
    if self._current_page == 2 then
        for round, roundInfo in pairs(report_list) do
            local isFindMe = false
            local my_round_info = {}
            my_round_info.round = round
            my_round_info.report_list = {}
            for k,v in pairs(roundInfo.report_list) do
                local info = zstring.split(v, "@")
                local leftInfo = zstring.split(info[2], ",")
                local rightInfo = zstring.split(info[3], ",")
                if tonumber(leftInfo[1]) == tonumber(_ED.user_info.user_id)
                    or tonumber(rightInfo[1]) == tonumber(_ED.user_info.user_id)
                    then
                    isFindMe = true
                    table.insert(my_round_info.report_list, v)
                    break
                end
            end
            if isFindMe == true then
                table.insert(result, my_round_info)
            end
        end
    else
        if report_list ~= nil then
            result = report_list
        end
    end

    local index = 0
    if #result > 0 then
        for round, roundInfo in pairs(result) do
            for k,v in pairs(roundInfo.report_list) do
                index = index + 1
                local cell = state_machine.excute("union_fighting_report_ex_cell_create", 0, {index, v, k, self._battle_type})
                self:insertListViewCellTop(cell)
            end
            if self._current_page ~= 2 then         -- 个人战况
                local cell = state_machine.excute("union_fighting_report_time_ex_cell_create", 0, {nil, round, round == #result, result_info})
                self:insertListViewCellTop(cell)
            end
            local cell = state_machine.excute("union_fighting_round_ex_cell_create", 0, {round})
            self:insertListViewCellTop(cell)
        end
    else
        if self._current_page == 1 then
            if self._battle_type == 1 then
                local cell = state_machine.excute("union_fighting_report_time_ex_cell_create", 0, {nil, 1, true, {union_is_join = false}})
                self:insertListViewCellTop(cell)
            elseif self._battle_type == 2 then
                local cell = state_machine.excute("union_fighting_report_time_ex_cell_create", 0, {nil, 1, true, result_info})
                self:insertListViewCellTop(cell)
            end
        end
    end

    local label = self._list_view:getChildByName("NoDataLabel")
    if label and label:getParent() then
        label:removeFromParent()
        label = nil
    end

    -- 我的战况如果没有数据时，写文字提示为空
    if #result == 0 and self._current_page == 2 then
        local label = cc.Label:createWithSystemFont(tipStringInfo_union_str[114] or "", "", 20)
        label:setName("NoDataLabel")
        label:setPosition(cc.p(self._list_view:getContentSize().width / 2, self._list_view:getContentSize().height / 2))
        self._list_view:addChild(label)
    end

    self._list_view:requestRefreshView()
    self._list_view_poy = self._list_view:getInnerContainer():getPositionY()
    self._list_view_height = self._list_view:getInnerContainer():getPositionY()

    self:runAction(cc.Sequence:create({cc.DelayTime:create(0.05), cc.CallFunc:create(function ( sender )
        sender._list_view_poy = 0
        sender:onUpdate(0)
    end)}))
end

function UnionFightReport:insertListViewCellTop(cell)
    if self._list_view ~= nil then
        if #self._list_view:getItems() == 0 then
            self._list_view:addChild(cell)
        else
            self._list_view:insertCustomItem(cell, 0)
        end
    end
end

function UnionFightReport:onUpdate(dt)
    if self._list_view ~= nil then
        local size = self._list_view:getContentSize()
        local posY = self._list_view:getInnerContainer():getPositionY()
        if self._list_view_poy == posY then
            return
        end
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

function UnionFightReport:onEnterTransitionFinish()

end

function UnionFightReport:initUI()
    local root = self.roots[1]
    local Panel_ghz_yss_box = ccui.Helper:seekWidgetByName(root, "Panel_ghz_yss_box")
    local Panel_js_zk = ccui.Helper:seekWidgetByName(root, "Panel_js_zk")
    local ListView_ghz_fighting = ccui.Helper:seekWidgetByName(root, "ListView_ghz_fighting")
    local ListView_ghz_zc_fighting = ccui.Helper:seekWidgetByName(root, "ListView_ghz_zc_fighting")
    local Button_js_zc_qh_1 = ccui.Helper:seekWidgetByName(root, "Button_js_zc_qh_1")
    local Button_js_zc_qh_2 = ccui.Helper:seekWidgetByName(root, "Button_js_zc_qh_2")
    local Panel_js_zc_t = ccui.Helper:seekWidgetByName(root, "Panel_js_zc_t")
    Panel_ghz_yss_box:setVisible(false)
    Panel_js_zk:setVisible(false)

    if self._battle_type == 1 then
        Panel_ghz_yss_box:setVisible(true)
        self._list_view = ListView_ghz_fighting

        Button_js_zc_qh_1:setVisible(false)
        Button_js_zc_qh_2:setVisible(false)
        Panel_js_zc_t:setVisible(false)
    else
        local is_mine = false
        if (self._left_info ~= nil and self._left_info.union_id == tonumber(_ED.union.union_info.union_id))
            or (self._right_info ~= nil and self._right_info.union_id == tonumber(_ED.union.union_info.union_id))
            then
            is_mine = true
        end

        if is_mine == true then
            Panel_ghz_yss_box:setVisible(true)
            self._list_view = ListView_ghz_fighting

            Button_js_zc_qh_1:setVisible(true)
            Button_js_zc_qh_2:setVisible(true)
            Panel_js_zc_t:setVisible(true)
        else
            Panel_js_zk:setVisible(true)
            self._list_view = ListView_ghz_zc_fighting
        end
    end
end

function UnionFightReport:updateData()
    self._report_list = {}          -- 战报
    self._left_info = nil           -- 查看公会信息
    self._right_info = nil
    self._left_current_num = {0, 0, 0}      -- 剩余人数
    self._right_current_num = {0, 0, 0}
    self._result_info = {}

    if self._battle_type == 1 then
        if _ED.union.union_fight_reports ~= nil then
            table.insert(self._report_list, _ED.union.union_fight_reports)
        end
    else        -- 决赛
        if _ED.union.union_fight_duel_match_info ~= nil then
            local match_pos = zstring.split(_ED.union.union_fight_duel_match_info.match_pos, ",")
            local battle_type = tonumber(_ED.union.union_fight_duel_match_info.battle_type)
            if _ED.union.union_fight_duel_info.battle_info ~= nil 
                and _ED.union.union_fight_duel_info.battle_info[""..battle_type] ~= nil 
                then
                if battle_type == 1 then
                    for k, v in pairs(_ED.union.union_fight_duel_info.battle_info[""..battle_type]) do
                        if tonumber(k) <= 4 and v.position == tonumber(match_pos[1]) then
                            self._left_info = v
                        elseif tonumber(k) <= 8 and v.position == tonumber(match_pos[2]) then
                            self._right_info = v
                        end
                    end
                else
                    self._left_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[1]]
                    self._right_info = _ED.union.union_fight_duel_info.battle_info[""..battle_type][""..match_pos[2]]
                end
            end

            for k, v in pairs(_ED.union.union_fight_duel_match_info.battle_list) do
                table.insert(self._report_list, v.report_info_list)
                local current_num = zstring.split(v.current_num_info, ",")
                local union_info = zstring.split(v.union_num_info, ",")
                if tonumber(union_info[1]) == tonumber(self._left_info.union_id) then
                    self._left_current_num[k] = tonumber(current_num[1])
                    self._right_current_num[k] = tonumber(current_num[2])
                else
                    self._left_current_num[k] = tonumber(current_num[2])
                    self._right_current_num[k] = tonumber(current_num[1])
                end

                local info = {}
                if self._left_current_num[k] > self._right_current_num[k] then
                    info.win_union = self._left_info.union_name
                    info.lose_union = self._right_info.union_name
                else
                    info.win_union = self._right_info.union_name
                    info.lose_union = self._left_info.union_name
                end
                info.report_count = v.total_round
                table.insert(self._result_info, info)
            end
        end
    end
end

function UnionFightReport:onInit( )
    local csbItem = csb.createNode(config_csb.union_fight.sm_legion_ghz_fighting)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_wzzz_back"), nil, 
    {
        terminal_name = "union_fight_report_window_close", 
        terminal_state = 0, 
        _page = 1,
        isPressedActionEnabled = true
    }, nil, 1)

    for i=1,2 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ghz_yss_"..i), nil, 
        {
            terminal_name = "union_fight_report_change_page", 
            terminal_state = 0, 
            _page = i,
            isPressedActionEnabled = true
        }, nil, 1)
    end

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_js_zc_qh_1"), nil, 
    {
        terminal_name = "union_fight_report_change_battle_count", 
        terminal_state = 0, 
        _page = 1,
        isPressedActionEnabled = true,
        change_count = 1,
    }, nil, 1)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_js_zc_qh_2"), nil, 
    {
        terminal_name = "union_fight_report_change_battle_count", 
        terminal_state = 0, 
        _page = 1,
        isPressedActionEnabled = true,
        change_count = -1,
    }, nil, 1)

    for i=1,3 do
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_ghz_zc_"..i), nil, 
        {
            terminal_name = "union_fight_report_select_battle_count", 
            terminal_state = 0, 
            battle_count = i,
            isPressedActionEnabled = true
        }, nil, 1)
    end

    state_machine.excute("sm_union_user_topinfo_open",0,self)

    self:updateData()
    self:initUI()

    self:changeBattleCount(1)
    self:updateInfo()
    self:changeSelectPage(1)
end

function UnionFightReport:init(battle_type)
    self._battle_type = battle_type
    self:onInit()
    return self
end

function UnionFightReport:onExit()
    state_machine.remove("union_fight_report_change_page")
    state_machine.remove("union_fight_report_change_battle_count")
    state_machine.remove("union_fight_report_select_battle_count")
end
