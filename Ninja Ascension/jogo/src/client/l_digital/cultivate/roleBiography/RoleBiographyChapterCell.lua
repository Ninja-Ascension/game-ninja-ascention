--[[ ----------------------------------------------------------------------------
-- 章节cell
--]] ----------------------------------------------------------------------------
RoleBiographyChapterCell = class("RoleBiographyChapterCellClass", Window)
RoleBiographyChapterCell.__size = nil

-- 创建Cell实例
local role_biography_chapter_cell_create_terminal = {
	_name = "role_biography_chapter_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyChapterCell then
			local cell = RoleBiographyChapterCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_chapter_cell_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyChapterCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies cell page state machine.
	local function init_role_biography_chapter_cell_terminal()
		local role_biography_chapter_cell_open_biography_window_terminal = {
			_name = "role_biography_chapter_cell_open_biography_window",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local unlock = params._datas._unlock
				if unlock == false then
					TipDlg.drawTextDailog(tipStringInfo_role_biography[8])
					return true
				end

				local chapterId = params._datas._chapterId
				state_machine.excute("role_biography_window_open", 0, chapterId)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_chapter_cell_open_biography_window_terminal)
	end
	-- call func init ninja biographies cell state machine.
	init_role_biography_chapter_cell_terminal()
end

-- 对象初始化
function RoleBiographyChapterCell:init(params)
	self._data = params

	self._chapterId = dms.atof(self._data, biographies_section_mould.id)

	self._unlock = RoleBiographyHandle.getChapterLockState(self._chapterId)

	self:onInit(params)
	self:setContentSize(RoleBiographyChapterCell.__size)
	return self
end

function RoleBiographyChapterCell:onUpdateDraw()
	local root = self.roots[1]

	self.Panel_pic = ccui.Helper:seekWidgetByName(root, "Panel_pic")
	self.Text_charactor = ccui.Helper:seekWidgetByName(root, "Text_charactor")
	self.Text_quantity_1 = ccui.Helper:seekWidgetByName(root, "Text_quantity_1")
	self.Image_lock = ccui.Helper:seekWidgetByName(root, "Image_lock")

	self.Panel_pic:removeAllChildren(true)

	local pic = dms.atof(self._data, biographies_section_mould.pic)
	local headSp = cc.Sprite:create(string.format("images/ui/text/TF_res/ninja_biographies/imprint/rlz_%d.png", pic))
	if self._unlock == true then
		display:ungray(headSp)
		self.Image_lock:setVisible(false)
	else
		display:gray(headSp)
		self.Image_lock:setVisible(true)
	end

	headSp:setAnchorPoint(0.5, 0.5)
	headSp:setPosition(cc.p(self.Panel_pic:getContentSize().width/2, self.Panel_pic:getContentSize().height/2))
	self.Panel_pic:addChild(headSp)

	self:showRedDot()

	local name_mould_id = dms.atof(self._data, biographies_section_mould.name)
	local word_info = dms.element(dms["word_mould"], name_mould_id)
    local name = word_info[3]
	self.Text_charactor:setString(name)

	-- 激活数量
	local acitvateCount, maxCount = RoleBiographyHandle.getBiographyActivateCountByChapterId(self._chapterId)
	self.Text_quantity_1:setString(acitvateCount .. "/" .. maxCount)
end

function RoleBiographyChapterCell:showRedDot()
	if self.Panel_pic._istips == true then
		self.Panel_pic:removeChild(self.Panel_pic._nodeChild, true)
		self.Panel_pic._nodeChild = nil
		self.Panel_pic._istips = false
	end

	if RoleBiographyHandle.showChapterDotByChapterId(self._chapterId) == true then
		if self.Panel_pic._istips == nil or self.Panel_pic._istips == false then
			local ball = cc.Sprite:create("images/ui/bar/tips.png")
			ball:setAnchorPoint(cc.p(0.5, 0.5))
			ball:setPosition(cc.p(self.Panel_pic:getContentSize().width-ball:getContentSize().width*0.5, self.Panel_pic:getContentSize().height-ball:getContentSize().height*0.5))
			self.Panel_pic:addChild(ball)
			self.Panel_pic._nodeChild = ball
			self.Panel_pic._istips = true
		end
	end
end

function RoleBiographyChapterCell:onEnterTransitionFinish()
	
end

function RoleBiographyChapterCell:onInit(params)
	-- 加载NinjaBiographiesCellWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_cell = res/cultivate/ninja_biographies/ninja_biographies_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyChapterCell.__size == nil then
		RoleBiographyChapterCell.__size = root:getContentSize()
	end

	-- 
	self.Panel_pic = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_pic"), nil,
	{
		terminal_name = "role_biography_chapter_cell_open_biography_window",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_chapterId = self._chapterId,
		_unlock = self._unlock
	}, nil, 0)	

	self:onUpdateDraw()
end

function RoleBiographyChapterCell:onExit()
	-- 释放RoleBiographyChapterCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_cell.csb", root)
	-- ]]
end

function RoleBiographyChapterCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyChapterCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
