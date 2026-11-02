--大师训练营规则界面
TrainigCampRule = class("TrainigCampRuleClass", Window)

local training_camp_rule_open_terminal = {
	_name = "training_camp_rule_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("TrainigCampRuleClass") == nil then
			fwin:open(TrainigCampRule:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local training_camp_rule_close_terminal = {
	_name = "training_camp_rule_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("TrainigCampRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(training_camp_rule_open_terminal)
state_machine.add(training_camp_rule_close_terminal)
state_machine.init()

function TrainigCampRule:ctor()
	self.super:ctor()
	self.roots = {}
end

function TrainigCampRule:onUpdateDraw()
    
end


function TrainigCampRule:onUpdate(dt)
  
end

function TrainigCampRule:init(params)
	self:onInit()
    return self
end

function TrainigCampRule:onInit()
    local csbItem = csb.createNode("activity/wonderful/training_camp_rule.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_back"), nil,  --关闭
    {
        terminal_name = "training_camp_rule_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

    --self:onUpdateDraw()

end

function TrainigCampRule:onEnterTransitionFinish()
end

function TrainigCampRule:onExit()
	-- state_machine.remove("egg_machine_window_update_draw")
	-- state_machine.remove("egg_machine_window_recruiting")
end

