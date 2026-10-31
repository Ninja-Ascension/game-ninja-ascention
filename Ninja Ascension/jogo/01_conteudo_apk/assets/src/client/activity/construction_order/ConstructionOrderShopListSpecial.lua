--------------------------------------------------------------------------------------------------------------
--  建号战令特殊商店列表cell
--------------------------------------------------------------------------------------------------------------
ConstructionOrderShopListSpecial = class("ConstructionOrderShopListSpecialClass", Window)
ConstructionOrderShopListSpecial.__size = nil

-- 创建cell
local construction_order_shop_list_special_create_terminal = {
    _name = "construction_order_shop_list_special_create",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local cell = ConstructionOrderShopListSpecial:new()
        cell:init(params)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_shop_list_special_create_terminal)
state_machine.init()

function ConstructionOrderShopListSpecial:ctor()
    self.super:ctor()
    self.roots = {}

    self.index = 0
    self.productID = 0
    self.shopInfo = {}
    self.itemInfo = {}
    self.enum_type = {
		PROP_INFORMATION = 6,						--	6:道具 
		EQUIPMENT_INFORMATION = 7,					--	7:装备 
        HERO_SKIN = 64,                             -- 64:皮肤
		SILKBAG_INFORMATION=71,						-- 71:锦囊(圣器)
		HEAD_FRAME = 76,							-- 76:头像框
    }

    app.load("client.activity.construction_order.ConstructionOrderShopListSpecialInfo")
    app.load("client.packs.prop.ComExchange")

    -- 初始化状态机
    local function init_construction_order_shop_list_special_window_terminal()
        -- 购买商品
        local construction_order_shop_list_special_buy_terminal = {
            _name = "construction_order_shop_list_special_buy",
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
                    cell.shopType = 2
                    cell.form_cell = "construction_order_shop"
					state_machine.excute("com_exchange_use_open",0,cell)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 查看详细信息
        local construction_order_shop_list_special_see_terminal = {
            _name = "construction_order_shop_list_special_see",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                -- 查看详细信息
                if nil ~= instance then
                    local cell = params._datas.cell
                    state_machine.excute("construction_order_shop_list_special_info_window_open", 0, {shopInfo = cell.shopInfo, propInfo = cell.itemInfo, curIndex = cell.index, productID = cell.productID})
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_shop_list_special_buy_terminal)
        state_machine.add(construction_order_shop_list_special_see_terminal)
        state_machine.init()
    end 
    init_construction_order_shop_list_special_window_terminal()

end

-- 兑换图片显示
function ConstructionOrderShopListSpecial:updateDrawPic()
    self.Panel_icon:removeBackGroundImage()
    
    local iconResPath = self:getPicPath()
    if true == cc.FileUtils:getInstance():isFileExist(iconResPath) then
        self.Panel_icon:setBackGroundImage(iconResPath)
    end
end

-- 获取图片对应路径
function ConstructionOrderShopListSpecial:getPicPath()
    local mouldID = self.prop.mould_id
    local type = self.prop.type
    local picIndex = -1
    local iconResPath = ""

    if type == self.enum_type.HERO_SKIN then
        picIndex = self.itemInfo.skinID
        iconResPath = string.format("image/cut/shop/cut_shop_role_%d.png", picIndex)
    elseif type == self.enum_type.HEAD_FRAME then
        local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, mouldID)[1]
        picIndex = dms.atoi(headFrameInfo, face_frame_mould.resID)
        iconResPath = string.format("image/cut/frame/cut_frame_%d.png", picIndex)
    elseif type == self.enum_type.PROP_INFORMATION then
        picIndex = setThePropsIcon(mouldID)[1]
        iconResPath = string.format("images/ui/props/props_%d.png", picIndex)
    elseif type == self.enum_type.EQUIPMENT_INFORMATION then
        picIndex = dms.int(dms["equipment_mould"], mouldID, equipment_mould.pic_index)
        iconResPath = string.format("images/ui/props/props_%d.png", picIndex)
    elseif type == self.enum_type.SILKBAG_INFORMATION then
        picIndex = dms.int(dms["ship_silk_bag_mould"], mouldID, ship_silk_bag_mould.pic_index)
        iconResPath = string.format("images/ui/props/props_%d.png", picIndex)
    end

    return iconResPath
