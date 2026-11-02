-- ----------------------------------------------------------------------------------------------------
-- 说明：宠物副本帮助
-------------------------------------------------------------------------------------------------------

BattleFieldHelp = class("BattleFieldHelpClass", Window)
   
local battle_field_help_window_open_terminal = {
    _name = "battle_field_help_window_open",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        if nil == fwin:find("BattleFieldHelpClass") then
        	
        	local helpWindow = BattleFieldHelp:new()
			helpWindow:init()
			fwin:open(helpWindow, fwin._dialog)
        end
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

local battle_field_help_window_close_terminal = {
    _name = "battle_field_help_window_close",
    _init = function (terminal)
        
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        fwin:close(fwin:find("BattleFieldHelpClass"))
        return true
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(battle_field_help_window_open_terminal)
state_machine.add(battle_field_help_window_close_terminal)
state_machine.init()
  
function BattleFieldHelp:ctor()
    self.super:ctor()
	self.roots = {}
	self.actions = {}
	
    -- Initialize Home page state machine.
    local function init_battle_field_help_terminal()
        --确定升级
        local battle_field_help_streng_terminal = {
            _name = "battle_field_help_streng",
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

		state_machine.add(battle_field_help_streng_terminal)
        state_machine.init()
    end
    
    init_battle_field_help_terminal()
end

function BattleFieldHelp:onUpdateDraw()
	local root = self.roots[1]
	if root == nil then 
		return
	end
end

function BattleFieldHelp:onEnterTransitionFinish()
	self.roots = {}
    local csbEquipInformation = csb.createNode("campaign/BattleField/BattleField_help.csb")
    self:addChild(csbEquipInformation)
	local root = csbEquipInformation:getChildByName("root")
	table.insert(self.roots, root)

	local action = csb.createTimeline("campaign/BattleField/BattleField_help.csb")
    table.insert(self.actions, action)
    csbEquipInformation:runAction(action)
    action:play("window_open", false)
	self:onUpdateDraw()

	--返回按钮
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_close"), nil, 
	{
		terminal_name = "battle_field_help_window_close",
		terminal_state = 0, 
		isPressedActionEnabled = true,
		_self = self,
	},
	nil,0)
end

function BattleFieldHelp:onExit()
end

function BattleFieldHelp:init()
	
end
