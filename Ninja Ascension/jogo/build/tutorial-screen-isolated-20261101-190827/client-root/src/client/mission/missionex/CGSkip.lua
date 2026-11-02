-- ----------------------------------------------------------------------------------------------------
-- 说明：CG跳过
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CGSkip = class("CGSkipClass", Window)

function CGSkip:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.mission = nil
	
    local function init_CGSkip_terminal()
		local CG_scene_skip_terminal = {
            _name = "CG_scene_skip",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	if __lua_project_id == __lua_project_red_alert_time or __lua_project_id == __lua_project_pacific_rim then
            		-- fwin:removeAll()
            		local skipnext1 = fwin:find("CGSkipClass")
					if skipnext1 ~= nil then 
						fwin:close(skipnext1)
					end
            		fwin:close(fwin:find("WindowLockClass"))
            		-- state_machine.excute("events_teaching_skip_exit", 0, 0)
                    -- cacher.cleanSystemCacher()
                    cacher.removeAllTextures()
                    -- executeResetCurrentEvent(true)
    				stopEffect()
					stopAllEffects()
					cc.SimpleAudioEngine:getInstance():stopAllEffects()
					executeNextEvent(nil, false)
				else
					fwin:removeAll()
					resetMission()
					if __lua_project_id ~= __lua_project_red_alert 
						and __lua_project_id ~= __lua_project_red_alert_time
						then
						state_machine.excute("login_character_create", 0, "login_character_create.")
					else
						local skipnext1 = fwin:find("CGSkipClass")
						if skipnext1 ~= nil then 
							fwin:close(skipnext1)
						end
						if MissionClass._fristFightEnd == false then
							MissionClass._fristFightEnd = true
					        _ED._current_scene_id = "1"
					        _ED._scene_npc_id = "576"
					        _ED._npc_difficulty_index = "1"
					        _ED._attacker_npc_id = "577"
					        app.load("client.red_alert.battle.battle_enum")
							app.load("client.red_alert.battle.battle_loading")
							_ED._battle_init_type = battle_enum._fight_type._fight_type_20
					        state_machine.excute("battle_loading_window_open",0,battle_enum._fight_type._fight_type_20)
						else
							app.load("client.red_alert.login.CampChose")
		        			state_machine.excute("camp_chose_window_open",0,"")
						end
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(CG_scene_skip_terminal)
        state_machine.init()
    end
    
    init_CGSkip_terminal()
end

-- function CGSkip:init(current_mission)
	-- self.mission = current_mission
-- end

function CGSkip:init(eventIndex,skipIndex)
	self.eventIndex = eventIndex
	self.skipIndex = skipIndex
end

function CGSkip:onEnterTransitionFinish()
	local csbCGSkip = csb.createNode("events_interpretation/events_skip.csb")
	self:addChild(csbCGSkip)
	local root = csbCGSkip:getChildByName("root")
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1"),nil, 
	{
		terminal_name = "CG_scene_skip", 	
		terminal_state = 0, 
		isPressedActionEnabled = true,
	}, 
	nil,0)
end

function CGSkip:onExit()
	state_machine.remove("CG_scene_skip")
end