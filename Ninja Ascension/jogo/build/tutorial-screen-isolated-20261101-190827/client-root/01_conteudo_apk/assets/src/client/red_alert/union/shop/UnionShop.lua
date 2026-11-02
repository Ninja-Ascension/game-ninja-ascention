--------------------------------------------------------------------------------------------------------------
--  说明：军团商店主界面
--------------------------------------------------------------------------------------------------------------
UnionShop = class("UnionShopClass", Window)

--打开界面
local union_shop_open_terminal = {
	_name = "union_shop_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if funOpenDrawTip(114) == true then
            return
        end 
		local UnionShopWindow = fwin:find("UnionShopClass")
		if nil == UnionShopWindow then
			fwin:open(UnionShop:new():init(params),fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local union_shop_close_terminal = {
	_name = "union_shop_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("UnionShopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(union_shop_open_terminal)
state_machine.add(union_shop_close_terminal)
state_machine.init()

function UnionShop:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	self._selectIndex = 0
    -- 1:贡献商店, 2:战功商店
    self._index = 0 
	app.load("client.red_alert.cells.shop.mystery_shop_cell")
    app.load("client.red_alert.shop.MysteryShopBuy")
	
	 -- Initialize union shop machine.
    local function init_union_shop_terminal()
		
		-- 隐藏界面
        local union_shop_hide_event_terminal = {
            _name = "union_shop_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_shop_show_event_terminal = {
            _name = "union_shop_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_shop_refresh_info_terminal = {
            _name = "union_shop_refresh_info",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            instance:updateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换按钮
        local union_shop_choose_tab_terminal = {
            _name = "union_shop_choose_tab",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
	            if params._datas.chooseIndex == 2 then
	            	if funOpenDrawTip(48) == true then 
	            		return
	            	end
	            end
                instance:chooseTab(params._datas.chooseIndex)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(union_shop_hide_event_terminal)
		state_machine.add(union_shop_show_event_terminal)
		state_machine.add(union_shop_refresh_info_terminal)
		state_machine.add(union_shop_choose_tab_terminal)
        state_machine.init()
    end
    
    -- call func init union shop  machine.
    init_union_shop_terminal()

end
--隐藏
function UnionShop:onHide()
	self:setVisible(false)
end
--显示
function UnionShop:onShow()
	self:setVisible(true)
end

-- 切换选中按钮
function UnionShop:chooseTab( chooseIndex )
	local root = self.roots[1]
    local Button_2 = ccui.Helper:seekWidgetByName(root, "Button_2")
    local Button_2_0 = ccui.Helper:seekWidgetByName(root, "Button_2_0")
    if chooseIndex == 1 then
        Button_2:setHighlighted(true)
        Button_2_0:setHighlighted(false)
    else
        Button_2:setHighlighted(false)
        Button_2_0:setHighlighted(true)
    end
    if self._selectIndex == chooseIndex then
        return
    end
    self._selectIndex = chooseIndex
    self:updateDraw()
	self:onUpdateDrawList()
end

function UnionShop:updateDraw()
	local root = self.roots[1]
	--商店等级
	local Text_shop_lv_v = ccui.Helper:seekWidgetByName(root, "Text_shop_lv_v")
	Text_shop_lv_v:setString(_ED.union.union_info.union_grade)
	-- 贡献icon
	local Image_mystery_shop_12 = ccui.Helper:seekWidgetByName(root, "Image_mystery_shop_12")
	Image_mystery_shop_12:setVisible(false)
	-- 战功icon
	local Image_mystery_map_icon = ccui.Helper:seekWidgetByName(root, "Image_mystery_map_icon")
	Image_mystery_map_icon:setVisible(false)
	--军团贡献
	local Text_mystery_shop_13 = ccui.Helper:seekWidgetByName(root, "Text_mystery_shop_13")
	if self._selectIndex == 1 then 
		Image_mystery_shop_12:setVisible(true)
		Text_mystery_shop_13:setString(_ED.user_info.union_contribute)
	else
		Image_mystery_map_icon:setVisible(true)
		Text_mystery_shop_13:setString(_ED.user_info.user_union_fight_exploit)
	end

end
--刷新滑动列表
function UnionShop:onUpdateDrawList()
    local root = self.roots[1]
    local ListView_mystery_shop_7 = ccui.Helper:seekWidgetByName(root,"ListView_mystery_shop_7")	--第一排列表
    local ListView_mystery_shop_6 = ccui.Helper:seekWidgetByName(root,"ListView_mystery_shop_6")	--第二排列表
    local ScrollView_mystery_shop_5 = ccui.Helper:seekWidgetByName(root,"ScrollView_mystery_shop_5")--滑动层
    ListView_mystery_shop_7:removeAllItems()
    ListView_mystery_shop_6:removeAllItems()
    local items = nil
    local shop_type = 0 
    if self._selectIndex == 1 then 
    	items = _ED.all_shop_info["1"]
    	shop_type = 3
    else
    	items = _ED.all_shop_info["3"]
    	shop_type = 4
    end
    local width = 0
    local index = 0
    if items ~= nil then
        for i, v in pairs(items) do
        	local openInfos = zstring.split(v.open_info, ",")
            local cell = state_machine.excute("mystery_shop_create_cell", 0, {v, i-1, shop_type})
            if math.floor(i % 2) == 0 then
                ListView_mystery_shop_6:addChild(cell)
            else
            	index = index + 1 
                ListView_mystery_shop_7:addChild(cell)
            end
            width = cell:getContentSize().width
        end
    end
    if index < 4 then
    	index = 4
    end

    ScrollView_mystery_shop_5:getInnerContainer():setContentSize(cc.size(width * index, ScrollView_mystery_shop_5:getContentSize().height))
    ListView_mystery_shop_7:requestRefreshView()
    ListView_mystery_shop_6:requestRefreshView()
end

function UnionShop:onInit()
	local csbItem = csb.createNode(config_csb.legion.legion_shop)
    self:addChild(csbItem)
    local root = csbItem:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline(config_csb.legion.legion_shop)
    table.insert(self.actions, action)
    action:play("window_open", false)
    csbItem:runAction(action)
	
	--关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_mystery_shop_close"),nil, 
	{
		terminal_name = "union_shop_close", 
		cell = self,	 	 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	-- 贡献
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2"), nil, 
    {
        terminal_name = "union_shop_choose_tab", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        chooseIndex = 1,
    }, nil, 0)

    -- 战功
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_2_0"), nil, 
    {
        terminal_name = "union_shop_choose_tab", 
        terminal_state = 0, 
        touch_scale = true,
        touch_scale_xy = 0.95, 
        chooseIndex = 2,
    }, nil, 0)
	
	self:chooseTab(self._index) 
end

function UnionShop:onEnterTransitionFinish()
end

function UnionShop:init(params)
    self._index = params[1]
	self:onInit()
	return self
end

function UnionShop:onExit()
	state_machine.remove("union_shop_hide_event")
	state_machine.remove("union_shop_show_event")
	state_machine.remove("union_shop_refresh_info")
	state_machine.remove("union_shop_choose_tab")
end