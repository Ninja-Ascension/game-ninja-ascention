-- ----------------------------------------------------------------------------------------------------
-- 说明：等待进入下一个事件
-------------------------------------------------------------------------------------------------------
WaitCD = class("WaitCDClass", Window)

local wait_cd_window_open_terminal = {
	_name = "wait_cd_window_open",
	_init = function (terminal) 
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("WaitCDClass"))
		fwin:open(WaitCD:new():init(params[1], params[2]), fwin._ui)
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
local wait_cd_window_close_terminal = {
	_name = "wait_cd_window_close",
	_init = function (terminal) 
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("WaitCDClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}	
state_machine.add(wait_cd_window_open_terminal)
state_machine.add(wait_cd_window_close_terminal)
state_machine.init()

function WaitCD:ctor()
    self.super:ctor()
	self.roots = {}
	self.mission = nil
	self.begin_time = os.time()
	self.interval = 0
	self.elapsed = 0
	self.stepIndex = 0
end

function WaitCD:init(current_mission, _interval)
	self.mission = current_mission
	self.interval = _interval or 0
	return self
end

function WaitCD:onUpdate(dt)
	if self._fury_hecho == true then return end -- Fury 4-oct: Mission la dio por terminada (executeNextRoundBattleEvent)
	self.elapsed = os.time() - self.begin_time
	if self.stepIndex > 0 then
		if self.interval < self.elapsed then
			if self.mission ~= nil then
				-- saveExecuteEvent(self.mission, true)
				-- self.mission = nil
				self:removeAllChildren(true)
				--fwin:close(self)
				fwin:addService({
	                callback = function ( params )
	                	if self._fury_hecho == true then return end
	                	state_machine.excute("wait_cd_window_close", 0, 0)
						saveExecuteEvent(params, true)
	                end,
	                params = self.mission
	            })
				return
			end
		end
	end
	self.stepIndex = self.stepIndex + 1
end

function WaitCD:onEnterTransitionFinish()
	-- self:setTouchEnabled(true)
	self.stepIndex = 0

	local csbWaitCD = csb.createNode("events_interpretation/events_cg_wait.csb")
	self:addChild(csbWaitCD)
	local root = csbWaitCD:getChildByName("root")
	table.insert(self.roots, root)
end

function WaitCD:onExit()

end