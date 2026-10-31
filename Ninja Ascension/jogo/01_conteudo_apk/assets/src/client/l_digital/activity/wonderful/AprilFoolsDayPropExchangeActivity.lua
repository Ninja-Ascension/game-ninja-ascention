--[[ ----------------------------------------------------------------------------
-- 愚人节节日道具兑换活动
--]] ----------------------------------------------------------------------------
AprilFoolsDayPropExchangeActivity = class("AprilFoolsDayPropExchangeActivityClass", Window)

-- 打开窗口
local april_fools_day_prop_exchange_activity_window_open_terminal = {
	_name = "april_fools_day_prop_exchange_activity_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("AprilFoolsDayPropExchangeActivityClass") then
			fwin:open(AprilFoolsDayPropExchangeActivity:new():init(params), fwin._view)
		end
		local _self = params._datas._self
		local _activity_type = params._datas._activity_type

		-- 用于推送红点相关的类型
		local activity_type = ""
		if _activity_type == 177 then
			activity_type = 177
		elseif _activity_type == 121 then
			activity_type = 1212
		end

		local readTime = cc.UserDefault:getInstance():getStringForKey(getKey("activity_push_"..activity_type))
	    local nowTimeStr = os.date("%Y".."-".."%m".."-".."%d".."-".."%H", getBaseGTM8Time(_ED.system_time + (os.time() - _ED.native_time)))
	    local nowTimes = zstring.split(nowTimeStr , "-")
		local havePush = false
		if readTime == nil or readTime == "" then
			writeKey( "activity_push_"..activity_type , nowTimeStr)
			havePush = true
		else
			local readTimes = zstring.split(readTime , "-")
			if #readTimes <= 1 then
	            readTimes = zstring.split(os.date("%Y".."-".."%m".."-".."%d".."-".."%H", readTimes[1]), "-")
	        end
			readTimes[4] = readTimes[4] or 0
			local lastTime = os.time({year=tonumber(readTimes[1]), month=tonumber(readTimes[2]), day=tonumber(readTimes[3]), hour=tonumber(readTimes[4]), min=0, sec=0})
	        local nowTime = os.time({year=tonumber(nowTimes[1]), month=tonumber(nowTimes[2]), day=tonumber(nowTimes[3]), hour=tonumber(nowTimes[4]), min=0, sec=0})
	        if nowTime - lastTime >= 24*3600 then
	            writeKey( "activity_push_"..activity_type , nowTimeStr)
	            havePush = true
	        else
	            if (tonumber(readTimes[3]) ~= tonumber(nowTimes[3]) and tonumber(nowTimes[4]) >= 5)
	                or (tonumber(readTimes[3]) == tonumber(nowTimes[3]) 
	                    and zstring.tonumber(readTimes[4]) < 5
	                    and tonumber(nowTimes[4]) >= 5)
	                then
	                writeKey( "activity_push_"..activity_type , nowTimeStr)
	                havePush = true
	            end
	        end
			-- if tonumber(readTimes[1]) < tonumber(nowTimes[1]) or tonumber(readTimes[2]) < tonumber(nowTimes[2])
			-- 	or tonumber(readTimes[3]) < tonumber(nowTimes[3]) then
			-- 	writeKey( "activity_push_"..activity_type , nowTime)
			-- 	havePush = true
			-- end
		end
		if havePush == true then
			state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, activity_type)
		end	
		local widget = _self.roots[1]
	    if widget._nodeChild ~= nil then
	        widget:removeChild(widget._nodeChild, true)
	        widget._nodeChild = nil
	        widget._istips = false
	    end
	    state_machine.excute("notification_center_remove_widget", 0, { _widget = widget })
	    state_machine.excute("push_notification_center_manager", 0, { _terminal_name = "push_notification_center_activity_the_center_sm_activity_icon_cell",
	        _widget = widget,
	        _invoke = nil,
	        _activity_type = _self.activity_type,
	        cells = _self.roots[1],
	        _interval = 0.2,})
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local april_fools_day_prop_exchange_activity_window_close_terminal = {
	_name = "april_fools_day_prop_exchange_activity_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("AprilFoolsDayPropExchangeActivityClass"))
		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 1212)
		state_machine.excute("push_notification_center_activity_the_center_sm_activity_update", 0, 177)
		--state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_activity_icon_cell")
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(april_fools_day_prop_exchange_activity_window_open_terminal)
state_machine.add(april_fools_day_prop_exchange_activity_window_close_terminal)
state_machine.init()

