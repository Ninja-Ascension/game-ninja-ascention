-- ----------------------------------------------------------------------------------------------------
-- 说明：花费确认通用框
-------------------------------------------------------------------------------------------------------
ExpendConfirm = class("ExpendConfirmClass", Window)

function ExpendConfirm:ctor()
    self.super:ctor()
    self.roots = {}
    self.actions = {}
    self.interfaceType = 0
    self.params = nil --附带参数

	self._enum_type = {
		_MINE_PATROL_TYPE = 1, --巡逻双倍奖励花费
        --后面添加类型

	}

    -- -- Initialize recharge tip dialog state machine.
    local function init_expend_confirm_terminal()
        local expend_confirm_close_terminal = {
            _name = "expend_confirm_close",
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

        --巡逻双倍奖励
        local expend_confirm_buy_patrol_terminal = {
            _name = "expend_confirm_buy_patrol",
            _init = function (terminal) 
            
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)

				local function responseGetRewardDoubleCallback(response)
                    if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
                        if response.node ~= nil and response.node.roots[1] ~= nil then 
                            state_machine.excute("mine_manager_manor_patrol_get_reward_double_update", 0, "")
                        end
                    end
                    state_machine.excute("expend_confirm_close", 0, "")
                end
                protocol_command.manor_double_reward.param_list = self.params.patrolId .."\r\n"
                NetworkManager:register(protocol_command.manor_double_reward.code, nil, nil, nil, instance, responseGetRewardDoubleCallback,false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        state_machine.add(expend_confirm_close_terminal)
        state_machine.add(expend_confirm_buy_patrol_terminal)
        
        state_machine.init()
    end
    
    -- -- call func init recharge tip dialog state machine.
    init_expend_confirm_terminal()
end

function ExpendConfirm:onUpdateDraw()
    local root = self.roots[1]

    -- -- 需要消耗的宝石数
    ccui.Helper:seekWidgetByName(root, "Text_2_0_0"):setString(""..self.needGold)
    -- -- 功能提示
    if self.interfaceType == self._enum_type._MINE_PATROL_TYPE then
         -- -- 请求购买
        fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_103_0"),       nil, 
        {
            terminal_name = "expend_confirm_buy_patrol",       
            terminal_state = 0, 
            isPressedActionEnabled = true
        }, 
        nil, 0)
    end
end

function ExpendConfirm:init(interfaceType, needGold,params)
	self.interfaceType = interfaceType
	self.needGold = needGold
    self.params = params
	return self
end

function ExpendConfirm:onEnterTransitionFinish()
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
        terminal_name = "expend_confirm_close",       
        terminal_state = 0, 
        isPressedActionEnabled = true
    }, 
    nil, 2)
end

function ExpendConfirm:onExit()
    state_machine.remove("expend_confirm_close")
	state_machine.remove("expend_confirm_buy_patrol")
end