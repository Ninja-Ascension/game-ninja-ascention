-- ----------------------------------------------------------------------------------------------------
-- 说明：开场CG跳过
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CGEventSkipNext = class("CGEventSkipNextClass", Window)

function CGEventSkipNext:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.mission = nil
	
    local function init_CGEventSkipNext_terminal()
		local CG_scene_event_skip_next_btn_terminal = {
            _name = "CG_scene_event_skip_next_btn",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if __lua_project_id == __lua_project_warship_girl_a 
					or __lua_project_id == __lua_project_warship_girl_b 
					or __lua_project_id == __lua_project_digimon_adventure 
					or __lua_project_id == __lua_project_naruto 
					or __lua_project_id == __lua_project_pokemon 
					or __lua_project_id == __lua_project_rouge 
					or __lua_project_id == __lua_project_yugioh 
					or __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim
					then
					if _ED.user_info.user_id == nil or _ED.user_info.user_id == "" then
						resetMission()
						fwin:removeAll()
						state_machine.excute("login_character_create", 0, "login_character_create.")
					else	
						local index = instance.skipIndex - instance.eventIndex
						changeExecuteEvent(instance.eventIndex)
						state_machine.excute("CG_scene_event_over", 0, "")
					end
				else	
					local index = instance.skipIndex - instance.eventIndex
					changeExecuteEvent(instance.eventIndex)
					state_machine.excute("CG_scene_event_over", 0, "")
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(CG_scene_event_skip_next_btn_terminal)
        state_machine.init()
    end
    
    init_CGEventSkipNext_terminal()
end

function CGEventSkipNext:init(eventIndex,skipIndex)
	self.eventIndex = eventIndex
	self.skipIndex = skipIndex
end

function CGEventSkipNext:onEnterTransitionFinish()
	local csbCGEventSkipNext = csb.createNode("events_interpretation/events_cg_tiaoguo.csb")
	self:addChild(csbCGEventSkipNext)
	local root = csbCGEventSkipNext:getChildByName("root")
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_3"),nil, 
	{
		terminal_name = "CG_scene_event_skip_next_btn", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, 
	nil,0)
end

function CGEventSkipNext:onExit()
	state_machine.remove("CG_scene_event_skip_next_btn")
end