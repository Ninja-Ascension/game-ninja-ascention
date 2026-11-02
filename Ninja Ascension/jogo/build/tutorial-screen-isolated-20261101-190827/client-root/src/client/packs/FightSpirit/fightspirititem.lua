--[[ ----------------------------------------------------------------------------
-- 战魂图标
--]] ----------------------------------------------------------------------------
FightSpiritItem = class("FightSpiritItemClass", Window)
FightSpiritItem.__size = nil

-- 创建Cell实例
local fight_spirit_item_create_terminal = {
	_name = "fight_spirit_item_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritItem then
			local cell = FightSpiritItem:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_item_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritItem:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit item page state machine.
	local function init_fight_spirit_item_terminal()
		-- 打开角色创建窗口
		local fight_spirit_item_open_terminal = {
			_name = "fight_spirit_item_open",
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
		local fight_spirit_item_close_terminal = {
			_name = "fight_spirit_item_close",
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

		-- 显示窗口
		local fight_spirit_item_show_terminal = {
			_name = "fight_spirit_item_show",
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
		local fight_spirit_item_hide_terminal = {
			_name = "fight_spirit_item_hide",
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

		state_machine.add(fight_spirit_item_open_terminal)
		state_machine.add(fight_spirit_item_close_terminal)
		state_machine.add(fight_spirit_item_show_terminal)
		state_machine.add(fight_spirit_item_hide_terminal)
		state_machine.init()
	end
	-- call func init fight spirit item state machine.
	init_fight_spirit_item_terminal()
end

-- 对象初始化
function FightSpiritItem:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritItem.__size)
	return self
end

function FightSpiritItem:onUpdateDraw()
	local root = self.roots[1]

	-- 战魂图标
	self.Panel_item = ccui.Helper:seekWidgetByName(root, "Panel_item")

	-- 加号
	self.Image_add = ccui.Helper:seekWidgetByName(root, "Image_add")

	-- 选中
	self.Image_choosed = ccui.Helper:seekWidgetByName(root, "Image_choosed")

	-- 选中框
	self.Panel_effect_1 = ccui.Helper:seekWidgetByName(root, "Panel_effect_1")

end

function FightSpiritItem:onEnterTransitionFinish()
	
end

function FightSpiritItem:onInit(params)
	-- 加载FightSpiritItemWindow界面资源.
	-- res.cocostudio.packs.FightSpirit_item = res/packs/FightSpirit/FightSpirit_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("packs/FightSpirit/FightSpirit_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if FightSpiritItem.__size == nil then
		FightSpiritItem.__size = root:getContentSize()
	end

	-- 关闭
	self.Button_closed = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_closed"), nil,
	{
		terminal_name = "fight_spirit_item_close",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	


	self:onUpdateDraw()
end

function FightSpiritItem:onExit()
	-- 释放FightSpiritItemWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit/FightSpirit_item.csb", root)
	-- ]]
end

function FightSpiritItem:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritItem:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("packs/FightSpirit/FightSpirit_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
