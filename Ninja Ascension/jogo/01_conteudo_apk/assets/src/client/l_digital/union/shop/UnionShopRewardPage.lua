--------------------------------------------------------------------------------------------------------------
--  说明：军团商店奖励界面
--------------------------------------------------------------------------------------------------------------
UnionShopRewardPage = class("UnionShopRewardPageClass", Window)
--打开界面
local union_shop_reward_page_open_terminal = {
	_name = "union_shop_reward_page_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		local UnionShopRewardPage = fwin:find("UnionShopPropPageClass")
		if UnionShopRewardPage ~= nil and UnionShopRewardPage:isVisible() == true then
			return true
		end
		fwin:open(UnionShopRewardPage:new():init(params),fwin._view)
		
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local union_shop_reward_page_close_terminal = {
	_name = "union_shop_reward_page_close",
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
state_machine.add(union_shop_reward_page_open_terminal)
state_machine.add(union_shop_reward_page_close_terminal)
state_machine.init()
function UnionShopRewardPage:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union shop reward page machine.
    local function init_union_shop_reward_page_terminal()
		-- 隐藏界面
        local union_shop_reward_page_hide_event_terminal = {
            _name = "union_shop_reward_page_hide_event",
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
        local union_shop_reward_page_show_event_terminal = {
            _name = "union_shop_reward_page_show_event",
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
		local union_shop_reward_page_refresh_list_terminal = {
            _name = "union_shop_reward_page_refresh_list",
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

		state_machine.add(union_shop_reward_page_hide_event_terminal)
		state_machine.add(union_shop_reward_page_show_event_terminal)
		state_machine.add(union_shop_reward_page_refresh_list_terminal)
        state_machine.init()
    end
    
    -- call func init union shop reward  page  machine.
    init_union_shop_reward_page_terminal()

end

function UnionShopRewardPage:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionShopRewardPage:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end
	
function UnionShopRewardPage:initListView()
	local root = self.roots[1]
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_31")	
	if #listView:getItems() > 0 then
		listView:removeAllItems()
	end
	listView:setVisible(true)
	UnionShopRewardPage.asyncIndex = 1
	UnionShopRewardPage.cacheListView = listView
	self.currentListView = UnionShopRewardPage.cacheListView
	self.currentInnerContainer = self.currentListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
	local data = dms.searchs(dms["union_shop_mould"], union_shop_mould.shop_page, 2)
	local dataCount = table.getn(data)
	if dataCount ~= 0 and data ~= nil and data[1] ~= nil and data[1][1] ~= nil then
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			app.load("client.cells.utils.multiple_list_view_cell")
	        local preMultipleCell = nil
	        local MylistViewCell = nil  			
			for i,v in pairs(data) do
				if UnionShopRewardPage.cacheListView == nil or v ==nil then
					return
				end
				local index = dms.atoi(v, union_shop_mould.id)
				local cell = UnionShopPropFashionListCell:createCell()
				cell:init(v,UnionShopRewardPage.asyncIndex, 2, 1)

				if MylistViewCell == nil then
	                MylistViewCell = MultipleListViewCell:createCell()
	                MylistViewCell:init(UnionShopRewardPage.cacheListView,UnionShopPropFashionListCell.__size)
	                listView:addChild(MylistViewCell)
	                MylistViewCell.prev = preMultipleCell
	                if preMultipleCell ~= nil then
	                    preMultipleCell.next = MylistViewCell
	                end
	            end
	            MylistViewCell:addNode(cell)
	            if MylistViewCell.child2 ~= nil then
	                preMultipleCell = MylistViewCell
	                MylistViewCell = nil
	            end  

				UnionShopRewardPage.asyncIndex = UnionShopRewardPage.asyncIndex + 1
			end		
			UnionShopRewardPage.cacheListView:requestRefreshView()	
		else
			for i,v in pairs(data) do
				if UnionShopRewardPage.cacheListView == nil or v ==nil then
					return
				end
				local index = dms.atoi(v, union_shop_mould.id)
				local cell = UnionShopPropFashionListCell:createCell()
				cell:init(v,UnionShopRewardPage.asyncIndex, 2, 1)
				UnionShopRewardPage.cacheListView:addChild(cell)
				UnionShopRewardPage.cacheListView:requestRefreshView()
				UnionShopRewardPage.asyncIndex = UnionShopRewardPage.asyncIndex + 1
			end
		end
	end
end

function UnionShopRewardPage:updateDraw()
	-- local function responseUnionShopInitCallBack(response)
	-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
	-- 		if response.node.initListView ~= nil then
	-- 			response.node:initListView()
	-- 		end
	-- 	end

	-- end

	-- NetworkManager:register(protocol_command.union_shop_init.code, nil, nil, nil, self, responseUnionShopInitCallBack, false, nil)
	self:initListView()

end
function UnionShopRewardPage:onUpdate(dt)
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

function UnionShopRewardPage:onInit()
	local csbUnionShopRewardPage = csb.createNode("legion/legion_shop_listview.csb")
	local root = csbUnionShopRewardPage:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbUnionShopRewardPage)
	self:updateDraw()
end

function UnionShopRewardPage:onEnterTransitionFinish()

end

function UnionShopRewardPage:init()
	self:onInit()
	return self
end

function UnionShopRewardPage:onExit()
	state_machine.remove("union_shop_reward_page_hide_event")
	state_machine.remove("union_shop_reward_page_show_event")
	state_machine.remove("union_shop_reward_page_refresh_list")
end