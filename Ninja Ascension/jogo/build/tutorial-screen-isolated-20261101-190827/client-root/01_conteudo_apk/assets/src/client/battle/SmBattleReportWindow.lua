--[[ ----------------------------------------------------------------------------
-- 战报界面
--]] ----------------------------------------------------------------------------
SmBattleReportWindow = class("SmBattleReportWindowClass", Window)
SmBattleReportWindow.SHOWTYPE = {
    DAMAGE = 1,
    INJURED = 2,
    CURE = 3
}
-- 打开窗口
local sm_battle_report_window_open_terminal = {
    _name = "sm_battle_report_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SmBattleReportWindowClass") then
            fwin:open(SmBattleReportWindow:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local sm_battle_report_window_close_terminal = {
    _name = "sm_battle_report_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmBattleReportWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_battle_report_window_open_terminal)
state_machine.add(sm_battle_report_window_close_terminal)
state_machine.init()

-- 构造器
function SmBattleReportWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._fight_type = nil
    self._report_data = {}
    self._cur_page = 0 -- 1:伤害 2:承伤 3:治疗
    -- load lua files.
    app.load("client.cells.battle.sm_battle_report_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    -- Initialize sm battle report window page state machine.
    local function init_sm_battle_report_window_terminal()
        -- 切换显示页
        local sm_battle_report_window_change_page_terminal = {
            _name = "sm_battle_report_window_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:changePage(params._datas.m_page)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_battle_report_window_change_page_terminal)
        state_machine.init()
    end
    -- call func init sm battle report window state machine.
    init_sm_battle_report_window_terminal()
end

function SmBattleReportWindow:setShipInfo(battleObject, detailShip)
    local shipAllData = zstring.split(battleObject, "!")
    local idx = 0
    for i, v in ipairs(shipAllData) do
        idx = idx + 1
        local shipData = zstring.split(v, ":")
        local ship = {}
        ship.ship_template_id = shipData[1]
        ship.evolution_status = shipData[3]
        ship.Order = shipData[5]
        ship.StarRating = shipData[4]
        ship.ship_grade = shipData[2]
        ship.ship_id = -1
        ship.skin_id = shipData[7]
        detailShip[i].fightObj = ship
    end
    return idx
end

function SmBattleReportWindow:setUserTotalFight(index, userInfo)
    local totalFight = 0
    if self._fight_type == _enum_fight_type._fight_type_11 then -- 竞技场
        totalFight = _ED.arena_battle_data[index].totalFight
    elseif self._fight_type == _enum_fight_type._fight_type_13 then -- 好友切磋
        if index == 1 then
            totalFight = _ED.user_info.fight_capacity
        else
            totalFight = _ED.chat_user_info.fighting
        end
    end

    userInfo.totalFight = totalFight
end

function SmBattleReportWindow:onHandleData()

    self._report_data = {}

    -- 头像框功能是否开放
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)

    for i = 1, 2 do
        local temp_info = {}
        local animalData = nil
        local shipNum = 0 -- 武将数量
        temp_info.detail = clone(_ED.battle_report_info[i].detail) -- 统计数据
        if self._fight_type == _enum_fight_type._fight_type_11 then -- 竞技场
            temp_info.name = _ED.arena_battle_data[i].name
            temp_info.lastRank = _ED.arena_battle_data[i].lastRank -- 战斗前排行
            temp_info.rank = _ED.arena_battle_data[i].rank
            temp_info.headID = _ED.arena_battle_data[i].headID -- 头像
            if fun_is_open == true then
                temp_info.headFrameID = _ED.arena_battle_data[i].headFrameID -- 头像框ID
                temp_info.headFrameStage = _ED.arena_battle_data[i].headFrameStage -- 头像框阶段
            end
            -- 武将数据
            shipNum = self:setShipInfo(_ED.arena_battle_data[i].battle_object, temp_info.detail)
            local animalsInfo = _ED.arena_battle_data[i].animalObject
            if animalsInfo ~= "" then
                -- 神兽数据
                animalData = zstring.splits(_ED.arena_battle_data[i].animalObject, "|", ",")
            end

            self:setUserTotalFight(i, temp_info)
        elseif self._fight_type == _enum_fight_type._fight_type_13 then -- 好友切磋
            if i == 1 then
                temp_info.name = _ED.user_info.user_name
                temp_info.headID = _ED.user_info.user_head -- 头像
                if fun_is_open == true then
                    temp_info.headFrameID = _ED.user_info.head_frame.curHeadFrameID -- 头像框ID
                    temp_info.headFrameStage = _ED.user_info.head_frame.curHeadFrameStage -- 头像框阶段
                end
                -- 武将数据
                local idx = 0
                for i = 1, 6 do
                    local fightShip = _ED.user_ship["" .. _ED.user_formetion_status[i]]
                    if fightShip ~= nil then
                        idx = idx + 1
                        temp_info.detail[idx].fightObj = fightShip
                    end
                end
                shipNum = idx
            else
                temp_info.name = _ED.chat_user_info.name
                temp_info.headID = _ED.chat_user_info.lead_mould_id -- 头像
                if fun_is_open == true then
                    temp_info.headFrameID = _ED.chat_user_info.headFrameID -- 头像框ID
                    temp_info.headFrameStage = _ED.chat_user_info.headFrameStage -- 头像框阶段
                end
                -- 武将数据
                shipNum = self:setShipInfo(_ED.chat_user_info.formation, temp_info.detail)
            end
            self:setUserTotalFight(i, temp_info)
        end
        -- 神兽数据
        if animalData ~= nil then
            local idx = 1
            for i, v in ipairs(animalData) do
                if tostring(v[1]) ~= "-1" then
                    temp_info.detail[shipNum + idx].fightObj = v
                    idx = idx + 1
                end
            end
        end
        -- 总计数据
        temp_info.totalDamage = 0 -- 总伤害
        temp_info.totalInjured = 0 -- 总承伤
        temp_info.totalCure = 0 -- 总治疗
        for i, v in ipairs(temp_info.detail) do
            temp_info.totalDamage = temp_info.totalDamage + v.damage
            temp_info.totalInjured = temp_info.totalInjured + v.injured
            temp_info.totalCure = temp_info.totalCure + v.cure
        end

        self._report_data[i] = temp_info
    end
end

function SmBattleReportWindow:refrushBtn(page)
    local root = self.roots[1]
    for i = 1, 3 do
        local Button_tab = ccui.Helper:seekWidgetByName(root, "Button_tab_" .. i)
        if page == i then
            Button_tab:setTouchEnabled(false)
            Button_tab:setHighlighted(true)
        else
            Button_tab:setTouchEnabled(true)
            Button_tab:setHighlighted(false)
        end
    end
end

-- 切换伤害/承伤/治疗
function SmBattleReportWindow:changePage(page)
    if self._cur_page == page then
        return
    end
    self:refrushBtn(page)
    self._cur_page = page
    self:onDrawList(self.Listview_formation_1, 1)
    self:onDrawList(self.Listview_formation_2, 2)
end

-- 数值从大到小排序
function SmBattleReportWindow:onSort(data, type)
    local result = {}
    local detail = data
    local function sortFunc(a, b)
        if self._cur_page == SmBattleReportWindow.SHOWTYPE.DAMAGE then
            return a.damage > b.damage
        elseif self._cur_page == SmBattleReportWindow.SHOWTYPE.INJURED then
            return a.injured > b.injured
        else
            return a.cure > b.cure
        end
    end
    table.sort(detail, sortFunc)

    local shipList = {} -- 武将
    local animalList = {} -- 神兽
    for i, v in ipairs(detail) do
        if v.pos > 6 then
            table.insert(animalList, v)
        else
            table.insert(shipList, v)
        end
    end
    table.add(result, shipList)
    table.add(result, animalList)

    return result
end

-- 双方武将列表 1:我方 2:敌方
function SmBattleReportWindow:onDrawList(listView, type)
    local reportInfo = self._report_data[type]
    local reportDetail = self:onSort(reportInfo.detail, type) -- 对应面板数据
    listView:removeAllItems()
    for i, v in ipairs(reportDetail) do
        local percent = 0
        if self._cur_page == SmBattleReportWindow.SHOWTYPE.DAMAGE then
            if reportInfo.totalDamage ~= 0 then
                percent = math.floor((v.damage / reportInfo.totalDamage) * 100)
            end
        elseif self._cur_page == SmBattleReportWindow.SHOWTYPE.INJURED then
            if reportInfo.totalInjured ~= 0 then
                percent = math.floor((v.injured / reportInfo.totalInjured) * 100)
            end
        elseif self._cur_page == SmBattleReportWindow.SHOWTYPE.CURE then
            if reportInfo.totalCure ~= 0 then
                percent = math.floor((v.cure / reportInfo.totalCure) * 100)
            end
        end
        local cell = state_machine.excute("sm_battle_report_cell_create", 0, {report_info = v, show_type = self._cur_page, show_percent = percent})
        listView:addChild(cell)
    end
    listView:jumpToTop()
    listView:requestRefreshView()
end

-- 双方玩家信息
function SmBattleReportWindow:onDrawPlayer(roleType, roleData)
    local root = self.roots[1]
    local reportData = self._report_data[roleType]

    -- 头像
    local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head_" .. roleType)
    Panel_head:removeAllChildren(true)
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
    local headIcon = nil
    if fun_is_open == true then
        local headIconInfo = {
            headFrameID = reportData.headFrameID,
            headFrameStage = reportData.headFrameStage,
            headID = reportData.headID
        }
        headIcon = CreateHeadIconCell(headIconInfo)
    else
        headIcon = self:onHeadDraw(reportData.headID)
    end
    Panel_head:addChild(headIcon)

    -- 昵称
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_" .. roleType)
    Text_name:setString(reportData.name)

    -- 战力
    local Text_power = ccui.Helper:seekWidgetByName(root, "Text_power_" .. roleType)
    Text_power:setString(reportData.totalFight)

    -- 排名容器
    local Panel_rank = ccui.Helper:seekWidgetByName(root, "Panel_rank_" .. roleType)
    if self._fight_type == _enum_fight_type._fight_type_11 and reportData.lastRank and reportData.rank then
        Panel_rank:setVisible(true)
        local lastRank = tonumber(reportData.lastRank) -- 战斗前排行
        local rank = tonumber(reportData.rank) -- 当前排行
        local cutRank = lastRank - rank
        local c = ""
        if cutRank >= 0 then
            cutRank = string.format(tipStringInfo_fight_report_detail_tips[1], rank, cutRank)
        else
            cutRank = string.format(tipStringInfo_fight_report_detail_tips[2], rank, -cutRank)
        end
        -- 排名
        local Text_rank = ccui.Helper:seekWidgetByName(root, "Text_rank_" .. roleType)
        Text_rank:setString(cutRank)
    else
        Panel_rank:setVisible(false)
    end
end

function SmBattleReportWindow:onHeadDraw(headIndex)
    local roots = cacher.createUIRef("icon/item.csb", "root")
    table.insert(self.roots, roots)
    roots:removeFromParent(true)
    local picIndex = tonumber(headIndex)
    local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
    local Panel_ditu = ccui.Helper:seekWidgetByName(roots, "Panel_ditu")
    local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
    if Panel_head ~= nil then
        Panel_head:removeAllChildren(true)
        Panel_head:removeBackGroundImage()
    end
    if Panel_kuang ~= nil then
        Panel_kuang:removeAllChildren(true)
        Panel_kuang:removeBackGroundImage()
    end
    if Panel_ditu ~= nil then
        Panel_ditu:removeAllChildren(true)
        Panel_ditu:removeBackGroundImage()
    end
    local quality_path = string.format("images/ui/quality/icon_enemy_%d.png", 5)
    local quality_kuang = string.format("images/ui/quality/quality_frame_%d.png", 14)

    local big_icon_path = nil
    if tonumber(picIndex) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(picIndex))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(picIndex))
    end
    Panel_ditu:setBackGroundImage(quality_path)
    Panel_kuang:setBackGroundImage(quality_kuang)
    Panel_head:setBackGroundImage(big_icon_path)
    Panel_head:setTouchEnabled(false)
    return roots
end

function SmBattleReportWindow:onUpdateDraw()
    local root = self.roots[1]
    -- 战斗回合数文本
    self.Text_round_num = ccui.Helper:seekWidgetByName(root, "Text_round_num")
    self.Text_round_num:setString(_ED.attackData.roundCount)
    -- 玩家上阵列表
    self.Listview_formation_1 = ccui.Helper:seekWidgetByName(root, "Listview_formation_1")
    -- 对方上阵列表
    self.Listview_formation_2 = ccui.Helper:seekWidgetByName(root, "Listview_formation_2")
    self:onDrawPlayer(1) -- 我方
    self:onDrawPlayer(2) -- 敌方
end

function SmBattleReportWindow:onDrawBtn()
    local root = self.roots[1]
    for i = 1, 3 do
        -- 伤害页签按钮
        fwin:addTouchEventListener(
            ccui.Helper:seekWidgetByName(root, "Button_tab_" .. i),
            nil,
            {
                terminal_name = "sm_battle_report_window_change_page",
                terminal_state = 0,
                m_page = i,
                isPressedActionEnabled = true
            },
            nil,
            0
        )
    end

    -- 关闭
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_back"),
        nil,
        {
            terminal_name = "sm_battle_report_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

-- 对象初始化
function SmBattleReportWindow:init(params)
    if nil ~= self.onInit then
        self._fight_type = tonumber(params.battleType)
        self:onInit(params)
    end
    return self
end

function SmBattleReportWindow:onInit(params)
    -- 加载SmBattleReportWindowWindow界面资源.
    -- battle.sm_battle_damage_detail = battle/sm_battle_damage_detail.csb
    local csbNode = csb.createNode("battle/sm_battle_damage_detail.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)
    self:onHandleData()
    self:onUpdateDraw()
    self:changePage(1)
    self:onDrawBtn()
end

function SmBattleReportWindow:onExit()
    -- 释放SmBattleReportWindowWindow界面资源.
    state_machine.remove("sm_battle_report_window_change_page")
end

function SmBattleReportWindow:close()
    -- window event : close.
end

function SmBattleReportWindow:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
