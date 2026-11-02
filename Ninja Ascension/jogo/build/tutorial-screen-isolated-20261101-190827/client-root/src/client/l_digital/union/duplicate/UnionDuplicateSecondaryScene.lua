--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景二级战斗界面
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSecondaryScene = class("UnionDuplicateSecondarySceneClass", Window)

function UnionDuplicateSecondaryScene:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate secondary scene machine.
    local function init_union_duplicate_secondary_scene_terminal()
		--打开界面
        local union_duplicate_secondary_scene_open_terminal = {
            _name = "union_duplicate_secondary_scene_open",
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
		
		--关闭界面
		local union_duplicate_secondary_scene_close_terminal = {
            _name = "union_duplicate_secondary_scene_close",
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
		-- 隐藏界面
        local union_duplicate_secondary_scene_hide_event_terminal = {
            _name = "union_duplicate_secondary_scene_hide_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onHide()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 显示界面
        local union_duplicate_secondary_scene_show_event_terminal = {
            _name = "union_duplicate_secondary_scene_show_event",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onShow()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--刷新信息
		local union_duplicate_secondary_scene_refresh_terminal = {
            _name = "union_duplicate_secondary_scene_refresh",
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
		-- 点击npc
		local union_duplicate_secondary_scene_open_fight_terminal = {
            _name = "union_duplicate_secondary_scene_open_fight",
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
		--点击宝藏状态机
		local union_duplicate_secondary_scene_open_treasure_terminal = {
            _name = "union_duplicate_secondary_scene_open_treasure",
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
		state_machine.add(union_duplicate_secondary_scene_open_terminal)
		state_machine.add(union_duplicate_secondary_scene_close_terminal)
		state_machine.add(union_duplicate_secondary_scene_hide_event_terminal)
		state_machine.add(union_duplicate_secondary_scene_show_event_terminal)
		state_machine.add(union_duplicate_secondary_scene_refresh_terminal)
		state_machine.add(union_duplicate_secondary_scene_open_fight_terminal)
		state_machine.add(union_duplicate_secondary_scene_open_treasure_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate secondary scene  machine.
    init_union_duplicate_secondary_scene_terminal()

end

function UnionDuplicateSecondaryScene:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionDuplicateSecondaryScene:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionDuplicateSecondaryScene:updateDraw()

end

function UnionDuplicateSecondaryScene:onInit()
	self:updateDraw()
end

function UnionDuplicateSecondaryScene:onEnterTransitionFinish()

end

function UnionDuplicateSecondaryScene:init()
	self:onInit()
	return self
end

function UnionDuplicateSecondaryScene:onExit()
	state_machine.remove("union_duplicate_secondary_scene_open")
	state_machine.remove("union_duplicate_secondary_scene_close")
	state_machine.remove("union_duplicate_secondary_scene_hide_event")
	state_machine.remove("union_duplicate_secondary_scene_show_event")
	state_machine.remove("union_duplicate_secondary_scene_refresh")
	state_machine.remove("union_duplicate_secondary_scene_open_fight")
	state_machine.remove("union_duplicate_secondary_scene_open_treasure")
end