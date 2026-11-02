--[[ ----------------------------------------------------------------------------
-- 头像/形象资源cell
--]] ----------------------------------------------------------------------------
HeadPortraitIconCell = class("HeadPortraitIconCellClass", Window)
HeadPortraitIconCell.__size = nil

-- 创建Cell实例
local head_portrait_icon_cell_create_terminal = {
	_name = "head_portrait_icon_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if HeadPortraitIconCell then
			local cell = HeadPortraitIconCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(head_portrait_icon_cell_create_terminal)
state_machine.init()

-- 构造器
function HeadPortraitIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.curImgID = 0			-- 头像/形象ID

	-- load lua files.

	-- Initialize head portrait icon cell page state machine.
	local function init_head_portrait_icon_cell_terminal()
		
	end
	-- call func init head portrait icon cell state machine.
	init_head_portrait_icon_cell_terminal()
end

-- 对象初始化
--unLocked 0 未解锁 1 已解锁
-- {picID = 1, unLocked = false, isChoosed = false, isUsed = false}
function HeadPortraitIconCell:init(params)
	self.index = params.index
	local cellData = params.cellData
	self.picID = cellData.mouldData.picID
	self.unLocked = cellData.unLocked
	self.isChoosed = cellData.isChoosed
	self.isUsed = cellData.isUsed
	if self.index <= 16 then
		self:onInit(params)
	end
	self:setContentSize(HeadPortraitIconCell.__size)
	return self
end

function HeadPortraitIconCell:onUpdateDraw()
	local root = self.roots[1]

	-- 被选中图片显示
	self.Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")

	-- 头像图片容器
	self.Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")

	-- 未解锁容器
	self.Panel_lock = ccui.Helper:seekWidgetByName(root, "Panel_lock")

	-- 使用中图片
	self.Image_using = ccui.Helper:seekWidgetByName(root, "Image_using")

	self:initDrawUI()
end

function HeadPortraitIconCell:initDrawUI()
	local picPath = nil
	if self.picID < 9 then
		picPath = string.format("images/ui/home/head_%d.png", self.picID)
	else
		picPath = string.format("images/ui/props/props_%d.png", self.picID)
	end 
	
	self.Panel_image:setBackGroundImage(picPath)
	self.Panel_lock:setVisible(self.unLocked == false)

	self:updateDrawIsUsed(self.isUsed == true)
	self:updateDrawIsChoosed(self.isChoosed == true)
end

-- 绘制是否被使用
function HeadPortraitIconCell:updateDrawIsUsed(isUsed)
	self.isUsed = isUsed
	self.Image_using:setVisible(isUsed)
end

-- 绘制是否被选中
function HeadPortraitIconCell:updateDrawIsChoosed(isChoosed)
	self.isChoosed = isChoosed
	self.Image_choose:setVisible(isChoosed)
end

function HeadPortraitIconCell:onEnterTransitionFinish()
	
end

function HeadPortraitIconCell:onInit(params)
	-- 加载HeadPortraitIconCellWindow界面资源.
	-- player.head_icon_cell = player/head_icon_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("player/head_icon_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("player/head_icon_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if HeadPortraitIconCell.__size == nil then
		HeadPortraitIconCell.__size = root:getContentSize()
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

function HeadPortraitIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	-- 被选中图片显示
	local Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")
	Image_choose:setVisible(false)
	-- 头像图片容器
	local Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")
	Panel_image:removeBackGroundImage()
	-- 使用中图片
	local Image_using = ccui.Helper:seekWidgetByName(root, "Image_using")
	Image_using:setVisible(false)
	-- 未解锁容器
	local Panel_lock = ccui.Helper:seekWidgetByName(root, "Panel_lock")
	Panel_lock:setVisible(false)
end

function HeadPortraitIconCell:onExit()
	-- 释放HeadPortraitIconCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("player/head_icon_cell.csb", root)
	-- ]]
end

function HeadPortraitIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeadPortraitIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("player/head_icon_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
