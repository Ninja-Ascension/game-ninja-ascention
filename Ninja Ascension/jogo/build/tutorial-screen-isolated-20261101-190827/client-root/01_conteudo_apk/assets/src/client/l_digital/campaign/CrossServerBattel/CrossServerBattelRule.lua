-- ----------------------------------------------------------------------------------------------------
-- 说明：跨服矿战规则界面
-------------------------------------------------------------------------------------------------------
CrossServerBattelRule = class("CrossServerBattelRuleClass", Window)

local cross_server_battel_rule_window_open_terminal = {
    _name = "cross_server_battel_rule_window_open",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:open(CrossServerBattelRule:new(), fwin._view)
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local cross_server_battel_rule_window_close_terminal = {
    _name = "cross_server_battel_rule_window_close",
    _init = function (terminal) 
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params) 
    	fwin:close(fwin:find("CrossServerBattelRuleClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(cross_server_battel_rule_window_open_terminal)
state_machine.add(cross_server_battel_rule_window_close_terminal)
state_machine.init()


function CrossServerBattelRule:ctor()
    self.super:ctor()
    self.roots = {}
	self._armature = nil

	-- load lua file
	app.load("client.l_digital.campaign.arena.ArenaPoint")
	app.load("client.l_digital.campaign.arena.ArenaAchieveReward")
    app.load("client.l_digital.cells.arena.arena_ladder_seat_cell")
	
    -- Initialize Arena page state machine.
    local function init_cross_server_battel_open_terminal()
		local cross_server_battel_map_terminal = {
		    _name = "cross_server_battel_open",
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

		state_machine.add(cross_server_battel_map_terminal)
		state_machine.init()
	end

	init_cross_server_battel_open_terminal()
end

function CrossServerBattelRule:onUpdate(dt)
end

function CrossServerBattelRule:onUpdateDraw()
end

function CrossServerBattelRule:onEnterTransitionFinish()
    local csbNode = csb.createNode("campaign/cross_service/cross_service_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbNode)

    -- 关闭窗口
    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule_closed"), nil, 
    {
        terminal_name = "cross_server_battel_rule_window_close", 
        isPressedActionEnabled = true
    },
    nil,0)
end

function CrossServerBattelRule:init()
end

function CrossServerBattelRule:onExit()
end