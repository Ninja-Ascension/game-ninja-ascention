--[[ ----------------------------------------------------------------------------
-- 头像框资源cell
--]] ----------------------------------------------------------------------------
HeadFrameIconCell = class("HeadFrameIconCellClass", Window)
HeadFrameIconCell.__size = nil

-- 创建Cell实例
local head_frame_icon_cell_create_terminal = {
	_name = "head_frame_icon_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if HeadFrameIconCell then
			local cell = HeadFrameIconCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(head_frame_icon_cell_create_terminal)
state_machine.init()

-- 构造器
function HeadFrameIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize head frame icon cell page state machine.
	local function init_head_frame_icon_cell_terminal()
		
	end
	-- call func init head frame icon cell state machine.
	init_head_frame_icon_cell_terminal()
end

-- 对象初始化
-- 头像框ID			当前解锁还是未解锁		是否被选中		是否被使用
-- {headFrameID = 1,  unLocked = true, isChoosed = false, isUsed = false}
function HeadFrameIconCell:init(params)
	self.index = params.index
	local cellData = params.cellData
	self.cellData = cellData
	self.headFrameID = cellData.mouldData.headFrameID
	self.unLocked = cellData.unLocked
	self.isChoosed = cellData.isChoosed
	self.isUsed = cellData.isUsed
	if self.index <= 16 then
		self:onInit(params)
	end
	self:setContentSize(HeadFrameIconCell.__size)
	return self
end

function HeadFrameIconCell:onUpdateDraw()
	local root = self.roots[1]

	-- 被选中图片显示
	self.Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")

	-- 头像框图片容器
	self.Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")

	-- 头像框特效容器
	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

	-- 未解锁图片
	self.Image_locked = ccui.Helper:seekWidgetByName(root, "Image_locked")

	-- 使用中图片
	self.Image_using = ccui.Helper:seekWidgetByName(root, "Image_using")

	-- 红点图片
	self.Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")

	self:initDrawUI()
end

function HeadFrameIconCell:initDrawUI()
	self:updateDrawHeadFrame()
	self:updateDrawIsUsed(self.isUsed)
	self:updateDrawIsChoosed(self.isChoosed)
	self:updateDrawRedDot()
end

-- 获取头像框阶段
function HeadFrameIconCell:getCurStage()
	local curStage = 1

	if self.isUsed == true then
		curStage = _ED.user_info.head_frame.curHeadFrameStage
	elseif self.unLocked == true then
		curStage = self.cellData.maxStage
	end

	return curStage
end

-- 绘制头像框内容
function HeadFrameIconCell:updateDrawHeadFrame()
	self.Panel_image:removeBackGroundImage()
	self.Panel_effect:removeAllChildren(true)

	local curStage = self:getCurStage()
	local picIndexInfo = self.cellData.mouldData.bgIDInfo
	local effectIndexInfo = self.cellData.mouldData.effectIDInfo

	local picIndex = picIndexInfo[curStage]
	local effectIndex = effectIndexInfo[curStage]

	local picPath = string.format("image/cut/frame/cut_frame_%d.png", picIndex)
	local jsonFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.json", effectIndex, effectIndex)
	local atlasFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.atlas", effectIndex, effectIndex)

	local isPlayEffect = false
	if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
		isPlayEffect = true

		local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
		animation:setPosition(cc.p(self.Panel_effect:getContentSize().width / 2, self.Panel_effect:getContentSize().height / 2))
		self.Panel_effect:addChild(animation)
	end

	if true == cc.FileUtils:getInstance():isFileExist(picPath) and isPlayEffect == false then
		self.Panel_image:setBackGroundImage(picPath)
	end

	self.Image_locked:setVisible(self.unLocked == false)
end

-- 头像框是否被使用
function HeadFrameIconCell:updateDrawIsUsed(isUsed)
	self.isUsed = isUsed
	self.Image_using:setVisible(isUsed)
end

-- 头像框是否被选中
function HeadFrameIconCell:updateDrawIsChoosed(isChoosed)
	self.isChoosed = isChoosed
	self.Image_choose:setVisible(isChoosed)
end

-- 绘制红点信息
function HeadFrameIconCell:updateDrawRedDot()
	self.Image_red:setVisible(getPlayerHeadFrameStateByID(self.headFrameID))
end

function HeadFrameIconCell:onEnterTransitionFinish()
	
end

function HeadFrameIconCell:onInit(params)
	-- 加载HeadFrameIconCellWindow界面资源.
	-- player.head_frame_cell = player/head_frame_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("player/head_frame_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("player/head_frame_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if HeadFrameIconCell.__size == nil then
		HeadFrameIconCell.__size = root:getContentSize()
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

function HeadFrameIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	-- 被选中图片显示
	local Image_choose = ccui.Helper:seekWidgetByName(root, "Image_choose")
	Image_choose:setVisible(false)
	-- 头像框图片容器
	local Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")
	Panel_image:removeBackGroundImage()
	-- 头像框特效容器
	local Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	Panel_effect:removeAllChildren(true)
	-- 未解锁图片
	local Image_locked = ccui.Helper:seekWidgetByName(root, "Image_locked")
	Image_locked:setVisible(false)
	-- 使用中图片
	local Image_using = ccui.Helper:seekWidgetByName(root, "Image_using")
	Image_using:setVisible(false)
	-- 红点图片
	local Image_red = ccui.Helper:seekWidgetByName(root, "Image_red")
	Image_red:setVisible(false)
end

function HeadFrameIconCell:onExit()
	-- 释放HeadFrameIconCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("player/head_frame_cell.csb", root)
	-- ]]
end

function HeadFrameIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeadFrameIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("player/head_frame_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
