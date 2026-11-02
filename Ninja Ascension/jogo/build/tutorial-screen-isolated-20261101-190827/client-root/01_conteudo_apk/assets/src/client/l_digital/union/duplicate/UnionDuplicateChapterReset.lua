--------------------------------------------------------------------------------------------------------------
--  说明：军团副本章节重置
--------------------------------------------------------------------------------------------------------------
UnionDuplicateChapterReset = class("UnionDuplicateChapterResetClass", Window)

function UnionDuplicateChapterReset:ctor()
	self.super:ctor()
	self.roots = {}
	
	
	 -- Initialize union duplicate chapter reset machine.
    local function init_union_duplicate_chapter_reset_terminal()
		--打开界面
        local union_duplicate_chapter_reset_open_terminal = {
            _name = "union_duplicate_chapter_reset_open",
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
		local union_duplicate_chapter_reset_close_terminal = {
            _name = "union_duplicate_chapter_reset_close",
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
        local union_duplicate_chapter_reset_hide_event_terminal = {
            _name = "union_duplicate_chapter_reset_hide_event",
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
        local union_duplicate_chapter_reset_show_event_terminal = {
            _name = "union_duplicate_chapter_reset_show_event",
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
		local union_duplicate_chapter_reset_refresh_terminal = {
            _name = "union_duplicate_chapter_reset_refresh",
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
		--选择重置类型
		local union_duplicate_chapter_reset_select_type_terminal = {
            _name = "union_duplicate_chapter_reset_select_type",
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
		state_machine.add(union_duplicate_chapter_reset_open_terminal)
		state_machine.add(union_duplicate_chapter_reset_close_terminal)
		state_machine.add(union_duplicate_chapter_reset_hide_event_terminal)
		state_machine.add(union_duplicate_chapter_reset_show_event_terminal)
		state_machine.add(union_duplicate_chapter_reset_refresh_terminal)
		state_machine.add(union_duplicate_chapter_reset_select_type_terminal)
        state_machine.init()
    end
    
    -- call func init union duplicate chapter reset  machine.
    init_union_duplicate_chapter_reset_terminal()

end

function UnionDuplicateChapterReset:onHide()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(false)
		end
	end
	self:setVisible(false)
end

function UnionDuplicateChapterReset:onShow()
	for i, v in pairs(self.group) do
		if v ~= nil then
			v:setVisible(true)
		end
	end
	self:setVisible(true)
end

function UnionDuplicateChapterReset:updateDraw()

end

function UnionDuplicateChapterReset:onInit()
	self:updateDraw()
end

function UnionDuplicateChapterReset:onEnterTransitionFinish()

end

function UnionDuplicateChapterReset:init()
	self:onInit()
	return self
end

function UnionDuplicateChapterReset:onExit()
	state_machine.remove("union_duplicate_chapter_reset_open")
	state_machine.remove("union_duplicate_chapter_reset_close")
	state_machine.remove("union_duplicate_chapter_reset_hide_event")
	state_machine.remove("union_duplicate_chapter_reset_show_event")
	state_machine.remove("union_duplicate_chapter_reset_refresh")
	state_machine.remove("union_duplicate_chapter_reset_select_type")
end