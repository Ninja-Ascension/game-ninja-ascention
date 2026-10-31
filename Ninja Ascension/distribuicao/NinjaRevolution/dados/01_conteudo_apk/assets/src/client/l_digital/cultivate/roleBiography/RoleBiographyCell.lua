--[[ ----------------------------------------------------------------------------
-- 印记详情
--]] ----------------------------------------------------------------------------
RoleBiographyCell = class("RoleBiographyCellClass", Window)
RoleBiographyCell.__size = nil

-- 创建Cell实例
local role_biography_cell_create_terminal = {
	_name = "role_biography_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyCell then
			local cell = RoleBiographyCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_cell_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies0 cell page state machine.
	local function init_role_biography_cell_terminal()
		local role_biography_cell_show_select_biography_terminal = {
			_name = "role_biography_cell_show_select_biography",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local biographyId = params._datas._biographyId
				local index = params._datas._index

				state_machine.excute("role_biography_update_select", 0, index)
				state_machine.excute("role_biography_select_biography", 0, biographyId)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_cell_show_select_biography_terminal)
	end
	-- call func init ninja biographies0 cell state machine.
	init_role_biography_cell_terminal()
end

-- 对象初始化
function RoleBiographyCell:init(params)
	self._index = params.index
	self._data = params.data

	self._biographyId = dms.atof(self._data, biographies_mould.id)

	if self._index < 9 then
		self:onInit(params)
	end
	
	self:setContentSize(RoleBiographyCell.__size)
	return self
end

function RoleBiographyCell:updateUI()
	local data = self._data

	local pic = dms.atof(data, biographies_mould.pic)
	self.Panel_player_icon_1:removeAllChildren(true)
	local headSp = cc.Sprite:create(string.format("images/ui/props/props_%d.png", pic))
	headSp:setAnchorPoint(0.5, 0.5)
	headSp:setPosition(cc.p(self.Panel_player_icon_1:getContentSize().width/2, self.Panel_player_icon_1:getContentSize().height/2))
	self.Panel_player_icon_1:addChild(headSp)

	local name_mould_id = dms.atof(data, biographies_mould.name)
    local word_info = dms.element(dms["word_mould"], name_mould_id)
    local name = word_info[3]
	self.Text_character:setString(name)

	local biographyQuality = dms.atof(data, biographies_mould.quality) + 3
	self.Text_character:setColor(cc.c3b(_quality_color[biographyQuality][1], _quality_color[biographyQuality][2], _quality_color[biographyQuality][3]))

	local isActivate = RoleBiographyHandle.getBiographyIsActivate(self._biographyId)
	self.Image_1:setVisible(isActivate)

	local canUpLevel, canComposeLevelUp = RoleBiographyHandle.getBiographyCanLevelUp(self._biographyId)
	self.Image_2:setVisible(canUpLevel or canComposeLevelUp)

	self.Panel_effect:removeAllChildren(true)

	-- 组成红点
	local signetCostStr = dms.atos(data, biographies_mould.signet_cost)
	local signetCost = zstring.splits(signetCostStr, "|", ",")

	for i, v in ipairs(self.Panel_Point) do
		v:removeAllChildren(true)

		local prop = signetCost[i]
		if prop then
			local propId = tonumber(prop[2])
			local count = tonumber(prop[3])

			local point = nil

			local haveCount = tonumber(getPropAllCountByMouldId(propId))
			if isActivate or haveCount >= count then
				local quality = dms.int(dms["prop_mould"], propId, prop_mould.prop_quality)
				point = cc.Sprite:create(string.format("images/ui/text/TF_res/ninja_biographies/imprint/ninja_biographies_dian_%d.png", quality + 1))
			else
				point = cc.Sprite:create(string.format("images/ui/text/TF_res/ninja_biographies/imprint/ninja_biographies_dian_%d.png", 0))
			end

			point:setAnchorPoint(0.5, 0.5)
			point:setPosition(cc.p(v:getContentSize().width/2, v:getContentSize().height/2))
			v:addChild(point)

			v:setVisible(true)
		else
			v:setVisible(false)
		end
	end

	local startLevel = RoleBiographyHandle.getAllBiographyInfo()[self._biographyId]
	
	local chapterId = dms.int(dms["biographies_mould"], self._biographyId, biographies_mould.chapterId)
	local _, canAdvance = RoleBiographyHandle.getChapterLockState(chapterId)

	if startLevel and canAdvance then
		for i, v in ipairs(self.Image_stars) do
			v:setVisible(startLevel >= i)
		end
		self.Panel_star:setVisible(true)
	else
		self.Panel_star:setVisible(false)
	end

	local canActivate, canComposeActivate = RoleBiographyHandle.getBiographyCanActivte(self._biographyId)
	local isShow = canActivate or canComposeActivate
	self:startActivateAnimation(isShow)

	self:showRedDot()
end

function RoleBiographyCell:showRedDot()
	if self.Image_4._istips == true then
		self.Image_4:removeChild(self.Image_4._nodeChild, true)
		self.Image_4._nodeChild = nil
		self.Image_4._istips = false
	end

	if RoleBiographyHandle.showDotByBiographyId(self._biographyId) == true then
		if self.Image_4._istips == nil or self.Image_4._istips == false then
			local ball = cc.Sprite:create("images/ui/bar/tips.png")
			ball:setAnchorPoint(cc.p(0.5, 0.5))
			ball:setPosition(cc.p(self.Image_4:getContentSize().width-ball:getContentSize().width*0.5, self.Image_4:getContentSize().height-ball:getContentSize().height*0.5))
			ball:setScale(0.7)
			self.Image_4:addChild(ball)
			self.Image_4._nodeChild = ball
			self.Image_4._istips = true
		end
	end
end

-- 激活按钮光效
function RoleBiographyCell:startActivateAnimation(isShow)
	local Panel_effect = self.Panel_effect
	Panel_effect:setVisible(isShow)

	Panel_effect:removeAllChildren(true)

	if isShow then
		local animationName = "animation2"

		local jsonFile = "images/ui/effice/effect_ninja_biographies/effect_ninja_biographies.json"
		local atlasFile = "images/ui/effice/effect_ninja_biographies/effect_ninja_biographies.atlas"

		local animation = sp.spine(jsonFile, atlasFile, 1, 0, animationName, isLoop, nil)
		sp.initArmature(animation, true)
		animation:setAnimation(0, animationName, true)
		animation:setPosition(cc.p(Panel_effect:getContentSize().width/2, Panel_effect:getContentSize().height/2))
		Panel_effect:addChild(animation)
	end
end

function RoleBiographyCell:onUpdateDraw()
	local root = self.roots[1]

	self.Image_4 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_4"), nil,
	{
		terminal_name = "role_biography_cell_show_select_biography",
		terminal_state = 0,
		isPressedActionEnabled = true,
		_biographyId = self._biographyId,
		_index = self._index
	}, nil, 0)	

	-- 印记容器
	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")

	-- 列传名称
	self.Text_character = ccui.Helper:seekWidgetByName(root, "Text_character")

	-- 进度容器
	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")

	-- 已激活图标（默认隐藏）
	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")

	-- 可升星图标（默认隐藏）
	self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")

	-- 可激活光效动画
	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")

	self.Panel_Point = {}
	for i = 1, 7 do
		local Panel = ccui.Helper:seekWidgetByName(root, "Panel_"..i)
		table.insert(self.Panel_Point, Panel)
	end

	--
	self.Image_stars = {}
	for i = 1, 7 do
		local Image_star = ccui.Helper:seekWidgetByName(root, "Image_star_"..i)
		table.insert(self.Image_stars, Image_star)
	end

	self.Panel_star = ccui.Helper:seekWidgetByName(root, "Panel_star")

	self.Image_4_0 = ccui.Helper:seekWidgetByName(root, "Image_4_0")

	self:updateUI()
