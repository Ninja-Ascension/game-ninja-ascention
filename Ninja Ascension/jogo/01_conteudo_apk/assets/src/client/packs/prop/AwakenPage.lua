-- ----------------------------------------------------------------------------------------------------
-- 说明：觉醒装备
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------


AwakenPage = class("AwakenPageClass", Window)	

function AwakenPage:ctor()
    self.super:ctor()
	
	self.roots = {}

	self._duration = 0
	self._elapsed = 0
	self._reloaded = false

	self.currentListView = nil
	self.currentInnerContainer = nil
	self.currentInnerContainerPosY = nil
	
    -- Initialize awaken_page page state machine.
    local function init_awaken_page_terminal()
		
		local awaken_page_manager_terminal = {
            _name = "awaken_page_manager",
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
		
		local awaken_page_remove_list_view_cell_terminal = {
            _name = "awaken_page_remove_list_view_cell",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				
				if instance ~= nil and fwin:find("AwakenPageClass") == instance then
					instance:removeListViewCell(params._datas._id)
				end
			
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local awaken_page_add_list_view_cell_terminal = {
            _name = "awaken_page_add_list_view_cell",
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
		
		local awaken_page_check_list_view_num_cell_terminal = {
            _name = "awaken_page_check_list_view_num_cell",
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
		
		local awaken_page_reload_list_view_cell_terminal = {
            _name = "awaken_page_reload_list_view_cell",
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
		
		state_machine.add(awaken_page_manager_terminal)
		state_machine.add(awaken_page_remove_list_view_cell_terminal)
		state_machine.add(awaken_page_add_list_view_cell_terminal)
		state_machine.add(awaken_page_check_list_view_num_cell_terminal)
		state_machine.add(awaken_page_reload_list_view_cell_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_awaken_page_terminal()
	
	self:onInit()
end

function AwakenPage:reload()
	self._reloaded = true
	
	self.currentInnerContainerPosY = self.currentInnerContainerPosY -500
	AwakenPage.asyncIndex = 1
	AwakenPage.propItems = self:sortMyPage()
	
	
	self:createListView()
	self._reloaded = false
	self:onUpdate(1)

end

function AwakenPage:createListView()
	app.load("client.cells.utils.multiple_list_view_cell")
	AwakenPage.myListView:removeAllItems()
	local preMultipleCell = nil
	local multipleCell = nil
	for i,v in pairs(AwakenPage.propItems) do
		local cell = PropListCell:createCell()
		cell:init(10, v, i)
		if multipleCell == nil then
			multipleCell = MultipleListViewCell:createCell()
			multipleCell:init(AwakenPage.myListView, PropListCell.__size)
			AwakenPage.myListView:addChild(multipleCell)
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

	AwakenPage.myListView:requestRefreshView()
	if self.currentInnerContainerPosY ~= nil then
		--AwakenPage.myListView:getInnerContainer():setPositionY(self.currentInnerContainerPosY)
		
	end
end

function AwakenPage:updatAddList()
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
		AwakenPage.propItems = sortMyPage
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

function AwakenPage:removeListViewCell(id)
	local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_warehouse")
	local cells = listView:getItems()
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
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
		end
	else
		for i, v in pairs(cells) do
			if v.prop.user_prop_template == id or tonumber(v.prop.prop_number) == 0 then
				listView:removeItem(listView:getIndex(v))
			end
		end
	end

end

function AwakenPage:removeListViewCell(id)
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

function AwakenPage:checkListNum()
	local listView = ccui.Helper:seekWidgetByName(self.roots[1], "ListView_warehouse")
	local cells = listView:getItems()
	local num = 1

	for i, v in pairs(cells) do
		for j, k in pairs(_ED.user_prop) do
			if tonumber(v.prop.user_prop_template) == tonumber(k.user_prop_template) and tonumber(v.prop.prop_number) ~= tonumber(k.prop_number) then
				state_machine.excute("prop_list_cellprop_update_num", 0, {k.prop_number,v}) 
			end
		end
	end
	
end

function AwakenPage:sortMyPage()
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
			if(tProp==16) then
				array[pIndex]=propInfo
				pIndex = pIndex + 1
			end
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
		-- 对所有物品进行品质排序
	table.sort(dVipArray, userPropSortFunc)
	local pIndex = 1
	for i, propInfo in pairs(dVipArray) do
		dUserProp[pIndex]=propInfo
		pIndex=pIndex+1
	end

	return dUserProp
	--END
	-------------------------------------------------------------------------------------------------
end

function AwakenPage.loading(texture)
	local myListView = AwakenPage.myListView
	if myListView ~= nil then
		local cell = PropListCell:createCell()
		cell:init(10, AwakenPage.propItems[AwakenPage.asyncIndex], AwakenPage.asyncIndex)
		myListView:addChild(cell)
		AwakenPage.asyncIndex = AwakenPage.asyncIndex + 1
	end
end

-- function AwakenPage:onUpdate(dt)
-- 	self._elapsed = self._elapsed + dt
-- 	if self._elapsed >= self._duration then
-- 		local myListView = AwakenPage.myListView
-- 		if myListView ~= nil then
-- 			local cell = PropListCell:createCell()
-- 			cell:init(10, AwakenPage.propItems[AwakenPage.asyncIndex])
-- 			myListView:addChild(cell)
-- 			AwakenPage.asyncIndex = AwakenPage.asyncIndex + 1
-- 			myListView:requestRefreshView()
-- 			if AwakenPage.asyncIndex > #AwakenPage.propItems then
-- 				self:unregisterOnNoteUpdate(self)
-- 			end
-- 		end
-- 		self._elapsed = 0
-- 	end
-- end


function AwakenPage:onUpdate(dt)
	if self._reloaded == true then 
		return
	end
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

function AwakenPage:onEnterTransitionFinish()

end

function AwakenPage:onInit(reload)
	local csbPropListView = csb.createNode("packs/warehouse_listvisw.csb")
	local root = csbPropListView:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbPropListView)


	AwakenPage.myListView = ccui.Helper:seekWidgetByName(root, "ListView_warehouse")
	AwakenPage.propItems = self:sortMyPage()
	AwakenPage.asyncIndex = 1
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then 
		self:createListView()
	else
		for i, prop in pairs(AwakenPage.propItems) do
			self.loading(nil)
		end
	end
	AwakenPage.myListView:requestRefreshView()

	self.currentListView = AwakenPage.myListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function AwakenPage:playCloseAction()
	
end

function AwakenPage:playIntoAction()

end
function AwakenPage:close()

end
function AwakenPage:onExit()
	AwakenPage.myListView = nil
	AwakenPage.asyncIndex = 1
	self:unregisterOnNoteUpdate(self)

end
