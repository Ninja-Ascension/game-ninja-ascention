--[[ ----------------------------------------------------------------------------
-- 头像框印记cell
--]] ----------------------------------------------------------------------------
HeadFrameImprintCell = class("HeadFrameImprintCellClass", Window)
HeadFrameImprintCell.__size = nil

-- 创建Cell实例
local head_frame_imprint_cell_create_terminal = {
	_name = "head_frame_imprint_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if HeadFrameImprintCell then
			local cell = HeadFrameImprintCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(head_frame_imprint_cell_create_terminal)
state_machine.init()

-- 构造器
function HeadFrameImprintCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
	self.isEnough = false
	-- load lua files.

	-- Initialize head frame imprint cell page state machine.
	local function init_head_frame_imprint_cell_terminal()
		
	end
	-- call func init head frame imprint cell state machine.
	init_head_frame_imprint_cell_terminal()
end

-- 对象初始化
-- 头像框数据
-- {params = {curImprintNums = 10, curImPrintInfo = {unLocked = fasle, picID = 0, effectID = 0, curStage = 1, needImprintNums = 0, haveImprintNums = 0}}}
function HeadFrameImprintCell:init(params)
	self.picID = params.picID
	self.curStage = params.curStage
	self.effectID = params.effectID
	self.isChoosed = params.isChoosed
	self.needImprintNums = params.needImprintNums
	self.haveImprintNums = params.haveImprintNums
	self.unLocked = params.unLocked
	self:onInit(params)
	self:setContentSize(HeadFrameImprintCell.__size)
	return self
end

function HeadFrameImprintCell:onUpdateDraw()
	local root = self.roots[1]

	-- 当前阶段数
	self.Text_cur_imprint = ccui.Helper:seekWidgetByName(root, "Text_cur_imprint")

	-- 当前阶段显示内容父节点
	self.Panel_imprint = ccui.Helper:seekWidgetByName(root, "Panel_imprint")

	-- 头像框图片容器
	self.Panel_image = ccui.Helper:seekWidgetByName(root, "Panel_image")

	-- 头像框特效容器
	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

	-- 该阶段需要的印记数量文本
	self.Text_need_nums = ccui.Helper:seekWidgetByName(root, "Text_need_nums")

	-- 未解锁显示
	self.Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")

	-- 当前选中的复选框
	self.CheckBox_choose = ccui.Helper:seekWidgetByName(root, "CheckBox_choose")

	self:initDrawUI()
end

function HeadFrameImprintCell:initDrawUI()
	if self.picID == -1 then
		self.Image_lock:setVisible(true)
		self.Panel_imprint:setVisible(false)
	else
		local picPath = string.format("image/cut/frame/cut_frame_%d.png", self.picID)
		local jsonFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.json", self.effectID, self.effectID)
		local atlasFile = string.format("images/ui/effice/effice_frame_%d/effice_frame_%d.atlas", self.effectID, self.effectID)

		self.Panel_imprint:setVisible(true)
		self.Image_lock:setVisible(false)

		self.Panel_image:removeBackGroundImage()
		self.Panel_effect:removeAllChildren(true)
		
		local isPlayEffect = false
		if true == cc.FileUtils:getInstance():isFileExist(jsonFile) then
			isPlayEffect = true
			local animation = sp.spine(jsonFile, atlasFile, 1, 0, "animation", true, nil)
			self.Panel_effect:addChild(animation)
			animation:setPosition(cc.p(self.Panel_effect:getContentSize().width / 2, self.Panel_effect:getContentSize().height / 2))
		end

		if true == cc.FileUtils:getInstance():isFileExist(picPath) and isPlayEffect == false then
			self.Panel_image:setBackGroundImage(picPath)
		end

		self.Text_need_nums:setString(self.needImprintNums)

		self.isEnough = self.needImprintNums <= self.haveImprintNums
		self.CheckBox_choose:setSelected(false)
		self.CheckBox_choose:setVisible(self.unLocked)
		
		if self.isEnough == false then
			self.CheckBox_choose:setTouchEnabled(false)
			self.CheckBox_choose:setSelected(false)
		end
		self.CheckBox_choose:setBright(self.isEnough == true)

		self:updateDrawSelected(self.isChoosed)

		local function checkBoxCallback()
			state_machine.excute("head_frame_imprint_update_cell_checkbox", 0, self.curStage)
		end
		self.CheckBox_choose:addTouchEventListener(checkBoxCallback)
	end
	
	self.Text_cur_imprint:setString(string.format(tipStringInfo_face_text[2], self.curStage))
end

function HeadFrameImprintCell:updateDrawSelected(isChoosed)
	if self.isEnough then
		self.CheckBox_choose:setTouchEnabled(not isChoosed)
		self.CheckBox_choose:setSelected(isChoosed)
	end
end

function HeadFrameImprintCell:onEnterTransitionFinish()
	
end

function HeadFrameImprintCell:onInit(params)
	-- 加载HeadFrameImprintCellWindow界面资源.
	-- player.imprint_cell = player/imprint_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("player/imprint_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("player/imprint_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if HeadFrameImprintCell.__size == nil then
		HeadFrameImprintCell.__size = root:getContentSize()
	end

	self:onUpdateDraw()
end

function HeadFrameImprintCell:onExit()
	-- 释放HeadFrameImprintCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("player/imprint_cell.csb", root)
	-- ]]
end

function HeadFrameImprintCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function HeadFrameImprintCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("player/imprint_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
