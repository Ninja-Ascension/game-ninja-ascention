--[[ ----------------------------------------------------------------------------
-- 头像通用ICON
--]] ----------------------------------------------------------------------------
HeadItemIconCell = class("HeadItemIconCellClass", Window)
HeadItemIconCell.__size = nil

-- 创建Cell实例
local head_item_Icon_cell_create_terminal = {
	_name = "head_item_Icon_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if HeadItemIconCell then
			local cell = HeadItemIconCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(head_item_Icon_cell_create_terminal)
state_machine.init()

-- 构造器
function HeadItemIconCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize head frame icon cell page state machine.
	local function init_head_item_Icon_cell_terminal()
		
	end
	-- call func init head frame icon cell state machine.
	init_head_item_Icon_cell_terminal()
end

-- 对象初始化
-- 头像框ID， 头像框阶段， 头像ID， VIP等级
-- headInfo = {headFrameID = 1, headFrameStage = 1, headID = 1}, vipLevel = 1
function HeadItemIconCell:init(params)
	self.headInfo = params.headInfo
	if self.headInfo.headFrameID == nil or self.headInfo.headFrameStage == "" then
		self.headInfo.headFrameID = -1
		self.headInfo.headFrameStage = -1
	end
	self.vipLevel = params.vipLevel

	self:onInit(params)
	self:setContentSize(HeadItemIconCell.__size)
	return self
end

function HeadItemIconCell:onUpdateDraw()
	local root = self.roots[1]

	-- 头像图片容器
	self.Panel_head_portrait = ccui.Helper:seekWidgetByName(root, "Panel_head_portrait")

	-- 头像框图片容器
	self.Panel_head_frame = ccui.Helper:seekWidgetByName(root, "Panel_head_frame")

	-- 头像框特效容器
	self.Panel_head_effect = ccui.Helper:seekWidgetByName(root, "Panel_head_effect")

	-- VIP等级父节点
	self.Panel_vip = ccui.Helper:seekWidgetByName(root, "Panel_vip")

	-- VIP等级文本
	self.Text_vip_level = ccui.Helper:seekWidgetByName(root, "Text_vip_level")

	self:initDrawUI()
end

function HeadItemIconCell:initDrawUI()
	self:udpateDrawHead()
	self:updateDrawVip()
end

-- 绘制头像内容
function HeadItemIconCell:udpateDrawHead()
	local headPicPath = nil

	local headID = self.headInfo.headID
	if headID < 9 then
		headPicPath = string.format("images/ui/home/head_%d.png", headID)
	else
		headPicPath = string.format("images/ui/props/props_%d.png", headID)
	end 
	-- 头像图片
	self.Panel_head_portrait:setBackGroundImage(headPicPath)

	if self.headInfo.headFrameID ~= -1 then
		local headFramePicID, headFrameEffectID = self:getHeadFramePicAndEffectID()
		local headFramePicPath = string.format("image/cut/frame/cut_frame_%d.png", headFramePicID)
		local jsonFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.json", headFrameEffectID, headFrameEffectID)
		local atlasFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.atlas", headFrameEffectID, headFrameEffectID)

		local isPlayEffect = false
		if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
			isPlayEffect = true

			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			animation:setPosition(cc.p(self.Panel_head_effect:getContentSize().width / 2, self.Panel_head_effect:getContentSize().height / 2))
			self.Panel_head_effect:addChild(animation)
		end
		-- 头像框图片
		if true == cc.FileUtils:getInstance():isFileExist(headFramePicPath) and isPlayEffect == false then
			self.Panel_head_frame:setBackGroundImage(headFramePicPath)
		end
	end

end

function HeadItemIconCell:getHeadFramePicAndEffectID()
	local headFrameInfo = dms.searchs(dms["face_frame_mould"], face_frame_mould.id, self.headInfo.headFrameID)[1]
	local picIndexInfo = zstring.split(dms.atos(headFrameInfo, face_frame_mould.bgIDInfo), ",", tonumber)
	local effectIndexInfo = zstring.split(dms.atos(headFrameInfo, face_frame_mould.effectIDInfo), ",", tonumber)

	local picID = picIndexInfo[self.headInfo.headFrameStage]
	local effectID = effectIndexInfo[self.headInfo.headFrameStage]

	return picID, effectID
end

-- 绘制vip等级
function HeadItemIconCell:updateDrawVip()
	if self.vipLevel ~= nil then
		self.Panel_vip:setVisible(true)
		self.Text_vip_level:setString(self.vipLevel)
	end
end

function HeadItemIconCell:onEnterTransitionFinish()
	
end

function HeadItemIconCell:onInit(params)
	-- 加载HeadItemIconCellWindow界面资源.
	-- player.head = player/head.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("player/head.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("player/head.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if HeadItemIconCell.__size == nil then
		HeadItemIconCell.__size = root:getContentSize()
	end

	self:clearUIInfo()
	self:onUpdateDraw()
end

function HeadItemIconCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end
	
	-- 头像图片容器
	local Panel_head_portrait = ccui.Helper:seekWidgetByName(root, "Panel_head_portrait")
	Panel_head_portrait:removeBackGroundImage()
	-- 头像框图片容器
	local Panel_head_frame = ccui.Helper:seekWidgetByName(root, "Panel_head_frame")
	Panel_head_frame:removeBackGroundImage()
	-- 头像框特效容器
	local Panel_head_effect = ccui.Helper:seekWidgetByName(root, "Panel_head_effect")
	Panel_head_effect:removeAllChildren(true)
	-- VIP等级父节点
	local Panel_vip = ccui.Helper:seekWidgetByName(root, "Panel_vip")
	Panel_vip:setVisible(false)
	-- VIP等级文本
	local Text_vip_level = ccui.Helper:seekWidgetByName(root, "Text_vip_level")
	Text_vip_level:setString("")
end

function HeadItemIconCell:onExit()
	-- 释放HeadItemIconCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("player/head.csb", root)
	-- ]]
end

function HeadItemIconCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeadItemIconCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("player/head.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
