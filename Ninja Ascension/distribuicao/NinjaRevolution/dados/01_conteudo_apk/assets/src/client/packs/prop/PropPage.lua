PropPage = class("PropPageClass", Window)	

function PropPage:ctor()
    self.super:ctor()
	
	self.roots = {}

	self._duration = 0
	self._elapsed = 0
	self._reloaded = false

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = nil
	
    -- Initialize prop_page page state machine.
    local function init_prop_page_terminal()
		
		local prop_page_manager_terminal = {
            _name = "prop_page_manager",
            _init = function (terminal) 
                app.load("client.cells.prop.prop_list_cell")
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
		
		local prop_page_remove_list_view_cell_terminal = {
            _name = "prop_page_remove_list_view_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
				else
					if instance ~= nil and fwin:find("PropPageClass") == instance then
						instance:removeListViewCell(params._datas._id)
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_page_add_list_view_cell_terminal = {
            _name = "prop_page_add_list_view_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
				else
					instance:updatAddList()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_page_check_list_view_num_cell_terminal = {
            _name = "prop_page_check_list_view_num_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:checkListNum()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local prop_page_reload_list_view_cell_terminal = {
            _name = "prop_page_reload_list_view_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
           		if instance ~= nil and instance.roots ~= nil then
					instance:reload()
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(prop_page_manager_terminal)
		state_machine.add(prop_page_remove_list_view_cell_terminal)
		state_machine.add(prop_page_add_list_view_cell_terminal)
		state_machine.add(prop_page_check_list_view_num_cell_terminal)
		state_machine.add(prop_page_reload_list_view_cell_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_prop_page_terminal()
	
	self:onInit()
end

function PropPage:reload()
	self._reloaded = true
	self:unregisterOnNoteUpdate(self)
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	self.currentListView = nil
	self.currentInnerContainer = nil
	self:removeAllChildren(true)
	self.roots = {}
	self:onInit(self._reloaded)
	self:registerOnNoteUpdate(self)
	self._reloaded = false
end

function PropPage:createListView()
	app.load("client.cells.utils.multiple_list_view_cell")
	PropPage.myListView:removeAllItems()
	local preMultipleCell = nil
	local multipleCell = nil
	for i,v in pairs(PropPage.propItems) do
		local cell = PropListCell:createCell()
		cell:init(10, v, i)
		if multipleCell == nil then
			multipleCell = MultipleListViewCell:createCell()
			multipleCell:init(PropPage.myListView, PropListCell.__size)
			PropPage.myListView:addChild(multipleCell)
			multipleCell.prev = preMultipleCell
			if preMultipleCell ~= nil then
				preMultipleCell.next = multipleCell
			end
		end
		multipleCell:addNode(cell)
		if multipleCell.child2 ~= nil then
			preMultipleCell = multipleCell
			multipleCell = nil
		end
	end

	PropPage.myListView:requestRefreshView()
	if self.currentInnerContainerPosY ~= nil then
		PropPage.myListView:getInnerContainer():setPositionY(self.currentInnerContainerPosY)
		
	end
end

function PropPage:updatAddList()
	local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_warehouse")
	local items = listView:getItems()
	local sortMyPage = self:sortMyPage()
	local skeep = false


	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		PropPage.propItems = sortMyPage
		self:createListView()
	else
		for i=1, table.getn(sortMyPage) do
			skeep = false
			for _,v in ipairs(items) do

				if tonumber(sortMyPage[i].user_prop_template) == tonumber(v.prop.user_prop_template) then
					v:updateDrawCountMID()
					skeep = true
					break 
				end
			end

			if skeep == false then
				local cell = PropListCell:createCell()
				cell:init(10, sortMyPage[i], 0)
				listView:addChild(cell)
			end
		end
	end
	listView:requestRefreshView()
end

function PropPage:removeListViewCell(id)
	local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_warehouse")
	local cells = listView:getItems()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		for i, v in pairs(cells) do
			if v.child1 ~= nil and v.child1.prop.user_prop_template == id or tonumber(v.child1.prop.prop_number) == 0 then
				v.child1:removeFromParent(true)
				v.child1 = nil
			end
			if v.child2 ~= nil and v.child2.prop.user_prop_template == id or tonumber(v.child2.prop.prop_number) == 0 then
				v.child2:removeFromParent(true)
				v.child2 = nil
			end
			state_machine.excute("multiple_list_view_cell_manager", 0, v)
		end
	else
		for i, v in pairs(cells) do
			if v.prop.user_prop_template == id or tonumber(v.prop.prop_number) == 0 then
				listView:removeItem(listView:getIndex(v))
			end
		end
	end
end

function PropPage:checkListNum()
	local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_warehouse")
	local cells = listView:getItems()
	local num = 1

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		for i, v in pairs(cells) do
			for j, k in pairs(_ED.user_prop) do
				if v.child1 ~= nil and tonumber(v.child1.prop.user_prop_template) == tonumber(k.user_prop_template) and tonumber(v.child1.prop.prop_number) ~= tonumber(k.prop_number) then
					state_machine.excute("prop_list_cellprop_update_num", 0, {k.prop_number,v.child1}) 
				end
				if v.child2 ~= nil and tonumber(v.child2.prop.user_prop_template) == tonumber(k.user_prop_template) and tonumber(v.child2.prop.prop_number) ~= tonumber(k.prop_number) then
					state_machine.excute("prop_list_cellprop_update_num", 0, {k.prop_number,v.child2}) 
				end
			end
		end
	else
		for i, v in pairs(cells) do
			for j, k in pairs(_ED.user_prop) do
				if tonumber(v.prop.user_prop_template) == tonumber(k.user_prop_template) and tonumber(v.prop.prop_number) ~= tonumber(k.prop_number) then
					state_machine.excute("prop_list_cellprop_update_num", 0, {k.prop_number,v}) 
				end
			end
		end
	end
end

function PropPage:sortMyPage()
	-- -------------------------------------------------------------------------------------------------
	--排序
	-- by sort array
	local dUserProp = {}

	--物品数组
	local dVipArray={} --vip类型4
	local dCommonBoxArray={} --普通箱子类型2,3
	local dEnableArray={} --可使用物品
	local dGiftArray={} --礼物
	local dDisEnableArray={} --不可使用物品
	
	
	--得到各类物品数组
	local function getPropArray(t,array)
		local pIndex = table.getn(array) + 1
		for i, propInfo in pairs(_ED.user_prop) do
			local tProp = dms.int(dms["prop_mould"], propInfo.user_prop_template, prop_mould.props_type)
			if(tProp==t) then
				array[pIndex]=propInfo
				pIndex = pIndex + 1
			end
		end
	end
	
	
	--得到可使用或不可使用物品
	local function getEnablePropArray(b,array, e)
		local pIndex = 1
		for i, propInfo in pairs(_ED.user_prop) do
			local bEnable = dms.string(dms["prop_mould"], propInfo.user_prop_template, prop_mould.can_sell)
			local tProp = dms.int(dms["prop_mould"], propInfo.user_prop_template, prop_mould.props_type)
			if(bEnable==b and tProp~=2 and tProp~=3 and tProp~=4) then
				local storgeIndex = dms.int(dms["prop_mould"], propInfo.user_prop_template, prop_mould.storage_page_index)
				if storgeIndex == 0 then
					if e == true then
						array[pIndex]=propInfo
						pIndex = pIndex + 1
					end
				end			
			end
		end
	end
	
	
	
	
	--合并数组
	local function merge(array)
		local pIndex = 1
		for i, propInfo in pairs(dVipArray) do
			array[pIndex]=propInfo
			pIndex=pIndex+1
		end
		
		for i, propInfo in pairs(dCommonBoxArray) do
			array[pIndex]=propInfo
			pIndex=pIndex+1
		end
		
		for i, propInfo in pairs(dEnableArray) do
			array[pIndex]=propInfo
			pIndex=pIndex+1
		end
		
		for i , propInfo in pairs(dGiftArray) do
			array[pIndex]=propInfo
			pIndex=pIndex+1
		end
		
		for i, propInfo in pairs(dDisEnableArray) do
			array[pIndex]=propInfo
			pIndex=pIndex+1
		end
	end
	
	local userPropSortFunc = function(a,b)
		--获取物品品质
		local aq = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)
		local bq = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)
		
		local ad = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.props_type)
		local bd = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.props_type)

		local result = false
		if ad < bd or (ad == bd and aq  >  bq) then 
			result = true
		end
		return result
	end
	
	local qualitySortIdFunc = function(a,b)
		--物品品质
		local aq = tonumber(a.user_prop_template)
		local bq = tonumber(b.user_prop_template)

		local result = false
		if aq < bq then 
			result = true
		end
		return result
	end

	local userTypeSortIdFunc = function(a,b)
		--使用类型
		local au = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.use_type)
		local bd = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.use_type)

		local result = false
		if au < bd then 
			result = true
		end
		return result 

	end

	--舰娘排序用
	local legendaryGameSortFunc = function(a,b)
		--获取物品品质
		local aq = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.prop_quality)
		local bq = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.prop_quality)
		
		local ad = dms.int(dms["prop_mould"], a.user_prop_template, prop_mould.id)
		local bd = dms.int(dms["prop_mould"], b.user_prop_template, prop_mould.id)

		local result = false
		if aq > bq or (aq == bq and ad  <  bd) then 
			result = true
		end
		return result
	end

	-- 获取物品存放到数组中方便下次品质排序
	getPropArray(4,dVipArray)
	getPropArray(2,dCommonBoxArray)
	getPropArray(3,dCommonBoxArray)
	getEnablePropArray("0",dEnableArray)
	getEnablePropArray("1",dDisEnableArray)
	getEnablePropArray("0", dGiftArray, true)
	
	if __lua_project_id == __lua_project_warship_girl_a or 
		__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
	else
		-- 对所有物品进行品质排序
		table.sort(dVipArray, userPropSortFunc)
		table.sort(dCommonBoxArray, userPropSortFunc)
		table.sort(dEnableArray, userPropSortFunc)
		table.sort(dGiftArray, userPropSortFunc)
		table.sort(dDisEnableArray, userPropSortFunc)
	end
	
	
	merge(dUserProp)
	
	if __lua_project_id == __lua_project_warship_girl_a or 
		__lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		table.sort(dUserProp, legendaryGameSortFunc)
	else
		table.sort(dUserProp, qualitySortIdFunc)
		table.sort(dUserProp, userTypeSortIdFunc)
	end

	return dUserProp
	--END
	-------------------------------------------------------------------------------------------------
