-- ----------------------------------------------------------------------------------------------------
-- 说明：商店
-------------------------------------------------------------------------------------------------------
AdventureShop = class("AdventureShopClass", Window)
    
app.load("client.adventure.cells.shop.adventure_shop_vip_buy_list_cell")

function AdventureShop:ctor()
    self.super:ctor()
    self.roots = {}

    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    self.current_show_type = 0  -- 0商店 1 VIP
    self.user_gold = 0
    -- Initialize adventure shop state machine.
    local function init_adventure_shop_terminal()
    	-- 购买血钻
        local adventure_shop_recharge_terminal = {
            _name = "adventure_shop_recharge",
            _init = function (terminal)
                app.load("client.adventure.shop.AdventureRecharge")
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:open(AdventureRecharge:new():init(), fwin._view)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --购买VIP
        local adventure_shop_recharge_vip_terminal = {
            _name = "adventure_shop_recharge_vip",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                 local function responseShopViewCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then 
                            response.node:updateListView(1)
                        end
                    end
                end
                protocol_command.shop_view.param_list = "1"
                NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --购买道具
        local adventure_shop_recharge_daoju_terminal = {
            _name = "adventure_shop_recharge_daoju",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                 instance:updateListView(0)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        --购买VIP后刷新列表
        local adventure_shop_buy_vip_ok_update_list_terminal = {
            _name = "adventure_shop_buy_vip_ok_update_list",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance:updateRefreshListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local adventure_shop_recharge_back_terminal = {
            _name = "adventure_shop_recharge_back",
            _init = function (terminal)
    
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance.current_show_type == 0  then 
                    
                    state_machine.excute("menu_manager", 0, 
                        {
                            _datas = {
                                terminal_name = "menu_manager",     
                                next_terminal_name = "menu_show_home_page",      
                                current_button_name = "Button_daditu",        
                                but_image = "Image_daditu",   
                                terminal_state = 0, 
                                isPressedActionEnabled = true
                            }
                        }
                    )
                    --商店界面中返回
                else
                    local function responseShopViewCallBack(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots ~= nil then 
                            response.node:updateListView(0)
                        end
                    end
                end
                protocol_command.shop_view.param_list = "0"
                NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)
                
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.add(adventure_shop_recharge_vip_terminal)
        state_machine.add(adventure_shop_recharge_terminal)
        state_machine.add(adventure_shop_recharge_back_terminal)
        state_machine.add(adventure_shop_buy_vip_ok_update_list_terminal)
        state_machine.add(adventure_shop_recharge_daoju_terminal)
        
        state_machine.init()
    end
    
    -- call func init adventure shop state machine.
    init_adventure_shop_terminal()
end

function AdventureShop:init()
	return self
end

function AdventureShop:onUpdate(dt)
    
    if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
        
        if self.current_show_type == 1 and  _ED.user_info.user_gold ~= self.user_gold then 
            self.user_gold  = _ED.user_info.user_gold
            self:updateListView(1)
            return
        end
        if self.current_show_type == 1 or self.current_show_type == 0 then 
            return
        end
        --不需要刷新了
        local size = self.currentListView:getContentSize()
        local posY = self.currentInnerContainer:getPositionY()
        if self.currentInnerContainerPosY == posY then
            return
        end
        self.currentInnerContainerPosY = posY
        local items = self.currentListView:getItems()
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

function AdventureShop:updateRefreshListView()
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_daoju")
    listView:requestRefreshView()
    listView:jumpToTop()
end

function AdventureShop:updateListView(show_type)
    self.current_show_type = show_type
    local root = self.roots[1]
    if root == nil then 
        return
    end
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_daoju")
    
    local vip_Button = ccui.Helper:seekWidgetByName(root, "Button_vip")
    local daoju_Button = ccui.Helper:seekWidgetByName(root, "Button_vip_0")

    listView:removeAllItems()
    if show_type == 0 then  --普通道具
        if _ED.return_prop ~= nil then
            for i, v in pairs(_ED.return_prop) do
                local cell = AdventureShopListCell:createCell()
                cell:init(v, i)
                cell:setName("prop_"..i)
                listView:addChild(cell)
            end
        end
        daoju_Button:setColor(cc.c3b(255, 255, 255))
        daoju_Button:setTouchEnabled(false)
        vip_Button:setColor(cc.c3b(150, 150, 150))
        vip_Button:setTouchEnabled(true)
    else
        --vip
        daoju_Button:setColor(cc.c3b(150, 150, 150))
        vip_Button:setTouchEnabled(false)
        vip_Button:setColor(cc.c3b(255, 255, 255))
        daoju_Button:setTouchEnabled(true)
        if _ED.return_vip_equipment ~= nil then
            for i, v in pairs(_ED.return_vip_equipment) do
                
                if tonumber(v.prop_type) == 1 then
                    local prop_instance = _ED.return_vip_prop[i]
                    local times = zstring.tonumber(prop_instance.VIP_buy_times) - zstring.tonumber(prop_instance.buy_times)
                    if times <= 0 then 
                    else
                        local cell = AdventureShopVipBuyListCell:createCell()
                        cell:init(v,2,1)
                        listView:addChild(cell) 
                    end
                end
            end
        end
        if _ED.return_vip_prop ~= nil then
            for i, v in pairs(_ED.return_vip_prop) do
                
                if tonumber(v.prop_type) == 0  then
                    local prop_instance = _ED.return_vip_prop[i]
                    local times = zstring.tonumber(prop_instance.VIP_buy_times) - zstring.tonumber(prop_instance.buy_times)
        
                    if times <= 0 then 
                    else
                        local cell = AdventureShopVipBuyListCell:createCell()
                        cell:init(v,1,1)
                        listView:addChild(cell) 
                    end
                end    
            end
        end
    end

    
    listView:requestRefreshView()

    self.currentListView = listView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AdventureShop:onEnterTransitionFinish()
	local csbAdventureShop = csb.createNode("shop/diamondshop/shop_diamond.csb")
    local root = csbAdventureShop:getChildByName("root")
    self.current_show_type = 0
    table.insert(self.roots, root)
    self:addChild(csbAdventureShop)
    self.user_gold = _ED.user_info.user_gold
    -- 返回
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"),       nil, 
    {
		terminal_name = "adventure_shop_recharge_back",     
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 2)
    
    local vipButton = ccui.Helper:seekWidgetByName(root, "Button_vip")
    vipButton:setTouchEnabled(false)
    fwin:addTouchEventListener(vipButton,       nil, 
    {
        terminal_name = "adventure_shop_recharge_vip",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)
    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_vip_package",
    _widget = ccui.Helper:seekWidgetByName(root, "Button_vip"),
    _invoke = nil,
    _interval = 1,})

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_vip_0"),       nil, 
    {
        terminal_name = "adventure_shop_recharge_daoju",        
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 购买血钻
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_buy"),       nil, 
    {
		terminal_name = "adventure_shop_recharge",        
		terminal_state = 0, 
		isPressedActionEnabled = true
    }, 
    nil, 0)

    -- 刷新商店
    local function responseShopViewCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.roots ~= nil then 
                response.node:updateListView(0)
            end
            
        end
    end
    protocol_command.shop_view.param_list = "0"
    NetworkManager:register(protocol_command.shop_view.code, nil, nil, nil, self, responseShopViewCallBack, false, nil)

    --self:updateListView()
    state_machine.excute("adventure_push_info_open",0,6)
end

function AdventureShop:onExit()

    state_machine.excute("adventure_push_info_close",0,0)
    state_machine.remove("adventure_shop_recharge")
end