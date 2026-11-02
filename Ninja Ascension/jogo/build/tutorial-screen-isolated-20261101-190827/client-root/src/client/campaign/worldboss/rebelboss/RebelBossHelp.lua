-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军BOSS帮助
-------------------------------------------------------------------------------------------------------

RebelBossHelp = class("RebelBossHelpClass", Window)
   
local rebel_boss_help_window_open_terminal = {
    _name = "rebel_boss_help_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RebelBossHelpClass") then
        	
        	local helpWindow = RebelBossHelp:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local rebel_boss_help_window_close_terminal = {
    _name = "rebel_boss_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("RebelBossHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_boss_help_window_open_terminal)
state_machine.add(rebel_boss_help_window_close_terminal)
state_machine.init()
  
function RebelBossHelp:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
    -- Initialize Home page state machine.
    local function init_rebel_boss_help_terminal()
        
    end
    
    init_rebel_boss_help_terminal()
end

function RebelBossHelp:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    
end

function RebelBossHelp:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/WorldBoss/wordBoss_help_2.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_help_2.csb")
    table.insert(self.actions, action)
    csbEquipInformation:runAction(action)
    action:play("window_open", false)
	--self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_105"), nil, 
	{
		terminal_name = "rebel_boss_help_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)
end

function RebelBossHelp:onExit()
end

function RebelBossHelp:init()
	
end
