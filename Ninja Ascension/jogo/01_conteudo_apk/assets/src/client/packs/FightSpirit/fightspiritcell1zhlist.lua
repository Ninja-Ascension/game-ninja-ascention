--[[ ----------------------------------------------------------------------------
-- 战魂推荐框
--]] ----------------------------------------------------------------------------
FightSpiritCell1ZhList = class("FightSpiritCell1ZhListClass", Window)
FightSpiritCell1ZhList.__size = nil

-- 创建Cell实例
local fight_spirit_cell1_zh_list_create_terminal = {
	_name = "fight_spirit_cell1_zh_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if FightSpiritCell1ZhList then
			local cell = FightSpiritCell1ZhList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(fight_spirit_cell1_zh_list_create_terminal)
state_machine.init()

-- 构造器
function FightSpiritCell1ZhList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize fight spirit cell1 zh list page state machine.
	local function init_fight_spirit_cell1_zh_list_terminal()
		
	end
	-- call func init fight spirit cell1 zh list state machine.
	init_fight_spirit_cell1_zh_list_terminal()
end

-- 对象初始化
function FightSpiritCell1ZhList:init(params)
	self:onInit(params)
	self:setContentSize(FightSpiritCell1ZhList.__size)
	return self
end

function FightSpiritCell1ZhList:onUpdateDraw()
	local root = self.roots[1]

	local iconContainer = ccui.Helper:seekWidgetByName(root, "Panel_zh_icon")
	local icon1 = cc.Sprite:create(string.format("images/ui/quality/icon_enemy_%d.png", 7))
	icon1:setAnchorPoint(cc.p(0,0))
	iconContainer:addChild(icon1)
	local propId = dms.string(dms["fight_spirit_suit_mould"], self._suitId, fight_spirit_suit_mould.prop_id)
	local icon2 = cc.Sprite:create(string.format("images/ui/props/props_%d.png", propId))
	iconContainer:addChild(icon2)
	icon2:setPosition(60,60)

	local nameId = dms.int(dms["fight_spirit_suit_mould"], self._suitId, fight_spirit_suit_mould.suit_name)
	ccui.Helper:seekWidgetByName(root, "Text_name"):setString(dms.element(dms["word_mould"], nameId)[3])
	ccui.Helper:seekWidgetByName(root, "Text_nem"):setString(self._count)
	local descId = dms.int(dms["fight_spirit_suit_mould"], self._suitId, fight_spirit_suit_mould.desc)
	ccui.Helper:seekWidgetByName(root, "Text_use"):setString(dms.element(dms["word_mould"], descId)[3])
end

function FightSpiritCell1ZhList:onEnterTransitionFinish()
	
end

function FightSpiritCell1ZhList:onInit(params)
	-- 加载FightSpiritCell1ZhListWindow界面资源.
	-- res.packs.FightSpirit_cell_1_zh_list = res/packs/FightSpirit_cell_1_zh_list.csb
	 -- 不使用缓存创建
	local csbNode = csb.createNode("packs/FightSpirit/FightSpirit_cell_1_zh_list.csb")
	local root = csbNode:getChildByName("root")
	
	-- [[ 使用缓存创建
	-- local root = cacher.createUIRef("packs/FightSpirit/FightSpirit_cell_1_zh_list.csb", "root")
	-- ]]
	-- root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(csbNode)
	if FightSpiritCell1ZhList.__size == nil then
		FightSpiritCell1ZhList.__size = root:getContentSize()
	end

	self._suitId = params.suitId
	self._count = params.count

	ccui.Helper:seekWidgetByName(root, "Image_4"):setSwallowTouches(false)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_4"), nil,
	{
		terminal_name = "fight_spirit_main_choose_suit",
		terminal_state = 0,
		isPressedActionEnabled = true,
		suitId = self._suitId,
	}, nil, 0)

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_det"), nil,
	{
		terminal_name = "fight_spirit_zh_skill_window_open",
		terminal_state = 0,
		isPressedActionEnabled = true,
		suitId = self._suitId,
	}, nil, 0)

	self:onUpdateDraw()
end

function FightSpiritCell1ZhList:onExit()
	-- 释放FightSpiritCell1ZhListWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("packs/FightSpirit_cell_1_zh_list.csb", root)
	-- ]]
end

function FightSpiritCell1ZhList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function FightSpiritCell1ZhList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("packs/FightSpirit_cell_1_zh_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
