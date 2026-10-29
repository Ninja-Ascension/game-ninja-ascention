ActivityGroupBuyCell0 = class("ActivityGroupBuyCell0Class", Window)

ActivityGroupBuyCell0.__size = nil

-- 创建Cell实例
local activity_group_buy_cell_0_create_terminal = {
    _name = "activity_group_buy_cell_0_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if ActivityGroupBuyCell0 then
            local cell = ActivityGroupBuyCell0:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(activity_group_buy_cell_0_create_terminal)
state_machine.init()

-- 构造器
function ActivityGroupBuyCell0:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    ------------------------------------------------------------------------ var------------------------------------------------------------------------

    ------------------------------------------------------------------ load lua files-------------------------------------------------------------------
    app.load("client.activity.group_buy.ActivityGroupBuyJd")
    ------------------------------------------------- Initialize summer drink cell page state machine---------------------------------------------------
    local function init_activity_group_buy_cell_0_terminal()
        -- 购买按钮
        local activity_group_buy_cell_0_onclick_buy_gift_terminal = {
            _name = "activity_group_buy_cell_0_onclick_buy_gift",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local function CallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        -- AQUI NO SE TOCA LA CELDA. El bloque del 176 llega
                        -- ANTES que esta respuesta y ProtocolParserCopyExx.lua
                        -- :16727 ya dispara `activity_group_buy_refresh_all`,
                        -- que rehace la lista entera: para cuando se ejecuta
                        -- esto la celda ya esta destruida y `_self:updateAll()`
                        -- reventaba («attempt to call method 'updateAll'»),
                        -- llevandose por delante la ventana de premio. Las dos
                        -- celdas hermanas -ActivityGroupBuyCell.lua:85 y
                        -- ActivityGroupBuyBox.lua:52- nunca lo hicieron.
                        app.load("client.reward.DrawRareReward")
                        local getRewardWnd = DrawRareReward:new()
                        getRewardWnd:init(7)
                        fwin:open(getRewardWnd, fwin._ui)

                        state_machine.excute("activity_group_buy_refresh_all", 0, "")
                    end
                end

                protocol_command.activity_group_buy_gift_pack.param_list = params._datas._self.cell_index
                NetworkManager:register(protocol_command.activity_group_buy_gift_pack.code, nil, nil, nil, params._datas._self, CallBack, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_group_buy_cell_0_onclick_buy_gift_terminal)
    end

    ------------------------------------------------- call func init user return window state machine---------------------------------------------------
    init_activity_group_buy_cell_0_terminal()
end

-- 对象初始化
function ActivityGroupBuyCell0:init(_data)
    if _data ~= nil then
        self._data = _data
    end

    self:onInit()
    self:setContentSize(ActivityGroupBuyCell0.__size)

    return self
end

function ActivityGroupBuyCell0:onInit()
    -- 加载ActivityGroupBuyCell界面资源.
    -- res.duplicate.pve_super_mopping_cell = duplicate/pve_super_mopping_cell.csb
    --[[ 不使用缓存创建
	local csbNode = csb.createNode("duplicate/pve_super_mopping_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
    -- [[ 使用缓存创建
    local root = cacher.createUIRef("activity/group_buy/group_buy_cell_0.csb", "root")
    -- ]]
    root:removeFromParent(false)
    table.insert(self.roots, root)
    self:addChild(root)
    if ActivityGroupBuyCell0.__size == nil then
        ActivityGroupBuyCell0.__size = root:getContentSize()
    end

    self:onUpdateDraw()
    self:buttonAddClickEvent()
end

function ActivityGroupBuyCell0:onUpdateDraw()
    local root = self.roots[1]

    -- 当前全服购买次数
    self.current_buy_time = self._data.totalNumber

    -- 全服最大购买次数
    local needNumbers = zstring.split(self._data.rateInfo, ",")
    local max_number = 0
    local current_index = 0
    local current_max_nums = {}
    for i, v in ipairs(needNumbers) do
        local current_num = tonumber(zstring.split(needNumbers[i], "-")[1])
        table.insert(current_max_nums, current_num)
    end

    max_number = current_max_nums[1]

    for i, num in ipairs(current_max_nums) do
        if self.current_buy_time >= current_max_nums[#current_max_nums] then
            max_number = current_max_nums[#current_max_nums]
            current_index = #current_max_nums
            break
        else
            if i < #current_max_nums then
                if self.current_buy_time >= num and self.current_buy_time < current_max_nums[i + 1] then
                    max_number = current_max_nums[i + 1]
                    current_index = i
                    break
                end
            end
        end
    end

    self.current_max_buy_time = max_number

    local maxNum = tonumber(zstring.split(needNumbers[table.nums(needNumbers)], "-")[1])

    -- 进度条差值
    self.current_loading_bar_value = self.current_buy_time / maxNum

    -- 标题文本内容
    self.current_title_msg = string.format(tipStringInfo_activity_group_buy[2], self._data.index + 1)

    -- 奖励数据
    self.current_reward_infos = self._data.reward

    -- 限购次数文本
    self.current_limit = self._data.todayBuyNumber .. "/" .. self._data.limit

    -- 原始价格文本
    self.current_base_price = string.format(tipStringInfo_activity_group_buy[3], self._data.defaultPrice)

    -- 折扣价格文本
    self.current_discount_price = string.format(tipStringInfo_activity_group_buy[3], self._data.currentPrice)

    -- 索引
    self.cell_index = self._data.index

    -----------------------------------------------------------------------------------------------------------------------------------------------------------

    -- 标题
    self.Text_recharge = ccui.Helper:seekWidgetByName(root, "Text_recharge")
    self.Text_recharge:setString(self.current_title_msg)

    -- 进度条
    self.LoadingBar_achievement = ccui.Helper:seekWidgetByName(root, "LoadingBar_achievement")
    self.LoadingBar_achievement:setPercent(self.current_loading_bar_value * 100)

    -- 进度条文本
    self.Text_buy = ccui.Helper:seekWidgetByName(root, "Text_buy")
    self.Text_buy:setString(self.current_buy_time .. "/" .. self.current_max_buy_time)

    -- 限购类型文本
    self.Text_limit_0 = ccui.Helper:seekWidgetByName(root, "Text_limit_0")
    self.Text_limit_0:setString(self._data.resetType == 0 and tipStringInfo_activity_group_buy[12] or tipStringInfo_activity_group_buy[11])

    -- 限购次数
    self.Text_limit = ccui.Helper:seekWidgetByName(root, "Text_limit")
    self.Text_limit:setString(self.current_limit)

    -- 奖励容器
    self.ListView_reward = ccui.Helper:seekWidgetByName(root, "ListView_reward")

    -- 绘制奖励
    local cells = DrawHandle.drawIcons(self.current_reward_infos)
    self.ListView_reward:removeAllItems()
    for i = 1, #cells do
        self.ListView_reward:addChild(cells[i])
    end
    self.ListView_reward:requestRefreshView()

    -- 购买按钮
    self.Button_zs = ccui.Helper:seekWidgetByName(root, "Button_zs")

    -- 原始价格
    self.Text_sale = ccui.Helper:seekWidgetByName(root, "Text_sale")
    self.Text_sale:setString(self.current_base_price)

    -- 折扣价格
    self.Text_zs = ccui.Helper:seekWidgetByName(root, "Text_zs")
    self.Text_zs:setString(self.current_discount_price)

    -- 进度条容器
    self.Panel_jd = ccui.Helper:seekWidgetByName(root, "Panel_jd")
    local panel_jd_size = self.Panel_jd:getContentSize()
    self.Panel_jd:removeAllChildren(true)
    for i, v in ipairs(needNumbers) do
        local current_n = tonumber(zstring.split(v, "-")[1])
        local discount_n = tonumber(zstring.split(v, "-")[2]) / 10
        local percentage = current_n / maxNum
        local cell = ActivityGroupBuyJd:createCell()
        cell:init({posX = panel_jd_size.width * percentage, discount_num = discount_n})
        self.Panel_jd:addChild(cell)
    end

    self:updateButtonState()
end

function ActivityGroupBuyCell0:updateAll()
    local activity_info = _ED.active_activity[176].activityAllData.activity_group_gift_info
    self._data = activity_info.info[tonumber(self.cell_index) + 1]
    if self._data ~= nil then
        self:onUpdateDraw()
        self:buttonAddClickEvent()
    end
end

function ActivityGroupBuyCell0:buttonAddClickEvent()
    -- 购买
    fwin:addTouchEventListener(
        self.Button_zs,
        nil,
        {
            terminal_name = "activity_group_buy_cell_0_onclick_buy_gift",
            terminal_state = 0,
            isPressedActionEnabled = true,
            _self = self
        },
        nil,
        0
    )
end

function ActivityGroupBuyCell0:updateButtonState()
    self.Button_zs:setTouchEnabled(self._data.todayBuyNumber < self._data.limit)
    self.Button_zs:setBright(self._data.todayBuyNumber < self._data.limit)
end

function ActivityGroupBuyCell0:onEnterTransitionFinish()
end

function ActivityGroupBuyCell0:createCell()
    local cell = ActivityGroupBuyCell0:new()
    cell:registerOnNodeEvent(cell)
    return cell
end

function ActivityGroupBuyCell0:onExit()
    -- 释放ActivityGroupBuyCell界面资源.
    -- [[ 释放缓存
    local root = self.roots[1]
    cacher.freeRef("activity/group_buy/group_buy_cell_0.csb", root)
    -- ]]
end

function ActivityGroupBuyCell0:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ActivityGroupBuyCell0:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:stopAllActions()
    root:removeFromParent(false)
    cacher.freeRef("activity/group_buy/group_buy_cell_0.csb", root)

    self.roots = {}
end