-- 构造器
function AprilFoolsDayPropExchangeActivity:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	-- 真实的活动类型
	-- 121 老节日兑换活动
	-- 177 新节日兑换活动
	self.myActivityType = nil

	-- load lua files.
	app.load("client.cells.activity.april_fools_day_prop_exchange_cell")
	app.load("client.cells.activity.april_fools_day_cost_prop_cell")

	-- Initialize recharge for sixty gift activity page state machine.
	local function init_april_fools_day_prop_exchange_activity_terminal()
		-- 打开角色创建窗口
		local april_fools_day_prop_exchange_activity_open_terminal = {
			_name = "april_fools_day_prop_exchange_activity_open",
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
		local april_fools_day_prop_exchange_activity_close_terminal = {
			_name = "april_fools_day_prop_exchange_activity_close",
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
		local april_fools_day_prop_exchange_activity_show_terminal = {
			_name = "april_fools_day_prop_exchange_activity_show",
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
		local april_fools_day_prop_exchange_activity_hide_terminal = {
			_name = "april_fools_day_prop_exchange_activity_hide",
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

		-- 刷新道具
		local april_fools_day_prop_exchange_activity_refresh_cost_prop_terminal = {
			_name = "april_fools_day_prop_exchange_activity_refresh_cost_prop",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if nil ~= instance then
					instance:updateCostPropList()
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(april_fools_day_prop_exchange_activity_open_terminal)
		state_machine.add(april_fools_day_prop_exchange_activity_close_terminal)
		state_machine.add(april_fools_day_prop_exchange_activity_show_terminal)
		state_machine.add(april_fools_day_prop_exchange_activity_hide_terminal)
		state_machine.add(april_fools_day_prop_exchange_activity_refresh_cost_prop_terminal)
		state_machine.init()
	end
	-- call func init recharge for sixty gift activity state machine.
	init_april_fools_day_prop_exchange_activity_terminal()
end

function AprilFoolsDayPropExchangeActivity:init(params)
	self.myActivityType = params._datas._activity_type
	AprilFoolsDayPropExchangeActivity.curActivityType = self.myActivityType
	AprilFoolsDayPropExchangeActivity.cacheListView = nil
	AprilFoolsDayPropExchangeActivity.asyncIndex = 1
	if nil ~= self.onInit then
		self:onInit()
	end
	return self
end

function AprilFoolsDayPropExchangeActivity:onInit()

end

function AprilFoolsDayPropExchangeActivity:onUpdate(dt)
    if self.Text_time == nil or nil == self.end_time then
        return
    end
    local surplus_time = (self.end_time - ((os.time() + _ED.time_add_or_sub))*1000)
    self.Text_time:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
end

function AprilFoolsDayPropExchangeActivity:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.ceil((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    --if _hourTime > 0 then
        if _hourTime < 10 then
    		timeString = timeString .. "0".._hourTime ..":"
    	else
    		timeString = timeString .. _hourTime ..":"
    	end
    --end
    --if _minutesTime > 0 then
        if _minutesTime < 10 then
    		timeString = timeString .. "0".._minutesTime ..":"
    	else
            timeString = timeString .. _minutesTime ..":"
        end
    --end
    --if _secondsTime > 0 then
    	if _secondsTime < 10 then
    		timeString = timeString .. "0".._secondsTime 
    	else
	        timeString = timeString .. _secondsTime 
	    end
    --end
    return timeString
end

function AprilFoolsDayPropExchangeActivity:loading_cell()
	if AprilFoolsDayPropExchangeActivity.cacheListView == nil then
		return 
	end
	if AprilFoolsDayPropExchangeActivity.curActivityType ~= self.myActivityType then 
		return
	end
	local activity = _ED.active_activity[self.myActivityType]
	local cell = AprilFoolsDayPropExchange:createCell()
	cell:init(activity, AprilFoolsDayPropExchangeActivity.load_indexs[AprilFoolsDayPropExchangeActivity.asyncIndex], AprilFoolsDayPropExchangeActivity.cacheListView)
	AprilFoolsDayPropExchangeActivity.cacheListView:addChild(cell)
	AprilFoolsDayPropExchangeActivity.cacheListView:requestRefreshView()
	AprilFoolsDayPropExchangeActivity.asyncIndex = AprilFoolsDayPropExchangeActivity.asyncIndex + 1
end

function AprilFoolsDayPropExchangeActivity:initListView()
	local activity = _ED.active_activity[self.myActivityType]

	local load_indexs1 = {}
	local load_indexs2 = {}
	for i, info in pairs(activity.activity_Info) do
		local activityInfo = info
		local countInfos = zstring.split(activity.activity_params, ",")
		local exchangeInfos = zstring.split(activityInfo.activityInfo_need_day, "@")
		local nCount = (tonumber(exchangeInfos[2]) - tonumber(countInfos[i]))
		if nCount > 0 then
			table.insert(load_indexs1, i)
		else
			table.insert(load_indexs2, i)
		end
	end

	table.add(load_indexs1, load_indexs2)
	AprilFoolsDayPropExchangeActivity.load_indexs = load_indexs1

	for i, v in pairs(activity.activity_Info) do
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, self.loading_cell, self)
	end
end

function AprilFoolsDayPropExchangeActivity:getCostPropList()
	local result = {}

	local activity = _ED.active_activity[self.myActivityType]
	if activity and activity.activity_Info then
		local activity_Info = activity.activity_Info
		for _, v in pairs(activity_Info) do
			local exchangeInfos = zstring.split(v.activityInfo_need_day, "@")
			local itemInfos = zstring.splits(exchangeInfos[1], ":", ",")

			for _, prop in pairs(itemInfos) do
				local propID = tonumber(prop[1])

				if not result[propID] then
					result[propID] = true
				end
			end
		end
	end

	local propIDs = {}
	for k, v in pairs(result) do
		table.insert(propIDs, k)
	end

	table.sort(propIDs, function(a, b)
		return a < b
	end)

	return propIDs
end

function AprilFoolsDayPropExchangeActivity:updateCostPropList()
	local ListView_1 = self.ListView_1
	ListView_1:removeAllItems()

	local propIDs = self:getCostPropList()
	for _, v in ipairs(propIDs) do
		local cell = state_machine.excute("april_fools_day_cost_prop_cell_create", 0, v)
		ListView_1:addChild(cell)
	end

	ListView_1:jumpToLeft()
	ListView_1:requestRefreshView()
end

function AprilFoolsDayPropExchangeActivity:onUpdateDraw()
	local root = self.roots[1]
	local activityData = _ED.active_activity[self.myActivityType]

	local activity_params = zstring.split(activityData.activity_params, "|")

	self.end_time = tonumber(activityData.end_time)

	self.ListView_tuisong = ccui.Helper:seekWidgetByName(root, "ListView_tuisong")

	self.ListView_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")

	cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
	AprilFoolsDayPropExchangeActivity.asyncIndex = 1
	AprilFoolsDayPropExchangeActivity.cacheListView = self.ListView_tuisong

	self:initListView()
	self:updateCostPropList()
end

function AprilFoolsDayPropExchangeActivity:onEnterTransitionFinish()
	-- 加载AprilFoolsDayPropExchangeActivityWindow界面资源.
	-- res.activity.wonderful.april_fools_day = res/activity/wonderful/april_fools_day.csb
	local csbNode = csb.createNode("activity/wonderful/april_fools_day.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	-- 关闭
	self.Button_lingqu = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "april_fools_day_prop_exchange_activity_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)

	self.Text_time = ccui.Helper:seekWidgetByName(root, "Text_time")

	self:onUpdateDraw()

	-- 背景图片gm控制
	local pics = zstring.split(_ED.active_activity[self.myActivityType].activity_describe , ",")
	local fileName = string.format("images/ui/text/sm_hd/%s",pics[2])
	if cc.FileUtils:getInstance():isFileExist(fileName) == true then
		ccui.Helper:seekWidgetByName(root, "Image_login_gift_1"):loadTexture(fileName)
	end
end

function AprilFoolsDayPropExchangeActivity:onExit()
	state_machine.remove("april_fools_day_prop_exchange_activity_open")
	state_machine.remove("april_fools_day_prop_exchange_activity_close")
	state_machine.remove("april_fools_day_prop_exchange_activity_show")
	state_machine.remove("april_fools_day_prop_exchange_activity_hide")
	state_machine.remove("april_fools_day_prop_exchange_activity_refresh_cost_prop")
	state_machine.excute("notification_center_update", 0, "push_notification_center_activity_the_center_sm_activity_icon_cell")end

function AprilFoolsDayPropExchangeActivity:close()
	-- window event : close.
	
end

function AprilFoolsDayPropExchangeActivity:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
