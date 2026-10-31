--------------------------------------------------------------------------------------------------------------
--  说明：军团商店时装界面
--------------------------------------------------------------------------------------------------------------
UnionShopFashionPage = class("UnionShopFashionPageClass", Window)


--打开界面
local union_shop_fashion_page_open_terminal = {
    _name = "union_shop_fashion_page_open",
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

--关闭界面
local union_shop_fashion_page_close_terminal = {
    _name = "union_shop_fashion_page_close",
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
state_machine.add(union_shop_fashion_page_open_terminal)
state_machine.add(union_shop_fashion_page_close_terminal)
state_machine.init()
function UnionShopFashionPage:ctor()
	self.super:ctor()
	self.roots = {}
    self.celltable = {}
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.cells.union.union_shop_prop_fashion_list_cell")
    else
    	app.load("client.cells.union.union_shop_prop_fashion_list_cell")
    end
	self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = nil
	 -- Initialize union shop fashion page machine.
    local function init_union_shop_fashion_page_terminal()
		
		-- 隐藏界面
        local union_shop_fashion_page_hide_event_terminal = {
            _name = "union_shop_fashion_page_hide_event",
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
        local union_shop_fashion_page_show_event_terminal = {
            _name = "union_shop_fashion_page_show_event",
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
		local union_shop_fashion_page_refresh_list_terminal = {
            _name = "union_shop_fashion_page_refresh_list",
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
		
		state_machine.add(union_shop_fashion_page_hide_event_terminal)
		state_machine.add(union_shop_fashion_page_show_event_terminal)
		state_machine.add(union_shop_fashion_page_refresh_list_terminal)
        state_machine.init()
    end
    
    -- call func init union shop fashion page  machine.
    init_union_shop_fashion_page_terminal()

end

function UnionShopFashionPage:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionShopFashionPage:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionShopFashionPage:updateDraw()
    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_31")  
    if #listView:getItems() > 0 then
        listView:removeAllItems()
    end
    listView:setVisible(true)
    UnionShopFashionPage.asyncIndex = 1
    UnionShopFashionPage.cacheListView = listView
    self.currentListView = UnionShopFashionPage.cacheListView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    local data = dms.searchs(dms["union_shop_mould"], union_shop_mould.shop_page, 1)
    self.celltable = {}
    if data ~= nil and data[1] ~= nil and data[1][1] ~= nil then
        for i,v in pairs(data) do
            if UnionShopFashionPage.cacheListView == nil or v ==nil then
                return
            end
            local index = dms.atoi(v, union_shop_mould.id)
            local cell = UnionShopPropFashionListCell:createCell()
            cell:init(v,UnionShopFashionPage.asyncIndex, 1, 1)
            -- UnionShopFashionPage.cacheListView:addChild(cell)
            -- UnionShopFashionPage.cacheListView:requestRefreshView()
            table.insert(self.celltable, cell)
            UnionShopFashionPage.asyncIndex = UnionShopFashionPage.asyncIndex + 1
        end
    end
    local sortFunc = function( cell1, cell2 )
        local mould_id1 = dms.int(dms["union_shop_mould"], cell1.mouldid, union_shop_mould.mould_id)
        local grow_level1 = dms.int(dms["equipment_mould"], mould_id1, equipment_mould.grow_level)
        local id1 = dms.int(dms["equipment_mould"], mould_id1, equipment_mould.id)

        local mould_id2 = dms.int(dms["union_shop_mould"], cell2.mouldid, union_shop_mould.mould_id)
        local grow_level2 = dms.int(dms["equipment_mould"], mould_id2, equipment_mould.grow_level)
        local id2 = dms.int(dms["equipment_mould"], mould_id2, equipment_mould.id)

        return grow_level1 > grow_level2 or (grow_level1 == grow_level2 and id1 < id2)
    end
    table.sort(self.celltable , sortFunc)

    if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        app.load("client.cells.utils.multiple_list_view_cell")
        local preMultipleCell = nil
        local MylistViewCell = nil        
        for i ,v in pairs(self.celltable) do
            if MylistViewCell == nil then
                MylistViewCell = MultipleListViewCell:createCell()
                MylistViewCell:init(UnionShopFashionPage.cacheListView,UnionShopPropFashionListCell.__size)
                listView:addChild(MylistViewCell)
                MylistViewCell.prev = preMultipleCell
                if preMultipleCell ~= nil then
                    preMultipleCell.next = MylistViewCell
                end
            end
            MylistViewCell:addNode(v)
            if MylistViewCell.child2 ~= nil then
                preMultipleCell = MylistViewCell
                MylistViewCell = nil
            end  
        end
    else
        for i ,v in pairs(self.celltable) do
            if v ~= nil then
                UnionShopFashionPage.cacheListView:addChild(v)
            end
        end
    end
    UnionShopFashionPage.cacheListView:requestRefreshView()
end

function UnionShopFashionPage:onUpdate(dt)
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

function UnionShopFashionPage:initData()
    if _ED.union.union_shop_info == nil or _ED.union.union_shop_info == "" then
        local function responseUnionShopInitCallBack(response)
            if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                if response.node.initListView ~= nil then
                    response.node:updateDraw()
                end
            end
        end
        NetworkManager:register(protocol_command.union_shop_init.code, nil, nil, nil, self, responseUnionShopInitCallBack, false, nil)
    else
        self:updateDraw()
    end
end

function UnionShopFashionPage:onInit()
	local csbUnionShopFashionPage = csb.createNode("legion/legion_shop_listview.csb")
    local root = csbUnionShopFashionPage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionShopFashionPage)
    self:initData()
end

function UnionShopFashionPage:onEnterTransitionFinish()

end

function UnionShopFashionPage:init()
	self:onInit()
	return self
end

function UnionShopFashionPage:onExit()
	state_machine.remove("union_shop_fashion_page_hide_event")
	state_machine.remove("union_shop_fashion_page_show_event")
	state_machine.remove("union_shop_fashion_page_refresh_list")
end