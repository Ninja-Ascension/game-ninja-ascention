-----------------------------

SmCultivateArtifactHelp = class("SmCultivateArtifactHelpClass", Window)

local sm_cultivate_artifact_help_open_terminal = {
	_name = "sm_cultivate_artifact_help_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("SmCultivateArtifactHelpClass") == nil then
			fwin:open(SmCultivateArtifactHelp:new():init(params), fwin._ui)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

local sm_cultivate_artifact_help_close_terminal = {
	_name = "sm_cultivate_artifact_help_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SmCultivateArtifactHelpClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(sm_cultivate_artifact_help_open_terminal)
state_machine.add(sm_cultivate_artifact_help_close_terminal)
state_machine.init()

function SmCultivateArtifactHelp:ctor()
	self.super:ctor()
	self.roots = {}
end

function SmCultivateArtifactHelp:onUpdateDraw( ... )
    -- body
end

function SmCultivateArtifactHelp:init(params)
	self:onInit()
    return self
end

function SmCultivateArtifactHelp:onInit()
    local csbItem = csb.createNode("cultivate/cultivate_artifact_help.csb")
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)

    fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root,"Button_closed"), nil, 
    {
        terminal_name = "sm_cultivate_artifact_help_close", 
        terminal_state = 0, 
        touch_black = true,
    }, nil, 3)

	self:onUpdateDraw()
end

function SmCultivateArtifactHelp:onEnterTransitionFinish()
end

function SmCultivateArtifactHelp:onExit()
end