end

-- 获取限购次数文本
function ConstructionOrderShopListSpecial:getLimitString()
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
function ConstructionOrderShopListSpecial:updateLimitPurchaseText()
    if self.itemInfo.buyLimitString ~= "" then
        self.Image_blocak:setVisible(true)
        self.Image_limit:setVisible(true)
        self.Text_limit:setString(self.itemInfo.buyLimitString)
    else
        self.Image_limit:setVisible(false)
    end
end

-- 没有道具信息时的绘制
function ConstructionOrderShopListSpecial:initDisplay()
    self.Button_buy:setTouchEnabled(false)
    self.Button_see:setTouchEnabled(false)
    self.Text_cost:setVisible(false)
    -- local icon_index = dms.int(dms["prop_mould"], self.prop.id, prop_mould.pic_index)
	-- local resPath = string.format("image/common/currency/common_currency_%d.png", icon_index)
    local resPath = "image/cut/shop/cut_shop_role_0.png"
    self.Panel_icon:removeBackGroundImage()
	self.Panel_icon:setBackGroundImage(resPath)

    self.Text_name:setVisible(false)
end

function ConstructionOrderShopListSpecial:initDraw()
    -- local propCell = DrawHandle.drawIcon(self.itemInfo.propInfo)
    -- self.Panel_icon:addChild(propCell)
    self:updateDrawPic()

    local icon_index = dms.int(dms["prop_mould"], self.prop.id, prop_mould.pic_index)
	local costResPath = string.format("image/common/currency/common_currency_%d.png", icon_index)
    self.Panel_cost:removeBackGroundImage()
	self.Panel_cost:setBackGroundImage(costResPath)
    self.Text_cost:setString(self.prop.sale_percentage)

    -- local evo_mould_id = dms.int(dms["ship_skin_mould"], self.prop.mould_id, ship_skin_mould.ship_evo_id)
	-- local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    

    -- 兑换次数文本
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
    -- 道具名称
    self.Text_name:setVisible(true)
    self.Text_name:setString(self.prop.mould_name)
    -- 售罄时图片显示
    if retaminTimes <= 0 then
        self.Text_root:setVisible(true)
        self.Text_nocounts:setVisible(true)
        self.Image_blocak:setVisible(true)
    end
    
    --设置限购条件文本
    if self.Image_limit and self.Text_limit then
        self:updateLimitPurchaseText()
    end
end

-- 初始化道具数据
function ConstructionOrderShopListSpecial:initPropData()
    local info = self.itemInfo
	local prop_param = zstring.split(info.propInfo, ",", tonumber)
    local prop = {}
    local evo_mould_id = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.ship_evo_id)
    local picIndex = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.form_id)
    local ship_mould_id = dms.int(dms["ship_skin_mould"], self.mould_id, ship_skin_mould.ship_mould_id)
    -- 商品类型
    prop.type = tonumber(prop_param[1])
    -- 类型对应的模板id
    prop.mould_id = tonumber(prop_param[2])
    -- 商品数量
    prop.number = tonumber(prop_param[3])
    
    local nameInfo = getItemNameAndQuality(prop_param)
    prop.mould_name = nameInfo[1]
    prop.prop_quality = nameInfo[2]

	local costInfo = zstring.split(info.consumeProp, ",", function ( value ) return tonumber(value) end)
    prop.costInfo = costInfo
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
    prop.id = costInfo[2]
    self.prop = prop
end

-- 刷新
function ConstructionOrderShopListSpecial:updateDraw()
    local root = self.roots[1]
    self.Text_root = ccui.Helper:seekWidgetByName(root, "Image_1")
    -- 售罄文本
    self.Text_nocounts = ccui.Helper:seekWidgetByName(root, "Text_2")
    -- 获得数码兽后解锁
    self.Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
    -- 
    self.Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")
    -- 售罄时图片遮罩
    self.Image_blocak = ccui.Helper:seekWidgetByName(root, "Image_2")
    -- 图片绘制容器
    self.Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    -- 消耗道具容器
    self.Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
    -- 消耗道具数量文本
    self.Text_cost = ccui.Helper:seekWidgetByName(root, "Text_8")
    -- 限购次数文本
    self.Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    -- 道具名称文本
    self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_11")
    -- 限购次数文本
    self.Text_number = ccui.Helper:seekWidgetByName(root, "Text_number")
    -- 限购条Text_number件容器
    self.Image_limit = ccui.Helper:seekWidgetByName(root, "Image_limit")
    -- 限购条件文本
    self.Text_limit = ccui.Helper:seekWidgetByName(root, "Text_limit")
    -- 限购次数底板
    self.Image_limit_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_limit_bg_1")

    if self.itemInfo ~= -1 then
        self:initPropData()
        self:initDraw()
    else
        self:initDisplay()
    end
