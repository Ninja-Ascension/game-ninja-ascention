-- ----------------------------------------------------------------------------------------------------
-- 说明：角色对话左侧对话框组件
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
RoleDialogueLeftBoxWidget = class("RoleDialogueLeftBoxWidgetClass", Window)
RoleDialogueLeftBoxWidget.__userHeroFontName = nil
function RoleDialogueLeftBoxWidget:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.name = ""
	self.string = ""
	self.action = nil
	
    local function init_RoleDialogueLeftBoxWidget_terminal()
		local role_dialogue_left_box_in_terminal = {
            _name = "role_dialogue_left_box_in",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params.action:gotoFrameAndPlay(0, params.action:getDuration(), false)
				params.action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "dialog_left_over" then
						fwin:find("RoleDialogueClass")._isBoxAllIn = true
					end
				end)
				
				
				local text_widget = ccui.Helper:seekWidgetByName(params.roots[1], "Text_3")
				-- text_widget:setString(params.string)
				
				local OldXPos = text_widget:getPositionX()
				local OldYPos = text_widget:getPositionY()
				
				local ttfConfig = {}
				ttfConfig.fontFilePath = text_widget:getFontName()
				ttfConfig.fontSize = text_widget:getFontSize()
				
				local label1 = cc.Label:createWithTTF(ttfConfig,"", cc.TEXT_ALIGNMENT_LEFT, 0)
				label1:setTextColor(text_widget:getTextColor())
				label1:setString(params.string)
				text_widget:addChild(label1)
				label1:setWidth(text_widget:getContentSize().width)
				
				text_widget:setPosition(cc.p(0, 0))
				text_widget:setAnchorPoint(cc.p(0, 0))
				label1:setPosition(cc.p(OldXPos, OldYPos))
				label1:setAnchorPoint(cc.p(0, 1))
				
				
				ccui.Helper:seekWidgetByName(params.roots[1], "Image_8"):setVisible(true)
				fwin:find("RoleDialogueClass")._isShowTextEnd = true
				
				-- local speed = 0.05
				-- local lenOfContent = string.len(params.string)
				-- local showCharIndex = 0
				-- -- 1个中文汉字占用3个字符长度
				-- local oneWordLen = 3
				
				-- local _updateContent = function (dt)
					-- showCharIndex = showCharIndex + oneWordLen
					-- if showCharIndex <= lenOfContent then
						-- text_widget:setString(string.sub(params.string, 1, showCharIndex))
						-- if fwin:find("RoleDialogueClass")._isShowTextEnd == true then
							-- params:unscheduler("print_text")
							-- text_widget:setString(params.string)
							-- ccui.Helper:seekWidgetByName(params.roots[1], "Image_8"):setVisible(true)
						-- end
					-- else
						-- params:unscheduler("print_text")
						-- fwin:find("RoleDialogueClass")._isShowTextEnd = true
						-- ccui.Helper:seekWidgetByName(params.roots[1], "Image_8"):setVisible(true)
					-- end
				-- end
				
				-- fwin:find("RoleDialogueClass")._isShowTextEnd = false
				-- params:scheduler("print_text", _updateContent, speed)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local role_dialogue_left_box_down_terminal = {
            _name = "role_dialogue_left_box_down",
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
		
		state_machine.add(role_dialogue_left_box_in_terminal)
		state_machine.add(role_dialogue_left_box_down_terminal)
        state_machine.init()
    end
    
    init_RoleDialogueLeftBoxWidget_terminal()
end

function RoleDialogueLeftBoxWidget:init(_name, _string)
	self.name = _name
	self.string = _string
end



-- function RoleDialogueLeftBoxWidget:showDilogMessage()
	-- self.action:gotoFrameAndPlay(0, self.action:getDuration(), false)
	-- self._text_widget = ccui.Helper:seekWidgetByName(self.roots[1], "Text_3")
	-- self._text_image = ccui.Helper:seekWidgetByName(self.roots[1], "Image_8")
	
				
	-- local _updateContent = function (dt)
		-- showCharIndex = showCharIndex + 1
		-- if showCharIndex <= lenOfContent then
			-- text_widget:setString(SubUTF8String(params.string, showCharIndex))
			-- if fwin:find("RoleDialogueClass")._isShowTextEnd == true then
				-- text_widget:setString(params.string)
				-- ccui.Helper:seekWidgetByName(params.roots[1], "Image_8"):setVisible(true)
			-- end
		-- else
			-- fwin:find("RoleDialogueClass")._isShowTextEnd = true
			-- ccui.Helper:seekWidgetByName(params.roots[1], "Image_8"):setVisible(true)
		-- end
	-- end
	
	-- fwin:find("RoleDialogueClass")._isShowTextEnd = false
	-- self.showTextEffect = true
-- end

-- function RoleDialogueLeftBoxWidget:onUpdate(dt)
	-- if self.showTextEffect == true then
		-- if fwin:find("RoleDialogueClass")._isShowTextEnd == true then
			-- self.showCharIndex = #self.string
		-- else
			-- self.showCharIndex = self.showCharIndex + 3
		-- end
		-- text_widget:setString(SubUTF8String(self.string, showCharIndex))
		-- if self.showCharIndex >= #self.string then
			-- self._text_image:setVisible(true)
			-- self.showTextEffect = true
			-- fwin:find("RoleDialogueClass")._isShowTextEnd = true
		-- end
	-- end
-- end

function RoleDialogueLeftBoxWidget:onEnterTransitionFinish()
	local csbRoleDialogueLeftBoxWidget = csb.createNode("Chat/dialog_list.csb")
	local root = csbRoleDialogueLeftBoxWidget:getChildByName("root")
	local Panel_dialog = ccui.Helper:seekWidgetByName(root, "Panel_dialog")
	Panel_dialog:removeFromParent(false)
	self:setContentSize(Panel_dialog:getContentSize())
	self:addChild(Panel_dialog)
	table.insert(self.roots, Panel_dialog)
	
	Panel_dialog:setTouchEnabled(false)
	
	self.action = csb.createTimeline("Chat/dialog_list.csb")
	Panel_dialog:runAction(self.action)
	if ___is_open_leadname == true then
		if RoleDialogueLeftBoxWidget.__userHeroFontName == nil then
			RoleDialogueLeftBoxWidget.__userHeroFontName = ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):getFontName()
		end
	 	if _ED.user_info.user_name == self.name then
	 		ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):setFontName("")
	 		ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):setFontSize(ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):getFontSize())-->设置字体大小
	 	else
	 		ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):setFontName(RoleDialogueLeftBoxWidget.__userHeroFontName)
	 	end
	end
	ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):setString(self.name)
	
	-- local text_pad = ccui.Helper:seekWidgetByName(Panel_dialog, "ImageView_dialog2")
	-- local text_widget = ccui.Helper:seekWidgetByName(Panel_dialog, "Text_3")
	-- text_widget:setTextAreaSize(cc.size(400,100))
	-- text_widget:setPositionY(text_widget:getPositionY()+30)
	-- text_pad:setContentSize(cc.size(text_pad:getContentSize().width, text_widget:getContentSize().height+50))
	-- Panel_dialog:setContentSize(cc.size(Panel_dialog:getContentSize().width, text_pad:getContentSize().height+100))
	
	ccui.Helper:seekWidgetByName(Panel_dialog, "Image_8"):setVisible(false)
end

function RoleDialogueLeftBoxWidget:onExit()
	state_machine.remove("role_dialogue_left_box_in")
	state_machine.remove("role_dialogue_left_box_down")
end

function RoleDialogueLeftBoxWidget:createCell()
	local cell = RoleDialogueLeftBoxWidget:new()
	cell:registerOnNodeEvent(cell)
	return cell
end