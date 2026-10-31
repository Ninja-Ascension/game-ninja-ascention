--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
FightSpiritRule = class("FightSpiritRuleClass", Window)

-- 打开窗口
local fight_spirit_rule_window_open_terminal = {
	_name = "fight_spirit_rule_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritRuleClass") then
			fwin:open(FightSpiritRule:new():init(params), fwin._ui)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_rule_window_close_terminal = {
	_name = "fight_spirit_rule_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritRuleClass"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_rule_window_open_terminal)
state_machine.add(fight_spirit_rule_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritRule:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit qianghua sx page state machine.
	local function init_fight_spirit_rule_terminal()
		
	end
	-- call func init fight spirit qianghua sx state machine.
	init_fight_spirit_rule_terminal()
end

-- 对象初始化
function FightSpiritRule:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritRule:onInit(params)

end

function FightSpiritRule:onUpdateDraw()
	local root = self.roots[1]

	
end

function FightSpiritRule:onEnterTransitionFinish()
	-- 加载FightSpiritRuleWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_rule = res/packs/FightSpirit/FightSpirit_rule.csb
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_rule.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

    -- 关闭
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_rule_closed"), nil,
	{
		terminal_name = "fight_spirit_rule_window_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function FightSpiritRule:onExit()
	-- 释放FightSpiritRuleWindow界面资源.
	
end

function FightSpiritRule:close()
	-- window event : close.
	
end

function FightSpiritRule:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
