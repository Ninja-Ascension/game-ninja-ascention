LimSummonViewShop = class("LimSummonViewShopClass", Window)

-- 打开窗口
local lim_summon_view_shop_window_open_terminal = {
    _name = "lim_summon_view_shop_window_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("LimSummonViewShopClass") then
            fwin:open(LimSummonViewShop:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local lim_summon_view_shop_window_close_terminal = {
    _name = "lim_summon_view_shop_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("LimSummonViewShopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(lim_summon_view_shop_window_open_terminal)
state_machine.add(lim_summon_view_shop_window_close_terminal)
state_machine.init()

function LimSummonViewShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    local function init_lim_summon_view_shop_terminal()
        
        local lim_summon_view_shop_close_terminal = 
        {
            _name = "lim_summon_view_shop_close",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("LimSummonViewShopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local lim_summon_view_shop_refresh_terminal = 
        {
            _name = "lim_summon_view_shop_refresh",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 刷新商店
                if instance then
                    instance:refresh()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(lim_summon_view_shop_close_terminal)
        state_machine.add(lim_summon_view_shop_refresh_terminal)

        state_machine.init()
    end

    init_lim_summon_view_shop_terminal()
end

function LimSummonViewShop:init(params)
    self.params = params
    
    self:initData()
    
    if nil ~= self.onInit then
        self:onInit(params)
    end

    return self
end

function LimSummonViewShop:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/lim_summon/lim_summon_integral.csb")
    self:addChild(csbNode)

    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)

    -- 定义按钮控件
    self.Button_2 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil,
    {
        terminal_name = "lim_summon_view_shop_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self:onUpdateDraw()
    self:showData()
end

function LimSummonViewShop:onUpdateDraw()
    local root = self.roots[1]

    -- 定义除按钮外的其他UI控件
    -- 积分数量
    self.Text_16 = ccui.Helper:seekWidgetByName(root, "Text_16")
    
    self.ScrollView_1 = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
end

function LimSummonViewShop:initData()
    -- 更新数据
    self.idActivity = self.params

    -- 当前的积分数
    self.numPoints = LimSummonMgr:GetInstance():getCountJifen()

    self.lstItem = LimSummonMgr:GetInstance():getShopItemLst(self.idActivity)

    -- 对商店物品进行排序
    local function sortFunc(a, b)
        if a.status == b.status then
            return a.id < b.id
        end

        if a.status == LimSummonMgr:GetInstance().enumShopItemStatus.canBuy then
            return true
        end

        if b.status == LimSummonMgr:GetInstance().enumShopItemStatus.canBuy then
            return false
        end

        if a.status == LimSummonMgr:GetInstance().enumShopItemStatus.unBuy then
            return true
        end

        if b.status == LimSummonMgr:GetInstance().enumShopItemStatus.unBuy then
            return false
        end

        return false
    end
    table.sort(self.lstItem, sortFunc)
end

function LimSummonViewShop:showData()
    -- 更新显示

    -- 显示积分
    self.Text_16:setString(self.numPoints)

    -- 显示商品列表
    self.ScrollView_1:removeAllChildren(true)
    local Column = 4

    local cellList = {}
    for i, v in ipairs(self.lstItem) do
        local cell = LimSummonCellShop:new()
        cell:init(v)
        cell:setActivityId(self.idActivity)
        table.insert(cellList, cell)
    end

    local info = {}
    info.targetScrollView = self.ScrollView_1
    info.nodeList = cellList
    info.columns = Column
    
    addNodeToScrollView(info)
end

function LimSummonViewShop:refresh()
    self:initData()
    self:showData()
end

function LimSummonViewShop:onExit()
    state_machine.remove("lim_summon_view_shop_close")
    state_machine.remove("lim_summon_view_shop_refresh")
end

function LimSummonViewShop:close()

end

function LimSummonViewShop:destroy(window)
 
end