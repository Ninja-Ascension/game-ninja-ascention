--[[ ----------------------------------------------------------------------------
-- 技能弹窗cell
--]] ----------------------------------------------------------------------------
MythicalAnimalsSkillTipCell = class("MythicalAnimalsSkillTipCellClass", Window)
MythicalAnimalsSkillTipCell.__size = nil

-- 创建Cell实例
local mythical_animals_skill_tip_cell_create_terminal = {
	_name = "mythical_animals_skill_tip_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if MythicalAnimalsSkillTipCell then
			local cell = MythicalAnimalsSkillTipCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(mythical_animals_skill_tip_cell_create_terminal)
state_machine.init()

-- 构造器
function MythicalAnimalsSkillTipCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_mythical_animals_skill_tip_cell_terminal()
		
	end
	-- call func init ninja biographies0 cell state machine.
	init_mythical_animals_skill_tip_cell_terminal()
end

-- 对象初始化
function MythicalAnimalsSkillTipCell:init(params)
	self._index = params.index
	self._talentMouldId = params.talentMouldId

	-- 当前神兽星级
	self._curStar = params.curStar

	self:onInit(params)
	
	self:setContentSize(MythicalAnimalsSkillTipCell.__size)
	return self
end

function MythicalAnimalsSkillTipCell:onUpdateDraw()
	local root = self.roots[1]

	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")

	self.Image_star = {}
	for i = 1, 5 do
		local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
		table.insert(self.Image_star, Image_star)
	end

	self.Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")

	self:updateUI()
end

function MythicalAnimalsSkillTipCell:updateUI()
	local desNameId = dms.int(dms["talent_mould"], tonumber(self._talentMouldId), talent_mould.talent_describe)
	local word_info = dms.element(dms["word_mould"], desNameId)
	local desName = word_info[3]
	self.Text_2_0:setString(desName)

	if self._curStar >= self._index then
		self.Text_2_0:setColor((cc.c3b(color_Type[2][1], color_Type[2][2], color_Type[2][3])))
	else
		self.Text_2_0:setColor((cc.c3b(color_Type[1][1], color_Type[1][2], color_Type[1][3])))
	end

	local star = self._index
	for i, v in ipairs(self.Image_star) do
		v:setVisible(i <= star)
	end

	local textRenderSize = self.Text_2_0:getAutoRenderSize() -- 未换行前尺寸
    local VirtualRendererSize = self.Text_2_0:getVirtualRendererSize() -- 控件本身可渲染尺寸
    local needRowNumber = math.ceil(textRenderSize.width / VirtualRendererSize.width)
    local currRowNumber = math.floor(VirtualRendererSize.height / textRenderSize.height)
    local curHeight = 0

    curHeight = (needRowNumber - currRowNumber) * textRenderSize.height + self.Text_2_0:getFontSize() + 10

    self.Text_2_0:setContentSize(cc.size(self.Text_2_0:getContentSize().width , self.Text_2_0:getContentSize().height + curHeight))
    self.Panel_star:setPosition(cc.p(self.Panel_star:getPositionX() , self.Panel_star:getPositionY() + curHeight))
    self.roots[1]:setContentSize(cc.size(self.roots[1]:getContentSize().width , self.roots[1]:getContentSize().height + curHeight))

    self._cellHeight = self.roots[1]:getContentSize().height
end

function MythicalAnimalsSkillTipCell:onInit(params)
	-- 加载MythicalAnimalsSkillTipCellWindow界面资源.
	-- res.cultivate.Mythical_animals.mythical_animals_prop_1 = res/cultivate/Mythical_animals/mythical_animals_prop_1.csb
	 -- 不使用缓存创建
	local csbNode = csb.createNode("cultivate/Mythical_animals/mythical_animals_prop_1.csb")
	local root = csbNode:getChildByName("root")
	
	-- [[ 使用缓存创建
	-- local root = cacher.createUIRef("cultivate/Mythical_animals/mythical_animals_prop_1.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if MythicalAnimalsSkillTipCell.__size == nil then
		MythicalAnimalsSkillTipCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function MythicalAnimalsSkillTipCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	self.Text_2_0:setString("")

	for i = 1, 5 do
		local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
		if Image_star then
			Image_star:setVisible(false)
		end
	end
end

function MythicalAnimalsSkillTipCell:onExit()
	-- 释放MythicalAnimalsSkillTipCellWindow界面资源.
	-- self:clearUIInfo()
	-- [[ 释放缓存
	-- local root = self.roots[1]
	-- cacher.freeRef("cultivate/Mythical_animals/mythical_animals_prop_1.csb", root)
	-- ]]
end

function MythicalAnimalsSkillTipCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function MythicalAnimalsSkillTipCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	-- self:clearUIInfo()
	-- self:stopAllActions()
	-- root:removeFromParent(false)
	-- cacher.freeRef("cultivate/Mythical_animals/mythical_animals_prop_1.csb", root)
	
	-- self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
