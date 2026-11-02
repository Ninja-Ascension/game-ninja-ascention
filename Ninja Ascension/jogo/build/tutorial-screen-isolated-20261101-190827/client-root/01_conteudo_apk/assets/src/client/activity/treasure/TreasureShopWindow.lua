-- ----------------------------------------------------------------------------------------------------
-- 说明：秘宝商店
-------------------------------------------------------------------------------------------------------

TreasureShopWindow = class("TreasureShopWindowClass", Window)

local treasure_shop_window_open_terminal = {
    _name = "treasure_shop_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local TreasureShopWindowWindow = fwin:find("TreasureShopWindowClass")
        if TreasureShopWindowWindow == nil then
            fwin:open(TreasureShopWindow:new():init(params), fwin._view)
        end
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(treasure_shop_window_open_terminal)
state_machine.init()

function TreasureShopWindow:ctor()
    self.super:ctor()
    self.roots = {}
    self.index = 2
    self._scroll_view = nil
    self._scroll_view_pox = 0
    self._scroll_view_width = 0
    self.roll_width = 0

    self.allScore = 0

    app.load("client.activity.treasure.TreasureShopWindowCell")

    local function init_treasure_shop_terminal()
        --
        local treasure_shop_close_terminal = {
            _name = "treasure_shop_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                fwin:close(fwin:find("TreasureShopWindowClass"))
                -- fwin:close(fwin:find("TreasureShopWindowBuyTopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local treasure_shop_scrollView_roll_terminal = {
            _name = "treasure_shop_scrollView_roll",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local currType = params._datas._type
                local scrollView = instance._scroll_view:getInnerContainer()
                local scrollViewX = 0
                if currType == 1 then
                    scrollViewX = scrollView:getPositionX() + instance.roll_width
                    scrollViewX = math.min(0 , scrollViewX)
                else
                    scrollViewX = scrollView:getPositionX() - instance.roll_width
                    scrollViewX = math.max(scrollViewX , instance._scroll_view:getContentSize().width - scrollView:getContentSize().width)
                end
                scrollView:setPositionX(scrollViewX)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --刷新
        local treasure_shop_refresh_terminal = {
            _name = "treasure_shop_refresh",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local scrollView = params
                for i,v in pairs(scrollView:getChildren()) do
                    if v then
                        v:initData()
                        v:onUpdateDraw()
                    end
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(treasure_shop_close_terminal)
        state_machine.add(treasure_shop_scrollView_roll_terminal)
        state_machine.add(treasure_shop_refresh_terminal)
        state_machine.init()
    end

    init_treasure_shop_terminal()
end

function TreasureShopWindow:onUpdateDraw()
    local root = self.roots[1]
    local params = json.decode(_ED.active_activity[148].activity_params)
    self.Text_integral_n = ccui.Helper:seekWidgetByName(root, "Text_integral_n")
    local ScrollView_explore_shop = ccui.Helper:seekWidgetByName(root, "ScrollView_explore_shop")
    ScrollView_explore_shop:removeAllChildren(true)
    
    local cell_size = nil
    local all = table.nums(params.actConfig.shop)
    local width_n = math.ceil(all / 2)
    local index = 1
    for i, shop_info in ipairs(params.actConfig.shop) do
        local cell = TreasureShopWindowCell:createCell()
        cell:init({shop_info, i})
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
        ScrollView_explore_shop:addChild(cell)
        cell:setPosition(cc.p( ((index - 1) % width_n) * cell_size.width , (2 - math.ceil( index / width_n)) * cell_size.height))
        index = index + 1
    end

    if nil ~= cell_size then
        self.roll_width = cell_size.width * 3
        local InnerWidth = math.max(cell_size.width * width_n , ScrollView_explore_shop:getContentSize().width)
        local InnerHeight = ScrollView_explore_shop:getInnerContainer():getContentSize().height
        ScrollView_explore_shop:getInnerContainer():setContentSize(cc.size(InnerWidth , InnerHeight))
    end

    self._scroll_view = ScrollView_explore_shop
    self._scroll_view_pox = 99999 --ScrollView_explore_shop:getInnerContainer():getPositionX()
    self._scroll_view_width = ScrollView_explore_shop:getInnerContainer():getPositionX()
end

function TreasureShopWindow:onUpdate(dt)
    local params = json.decode(_ED.active_activity[148].activity_params)
    
    if self.Text_integral_n and self.allScore ~= tonumber(params.score) then
        self.allScore = tonumber(params.score)
        self.Text_integral_n:setString(self.allScore)
    end

    if self._scroll_view ~= nil then
        local size = self._scroll_view:getContentSize()
        local posX = self._scroll_view:getInnerContainer():getPositionX()
        if self._scroll_view_pox == posX then
            return
        end
        self._scroll_view_pox = posX
        local items = self._scroll_view:getChildren()

        if posX >= -40 then
            self.Button_arrow_left:setVisible(false)
        else
            self.Button_arrow_left:setVisible(true)
        end
        if posX <= -self._scroll_view:getInnerContainer():getContentSize().width + self._scroll_view:getContentSize().width + 40 then
            self.Button_arrow_right:setVisible(false)
        else
            self.Button_arrow_right:setVisible(true)
        end

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

function TreasureShopWindow:onInit()
    local csb_explore_shop = csb.createNode("activity/wonderful/rare_treasure_shop.csb")
    local root = csb_explore_shop:getChildByName("root")
    self.root = root
    table.insert(self.roots, root)
    self:addChild(csb_explore_shop)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_explore_shop_report_back"), nil, 
    {
        terminal_name = "treasure_shop_close", 
        terminal_state = 0, 
        isPressedActionEnabled = true
    },
    nil, 0)

    self.Button_arrow_right = ccui.Helper:seekWidgetByName(root, "Button_arrow_right")
    self.Button_arrow_left = ccui.Helper:seekWidgetByName(root, "Button_arrow_left")
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_right"), nil, 
    {
        terminal_name = "treasure_shop_scrollView_roll", 
        terminal_state = 0, 
        _type  = 2,
        isPressedActionEnabled = true
    },
    nil, 0)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_left"), nil, 
    {
        terminal_name = "treasure_shop_scrollView_roll", 
        terminal_state = 0, 
        _type  = 1,
        isPressedActionEnabled = true
    },
    nil, 0)
    
    self:onUpdateDraw()

    -- 顶部用户信息
    -- app.load("client.l_digital.campaign.fileIsland.TreasureShopWindowBuyTop")                   
    -- local userinfo = TreasureShopWindowBuyTop:new()
    -- userinfo._rootWindows = self
    -- local info = fwin:open(userinfo,fwin._windows)

    self:registerOnNodeEvent(self)
    self:registerOnNoteUpdate(self, 1)
end

function TreasureShopWindow:init(params)
    self.index = 1
    self:onInit()
    return self
end

function TreasureShopWindow:onExit()
    state_machine.remove("treasure_shop_close")
    state_machine.remove("treasure_shop_refresh")
end

