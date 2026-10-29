--[[ ----------------------------------------------------------------------------
-- 商店
--]] ----------------------------------------------------------------------------
CrossTotalWarShop = class("CrossTotalWarShopClass", Window)

-- 打开窗口
local cross_total_war_shop_window_open_terminal = {
	_name = "cross_total_war_shop_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("CrossTotalWarShopClass") then
			fwin:open(CrossTotalWarShop:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local cross_total_war_shop_window_close_terminal = {
	_name = "cross_total_war_shop_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("CrossTotalWarShopClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(cross_total_war_shop_window_open_terminal)
state_machine.add(cross_total_war_shop_window_close_terminal)
state_machine.init()

-- 构造器
function CrossTotalWarShop:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self._tick_time = 0
	-- load lua files.
	app.load("client.l_digital.campaign.cross_total_war.CrossTotalWarShopCell")
	
	-- Initialize cross total war shop page state machine.
	local function init_cross_total_war_shop_terminal()
		-- 打开角色创建窗口
		local cross_total_war_shop_open_terminal = {
			_name = "cross_total_war_shop_open",
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
		local cross_total_war_shop_close_terminal = {
			_name = "cross_total_war_shop_close",
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
		local cross_total_war_shop_show_terminal = {
			_name = "cross_total_war_shop_show",
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
		local cross_total_war_shop_hide_terminal = {
			_name = "cross_total_war_shop_hide",
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

		-- 刷金币
		local cross_total_war_fresh_coin_terminal = {
			_name = "cross_total_war_fresh_coin",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance.Text_res_number:setString(_ED.cross_arena_shop_info.coin)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(cross_total_war_fresh_coin_terminal)
		state_machine.add(cross_total_war_shop_open_terminal)
		state_machine.add(cross_total_war_shop_close_terminal)
		state_machine.add(cross_total_war_shop_show_terminal)
		state_machine.add(cross_total_war_shop_hide_terminal)
		state_machine.init()
	end
	-- call func init cross total war shop state machine.
	init_cross_total_war_shop_terminal()
end

-- 对象初始化
function CrossTotalWarShop:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function CrossTotalWarShop:onUpdateDraw()
	local root = self.roots[1]

	-- 忍具币数量
	self.Text_res_number = ccui.Helper:seekWidgetByName(root, "Text_res_number")
	self.Text_res_number:setString(_ED.cross_arena_shop_info.coin)

	-- 商店容器
	local ScrollView_commodity = ccui.Helper:seekWidgetByName(root, "ScrollView_commodity")
    ScrollView_commodity:removeAllChildren(true)
  

    local show_group = _ED.cross_arena_shop_info.goods

    local function sortFunction(a, b)
        return a.weights < b.weights
    end
    table.sort(show_group, sortFunction)

    local cell_size = nil
    local width_n = math.ceil((#show_group)/ 2)
	local cell_group = {}
	--debug.print_r(show_group,'show_group===================')
	
    for i , v in pairs(show_group) do 
		-- local prop = self:getPropByType(v)
		--debug.print_r(v,'v===================')
        local cell = CrossTotalWarShopCell:createCell()
		cell:init(v)
        if cell_size == nil then
            cell_size = cell:getContentSize()
        end

        ScrollView_commodity:addChild(cell)
		table.insert(cell_group, cell)

    end

    if cell_size ~= nil then
        self.roll_width = cell_size.width * 3
        local InnerWidth = math.max(cell_size.width * width_n , ScrollView_commodity:getContentSize().width)
        ScrollView_commodity:setInnerContainerSize(cc.size(InnerWidth , cell_size.height * 2))
        self.scrollView = ScrollView_commodity

        for k, v in pairs(cell_group) do
            v:setPosition(cc.p( ((k - 1) % width_n) * cell_size.width , (2 - math.ceil( k / width_n)) * cell_size.height))
        end
    end

    self._scroll_view = ScrollView_commodity
    self._scroll_view_pox = 99999--ScrollView_commodity:getInnerContainer():getPositionX()
    self._scroll_view_width = ScrollView_commodity:getInnerContainer():getPositionX()
	
	-- 99小時99分99秒后刷新
	self._text_time = ccui.Helper:seekWidgetByName(root, "Text_time_refresh")
	self._text_time:setVisible(false)
end

function CrossTotalWarShop:getPropByType(originalProp)
	

   local prop = {}

   local reward = dms.element(dms["cross_arena_shop"], originalProp.goodsId)
   --debug.print_r(reward,'reward')

   local goods_info = zstring.split(dms.atos(reward, 2), ",")
   local cost_info = zstring.split(dms.atos(reward, 3), ",")

   prop.mould_id = tonumber(goods_info[2])
   prop.type = tonumber(goods_info[1])
   prop.sale_percentage = originalProp.price
   prop.good_index = originalProp.weights
   prop.max_buy_times = originalProp.maxFrequency
   prop.good_id = originalProp.goodsId

   if prop.number == nil then
	   prop.number = 1
   end

   local prop_info = nil
   if prop.type == 6 then
	   prop_info = dms.element(dms["prop_mould"], prop.mould_id)
	   if prop.mould_name == nil then
		   prop.mould_name = dms.atos(prop_info, prop_mould.prop_name)
		   if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			   prop.mould_name = setThePropsIcon(prop.mould_id)[2]
		   end
	   end
	   if prop.prop_quality == nil then
		   prop.prop_quality = dms.atoi(prop_info, prop_mould.prop_quality)
	   end
	   prop.mould_remarks = dms.atos(prop_info, prop_mould.remarks)
	   if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		   prop.mould_remarks = drawPropsDescription(prop.mould_id)
	   end
   elseif prop.type == 7 then
	   prop_info = dms.element(dms["equipment_mould"], prop.mould_id)
	   if prop.mould_name == nil then
		   prop.mould_name = smEquipWordlFundByIndex(prop.mould_id , 1)
	   end
	   prop.prop_quality = dms.atoi(prop_info, equipment_mould.trace_npc_index)
	   if prop.prop_quality == 0 then
		   prop.prop_quality = 3
	   end
	   prop.mould_remarks = smEquipWordlFundByIndex(prop.mould_id , 2)--描述
   end
   return prop
end

function CrossTotalWarShop:onEnterTransitionFinish()
	-- 加载CrossTotalWarShopWindow界面资源.
	-- res.campaign.cross_total_war.cross_total_war_shop = res/campaign/cross_total_war/cross_total_war_shop.csb
	local csbNode = csb.createNode("campaign/cross_total_war/cross_total_war_shop.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "cross_total_war_shop_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:initData()
end
function CrossTotalWarShop:initData()
	-- 初始信息
	local function cross_arena_shop_initCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if nil ~= response.node and nil ~= response.node.roots then
				response.node:onUpdateDraw()
			end
		end
	-- _ED.cross_arena_shop_info = json.decode('{"coin":999,"goods":[{"goodsId":1,"price":500,"maxFrequency":10,"purchasedTimes":2,"weights":10},{"goodsId":2,"price":600,"maxFrequency":5,"purchasedTimes":0,"weights":20}]}')
	end
	protocol_command.cross_arena_shop_init.param_list = ""
	NetworkManager:register(protocol_command.cross_arena_shop_init.code, nil, nil, nil, self, cross_arena_shop_initCallback, false, nil)
end

function CrossTotalWarShop:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time < 0 then
            self._tick_time = 0
            self:initData()
        end
    end
    if self._scroll_view ~= nil then
        local size = self._scroll_view:getContentSize()
        local posX = self._scroll_view:getInnerContainer():getPositionX()
        if self._scroll_view_pox == posX then
            return
        end
        self._scroll_view_pox = posX
        local items = self._scroll_view:getChildren()
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

function CrossTotalWarShop:onExit()
	-- 释放CrossTotalWarShopWindow界面资源.
	state_machine.remove("cross_total_war_shop_open")
	state_machine.remove("cross_total_war_shop_close")
	state_machine.remove("cross_total_war_shop_show")
	state_machine.remove("cross_total_war_shop_hide")
	state_machine.remove("cross_total_war_fresh_coin")
	
end

function CrossTotalWarShop:close()
	-- window event : close.
	
end

function CrossTotalWarShop:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
