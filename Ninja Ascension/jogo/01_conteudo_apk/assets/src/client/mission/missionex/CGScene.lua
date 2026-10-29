-- ----------------------------------------------------------------------------------------------------
-- 说明：CG场景
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CGScene = class("CGSceneClass", Window)

function CGScene:ctor()
    self.super:ctor()
	
	self.roots = {}
	
	self.mission = nil
	
	self.CG_index = nil --	当前CG索引
	self.bgm = nil		--	背景音乐
	self.noise = nil	--	场景声音（打斗、环境音）
	
	self.CG_group = {
		{1},
		{8,9,10},
	}
	
    local function init_CGScene_terminal()
		local CG_scene_event_over_terminal = {
            _name = "CG_scene_event_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	-- saveExecuteEvent(params.mission, true)
                fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local CG_scene_event_skip_next_terminal = {
            _name = "CG_scene_event_skip_next",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:sikpNextEvent()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        local CG_scene_event_stop_video_terminal = {
            _name = "CG_scene_event_stop_video",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.videoPlayer ~= nil then
                	-- instance.videoPlayer:stop()
                	-- instance.videoPlayer = nil
                	state_machine.excute("CG_scene_event_over", 0, 0)
                end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(CG_scene_event_skip_next_terminal)
		state_machine.add(CG_scene_event_over_terminal)
		state_machine.add(CG_scene_event_stop_video_terminal)
        state_machine.init()
    end
    
    init_CGScene_terminal()
end

function CGScene:init(current_mission)
	self.mission = current_mission
	self.CG_index = dms.atoi(self.mission, mission_param1)
	self.bgm = dms.atos(self.mission, mission_param2)		--	背景音乐
	self.noise = dms.atos(self.mission, mission_param3) 	--	场景声音（打斗、环境音）
end

local changeAction_animationEventCallFunc_cg = function(armatureBack,movementType,movementID)
	local id = movementID
	if armatureBack._changing == nil then
		armatureBack._changing = true
		if armatureBack._nextAction ~= nil and armatureBack._actionIndex ~= armatureBack._nextAction then
			armatureBack._actionIndex = armatureBack._nextAction
			armatureBack._actionLoopCount = 0
			armatureBack:getAnimation():playWithIndex(armatureBack._nextAction)
		end
		if armatureBack._nextFunc ~= nil 
			and armatureBack._nextFunc ~= changeAction_animationEventCallFunc  then
			armatureBack:getAnimation():setMovementEventCallFunc(armatureBack._nextFunc)
		end 
		armatureBack._changing = nil
		
		if armatureBack._invoke ~= nil then
			armatureBack._invoke(armatureBack)
		end
	end
	if armatureBack._actionLoopCount ~= nil then
		armatureBack._actionLoopCount = armatureBack._actionLoopCount + 1
	end
end

-- 加载光效资源文件
local loadEffectFile_CG = function(fileName)
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(fileName)
end

local deleteEffect_CG = function(armatureBack)
	if armatureBack == nil then
		return
	end
	
	if armatureBack._LastsCountTurns > 0 then
		-- 删除光效
		armatureBack._LastsCountTurns = armatureBack._LastsCountTurns == nil and 0 or armatureBack._LastsCountTurns - 1
		if armatureBack._LastsCountTurns <= 0 then
			local fileName = armatureBack._fileName
			armatureBack:removeFromParent(true)
			-- 删除光效文件
			ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(fileName)
		end
	end
	
	local CGSceneWnd = fwin:find("CGSceneClass")
	CGSceneWnd.play_index = CGSceneWnd.play_index + 1
	if CGSceneWnd.play_index <= #CGSceneWnd.CG_group[CGSceneWnd.CG_index] then
		CGSceneWnd:playCG(CGSceneWnd.CG_group[CGSceneWnd.CG_index][CGSceneWnd.play_index])
	else	
		state_machine.excute("CG_scene_event_over", 0, "")
	end
end

local createEffect_CG = function(armatureName, armatureFile, armaturePad, loop, ZOrder, actionTimeSpeed)
	loadEffectFile_CG(armatureFile)
	local armature = ccs.Armature:create(armatureName)
	armature._fileName = armatureFile
	armature._invoke = deleteEffect_CG
	armature._actionIndex = 0
	armature._nextAction = 0
	if loop ~= nil and loop > 0 then
		armature._LastsCountTurns = loop
	else
		armature._LastsCountTurns = -1
	end
	
	if ZOrder ~= nil then
		armaturePad:addChild(armature, ZOrder)
	else
		armaturePad:addChild(armature)
	end
	if actionTimeSpeed ~= nil and actionTimeSpeed > 0 then
		armature:getAnimation():setSpeedScale(1.0/actionTimeSpeed)
	end
	armature:setPosition(cc.p(armaturePad:getContentSize().width/2, armaturePad:getContentSize().height/2))
	armature:getAnimation():playWithIndex(0)
	armature:getAnimation():setMovementEventCallFunc(changeAction_animationEventCallFunc_cg)
	return armature
end

function CGScene:sikpNextEvent()
	self.play_index = self.play_index + 1
	self:playCG(self.play_index)
end


function CGScene:playCG(_index)
	local root = self.roots[1]
	
	local panel_cg = ccui.Helper:seekWidgetByName(root, "Panel_cg_1")
	createEffect_CG(string.format("effice_cg_%d", _index), 
					string.format("images/ui/effice/effice_cg_%d/effice_cg_%d.ExportJson", _index, _index), 
					panel_cg, 1, 100)
end

function CGScene:onEnterTransitionFinish()
	local csbCGScene = csb.createNode("events_interpretation/events_interpretation_1.csb")
	self:addChild(csbCGScene)
	local root = csbCGScene:getChildByName("root")
	table.insert(self.roots, root)
	
	self.play_index = 1
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if tonumber(self.CG_index) == 0 then
			-- 停止视频
			local Panel_close_mp4 = ccui.Helper:seekWidgetByName(root, "Panel_close_mp4")
			if Panel_close_mp4 ~= nil then
				Panel_close_mp4:setVisible(true)
				fwin:addTouchEventListener(Panel_close_mp4, nil, 
				{
					terminal_name = "CG_scene_event_stop_video", 
			        terminal_state = 0, 
			        isPressedActionEnabled = false
				}, 
				nil, 0)
			end
			self.cgvnmae = dms.atos(self.mission, mission_param4)
			-- drawVideoFullPath("video/" .. self.cgvnmae .. ".mp4",1,self,"CG_scene_event_over")

			-- cc.SimpleAudioEngine:getInstance():end()
			-- ccexp.AudioEngine:end()

			stopBgm()
			stopEffect()
			stopAllEffects()

			fwin:addService({
				callback = function ( params )
					drawVideoFullPath("video/" .. params.cgvnmae .. ".mp4",1, params,"CG_scene_event_over")
				end,
				delay = 0.01,
				params = self
			})
			return
		end
	end
	self:playCG(self.CG_group[self.CG_index][self.play_index])
end

function CGScene:onExit()
	againPlayBgm()
	saveExecuteEvent(self.mission, true)
	state_machine.remove("CG_scene_event_over")
	state_machine.remove("CG_scene_event_skip_next")
end