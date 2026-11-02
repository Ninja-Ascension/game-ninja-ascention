-----------------------------
--充值返钻
-----------------------------
SmRechargeReturnRewardNew = class("SmRechargeReturnRewardNewClass", Window)

local sm_recharge_return_reward_new_open_terminal = {
	_name = "sm_recharge_return_reward_new_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmRechargeReturnRewardNewClass") == nil then
			fwin:open(SmRechargeReturnRewardNew:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_recharge_return_reward_new_close_terminal = {
	_name = "sm_recharge_return_reward_new_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmRechargeReturnRewardNewClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_recharge_return_reward_new_open_terminal)
state_machine.add(sm_recharge_return_reward_new_close_terminal)
state_machine.init()

function SmRechargeReturnRewardNew:ctor()
	self.super:ctor()
	self.roots = {}
    
    self._tick_time = 0
    self._text_time = nil

    app.load("client.l_digital.cells.activity.wonderful.SmActivityRechargeReturnRewardNewCell")
    local function init_sm_recharge_return_reward_terminal()
        local sm_recharge_return_reward_update_draw_new_terminal = {
            _name = "sm_recharge_return_reward_update_draw_new",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                if instance ~= nil and instance.roots ~= nil and instance.roots[1] ~= nil then
                	instance:onUpdateDraw()
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        state_machine.add(sm_recharge_return_reward_update_draw_new_terminal)
        state_machine.init()
    end
    init_sm_recharge_return_reward_terminal()
end

function SmRechargeReturnRewardNew:onUpdateDraw()
    local root = self.roots[1]
    local ListView_tab_1 = ccui.Helper:seekWidgetByName(root, "ListView_tab_1")
    self._text_time = ccui.Helper:seekWidgetByName(root,"Text_time_1")
    ListView_tab_1:removeAllItems()

    local activity_info = _ED.active_activity[self.actType]
    local activity_params = zstring.split(activity_info.activity_params, ",")
    local result = {}
    for i, v in pairs(activity_info.activity_Info) do
        table.insert(result, v)
    end
    local closeItems = {}       -- 已完成
    local drawItems = {}            -- 可领取
    local uncompItems = {}      -- 未完成
    for k, v in pairs(result) do
        if tonumber(v.activityInfo_isReward) == 1 then
            table.insert(closeItems, v)
        elseif tonumber(activity_params[k]) == 1 then
            table.insert(drawItems, v)
        else
            table.insert(uncompItems, v)
        end
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

    for k, v in pairs(result) do
        local cell = state_machine.excute("sm_activity_recharge_return_reward_cell_new_create", 0, {v, self.actType})
        ListView_tab_1:addChild(cell)
    end
    ListView_tab_1:requestRefreshView()

    self._tick_time =  (tonumber(activity_info.end_time) - (os.time() + _ED.time_add_or_sub) * 1000) / 1000
    self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
end

function SmRechargeReturnRewardNew:onUpdate(dt)
    if self._text_time ~= nil and self._tick_time > 0 then 
        self._tick_time = self._tick_time - dt
        self._text_time:setString(getRedAlertTimeActivityFormat(self._tick_time))
        if self._tick_time <= 0 then
            self._tick_time = nil
        end
    end
end

function SmRechargeReturnRewardNew:init(params)
    self.actType = params
	self:onInit()
    return self
end

function SmRechargeReturnRewardNew:onInit()
    local csbItem = csb.createNode("activity/wonderful/single_pen_recharge_chongzhi.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_7day_back"), nil, 
    {
        terminal_name = "sm_recharge_return_reward_new_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    self:onUpdateDraw()
end

function SmRechargeReturnRewardNew:onEnterTransitionFinish()
end

function SmRechargeReturnRewardNew:onExit()
	state_machine.remove("sm_recharge_return_reward_update_draw_new")
end

