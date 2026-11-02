--[[ ----------------------------------------------------------------------------
-- 规则界面
--]] ----------------------------------------------------------------------------
SecretTreasureGuide = class("SecretTreasureGuideClass", Window)

-- 打开窗口
local secret_treasure_guide_window_open_terminal = {
	_name = "secret_treasure_guide_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("SecretTreasureGuideClass") then
			fwin:open(SecretTreasureGuide:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local secret_treasure_guide_window_close_terminal = {
	_name = "secret_treasure_guide_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("SecretTreasureGuideClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(secret_treasure_guide_window_open_terminal)
state_machine.add(secret_treasure_guide_window_close_terminal)
state_machine.init()

-- 构造器
function SecretTreasureGuide:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize secret treasure rule page state machine.
	local function init_secret_treasure_guide_terminal()
		-- 打开角色创建窗口
		local secret_treasure_guide_open_terminal = {
			_name = "secret_treasure_guide_open",
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

		-- 关闭角色创建窗口
		local secret_treasure_guide_close_terminal = {
			_name = "secret_treasure_guide_close",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("secret_treasure_guide_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 显示窗口
		local secret_treasure_guide_show_terminal = {
			_name = "secret_treasure_guide_show",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 显示窗口
				if nil ~= instance then
					instance:setVisible(true)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		-- 隐藏窗口
		local secret_treasure_guide_hide_terminal = {
			_name = "secret_treasure_guide_hide",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				-- 隐藏窗口
				if nil ~= instance then
					instance:setVisible(false)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(secret_treasure_guide_open_terminal)
		state_machine.add(secret_treasure_guide_close_terminal)
		state_machine.add(secret_treasure_guide_show_terminal)
		state_machine.add(secret_treasure_guide_hide_terminal)
		state_machine.init()
	end
	-- call func init secret treasure rule state machine.
	init_secret_treasure_guide_terminal()
end

-- 对象初始化
function SecretTreasureGuide:init(params)
	self._widget = params

	return self
end

function SecretTreasureGuide:updateUI()
	local Panel_3 = self.Panel_3

	-- 计算指引位置
	local selectObject = self._widget
	local size = selectObject:getContentSize()
 	local anchor = selectObject:getAnchorPoint()
	local swp = fwin:convertToWorldSpaceAR(selectObject, cc.p(0, 0))
	local uiPosition = cc.p(0, 0)
	uiPosition.x = uiPosition.x + swp.x / app.scaleFactor + size.width / 2 - size.width * anchor.x
	uiPosition.y = uiPosition.y + swp.y / app.scaleFactor + size.height / 2 - size.height * anchor.y

	Panel_3:setPosition(uiPosition)

	local ArmatureNode_zhiyin_up = self.ArmatureNode_zhiyin_up
	ArmatureNode_zhiyin_up:setVisible(true)

	draw.initArmature(ArmatureNode_zhiyin_up, nil, -1, 0, 1)
	ArmatureNode_zhiyin_up._invoke = nil
	csb.animationChangeToAction(ArmatureNode_zhiyin_up, 0, 0, false)
end

function SecretTreasureGuide:onUpdateDraw()
	local root = self.roots[1]

	local Panel_3 = ccui.Helper:seekWidgetByName(root, "Panel_3")
	self.Panel_3 = Panel_3

	local ArmatureNode_zhiyin_down = Panel_3:getChildByName("ArmatureNode_zhiyin_down")
	ArmatureNode_zhiyin_down:setVisible(false)

	local ArmatureNode_zhiyin = Panel_3:getChildByName("ArmatureNode_zhiyin")
	ArmatureNode_zhiyin:setVisible(false)

	local ArmatureNode_zhiyin_tips = Panel_3:getChildByName("ArmatureNode_zhiyin_tips")
	ArmatureNode_zhiyin_tips:setVisible(false)

	self.ArmatureNode_zhiyin_up = Panel_3:getChildByName("ArmatureNode_zhiyin_up")

	local Panel_black = ccui.Helper:seekWidgetByName(root, "Panel_black")
	Panel_black:setVisible(false)

	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	Panel_2:setVisible(false)

	for i = 2, 7 do
		local Panel = ccui.Helper:seekWidgetByName(root, "Panel_"..i)
		Panel:setTouchEnabled(false)
	end

	self:updateUI()
end

function SecretTreasureGuide:playTuitionAnimation(showType)

end

function SecretTreasureGuide:onEnterTransitionFinish()
	-- 加载SecretTreasureGuideWindow界面资源.
	-- res.utils.teaching = res/utils/teaching.csb
	local csbNode = csb.createNode("utils/teaching.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self:onUpdateDraw()
end

function SecretTreasureGuide:onExit()
	-- 释放SecretTreasureGuideWindow界面资源.
	state_machine.remove("secret_treasure_guide_open")
	state_machine.remove("secret_treasure_guide_close")
	state_machine.remove("secret_treasure_guide_show")
	state_machine.remove("secret_treasure_guide_hide")
end

function SecretTreasureGuide:close()
	-- window event : close.
	
end

function SecretTreasureGuide:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
