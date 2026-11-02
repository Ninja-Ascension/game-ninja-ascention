--[[ ----------------------------------------------------------------------------
-- 购买战令进阶卡
--]] ----------------------------------------------------------------------------
ConstructionOrderBuyEnter = class("ConstructionOrderBuyEnterClass", Window)

-- 打开窗口
local construction_order_buy_enter_window_open_terminal = {
    _name = "construction_order_buy_enter_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ConstructionOrderBuyEnterClass") then
            fwin:open(ConstructionOrderBuyEnter:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local construction_order_buy_enter_window_close_terminal = {
    _name = "construction_order_buy_enter_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ConstructionOrderBuyEnterClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_buy_enter_window_open_terminal)
state_machine.add(construction_order_buy_enter_window_close_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderBuyEnter:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
   self.rewardInfo = {}
   self.curPeriod = 0               -- 当前期数

    -- Initialize construction_order_buy_enter page state machine.
    local function init_construction_order_buy_enter_terminal()
        -- 打开角色创建窗口
        local construction_order_buy_enter_open_terminal = {
            _name = "construction_order_buy_enter_open",
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
        local construction_order_buy_enter_close_terminal = {
            _name = "construction_order_buy_enter_close",
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
        local construction_order_buy_enter_show_terminal = {
            _name = "construction_order_buy_enter_show",
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
        local construction_order_buy_enter_hide_terminal = {
            _name = "construction_order_buy_enter_hide",
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

        -- 点击购买
        local construction_order_buy_enter_buy_terminal = {
            _name = "construction_order_buy_enter_buy",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 点击购买
                if nil ~= instance then
                    local period = params._datas.curPeriod
                    _ED.purchaseConstruction = true
                    local rechargeMouldIdx = dms.searchs(dms["pass_mould"], pass_mould.type, WarOrderAllTypeEnum.ConstructionWarOrder, pass_mould.stage, period)[1]
                    local giftIdx = tonumber(rechargeMouldIdx[pass_mould.giftID])
                    -- print(giftIdx, "======giftIdx")
                    PullUpRechargeWindow({curPurchaseGiftID = giftIdx})

                    state_machine.excute("construction_order_buy_enter_window_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(construction_order_buy_enter_open_terminal)
        state_machine.add(construction_order_buy_enter_close_terminal)
        state_machine.add(construction_order_buy_enter_show_terminal)
        state_machine.add(construction_order_buy_enter_hide_terminal)
        state_machine.add(construction_order_buy_enter_buy_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_construction_order_buy_enter_terminal()
end

-- 显示当前挡位价格
function ConstructionOrderBuyEnter:getCurPrice()
    local warOrderInfo = dms.searchs(dms["pass_mould"], pass_mould.type, WarOrderAllTypeEnum.ConstructionWarOrder, pass_mould.stage, self.curPeriod)
    local giftID = dms.atoi(warOrderInfo[1], pass_mould.giftID)
    local gearID = dms.int(dms["recharge_gear_mould"], giftID, recharge_gear_mould.gearID)
    local money = dms.string(dms["top_up_goods"], gearID, top_up_goods.money)

    self.Text_price:setString(_string_piece_info[217]..money)
end

function ConstructionOrderBuyEnter:initDrawList()
 
    local mScorllView = self.Scrollview_reward
    mScorllView:removeAllChildren(true)
    local rewardsInfo = MergerSameRewards(self.rewardInfo)
    local cell_size = nil
    local all = table.nums(rewardsInfo)
    local width_n = math.ceil(all / 2)
    local index = 1
    local cellList = {}
    for i, v in ipairs(rewardsInfo) do
        local cell = DrawHandle.drawIcon(v)

        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
        cell:setPosition(cc.p(((index - 1) % width_n) * cell_size.width, (2 - math.ceil(index / width_n)) * cell_size.height))
        mScorllView:addChild(cell)
        index = index + 1
    end

    mScorllView:jumpToLeft()

    if nil ~= cell_size then
        self.roll_width = cell_size.width * 3
        local InnerWidth = math.max(cell_size.width * width_n, mScorllView:getContentSize().width)
        local InnerHeight = mScorllView:getInnerContainer():getContentSize().height
        mScorllView:getInnerContainer():setContentSize(cc.size(InnerWidth, InnerHeight))
    end
end

-- 对象初始化
function ConstructionOrderBuyEnter:init(params)
    self.rewardInfo = params.allRewardInfo
    self.curPeriod = params.curPeriod
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self 
end


function ConstructionOrderBuyEnter:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/passport/passport_main_jianhao_unlock.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)


    -- 关闭界面
    self.Button_close =
    fwin:addTouchEventListener(
    ccui.Helper:seekWidgetByName(root, "Button_1"),
    nil,
    {
        terminal_name = "construction_order_buy_enter_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    },
    nil,
    0
    )

    -- 点击购买
    self.Button_buy =
    fwin:addTouchEventListener(
    ccui.Helper:seekWidgetByName(root, "Button_2"),
    nil,
    {
        terminal_name = "construction_order_buy_enter_buy",
        terminal_state = 0,
        isPressedActionEnabled = true,
        curPeriod = self.curPeriod,
    },
    nil,
    0
    )

    self.Scrollview_reward = ccui.Helper:seekWidgetByName(root, "ScrollView_1")

    -- 价格文本
    self.Text_price = ccui.Helper:seekWidgetByName(root, "Text_3")

    self:initDrawList()
    self:getCurPrice()
end

function ConstructionOrderBuyEnter:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("construction_order_buy_enter_open")
    state_machine.remove("construction_order_buy_enter_close")
    state_machine.remove("construction_order_buy_enter_show")
    state_machine.remove("construction_order_buy_enter_hide")
    state_machine.remove("construction_order_buy_enter_buy")
    
end

function ConstructionOrderBuyEnter:close()
    -- window event : close.
end

function ConstructionOrderBuyEnter:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
