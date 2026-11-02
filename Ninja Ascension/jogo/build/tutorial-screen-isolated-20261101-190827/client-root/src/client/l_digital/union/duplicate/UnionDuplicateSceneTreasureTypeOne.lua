--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景宝藏第一种类型的宝藏
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSceneTreasureTypeOne = class("UnionDuplicateSceneTreasureTypeOneClass", Window)

function UnionDuplicateSceneTreasureTypeOne:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate scene treasure type one machine.
    local function init_union_duplicate_scene_treasure_type_one_terminal()
		--打开界面
        local union_duplicate_scene_treasure_type_one_open_terminal = {
            _name = "union_duplicate_scene_treasure_type_one_open",
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
		local union_duplicate_scene_treasure_type_one_close_terminal = {
            _name = "union_duplicate_scene_treasure_type_one_close",
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
        local union_duplicate_scene_treasure_type_one_hide_event_terminal = {
            _name = "union_duplicate_scene_treasure_type_one_hide_event",
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
        local union_duplicate_scene_treasure_type_one_show_event_terminal = {
            _name = "union_duplicate_scene_treasure_type_one_show_event",
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
		local union_duplicate_scene_treasure_type_one_refresh_info_terminal = {
            _name = "union_duplicate_scene_treasure_type_one_refresh_info",
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
		state_machine.add(union_duplicate_scene_treasure_type_one_open_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_one_close_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_one_hide_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_one_show_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_one_refresh_info_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate scene treasure type one  machine.
    init_union_duplicate_scene_treasure_type_one_terminal()

end

function UnionDuplicateSceneTreasureTypeOne:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionDuplicateSceneTreasureTypeOne:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionDuplicateSceneTreasureTypeOne:updateDraw()

end

function UnionDuplicateSceneTreasureTypeOne:onInit()
	self:updateDraw()
end

function UnionDuplicateSceneTreasureTypeOne:onEnterTransitionFinish()

end

function UnionDuplicateSceneTreasureTypeOne:init()
	self:onInit()
	return self
end

function UnionDuplicateSceneTreasureTypeOne:onExit()
	state_machine.remove("union_duplicate_scene_treasure_type_one_open")
	state_machine.remove("union_duplicate_scene_treasure_type_one_close")
	state_machine.remove("union_duplicate_scene_treasure_type_one_hide_event")
	state_machine.remove("union_duplicate_scene_treasure_type_one_show_event")
	state_machine.remove("union_duplicate_scene_treasure_type_one_refresh_info")
end