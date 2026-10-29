--------------------------------------------------------------------------------------------------------------
--  说明：军团副本场景宝藏预览界面
--------------------------------------------------------------------------------------------------------------
UnionDuplicateSceneTreasurePreview = class("UnionDuplicateSceneTreasurePreviewClass", Window)

function UnionDuplicateSceneTreasurePreview:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize  union duplicate scene treasure preview machine.
    local function init_union_duplicate_scene_treasure_preview_terminal()
		--打开界面
        local union_duplicate_scene_treasure_preview_open_terminal = {
            _name = "union_duplicate_scene_treasure_preview_open",
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
		local union_duplicate_scene_treasure_preview_close_terminal = {
            _name = "union_duplicate_scene_treasure_preview_close",
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
        local union_duplicate_scene_treasure_preview_hide_event_terminal = {
            _name = "union_duplicate_scene_treasure_preview_hide_event",
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
        local union_duplicate_scene_treasure_preview_show_event_terminal = {
            _name = "union_duplicate_scene_treasure_preview_show_event",
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
		local union_duplicate_scene_treasure_preview_refresh_terminal = {
            _name = "union_duplicate_scene_treasure_preview_refresh",
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
		-- 选择类型宝藏
		local union_duplicate_scene_treasure_preview_select_page_terminal = {
            _name = "union_duplicate_scene_treasure_preview_select_page",
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
		
		state_machine.add(union_duplicate_scene_treasure_preview_open_terminal)
		state_machine.add(union_duplicate_scene_treasure_preview_close_terminal)
		state_machine.add(union_duplicate_scene_treasure_preview_hide_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_preview_show_event_terminal)
		state_machine.add(union_duplicate_scene_treasure_preview_refresh_terminal)
		state_machine.add(union_duplicate_scene_treasure_preview_select_page_terminal)
        state_machine.init()
    end
    
    -- call func init  union duplicate scene treasure preview  machine.
    init_union_duplicate_scene_treasure_preview_terminal()

end

function UnionDuplicateSceneTreasurePreview:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionDuplicateSceneTreasurePreview:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionDuplicateSceneTreasurePreview:updateDraw()

end

function UnionDuplicateSceneTreasurePreview:onInit()
	self:updateDraw()
end

function UnionDuplicateSceneTreasurePreview:onEnterTransitionFinish()

end

function UnionDuplicateSceneTreasurePreview:init()
	self:onInit()
	return self
end

function UnionDuplicateSceneTreasurePreview:onExit()
	state_machine.remove("union_duplicate_scene_treasure_preview_open")
	state_machine.remove("union_duplicate_scene_treasure_preview_close")
	state_machine.remove("union_duplicate_scene_treasure_preview_hide_event")
	state_machine.remove("union_duplicate_scene_treasure_preview_show_event")
	state_machine.remove("union_duplicate_scene_treasure_preview_refresh")
	state_machine.remove("union_duplicate_scene_treasure_preview_select_page")

end