end

function PropPage.loading(texture)
	local myListView = PropPage.myListView
	if myListView ~= nil then
		local cell = PropListCell:createCell()
		cell:init(10, PropPage.propItems[PropPage.asyncIndex], PropPage.asyncIndex)
		myListView:addChild(cell)
		PropPage.asyncIndex = PropPage.asyncIndex + 1
		-- myListView:requestRefreshView()
	end
end

-- function PropPage:onUpdate(dt)
-- 	self._elapsed = self._elapsed + dt
-- 	if self._elapsed >= self._duration then
-- 		local myListView = PropPage.myListView
-- 		if myListView ~= nil then
-- 			local cell = PropListCell:createCell()
-- 			cell:init(10, PropPage.propItems[PropPage.asyncIndex])
-- 			myListView:addChild(cell)
-- 			PropPage.asyncIndex = PropPage.asyncIndex + 1
-- 			myListView:requestRefreshView()
-- 			if PropPage.asyncIndex > #PropPage.propItems then
-- 				self:unregisterOnNoteUpdate(self)
-- 			end
-- 		end
-- 		self._elapsed = 0
-- 	end
-- end


function PropPage:onUpdate(dt)
	if self.currentListView ~= nil and self.currentInnerContainer ~= nil then
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

function PropPage:onEnterTransitionFinish()

