-- ----------------------------------------------------------------------------------------------------
-- 说明：文件岛好友任务
-------------------------------------------------------------------------------------------------------

FileIslandFriends = class("FileIslandFriendsClass", Window)

local fileIsland_window_friends_open_terminal = {
    _name = "fileIsland_window_friends_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
  --   	local function responseFileIslandFriendsInitCallback(response)
		-- 	if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
		-- 		local FileIslandFriendsWindow = fwin:find("FileIslandFriendsClass")
		--     	if FileIslandFriendsWindow == nil then
		--     		fwin:open(FileIslandFriends:new():init(params), fwin._view)
		--     	end
		-- 	end
		-- end
		-- protocol_command.fileIslandTaskInfo.param_list = ""
		-- NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, responseFileIslandFriendsInitCallback, false, nil)

		local FileIslandFriendsWindow = fwin:find("FileIslandFriendsClass")
    	if FileIslandFriendsWindow == nil then
    		fwin:open(FileIslandFriends:new():init(params), fwin._view)
    	end

    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(fileIsland_window_friends_open_terminal)
state_machine.init()

function FileIslandFriends:ctor()
    self.super:ctor()
	self.roots = {}

	app.load("client.l_digital.cells.campaign.fileIsland.fileIsland_friend_cell")
	app.load("client.l_digital.campaign.fileIsland.FileIslandFriendCellInfo")

	local function init_fileIsland_friends_terminal()
		-- 关闭
		local fileIsland_friends_close_terminal = {
            _name = "fileIsland_friends_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	state_machine.excute("fileIsland_window_updateDraw_friend_redPoint", 0, "")
				fwin:close(fwin:find("FileIslandFriendsClass"))
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 左右箭头
        local fileIsland_friends_scrollView_roll_terminal = {
            _name = "fileIsland_friends_scrollView_roll",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local currType = params._datas._type
            	local container = instance.listView:getInnerContainer()
            	local scrollViewX = 0
            	if currType == 1 then
            		scrollViewX = container:getPositionX()
            		scrollViewX = math.max(0 , scrollViewX)
            	elseif currType == 2 then
            		scrollViewX = container:getPositionX()
            		scrollViewX = math.min(scrollViewX , instance.listView:getContentSize().width - container:getContentSize().width)
            	end

            	container:setPositionX(scrollViewX)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 切换左侧任务类型按钮
        local fileIsland_friends_left_btn_change_terminal = {
            _name = "fileIsland_friends_left_btn_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local currType = params._datas.btnType

            	instance.button_my_task:setHighlighted(false)
				instance.button_cooperation_task:setHighlighted(false)

				if currType == 1 then
					instance.button_my_task:setHighlighted(true)
				elseif currType == 2 then
					instance.button_cooperation_task:setHighlighted(true)
				end
            	
            	if instance.taskType == currType then
            		return
            	end

            	local function responseFileIslandFriendsInitCallback(response)
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						instance:initData()
						instance:onUpdateDraw(currType)
					end
				end
				protocol_command.fileIslandTaskInfo.param_list = ""
				NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, responseFileIslandFriendsInitCallback, false, nil)

                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 重新请求和刷新数据
        local fileIsland_friends_request_and_refresh_list_terminal = {
            _name = "fileIsland_friends_request_and_refresh_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:requestAndRefreshTaskInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 刷新数据
        local fileIsland_friends_refresh_list_terminal = {
            _name = "fileIsland_friends_refresh_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance:refreshTaskInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(fileIsland_friends_close_terminal)
        state_machine.add(fileIsland_friends_scrollView_roll_terminal)
        state_machine.add(fileIsland_friends_left_btn_change_terminal)
        state_machine.add(fileIsland_friends_request_and_refresh_list_terminal)
        state_machine.add(fileIsland_friends_refresh_list_terminal)

		state_machine.init()
	end

	init_fileIsland_friends_terminal()
end

function FileIslandFriends:onUpdateDraw(taskType)
	local root = self.roots[1]
	self.taskType = taskType

	-- 列表
	local listView = ccui.Helper:seekWidgetByName(root, "ListView_1")
	listView:stopAllActions()
	listView:setDirection(2)
	listView:removeAllItems()
	listView:jumpToLeft()

	local data
	if taskType == 1 then
		data = self.taskInfo1
	elseif taskType == 2 then
		data = self.taskInfo2
	end

	for i = 1, #data do
		local cellData = data[i]
		local cell = FileIslandFriendCell:createCell()
		cell:init(cellData, i)
		listView:addChild(cell)

		if taskType == 1 then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_fileIsland_friend_cell_push",
	            _widget = cell,
	            _invoke = nil,
	            _index = i,
	            _data = data,
	            _interval = 0.5,})
		end

	end

	listView:requestRefreshView()
	
	self.listView = listView
	self.list_view_pox = listView:getInnerContainer():getPositionX()

	if #data == 0 then
    	self.button_arrow_right:setVisible(false)
    	self.button_arrow_left:setVisible(false)
    else
    	self.button_arrow_left:setVisible(true)
    	self.button_arrow_right:setVisible(true)
    end

	-- 可加入好友任务个数
	local max = dms.string(dms["play_config"], 96, play_config.param)
	local count = self.taskInfo.joinFriendTaskCount + self.taskInfo.finishFriendTaskCount
	self.Text_holy_list_t_0:setString((max - count) .. "/" .. max)

end

function FileIslandFriends:onUpdate(dt)
    if self.listView ~= nil then
        local size = self.listView:getContentSize()
        local posX = self.listView:getInnerContainer():getPositionX()
        if self.list_view_pox == posX then
            return
        end

        self.list_view_pox = posX
        local items = self.listView:getItems()

	    if posX >= -40 then
	        self.button_arrow_left:setVisible(false)
	    else
	        self.button_arrow_left:setVisible(true)
	    end

	    if posX <= -self.listView:getInnerContainer():getContentSize().width + self.listView:getContentSize().width + 40 then
	        self.button_arrow_right:setVisible(false)
	    else
	        self.button_arrow_right:setVisible(true)
	    end

        if items[1] == nil then
            return
        end

        local itemSize = items[1]:getContentSize()

        for i, v in pairs(items) do
            local tempX = v:getPositionX() + posX
            if tempX + itemSize.width * 2 < 0 or tempX > size.width + itemSize.width * 2 then
                v:unload()
            else
                v:reload()
            end
        end
    end
end

function FileIslandFriends:onInit()
	local csb_explore_friend_task = csb.createNode("campaign/explore/explore_friend_task.csb")
	local root = csb_explore_friend_task:getChildByName("root")
	self.root = root
	table.insert(self.roots, root)
    self:addChild(csb_explore_friend_task)

    -- 关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_maoxian_back"), nil, 
	{
		terminal_name = "fileIsland_friends_close", 
		terminal_state = 0, 
		isPressedActionEnabled = true
	},
	nil, 0)

    -- 箭头
    self.button_arrow_left = ccui.Helper:seekWidgetByName(root, "Button_alloy_matrix_formation_change_left")
    self.button_arrow_right = ccui.Helper:seekWidgetByName(root, "Button_alloy_matrix_formation_change_right")
    
	fwin:addTouchEventListener(self.button_arrow_left, nil, 
	{
		terminal_name = "fileIsland_friends_scrollView_roll", 
		terminal_state = 0, 
		_type  = 1,
		isPressedActionEnabled = true
	},
	nil, 0)

	fwin:addTouchEventListener(self.button_arrow_right, nil, 
	{
		terminal_name = "fileIsland_friends_scrollView_roll", 
		terminal_state = 0, 
		_type  = 2,
		isPressedActionEnabled = true
	},
	nil, 0)

	-- 我的任务
	self.button_my_task = ccui.Helper:seekWidgetByName(root, "Button_10_0")
	fwin:addTouchEventListener(self.button_my_task, nil, 
    {
        terminal_name = "fileIsland_friends_left_btn_change", 
        btnType = 1
    },
    nil, 0)

	-- 协作任务
	self.button_cooperation_task = ccui.Helper:seekWidgetByName(root, "Button_10_0_0")
	fwin:addTouchEventListener(self.button_cooperation_task, nil, 
    {
        terminal_name = "fileIsland_friends_left_btn_change", 
        btnType = 2
    },
    nil, 0)

	-- 可加入好友任务个数
    self.Text_holy_list_t_0 = ccui.Helper:seekWidgetByName(root, "Text_holy_list_t_0")

    self.button_my_task:setHighlighted(false)
	self.button_cooperation_task:setHighlighted(false)

    local listIndex = 1
    if tonumber(self.params) == 2 then
    	listIndex = 2
    	self.button_cooperation_task:setHighlighted(true)
    else
    	self.button_my_task:setHighlighted(true)
    end
	
	-- 刷新我的任务界面
	self.taskType = listIndex
	
	self:onUpdateDraw(listIndex)

    -- 顶部用户信息
	app.load("client.l_digital.campaign.fileIsland.FileIslandShopBuyTop") 					
	local userinfo = FileIslandShopBuyTop:new()
    userinfo._rootWindows = self
    local info = fwin:open(userinfo,fwin._windows)

	self:registerOnNodeEvent(self)
	self:registerOnNoteUpdate(self, 1)
end

function FileIslandFriends:initData()
	self.taskInfo = _ED.fileIsland.taskInfo

	-- 我的任务
	self.taskInfo1 = {}

	for i = 1, #self.taskInfo.mySingleTaskInfo do
		local data = self.taskInfo.mySingleTaskInfo[i]
		data.cellType = 1
		data.listType = 1
		table.insert(self.taskInfo1, data)
	end

	for i = 1, #self.taskInfo.myJoinTaskInfo do
		local data = self.taskInfo.myJoinTaskInfo[i]
		data.cellType = 3
		data.listType = 1
		table.insert(self.taskInfo1, data)
	end

	for i = 1, #self.taskInfo.myMultiTaskInfo do
		local data = self.taskInfo.myMultiTaskInfo[i]
		data.cellType = 2
		data.listType = 1
		table.insert(self.taskInfo1, data)
	end

	-- 我的任务的排序
	for i = 1, #self.taskInfo1 do
		local data = self.taskInfo1[i] 
		local configdata = dms.element(dms["file_island_friend_task"], data.configId)

		-- 单人
		if data.cellType == 1 then
			if data.curProgress == 0 then
				data.order = 1
			else
				data.order = 6
			end

		-- 协作
		elseif data.cellType == 2 then
			if data.curProgress == 0 then
				data.order = 2
			else
				data.order = 3
			end

		-- 加入
		elseif data.cellType == 3 then
			local complete = false
			for i = 1, #data.rewardFriends do
				if data.rewardFriends[i] == tonumber(_ED.user_info.user_id) then
					complete = true
					break
				end
			end

			if complete == false then
				data.order = 4
			else
				data.order = 5
			end
		end

		-- 时间
		local current = _ED.system_time + (os.time() - _ED.native_time)
        data.lastTime = data.endTime - current

        local joinFriendData = data.joinFriends[1]
        if data.type == 2 and joinFriendData and joinFriendData.endTime then
        	local npcNum = dms.atos(configdata, file_island_friend_task.friend_npcNum)
        	if tonumber(data.friendChallengeTimes) < tonumber(npcNum) then
        		data.lastTime = joinFriendData.endTime - current
        	end
        end
	end

	local function sortFunc(a, b)
        if tonumber(a.order) < tonumber(b.order) then
            return tonumber(a.order) < tonumber(b.order)
        elseif tonumber(a.order) == tonumber(b.order) then
            return tonumber(a.lastTime) < tonumber(b.lastTime)
        end
    end
	table.sort(self.taskInfo1, sortFunc)

	-- 协作任务
	self.taskInfo2 = {}

	for i = 1, #self.taskInfo.friendMultiTaskInfo do
		local data = self.taskInfo.friendMultiTaskInfo[i]
		data.cellType = 3
		data.listType = 2

		-- 时间
		local current = _ED.system_time + (os.time() - _ED.native_time)
        data.lastTime = data.endTime - current

		table.insert(self.taskInfo2, data)
	end

	-- 协作任务的排序
	local function sortFunc(a, b)
        return tonumber(a.lastTime) < tonumber(b.lastTime)
    end
	table.sort(self.taskInfo2, sortFunc)

end

function FileIslandFriends:init(params)
	self.params = params
	self:initData()
	self:onInit()
	return self
end

function FileIslandFriends:onExit()
	state_machine.remove("fileIsland_friends_close")
	state_machine.remove("fileIsland_friends_scrollView_roll")
	state_machine.remove("fileIsland_friends_left_btn_change")
	state_machine.remove("fileIsland_friends_request_and_refresh_list")
	state_machine.remove("fileIsland_friends_refresh_list")

end

function FileIslandFriends:requestAndRefreshTaskInfo()
	local function callback(response)
		if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
			self:initData()
			self:onUpdateDraw(self.taskType)
		end
	end
	protocol_command.fileIslandTaskInfo.param_list = ""
	NetworkManager:register(protocol_command.fileIslandTaskInfo.code, nil, nil, nil, nil, callback, false, nil)
end

function FileIslandFriends:refreshTaskInfo()
	self:initData()
	self:onUpdateDraw(self.taskType)
end



