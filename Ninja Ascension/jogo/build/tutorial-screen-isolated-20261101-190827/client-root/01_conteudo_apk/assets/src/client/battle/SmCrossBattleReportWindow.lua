--[[ ----------------------------------------------------------------------------
-- 战报界面(小队竞技场和跨服忍界大战)
--]] ----------------------------------------------------------------------------
SmCrossBattleReportWindow = class("SmCrossBattleReportWindowClass", Window)
SmCrossBattleReportWindow.FIGHTTYPE = {
    TEAMARENA = 1, -- 小队竞技场
    CROSSTOTAL = 2 -- 跨服忍界大战
}
SmCrossBattleReportWindow.SHOWTYPE = {
    DAMAGE = 1,
    INJURED = 2,
    CURE = 3
}
-- 打开窗口
local sm_cross_battle_report_window_open_terminal = {
    _name = "sm_cross_battle_report_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SmCrossBattleReportWindowClass") then
            fwin:open(SmCrossBattleReportWindow:new():init(params), fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local sm_cross_battle_report_window_close_terminal = {
    _name = "sm_cross_battle_report_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SmCrossBattleReportWindowClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(sm_cross_battle_report_window_open_terminal)
state_machine.add(sm_cross_battle_report_window_close_terminal)
state_machine.init()

-- 构造器
function SmCrossBattleReportWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._fight_type = nil
    self._report_data = {} -- 战斗数据
    self._cur_page = 1 -- 1:伤害 2:承伤 3:治疗
    self._cur_session = 1 -- 当前场次
    self._win_info = {} -- 每场胜负记录
    -- load lua files.
    app.load("client.cells.battle.sm_cross_battle_report_cell")
    app.load("client.cells.ship.hero_icon_list_cell")
    -- Initialize sm battle report window page state machine.
    local function init_sm_cross_battle_report_window_terminal()
        -- 切换显示页
        local sm_cross_battle_report_window_change_page_terminal = {
            _name = "sm_cross_battle_report_window_change_page",
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

        -- 切换场次
        local sm_cross_battle_report_window_change_session_terminal = {
            _name = "sm_cross_battle_report_window_change_session",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:changeSession(params._datas.m_session)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_cross_battle_report_window_change_page_terminal)
        state_machine.add(sm_cross_battle_report_window_change_session_terminal)
        state_machine.init()
    end
    -- call func init sm battle report window state machine.
    init_sm_cross_battle_report_window_terminal()
end

function SmCrossBattleReportWindow:onHandleData()
    local function getTotalData(tempData)
        local temp_info = {
            totalDamage = 0,
            totalInjured = 0,
            totalCure = 0
        }
        for i, v in ipairs(tempData) do
            temp_info.totalDamage = temp_info.totalDamage + v.damage
            temp_info.totalInjured = temp_info.totalInjured + v.injured
            temp_info.totalCure = temp_info.totalCure + v.cure
        end
        return temp_info
    end
    self._report_data = clone(_ED.cross_battle_report_info.battleInfo)
    -- 统计数据汇总
    for i, v in ipairs(self._report_data) do
        v.info[1].totalInfo = getTotalData(v.info[1].detail)
        v.info[2].totalInfo = getTotalData(v.info[2].detail)
    end
    -- 战斗结果汇总
    self._win_info = self:getWinInfo()
end

-- 数值从大到小排序
function SmCrossBattleReportWindow:onSort(data, type)
    local result = {}
    local detail = data
    local function sortFunc(a, b)
        if self._cur_page == SmCrossBattleReportWindow.SHOWTYPE.DAMAGE then
            return a.damage > b.damage
        elseif self._cur_page == SmCrossBattleReportWindow.SHOWTYPE.INJURED then
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

-- 双方武将列表 session:场次 page:页面 type: 1=我方 2=敌方
function SmCrossBattleReportWindow:onDrawList(listView, session, page, type)
    local function caculPercent(single, total)
        -- 百分比计算
        local percent = 0
        if total ~= 0 then
            percent = math.floor((single / total) * 100)
        end
        return percent
    end

    local reportInfo = self._report_data[session].info[type]
    local reportDetail = self:onSort(reportInfo.detail, type) -- 对应面板数据
    listView:removeAllItems()
    for i, v in ipairs(reportDetail) do
        local percent = 0
        if page == SmCrossBattleReportWindow.SHOWTYPE.DAMAGE then
            local mTotalDamage = reportInfo.totalInfo.totalDamage
            percent = caculPercent(v.damage, mTotalDamage)
        elseif page == SmCrossBattleReportWindow.SHOWTYPE.INJURED then
            local mTotalInjured = reportInfo.totalInfo.totalInjured
            percent = caculPercent(v.injured, mTotalInjured)
        elseif page == SmCrossBattleReportWindow.SHOWTYPE.CURE then
            local mTotalCure = reportInfo.totalInfo.totalCure
            percent = caculPercent(v.cure, mTotalCure)
        end
        local cell = state_machine.excute("sm_cross_battle_report_cell_create", 0, {report_info = v, show_type = page, show_percent = percent})
        listView:addChild(cell)
    end
    listView:jumpToTop()
    listView:requestRefreshView()
end

function SmCrossBattleReportWindow:getPlayerInfo(roleType)
    local function setInfo(name, integral, sever)
        return {name = name, integral = integral, sever = sever}
    end
    local playerInfo = nil
    
    if self._fight_type == SmCrossBattleReportWindow.FIGHTTYPE.TEAMARENA then
        if roleType == 1 then
            playerInfo = setInfo(_ED.TeamArena_win.name, _ED.TeamArena_win.integral, GetServerNameByServerNumber(_ED.TeamArena_win.server))
        else
            playerInfo = setInfo(_ED.TeamArena_lose.name, _ED.TeamArena_lose.integral, GetServerNameByServerNumber(_ED.TeamArena_lose.server))
        end
    elseif self._fight_type == SmCrossBattleReportWindow.FIGHTTYPE.CROSSTOTAL then
        if roleType == 1 then
            playerInfo = setInfo(_ED.crossServerTotal_win.name, _ED.crossServerTotal_win.integral, GetServerNameByServerNumber(_ED.crossServerTotal_win.server))
        else
            playerInfo = setInfo(_ED.crossServerTotal_lose.name, _ED.crossServerTotal_lose.integral, GetServerNameByServerNumber(_ED.crossServerTotal_lose.server))
        end
    end
    return playerInfo
end

function SmCrossBattleReportWindow:refrushBtn(session, page)
    local root = self.roots[1]
    for i = 1, 3 do
        local Button_round = ccui.Helper:seekWidgetByName(root, "Button_round_" .. i)
        if session == i then
            Button_round:setTouchEnabled(false)
            Button_round:setHighlighted(true)
        else
            Button_round:setTouchEnabled(true)
            Button_round:setHighlighted(false)
        end
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

-- 刷新战报信息
function SmCrossBattleReportWindow:refrushView(session, page)
    self:refrushBtn(session, page)
    self:onDrawList(self.Listview_formation_1, session, page, 1)
    self:onDrawList(self.Listview_formation_2, session, page, 2)
end
-- 切换伤害/承伤/治疗
function SmCrossBattleReportWindow:changePage(page)
    if self._cur_page == page then
        return
    end
    self._cur_page = page
    self:refrushView(self._cur_session, page)
end

-- 切换场次
function SmCrossBattleReportWindow:changeSession(session)
    if self._cur_session == session then
        return
    end
    self._cur_session = session
    self:updateRound(session)
    self:refrushView(session, self._cur_page)
end

-- 获得战斗结果
function SmCrossBattleReportWindow:getWinInfo()
    local winInfo = {}
    if self._fight_type == SmCrossBattleReportWindow.FIGHTTYPE.TEAMARENA then
        for i, v in ipairs(_ED.TeamArena_attackData) do
            if tonumber(v.isWin) == 1 then
                table.insert(winInfo, true)
            else
                table.insert(winInfo, false)
            end
        end
    elseif self._fight_type == SmCrossBattleReportWindow.FIGHTTYPE.CROSSTOTAL then
        for i, v in ipairs(_ED.crossServerTotal_attackData) do
            if tonumber(v.isWin) == 1 then
                table.insert(winInfo, true)
            else
                table.insert(winInfo, false)
            end
        end
    end
    return winInfo
end

-- 双方玩家信息
function SmCrossBattleReportWindow:onDrawPlayer(roleType)
    local root = self.roots[1]
    local headData = _ED.cross_battle_report_info.headInfo[roleType]
    local otherInfo = self:getPlayerInfo(roleType)
    
    -- 头像
    local Panel_head = ccui.Helper:seekWidgetByName(root, "Panel_head_" .. roleType)
    Panel_head:removeAllChildren(true)
    local fun_is_open = GetProjectFunctionIsOpen(ProjectFunctionEnum.FrameHead)
    local headIcon = nil
    if fun_is_open == true then
        local headIconInfo = {
            headFrameID = headData.headFrameID,
            headFrameStage = headData.headFrameStage,
            headID = headData.headID
        }
        headIcon = CreateHeadIconCell(headIconInfo)
    else
        headIcon = self:onHeadDraw(headData.headID)
    end
    Panel_head:addChild(headIcon)

    -- 昵称
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_name_" .. roleType)
    Text_name:setString(otherInfo.name)

    -- 积分
    local Text_power = ccui.Helper:seekWidgetByName(root, "Text_power_" .. roleType)
    Text_power:setString(otherInfo.integral)

    -- 服务器
    local Text_rank = ccui.Helper:seekWidgetByName(root, "Text_rank_" .. roleType)
    Text_rank:setString(otherInfo.sever)
end

-- 显示胜利失败标签
function SmCrossBattleReportWindow:showResultTag(isShow)
    local root = self.roots[1]
    local Image_win_1 = ccui.Helper:seekWidgetByName(root, "Image_win_1")
    Image_win_1:setVisible(isShow)
    local Image_lose_1 = ccui.Helper:seekWidgetByName(root, "Image_lose_1")
    Image_lose_1:setVisible(not isShow)
    local Image_win_2 = ccui.Helper:seekWidgetByName(root, "Image_win_2")
    Image_win_2:setVisible(not isShow)
    local Image_lose_2 = ccui.Helper:seekWidgetByName(root, "Image_lose_2")
    Image_lose_2:setVisible(isShow)
end

function SmCrossBattleReportWindow:onHeadDraw(headIndex)
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

function SmCrossBattleReportWindow:onUpdateDraw()
    local root = self.roots[1]
    -- 战斗回合数文本
    self.Text_round_num = ccui.Helper:seekWidgetByName(root, "Text_round_num")
    -- 玩家上阵列表
    self.Listview_formation_1 = ccui.Helper:seekWidgetByName(root, "Listview_formation_1")
    -- 对方上阵列表
    self.Listview_formation_2 = ccui.Helper:seekWidgetByName(root, "Listview_formation_2")
    self:onDrawPlayer(1) -- 我方
    self:onDrawPlayer(2) -- 敌方
    self:refrushView(self._cur_session, self._cur_page)
    self:updateRound(self._cur_session)
end

-- 回合数和每场胜负刷新
function SmCrossBattleReportWindow:updateRound(session)
    -- 胜负显示
    if self._win_info[self._cur_session] then
        self:showResultTag(true)
    else
        self:showResultTag(false)
    end
    -- 回合数
    self.Text_round_num:setString(self._report_data[session].round)
end

function SmCrossBattleReportWindow:onDrawBtn()
    local root = self.roots[1]

    for i = 1, 3 do
        -- 伤害页签按钮
        fwin:addTouchEventListener(
            ccui.Helper:seekWidgetByName(root, "Button_tab_" .. i),
            nil,
            {
                terminal_name = "sm_cross_battle_report_window_change_page",
                terminal_state = 0,
                m_page = i,
                isPressedActionEnabled = true
            },
            nil,
            0
        )
        local Button_round = ccui.Helper:seekWidgetByName(root, "Button_round_" .. i)
        if i > #self._report_data then
            Button_round:setVisible(false)
        else
            Button_round:setVisible(true)
        end
        -- 场次页签按钮
        fwin:addTouchEventListener(
            Button_round,
            nil,
            {
                terminal_name = "sm_cross_battle_report_window_change_session",
                terminal_state = 0,
                m_session = i,
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
            terminal_name = "sm_cross_battle_report_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function SmCrossBattleReportWindow:onInit(params)
    local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_damage_detail_0.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)
    self:onHandleData()
    self:onUpdateDraw()
    self:onDrawBtn()
end

-- 对象初始化
function SmCrossBattleReportWindow:init(params)
    if nil ~= self.onInit then
        self._fight_type = tonumber(params.battleType)
        self:onInit(params)
    end
    return self
end

function SmCrossBattleReportWindow:onExit()
    -- 释放SmCrossBattleReportWindowWindow界面资源.
    state_machine.remove("sm_cross_battle_report_window_change_page")
    state_machine.remove("sm_cross_battle_report_window_change_session")
end

function SmCrossBattleReportWindow:close()
    -- window event : close.
end

function SmCrossBattleReportWindow:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
