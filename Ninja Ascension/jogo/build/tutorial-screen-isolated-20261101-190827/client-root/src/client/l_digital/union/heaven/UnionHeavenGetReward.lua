--------------------------------------------------------------------------------------------------------------
--  说明：封坛祭天领取宝箱界面
--------------------------------------------------------------------------------------------------------------
UnionHeavenGetReward = class("UnionHeavenGetRewardClass", Window)

function UnionHeavenGetReward:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union heaven get reward machine.
    local function init_union_heaven_get_reward_terminal()
		--打开界面
        local union_heaven_get_reward_open_terminal = {
            _name = "union_heaven_get_reward_open",
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
		
		--关闭界面
		local union_heaven_get_reward_close_terminal = {
            _name = "union_heaven_get_reward_close",
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
		-- 隐藏界面
        local union_heaven_get_reward_hide_event_terminal = {
            _name = "union_heaven_get_reward_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_heaven_get_reward_show_event_terminal = {
            _name = "union_heaven_get_reward_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_heaven_get_reward_refresh_terminal = {
            _name = "union_heaven_get_reward_refresh",
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
		--领取奖励 
		local union_heaven_get_reward_to_get_terminal = {
            _name = "union_heaven_get_reward_to_get",
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
		state_machine.add(union_heaven_get_reward_open_terminal)
		state_machine.add(union_heaven_get_reward_close_terminal)
		state_machine.add(union_heaven_get_reward_hide_event_terminal)
		state_machine.add(union_heaven_get_reward_show_event_terminal)
		state_machine.add(union_heaven_get_reward_refresh_terminal)
		state_machine.add(union_heaven_get_reward_to_get_terminal)
        state_machine.init()
    end
    
    -- call func init union heaven get reward machine.
    init_union_heaven_get_reward_terminal()

end

function UnionHeavenGetReward:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionHeavenGetReward:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionHeavenGetReward:updateDraw()

end

function UnionHeavenGetReward:onInit()
	self:updateDraw()
end

function UnionHeavenGetReward:onEnterTransitionFinish()

end

function UnionHeavenGetReward:init()
	self:onInit()
	return self
end

function UnionHeavenGetReward:onExit()
	state_machine.remove("union_heaven_get_reward_open")
	state_machine.remove("union_heaven_get_reward_close")
	state_machine.remove("union_heaven_get_reward_hide_event")
	state_machine.remove("union_heaven_get_reward_show_event")
	state_machine.remove("union_heaven_get_reward_refresh")
	state_machine.remove("union_heaven_get_reward_to_get")
end