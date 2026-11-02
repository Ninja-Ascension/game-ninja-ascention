--[[ ----------------------------------------------------------------------------
-- 称号资源cell
--]] ----------------------------------------------------------------------------
HeadTtileIconCell = class("HeadTtileIconCellClass", Window)
HeadTtileIconCell.__size = nil

-- 创建Cell实例
local head_ttile_icon_cell_create_terminal = {
	_name = "head_ttile_icon_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if HeadTtileIconCell then
			local cell = HeadTtileIconCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(head_ttile_icon_cell_create_terminal)
state_machine.init()

-- 构造器
function HeadTtileIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize head ttile icon cell page state machine.
	local function init_head_ttile_icon_cell_terminal()
		
	end
	-- call func init head ttile icon cell state machine.
	init_head_ttile_icon_cell_terminal()
end

-- 对象初始化
-- 形象ID		当前解锁还是未解锁		是否被选中		是否被使用
-- {titleID = 1, unLocked = false, isChoosed = false, isUsed = false}
function HeadTtileIconCell:init(params)
	self.index = params.index
	local cellData = params.cellData
	self.titleID = cellData.titleID
	self.unLocked = cellData.unLocked
	self.isChoosed = cellData.isChoosed
	self.isUsed = cellData.isUsed
	if self.index <= 14 then
		self:onInit(params)
	end
	self:setContentSize(HeadTtileIconCell.__size)
	return self
end

function HeadTtileIconCell:onUpdateDraw()
	local root = self.roots[1]

	-- 被选中图片显示
	self.Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")

	-- 称号图片容器
	self.Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")

	-- 使用中图片
	self.Image_using = ccui.Helper:seekWidgetByName(root, "Image_using")

	self:initDrawUI()
end

function HeadTtileIconCell:initDrawUI()
	local titlePicID = dms.string(dms["title_param"], self.titleID, title_param.pic_index)
	local picPath = string.format("images/ui/text/title/title_%s.png", titlePicID)
	local imageSize = self.Panel_image:getContentSize()
	local SpritTitle = cc.Sprite:create(picPath)
    SpritTitle:setAnchorPoint(cc.p(0.5,0.5))
    SpritTitle:setPosition(cc.p(imageSize.width / 2 , imageSize.height / 2))
    self.Panel_image:addChild(SpritTitle,-1)
	if self.unLocked == false then
        display:gray(SpritTitle)
        self.Button_choose:setBright(false)
	end

	self:updateDrawIsUsed(self.isUsed)
	self:updateDrawIsChoosed(self.isChoosed)
end

-- 称号是否被使用
function HeadTtileIconCell:updateDrawIsUsed(isUsed)
	self.isUsed = isUsed
	self.Image_using:setVisible(isUsed)
end

-- 称号是否被选中
function HeadTtileIconCell:updateDrawIsChoosed(isChoosed)
	self.isChoosed = isChoosed
	self.Image_choose:setVisible(isChoosed)
end

function HeadTtileIconCell:onEnterTransitionFinish()
	
end

function HeadTtileIconCell:onInit(params)
	-- 加载HeadTtileIconCellWindow界面资源.
	-- player.head_title_cell = player/head_title_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("player/head_title_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("player/head_title_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if HeadTtileIconCell.__size == nil then
		HeadTtileIconCell.__size = root:getContentSize()
	end

	-- 选中按钮
	self.Button_choose = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_choose"), nil,
	{
		terminal_name = "personality_setting_main_change_cell",
		terminal_state = 0,
		isPressedActionEnabled = true,
		chooseIdx = self.index
	}, nil, 0)	

	self:clearUIInfo()
	self:onUpdateDraw()
end

function HeadTtileIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	-- 被选中图片显示
	local Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")
	Image_choose:setVisible(false)
	-- 称号图片容器
	local Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")
	Panel_image:removeAllChildren(true)
	-- 使用中图片
	local Image_using = ccui.Helper:seekWidgetByName(root, "Image_using")
	Image_using:setVisible(false)
	-- 选择按钮
	local Button_choose = ccui.Helper:seekWidgetByName(root, "Button_choose")
	Button_choose:setBright(true)
end

function HeadTtileIconCell:onExit()
	-- 释放HeadTtileIconCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("player/head_title_cell.csb", root)
	-- ]]
end

function HeadTtileIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeadTtileIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("player/head_title_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
