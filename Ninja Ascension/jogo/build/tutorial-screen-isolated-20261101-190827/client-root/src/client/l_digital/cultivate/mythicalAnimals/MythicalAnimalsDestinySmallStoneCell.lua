--[[ ----------------------------------------------------------------------------
-- 神兽页签中间icon cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsDestinySmallStoneCell = class("MythicalAnimalsDestinySmallStoneCellClass", Window)
MythicalAnimalsDestinySmallStoneCell.__size = nil

-- 创建Cell实例
local mythical_animals_destiny_small_stone_cell_create_terminal = {
	_name = "mythical_animals_destiny_small_stone_cell",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsDestinySmallStoneCell then
			local cell = MythicalAnimalsDestinySmallStoneCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_destiny_small_stone_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsDestinySmallStoneCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_icon_cell_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_icon_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsDestinySmallStoneCell:init(params)
	self._index = params.index
	self._curLeftSelectIndex = params.curLeftSelectIndex

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsDestinySmallStoneCell.__size)
	return self
end

function MythicalAnimalsDestinySmallStoneCell:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_stone = ccui.Helper:seekWidgetByName(root, "Panel_stone")
	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")
	self.Label_name = ccui.Helper:seekWidgetByName(root, "Label_name")

	self:updateUI()
end

function MythicalAnimalsDestinySmallStoneCell:updateUI()
	local curStep = MythicalAnimalsHandle.getCurDestinyStep() + 1
	local curProgress = MythicalAnimalsHandle.getCurDestinyProgress()

	local picIndex = self._index

	-- 如果当前选中的左侧天命小于已激活天命阶数 则高亮
	self.Image_select:setVisible(false)
	if self._curLeftSelectIndex < curStep then
		self.Image_select:setVisible(true)
	else
		self.Image_select:setVisible(self._index <= curProgress)
		if self._index > curProgress then
			picIndex = 6
		end
	end

	local headSp = cc.Sprite:create(string.format("images/ui/text/TF_res/Mythical_animals/mythical_destiny_nature_%d.png", picIndex))
	self.Panel_stone:removeAllChildren(true)
	headSp:setPosition(cc.p(self.Panel_stone:getContentSize().width/2, self.Panel_stone:getContentSize().height/2))
	self.Panel_stone:addChild(headSp)

	local propertyStr = MythicalAnimalsHandle.getDestinyPropertyString(self._curLeftSelectIndex, self._index)
	self.Label_name:setString(propertyStr)
end

function MythicalAnimalsDestinySmallStoneCell:onInit(params)
	-- 加载MythicalAnimalsDestinySmallStoneCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_stone_item = res/cultivate/Mythical_animals/mythical_animals_stone_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_stone_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_stone_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsDestinySmallStoneCell.__size == nil then
		MythicalAnimalsDestinySmallStoneCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsDestinySmallStoneCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_stone = ccui.Helper:seekWidgetByName(root, "Panel_stone")
	self.Panel_stone:removeAllChildren(true)

	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")
	self.Image_select:setVisible(false)

	self.Label_name = ccui.Helper:seekWidgetByName(root, "Label_name")
	self.Label_name:setString("")
end

function MythicalAnimalsDestinySmallStoneCell:onExit()
	-- 释放MythicalAnimalsDestinySmallStoneCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_stone_item.csb", root)
	-- ]]
end

function MythicalAnimalsDestinySmallStoneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsDestinySmallStoneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_stone_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
