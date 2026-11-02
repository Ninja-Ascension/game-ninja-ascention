--[[ ----------------------------------------------------------------------------
-- 七日活动分页
--]] ----------------------------------------------------------------------------
ServiceCarnivalSevenday = class("ServiceCarnivalSevendayClass", Window)

-- 打开窗口
local service_carnival_sevenday_window_open_terminal = {
	_name = "service_carnival_sevenday_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		-- if nil == fwin:find("ServiceCarnivalSevendayClass") then
			-- local cell = ServiceCarnivalSevenday:new()
			-- cell:init(params)
			-- cell:registerOnNodeEvent(cell)
			-- return cell


			local userinfo = ServiceCarnivalSevenday:new():init()
			userinfo._rootWindows = params
			fwin:open(userinfo,fwin._view)
			
			-- return fwin:open(ServiceCarnivalSevenday:new():init(params), fwin._view)
		-- end
		-- return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local service_carnival_sevenday_window_close_terminal = {
	_name = "service_carnival_sevenday_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ServiceCarnivalSevendayClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(service_carnival_sevenday_window_open_terminal)
state_machine.add(service_carnival_sevenday_window_close_terminal)
state_machine.init()

-- 构造器
function ServiceCarnivalSevenday:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.dayIndex = 1			--

	self._controlers = {}
	self.Button_day_list = {}   -- 存放各天的按钮
	self.Button_tab_list = {}	-- 存放任务类型按钮
	self.Button_image_list = {}	-- 存放天数背景图片
	self.tab_list = {}			-- 存放tab整体
	self.configData = {}		-- 存放每天任务相关信息
	self.userData = {}			-- 存放玩家信息

	-- load lua files.
	app.load("client.activity.serviceCarnival.servicecarnivalsevendaylist")
	app.load("client.activity.serviceCarnival.servicecarnivalsevendaytab")
	app.load("client.activity.serviceCarnival.ServiceCarnivalFinalReward")
	-- Initialize service carnival sevenday page state machine.
	local function init_service_carnival_sevenday_terminal()
		-- 打开角色创建窗口
		local service_carnival_sevenday_open_terminal = {
			_name = "service_carnival_sevenday_open",
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
		local service_carnival_sevenday_close_terminal = {
			_name = "service_carnival_sevenday_close",
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
		local service_carnival_sevenday_show_terminal = {
			_name = "service_carnival_sevenday_show",
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
		local service_carnival_sevenday_hide_terminal = {
			_name = "service_carnival_sevenday_hide",
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

		-- 切换天数标签
        local service_carnival_sevenday_page_change_terminal = {
            _name = "service_carnival_sevenday_page_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local day_index = params._datas._day_index
				app.load("client.activity.serviceCarnival.ServiceCarnivalMain")
				state_machine.unlock("service_carnival_main_change_type")
                -- 未开启提示
                if tonumber(day_index) > tonumber(params._datas._day_count) and day_index ~= 6 then
                    TipDlg.drawTextDailog(string.format(_new_interface_text[311], day_index))
                    return false
                end
                for i = 1, 7 do
                    local Image_day =instance.Button_image_list[i]
                    if Image_day ~= nil then
                        Image_day:setVisible(false)
                    end
                end 
                local Image_day_now = instance.Button_image_list[day_index]
                if Image_day_now ~= nil then
                    Image_day_now:setVisible(true)
                end
                -- state_machine.excute("seven_happy_remove_last_reward", 0, nil)
				instance:clearListInfo(day_index)
				if day_index ~= 6 then
					self:onUpdateDrawEx(day_index)
					
				else
					local Panel_checkpoint_rank_final = ccui.Helper:seekWidgetByName(instance.roots[1], "Panel_checkpoint_rank_final")
					state_machine.excute("service_carnival_final_reward_open", 0, {rootWindow = Panel_checkpoint_rank_final})
				end

               return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		-- 切换任务类型
        local service_carnival_sevenday_type_change_terminal = {
            _name = "service_carnival_sevenday_type_change",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local selector_index = nil
                if params ~= nil and params._datas ~= nil and params._datas.selector_index ~= nil then 
                    selector_index = params._datas.selector_index
                end

                if params ~= nil and params[1] == true then
                    instance:onUpdateDrawEx(instance.dayIndex, selector_index, true)
                else
                    instance:onUpdateDrawEx(instance.dayIndex, selector_index)
                end
                
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(service_carnival_sevenday_open_terminal)
		state_machine.add(service_carnival_sevenday_close_terminal)
		state_machine.add(service_carnival_sevenday_show_terminal)
		state_machine.add(service_carnival_sevenday_hide_terminal)
		state_machine.add(service_carnival_sevenday_page_change_terminal)
		state_machine.add(service_carnival_sevenday_type_change_terminal)
		state_machine.init()
	end
	-- call func init service carnival sevenday state machine.
	init_service_carnival_sevenday_terminal()
end

function ServiceCarnivalSevenday:onUpdateTaskType()
	local root = self.roots[1]
	if self.ListView_tab == nil then
		self.ListView_tab = ccui.Helper:seekWidgetByName(root, "ListView_tab")
	end
	self.ListView_tab:removeAllItems()
	self.Button_tab_list = {}
	self.tab_list = {}
	local allTypeString = dms.string(dms["new_server_carnival"], self.dayIndex, new_server_carnival.taskType)
	local allTypes = zstring.split(allTypeString, ",")
	for i, v in ipairs(allTypes) do
		local cell = state_machine.excute("service_carnival_sevenday_tab_create", 0, {type = tonumber(v)})
		self.ListView_tab:addChild(cell)
		local Button_tab = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(cell, "Button_tab"), nil,
		{
			terminal_name = "service_carnival_sevenday_type_change",
			terminal_state = 0,
			isPressedActionEnabled = true,
			selector_index = i
		}, nil, 0)

		
		state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_service_carnival_7happy_page_push",
            _widget = cell,
            _invoke = nil,
            _pageIndex = i,
            _interval = 0.5,})
		table.insert(self.tab_list, cell)
		table.insert(self.Button_tab_list, Button_tab)
		self.ListView_tab:requestRefreshView()
	end
end

-- 显示或隐藏列表
function ServiceCarnivalSevenday:changeLastState(isShow)
    local root = self.roots[1]
    if root ~= nil then
        local ListView_meirifuli = ccui.Helper:seekWidgetByName(root, "ListView_meirifuli")
        ListView_meirifuli:setVisible(isShow)

        for i = 1, 3 do
            self.Button_tab_list[i]:setVisible(isShow)
        end

        if isShow == false then
            for i = 1, #self.Button_image_list do
				self.Button_image_list[i]:setVisible(false)
            end
        end
    end
end

function ServiceCarnivalSevenday:onUpdateDrawEx(dayIndex, selectorIndex, isboolen)
	local root = self.roots[1]
    local current_controler = self._controlers[dayIndex]
    if current_controler == nil then
        return
    end

    if self.dayIndex == dayIndex 
        and self._current_controler == current_controler
        and selectorIndex == current_controler.selector_index 
        then
        return
    end

    self.dayIndex = dayIndex
	self:onUpdateTaskType()
    if nil == selectorIndex then
        if current_controler.selector_index < 1 then
            current_controler.selector_index = 1
        end
        selectorIndex = current_controler.selector_index
    else
        current_controler.selector_index = selectorIndex
    end

    self._current_controler = current_controler
	local Text_light_now = nil
	local Text_dark_now = nil
    -- 标签页显示
    for i = 1, #self.Button_tab_list do
        local controlButton = self.Button_tab_list[i]
		
		local Text_light = ccui.Helper:seekWidgetByName(self.tab_list[i], "Text_light")
		local Text_dark = ccui.Helper:seekWidgetByName(self.tab_list[i], "Text_dark")
        if nil == self._current_controler.selector or i == selectorIndex then
            self._current_controler.selector = controlButton
			Text_light_now = Text_light
			Text_dark_now = Text_dark
        end
        controlButton:setHighlighted(false)
        controlButton:setTouchEnabled(true) 

        -- 标签页的数据
        local tabData = self._current_controler.data[i]
        if nil == tabData then
            controlButton:setVisible(false)
			Text_light:setVisible(false)
			Text_dark:setVisible(false)
			Text_dark:setVisible(true)
			Text_light:setVisible(false)
        else
            controlButton:setVisible(true)
			Text_light:setVisible(false)
			Text_dark:setVisible(true)
            local name = tonumber(tabData[1][1])
			Text_light:setString(tipStringInfo_service_sevenday_type_name[name])
			Text_dark:setString(tipStringInfo_service_sevenday_type_name[name])

        end
		local name = tonumber(tabData[1][1])
    end
	Text_light_now:setVisible(true)
	Text_dark_now:setVisible(false)
    self._current_controler.selector:setHighlighted(true)
    self._current_controler.selector:setTouchEnabled(false)

    
    -- 任务列表
    local listView = ccui.Helper:seekWidgetByName(root, "ListView_rwlb")
    listView:removeAllItems()

    -- 当前标签页下的所有任务的数据，第1个数据是标签页的名称，从第2个数据开始是有效的任务数据
    local item_group = {}
    local tabData = self._current_controler.data[selectorIndex]
	
	tabData = self:sortListItems(tabData, selectorIndex)
	
	-- debug.print_r(self.userData, "=====self.userDataself.userData")
	-- debug.print_r(tabData, "========tabData")
    for i = 1, #tabData do
        -- 每一个cell的数据
        local cellData = tabData[i]
		
        local cell = state_machine.excute("service_carnival_sevenday_list_create", 0, {{id = tonumber(cellData[1]), data = cellData, pageIndex = selectorIndex, drawIndex = tabData[i].index, dayIndex = self.dayIndex, userData = self.userData},i})
        
		listView:addChild(cell)
    end
    
    listView:requestRefreshView()
	listView:jumpToTop()

    self.ListView_rwlb = listView
    self.listview_ContainerPosY = listView:getInnerContainer():getPositionY()

	-- local function updateListView(sender, event)
		
	-- end
	-- self.ListView_rwlb:addScrollViewEventListener(updateListView)

    -- fwin:addService({
    --     callback = function ( params )
    --         if params.listview ~= nil then
    --             params.listview:requestRefreshView()
    --             params.listview_ContainerPosY = listView:getInnerContainer():getPositionY() + 1
    --         end
    --     end,
    --     delay = 0,
    --     params = self
    -- })

end

function ServiceCarnivalSevenday:sortListUserData(selectorIndex)

    local result = {}
    local closeItems = {}       -- 已完成
    local drawItems = {}            -- 可领取
    local uncompItems = {}      -- 未完成

	local userData = self.userData
	local userData_day = userData.statusArr[tonumber(self.dayIndex)]
	local userData_page = userData_day[tonumber(selectorIndex)]
    for k, v in pairs(userData_page) do
		
        if tonumber(v.st) == 0 then
            table.insert(uncompItems, v)
        elseif tonumber(v.st) == 2 then
            table.insert(drawItems, v)
        else
            table.insert(closeItems, v)
        end
    end

    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(uncompItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end
	
    userData_day[tonumber(selectorIndex)] = result
end

function ServiceCarnivalSevenday:sortListItems(items, selectorIndex)


	local result = {}
    local closeItems = {}       -- 已完成
    local drawItems = {}            -- 可领取
    local uncompItems = {}      -- 未完成
	
	local userData = self.userData
	local userData_day = userData.statusArr[tonumber(self.dayIndex)]
	local userData_page = userData_day[tonumber(selectorIndex)]
	for i = 2, #items do
		local userData_cell = userData_page[tonumber(i - 1)]
		local rewardState = userData_cell.st
		
		items[i].index = i - 1
		--0未完成, 1 已领取, 2 可领取
		if tonumber(rewardState) == 0 then
            table.insert(uncompItems, items[i])
        elseif tonumber(rewardState) == 2 then
            table.insert(drawItems, items[i])
        else
            table.insert(closeItems, items[i])
        end
	end
	
    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(uncompItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end
	
    return result
end

function ServiceCarnivalSevenday:updateListViewDraw()
	if self.ListView_rwlb ~= nil then
		local size = self.ListView_rwlb:getContentSize()
		local posY = self.ListView_rwlb:getInnerContainer():getPositionY()
		if self.listview_ContainerPosY == posY then
			return
		end
		self.listview_ContainerPosY = posY
		local items = self.ListView_rwlb:getItems()
		if items[1] == nil then
			return
		end
		local itemSize = items[1]:getContentSize()
		for i, v in pairs(items) do
			local tempY = v:getPositionY() + posY
			if tempY + itemSize.height / 2 + itemSize.height < 0 or tempY > size.height + itemSize.height / 2 then
				v:unload()
			else
				v:reload()
			end
		end
	end
end

function ServiceCarnivalSevenday:onUpdate(dt)
	
	self:updateListViewDraw()

    self:updateDrawActivityTime()
end

-- 倒计时
function ServiceCarnivalSevenday:updateDrawActivityTime()
    local root = self.roots[1]
    if root == nil or _ED.active_activity[183] == nil then
        return
    end

    local current = _ED.system_time + (os.time() - _ED.native_time)
	
    local activity = _ED.active_activity[183]
    local surplus_time = activity.end_time / 1000 - current
    self.Text_num_timeCount:setString(getRedAlertTimeActivityFormat(surplus_time))

end

function ServiceCarnivalSevenday:clearListInfo(day_index)
	self.ListView_rwlb:removeAllItems()
	self.ListView_tab:removeAllItems()
	self.Panel_checkpoint_rank_final:removeAllChildren()
	if day_index ~= 6 then
		self.ListView_rwlb:setVisible(true)
		self.Panel_checkpoint_rank_final:setVisible(false)
	else
		self.ListView_rwlb:setVisible(false)
		self.Panel_checkpoint_rank_final:setVisible(true)
	end
	
end

-- 对象初始化
function ServiceCarnivalSevenday:init(params)
	self.configData = {}
	self.nowDays = {1,2,3,4}
	
	local days = dms.count(dms["new_server_carnival"]) - 1
	for i = 1 , days do
		local dayData = dms.element(dms["new_server_carnival"], i, true)
		
		self.configData[i] = self.configData[i] or {}
		local typeInfo = zstring.split(dayData[new_server_carnival.taskType], ",")
		local taskInfo = zstring.split(dayData[new_server_carnival.taskString], "|")
		local curDayInfo = {}
		for i, v in ipairs(typeInfo) do
			local data = {}
			local detailInfo = {}
			table.insert(detailInfo, tonumber(v))
			table.insert(data, detailInfo)
			local taskList = zstring.split(taskInfo[i], ",")
			for i, v in ipairs(taskList) do
				local taskDetail = {}
				table.insert(taskDetail, tonumber(v))
				local open_level = tonumber(dms.string(dms["achieve"], tonumber(v), achieve.achive_type))
				local param1 = tonumber(dms.string(dms["achieve"], tonumber(v), achieve.param1))
				local param3 = tonumber(dms.string(dms["achieve"], tonumber(v), achieve.param3))
				local maxNum = 0
				if open_level == 0 and param1 ~= 0 and param3 ~= -1 then
					maxNum = dms.string(dms["achieve"], tonumber(v), achieve.param3)
				else
					maxNum = dms.string(dms["achieve"], tonumber(v), achieve.param2)
				end
				table.insert(taskDetail, maxNum)

				table.insert(data, taskDetail)
			end
			table.insert(curDayInfo, data)
		end
		self.configData[i] = curDayInfo
		
		
	end
	local userStr = _ED.active_activity[183].activity_params
	
    self.userData = json.decode(userStr)
	for i, v in ipairs(self.configData) do
		table.insert(self._controlers, 
        {
            data = v,
            page_index = i,
            selector_index = -1,
            selector = nil,
        })
	end
	
	
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function ServiceCarnivalSevenday:initListView()
	local root = self.roots[1]

	 -- 后端传过来的是0，加1，表示第一天
	 local nowDayCount = tonumber(self.userData.curDay)
	 self.Button_day_list = {}
	 self.Button_image_list ={}
	 for i = 1, 6 do
        local day = i
		local Button_day = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_day_"..i), nil,
		{
			terminal_name = "service_carnival_sevenday_page_change",
			terminal_state = 0,
            _day_index = day,
            _day_count = nowDayCount,
			isPressedActionEnabled = true,
			curIndex = 1
		}, nil, 0)	
		Button_day:setHighlighted(false)
		if i <= nowDayCount then
			state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_service_carnival_7happy_day_push",
            _widget = Button_day,
            _invoke = nil,
            dayIndex = day,
            _interval = 0.5,})
		end

		local Button_image = ccui.Helper:seekWidgetByName(Button_day, "Image_day_"..i)
		Button_image:setVisible(false)

		if i ~= 6 then
			local Lock_image = ccui.Helper:seekWidgetByName(Button_day, "Image_lock_"..i)
			if i <= nowDayCount then
				Lock_image:setVisible(false)
			end
		end
		table.insert(self.Button_day_list, Button_day)
		table.insert(self.Button_image_list, Button_image)
	end

	state_machine.excute("service_carnival_sevenday_page_change", 0, {
		_datas = {
			terminal_name = "service_carnival_sevenday_page_change",      
			terminal_state = 0,
			_day_index = 1,
			_day_count = nowDayCount,
			isPressedActionEnabled = true
		}
	})
end

function ServiceCarnivalSevenday:onEnterTransitionFinish()
	-- 加载ServiceCarnivalSevendayWindow界面资源.
	-- res.activity.service_carnival.service_carnival_sevenday = res/activity/service_carnival/service_carnival_sevenday.csb
	local csbNode = csb.createNode("activity/service_carnival/service_carnival_sevenday.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	local nowDayCount = tonumber(self.userData.curDay)

	-- 分页按钮列表容器
	self.ListView_tab = ccui.Helper:seekWidgetByName(root, "ListView_tab")

	-- 任务獎勵列表容器
	self.ListView_rwlb = ccui.Helper:seekWidgetByName(root, "ListView_rwlb")

	-- 倒计时
	self.Text_num_timeCount = ccui.Helper:seekWidgetByName(root, "Text_num_timeCount")

	-- 七日狂欢最终奖励容器
	self.Panel_checkpoint_rank_final = ccui.Helper:seekWidgetByName(root, "Panel_checkpoint_rank_final")
	-- print(self.Panel_checkpoint_rank_final, "====self.Panel_checkpoint_rank_final")
	-- self.Button_day_list[1]:setHighlighted(true)

	self:initListView()
	self:onUpdateTaskType()
	self:onUpdateDrawEx(1, 1)
	
end

function ServiceCarnivalSevenday:onExit()
	-- 释放ServiceCarnivalSevendayWindow界面资源.
	state_machine.remove("service_carnival_sevenday_open")
	state_machine.remove("service_carnival_sevenday_close")
	state_machine.remove("service_carnival_sevenday_show")
	state_machine.remove("service_carnival_sevenday_hide")
	state_machine.remove("service_carnival_sevenday_page_change")
	state_machine.remove("service_carnival_sevenday_type_change")
	
end

function ServiceCarnivalSevenday:close()
	-- window event : close.
	
end

function ServiceCarnivalSevenday:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
