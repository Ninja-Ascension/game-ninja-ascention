-----------------------------
-- 一键试炼提示的界面
-----------------------------
SmTrialTowerRweepTip = class("SmTrialTowerRweepTipClass", Window)

--打开界面
local sm_trial_tower_rweep_tip_open_terminal = {
	_name = "sm_trial_tower_rweep_tip_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmTrialTowerRweepTipClass") == nil then
			fwin:open(SmTrialTowerRweepTip:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local sm_trial_tower_rweep_tip_close_terminal = {
	_name = "sm_trial_tower_rweep_tip_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmTrialTowerRweepTipClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_trial_tower_rweep_tip_open_terminal)
state_machine.add(sm_trial_tower_rweep_tip_close_terminal)
state_machine.init()

function SmTrialTowerRweepTip:ctor()
	self.super:ctor()
	self.roots = {}
    self.actions = {}

    local function init_sm_trial_tower_rweep_tip_terminal()
        --
        local sm_ranking_union_view_the_first_place_terminal = {
            _name = "sm_ranking_union_view_the_first_place",
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

        state_machine.add(sm_ranking_union_view_the_first_place_terminal)

        state_machine.init()
    end
    init_sm_trial_tower_rweep_tip_terminal()
end

function SmTrialTowerRweepTip:updateDraw()
	local root = self.roots[1]

end

function SmTrialTowerRweepTip:init(params)
	self:onInit()
    return self
end

function SmTrialTowerRweepTip:onInit()
    local csbItem = csb.createNode("campaign/TrialTower/sm_trial_tower_rweep_tip.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    local action = csb.createTimeline("campaign/TrialTower/sm_trial_tower_rweep_tip.csb")
    table.insert(self.actions, action)
    csbItem:runAction(action)
    -- action:gotoFrameAndPlay(0, action:getDuration(), false)
    action:play("window_open", false)

	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_cancel"), nil, 
    {
        terminal_name = "sm_trial_tower_rweep_tip_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	
	--关闭
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_close"), nil, 
    {
        terminal_name = "sm_trial_tower_rweep_tip_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)
	
	self:updateDraw()
end

function SmTrialTowerRweepTip:onEnterTransitionFinish()
    
end


function SmTrialTowerRweepTip:onExit()
    state_machine.remove("sm_trial_tower_rweep_tip_change_page")
	state_machine.remove("sm_trial_tower_rweep_tip_open_rank")
end