end 

function ConstructionOrderShopListSpecial:onInit()
    local root = cacher.createUIRef("shop/new_shop_tab_1_cell_0.csb", "root")
    table.insert(self.roots, root)
    self:addChild(root)

    if ConstructionOrderShopListSpecial.__size == nil then
        ConstructionOrderShopListSpecial.__size = root:getContentSize()
    end

    -- 购买按钮
    self.Button_buy = fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_1"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_buy",
            terminal_state = 0,
            isPressedActionEnabled = true,
            cell = self,
        },
        nil,
        0
    )

    -- 查看角色信息
    self.Button_see = fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_role_info"),
        nil,
        {
            terminal_name = "construction_order_shop_list_special_see",
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

function ConstructionOrderShopListSpecial:onEnterTransitionFinish()
    local root = self.roots[1]
end

function ConstructionOrderShopListSpecial:clearUIInfo( ... )
    local root = self.roots[1]
    if root == nil then
        return
    end
    local root = self.roots[1]
    local Text_root = ccui.Helper:seekWidgetByName(root, "Image_1")
    Text_root:setVisible(false)
    -- 售罄文本
    local Text_nocounts = ccui.Helper:seekWidgetByName(root, "Text_2")
    Text_nocounts:setVisible(false)
    -- 获得数码兽后解锁
    local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
    Text_3:setVisible(false)
    -- 
    local Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")
    Text_4:setVisible(false)
    -- 售罄时图片遮罩
    local Image_blocak = ccui.Helper:seekWidgetByName(root, "Image_2")
    Image_blocak:setVisible(false)
    -- 图片绘制容器
    local Panel_icon = ccui.Helper:seekWidgetByName(root, "Panel_icon")
    Panel_icon:removeBackGroundImage()
    -- 消耗道具容器
    local Panel_cost = ccui.Helper:seekWidgetByName(root, "Panel_cost")
    Panel_cost:removeBackGroundImage()
    -- 消耗道具数量文本
    local Text_cost = ccui.Helper:seekWidgetByName(root, "Text_8")
    Text_cost:setString("")
    -- 限购次数文本
    local Text_1 = ccui.Helper:seekWidgetByName(root, "Text_1")
    Text_1:setString("")
    Text_1:setVisible(false)
    -- 道具名称文本
    local Text_name = ccui.Helper:seekWidgetByName(root, "Text_11")
    Text_name:setString("")
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
        Text_number:setVisible(false)
        Text_number:setString("")
    end
    -- 限购次数底板
    local Image_limit_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_limit_bg_1")
    if Image_limit_bg_1 ~= nil then
        Image_limit_bg_1:setVisible(false)
    end
end

function ConstructionOrderShopListSpecial:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end
    self:onInit()
end

function ConstructionOrderShopListSpecial:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
    self:removeAllChildren(true)
    self:clearUIInfo()
    cacher.freeRef("shop/new_shop_tab_1_cell_0.csb", root)
    root:removeFromParent(false)
    self.roots = {}
end

function ConstructionOrderShopListSpecial:init(params)
    self.index = params.index
    self.itemInfo = params.info
    if params.info ~= -1 then
        self.productID = params.info.productID
    end 
    self.shopInfo = params.shopInfo
    -- if self.index ~= nil and self.index <= 15 then
       self:onInit()
    -- end
    self:setContentSize(ConstructionOrderShopListSpecial.__size)
    return self
end

function ConstructionOrderShopListSpecial:onExit()
    self:clearUIInfo()
    cacher.freeRef("shop/new_shop_tab_1_cell_0.csb", self.roots[1])
end