-- ----------------------------------------------------------------------------------------------------
-- 说明：角色对话左侧角色组件
-- 创建时间
-- 作者：肖雄
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
RoleDialogueLeftRoleWidget = class("RoleDialogueLeftRoleWidgetClass", Window)

function RoleDialogueLeftRoleWidget:ctor()
    self.super:ctor()
    
	self.roots = {}
	
	self.head = nil
	self.action = nil
	
	self.color = nil
	
    local function init_RoleDialogueLeftRoleWidget_terminal()
		local role_dialogue_left_role_in_terminal = {
            _name = "role_dialogue_left_role_in",
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
				
				local function leftExpressionRestart()
					local leftExpressionLayout = headWidget:getParent():getChildByName("Panel_2")
					
					-- local lastWidget = leftExpressionLayout:getChildByTag(1001)
					-- if lastWidget ~= nil then
						-- state_machine.excute("role_dialogue_expression_out", 0, lastWidget)
					-- end
					
					local leftExpressionWidget = RoleDialogueExpressionWidget:createCell()
					leftExpressionWidget:init(expressionId)
					-- leftExpressionLayout:removeAllChildren(true)
					leftExpressionWidget:setTag(1001)
					leftExpressionLayout:addChild(leftExpressionWidget)
					
					state_machine.excute("role_dialogue_expression_in", 0, leftExpressionWidget)
				end
				
				if fwin:find("RoleDialogueClass")._counts > 0 and 
				  fwin:find("RoleDialogueClass")._last_left_head == fwin:find("RoleDialogueClass").left_head then
					headWidget.action:play("left_role_say", false)
					-- print("left_role_say")
					leftExpressionRestart()
				else
					headWidget.action:play("left_role_in", false)
					-- print("left_role_in")
					headWidget.action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							return
						end

						local str = frame:getEvent()
						if str == "exit" then
							leftExpressionRestart()
						end	
					end)
				end	
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		local role_dialogue_left_role_out_terminal = {
            _name = "role_dialogue_left_role_out",
            _init = function (terminal)
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				-- params.headWidget.action:play("left_role_out", false)
				-- print("left_role_out")
				params.headWidget.action:setFrameEventCallFunc(function (frame)
					if nil == frame then
						return
					end

					local str = frame:getEvent()
					if str == "left_role_out" then
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
		
		state_machine.add(role_dialogue_left_role_in_terminal)
		state_machine.add(role_dialogue_left_role_out_terminal)
        state_machine.init()
    end
    
    init_RoleDialogueLeftRoleWidget_terminal()
end

function RoleDialogueLeftRoleWidget:init(_head)
	self.head = _head
end

function RoleDialogueLeftRoleWidget:changeDialogHeroHeadImage(_head)
	self.head = _head
	local root = self.roots[1]
	-- local Panel_big_head = ccui.Helper:seekWidgetByName(root, "Panel_big_head_01")
	root:setBackGroundImage(string.format("images/face/big_head/big_head_%d.png", self.head))
end

function RoleDialogueLeftRoleWidget:setShadow(boolean)
	local root = self.roots[1]
	if boolean == true then
		root:setColor(cc.c3b(130,130,130))
	else
		root:setColor(self.color)
	end	
end

function RoleDialogueLeftRoleWidget:onEnterTransitionFinish()
	local csbRoleDialogueLeftRoleWidget = csb.createNode("Chat/dialog_ro_1.csb")
	local root = csbRoleDialogueLeftRoleWidget:getChildByName("root")
	
	local Panel_big_head = ccui.Helper:seekWidgetByName(root, "Panel_big_head_01")
	Panel_big_head:removeFromParent(false)
	table.insert(self.roots, Panel_big_head)
	
	self:setContentSize(Panel_big_head:getContentSize())
	self:addChild(Panel_big_head)
	
	self.action = csb.createTimeline("Chat/dialog_ro_1.csb")
	Panel_big_head:runAction(self.action)

	self.action1 = csb.createTimeline("Chat/dialog_ro_1.csb")
	Panel_big_head:runAction(self.action1)
	self.action1:play("left_role_dt", true)
	
	self.color = Panel_big_head:getColor()
end

function RoleDialogueLeftRoleWidget:onExit()
	state_machine.remove("role_dialogue_left_role_in")
	state_machine.remove("role_dialogue_left_role_out")
end

function RoleDialogueLeftRoleWidget:createCell()
	local cell = RoleDialogueLeftRoleWidget:new()
	cell:registerOnNodeEvent(cell)
	return cell
end