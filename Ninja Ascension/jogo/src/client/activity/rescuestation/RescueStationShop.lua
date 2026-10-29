--[[ ----------------------------------------------------------------------------
-- 商店兑换界面
--]] ----------------------------------------------------------------------------
RescueStationShop = class("RescueStationShopClass", Window)

-- 打开窗口
local rescue_station_shop_window_open_terminal = {
	_name = "rescue_station_shop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("RescueStationShopClass") then
			fwin:open(RescueStationShop:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local rescue_station_shop_window_close_terminal = {
	_name = "rescue_station_shop_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("RescueStationShopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(rescue_station_shop_window_open_terminal)
state_machine.add(rescue_station_shop_window_close_terminal)
state_machine.init()

-- 构造器
function RescueStationShop:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
	self._scroll_view_pox = 0
    app.load("client.activity.rescuestation.RescueShopWindowCell")
	local function init_rescue_station_shop_terminal()
		-- 打开角色创建窗口
		local rescue_station_shop_open_terminal = {
			_name = "rescue_station_shop_open",
			_init = function (terminal)
				
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
		local rescue_station_shop_close_terminal = {
			_name = "rescue_station_shop_close",
			_init = function (terminal)
				
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
		local rescue_station_shop_show_terminal = {
			_name = "rescue_station_shop_show",
			_init = function (terminal)
				
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
		local rescue_station_shop_hide_terminal = {
			_name = "rescue_station_shop_hide",
			_init = function (terminal)
				
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

		 local rescue_station_shop_scrollView_roll_terminal = {
            _name = "rescue_station_shop_scrollView_roll",
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

        -- 刷新数据
		local rescue_station_shop_update_terminal = {
			_name = "rescue_station_shop_update",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				instance:onUpdateDraw()
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(rescue_station_shop_open_terminal)
		state_machine.add(rescue_station_shop_close_terminal)
		state_machine.add(rescue_station_shop_show_terminal)
		state_machine.add(rescue_station_shop_hide_terminal)
		state_machine.add(rescue_station_shop_scrollView_roll_terminal)
		state_machine.add(rescue_station_shop_update_terminal)
		state_machine.init()
	end
	-- call func init rescue station shop state machine.
	init_rescue_station_shop_terminal()
end

-- 对象初始化
function RescueStationShop:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function RescueStationShop:onUpdate(dt)
  --  local params = json.decode(_ED.active_activity[148].activity_params)
    
    -- if self.Text_integral_n and self.allScore ~= tonumber(params.score) then
    --     self.allScore = tonumber(params.score)
    --     self.Text_integral_n:setString(self.allScore)
    -- end

    if self.ScrollView_commodity ~= nil then
        local size = self.ScrollView_commodity:getContentSize()
        local posX = self.ScrollView_commodity:getInnerContainer():getPositionX()
        if self._scroll_view_pox == posX then
            return
        end
        self._scroll_view_pox = posX
        local items = self.ScrollView_commodity:getChildren()

        if posX >= -40 then
            self.Button_arrow_left:setVisible(false)
        else
            self.Button_arrow_left:setVisible(true)
        end
        if posX <= -self.ScrollView_commodity:getInnerContainer():getContentSize().width + self.ScrollView_commodity:getContentSize().width + 40 then
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

function RescueStationShop:onUpdateDraw()
	local root = self.roots[1]

	-- 滚动容器
	self.ScrollView_commodity = ccui.Helper:seekWidgetByName(root, "ScrollView_commodity")
    self.ScrollView_commodity:removeAllChildren(true)
    
    local info =  json.decode(_ED.active_activity[159].activity_params)
    local cell_size = nil
    local all = table.nums(dms["role_rescue_shop"])
    local width_n = math.ceil(all / 3)
    local index = 1
    for i, shop_info in pairs(info.shop_status) do
        local cell = RescueShopWindowCell:createCell()
        cell:init({shop_info, i})
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end
        self.ScrollView_commodity:addChild(cell)
        cell:setPosition(cc.p( ((index - 1) % width_n) * cell_size.width , (2 - math.ceil( index / width_n)) * cell_size.height))
        index = index + 1
    end

    if nil ~= cell_size then
        self.roll_width = cell_size.width * 3
        local InnerWidth = math.max(cell_size.width * width_n , self.ScrollView_commodity:getContentSize().width)
        local InnerHeight = self.ScrollView_commodity:getInnerContainer():getContentSize().height
        self.ScrollView_commodity:getInnerContainer():setContentSize(cc.size(InnerWidth , InnerHeight))
    end

    self._scroll_view = self.ScrollView_commodity
    self._scroll_view_pox = 99999 --ScrollView_explore_shop:getInnerContainer():getPositionX()
    self._scroll_view_width = self.ScrollView_commodity:getInnerContainer():getPositionX()

    self.Text_rescue_icon_n = ccui.Helper:seekWidgetByName(root, "Text_rescue_icon_n") --救助币数量
    if  fundPropWidthId(1468)  then
       self.Text_rescue_icon_n:setString(fundPropWidthId(1468).prop_number) 
    else
       self.Text_rescue_icon_n:setString(0)
    end
end


function RescueStationShop:onEnterTransitionFinish()
	-- 加载RescueStationShopWindow界面资源.
	-- res.activity.rescue_station_shop = res/activity/rescue_station_shop.csb
	local csbNode = csb.createNode("activity/rescue_station/rescue_station_shop.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)
    
    self.Button_arrow_right = ccui.Helper:seekWidgetByName(root, "Button_arrow_right")
    self.Button_arrow_left = ccui.Helper:seekWidgetByName(root, "Button_arrow_left")
  

	-- 左箭头
	self.Button_arrow_left = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_left"), nil,
	{
		terminal_name = "rescue_station_shop_scrollView_roll",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_type  = 1,
	}, nil, 0)	

	-- 右箭头
	self.Button_arrow_right = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_arrow_right"), nil,
	{
		terminal_name = "rescue_station_shop_scrollView_roll",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_type  = 2,
	}, nil, 0)	

	-- 关闭
	self.Button_cross_service_report_back = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_cross_service_report_back"), nil,
	{
		terminal_name = "rescue_station_shop_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function RescueStationShop:onExit()
	-- 释放RescueStationShopWindow界面资源.
	state_machine.remove("rescue_station_shop_open")
	state_machine.remove("rescue_station_shop_close")
	state_machine.remove("rescue_station_shop_show")
	state_machine.remove("rescue_station_shop_hide")
end

function RescueStationShop:close()
	-- window event : close.
	
end

function RescueStationShop:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
