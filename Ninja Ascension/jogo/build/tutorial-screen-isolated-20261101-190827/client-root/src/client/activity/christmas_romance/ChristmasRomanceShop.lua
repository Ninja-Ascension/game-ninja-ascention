--[[ ----------------------------------------------------------------------------
-- 兑换商店
--]] ----------------------------------------------------------------------------
ChristmasRomanceShop = class("ChristmasRomanceShopClass", Window)

-- 打开窗口
local christmas_romance_shop_window_open_terminal = {
    _name = "christmas_romance_shop_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ChristmasRomanceShopClass") then
            fwin:open(ChristmasRomanceShop:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local christmas_romance_shop_window_close_terminal = {
    _name = "christmas_romance_shop_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ChristmasRomanceShopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(christmas_romance_shop_window_open_terminal)
state_machine.add(christmas_romance_shop_window_close_terminal)
state_machine.init()

-- 构造器
function ChristmasRomanceShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self._page = 0 -- 1:武将 2:忍具 3:装备 4:道具
    self._endTime = nil
    self._shopInfos = {}
    self._activityInfos = nil
    self._scroll_view = nil
    self._scroll_view_pox = 0
    self._scroll_view_width = 0
    self.roll_width = 0

    self.deltaTime = 1
    self.totalTime = 0

    app.load("client.activity.christmas_romance.ChristmasRomanceShopList")
    app.load("client.activity.christmas_romance.ChristmasRomanceExchangeTip")
    -- Initialize christmas romance shop page state machine.
    local function init_christmas_romance_shop_terminal()
        -- 打开角色创建窗口
        local christmas_romance_shop_open_terminal = {
            _name = "christmas_romance_shop_open",
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
        local christmas_romance_shop_close_terminal = {
            _name = "christmas_romance_shop_close",
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
        local christmas_romance_shop_show_terminal = {
            _name = "christmas_romance_shop_show",
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
        local christmas_romance_shop_hide_terminal = {
            _name = "christmas_romance_shop_hide",
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

        -- 刷新商店
        local christmas_romance_shop_refrush_terminal = {
            _name = "christmas_romance_shop_refrush",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance then
                    instance:getShopData()
                    instance:showShopList()
                    state_machine.excute("christmas_romance_top_info_refresh_prop_count", 0, nil)
                    fwin:addService(
                        {
                            callback = function(params)
                                state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 181)
                                state_machine.excute("notification_center_update", 0, "push_notification_christmas_romance_page_push")
                            end,
                            delay = 0
                        }
                    )
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切页
        local christmas_romance_shop_change_page_terminal = {
            _name = "christmas_romance_shop_change_page",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if nil ~= instance then
                    local mPage = params._datas.m_page
                    instance:changePage(mPage)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(christmas_romance_shop_open_terminal)
        state_machine.add(christmas_romance_shop_close_terminal)
        state_machine.add(christmas_romance_shop_show_terminal)
        state_machine.add(christmas_romance_shop_hide_terminal)
        state_machine.add(christmas_romance_shop_refrush_terminal)
        state_machine.add(christmas_romance_shop_change_page_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_christmas_romance_shop_terminal()
end

-- 对象初始化
function ChristmasRomanceShop:init(params)
    self._activityInfos = _ED.active_activity[181].activity_data
    self._endTime = _ED.active_activity[181].end_time
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ChristmasRomanceShop:onUpdateDraw()
    local root = self.roots[1]

    -- 商店货物 横向滚动容器
    self.ScrollView_stuff_list = ccui.Helper:seekWidgetByName(root, "ScrollView_stuff_list")

    -- 商店货物 竖向滚动容器
    self.ScrollView_stuff_list_vertical = ccui.Helper:seekWidgetByName(root, "ScrollView_stuff_list_vertical")
    -- 本期购买数量
    self.Text_count_buynumber = ccui.Helper:seekWidgetByName(root, "Text_count_buynumber")
    -- 本期兑换倒计时
    self.Text_countime_num = ccui.Helper:seekWidgetByName(root, "Text_countime_num")
    self.Text_countime_num = ccui.Helper:seekWidgetByName(root, "Text_countime_num")
    self:updateActivityRemainTime()
end

-- 切页
function ChristmasRomanceShop:changePage(pageIdx)
    if pageIdx and pageIdx == self._page then
        return
    end
    if pageIdx then
        self._page = pageIdx
    end
    local curPage = self._page
    self.Button_tab_hero:setTouchEnabled(true)
    self.Button_tab_hero:setHighlighted(false)
    self.Button_tab_renjv:setTouchEnabled(true)
    self.Button_tab_renjv:setHighlighted(false)
    self.Button_tab_zhuangbei:setTouchEnabled(true)
    self.Button_tab_zhuangbei:setHighlighted(false)
    self.Button_tab_daoju:setTouchEnabled(true)
    self.Button_tab_daoju:setHighlighted(false)

    if curPage == 1 then
        self.Button_tab_hero:setTouchEnabled(false)
        self.Button_tab_hero:setHighlighted(true)
    elseif curPage == 2 then
        self.Button_tab_renjv:setTouchEnabled(false)
        self.Button_tab_renjv:setHighlighted(true)
    elseif curPage == 3 then
        self.Button_tab_zhuangbei:setTouchEnabled(false)
        self.Button_tab_zhuangbei:setHighlighted(true)
    elseif curPage == 4 then
        self.Button_tab_daoju:setTouchEnabled(false)
        self.Button_tab_daoju:setHighlighted(true)
    end
    self:showShopList()
end

function ChristmasRomanceShop:sortList(items)
    local result = {}
    -- 售完的
    local outList = {}
    -- 未售完的
    local outListNot = {}

    for i, v in ipairs(items) do
        local surplusTimes = v._surplusTimes
        if surplusTimes > 0 then
            table.insert(outListNot, v)
        else
            table.insert(outList, v)
        end
    end

    for i, v in ipairs(outListNot) do
        table.insert(result, v)
    end

    for i, v in ipairs(outList) do
        table.insert(result, v)
    end

    return result
end

function ChristmasRomanceShop:getPageTime(mType)
    local infos = zstring.split(dms.string(dms["activity_config"], 95, activity_config.param), "|")[mType]
    local total = tonumber(zstring.split(infos, ",")[2])
    return total
end

-- 商店列表
function ChristmasRomanceShop:showShopList()
    local mType = self._page
    local pageHaveTime = _ED.active_activity[181].activity_data.shopState[mType].userAllBuyNumber
    local pageTotalTime = self:getPageTime(mType)
    self.Text_count_buynumber:setString(pageHaveTime .. "/" .. pageTotalTime)

    local shopInfos = self._shopInfos[mType]
    local cell_size = nil
    local all = table.nums(shopInfos)
    local width_n = math.ceil(all / 2)
    local index = 1
    local cellList = {}
    for i, v in ipairs(shopInfos) do
        local cell = state_machine.excute("christmas_romance_shop_list_create", 0, {mType = mType, infos = v})
        table.insert(cellList, cell)
    end

    local sortListCell = self:sortList(cellList)
    if self.ScrollView_stuff_list ~= nil then 
        -- 横向滑动
        local mScorllView = self.ScrollView_stuff_list
        mScorllView:removeAllChildren(true)
        for i, v in ipairs(sortListCell) do
            if cell_size == nil then
                cell_size = v:getContentSize()
            end
            v:setPosition(cc.p(((index - 1) % width_n) * cell_size.width, (2 - math.ceil(index / width_n)) * cell_size.height))
            mScorllView:addChild(v)
            index = index + 1
        end
    
        mScorllView:jumpToLeft()

        if nil ~= cell_size then
            self.roll_width = cell_size.width * 3
            local InnerWidth = math.max(cell_size.width * width_n, mScorllView:getContentSize().width)
            local InnerHeight = mScorllView:getInnerContainer():getContentSize().height
            mScorllView:getInnerContainer():setContentSize(cc.size(InnerWidth, InnerHeight))
        end
    elseif self.ScrollView_stuff_list_vertical ~= nil then 
        -- 竖向滑动
        local mScorllView = self.ScrollView_stuff_list_vertical
        mScorllView:removeAllChildren(true)
        local info = {}
        info.targetScrollView = mScorllView
        info.nodeList = sortListCell
        info.columns = 4
        
        addNodeToScrollView(info)
    end
end

function ChristmasRomanceShop:scrollRefrush()
    if self._scroll_view ~= nil then
        local size = self._scroll_view:getContentSize()
        local posX = self._scroll_view:getInnerContainer():getPositionX()
        if self._scroll_view_pox == posX then
            return
        end
        self._scroll_view_pox = posX
        local items = self._scroll_view:getChildren()

        -- if posX >= -40 then
        --     self.Button_arrow_left:setVisible(false)
        -- else
        --     self.Button_arrow_left:setVisible(true)
        -- end
        -- if posX <= -self._scroll_view:getInnerContainer():getContentSize().width + self._scroll_view:getContentSize().width + 40 then
        --     self.Button_arrow_right:setVisible(false)
        -- else
        --     self.Button_arrow_right:setVisible(true)
        -- end

        if items[1] == nil then
            return
        end
        local itemSize = items[1]:getContentSize()
        for i, v in pairs(items) do
            local tempX = v:getPositionX() + posX
            if tempX + itemSize.width < 0 or tempX > size.width + itemSize.width then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

-- 商店基础数据
function ChristmasRomanceShop:getShopData()
    self._activityInfos = _ED.active_activity[181].activity_data
    self._shopInfos = {}
    for i = 1, 3 do
        self._shopInfos[i] = {}
        local shopData = dms.searchs(dms["christmas_mall"], activity_christmas_romance_shop_mould.shop_type, i)
        for m, v in ipairs(shopData) do
            local temp = {}
            temp.id = tonumber(v[activity_christmas_romance_shop_mould.shop_ID])
            temp.reward = v[activity_christmas_romance_shop_mould.shop_reward]
            temp.price = tonumber(v[activity_christmas_romance_shop_mould.shop_price])
            temp.canBuyTimes = tonumber(v[activity_christmas_romance_shop_mould.shop_buy_time])
            self._shopInfos[i][m] = temp
        end
    end
    self._shopInfos[4] = self._activityInfos.shopProp
end

-- 页签红点刷新
function ChristmasRomanceShop:drawPageRed()
    for i = 1, 4 do
        state_machine.excute(
            "push_notification_center_manager",
            0,
            {
                _terminal_name = "push_notification_christmas_romance_page_push",
                _widget = self.Button_list[i],
                _invoke = nil,
                _pageIndex = 5,
                _pageType = i,
                _interval = 0.5
            }
        )
    end
end

function ChristmasRomanceShop:darwBtn()
    local root = self.roots[1]
    -- 规则按钮
    self.Button_rule =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_rule"),
        nil,
        {
            terminal_name = "christmas_romance_rule_window_open",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    -- 英雄分页
    self.Button_tab_hero =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_hero"),
        nil,
        {
            terminal_name = "christmas_romance_shop_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 1
        },
        nil,
        0
    )

    -- 忍具分页
    self.Button_tab_renjv =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_renjv"),
        nil,
        {
            terminal_name = "christmas_romance_shop_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 2
        },
        nil,
        0
    )

    -- 装备分页
    self.Button_tab_zhuangbei =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_zhuangbei"),
        nil,
        {
            terminal_name = "christmas_romance_shop_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 3
        },
        nil,
        0
    )

    -- 道具分页
    self.Button_tab_daoju =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_tab_daoju"),
        nil,
        {
            terminal_name = "christmas_romance_shop_change_page",
            terminal_state = 0,
            isPressedActionEnabled = true,
            m_page = 4
        },
        nil,
        0
    )

    -- 关闭界面
    self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "christmas_romance_shop_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true
        },
        nil,
        0
    )

    self.Button_list = {
        self.Button_tab_hero,
        self.Button_tab_renjv,
        self.Button_tab_zhuangbei,
        self.Button_tab_daoju
    }
end

function ChristmasRomanceShop:onUpdate(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime >= self.deltaTime then
        self:updateActivityRemainTime()
        self.totalTime = 0
    end
    -- self:scrollRefrush()
end

function ChristmasRomanceShop:updateActivityRemainTime()
    if self.Text_countime_num == nil or self._endTime == nil then
        return
    end
    local surplus_time = (self._endTime - (os.time() + _ED.time_add_or_sub) * 1000)
    self.Text_countime_num:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function ChristmasRomanceShop:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .. _string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0" .. _hourTime .. ":"
    else
        timeString = timeString .. _hourTime .. ":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0" .. _minutesTime .. ":"
    else
        timeString = timeString .. _minutesTime .. ":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0" .. _secondsTime
    else
        timeString = timeString .. _secondsTime
    end
    return timeString
end

function ChristmasRomanceShop:onEnterTransitionFinish()
    -- 加载ChristmasRomanceShopWindow界面资源.
    -- res.activity.christmas_romance.christmas_romance_shop = res/activity/christmas_romance/christmas_romance_shop.csb
    local csbNode = csb.createNode("activity/christmas_romance/christmas_romance_shop.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    local idResources = state_machine.excute("christmas_romance_get_resources_id")
    if idResources > 0 then
        local newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_bg.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_13"):loadTexture(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_box_1.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_3_0_0_0"):loadTexture(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_role.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_3_0_0_0_0"):loadTexture(newPath)
        end

        newPath = string.format("images/ui/text/sm_hd/christmas_romance/christmas_romance_%d/christmas_romance_title2.png", idResources)
        if cc.FileUtils:getInstance():isFileExist(newPath) then
            ccui.Helper:seekWidgetByName(root, "Image_title_1"):loadTexture(newPath)
        end
    end

    self:getShopData()
    self:darwBtn()
    self:onUpdateDraw()
    self:changePage(1)
    self:drawPageRed()

    -- 顶部道具信息
    state_machine.excute("christmas_romance_top_info_open", 0, {rootWindows = self, openType = 2})
end

function ChristmasRomanceShop:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("christmas_romance_shop_open")
    state_machine.remove("christmas_romance_shop_close")
    state_machine.remove("christmas_romance_shop_show")
    state_machine.remove("christmas_romance_shop_hide")
    state_machine.remove("christmas_romance_shop_refrush")
    state_machine.remove("christmas_romance_shop_change_page")
end

function ChristmasRomanceShop:close()
    -- window event : close.
end

function ChristmasRomanceShop:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
