






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
	 		ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):setFontSize(ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):getFontSize())
	 	else
	 		ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):setFontName(RoleDialogueLeftBoxWidget.__userHeroFontName)
	 	end
	end
	ccui.Helper:seekWidgetByName(Panel_dialog, "Label_7981"):setString(self.name)








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