--[[ ----------------------------------------------------------------------------
-- 锦囊快速分解
--]] ----------------------------------------------------------------------------
SilkBagFastResolve = class("SilkBagFastResolveClass", Window)

-- 打开窗口
local silkbag_fast_resolve_window_open_terminal = {
    _name = "silkbag_fast_resolve_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("SilkBagFastResolveClass") then
            fwin:open(SilkBagFastResolve:new():init(params), fwin._ui)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local silkbag_fast_resolve_window_close_terminal = {
    _name = "silkbag_fast_resolve_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("SilkBagFastResolveClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(silkbag_fast_resolve_window_open_terminal)
state_machine.add(silkbag_fast_resolve_window_close_terminal)
state_machine.init()

-- 构造器
function SilkBagFastResolve:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    -- var
    self._silkList = {}
    -- load lua files.
    app.load("client.l_digital.cultivate.silkbag.SilkBagScreen")
    app.load("client.l_digital.cells.cultivate.silkbag.sm_cultivate_resolve_cell")
    -- Initialize silkbag_fast_resolve page state machine.
    local function init_silkbag_fast_resolve_terminal()
        -- 打开角色创建窗口
        local silkbag_fast_resolve_open_terminal = {
            _name = "silkbag_fast_resolve_open",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 关闭角色创建窗口
        local silkbag_fast_resolve_close_terminal = {
            _name = "silkbag_fast_resolve_close",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 显示窗口
        local silkbag_fast_resolve_show_terminal = {
            _name = "silkbag_fast_resolve_show",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 显示窗口
                if nil ~= instance then
                    instance:setVisible(true)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏窗口
        local silkbag_fast_resolve_hide_terminal = {
            _name = "silkbag_fast_resolve_hide",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 隐藏窗口
                if nil ~= instance then
                    instance:setVisible(false)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 快速选择
        local silkbag_fast_resolve_quick_select_terminal = {
            _name = "silkbag_fast_resolve_quick_select",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                state_machine.excute("silkbag_screen_window_open", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 分解
        local silkbag_fast_resolve_click_ok_terminal = {
            _name = "silkbag_fast_resolve_click_ok",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil == instance then
                    return true
                end
                state_machine.lock("silkbag_fast_resolve_click_ok")
                local function responseResolveSilkbagCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if nil ~= response.node and nil ~= response.node.roots and nil ~= response.node.roots[1] then
                            --奖励绘制
                            app.load("client.reward.DrawRareReward")
                            local getRewardWnd = DrawRareReward:new()
                            getRewardWnd:init(7)
                            fwin:open(getRewardWnd, fwin._ui)
                            -- 刷新
                            instance:initSelectState()
                            instance:onDrawScrol()
                            state_machine.unlock("silkbag_fast_resolve_click_ok")
                        else
                            state_machine.unlock("silkbag_fast_resolve_click_ok")
                        end
                    else
                        state_machine.unlock("silkbag_fast_resolve_click_ok")
                    end
                end
                -- 分解列表
                local mSelectList = instance:getSelectedList()
                if #mSelectList < 1 then
                    TipDlg.drawTextDailog(tipStringInfo_rescue_silkbag[20])
                    state_machine.unlock("silkbag_fast_resolve_click_ok")
                    return
                end
                local function commendResolve()
                    local ids = ""
                    for i, v in ipairs(mSelectList) do
                        if i == 1 then
                            ids = ids .. v.info.id
                        else
                            ids = ids .. "," .. v.info.id
                        end
                    end
                    protocol_command.ship_slik_bag_resolve.param_list = ids
                    NetworkManager:register(protocol_command.ship_slik_bag_resolve.code, nil, nil, nil, instance, responseResolveSilkbagCallBack, false, nil)
                end

                function showConfirmTip(instance, n)
                    if 0 == n then
                        --分解
                        commendResolve()
                    else
                        state_machine.unlock("silkbag_fast_resolve_click_ok")
                    end
                end

                if instance:haveHighQulity(mSelectList) then
                    app.load("client.utils.ConfirmTip")
                    local tip = ConfirmTip:new()
                    tip:init(instance, showConfirmTip, tipStringInfo_rescue_silkbag[6])
                    fwin:open(tip, fwin._ui)
                else
                    --分解
                    commendResolve()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新选择状态
        local silkbag_fast_resolve_select_refresh_terminal = {
            _name = "silkbag_fast_resolve_select_refresh",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    local mId = params[1]
                    local mState = params[2]
                    instance:changeSelectState(mId, mState)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新快选结果
        local silkbag_fast_resolve_screen_refresh_terminal = {
            _name = "silkbag_fast_resolve_screen_refresh",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if params then
                    local mHaveList = params[1]
                    instance:refreshSelectState(mHaveList)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(silkbag_fast_resolve_open_terminal)
        state_machine.add(silkbag_fast_resolve_close_terminal)
        state_machine.add(silkbag_fast_resolve_show_terminal)
        state_machine.add(silkbag_fast_resolve_hide_terminal)
        state_machine.add(silkbag_fast_resolve_quick_select_terminal)
        state_machine.add(silkbag_fast_resolve_click_ok_terminal)
        state_machine.add(silkbag_fast_resolve_select_refresh_terminal)
        state_machine.add(silkbag_fast_resolve_screen_refresh_terminal)
        state_machine.init()
    end
    -- call func init silkbag_fast_resolve state machine.
    init_silkbag_fast_resolve_terminal()
end

-- 对象初始化
function SilkBagFastResolve:init(params)
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function SilkBagFastResolve:onInit(params)
    local csbNode = csb.createNode("cultivate/silk_bag_break_down.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    self:drawBtn()
    self:initSelectState()
    self:onUpdateDraw()
    self:onDrawScrol()
    self:onDrawResolveInfo()
end

function SilkBagFastResolve:onUpdateDraw()
    local root = self.roots[1]
    self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
    -- 数量
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 获得精华数量
    self.Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")
end

function SilkBagFastResolve:onDrawResolveInfo()
    local haveSelect = self:getSelectedList()
    self.Text_1:setString(#haveSelect .. "")
    local getNum = 0
    if #haveSelect > 0 then
        for i, v in ipairs(haveSelect) do
            local propInfo = dms.string(dms["ship_silk_bag_mould"], v.silkBagMouldId, ship_silk_bag_mould.decompose_output)
            local addNum = tonumber(zstring.split(propInfo, ",")[3])
            getNum = getNum + addNum
        end
    end

    self.Text_2:setString(getNum .. "")
end

function SilkBagFastResolve:initSelectState()
    self._silkList = self:getSortedHeroes()
end

function SilkBagFastResolve:refreshSelectState(haveList)
    if #haveList > 0 then
        for i, v in ipairs(self._silkList) do
            local quality = dms.int(dms["ship_silk_bag_mould"], v.silkBagMouldId, ship_silk_bag_mould.quality_level)
            local isSelect = false
            for m, val in ipairs(haveList) do
                if quality == val then
                    self._silkList[i].selectState = true
                    isSelect = true
                    break
                end
            end
            if isSelect == false then
                self._silkList[i].selectState = false
            end
        end
    else
        self:initSelectState()
    end
    self:onDrawScrol()
    self:onDrawResolveInfo()
end

function SilkBagFastResolve:changeSelectState(id, state)
    for i, v in ipairs(self._silkList) do
        if tonumber(id) == tonumber(v.info.id) then
            self._silkList[i].selectState = state
        end
    end

    self:onDrawResolveInfo()
end

function SilkBagFastResolve:getSelectedList()
    local result = {}
    for i, v in ipairs(self._silkList) do
        if v.selectState == true then
            table.insert(result, v)
        end
    end
    return result
end

function SilkBagFastResolve:haveHighQulity(selectList)
    for i, v in ipairs(selectList) do
        local mould_id = v.info.silkBagMouldId
        local quality = dms.int(dms["ship_silk_bag_mould"], mould_id, ship_silk_bag_mould.quality_level)
        if 3 <= quality then
            return true
        end
    end
    return false
end

function SilkBagFastResolve:onDrawScrol()
    local silkInfo = self._silkList
    local m_ScrollView = self.ScrollView_1
    m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0, 0))
    panel:removeAllChildren(true)
    local horizontalNumber = 2
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth / horizontalNumber

    local Hlindex = 0
    local number = table.nums(silkInfo)
    local m_number = math.ceil(number / horizontalNumber)

    local cell_height = 0
    local resultInfo = {}
    local mIdx = 1
    for j, v in pairs(silkInfo) do
        local cell = SmCultivateResolvecell:createCell()
        cell:init(v, mIdx)
        cell_height = cell:getContentSize().height
        table.insert(resultInfo,cell)
        mIdx = mIdx + 1
    end

    cellHeight = math.ceil(cell_height * m_number)
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(cc.size(m_ScrollView:getContentSize().width,sHeight))

    local index = 1
    for i,v in ipairs(resultInfo) do 
        panel:addChild(v)
        tWidth = tWidth + wPosition
        if (index - 1) % horizontalNumber == 0 then
            Hlindex = Hlindex + 1
            tWidth = 0
            tHeight = sHeight - cell_height * Hlindex
        end
        if index <= horizontalNumber then
            tHeight = sHeight - cell_height
        end

        v:setPosition(cc.p(tWidth, tHeight))
        index = index + 1
    end

    m_ScrollView:jumpToTop()

    self.currentScrollView = m_ScrollView
    self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()
end

function SilkBagFastResolve:onUpdate(dt)
    if self.currentScrollView ~= nil and self.currentScrollViewInnerContainer ~= nil then
        local size = self.currentScrollView:getContentSize()
        local posY = self.currentScrollViewInnerContainer:getPositionY()
        if self.currentScrollViewInnerContainerPosY == posY then
            return
        end
        self.currentScrollViewInnerContainerPosY = posY
        local items = self.currentScrollView:getChildren()
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

function SilkBagFastResolve:getSortedHeroes()
    local function fightingCapacity(a, b)
        local mouldTypeA = dms.int(dms["ship_silk_bag_mould"], tonumber(a.silkBagMouldId), ship_silk_bag_mould.mould_type) * 10000
        local mouldTypeB = dms.int(dms["ship_silk_bag_mould"], tonumber(b.silkBagMouldId), ship_silk_bag_mould.mould_type) * 10000

        local qualityA = dms.int(dms["ship_silk_bag_mould"], tonumber(a.silkBagMouldId), ship_silk_bag_mould.quality_level) * 500
        local qualityB = dms.int(dms["ship_silk_bag_mould"], tonumber(b.silkBagMouldId), ship_silk_bag_mould.quality_level) * 500

        local compareA = mouldTypeA + qualityA + a.silkBagMouldId
        local compareB = mouldTypeB + qualityB + b.silkBagMouldId

        local result = false
        if compareA > compareB then
            result = true
        end
        return result
    end
    local tSortedHeroes = {}

    if _ED.silkbag_pack_info == nil then
        return tSortedHeroes
    end
    tSortedHeroes = self:getNoUseSkilBagInfo()

    table.sort(tSortedHeroes, fightingCapacity)
    return tSortedHeroes
end

function SilkBagFastResolve:getNoUseSkilBagInfo()
    local data = {}
    for k, v in pairs(_ED.silkbag_pack_info) do
        if tonumber(v.onUseIndex) == -1 then
            table.insert(data, {info = v, silkBagMouldId = tonumber(v.silkBagMouldId), selectState = false})
        end
    end
    return data
end

function SilkBagFastResolve:drawBtn()
    local root = self.roots[1]
    -- 关闭
    self.Button_closed =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_closed"),
        nil,
        {
            terminal_name = "silkbag_fast_resolve_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 快速选择
    self.Button_quick_select =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_quick_select"),
        nil,
        {
            terminal_name = "silkbag_fast_resolve_quick_select",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 分解
    self.Button_fenjie =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_fenjie"),
        nil,
        {
            terminal_name = "silkbag_fast_resolve_click_ok",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )
end

function SilkBagFastResolve:onEnterTransitionFinish()
end

function SilkBagFastResolve:onExit()
    -- 释放SilkBagFastResolveWindow界面资源.
    state_machine.remove("silkbag_fast_resolve_open")
    state_machine.remove("silkbag_fast_resolve_close")
    state_machine.remove("silkbag_fast_resolve_show")
    state_machine.remove("silkbag_fast_resolve_hide")
    state_machine.remove("silkbag_fast_resolve_quick_select")
    state_machine.remove("silkbag_fast_resolve_click_ok")
    state_machine.remove("silkbag_fast_resolve_select_refresh")
    state_machine.remove("silkbag_fast_resolve_screen_refresh")
end

function SilkBagFastResolve:close()
    -- window event : close.
end

function SilkBagFastResolve:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
