-- ----------------------------------------------------------------------------------------------------
-- 说明：骰子获取途径界面
-------------------------------------------------------------------------------------------------------
RichmanDiceGetAccess = class("RichmanDiceGetAccessClass", Window)

local richman_dice_get_access_window_open_terminal = {
    _name = "richman_dice_get_access_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RichmanDiceGetAccessClass") then
			fwin:open(RichmanDiceGetAccess:new():init(params), fwin._view)
		end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local richman_dice_get_access_window_close_terminal = {
    _name = "richman_dice_get_access_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if  fwin:find("RichmanDiceGetAccessClass") then
            fwin:close(fwin:find("RichmanDiceGetAccessClass"))
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(richman_dice_get_access_window_open_terminal)
state_machine.add(richman_dice_get_access_window_close_terminal)
state_machine.init()

function RichmanDiceGetAccess:ctor()
    self.super:ctor()
    
    self.roots = {}

    self.diceType = 0

    -- 倒计时
    self.totalTime = 0
    self.deltaTime = 1

    app.load("client.activity.richman.RichmanTask")
    app.load("client.activity.richman.RichmanDiamondPurchaseDice")
    local function init_richman_dice_get_access_terminal()
		-- 打开角色创建窗口
		local richman_dice_get_access_open_terminal = {
			_name = "richman_dice_get_access_open",
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
		local richman_dice_get_access_close_terminal = {
			_name = "richman_dice_get_access_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("richman_dice_get_access_window_close", 0, 0)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local richman_dice_get_access_show_terminal = {
			_name = "richman_dice_get_access_show",
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
		local richman_dice_get_access_hide_terminal = {
			_name = "richman_dice_get_access_hide",
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

        -- 骰子获取途径按钮
		local richman_dice_get_access_btn_event_terminal = {
			_name = "richman_dice_get_access_btn_event",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 骰子获取途径按钮
				if nil ~= instance then
					local accessType = params._datas.accessType
                    if accessType == 1 then
                        state_machine.excute("richman_task_window_open", 0, nil)
                    elseif accessType == 2 or accessType == 4 then
                        state_machine.excute("richman_dice_get_access_jump_single_recharge", 0, nil)
                    elseif accessType == 3 then
                        state_machine.excute("richman_diamond_purchase_dice_window_open", 0, nil)
                    end
                    state_machine.excute("richman_dice_get_access_window_close", 0, nil)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

        
		-- 特惠礼包
		local richman_dice_get_access_jump_single_recharge_terminal = {
			_name = "richman_dice_get_access_jump_single_recharge",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if _ED.active_activity[152] ~= nil then
					app.load("client.activity.wonderful.ActivitySingleRecharge")
					state_machine.excute("activity_single_recharge_window_open", 0, 152)
				elseif _ED.active_activity[170] ~= nil then
                    app.load("client.activity.private_custom.PrivateCustom")
                    state_machine.excute("private_custom_window_open", 0, nil)
				elseif _ED.active_activity[145] ~= nil then
                    state_machine.excute("activity_home_recharge_return_reward_new", 0, {_datas = {_type = 145}})
				elseif _ED.active_activity[107] ~= nil then
                    state_machine.excute("activity_home_recharge_return_reward", 0, {_datas = {_type = 107}})
                elseif _ED.active_activity[178] ~= nil then
                    state_machine.excute("activity_home_recharge_return_interest", 0, {_datas = {_type = 178}})
                elseif _ED.active_activity[179] ~= nil then
                    state_machine.excute("activity_home_open_super_pack", 0, nil)
                else
                	state_machine.excute("shortcut_open_recharge_window", 0, "")
				end

				state_machine.excute("richman_main_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(richman_dice_get_access_open_terminal)
		state_machine.add(richman_dice_get_access_close_terminal)
		state_machine.add(richman_dice_get_access_show_terminal)
		state_machine.add(richman_dice_get_access_hide_terminal)
		state_machine.add(richman_dice_get_access_btn_event_terminal)
		state_machine.add(richman_dice_get_access_jump_single_recharge_terminal)
        
		state_machine.init()
	end
	-- call func init richman_reward record state machine.
	init_richman_dice_get_access_terminal()
end

function RichmanDiceGetAccess:onUpdateDraw()
    self.Panel_5:setVisible(self.diceType == 0)
    self.Panel_6:setVisible(self.diceType == 1)

    self:updateActivityRemainTime()
end

-- 对象初始化
function RichmanDiceGetAccess:init(params)
    self.diceType = params
	self._activityEndTime = _ED.active_activity[187].end_time
    return self
end

function RichmanDiceGetAccess:onUpdate(dt)
    self.totalTime = self.totalTime + dt
    if self.totalTime >= self.deltaTime then
        self:updateActivityRemainTime()
        self.totalTime = 0
    end
end

function RichmanDiceGetAccess:updateActivityRemainTime()
	if self.accessUIList ~= nil and self._activityEndTime ~= nil then
		for _, v in ipairs(self.accessUIList) do
			local surplus_time = (self._activityEndTime - ((os.time() + _ED.time_add_or_sub))*1000)
			v.text:setString(surplus_time < 0 and _string_piece_info[305] or self:drawTime(surplus_time))
		end
	end
end

function RichmanDiceGetAccess:drawTime(_time)
    local timeString = ""
    local _dayTime = math.floor((_time / 1000) / 86400)
    local _hourTime = math.floor((_time / 1000) % 86400 / 3600)
    local _minutesTime = math.floor((_time / 1000) % 86400 % 3600 / 60)
    local _secondsTime = math.floor((_time / 1000) % 60)
    if _dayTime > 0 then
        timeString = timeString .. _dayTime .._string_piece_info[231]
    end
    if _hourTime < 10 then
        timeString = timeString .. "0".._hourTime ..":"
    else
        timeString = timeString .. _hourTime ..":"
    end

    if _minutesTime < 10 then
        timeString = timeString .. "0".._minutesTime ..":"
    else
        timeString = timeString .. _minutesTime ..":"
    end

    if _secondsTime < 10 then
        timeString = timeString .. "0".._secondsTime 
    else
        timeString = timeString .. _secondsTime 
    end
    return timeString
end


function RichmanDiceGetAccess:onEnterTransitionFinish()
    local csbNode = csb.createNode("activity/dafuweng/dafuweng_tujing.csb")
	local root = csbNode:getChildByName("root")
    self:addChild(csbNode)
    table.insert(self.roots, root)

    self.accessUIList = {}
   	for i = 1, 4 do
   		local accessUI = {}
   		local str = string.format("Button_%s_1", i)
   		accessUI.button = ccui.Helper:seekWidgetByName(root, str)

   		str = string.format("Text_%s_3", i)
   		accessUI.text = ccui.Helper:seekWidgetByName(root, str)

   		fwin:addTouchEventListener(accessUI.button, nil, {
	        terminal_name = "richman_dice_get_access_btn_event",
	        terminal_state = 0,
	        isPressedActionEnabled = true,
	        accessType = i,
	    }, nil, 0)

   		table.insert(self.accessUIList, accessUI)
   	end

    -- 关闭
    self.Button_1 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, {
        terminal_name = "richman_dice_get_access_window_close",
        terminal_state = 0,
        isPressedActionEnabled = true,
    }, nil, 0)

    self.Panel_5 = ccui.Helper:seekWidgetByName(root, "Panel_5")

    self.Panel_6 = ccui.Helper:seekWidgetByName(root, "Panel_6")

    self:onUpdateDraw()
end

function RichmanDiceGetAccess:onExit()
    state_machine.remove("richman_dice_get_access_open")
	state_machine.remove("richman_dice_get_access_close")
	state_machine.remove("richman_dice_get_access_show")
	state_machine.remove("richman_dice_get_access_hide")
	state_machine.remove("richman_dice_get_access_btn_event")
    state_machine.remove("richman_dice_get_access_jump_single_recharge")
end


function RichmanDiceGetAccess:close()
	-- window event : close.
	
end

function RichmanDiceGetAccess:destroy(window)
	-- window event : destroy.
	
end
