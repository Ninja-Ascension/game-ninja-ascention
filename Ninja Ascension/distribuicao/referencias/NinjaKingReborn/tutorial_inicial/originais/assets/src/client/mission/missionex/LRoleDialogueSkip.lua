






LRoleDialogueSkip = class("LRoleDialogueSkipClass", Window)

function LRoleDialogueSkip:ctor()
    self.super:ctor()

	self.roots = {}

	self.eventIndex = nil
	self.nexteventIndex = 0
	self.mission = nil
	self.missions = nil
    local function init_LRoleDialogueSkip_terminal()
		local lroledialogue_skip_terminal = {
            _name = "lroledialogue_skip",
            _init = function (terminal)

            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
            		executeNextEvent()
            		return
            	end
            	if self.nexteventIndex == 0 then
            		return
            	end
				for i=1,self.nexteventIndex do
					state_machine.excute("role_dialogue_touch",0,"")
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(lroledialogue_skip_terminal)
        state_machine.init()
    end

    init_LRoleDialogueSkip_terminal()
end

function LRoleDialogueSkip:init(eventIndex,mission,missions)
	self.eventIndex = eventIndex
	self.mission = mission
	self.missions = missions
	self:onInit()
end

function LRoleDialogueSkip:onEnterTransitionFinish()
	local csbCGSkip = csb.createNode("events_interpretation/events_skip_lhm.csb")
	self:addChild(csbCGSkip)
	local root = csbCGSkip:getChildByName("root")
	table.insert(self.roots, root)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),nil,
	{
		terminal_name = "lroledialogue_skip",
		terminal_state = 0,
		isPressedActionEnabled = true,
	},
	nil,0)
end
function LRoleDialogueSkip:onInit()
	local counts = #self.missions
	local nexteventIndex = 0
	for i=self.eventIndex,counts do
		if dms.atoi(self.missions[i],mission_param.mission_skip_id) == 1 then
			nexteventIndex = nexteventIndex + 1
		elseif dms.atoi(self.missions[i],mission_param.mission_skip_id) == 0 then
			break
		end
	end
	self.nexteventIndex = nexteventIndex
end

function LRoleDialogueSkip:onExit()
	state_machine.remove("lroledialogue_skip")
end