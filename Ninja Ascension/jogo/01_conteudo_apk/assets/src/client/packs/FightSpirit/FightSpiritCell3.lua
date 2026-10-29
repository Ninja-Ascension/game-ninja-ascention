--[[ ----------------------------------------------------------------------------
-- 觉醒界面
--]] ----------------------------------------------------------------------------
FightSpiritCell3 = class("FightSpiritCell3Class", Window)

-- 打开窗口
local fight_spirit_cell3_window_open_terminal = {
	_name = "fight_spirit_cell3_window_open",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if nil == fwin:find("FightSpiritCell3Class") then
			fwin:open(FightSpiritCell3:new():init(params), fwin._view)
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

-- 关闭窗口
local fight_spirit_cell3_window_close_terminal = {
	_name = "fight_spirit_cell3_window_close",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		fwin:close(fwin:find("FightSpiritCell3Class"))
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_cell3_window_open_terminal)
state_machine.add(fight_spirit_cell3_window_close_terminal)
state_machine.init()

-- 构造器
function FightSpiritCell3:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit cell3 page state machine.
	local function init_fight_spirit_cell3_terminal()
		
	end
	-- call func init fight spirit cell3 state machine.
	init_fight_spirit_cell3_terminal()
end

-- 对象初始化
function FightSpiritCell3:init(params)
	if nil ~= self.onInit then
		self:onInit(params)
	end
	return self
end

function FightSpiritCell3:onUpdateDraw()
	local root = self.roots[1]

end

function FightSpiritCell3:onEnterTransitionFinish()
	-- 加载FightSpiritCell3Window界面资源.
	-- res.packs.FightSpirit_cell_3 = res/packs/FightSpirit_cell_3.csb
	local csbNode = csb.createNode("packs/FightSpirit_cell_3.csb")
	local root = csbNode:getChildByName("root")
	table.insert(self.roots, root)
	self:addChild(csbNode)

	self:onUpdateDraw()
end

function FightSpiritCell3:onExit()
	-- 释放FightSpiritCell3Window界面资源.
	
end

function FightSpiritCell3:close()
	-- window event : close.
	
end

function FightSpiritCell3:destroy(window)
	-- window event : destroy.
	
end

-- ~END
-- ----------------------------------------------------------------------------
