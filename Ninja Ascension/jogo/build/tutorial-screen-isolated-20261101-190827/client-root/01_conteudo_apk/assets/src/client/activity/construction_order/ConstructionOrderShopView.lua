--[[ ----------------------------------------------------------------------------
-- 兑换商店滚动容器界面
--]] ----------------------------------------------------------------------------
ConstructionOrderShopView = class("ConstructionOrderShopViewClass", Window)
ConstructionOrderShopView.__size = nil

-- 打开窗口
local consturion_order_shop_view_window_create_terminal = {
    _name = "consturion_order_shop_view_window_create",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        -- if nil == fwin:find("ConstructionOrderShopViewClass") then
            local cell = ConstructionOrderShopView:new()
            cell:init(params)
            cell:registerOnNodeEvent(cell)
            return cell
        -- end
        -- return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(consturion_order_shop_view_window_create_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderShopView:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.curType = 0
    self.shopInfo = {}

    self.exchangeType = {
        DAYLIMIT = 0,               -- 每日限购
        WEEKLIMIT = 1,              -- 每周限购
        PERIODLIMIT = 2,            -- 每期限购
        LIFETIMELIMIT = 3,          -- 终身限购
    }

   
    app.load("client.activity.construction_order.ConstructionOrderShopListNormal")
    app.load("client.activity.construction_order.ConstructionOrderShopListSpecial")
    -- Initialize consturion_order_shop_view page state machine.
    local function init_consturion_order_shop_view_terminal()

        -- 切换商店类型
        local construction_order_shop_view_change_type_terminal = {
            _name = "construction_order_shop_view_change_type",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local type = params.shop_type
                    instance:updateDraw(type)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 购买商品后的刷新
        local construction_order_shop_view_refresh_terminal = {
            _name = "construction_order_shop_view_refresh",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    smFightingChange()
                    instance:updateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_shop_view_change_type_terminal)
        state_machine.add(construction_order_shop_view_refresh_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_consturion_order_shop_view_terminal()
end


function ConstructionOrderShopView:sortListItems()
    local finishedProduct = {}      -- 没有购买次数的商品
    local haveTimesProduct= {}      -- 有购买次数
    local result = {}

    local dayLimit = {}             -- 每日限购
    local weekLimit = {}            -- 每周限购
    local periodLimit = {}          -- 每期限购
    local lifeTimeLimit = {}        -- 终身限购

    for i, v in ipairs(self.shopInfo) do
        if v.exchangeType == self.exchangeType.DAYLIMIT then
            table.insert(dayLimit, v)
        elseif v.exchangeType == self.exchangeType.WEEKLIMIT then
            table.insert(weekLimit, v)
        elseif v.exchangeType == self.exchangeType.PERIODLIMIT then
            table.insert(periodLimit, v)
        elseif v.exchangeType == self.exchangeType.LIFETIMELIMIT then
            table.insert(lifeTimeLimit, v)
        end
    end

    for i, v in ipairs(dayLimit) do
        if v.remainCounts > 0 then
            table.insert(haveTimesProduct, v)
        else
            table.insert(finishedProduct, v)
        end
    end

    for i, v in ipairs(weekLimit) do
        if v.remainCounts > 0 then
            table.insert(haveTimesProduct, v)
        else
            table.insert(finishedProduct, v)
        end
    end

    for i, v in ipairs(periodLimit) do
        if v.remainCounts > 0 then
            table.insert(haveTimesProduct, v)
        else
            table.insert(finishedProduct, v)
        end
    end

    for i, v in ipairs(lifeTimeLimit) do
        if v.remainCounts > 0 then
            table.insert(haveTimesProduct, v)
        else
            table.insert(finishedProduct, v)
        end
    end
    for i, v in ipairs(haveTimesProduct) do
        table.insert(result, v)
    end

    for i, v in ipairs(finishedProduct) do
        table.insert(result, v)
    end

    return result

end

-- 获取每升一级所需的经验
function ConstructionOrderShopView:getEveryGradeNeedExp()
    local everyGradeExp = dms.int(dms["play_config"], 281, play_config.param)
    return everyGradeExp
end

-- 获取玩家当前战令等级
function ConstructionOrderShopView:getUserLevel()
    local exp = 0
    local user_order_info = _ED.active_activity[186].user_order_info
    if user_order_info ~= nil then
        exp = user_order_info.allExp
    end
    local everyGradeExp = self:getEveryGradeNeedExp()
    local curLevel = math.floor(exp / everyGradeExp)

    return curLevel
end

function ConstructionOrderShopView:getPurcharseLimitInfo(buyLimitString)
    local buyLimitInfo = zstring.split(buyLimitString, ",", tonumber)
    return buyLimitInfo
end

-- 获取商品限购内容文本
function ConstructionOrderShopView:getPurcharseLimitString(buyLimit)
    local limitBuyString = ""
    if buyLimit ~= nil then
        local buyLimitInfo = self:getPurcharseLimitInfo(buyLimit)
        local limitBuyType = buyLimitInfo[1]
        local limitBuyValue = buyLimitInfo[2]
        if limitBuyType == -1 then
            
        elseif limitBuyType == 1 then
            local warOrderLevel = self:getUserLevel()
            if warOrderLevel< limitBuyValue then
                limitBuyString = string.format(war_order_str[22], limitBuyValue)
            end
        elseif limitBuyType == 2 then
            if tonumber(_ED.user_info.user_grade) < limitBuyValue then
                limitBuyString = string.format(war_order_str[23], limitBuyValue)
            end
        elseif limitBuyType == 3 then
            if tonumber(_ED.npc_state[limitBuyValue]) <= 0 then
                limitBuyString = string.format(war_order_str[24], buyLimitInfo[3].."-"..buyLimitInfo[4])
            end
        end
    end
    
    return limitBuyString
end

-- 初始化商店数据
function ConstructionOrderShopView:initShopData()
    self.shopInfo = {}
    local user_order_info = _ED.active_activity[186].user_order_info
    if user_order_info == nil then
        return self.shopInfo
    end
    local remainCountsString = user_order_info.shopInfo[self.curType].remainCounts
    local remainCounts = zstring.split(remainCountsString, ",", function ( value ) return tonumber(value) end)
    local shopData = dms.searchs(dms["pass_shop_mould"], pass_shop_mould.type, self.curType)
    for i, v in ipairs(shopData) do
        local info = {}
        info.propInfo = v[pass_shop_mould.prop]                                -- 道具内容
        info.allExchangeNums = tonumber(v[pass_shop_mould.exchangeCounts])     -- 兑换最大数量
        info.exchangeType = tonumber(v[pass_shop_mould.exchangeType])          -- 兑换类型
        info.consumeProp = v[pass_shop_mould.consumeProp]                      -- 所消耗道具
        info.remainCounts = remainCounts[i]                                    -- 剩余购买次数
        info.skinID = tonumber(v[pass_shop_mould.skinID])                      -- 皮肤ID 
        info.productID = i

        local buyLimit = v[pass_shop_mould.buyLimit]                           -- 购买限制 
        info.buyLimitString = self:getPurcharseLimitString(buyLimit)           -- 限制条件文本

        table.insert(self.shopInfo, info)
    end
end


function ConstructionOrderShopView:updateDraw(type)
    if type ~= nil then
        self.curType = type
    end
    self:initShopData()
    self:drawShop()
end

function ConstructionOrderShopView:onUpdate(dt)
    -- if self.ScrooView_shop ~= nil then
    --     local posY = self.ScrooView_shop:getInnerContainer():getPositionY()
    --     if posY == self._scroll_view_posy then
    --         return
    --     end
    --     self._scroll_view_posy = posY

    --     local size = self.ScrooView_shop:getContentSize()
    --     local items = self._cell_group
    --     local itemSize = self._cell_size
    --     for i, v in pairs(items) do
    --         if v ~= nil and v ~= false then
    --             if v ~= nil then
    --                 local tempY = v:getPositionY() + posY
    --                 if tempY + itemSize.height < 0 or tempY > size.height + itemSize.height then
    --                     v:unload()
    --                 else
    --                     v:reload()
    --                 end
    --             end
    --         end
    --     end
    -- end
end

-- 进行商店的绘制
function ConstructionOrderShopView:drawShop()
    self.ScrooView_shop:removeAllChildren()

    self.shopInfo = self:sortListItems()

    local cell_size = nil
    local cell_group = {}
    local allNums = #self.shopInfo
    for k, v in pairs(self.shopInfo) do
        local cell = nil
        if self.curType == 1 then
            cell = state_machine.excute("construction_order_shop_list_normal_create", 0, {info = v, index = k})
        elseif self.curType == 2 then
            cell = state_machine.excute("construction_order_shop_list_special_create", 0, {info = v, index = k, shopInfo = self.shopInfo})
        end
        self.ScrooView_shop:addChild(cell)
        table.insert(cell_group, cell)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
    end
    if self.curType == 2 then
        local cell = state_machine.excute("construction_order_shop_list_special_create", 0, {info = -1, index = #self.shopInfo + 1, shopInfo = -1})
        self.ScrooView_shop:addChild(cell)
        table.insert(cell_group, cell)
        allNums = allNums + 1
    end
    local width = self.ScrooView_shop:getContentSize().width
    local height = self.ScrooView_shop:getContentSize().height
    local count = allNums
    local row_count = 5
    local col_count = math.ceil(count / row_count)
    if count > 0 then
        if cell_size.height * col_count > height then
            height = cell_size.height * col_count
        end
        -- 进行scrollView的绘制
        self.ScrooView_shop:getInnerContainer():setContentSize(cc.size(width, height + 15))
        for i = 1, count do
            local row = 0
            local col = 0
            local cell = nil
            row = math.floor((i - 1) % row_count)
            col = math.floor((i - 1) / row_count)
            cell = cell_group[i]
            cell:setAnchorPoint(cc.p(0,1))
            cell:setPosition(cc.p(row * (width / row_count), height - col * cell_size.height))
        end
    end

    self.ScrooView_shop:jumpToTop()

    self._scroll_view_posy = self.ScrooView_shop:getInnerContainer():getPositionY()
    self._cell_group = cell_group
    self._cell_size = cell_size
end

-- 对象初始化
function ConstructionOrderShopView:init(params)
    self.curType = params[1]
    if nil ~= self.onInit then
        self:onInit(params)
    end
    self:setContentSize(ConstructionOrderShopView.__size)
    return self
end

function ConstructionOrderShopView:onInit(params)
    -- 使用缓存创建
    local root = cacher.createUIRef("shop/new_shop_tab_1_0.csb", "root")
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
    if ConstructionOrderShopView.__size == nil then
        ConstructionOrderShopView.__size = root:getContentSize()
    end
 
    -- 商店容器
    self.ScrooView_shop = ccui.Helper:seekWidgetByName(root, "ScrollView_1")
 
    self:initShopData()
    self:drawShop()
end

function ConstructionOrderShopView:onEnterTransitionFinish()
   
end

function ConstructionOrderShopView:onExit()
    -- 释放ConstructionOrderShopView界面资源.
    local root = self.roots[1]
	cacher.freeRef("shop/new_shop_tab_1_0.csb", root)
    
end

-- ~END
-- ----------------------------------------------------------------------------
