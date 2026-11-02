-- ----------------------------------------------------------------------------------------------------
-- 说明：角色对话表情组件
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
RoleDialogueExpressionWidget = class("RoleDialogueExpressionWidgetClass", Window)

function RoleDialogueExpressionWidget:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.action = nil
	self.expression = nil
	
    local function init_RoleDialogueExpressionWidget_terminal()
		local role_dialogue_expression_in_terminal = {
            _name = "role_dialogue_expression_in",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- headWidget.action:play("right_role_in", false)
				params.action:gotoFrameAndPlay(0, 10, false)
				params.action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "exit" then
						params.action:gotoFrameAndPlay(10, 86, true)
					end
				end)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local role_dialogue_expression_out_terminal = {
            _name = "role_dialogue_expression_out",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				params.action:gotoFrameAndPlay(95, 105, false)
				params.action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "over" then
						params:removeFromParent(true)
					end
				end)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(role_dialogue_expression_in_terminal)
		state_machine.add(role_dialogue_expression_out_terminal)
        state_machine.init()
    end
    
    init_RoleDialogueExpressionWidget_terminal()
end

function RoleDialogueExpressionWidget:init(_expression)
	self.expression = _expression
end

function RoleDialogueExpressionWidget:onEnterTransitionFinish()
	local csbRoleDialogueExpressionWidget = csb.createNode("Chat/dialog_biaoq.csb")
	local root = csbRoleDialogueExpressionWidget:getChildByName("root")
	
	local expression_panel = root:getChildByName("Panel_bq")
	expression_panel:removeFromParent(false)
	table.insert(self.roots, expression_panel)
	
	self:setContentSize(expression_panel:getContentSize())
	self:addChild(expression_panel)
	
	self.action = csb.createTimeline("Chat/dialog_biaoq.csb")
	expression_panel:runAction(self.action)
	
	expression_panel:setBackGroundImage(string.format("images/ui/biaoqing/%d.png", self.expression))
end

function RoleDialogueExpressionWidget:onExit()
	-- state_machine.remove("role_dialogue_expression_in")
	-- state_machine.remove("role_dialogue_expression_out")
end

function RoleDialogueExpressionWidget:createCell()
	local cell = RoleDialogueExpressionWidget:new()
	cell:registerOnNodeEvent(cell)
	return cell
end