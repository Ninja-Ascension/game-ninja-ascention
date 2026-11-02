--------------------------------------------------------------------------------------------------------------
--  建号战令普通商店列表cell
--------------------------------------------------------------------------------------------------------------
ConstructionOrderShopListNormal = class("ConstructionOrderShopListNormalClass", Window)
ConstructionOrderShopListNormal.__size = nil

-- 创建cell
local construction_order_shop_list_normal_create_terminal = {
    _name = "construction_order_shop_list_normal_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ConstructionOrderShopListNormal:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_shop_list_normal_create_terminal)
state_machine.init()

function ConstructionOrderShopListNormal:ctor()
    self.super:ctor()
    self.roots = {}

    self.index = 0
    self.productID = 0
    self.itemInfo = {}

    
    app.load("client.packs.prop.ComExchange")

    -- 初始化状态机
    local function init_construction_order_shop_list_normal_terminal()
        -- 购买商品
        local construction_order_shop_list_normal_buy_terminal = {
            _name = "construction_order_shop_list_normal_buy",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 购买商品
                if nil ~= instance then
                    local cell = params._datas.cell
                    local prop = cell.prop
                    if cell.itemInfo.buyLimitString ~= "" then
                        TipDlg.drawTextDailog(cell.itemInfo.buyLimitString)
                        return false
                    end
                    if prop.remainCounts <= 0 then
                        TipDlg.drawTextDailog(war_order_str[19])
                        return false
                    end
                    if prop.prop_number <= 0 then
                        TipDlg.drawTextDailog(war_order_str[13])
                        return false
                    end
                    cell.shopType = 1
                    cell.form_cell = "construction_order_shop"
					state_machine.excute("com_exchange_use_open",0,cell)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_shop_list_normal_buy_terminal)
        state_machine.init()
    end 
    init_construction_order_shop_list_normal_terminal()

end

-- function ConstructionOrderShopListNormal:canBuyProduct()
--     local sale = self.sale_percentage
-- end

-- 获取限购次数文本
function ConstructionOrderShopListNormal:getLimitString()
    local limitString = ""
    local exchangeType = self.itemInfo.exchangeType
    if exchangeType == 0 then
        limitString = war_order_str[9]
    elseif exchangeType == 1 then
        limitString = war_order_str[10]
    elseif exchangeType == 2 then
        limitString = war_order_str[11]
    elseif exchangeType == 3 then
        limitString = war_order_str[12]
    end
    return limitString
end

-- 设置限购条件文本
function ConstructionOrderShopListNormal:updateLimitPurchaseText()
    if self.itemInfo.buyLimitString ~= "" then
        self.Image_block:setVisible(true)
        self.Image_limit:setVisible(true)
        self.Text_limit:setString(self.itemInfo.buyLimitString)
    else
        self.Image_limit:setVisible(false)
    end
end

function ConstructionOrderShopListNormal:initDraw()
    local propCell = DrawHandle.drawIcon(self.itemInfo.propInfo)
    self.Panel_icon:addChild(propCell)


    local icon_index = dms.int(dms["prop_mould"], self.prop.id, prop_mould.pic_index)
	local resPath = string.format("image/common/currency/common_currency_%d.png", icon_index)
    self.Panel_cost:removeBackGroundImage()
	self.Panel_cost:setBackGroundImage(resPath)
    self.Text_cost:setString(self.prop.sale_percentage)

    local limitString = self:getLimitString()
    local retaminTimes = self.itemInfo.remainCounts
    local allTimes = self.itemInfo.allExchangeNums
    local retaminTimeString = retaminTimes.."/"..allTimes
    self.Text_1:setVisible(true)
    self.Text_1:setString(limitString..retaminTimeString)
    if self.Text_number ~= nil then
        self.Text_number:setVisible(true)
        self.Image_limit_bg_1:setVisible(true)
        
        self.Text_1:setString(limitString)
        self.Text_number:setString(retaminTimeString)
    end

    self.Text_name:setString(self.prop.mould_name)

    if retaminTimes <= 0 then
        self.Text_stateRoot:setVisible(true)
        self.Text_soldout:setVisible(true)
        self.Button_buy:setTouchEnabled(false)
        self.Image_block:setVisible(true)
    else
        self.Text_stateRoot:setVisible(false)
        self.Text_soldout:setVisible(false)
        self.Button_buy:setTouchEnabled(true)
        self.Image_block:setVisible(false)
    end
    
    --设置限购条件文本
    if self.Image_limit and self.Text_limit then
        self:updateLimitPurchaseText()
    end
end

function ConstructionOrderShopListNormal:initPropData()
    local info = self.itemInfo
	local prop_param = zstring.split(info.propInfo, ",")
    local prop = {}
    -- 商品类型
    prop.type = tonumber(prop_param[1])
    -- 类型对应的模板id
    prop.mould_id = tonumber(prop_param[2])
    -- 商品数量
    prop.number = tonumber(prop_param[3])
    
    local propInfo = getItemNameAndQuality(prop_param)
    prop.mould_name = propInfo[1]
    prop.prop_quality = propInfo[2]

	local costInfo = zstring.split(info.consumeProp, ",", function ( value ) return tonumber(value) end)

    -- 价格
    prop.sale_percentage = costInfo[3]
    -- 最大可购买次数
    self._maxTimes = self.exchangeCount
    --当前积分可以购买的次数
    local havePropNum = tonumber(getPropAllCountByMouldId(costInfo[2]))
    local may_num = math.floor(havePropNum / costInfo[3])
    prop.prop_number = may_num
    prop.remainCounts = info.remainCounts
    if may_num > info.remainCounts then
        prop.prop_number = info.remainCounts
    end
    -- prop.prop_number = 2
    prop.id = costInfo[2]
    self.prop = prop

end

-- 刷新
function ConstructionOrderShopListNormal:updateDraw()
    local root = self.roots[1]

    self.Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
    self.Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")

    -- 图片绘制容器
    self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    -- 消耗道具容器
    self.Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
    -- 消耗道具数量文本
    self.Text_cost = ccui.Helper:seekWidgetByName(root, "Text_8")
    -- 限购周期类型文本
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 道具名称文本
    self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_11")
    -- 商品状态文本标签父节点
    self.Text_stateRoot = ccui.Helper:seekWidgetByName(root, "Image_1")
    -- 商品不可购买底板
    self.Image_block = ccui.Helper:seekWidgetByName(root, "Image_2")
    
    -- 本次不需要的文本内容
    self.Text_state1 = ccui.Helper:seekWidgetByName(root, "Text_4")
    self.Text_state2 = ccui.Helper:seekWidgetByName(root, "Text_3")
    self.Text_state1:setVisible(false)
    self.Text_state2:setVisible(false)
    
    -- 已售罄文本
    self.Text_soldout = ccui.Helper:seekWidgetByName(root, "Text_2")

    -- 限购条件容器
    self.Image_limit = ccui.Helper:seekWidgetByName(root, "Image_limit")

    -- 限购条件文本
    self.Text_limit = ccui.Helper:seekWidgetByName(root, "Text_limit")

    -- 限购次数文本
    self.Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")

    -- 限购次数底板图片
	self.Image_limit_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_limit_bg_1")

    self:initDraw()
end 

function ConstructionOrderShopListNormal:onInit()
    local root = cacher.createUIRef("shop/new_shop_tab_1_cell.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ConstructionOrderShopListNormal.__size == nil then
        ConstructionOrderShopListNormal.__size = root:getContentSize()
    end

    self:initPropData()
    -- print(self.prop.remainCounts, "============remainCounts")
    -- 购买按钮
    self.Button_buy =
    fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_1"),
        nil,
        {
            terminal_name = "construction_order_shop_list_normal_buy",
            terminal_state = 0,
            isPressedActionEnabled = true,
            cell = self,
        },
        nil,
        0
    )

    self:clearUIInfo()
    self:updateDraw()
end

function ConstructionOrderShopListNormal:onEnterTransitionFinish()
    local root = self.roots[1]
end

function ConstructionOrderShopListNormal:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    -- 图片绘制容器
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    Panel_icon:removeAllChildren()
    -- 消耗道具容器
    local Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
    Panel_cost:removeAllChildren()
    -- 消耗道具数量文本
    local Text_cost = ccui.Helper:seekWidgetByName(root, "Text_8")
    Text_cost:setString("")
    -- 限购周期类型文本
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    Text_1:setString("")
    Text_1:setVisible(false)
    -- 道具名称文本
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_11")
    Text_name:setString("")
    -- 商品状态文本标签父节点
    local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
    Image_1:setVisible(false)
    -- 商品不可购买底板
    local Image_block = ccui.Helper:seekWidgetByName(root, "Image_2")
    Image_block:setVisible(false)
    -- 限购条件容器
    local Image_limit = ccui.Helper:seekWidgetByName(root, "Image_limit")
    if Image_limit ~= nil then
        Image_limit:setVisible(false)
    end
    -- 限购条件文本
    local Text_limit = ccui.Helper:seekWidgetByName(root, "Text_limit")
    if Text_limit ~= nil then
        Text_limit:setString("")
    end
    -- 限购次数文本
    local Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    if Text_number ~= nil then
        Text_number:setString("")
        Text_number:setVisible(false)
    end
    -- 限购次数底板
    local Image_limit_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_limit_bg_1")
    if Image_limit_bg_1 ~= nil then
        Image_limit_bg_1:setVisible(false)
    end
end

function ConstructionOrderShopListNormal:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ConstructionOrderShopListNormal:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:removeAllChildren(true)
    self:clearUIInfo()
    cacher.freeRef("shop/new_shop_tab_1_cell.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function ConstructionOrderShopListNormal:init(params)
    self.index = params.index
    self.itemInfo = params.info
    self.productID = params.info.productID
    -- if self.index ~= nil and self.index <= 15 then
       self:onInit()
    -- end
    self:setContentSize(ConstructionOrderShopListNormal.__size)
    return self
end

function ConstructionOrderShopListNormal:onExit()
    self:clearUIInfo()
    cacher.freeRef("shop/new_shop_tab_1_cell.csb", self.roots[1])
end