-- ----------------------------------------------------------------------------------------------------
-- 说明：sm商城道具购买页
-------------------------------------------------------------------------------------------------------

SmShopTab = class("SmShopTabClass", Window)

local sm_shop_tab_open_terminal = {
    _name = "sm_shop_tab_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local SmShopTabWindow = fwin:find("SmShopTabClass")
    	if SmShopTabWindow ~= nil then
    		SmShopTabWindow:setVisible(true)
    		return
    	end
    	local page = SmShopTab:new():init(params)
		return page
    end,
    _terminal = nil,
    _terminals = nil
}
state_machine.add(sm_shop_tab_open_terminal)
state_machine.init()

function SmShopTab:ctor()
    self.super:ctor()
	self.roots = {}
	self.index = 2
	self._scroll_view = nil
	self._scroll_view_pox = 0
	self._scroll_view_width = 0
	self.roll_width = 0
	app.load("client.l_digital.cells.prop.sm_shop_prop_buy_list_cell")
	app.load("client.l_digital.shop.SmShopRefreshWindow")
	local function init_sm_shop_tab_terminal()
		--
		local sm_shop_tab_update_shop_terminal = {
            _name = "sm_shop_tab_update_shop",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("sm_shop_refresh_window_open" , 0 , instance.index)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_tab_update_terminal = {
            _name = "sm_shop_tab_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateMoney()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local sm_shop_tab_updateDraw_terminal = {
            _name = "sm_shop_tab_updateDraw",
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
        state_machine.add(sm_shop_tab_update_shop_terminal)
		state_machine.add(sm_shop_tab_update_terminal)
		state_machine.add(sm_shop_tab_updateDraw_terminal)
        state_machine.init()
	end
	init_sm_shop_tab_terminal()
end

function SmShopTab:onUpdateMoney()
	local root = self.roots[1]
	local Text_res_number = ccui.Helper:seekWidgetByName(root, "Text_res_number")
	local curr_cost = 0
	if self.index == 2 then
		curr_cost = 0
	elseif self.index == 3 then
		curr_cost = _ED.user_info.user_honour
	elseif self.index == 4 then
		curr_cost = _ED.user_info.all_glories
	else
		curr_cost = _ED.union.user_union_info.rest_contribution
	end
	Text_res_number:setString(curr_cost)
end

function SmShopTab:onUpdateDraw()
	local root = self.roots[1]
	local ScrollView_commodity = ccui.Helper:seekWidgetByName(root, "ScrollView_commodity")
    if type(cc.nrSpineCommand)=='function' then
        ScrollView_commodity:stopAutoScroll()
        ScrollView_commodity:setDirection(ccui.ScrollViewDir.horizontal)
        ScrollView_commodity:setBounceEnabled(false)
        ScrollView_commodity:setInertiaScrollEnabled(false)
    end
    local previousX=ScrollView_commodity:getInnerContainer():getPositionX()
	ScrollView_commodity:removeAllChildren(true)
	local Panel_res = ccui.Helper:seekWidgetByName(root, "Panel_res")
	local image_ghb = ccui.Helper:seekWidgetByName(root, "image_ghb_2")
	local image_jjb = ccui.Helper:seekWidgetByName(root, "image_jjb_2")
	local image_slb = ccui.Helper:seekWidgetByName(root, "image_slb_2")
	image_ghb:setVisible(false)
	image_jjb:setVisible(false)
	image_slb:setVisible(false)
	local show_group = {}
	local show_group2 = {}
	Panel_res:setVisible(true)
	if self.index == 2 then
		Panel_res:setVisible(false)
		show_group = _ED.secret_shop_init_info.goods_info
	elseif self.index == 3 then
		image_jjb:setVisible(true)
		show_group = _ED.arena_good
	elseif self.index == 4 then
		image_slb:setVisible(true)
		show_group = _ED.glories_shop_info
	else
		image_ghb:setVisible(true)
		show_group = _ED.union.union_shop_info.treasure.goods_info
		-- local function sortTable( a, b )
	 --        return tonumber(a.goods_id) < tonumber(b.goods_id)
	 --            or tonumber(a.goods_id) == tonumber(b.goods_id) and tonumber(a.goods_id) > tonumber(b.goods_id)
	 --    end
		-- table.sort(show_group , sortTable)
	end
	local cell_size = nil
	local width_n = math.ceil((#show_group + #show_group2)/ 2)
	local index = 1
	for i , v in pairs(show_group) do 
		local cell = SmShopPropBuyListCell:createCell()
		local prop = self:getPropByType(v,1)
		cell:init(prop,self.index,index)
		if cell_size == nil then
			cell_size = cell:getContentSize()
		end
		if prop.showlv ~= nil 
			and ((tonumber(_ED.user_info.user_grade) < tonumber(prop.showlv[1])) or (tonumber(_ED.user_info.user_grade) > tonumber(prop.showlv[2]))) 
			then
		else
			-- cell:setVisible(false)
            if type(cc.nrSpineCommand)=='function' then
                local function propagate(node)
                    if node.setPropagateTouchEvents then node:setPropagateTouchEvents(true) end
                    for _,child in ipairs(node:getChildren()) do propagate(child) end
                end
                propagate(cell)
            end
			ScrollView_commodity:addChild(cell)
			cell:setPosition(cc.p( ((index - 1) % width_n) * cell_size.width , (2 - math.ceil( index / width_n)) * cell_size.height))
			-- if cell.roots ~= nil and cell.roots[1] ~= nil then
			-- 	cell.roots[1]:setScale(1.15)
			-- 	cell.roots[1]:setAnchorPoint(cc.p(0.5,0.5))
			-- end
			index = index + 1
		end
	end

	for i , v in pairs(show_group2) do 
		local cell = SmShopPropBuyListCell:createCell()
		local prop = self:getPropByType(v,2)
		cell:init(prop,self.index,index)
		if cell_size == nil then
			cell_size = cell:getContentSize()
		end
		if prop.showlv ~= nil 
			and ((tonumber(_ED.user_info.user_grade) < tonumber(prop.showlv[1])) or (tonumber(_ED.user_info.user_grade) > tonumber(prop.showlv[2]))) 
			then
		else
			-- cell:setVisible(false)
            if type(cc.nrSpineCommand)=='function' then
                local function propagate(node)
                    if node.setPropagateTouchEvents then node:setPropagateTouchEvents(true) end
                    for _,child in ipairs(node:getChildren()) do propagate(child) end
                end
                propagate(cell)
            end
			ScrollView_commodity:addChild(cell)
			cell:setPosition(cc.p( ((index - 1) % width_n) * cell_size.width , (2 - math.ceil( index / width_n)) * cell_size.height))
			-- if cell.roots ~= nil and cell.roots[1] ~= nil then
			-- 	cell.roots[1]:setScale(1.15)
			-- 	cell.roots[1]:setAnchorPoint(cc.p(0.5,0.5))
			-- end
			index = index + 1
		end
	end

	if nil ~= cell_size then
		self.roll_width = cell_size.width * 3
		local InnerWidth = math.max(cell_size.width * width_n , ScrollView_commodity:getContentSize().width)
        if type(cc.nrSpineCommand)=='function' then
            local height=math.max(cell_size.height*2,ScrollView_commodity:getContentSize().height)
            ScrollView_commodity:setInnerContainerSize(cc.size(InnerWidth,height))
            local minX=ScrollView_commodity:getContentSize().width-InnerWidth
            ScrollView_commodity:getInnerContainer():setPositionX(math.max(minX,math.min(0,previousX)))
        else
		ScrollView_commodity:getInnerContainer():setContentSize(cc.size(InnerWidth , cell_size.height * 2))
        end
	end

    self._scroll_view = ScrollView_commodity
    self._scroll_view_pox = 99999--ScrollView_commodity:getInnerContainer():getPositionX()
    self._scroll_view_width = ScrollView_commodity:getInnerContainer():getPositionX()

	local refresh_times = zstring.split(dms.string(dms["shop_config"], 1, shop_config.param) , ",")
	local nextReresh = 0
	local isToday = false
	local str = ""
	local server_time = getCurrentGTM8Time()
	-- local currTimes = os.date("%H", os.time()) * 3600 + os.date("%M", os.time()) * 60 + os.date("%S", os.time())
	local currTimes = server_time.hour * 3600 + server_time.min * 60 + server_time.sec
	local nextTimes = 0
	-- local currhour = os.date("%H", os.time())
	local currhour = server_time.hour
	for i , v in pairs(refresh_times) do
		local _hour = tonumber(zstring.split(v , ":")[1])
		if tonumber(currhour) < _hour then
			nextReresh = _hour
			nextTimes = _hour * 3600
			isToday = true
			break
		end
	end
	if isToday == false then
		nextReresh = tonumber(zstring.split(refresh_times[1] , ":")[1])
		nextTimes = ( nextReresh + 24) * 3600
		str = string.format(_new_interface_text[101], nextReresh)
	else
		str = string.format(_new_interface_text[100], nextReresh)
	end
	local Text_time = ccui.Helper:seekWidgetByName(root, "Text_time_refresh")
	Text_time:setString(_new_interface_text[102]..str)
	self:onUpdateMoney()
	local function refreshUpdateDraw( ... )
		state_machine.excute("shop_prop_buy_list_scrollView_update", 0 ,"shop_prop_buy_list_scrollView_update.")
	end
	self:stopAllActions()
	self:runAction(cc.Sequence:create(cc.DelayTime:create(nextTimes - currTimes), cc.CallFunc:create(refreshUpdateDraw)))
end

function SmShopTab:onUpdate(dt)
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

function SmShopTab:getPropByType(originalProp,page)
	 function change_type(prop_type)
        if prop_type == 0 then
            return 6 
        elseif prop_type == 1 then
            return 13
        elseif prop_type == 2 then
            return 7
        elseif prop_type == 4 then
            return 34
        elseif prop_type == -1 then
            return 1
        end
    end
	local prop = {}
	prop.buy_limit = 1
	if self.index == 2 then
		prop.mould_id = originalProp.goods_id
		prop.buy_times = 1 - tonumber(originalProp.remain_times)
		prop.sale_percentage = originalProp.sell_price
		prop.number = originalProp.sell_count
		prop.type = change_type(tonumber(originalProp.goods_type))
		prop.sell_type = tonumber(originalProp.sell_type)
	elseif self.index == 3 then
		local reward = dms.element(dms["arena_shop_info"], originalProp.good_id)
		prop.buy_times = tonumber(originalProp.exchange_times)
		prop.mould_id = dms.atoi(reward, arena_shop_info.item_mould)
		prop.sale_percentage = dms.atoi(reward, arena_shop_info.need_honor)
		prop.number = dms.atoi(reward, arena_shop_info.sell_count)
		prop.type = change_type(dms.atoi(reward, arena_shop_info.item_type))
		prop.buy_limit = dms.atoi(reward, arena_shop_info.exchange_count_limit)
		prop.refresh_type = dms.atoi(reward, arena_shop_info.refresh_type)
	elseif self.index == 4 then
		local reward = dms.element(dms["glories_shop_info"], originalProp.goods_id)
		prop.buy_times = tonumber(originalProp.goods_exchange_times)
		prop.mould_id = dms.atoi(reward, glories_shop_info.item_mould)
		prop.sale_percentage = dms.atoi(reward, glories_shop_info.need_glories)
		prop.number = dms.atoi(reward, glories_shop_info.sell_count)
		prop.type = change_type(dms.atoi(reward, glories_shop_info.item_type))
		prop.buy_limit = dms.atoi(reward, glories_shop_info.exchange_limit)
		prop.refresh_type = dms.atoi(reward, glories_shop_info.refresh_type)
	elseif self.index == 5 then
		local reward = dms.element(dms["union_shop_library"], originalProp.goods_id)
		prop.buy_times = tonumber(originalProp.remain_times)
		prop.mould_id = dms.atoi(reward, union_shop_library.mould_id)
		prop.sale_percentage = dms.atoi(reward, union_shop_library.cost_contribution)
		prop.number = dms.atoi(reward, union_shop_library.sell_one_count)
		prop.type = change_type(dms.atoi(reward, union_shop_library.shop_type))
		prop.showlv = zstring.split(dms.atos(reward, union_shop_library.showLv),",")
		prop.buy_limit = dms.atoi(reward, union_shop_library.can_buy_count)
		prop.refresh_type = dms.atoi(reward, union_shop_library.refresh_type)
	end
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

function SmShopTab:onInit()
	local csbSmShopTab = csb.createNode("shop/shop_listview_tab_2.csb")
	local root = csbSmShopTab:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csbSmShopTab)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_refresh"), nil, 
	{
		terminal_name = "sm_shop_tab_update_shop", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 2)
	
	self:onUpdateDraw()

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function SmShopTab:init(params)
	self.index = params
	self:onInit()
	return self
end

function SmShopTab:onExit()
	state_machine.remove("sm_shop_tab_update")
	state_machine.remove("sm_shop_tab_update_shop")
	state_machine.remove("sm_shop_tab_updateDraw")
end

