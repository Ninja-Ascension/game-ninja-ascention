-- ----------------------------------------------------------------------------------------------------
-- 说明：PVE日常副本购买次数
-------------------------------------------------------------------------------------------------------
PVEGameActivityBuyCount = class("PVEGameActivityBuyCountClass", Window)

function PVEGameActivityBuyCount:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.interfaceType = 0

    self.residualCount = 0          -- 剩余的可购买次数
	self.state_machine_info = nil

	self._enum_type = {
		_RESET_ATTACK_COUNT_PLOT_COPY_NPC = 1  		-- PVE日常副本购买次数
	}

    -- -- Initialize recharge tip dialog state machine.
    local function init_recharge_tip_dialog_terminal()
        local pve_game_activity_buy_times_dialog_close_terminal = {
            _name = "pve_game_activity_buy_times_dialog_close",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                instance.actions[1]:play("window_close", false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_game_activity_buy_times_dialog_cancel_terminal = {
            _name = "pve_game_activity_buy_times_dialog_cancel",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("pve_game_activity_buy_times_dialog_close", 0, "")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local pve_game_activity_buy_times_dialog_confirm_terminal = {
            _name = "pve_game_activity_buy_times_dialog_confirm",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                local t_self = params._datas._self
                if zstring.tonumber(t_self.needGold) > zstring.tonumber(_ED.user_info.user_gold) then
                -- 提示宝石不足,去充值
                -- 提示购买
                    state_machine.excute("shortcut_open_function_dailog_cancel_and_ok", 0, 
                    {
                        terminal_name = "shortcut_open_recharge_window", 
                        terminal_state = 0, 
                        _msg = _string_piece_info[273], 
                        _datas= 
                        {

                        }
                    })
                else
    				local function responseBattleInitCallback(response)
    					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
    						app.load("client.duplicate.pve.PVEDailyActivityCopy")

                           state_machine.excute("pve_game_activity_buy_times_dialog_close", 0, "")
                           state_machine.excute("pve_daily_activity_copy_updata", 0, "")
    					end
    				end
                	protocol_command.basic_consumption.param_list = "53\r\n0\r\n0"
    				NetworkManager:register(protocol_command.basic_consumption.code, nil, nil, nil, nil, responseBattleInitCallback, false, nil)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(pve_game_activity_buy_times_dialog_close_terminal)
        state_machine.add(pve_game_activity_buy_times_dialog_cancel_terminal)
        state_machine.add(pve_game_activity_buy_times_dialog_confirm_terminal)
        state_machine.init()
    end
    
    -- -- call func init recharge tip dialog state machine.
    init_recharge_tip_dialog_terminal()
end

function PVEGameActivityBuyCount:onUpdateDraw()
    local root = self.roots[1]

    -- -- 需要消耗的宝石数
    ccui.Helper:seekWidgetByName(root, "Text_2_0_0"):setString(""..self.needGold)
    -- -- 功能提示
    if self.interfaceType == self._enum_type._RESET_ATTACK_COUNT_PLOT_COPY_NPC then
        ccui.Helper:seekWidgetByName(root, "Text_2_0"):setString("".._string_piece_info[374])
    end

    -- -- 今日可购买的次数
    local tipString = _string_piece_info[69]
    if self.residualCount < 10 then
        tipString = tipString .. " " .. self.residualCount .. " "
    else
       tipString = tipString .. self.residualCount
    end
    tipString = tipString .. _string_piece_info[251]
    ccui.Helper:seekWidgetByName(root, "Text_6"):setString(tipString)
end

function PVEGameActivityBuyCount:init(interfaceType, needGold, residualCount, state_machine_info)
	self.interfaceType = interfaceType
	self.needGold = needGold
    self.residualCount = residualCount
	self.state_machine_info = state_machine_info
	
	return self
end

function PVEGameActivityBuyCount:onEnterTransitionFinish()
	local csbPVEGameActivityBuyCount = csb.createNode("utils/prompted.csb")
    local root = csbPVEGameActivityBuyCount:getChildByName("root")
    table.insert(self.roots, root)

    local action = csb.createTimeline("utils/prompted.csb")
    table.insert(self.actions, action )
    csbPVEGameActivityBuyCount:runAction(action)
   
    action:setFrameEventCallFunc(function (frame)
        if nil == frame then
            return
        end

        local str = frame:getEvent()
        if str == "open" then
        elseif str == "close" then
        	fwin:close(self)
        end
    end)
    action:play("window_open", false)

    self:addChild(csbPVEGameActivityBuyCount)

    self:onUpdateDraw()

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103"),       nil, 
    {
        terminal_name = "pve_game_activity_buy_times_dialog_cancel",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)

    -- -- 请求购买
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_0"),       nil, 
    {
        terminal_name = "pve_game_activity_buy_times_dialog_confirm",       
        terminal_state = 0, 
        isPressedActionEnabled = true,
        _self = self
    }, 
    nil, 0)
end

function PVEGameActivityBuyCount:onExit()
    state_machine.remove("pve_game_activity_buy_times_dialog_close_terminal")
	state_machine.remove("pve_game_activity_buy_times_dialog_cancel_terminal")
	state_machine.remove("pve_game_activity_buy_times_dialog_confirm_terminal")
end