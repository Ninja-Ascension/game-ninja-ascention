--[[ ----------------------------------------------------------------------------
-- 左侧天命阶数石头
--]] ----------------------------------------------------------------------------
MythicalAnimalsDestinyStoneCell = class("MythicalAnimalsDestinyStoneCellClass", Window)
MythicalAnimalsDestinyStoneCell.__size = nil

-- 创建Cell实例
local mythical_animals_dstiny_stone_cell_create_terminal = {
	_name = "mythical_animals_dstiny_stone_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsDestinyStoneCell then
			local cell = MythicalAnimalsDestinyStoneCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_dstiny_stone_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsDestinyStoneCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_dstiny_stone_cell_terminal()
		local mythical_animals_dstiny_stone_cell_select_terminal = {
			_name = "mythical_animals_dstiny_stone_cell_select",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local cell = params._datas._self
				if cell then
					local selectIndex = cell._index
					local curStep = MythicalAnimalsHandle.getCurDestinyStep()

					if selectIndex <= curStep + 1 then
						state_machine.excute("mythical_animals_destiny_refresh_ui", 0, selectIndex)
					else
						TipDlg.drawTextDailog(tipStringInfo_magical_animals_word[1])
					end
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(mythical_animals_dstiny_stone_cell_select_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_dstiny_stone_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsDestinyStoneCell:init(params)
	self._index = params.index

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsDestinyStoneCell.__size)
	return self
end

function MythicalAnimalsDestinyStoneCell:onUpdateDraw()
	local root = self.roots[1]

	-- 选中
	self.Panel_animals_prop_box = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_animals_prop_box"), nil,
	{
		terminal_name = "mythical_animals_dstiny_stone_cell_select",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_self = self
	}, nil, 0)	

	-- 容器
	self.Panel_talent = ccui.Helper:seekWidgetByName(root, "Panel_talent")
	-- 动画
	self.Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
	-- 名字
	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	-- 选中光效
	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")

	self:updateUI()
end

function MythicalAnimalsDestinyStoneCell:updateUI()
	local Panel_talent = self.Panel_talent
	Panel_talent:removeAllChildren(true)

	local stonePicIndex, stageMouldId = MythicalAnimalsHandle.getDestinyLeftIconInfoByStage(self._index)

	local sp = cc.Sprite:create(string.format("images/ui/text/TF_res/Mythical_animals/mythical_icon/mythical_icon_%d.png", stonePicIndex))
	sp:setPosition(cc.p(Panel_talent:getContentSize().width/2, Panel_talent:getContentSize().height/2))

	local curStep = MythicalAnimalsHandle.getCurDestinyStep()
	if self._index <= curStep + 1 then
		display:ungray(sp)
	else
		display:gray(sp)
	end

	Panel_talent:addChild(sp)

	local word_info = dms.element(dms["word_mould"], stageMouldId)
	self.Text_name:setString(word_info[3])
end

function MythicalAnimalsDestinyStoneCell:setSelectState(isShow)
	self.Image_select:setVisible(isShow)
end

function MythicalAnimalsDestinyStoneCell:onInit(params)
	-- 加载MythicalAnimalsDestinyStoneCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_talent_item = res/cultivate/Mythical_animals/mythical_animals_talent_item.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_talent_item.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_talent_item.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsDestinyStoneCell.__size == nil then
		MythicalAnimalsDestinyStoneCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsDestinyStoneCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_talent = ccui.Helper:seekWidgetByName(root, "Panel_talent")
	self.Panel_talent:removeAllChildren(true)

	self.Panel_donghua = ccui.Helper:seekWidgetByName(root, "Panel_donghua")
	self.Panel_donghua:removeAllChildren(true)

	self.Text_name = ccui.Helper:seekWidgetByName(root, "Text_name")
	self.Text_name:setString("")

	self.Image_select = ccui.Helper:seekWidgetByName(root, "Image_select")
	self.Image_select:setVisible(false)
end

function MythicalAnimalsDestinyStoneCell:onExit()
	-- 释放MythicalAnimalsDestinyStoneCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_talent_item.csb", root)
	-- ]]
end

function MythicalAnimalsDestinyStoneCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsDestinyStoneCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/Mythical_animals/mythical_animals_talent_item.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
