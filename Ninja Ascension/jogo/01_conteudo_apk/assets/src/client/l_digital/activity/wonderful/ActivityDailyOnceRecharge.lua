-----------------------------
--充值返钻
-----------------------------
ActivityDailyOnceRecharge = class("ActivityDailyOnceRechargeClass", Window)

local activity_daily_once_recharge_open_terminal = {
	_name = "activity_daily_once_recharge_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("ActivityDailyOnceRechargeClass") == nil then
			fwin:open(ActivityDailyOnceRecharge:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local activity_daily_once_recharge_close_terminal = {
	_name = "activity_daily_once_recharge_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("ActivityDailyOnceRechargeClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(activity_daily_once_recharge_open_terminal)
state_machine.add(activity_daily_once_recharge_close_terminal)
state_machine.init()

function ActivityDailyOnceRecharge:ctor()
	self.super:ctor()
	self.roots = {}
    
    self._tick_time = 0
    self._text_time = nil

    app.load("client.l_digital.activity.wonderful.ActivityDailyOnceRechargeCell")
    local function init_activity_daily_once_recharge_cell_terminal()
        local activity_daily_once_recharge_terminal = {
            _name = "activity_daily_once_recharge",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots and instance.roots[1] ~= nil then
                	instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(activity_daily_once_recharge_terminal)
        state_machine.init()
    end
    init_activity_daily_once_recharge_cell_terminal()
end

function ActivityDailyOnceRecharge:onUpdateDraw()
    local root = self.roots[1]
    local ListView_tab_1 = ccui.Helper:seekWidgetByName(root, "ListView_1")
    self._text_time = ccui.Helper:seekWidgetByName(root,"Text_32")
    local Text_45 = ccui.Helper:seekWidgetByName(root,"Text_45")
    local Text_45_1 = ccui.Helper:seekWidgetByName(root,"Text_45_1")
    ListView_tab_1:removeAllItems()

    Text_45:setString("")

    Text_45:setString(tipStringInfo_daily_once_recharge_tips[1])
    Text_45_1:setString(tipStringInfo_daily_once_recharge_tips[2])

    local activity_info = _ED.active_activity[self.actType]
    local activity_params = zstring.splits(activity_info.activity_params, "|", ",")
    local result = {}
    for i, v in ipairs(activity_info.activity_Info) do
        table.insert(result, v)
    end
    local closeItems = {}       -- 已完成
    local drawItems = {}            -- 可领取
    local uncompItems = {}      -- 未完成
    for k, v in ipairs(result) do
        local maxCompNum = zstring.split(v.activityInfo_need_day, ",")[2]
        if tonumber(maxCompNum) <= tonumber(activity_params[k][2]) then
            v.state = 2
            table.insert(closeItems, v)
        else
            if tonumber(activity_params[k][1]) > tonumber(activity_params[k][2]) then
                table.insert(drawItems, v)
                v.state = 1
            else
                table.insert(uncompItems, v)
                v.state = 0
            end
        end
        v.curRecharge = tonumber(activity_params[k][1])
        v.curGetReward = tonumber(activity_params[k][2])
    end
    result = {}
    for k, v in pairs(drawItems) do
        table.insert(result, v)
    end
    for k, v in pairs(uncompItems) do
        table.insert(result, v)
    end
    for k, v in pairs(closeItems) do
        table.insert(result, v)
    end

    for k, v in ipairs(result) do
        local cell = state_machine.excute("activity_daily_once_recharge_cell_create", 0, {v, self.actType})
        ListView_tab_1:addChild(cell)
    end
    ListView_tab_1:requestRefreshView()

    self.cacheListView = ListView_tab_1
    self._tick_time =  (tonumber(activity_info.end_time) - (os.time() + _ED.time_add_or_sub) * 1000) / 1000
    -- self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
end

function ActivityDailyOnceRecharge:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time <= 0 then
            self._tick_time = nil
        end
    end
end

function ActivityDailyOnceRecharge:init(params)
    self.actType = params
	self:onInit()
    return self
end

function ActivityDailyOnceRecharge:onInit()
    local csbItem = csb.createNode("activity/wonderful/one_recharge.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    self:onUpdateDraw()
end

function ActivityDailyOnceRecharge:lazy()
    if self.loaded == true then
        return
    end
    self.loaded = true
    self:onInit()
    self:registerOnNoteUpdate(self, 1)
end

function ActivityDailyOnceRecharge:unload()
    self:removeAllChildren(true)
    self.loaded = false
    self.roots = {}
    self._text_time = nil
    self.cacheListView = nil
    self:unregisterOnNoteUpdate(self)
end

function ActivityDailyOnceRecharge:onEnterTransitionFinish()
end

function ActivityDailyOnceRecharge:createCell(params)
    local cell = ActivityDailyOnceRecharge:new()
    cell:registerOnNodeEvent(cell)
    cell:registerOnNoteUpdate(cell, 0.5)
    return cell
end

function ActivityDailyOnceRecharge:onExit()
	state_machine.remove("activity_daily_once_recharge")
end

