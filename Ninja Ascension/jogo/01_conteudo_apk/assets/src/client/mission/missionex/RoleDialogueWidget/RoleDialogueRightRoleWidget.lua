-- ----------------------------------------------------------------------------------------------------
-- 说明：角色对话右侧角色组件
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
RoleDialogueRightRoleWidget = class("RoleDialogueRightRoleWidgetClass", Window)

function RoleDialogueRightRoleWidget:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.head = nil
	self.action = nil
	
	self.color = nil
	
    local function init_RoleDialogueRightRoleWidget_terminal()
		local role_dialogue_right_role_in_terminal = {
            _name = "role_dialogue_right_role_in",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local headWidget = params[1]
				local headId = params[2]
				local expressionId = params[3]
				headWidget:changeDialogHeroHeadImage(headId)
				
				local function rightExpressionRestart()
					local rightExpressionLayout = headWidget:getParent():getChildByName("Panel_3")
					
					-- local lastWidget = rightExpressionLayout:getChildByTag(1001)
					-- if lastWidget ~= nil then
						-- state_machine.excute("role_dialogue_expression_out", 0, lastWidget)
					-- end
					
					local rightExpressionWidget = RoleDialogueExpressionWidget:createCell()
					rightExpressionWidget:init(expressionId)
					-- rightExpressionLayout:removeAllChildren(true)
					rightExpressionWidget:setTag(1001)
					rightExpressionLayout:addChild(rightExpressionWidget)
					
					state_machine.excute("role_dialogue_expression_in", 0, rightExpressionWidget)
				end
				
				if fwin:find("RoleDialogueClass")._counts > 0 and 
				  fwin:find("RoleDialogueClass")._last_right_head == fwin:find("RoleDialogueClass").right_head then
					-- print("right_role_say")
					headWidget.action:play("right_role_say", false)
					rightExpressionRestart()
				else
					headWidget.action:play("right_role_in", false)
					-- print("right_role_in")
					headWidget.action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "exit" then
							rightExpressionRestart()
						end	
					end)
				end	
				
			    return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local role_dialogue_right_role_out_terminal = {
            _name = "role_dialogue_right_role_out",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- params.headWidget.action:play("right_role_out", false)
				-- print("right_role_out")
				params.headWidget.action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "right_role_out" then
						if params.sessionGoOn == true then
							state_machine.excute("role_dialogue_box_in", 0, "role_dialogue_box_in.")
							state_machine.excute("role_dialogue_role_in", 0, "role_dialogue_role_in.")
						end
					end	
				end)
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		state_machine.add(role_dialogue_right_role_in_terminal)
		state_machine.add(role_dialogue_right_role_out_terminal)
        state_machine.init()
    end
    
    init_RoleDialogueRightRoleWidget_terminal()
end

function RoleDialogueRightRoleWidget:init(_head)
	self.head = _head
end

function RoleDialogueRightRoleWidget:changeDialogHeroHeadImage(_head)
	self.head = _head
	local root = self.roots[1]
	-- local Panel_big_head = ccui.Helper:seekWidgetByName(root, "Panel_big_head_02")
	root:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.head))
end

function RoleDialogueRightRoleWidget:setShadow(boolean)
	local root = self.roots[1]
	if boolean == true then
		root:setColor(cc.c3b(130,130,130))
	else
		root:setColor(self.color)
	end	
end

function RoleDialogueRightRoleWidget:onEnterTransitionFinish()
	local csbRoleDialogueRightRoleWidget = csb.createNode("Chat/dialog_ro_2.csb")
	local root = csbRoleDialogueRightRoleWidget:getChildByName("root")
	
	local Panel_big_head = ccui.Helper:seekWidgetByName(root, "Panel_big_head_02")
	Panel_big_head:removeFromParent(false)
	table.insert(self.roots, Panel_big_head)
	
	self:setContentSize(Panel_big_head:getContentSize())
	self:addChild(Panel_big_head)
	
	self.action = csb.createTimeline("Chat/dialog_ro_2.csb")
	Panel_big_head:runAction(self.action)

	self.action1 = csb.createTimeline("Chat/dialog_ro_2.csb")
	Panel_big_head:runAction(self.action1)
	self.action1:play("right_role_dt", true)
	
	self.color = Panel_big_head:getColor()
end

function RoleDialogueRightRoleWidget:onExit()
	state_machine.remove("role_dialogue_right_role_in")
	state_machine.remove("role_dialogue_right_role_out")
end

function RoleDialogueRightRoleWidget:createCell()
	local cell = RoleDialogueRightRoleWidget:new()
	cell:registerOnNodeEvent(cell)
	return cell
end