--[[ ----------------------------------------------------------------------------
-- 购买战令进阶卡
--]] ----------------------------------------------------------------------------
CommonOrderBuyEnter = class("CommonOrderBuyEnterClass", Window)

-- 打开窗口
local common_order_buy_enter_window_open_terminal = {
    _name = "common_order_buy_enter_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("CommonOrderBuyEnterClass") then
            fwin:open(CommonOrderBuyEnter:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local common_order_buy_enter_window_close_terminal = {
    _name = "common_order_buy_enter_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("CommonOrderBuyEnterClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(common_order_buy_enter_window_open_terminal)
state_machine.add(common_order_buy_enter_window_close_terminal)
state_machine.init()

-- 构造器
function CommonOrderBuyEnter:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
   self.rewardInfo = {}
   self.curType = 0
   self.curStage = 0

    -- Initialize common_order_buy_enter page state machine.
    local function init_common_order_buy_enter_terminal()
        -- 打开角色创建窗口
        local common_order_buy_enter_open_terminal = {
            _name = "common_order_buy_enter_open",
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
        local common_order_buy_enter_close_terminal = {
            _name = "common_order_buy_enter_close",
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
        local common_order_buy_enter_show_terminal = {
            _name = "common_order_buy_enter_show",
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
        local common_order_buy_enter_hide_terminal = {
            _name = "common_order_buy_enter_hide",
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
        local common_order_buy_enter_buy_terminal = {
            _name = "common_order_buy_enter_buy",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 点击购买
                if nil ~= instance then
                    local cell = params._datas.cell
                    local stage = cell.curStage
                    local type = cell.curType
                    _ED.purchaseCommon = true
                    local rechargeMouldIdx = dms.searchs(dms["pass_mould"], pass_mould.type, type, pass_mould.stage, stage)[1]
                    local giftIdx = tonumber(rechargeMouldIdx[pass_mould.giftID])
                    PullUpRechargeWindow({curPurchaseGiftID = giftIdx})
                    
                    -- state_machine.excute("common_order_main_activation_warorder", 0, nil)

                    state_machine.excute("common_order_buy_enter_window_close", 0, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }


        state_machine.add(common_order_buy_enter_open_terminal)
        state_machine.add(common_order_buy_enter_close_terminal)
        state_machine.add(common_order_buy_enter_show_terminal)
        state_machine.add(common_order_buy_enter_hide_terminal)
        state_machine.add(common_order_buy_enter_buy_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_common_order_buy_enter_terminal()
end

-- 显示当前挡位价格
function CommonOrderBuyEnter:getCurPrice()
    local warOrderInfo = dms.searchs(dms["pass_mould"], pass_mould.type, self.curType, pass_mould.stage, self.curStage)
    local giftID = dms.atoi(warOrderInfo[1], pass_mould.giftID)
    local gearID = dms.int(dms["recharge_gear_mould"], giftID, recharge_gear_mould.gearID)
    local money = dms.string(dms["top_up_goods"], gearID, top_up_goods.money)
    self.Text_price:setString(_string_piece_info[217]..money)
end

function CommonOrderBuyEnter:initDrawList()
 
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
function CommonOrderBuyEnter:init(params)
    self.rewardInfo = params.allRewardInfo
    self.curStage = params.stage
    self.curType = params.type
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function CommonOrderBuyEnter:onInit()
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
            terminal_name = "common_order_buy_enter_window_close",
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
            terminal_name = "common_order_buy_enter_buy",
            terminal_state = 0,
            isPressedActionEnabled = true,
            cell = self,
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


function CommonOrderBuyEnter:onEnterTransitionFinish()
    
end

function CommonOrderBuyEnter:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("common_order_buy_enter_open")
    state_machine.remove("common_order_buy_enter_close")
    state_machine.remove("common_order_buy_enter_show")
    state_machine.remove("common_order_buy_enter_hide")
    state_machine.remove("common_order_buy_enter_buy")
    
end

function CommonOrderBuyEnter:close()
    -- window event : close.
end

function CommonOrderBuyEnter:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
