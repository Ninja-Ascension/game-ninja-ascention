--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景宝藏界面
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSceneTreasure = class("UnionDuplicateSceneTreasureClass", Window)

function UnionDuplicateSceneTreasure:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate scene treasuren machine.
    local function init_union_duplicate_scene_treasure_terminal()
		--打开界面
        local union_duplicate_scene_treasure_open_terminal = {
            _name = "union_duplicate_scene_treasure_open",
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
		local union_duplicate_scene_treasure_close_terminal = {
            _name = "union_duplicate_scene_treasure_close",
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
        local union_duplicate_scene_treasure_hide_event_terminal = {
            _name = "union_duplicate_scene_treasure_hide_event",
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
        local union_duplicate_scene_treasure_show_event_terminal = {
            _name = "union_duplicate_scene_treasure_show_event",
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
		local union_duplicate_scene_treasure_refresh_terminal = {
            _name = "union_duplicate_scene_treasure_refresh",
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
		-- 点击预览
		local union_duplicate_scene_treasure_open_preview_terminal = {
            _name = "union_duplicate_scene_treasure_open_preview",
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
		--选择列表类型宝藏
		local union_duplicate_scene_treasure_select_page_terminal = {
            _name = "union_duplicate_scene_treasure_select_page",
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
		-- 打开宝藏列表界面状态机1
		local union_duplicate_scene_treasure_type_one_terminal = {
            _name = "union_duplicate_scene_treasure_type_one",
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
		--打开宝藏列表界面状态机2
		local union_duplicate_scene_treasure_type_Two_terminal = {
            _name = "union_duplicate_scene_treasure_type_Two",
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
		-- 打开宝藏列表界面状态机3
		local union_duplicate_scene_treasure_type_three_terminal = {
            _name = "union_duplicate_scene_treasure_type_three",
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
		-- 打开宝藏列表界面状态机4
		local union_duplicate_scene_treasure_type_four_terminal = {
            _name = "union_duplicate_scene_treasure_type_four",
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
		
		state_machine.add(union_duplicate_scene_treasure_open_terminal)
		state_machine.add(union_duplicate_scene_treasure_close_terminal)
		state_machine.add(union_duplicate_scene_treasure_hide_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_show_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_refresh_terminal)
		state_machine.add(union_duplicate_scene_treasure_open_preview_terminal)
		state_machine.add(union_duplicate_scene_treasure_select_page_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_one_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_Two_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_three_terminal)
		state_machine.add(union_duplicate_scene_treasure_type_four_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate scene treasuren  machine.
    init_union_duplicate_scene_treasure_terminal()

end

function UnionDuplicateSceneTreasure:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionDuplicateSceneTreasure:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionDuplicateSceneTreasure:updateDraw()

end

function UnionDuplicateSceneTreasure:onInit()
	self:updateDraw()
end

function UnionDuplicateSceneTreasure:onEnterTransitionFinish()

end

function UnionDuplicateSceneTreasure:init()
	self:onInit()
	return self
end

function UnionDuplicateSceneTreasure:onExit()
	state_machine.remove("union_duplicate_scene_treasure_open")
	state_machine.remove("union_duplicate_scene_treasure_close")
	state_machine.remove("union_duplicate_scene_treasure_hide_event")
	state_machine.remove("union_duplicate_scene_treasure_show_event")
	state_machine.remove("union_duplicate_scene_treasure_refresh")
	state_machine.remove("union_duplicate_scene_treasure_open_preview")
	state_machine.remove("union_duplicate_scene_treasure_select_page")
	state_machine.remove("union_duplicate_scene_treasure_type_one")
	state_machine.remove("union_duplicate_scene_treasure_type_Two")
	state_machine.remove("union_duplicate_scene_treasure_type_three")
	state_machine.remove("union_duplicate_scene_treasure_type_four")
end