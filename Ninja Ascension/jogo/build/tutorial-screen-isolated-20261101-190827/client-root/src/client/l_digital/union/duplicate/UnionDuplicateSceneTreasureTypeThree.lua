--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景宝藏第三种类型的宝藏
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSceneTreasureTypeThree = class("UnionDuplicateSceneTreasureTypeThreeClass", Window)

function UnionDuplicateSceneTreasureTypeThree:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate scene treasure type three machine.
    local function init_union_duplicate_scene_treasure_type_three_terminal()
		--打开界面
        local union_duplicate_scene_treasure_type_three_open_terminal = {
            _name = "union_duplicate_scene_treasure_type_three_open",
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
		local union_duplicate_scene_treasure_type_three_close_terminal = {
            _name = "union_duplicate_scene_treasure_type_three_close",
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
        local union_duplicate_scene_treasure_type_three_hide_event_terminal = {
            _name = "union_duplicate_scene_treasure_type_three_hide_event",
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
        local union_duplicate_scene_treasure_type_three_show_event_terminal = {
            _name = "union_duplicate_scene_treasure_type_three_show_event",
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
		local union_duplicate_scene_treasure_type_three_refresh_info_terminal = {
            _name = "union_duplicate_scene_treasure_type_three_refresh_info",
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
		state_machine.add(union_duplicate_scene_treasure_type_three_open_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_three_close_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_three_hide_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_three_show_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_three_refresh_info_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate scene treasure type three  machine.
    init_union_duplicate_scene_treasure_type_three_terminal()

end

function UnionDuplicateSceneTreasureTypeThree:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionDuplicateSceneTreasureTypeThree:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionDuplicateSceneTreasureTypeThree:updateDraw()

end

function UnionDuplicateSceneTreasureTypeThree:onInit()
	self:updateDraw()
end

function UnionDuplicateSceneTreasureTypeThree:onEnterTransitionFinish()

end

function UnionDuplicateSceneTreasureTypeThree:init()
	self:onInit()
	return self
end

function UnionDuplicateSceneTreasureTypeThree:onExit()
	state_machine.remove("union_duplicate_scene_treasure_type_three_open")
	state_machine.remove("union_duplicate_scene_treasure_type_three_close")
	state_machine.remove("union_duplicate_scene_treasure_type_three_hide_event")
	state_machine.remove("union_duplicate_scene_treasure_type_three_show_event")
	state_machine.remove("union_duplicate_scene_treasure_type_three_refresh_info")
end