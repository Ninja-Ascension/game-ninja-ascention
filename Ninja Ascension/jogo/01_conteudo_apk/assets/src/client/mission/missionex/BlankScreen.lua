-- ----------------------------------------------------------------------------------------------------
-- 说明：黑屏事件
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
BlankScreen = class("BlankScreenClass", Window)

function BlankScreen:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.mission = nil
	
	self.enum_type = {
		WORDBYWORD = 0,	-- 逐字显示
		LINEBYLINE = 1, -- 逐行显示
	}
	
	self.UI_text = {}		 -- uitext集合
	self.strings = {}		 -- 文本集合
	self.print_type = self.enum_type.WORDBYWORD -- 文字出现方式
	self.print_speed = 0.08	 -- 文字出现速度
	self.one_word_len = 3	 -- 一个文字的字符数，一个汉字占用三个
	self.show_char_index = 0 -- 实时显示的字符数 string.sub(_string, 1, showCharIndex)
	self.len_of_content = {} -- 文本字符数 string.len(_string)
	self.is_print_over = false -- 文字显示完毕标识，点击屏幕可以直接显示完
	self.stop_effect = false
	
	self.now_print_index = 1   --正在打印的行数
	
    local function init_BlankScreen_terminal()
		local blank_screen_touch_screen_terminal = {
            _name = "blank_screen_touch_screen",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if instance.is_print_over == false then
					instance.is_print_over = true
				else
					state_machine.excute("blank_screen_event_over", 1, "blank_screen_event_over")
				end	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local blank_screen_event_over_terminal = {
            _name = "blank_screen_event_over",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--> print("~~~~~~~~~ next_event_come ~~~~~~~~~")
				saveExecuteEvent(self.mission, true)
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
		state_machine.add(blank_screen_touch_screen_terminal)
		state_machine.add(blank_screen_event_over_terminal)
        state_machine.init()
    end
    
    init_BlankScreen_terminal()
end

function BlankScreen:init(current_mission)
	self.mission = current_mission
end

function BlankScreen:onUpdate(dt)
	if self.stop_effect == true then
		return
	end

	if self.print_type == self.enum_type.WORDBYWORD then
		self.show_char_index = self.show_char_index + self.one_word_len
		
		if self.show_char_index <= self.len_of_content[self.now_print_index] then
			-- self.UI_text[self.now_print_index]:setString(string.sub(self.strings[self.now_print_index], 1, self.show_char_index))
			self.UI_text[self.now_print_index]:setString(self.strings[self.now_print_index])
			if self.is_print_over == true then
				-- self:unscheduler("print_text")
				self.stop_effect = true
				for i = self.now_print_index, #self.strings do
					self.UI_text[i]:setString(self.strings[i])
				end
			end
		else
			self.show_char_index = 0
			self.now_print_index = self.now_print_index + 1
			if self.UI_text[self.now_print_index] == nil then 
				-- self:unscheduler("print_text")
				self.stop_effect = true
				self.is_print_over = true
			end
		end
	elseif self.print_type == self.enum_type.LINEBYLINE then
		self.UI_text[self.now_print_index]:setString(self.strings[self.now_print_index])
		
		if self.is_print_over == true then
			-- self:unscheduler("print_text")
			self.stop_effect = true
			for i = self.now_print_index, #self.strings do
				self.UI_text[i]:setString(self.strings[i])
			end
		end
		
		self.now_print_index = self.now_print_index + 1
		if self.UI_text[self.now_print_index] == nil then 
			-- self:unscheduler("print_text")
			self.stop_effect = true
			self.is_print_over = true
		end
	end
end

function BlankScreen:onEnterTransitionFinish()
	local csbBlankScreen = csb.createNode("events_interpretation/events_interpretation.csb")
	self:addChild(csbBlankScreen)
	local root = csbBlankScreen:getChildByName("root")
	table.insert(self.roots, root)
	
	local uiTextSetStr = dms.atos(self.mission, mission_param1)
	local stringsSetStr = dms.atos(self.mission, mission_param2)
	
	local uiTextSet = zstring.split(uiTextSetStr, "|")
	for i, v in ipairs(uiTextSet) do
		table.insert(self.UI_text, ccui.Helper:seekWidgetByName(root, v))
	end
	
	self.strings = zstring.split(stringsSetStr, "|")

	for i, v in ipairs(self.strings) do
		table.insert(self.len_of_content, string.len(v))
	end
	
	-- local updateContent = nil
	
	-- if self.print_type == self.enum_type.WORDBYWORD then
	-- 	updateContent = function(dt)
	-- 		self.show_char_index = self.show_char_index + self.one_word_len
			
	-- 		if self.show_char_index <= self.len_of_content[self.now_print_index] then
	-- 			self.UI_text[self.now_print_index]:setString(string.sub(self.strings[self.now_print_index], 1, self.show_char_index))
	-- 			if self.is_print_over == true then
	-- 				self:unscheduler("print_text")
	-- 				for i = self.now_print_index, #self.strings do
	-- 					self.UI_text[i]:setString(self.strings[i])
	-- 				end
	-- 			end
	-- 		else
	-- 			self.show_char_index = 0
	-- 			self.now_print_index = self.now_print_index + 1
	-- 			if self.UI_text[self.now_print_index] == nil then 
	-- 				self:unscheduler("print_text")
	-- 				self.is_print_over = true
	-- 			end
	-- 		end
	-- 	end
	-- elseif self.print_type == self.enum_type.LINEBYLINE then
	-- 	updateContent = function(dt)
	-- 		self.UI_text[self.now_print_index]:setString(self.strings[self.now_print_index])
			
	-- 		if self.is_print_over == true then
	-- 			self:unscheduler("print_text")
	-- 			for i = self.now_print_index, #self.strings do
	-- 				self.UI_text[i]:setString(self.strings[i])
	-- 			end
	-- 		end
			
	-- 		self.now_print_index = self.now_print_index + 1
	-- 		if self.UI_text[self.now_print_index] == nil then 
	-- 			self:unscheduler("print_text")
	-- 			self.is_print_over = true
	-- 		end
	-- 	end
	-- end
	
	-- self:scheduler("print_text", updateContent, self.print_speed)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_sjyy"), nil, {terminal_name = "blank_screen_touch_screen", terminal_state = 1}, nil, 0)
end

function BlankScreen:onExit()
	state_machine.remove("blank_screen_touch_screen")
	state_machine.remove("blank_screen_event_over")
end