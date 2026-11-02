--------------------------------------------------------------------------------------------------------------
--  说明：军团商店限时界面
--------------------------------------------------------------------------------------------------------------
UnionShopTimeLimitPage = class("UnionShopTimeLimitPageClass", Window)
--打开界面
local union_shop_time_limit_page_open_terminal = {
    _name = "union_shop_time_limit_page_open",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if params ~= nil then
			local UnionShopTimeLimitPageWindow = fwin:find("UnionShopClass")
			if UnionShopTimeLimitPageWindow ~= nil and UnionShopTimeLimitPageWindow:isVisible() == true then
				return true
			end
			fwin:open(UnionShopTimeLimitPage:new():init(params),fwin._view)	
		end	
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

--关闭界面
local union_shop_time_limit_page_close_terminal = {
    _name = "union_shop_time_limit_page_close",
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
state_machine.add(union_shop_time_limit_page_open_terminal)
state_machine.add(union_shop_time_limit_page_close_terminal)
state_machine.init()
function UnionShopTimeLimitPage:ctor()
	self.super:ctor()
	self.roots = {}
	self.pram = nil
	self.load = false
    self.needSend = false
    self.currentListView = nil
    self.currentInnerContainer = nil
    self.currentInnerContainerPosY = 0
    if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        app.load("client.l_digital.cells.union.union_shop_time_limit_list_cell")
    else
    	app.load("client.cells.union.union_shop_time_limit_list_cell")
    end
	 -- Initialize union shop time limit page machine.
    local function init_union_shop_time_limit_page_terminal()
		
		-- 隐藏界面
        local union_shop_time_limit_page_hide_event_terminal = {
            _name = "union_shop_time_limit_page_hide_event",
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
        local union_shop_time_limit_page_show_event_terminal = {
            _name = "union_shop_time_limit_page_show_event",
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
		local union_shop_time_limit_page_refresh_list_terminal = {
            _name = "union_shop_time_limit_page_refresh_list",
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
	
		state_machine.add(union_shop_time_limit_page_hide_event_terminal)
		state_machine.add(union_shop_time_limit_page_show_event_terminal)
		state_machine.add(union_shop_time_limit_page_refresh_list_terminal)
        state_machine.init()
    end
    
    -- call func init union shop time limit  page  machine.
    init_union_shop_time_limit_page_terminal()

end

function UnionShopTimeLimitPage:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionShopTimeLimitPage:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionShopTimeLimitPage:initListView()

    local root = self.roots[1]
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_38")  
    if #listView:getItems() > 0 then
        listView:removeAllItems() 
    end
    listView:setVisible(true)
    UnionShopTimeLimitPage.asyncIndex = 1
    UnionShopTimeLimitPage.cacheListView = listView
    self.currentListView = UnionShopTimeLimitPage.cacheListView
    self.currentInnerContainer = self.currentListView:getInnerContainer()
    self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
    if _ED.union.union_shop_info.treasure == nil or _ED.union.union_shop_info.treasure == "" or _ED.union.union_shop_info.treasure.goods_count == "" then
        return
    end
    if __lua_project_id == __lua_project_gragon_tiger_gate
        or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
        or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
        then
        app.load("client.cells.utils.multiple_list_view_cell")
        local preMultipleCell = nil
        local MylistViewCell = nil          
        for i=1, _ED.union.union_shop_info.treasure.goods_count do
            if UnionShopTimeLimitPage.cacheListView == nil  then
                return
            end
            local cell = UnionShopTimeLimitListCell:createCell()
            cell:init(_ED.union.union_shop_info.treasure.goods_info[i],UnionShopTimeLimitPage.asyncIndex, 2)
            if MylistViewCell == nil then
                MylistViewCell = MultipleListViewCell:createCell()
                MylistViewCell:init(UnionShopTimeLimitPage.cacheListView,UnionShopTimeLimitListCell.__size)
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
            UnionShopTimeLimitPage.asyncIndex = UnionShopTimeLimitPage.asyncIndex + 1
        end 
        UnionShopTimeLimitPage.cacheListView:requestRefreshView()       
    else
        for i=1, _ED.union.union_shop_info.treasure.goods_count do
    		if UnionShopTimeLimitPage.cacheListView == nil  then
    			return
    		end
            local cell = UnionShopTimeLimitListCell:createCell()
            cell:init(_ED.union.union_shop_info.treasure.goods_info[i],UnionShopTimeLimitPage.asyncIndex, 2)
            UnionShopTimeLimitPage.cacheListView:addChild(cell)
            UnionShopTimeLimitPage.cacheListView:requestRefreshView()
            UnionShopTimeLimitPage.asyncIndex = UnionShopTimeLimitPage.asyncIndex + 1
        end
    end
end

function UnionShopTimeLimitPage:updateDraw()
	self.load = true
    local function responseUnionShopInitCallBack(response)
        if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
            if response.node ~= nil and response.node.initListView ~= nil then
                response.node:initListView()
				response.node.load = false
            end
        end

    end
	if  self.needSend == true then
         NetworkManager:register(protocol_command.union_shop_init.code, nil, nil, nil, self, responseUnionShopInitCallBack, false, nil)
    else
        self:initListView()
        self.load = false
    end 

end
function UnionShopTimeLimitPage:formatTimeString(_time)	--系统时间转换
	local timeString = ""
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)/3600)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor((tonumber(_time)%3600)/60)) .. ":"
	timeString = timeString .. string.format("%02d", math.floor(tonumber(_time)%60))
	return timeString
end
function UnionShopTimeLimitPage:onUpdate(dt)

	local root = self.roots[1]

	if _ED.union.union_shop_info.treasure.refresh_time ~= nil and _ED.union.union_shop_info.treasure.refresh_time ~= "" and _ED.union.union_shop_info.treasure.os_time ~= nil then
		local times = os.time()- tonumber(_ED.union.union_shop_info.treasure.os_time)
		local remainTime = 0
		local _refreshTime = ccui.Helper:seekWidgetByName(root, "Text_57_0")
		if _refreshTime == nil then
			return
		end
		local ButtonWelcome = ccui.Helper:seekWidgetByName(root, "Button_3")
		
		if times > (tonumber(_ED.union.union_shop_info.treasure.refresh_time/1000) + 1)then 
			if self.load == false then
                 self.needSend = true
				self:updateDraw()
				_refreshTime:setVisible(false)
				_refreshTime:setString(self:formatTimeString(remainTime))
			end
		else 
			remainTime =_ED.union.union_shop_info.treasure.refresh_time/1000-times	--剩余刷新的时间
			if remainTime > 0 then
				_refreshTime:setString(self:formatTimeString(remainTime))
				_refreshTime:setVisible(true)
			end	

		end
	
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

function UnionShopTimeLimitPage:onInit()
    local csbUnionShopTimeLimitPage = csb.createNode("legion/legion_shop_listview_xs.csb")
    local root = csbUnionShopTimeLimitPage:getChildByName("root")
    table.insert(self.roots, root)
    self:addChild(csbUnionShopTimeLimitPage)
	self:updateDraw()
end

function UnionShopTimeLimitPage:onEnterTransitionFinish()

end

function UnionShopTimeLimitPage:init()
	self.load = false
	self:onInit()
	return self
end

function UnionShopTimeLimitPage:onExit()
	state_machine.remove("union_shop_time_limit_page_hide_event")
	state_machine.remove("union_shop_time_limit_page_show_event")
	state_machine.remove("union_shop_time_limit_page_refresh_list")
end