end

function PropPage:onInit(reload)
	local csbPropListView = csb.createNode("packs/warehouse_listvisw.csb")
	local root = csbPropListView:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPropListView)

    if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
    	if reload ~= true then
    		Animations_PlayOpenMainUI({self}, SHOW_UI_ACTION_TYPR.TYPE_ACTION_CENTER_IN)
    	end
    elseif __lua_project_id == __lua_project_legendary_game then
		local action = csb.createTimeline("packs/warehouse_listvisw.csb")
		csbPropListView:runAction(action)
		self.m_action = action
		if reload ~= true then
			self:playIntoAction()
		end
	end

 --    -- self._duration = 0.15
 --    -- self:registerOnNoteUpdate(self, 0.15)
	
	-- local listView = ccui.Helper:seekWidgetByName(root, "ListView_warehouse")
	-- for i, prop in pairs(self:sortMyPage()) do
	-- 	local cell = PropListCell:createCell()
	-- 	-- cell:init(10, prop, (j - 1) * 2 + i)
	-- 	cell:init(10, prop, i)
	-- 	listView:addChild(cell)
	-- end

	-- listView:requestRefreshView()

	PropPage.myListView = ccui.Helper:seekWidgetByName(root, "ListView_warehouse")
	PropPage.propItems = self:sortMyPage()
	PropPage.asyncIndex = 1
	-- cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self:createListView()
	else
		for i, prop in pairs(PropPage.propItems) do
			-- if PropPage.asyncIndex <= 5 then
			-- 	self.loading(nil)
			-- else
			-- 	cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading)
			-- end

			self.loading(nil)
		end

		PropPage.myListView:requestRefreshView()
	end
	
	self.currentListView = PropPage.myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function PropPage:playCloseAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self:onClose()
	elseif __lua_project_id == __lua_project_legendary_game then
		self.m_action:play("window_close", false)
	end
end

function PropPage:playIntoAction()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then
		self.m_action:play("window_open", false)
		self.m_action:setTimeSpeed(app.getTimeSpeed())
		self.m_action:setFrameEventCallFunc(function (frame)
	        if nil == frame then
	            return
	        end

	        local str = frame:getEvent()
	        if str == "window_open_over" then
	        	
	        elseif str == "window_close_over" then
	            self:onClose()
	        end
	    end)
	end
end

function PropPage:close()
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		if fwin:find("ShopVIPPropShowClass") ~= nil then
			fwin:close(fwin:find("ShopVIPPropShowClass"))
		end
	end
end

function PropPage:onExit()
	PropPage.myListView = nil
	PropPage.asyncIndex = 1
	self:unregisterOnNoteUpdate(self)
	-- state_machine.remove("prop_page_use_materials")
	-- state_machine.remove("prop_page_remove_list_view_cell")
	-- state_machine.remove("Prop_Page_chick")

end
