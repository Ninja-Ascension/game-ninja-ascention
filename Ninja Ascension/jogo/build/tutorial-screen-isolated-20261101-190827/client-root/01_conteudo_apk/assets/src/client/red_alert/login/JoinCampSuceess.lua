-----------------------------
--加入阵营
-----------------------------
JoinCampSuceess = class("JoinCampSuceessClass", Window)

--打开界面
local join_camp_suceess_window_open_terminal = {
	_name = "join_camp_suceess_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if fwin:find("JoinCampSuceessClass") == nil then
			fwin:open(JoinCampSuceess:new():init(), fwin._windows)		
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

--关闭界面
local join_camp_suceess_window_close_terminal = {
	_name = "join_camp_suceess_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("JoinCampSuceessClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}
state_machine.add(join_camp_suceess_window_open_terminal)
state_machine.add(join_camp_suceess_window_close_terminal)
state_machine.init()

function JoinCampSuceess:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}
end

function JoinCampSuceess:init()
	self:onInit()
    return self
end

--初始化界面
function JoinCampSuceess:onInit()
    local csbItem = csb.createNode(config_csb.login.camp_chose_join)
    local root = csbItem:getChildByName("root")
    self:addChild(csbItem)
    table.insert(self.roots, root)
	
	-- 1 加入部落    2 加入天灾    3 加入联盟
	self._armatureName = "effect_gzxzzy_" .. _ED.user_info.user_force
	self._armatureFile = "images/ui/effice/effect_gzxzzy_" .. _ED.user_info.user_force .. "/" .. self._armatureName .. ".ExportJson"
	ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(self._armatureFile)
	
    local armature = ccs.Armature:create(self._armatureName)

    armature:getAnimation():playWithIndex(0)
    armature:getAnimation():setMovementEventCallFunc(csb.changeAction_animationEventCallFunc)
	armature._invoke = function(armature)
		-- fwin:__show(fwin._frameview)
		-- state_machine.excute("join_camp_suceess_window_close", 0, 0)
	end

	armature:getAnimation():setFrameEventCallFunc(
    function(bone,evt,originFrameIndex,currentFrameIndex)
        local tempArmature = bone:getArmature()
        if tempArmature:isVisible() == true then
            if evt == "home_in" then
               state_machine.excute("main_window_join_camp_in",0,{})
            end
        end
    end)
	local Panel_camp_join =  ccui.Helper:seekWidgetByName(root,"Panel_camp_join")
	Panel_camp_join:removeAllChildren(true)
	Panel_camp_join:addChild(armature)
end

function JoinCampSuceess:onExit()
	ccs.ArmatureDataManager:getInstance():removeArmatureFileInfo(self._armatureFile)
end
