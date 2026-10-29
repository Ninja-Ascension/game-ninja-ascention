-- ----------------------------------------------------------------------------------------------------
-- 说明：叛军BOSS战报
-------------------------------------------------------------------------------------------------------

RebelBossBattleReport = class("RebelBossBattleReportClass", Window)
   
local rebel_boss_help_window_open_terminal = {
    _name = "rebel_boss_help_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("RebelBossBattleReportClass") then
        	
        	local helpWindow = RebelBossBattleReport:new()
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
        fwin:close(fwin:find("RebelBossBattleReportClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(rebel_boss_help_window_open_terminal)
state_machine.add(rebel_boss_help_window_close_terminal)
state_machine.init()
  
function RebelBossBattleReport:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
    -- Initialize Home page state machine.
    local function init_rebel_boss_help_terminal()
        
    end
    
    init_rebel_boss_help_terminal()
end

function RebelBossBattleReport:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
    local phPanel = ccui.Helper:seekWidgetByName(root, "Panel_wks")
    phPanel:setVisible(false)
end

function RebelBossBattleReport:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/WorldBoss/wordBoss_zhanbao.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("campaign/WorldBoss/wordBoss_zhanbao.csb")
    table.insert(self.actions, action)
    csbEquipInformation:runAction(action)
    action:play("window_open", false)
	self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"), nil, 
	{
		terminal_name = "rebel_boss_help_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)
end

function RebelBossBattleReport:onExit()
end

function RebelBossBattleReport:init()
	
end