end

function RoleBiographyCell:onEnterTransitionFinish()
	
end

function RoleBiographyCell:onInit(params)
	-- 加载RoleBiographyCellWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_0_cell = res/cultivate/ninja_biographies/ninja_biographies_0_cell.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_0_cell.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_0_cell.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyCell.__size == nil then
		RoleBiographyCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function RoleBiographyCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Panel_player_icon_1 = ccui.Helper:seekWidgetByName(root, "Panel_player_icon_1")
	self.Panel_player_icon_1:removeAllChildren(true)

	self.Text_character = ccui.Helper:seekWidgetByName(root, "Text_character")
	self.Text_character:setString("")

	self.Panel_1 = ccui.Helper:seekWidgetByName(root, "Panel_1")
	self.Panel_1:removeAllChildren(true)

	self.Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	self.Image_1:setVisible(false)

	self.Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	self.Image_2:setVisible(false)

	self.Panel_effect = ccui.Helper:seekWidgetByName(root, "Panel_effect")
	self.Panel_effect:removeAllChildren(true)

	for i = 1, 7 do
		local Panel = ccui.Helper:seekWidgetByName(root, "Panel_"..i)
		Panel:removeAllChildren(true)
	end

	self.Image_4 = ccui.Helper:seekWidgetByName(root, "Image_4")
	self.Image_4:removeAllChildren(true)
end

function RoleBiographyCell:onExit()
	-- 释放RoleBiographyCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_0_cell.csb", root)
	-- ]]
end

function RoleBiographyCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_0_cell.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
