--------------------------------------------------------------------------------------------------------------
--  说明：金钱不足跳转面板
--------------------------------------------------------------------------------------------------------------
SilverToGet = class("SilverToGetClass", Window)

app.load("client.cells.prop.prop_money_icon")
app.load("client.utils.silver.silver_toget_listcell")
--打开界面
local silver_to_get_open_terminal = {
	_name = "silver_to_get_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local _window_type = params
		local _SilverToGet = SilverToGet:new()
		_SilverToGet:init(_window_type)
		fwin:open( _SilverToGet,fwin._viewdialog)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local silver_to_get_close_terminal = {
	_name = "silver_to_get_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SilverToGetClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(silver_to_get_open_terminal)
state_machine.add(silver_to_get_close_terminal)
state_machine.init()

function SilverToGet:ctor()
	self.super:ctor()
	self.roots = {}
	self.enum_type = {
		_SILVER = 1,                -- 金钱
		_GOLD = 2,				    -- 宝石
		_REPUTATIOM = 3,			-- 声望
		_HERO = 4,	                -- 将魂
		_SOUL = 5,					-- 英魂
		_GLORIES = 6,			    -- 威名
		_EXPLOIT = 7,		        -- 战功

	}
	--控件
	self.listview = nil--列表
	self.image_panle = nil--图片
	self.text_name = nil --名字
	self.text_number = nil -- 现有数量
	self.listview_PositionY = nil -- 列表滑动初始定位
	
	--数据
	self._window_type = nil--类型--银币、英魂、什么的。目前只有银币
	self.to_get_way_table = {} --跳转方式的表
	 -- Initialize union duplicate seat machine.
    local function init_silver_to_get_terminal()

		state_machine.init()
    end
    
    -- call func init union duplicate seat machine.
    init_silver_to_get_terminal()

end

--初始化全局用的控件，变量
function SilverToGet:initDeclare()
	local root = self.roots[1]
	local ListView_1 = ccui.Helper:seekWidgetByName(root,"ListView_1")
	local image_panle = ccui.Helper:seekWidgetByName(root,"Panel_3")
	local text_name = ccui.Helper:seekWidgetByName(root,"Text_1")
	local text_number = ccui.Helper:seekWidgetByName(root,"Text_3")
	self.listview = ListView_1 
	self.image_panle = image_panle
	self.text_name = text_name 
	self.text_number = text_number
	
	--暂无获取路径的提示文字，在这里总是隐藏的
	local text_get_way_info = ccui.Helper:seekWidgetByName(root,"Text_121") 
	text_get_way_info:setVisible(false)
end

--绘制
function SilverToGet:initDraw()
	if self._window_type == self.enum_type._SILVER then-- 金钱,铜币

		self:initSilverDraw()
		self.to_get_way_table = user_resource_info._silver_to_get_index

	elseif self._window_type == self.enum_type._REPUTATIOM then --声望，

		self:initReputationDraw()
		self.to_get_way_table = user_resource_info._reputation_to_get_index

	elseif self._window_type == self.enum_type._GLORIES then -- 威名

		self:initGloriesDraw()
		self.to_get_way_table = user_resource_info._glories_to_get_index

	elseif self._window_type == self.enum_type._SOUL then -- 英魂

		self:initSoulDraw()
		self.to_get_way_table = user_resource_info._soul_to_get_index

	elseif self._window_type == self.enum_type._EXPLOIT then -- 战功	

		self:initExploitDraw()
		self.to_get_way_table = user_resource_info._exploit_to_get_index
	end
end

--金钱的绘制
function SilverToGet:initSilverDraw()
	local cell = propMoneyIcon:createCell()
	cell:init("1",nil,nil)
	--设置图片
	self.image_panle:addChild(cell)
	--设置名字
	self.text_name:setString(_All_tip_string_info._fundName)
	--设置现有金钱数量
	self.text_number:setString(_ED.user_info.user_silver)
end

--声望的绘制
function SilverToGet:initReputationDraw()
	local cell = propMoneyIcon:createCell()
	cell:init("3",nil,nil)
	--设置图片
	self.image_panle:addChild(cell)
	--设置名字
	self.text_name:setString(_All_tip_string_info._reputation)
	--设置现有声望数量
	self.text_number:setString(_ED.user_info.user_honour)
end

--英魂
function SilverToGet:initSoulDraw()
	local cell = propMoneyIcon:createCell()
	cell:init("5",nil,nil)
	--设置图片
	self.image_panle:addChild(cell)
	--设置名字
	self.text_name:setString(_All_tip_string_info._soulName)
	--设置现有英魂数量
	self.text_number:setString(_ED.user_info.jade)
end

--威名
function SilverToGet:initGloriesDraw()
	local cell = propMoneyIcon:createCell()
	cell:init("6",nil,nil)
	--设置图片
	self.image_panle:addChild(cell)
	--设置名字
	self.text_name:setString(_All_tip_string_info._glories)
	--设置现有威名数量
	self.text_number:setString(_ED.user_info.all_glories)
end

--战功
function SilverToGet:initExploitDraw()
	local cell = propMoneyIcon:createCell()
	cell:init("7",nil,nil)
	--设置图片
	self.image_panle:addChild(cell)
	--设置名字
	self.text_name:setString(_All_tip_string_info._exploit)
	--设置现有战功数量
	self.text_number:setString(_ED.user_info.exploit)
end

--初始化列表--...虽然只有几个..还是做个缓存
function SilverToGet:initListView()
	local index = 1 
	local notopentables = {}
	for i , v in pairs(self.to_get_way_table) do
		local funopenId = dms.string(dms["function_param"],tonumber(v),function_param.open_function)
		local openlevel = dms.int(dms["fun_open_condition"],tonumber(funopenId),fun_open_condition.level)
		--排序，开启的排前面
		local user_level= tonumber(_ED.user_info.user_grade)
		if user_level >= openlevel then	
			local cell = SilverToGetListCell:createCell()
			cell:init(v,index)
			self.listview:addChild(cell)
			index = index + 1
		else
			table.insert(notopentables,v)
		end	
	end
	
	--插入未开启的
	for i ,v  in pairs(notopentables) do
		local cell = SilverToGetListCell:createCell()
		cell:init(v,index)
		self.listview:addChild(cell)
		index = index + 1		
	end
	self.listview_PositionY = self.listview:getInnerContainer():getPositionY()
end

--初始化界面csb，点击事件
function SilverToGet:onInit()
	local csbSilverToGet= csb.createNode("packs/to_get.csb")
	
    self:addChild(csbSilverToGet)
	local root = csbSilverToGet:getChildByName("root")
	table.insert(self.roots, root)
	
	local close_button = ccui.Helper:seekWidgetByName(root, "Button_1")
	fwin:addTouchEventListener(close_button, nil, 
    {
        terminal_name = "silver_to_get_close", 
        terminal_state = 0,
		isPressedActionEnabled = true
    }, 
    nil, 0)
	self:initDeclare()
	self:initDraw()
	self:initListView()
end

--update,缓存列表刷新
function SilverToGet:onUpdate()
	if self.listview ~= nil then
		local size = self.listview:getContentSize()
		local posY = self.listview:getInnerContainer():getPositionY()
		if self.listview_PositionY == posY then
			return
		end
		self.listview_PositionY = posY
		local items = self.listview:getItems()
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
function SilverToGet:onEnterTransitionFinish()
	
end

function SilverToGet:init(_window_type)
--_window_type == 1 时 为金钱，后面留空，以后可以添加，英魂，战功，声望什么的。。
	self._window_type = _window_type
	self:onInit()
	return self
end

function SilverToGet:onExit()

end