-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛好友任务
-------------------------------------------------------------------------------------------------------

FileIslandHolyThing = class("FileIslandHolyThingClass", Window)

local fileIsland_window_holy_thing_terminal = {
    _name = "fileIsland_window_holy_thing_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
  --   	local function responseFileIslandHolyThingInitCallback(response)
		-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- 		local FileIslandHolyThingWindow = fwin:find("FileIslandHolyThingClass")
		--     	if FileIslandHolyThingWindow == nil then
		--     		fwin:open(FileIslandHolyThing:new():init(params), fwin._view)
		--     	end
		-- 	end
		-- end
		-- protocol_command.cross_mine_user_shop_buy.param_list = -1 .. "\r\n" .. 1
		-- NetworkManager:register(protocol_command.cross_mine_user_shop_buy.code, nil, nil, nil, nil, responseFileIslandHolyThingInitCallback, false, nil)

		local FileIslandHolyThingWindow = fwin:find("FileIslandHolyThingClass")
    	if FileIslandHolyThingWindow == nil then
    		fwin:open(FileIslandHolyThing:new():init(params), fwin._view)
    	end

    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_window_holy_thing_terminal)
state_machine.init()

function FileIslandHolyThing:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.l_digital.cells.campaign.fileIsland.fileIsland_holy_cell_1")
	app.load("client.l_digital.cells.campaign.fileIsland.fileIsland_holy_cell_2")
	app.load("client.l_digital.cells.campaign.fileIsland.fileIsland_holy_cell_3")
	app.load("client.l_digital.campaign.fileIsland.FileIslandHolyCellInfo")

	local function init_fileIsland_friends_terminal()
		-- 关闭
		local fileIsland_holy_thing_close_terminal = {
            _name = "fileIsland_holy_thing_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				fwin:close(fwin:find("FileIslandHolyThingClass"))
				-- fwin:close(fwin:find("FileIslandShopBuyTopClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击左侧列表，刷新右侧列表
		local fileIsland_holy_thing_refreshRightListView_terminal = {
            _name = "fileIsland_holy_thing_refreshRightListView",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:refreshRightListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 点击升级按钮升级
		local fileIsland_holy_thing_Button_explore_holy_up_terminal = {
            _name = "fileIsland_holy_thing_Button_explore_holy_up",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:refreshRightListView()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_holy_thing_close_terminal)
        state_machine.add(fileIsland_holy_thing_refreshRightListView_terminal)
        state_machine.add(fileIsland_holy_thing_Button_explore_holy_up_terminal)

		state_machine.init()
	end

	init_fileIsland_friends_terminal()
end

function FileIslandHolyThing:onUpdateDraw()
	local root = self.roots[1]
	
	local data = {
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
		{nick = 2},
		{nick = 1},
		{nick = 3},
		{nick = 4},
		{nick = 5},
		{nick = 9},
		{nick = 0},
	}

	-- 左侧列表
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:removeAllItems()
	listView:jumpToTop()

	for i = 1, #data do
		local cellData = data[i]
		local cell = FileIslandHolyCell_1:createCell()
		cell:init(cellData, i, self)
		listView:addChild(cell)
	end

	listView:requestRefreshView()
	
	self.listView = listView
	self.list_view_posY = listView:getInnerContainer():getPositionY()

	-- 刷新右侧圣物属性列表
	self:refreshRightListView()

end

-- 刷新右下圣物状态信息
function FileIslandHolyThing:refreshHolyInfo()
	self.Panel_regular_up_lock:setVisible(false)
	self.Text_regular_up_top:setVisible(false)
	self.Text_regular_lv_t:setVisible(false)
	self.Text_regular_lv_n:setVisible(false)

	local holyState = 1
	-- 已解锁，已激活，可升级
	if holyState == 1 then
		self.Text_regular_lv_t:setVisible(true)
		self.Text_regular_lv_n:setVisible(true)

	-- 已解锁，未激活，可激活
	elseif holyState == 2 then

	-- 未解锁
	elseif holyState == 3 then
		self.Panel_regular_up_lock:setVisible(true)

	-- 满级
	elseif holyState == 4 then
		self.Text_regular_up_top:setVisible(true)
		self.Text_regular_lv_t:setVisible(true)
		self.Text_regular_lv_n:setVisible(true)
	end


end

-- 刷新右侧圣物属性列表
function FileIslandHolyThing:refreshRightListView()

	local data2 = {
		{idx = 1},
		{idx = 2},
		{idx = 3},
		{idx = 4},
		{idx = 5},
		{idx = 6},
		{idx = 7},
		{idx = 8},
		{idx = 9},
		{idx = 10},
		{idx = 11},
		{idx = 12},
		{idx = 13},
		{idx = 14},
		{idx = 15},
		{idx = 16},
		{idx = 17},
		{idx = 18},
		{idx = 19},
		{idx = 20},
		{idx = 21},
		{idx = 22},
		{idx = 23},
		{idx = 24},
		{idx = 25},
		{idx = 26},
		{idx = 27},
		{idx = 28},
		{idx = 29},
		{idx = 30},
		{idx = 31},
		{idx = 32},
		{idx = 33},
		{idx = 34},
		{idx = 35},
		{idx = 36},
		{idx = 37},
		{idx = 38},
		{idx = 39},
		{idx = 40},
		{idx = 41},
		{idx = 42},
		{idx = 43},
		{idx = 44},
		{idx = 45},
		{idx = 46},
		{idx = 47},
		{idx = 48},
		{idx = 49},
		{idx = 50},
		{idx = 51},
		{idx = 52},
		{idx = 53},
		{idx = 54},
		{idx = 55},
		{idx = 56},
		{idx = 57},
	}

	local root = self.roots[1]

	-- 右侧列表
	local listView2 = ccui.Helper:seekWidgetByName(root, "ListView_holy")
	listView2:removeAllItems()
	listView2:jumpToTop()

	local cellCount = math.ceil(#data2 / 4)

	for i = 1, cellCount do
		local cell = FileIslandHolyCell_2:createCell()
		local cellData = {}
		for j = 1, 4 do
			local single = data2[j + 4 * (i - 1)]
			if single then
				single.maxNum = #data2
				table.insert(cellData, single)
			end
		end
		cell:init(cellData, i, self)
		listView2:addChild(cell)
	end

	listView2:requestRefreshView()
	
	self.listView2 = listView2
	self.list_view_2_posY = listView2:getInnerContainer():getPositionY()
end

-- 没帧刷新
function FileIslandHolyThing:onUpdateLeftListView()
	if self.listView ~= nil then
	    local size = self.listView:getContentSize()
	    local posY = self.listView:getInnerContainer():getPositionY()
	    if self.list_view_posY == posY then
	        return
	    end

	    self.list_view_posY = posY
	    local items = self.listView:getItems()

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

-- 每帧刷新
function FileIslandHolyThing:onUpdateRightListView()
	if self.listView2 ~= nil then
	    local size = self.listView2:getContentSize()
	    local posY = self.listView2:getInnerContainer():getPositionY()
	    if self.list_view_2_posY == posY then
	        return
	    end

	    self.list_view_2_posY = posY
	    local items = self.listView2:getItems()

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

function FileIslandHolyThing:onUpdate(dt)
	self:onUpdateLeftListView()
	self:onUpdateRightListView()
end

function FileIslandHolyThing:onInit()
	local csb_explore_friend_task = csb.createNode("campaign/explore/explore_holy.csb")
	local root = csb_explore_friend_task:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csb_explore_friend_task)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_maoxian_back"), nil, 
	{
		terminal_name = "fileIsland_holy_thing_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

    -- 圣物名
	self.Text_103 = ccui.Helper:seekWidgetByName(root, "Text_103")
	-- 圣物图片
	self.Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	-- 可升级状态panel
	self.Panel_regular_up = ccui.Helper:seekWidgetByName(root, "Panel_regular_up")
	-- 升级消耗探索币
	self.Text_regular_tsb_n = ccui.Helper:seekWidgetByName(root, "Text_regular_tsb_n")
	-- 升级消耗金币
	self.Text_regular_jb_n = ccui.Helper:seekWidgetByName(root, "Text_regular_jb_n")
	-- 升级按钮
	local Button_explore_holy_up = ccui.Helper:seekWidgetByName(root, "Button_explore_holy_up")
	fwin:addTouchEventListener(Button_explore_holy_up, nil, 
	{
		terminal_name = "fileIsland_holy_thing_Button_explore_holy_up", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

	-- 已满级
	self.Text_regular_up_top = ccui.Helper:seekWidgetByName(root, "Text_regular_up_top")
	-- 等级文字
	self.Text_regular_lv_t = ccui.Helper:seekWidgetByName(root, "Text_regular_lv_t")
	-- 等级数
	self.Text_regular_lv_n = ccui.Helper:seekWidgetByName(root, "Text_regular_lv_n")
	-- 未解锁panel
	self.Panel_regular_up_lock = ccui.Helper:seekWidgetByName(root, "Panel_regular_up_lock")
	-- 解锁条件1
	self.Text_regular_lv_lock_condition_t_1 = ccui.Helper:seekWidgetByName(root, "Text_regular_lv_lock_condition_t_1")
	-- 解锁条件1内容
	self.Text_regular_lv_lock_condition_n_1 = ccui.Helper:seekWidgetByName(root, "Text_regular_lv_lock_condition_n_1")
	-- 解锁条件2
	self.Text_regular_lv_lock_condition_t_2 = ccui.Helper:seekWidgetByName(root, "Text_regular_lv_lock_condition_t_2")
	-- 解锁条件2内容
	self.Text_regular_lv_lock_condition_n_2 = ccui.Helper:seekWidgetByName(root, "Text_regular_lv_lock_condition_n_2")
	
	self.selectIndex = 1
	self:onUpdateDraw()

    -- 顶部用户信息
	app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop") 					
	local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function FileIslandHolyThing:init(params)
	self:onInit()
	return self
end

function FileIslandHolyThing:onExit()
	state_machine.remove("fileIsland_holy_thing_close")
	state_machine.remove("fileIsland_holy_thing_refreshRightListView")
	state_machine.remove("fileIsland_holy_thing_Button_explore_holy_up")

end

