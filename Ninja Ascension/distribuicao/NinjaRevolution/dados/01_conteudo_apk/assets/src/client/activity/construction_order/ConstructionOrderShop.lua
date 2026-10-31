--[[ ----------------------------------------------------------------------------
-- 兑换商店
--]] ----------------------------------------------------------------------------
ConstructionOrderShop = class("ConstructionOrderShopClass", Window)

-- 打开窗口
local construction_order_shop_window_open_terminal = {
    _name = "construction_order_shop_window_open",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("ConstructionOrderShopClass") then
            fwin:open(ConstructionOrderShop:new():init(params), fwin._view)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

-- 关闭窗口
local construction_order_shop_window_close_terminal = {
    _name = "construction_order_shop_window_close",
    _init = function(terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("ConstructionOrderShopClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(construction_order_shop_window_open_terminal)
state_machine.add(construction_order_shop_window_close_terminal)
state_machine.init()

-- 构造器
function ConstructionOrderShop:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}

    -- var
    self.shopTypeList = {
        NORMALSHOP = 1,             -- 常规商店
        SPECIALSHOP = 2,            -- 特殊商店
    }

    self.ButtonShopList = {}

    self.curType = 1                -- 当前商店类型
   
    app.load("client.activity.construction_order.ConstructionOrderShopView")
    app.load("client.activity.construction_order.ConstructionOrderShopTab")
    app.load("client.activity.construction_order.ConstructionOrderShopTabList")
    app.load("client.activity.construction_order.ConstructionOrderShopListNormal")
    app.load("client.activity.construction_order.ConstructionOrderShopListSpecial")
    
	app.load("client.utils.CurrencyIcon")
    -- Initialize construction_order_shop page state machine.
    local function init_construction_order_shop_terminal()
        -- 打开角色创建窗口
        local construction_order_shop_open_terminal = {
            _name = "construction_order_shop_open",
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
        local construction_order_shop_close_terminal = {
            _name = "construction_order_shop_close",
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
        local construction_order_shop_show_terminal = {
            _name = "construction_order_shop_show",
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
        local construction_order_shop_hide_terminal = {
            _name = "construction_order_shop_hide",
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
        
        -- 切换商店类型
        local construction_order_shop_change_type_terminal = {
            _name = "construction_order_shop_change_type",
            _init = function(terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil then
                    local shopType = params._datas.shop_type
                    -- print(shopType, '=====shopType')
                    state_machine.excute("construction_order_shop_view_change_type", 0, {shop_type = shopType})
                    instance:updateUI(shopType)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(construction_order_shop_open_terminal)
        state_machine.add(construction_order_shop_close_terminal)
        state_machine.add(construction_order_shop_show_terminal)
        state_machine.add(construction_order_shop_hide_terminal)
        state_machine.add(construction_order_shop_change_type_terminal)
        state_machine.init()
    end
    -- call func init christmas romance shop state machine.
    init_construction_order_shop_terminal()
end

function ConstructionOrderShop:updateUI(shopType)
    if shopType ~= nil then
        self.curType = shopType
    end
    
    for i, v in ipairs(self.ButtonShopList) do
        local Text_dark = v.Text_type_1
        local Text_light = v.Text_type_2
        local Button_tab = ccui.Helper:seekWidgetByName(v, "Button_paging_tab_1")
        if v.curType == self.curType then
            Text_dark:setVisible(false)
            Text_light:setVisible(true)
            Button_tab:setTouchEnabled(false)
            Button_tab:setHighlighted(true)
        else
            Text_dark:setVisible(true)
            Text_light:setVisible(false)
            Button_tab:setTouchEnabled(true)
            Button_tab:setHighlighted(false)
        end
    end

    self:showCurrencyUI()
end

function ConstructionOrderShop:showCurrencyUI()
    local propType = 0
    local propID = 0
    if self.curType == 1 then
        local propInfo = zstring.split(dms.string(dms["play_config"], 279, play_config.param), ",")
        propType = tonumber(propInfo[1])
	    propID = tonumber(propInfo[2])
    elseif self.curType == 2 then
        local propInfo = zstring.split(dms.string(dms["play_config"], 280, play_config.param), ",")
        propType = tonumber(propInfo[1])
	    propID = tonumber(propInfo[2])
    end
    self.Panel_currency_1:removeAllChildren()
    local cell = state_machine.excute("currency_icon_create", 0, {propType = propType, propID = propID})
    self.Panel_currency_1:addChild(cell)
    
end


function ConstructionOrderShop:onUpdateDraw()
    self.Panel_tab:removeAllChildren()
    local panel = state_machine.excute("consturion_order_shop_view_window_create", 0, {self.curType})
    self.Panel_tab:addChild(panel)
end

function ConstructionOrderShop:updateShopTab()
    local user_order_info = _ED.active_activity[186].user_order_info
    -- debug.print_r(user_order_info, "===user_order_info")
    -- local user_order_info = nil
    if user_order_info == nil then
        return false
    end
    self.ButtonShopList = {}
    self.Panel_commcon_paging_1:removeAllChildren()

    local shopTabPanel = state_machine.excute("construction_order_shop_tab_create", 0, nil)
    self.Panel_commcon_paging_1:addChild(shopTabPanel)
    local ListView_tab = shopTabPanel.ListView_paging_tab
    ListView_tab:removeAllItems()
    local allShopTypes = table.nums(user_order_info.shopInfo)
    for i = 1, allShopTypes do
        local shopTab = state_machine.excute("construction_order_shop_tab_list_create", 0, {curType = i})
        
        ListView_tab:addChild(shopTab)
        table.insert(self.ButtonShopList, shopTab)

        local Image_1 = ccui.Helper:seekWidgetByName(shopTab, "Image_1")
		Image_1:setVisible(false)

        local Button_tab = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(shopTab, "Button_paging_tab_1"), nil,
		{
			terminal_name = "construction_order_shop_change_type",
			terminal_state = 0,
			isPressedActionEnabled = true,
			shop_type = i
		}, nil, 0)
    end
    
end

-- 对象初始化
function ConstructionOrderShop:init(params)
  
    if nil ~= self.onInit then
        self:onInit(params)
    end
    return self
end

function ConstructionOrderShop:onInit(params)
    -- 默认商店类型
    self.curType = params.curType
end

function ConstructionOrderShop:onUpdate(dt)
    
end


function ConstructionOrderShop:onEnterTransitionFinish()
    -- 加载ChristmasRomanceShopWindow界面资源.
    local csbNode = csb.createNode("shop/new_shop.csb")
    local root = csbNode:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 商店界面容器
    self.Panel_tab = ccui.Helper:seekWidgetByName(root, "Panel_tab")

    -- 商店类型容器
    self.Panel_commcon_paging_1 = ccui.Helper:seekWidgetByName(root, "Panel_commcon_paging_1")

    -- 商店消耗道具
    self.Panel_currency_1 = ccui.Helper:seekWidgetByName(root, "Panel_currency_1")

     -- 关闭界面
     self.Button_close =
        fwin:addTouchEventListener(
        ccui.Helper:seekWidgetByName(root, "Button_close"),
        nil,
        {
            terminal_name = "construction_order_shop_window_close",
            terminal_state = 0,
            isPressedActionEnabled = true,
        },
        nil,
        0
    )

    self:updateShopTab()
    self:onUpdateDraw()
    self:updateUI()
end

function ConstructionOrderShop:onExit()
    -- 释放ChristmasRomanceShopWindow界面资源.
    state_machine.remove("construction_order_shop_open")
    state_machine.remove("construction_order_shop_close")
    state_machine.remove("construction_order_shop_show")
    state_machine.remove("construction_order_shop_hide")
    state_machine.remove("construction_order_shop_change_type")
    
end

function ConstructionOrderShop:close()
    -- window event : close.
end

function ConstructionOrderShop:destroy(window)
    -- window event : destroy.
end

-- ~END
-- ----------------------------------------------------------------------------
