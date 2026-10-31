-- ----------------------------------------------------------------------------------------------------
-- 说明：竞技场战报
-------------------------------------------------------------------------------------------------------

ArenaWarReportPanel = class("ArenaWarReportPanelClass", Window)

--打开界面
local sm_arena_war_report_panel_open_terminal = {
	_name = "sm_arena_war_report_panel_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("ArenaWarReportPanelClass") == nil then
			fwin:open(ArenaWarReportPanel:new(),_view)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_arena_war_report_panel_open_terminal)
state_machine.init()
    
function ArenaWarReportPanel:ctor()
    self.super:ctor()
    self.roots = {}
	
	--缓存listview
	self.cacheListView = nil
	self.cacheScrollView = nil

	self.currentScrollView = nil
	self.currentScrollViewInnerContainer = nil
	self.currentScrollViewInnerContainerPosY  = 0
	
	app.load("client.l_digital.cells.arena.arena_war_report_seat_cell")
	
    -- Initialize ArenaWarReportPanel page state machine.
    local function init_arena_ranking_panel_terminal()
	
		--关闭面板
		local arena_war_report_panel_close_terminal = {
            _name = "arena_war_report_panel_close",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				-- fwin:open(Campaign:new(), fwin._view)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		
		state_machine.add(arena_war_report_panel_close_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_arena_ranking_panel_terminal()
end

function ArenaWarReportPanel:pushReport()
	if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[11] ~= nil then
		local ids_str = ""
		for k, v in pairs(_ED.city_resource_battle_report[11]) do
			if k == 1 then
				ids_str = ids_str..v.time
			else
				ids_str = ids_str..","..v.time
			end
		end
		cc.UserDefault:getInstance():setStringForKey(getKey("push_sm_war_report_ids"), ids_str)
        cc.UserDefault:getInstance():flush()

        state_machine.excute("notification_center_update", 0, "push_notification_center_sm_arena_all")
        state_machine.excute("notification_center_update", 0, "push_notification_center_sm_arena_page_tip")
        state_machine.excute("notification_center_update", 0, "push_notification_center_sm_war_report_panel")
	end
end

function ArenaWarReportPanel:initDraw()
	
	--添加列表
	local index = 0

	self.cacheListView:removeAllItems()
	if _ED.city_resource_battle_report ~= nil and _ED.city_resource_battle_report[11] ~= nil then
		table.sort(_ED.city_resource_battle_report[11], function(c1, c2)
			if c1 ~= nil 
	            and c2 ~= nil 
	            and zstring.tonumber(c1.time) > zstring.tonumber(c2.time) then
				return true
			end
			return false
		end)
		if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
			self:createScollView(_ED.city_resource_battle_report[11])
		else
			for i, v in pairs(_ED.city_resource_battle_report[11]) do
				index = index + 1
				local arsc = ArenaWarReportSeatCell:createCell()
				arsc:init(v, index)
				self.cacheListView:addChild(arsc)
			end
		end
		
	end
	self.cacheListView:requestRefreshView()
	
	self.currentInnerContainer = self.cacheListView:getInnerContainer()
	self.currentInnerContainerPosY = self.currentInnerContainer:getPositionY()
end

function ArenaWarReportPanel:createScollView(infos)
	local m_ScrollView = self.cacheScrollView
	m_ScrollView:removeAllChildren(true)
    local panel = m_ScrollView:getInnerContainer()
    panel:setContentSize(m_ScrollView:getContentSize())
    panel:setPosition(cc.p(0,0))
    panel:removeAllChildren(true)
    local sSize = panel:getContentSize()
    local sHeight = sSize.height
    local sWidth = sSize.width
    local controlSize = m_ScrollView:getInnerContainerSize()
    local nextY = sSize.height
    local nextX = sSize.width
    local tHeight = 0
    local cellHeight = 0
    local tWidth = 0
    local wPosition = sWidth/3
    local Hlindex = 0
    local number = #infos
    local m_number = math.ceil(number/3)
    cellHeight = m_number*265
    sHeight = math.max(sHeight, cellHeight)
    panel:setContentSize(m_ScrollView:getContentSize().width, sHeight)
    local first = nil
    local index = 1
    local cell_height = 0
    for j, v in pairs(infos) do
        local cell = ArenaWarReportSeatCell:createCell()
		cell:init(v, j)	
        panel:addChild(cell)
        cell_height = cell:getContentSize().height
        tWidth = tWidth + wPosition
        if (index-1)%3 ==0 then
            Hlindex = Hlindex+1
            tWidth = 0
            tHeight = sHeight - cell_height*Hlindex  
        end
        if index <= 3 then
            tHeight = sHeight - cell_height
        end
        cell:setPosition(cc.p(tWidth,tHeight))
        index = index + 1
    end

    self.currentScrollView = m_ScrollView
    self.currentScrollViewInnerContainer = self.currentScrollView:getInnerContainer()
    self.currentScrollViewInnerContainerPosY = self.currentScrollViewInnerContainer:getPositionY()

    m_ScrollView:jumpToTop()
end

function ArenaWarReportPanel:onUpdate(dt)
	if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		if self.currentScrollView ~= nil and self.currentScrollViewInnerContainer ~= nil then
	        local size = self.currentScrollView:getContentSize()
	        local posY = self.currentScrollViewInnerContainer:getPositionY()
	        if self.currentScrollViewInnerContainerPosY == posY then
	            return
	        end
	        self.currentScrollViewInnerContainerPosY = posY
	        local items = self.currentScrollView:getChildren()
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
	else
		if self.cacheListView ~= nil and self.currentInnerContainer ~= nil then
			local size = self.cacheListView:getContentSize()
			local posY = self.currentInnerContainer:getPositionY()
			if self.currentInnerContainerPosY == posY then
				return
			end
			self.currentInnerContainerPosY = posY
			local items = self.cacheListView:getItems()
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
end


function ArenaWarReportPanel:reviseListviewSize(listview)
	if #listview:getItems() <= 0 then return end
	local listviewContentSize = listview:getContentSize()
	local tmpContentSize = listview:getItem(0):getContentSize()
	tmpContentSize.height = tmpContentSize.height * #listview:getItems()
	listview:getInnerContainer():setContentSize(tmpContentSize)
	listviewContentSize.width = tmpContentSize.width
	listview:setContentSize(listviewContentSize)
end

--请求竞技场战报数据
function ArenaWarReportPanel:requestInitDatas()
	local function responseReportCallback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			if response.node == nil or response.node.roots == nil then
				return
			end
			response.node:initDraw()
			response.node:pushReport()
		end
	end
	responseReportCallback({RESPONSE_SUCCESS = true, PROTOCOL_STATUS = 0, node = self})
	-- protocol_command.battlefield_report_get.param_list = 11
	-- NetworkManager:register(protocol_command.battlefield_report_get.code, nil, nil, nil, self, responseReportCallback, false, nil)
end

function ArenaWarReportPanel:onEnterTransitionFinish()
	
    local csbArenaRankPanel = csb.createNode("campaign/ArenaStorage/ArenaStorage_report.csb")
	local action = csb.createTimeline("campaign/ArenaStorage/ArenaStorage_report.csb")
	local root = csbArenaRankPanel:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbArenaRankPanel)
	
	csbArenaRankPanel:runAction(action)
	action:gotoFrameAndPlay(0, action:getDuration(), false)
	
	--缓存listview
	self.cacheListView = ccui.Helper:seekWidgetByName(root, "ListView_zhanbao")

	if __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece then
		self.cacheScrollView = ccui.Helper:seekWidgetByName(root, "ScrollView_zhanbao")
	end

	
	--添加返回点击事件
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_back"), 	nil, 
	{
		terminal_name = "arena_war_report_panel_close", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 2)
	
	self:requestInitDatas()

	app.load("client.player.UserInformationHeroStorage")
    local userInformationHeroStorage = UserInformationHeroStorage:new()
    userInformationHeroStorage._rootWindows = self
    fwin:open(userInformationHeroStorage,fwin._view)
end

--关闭所有按钮的高亮显示
function ArenaWarReportPanel:closeHighlighted()
end

function ArenaWarReportPanel:onExit()
	ArenaWarReportPanel.asyncIndex = 1
	ArenaWarReportPanel.cacheListView = nil

	state_machine.remove("arena_war_report_panel_close")
end
