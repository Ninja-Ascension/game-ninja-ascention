--[[ ----------------------------------------------------------------------------
-- @class
--]] ----------------------------------------------------------------------------
RoleBiographyRankCell = class("RoleBiographyRankCellClass", Window)
RoleBiographyRankCell.__size = nil

-- 创建Cell实例
local role_biography_rank_cell_create_terminal = {
	_name = "role_biography_rank_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyRankCell then
			local cell = RoleBiographyRankCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_rank_cell_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyRankCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies report list page state machine.
	local function init_role_biography_rank_cell_terminal()
		
	end
	-- call func init ninja biographies report list state machine.
	init_role_biography_rank_cell_terminal()
end

-- 对象初始化
function RoleBiographyRankCell:init(params)
	self._index = params.index
	self._data = params.data

	-- if self._index < 9 then
		self:onInit(params)
	-- end
	self:setContentSize(RoleBiographyRankCell.__size)
	return self
end

function RoleBiographyRankCell:onUpdateDraw()
	local root = self.roots[1]

	for i = 1, 3 do
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..i)
		Image_no:setVisible(false)
	end

	local Image_ranking = ccui.Helper:seekWidgetByName(root, "Image_ranking")
	Image_ranking:setVisible(false)


	local rank = tonumber(self._data.rankNumber)
	if rank <= 3 then
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..rank)
		Image_no:setVisible(true)
	else
		Image_ranking:setVisible(true)
		local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
		Text_ranking:setString(rank)
	end

	local rankInfo = self._data.rankInfo
	---
	local Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	Text_name_lv:setString(rankInfo.nickName)

	local headPic = tonumber(rankInfo.headPic)

	local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	Panel_player_icon:removeAllChildren(true)
	Panel_player_icon:removeBackGroundImage()
	local big_icon_path = nil
	if tonumber(headPic) < 9 then
        big_icon_path = string.format("images/ui/home/head_%d.png", tonumber(headPic))
    else
        big_icon_path = string.format("images/ui/props/props_%d.png", tonumber(headPic))
	end
	Panel_player_icon:setBackGroundImage(big_icon_path)

	local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	Text_1_0:setString(rankInfo.activateNumber)

	--成就值
	local Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	Text_2_0:setString(rankInfo.score)

	local Text_server = ccui.Helper:seekWidgetByName(root, "Text_server*11_0")
	local num = GetServerNameByServerNumber(rankInfo.serverNumber)
	Text_server:setString(num)

	local Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")
	Text_level:setString(rankInfo.userLevel)
end

function RoleBiographyRankCell:onEnterTransitionFinish()
	
end

function RoleBiographyRankCell:onInit(params)
	-- 加载RoleBiographyRankCellWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_report_list = res/cultivate/ninja_biographies/ninja_biographies_report_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_report_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_report_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyRankCell.__size == nil then
		RoleBiographyRankCell.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function RoleBiographyRankCell:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	for i = 1, 3 do
		local Image_no = ccui.Helper:seekWidgetByName(root, "Image_no_"..i)
		Image_no:setVisible(false)
	end

	local Image_ranking = ccui.Helper:seekWidgetByName(root, "Image_ranking")
	Image_ranking:setVisible(false)

	local Text_ranking = ccui.Helper:seekWidgetByName(root, "Text_ranking")
	Text_ranking:setString("")


	local Text_name_lv = ccui.Helper:seekWidgetByName(root, "Text_name_lv")
	Text_name_lv:setString("")

	local Panel_player_icon = ccui.Helper:seekWidgetByName(root, "Panel_player_icon")
	Panel_player_icon:removeAllChildren(true)
	Panel_player_icon:removeBackGroundImage()

	local Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	Text_1_0:setString("")

	--成就值
	local Text_2_0 = ccui.Helper:seekWidgetByName(root, "Text_2_0")
	Text_2_0:setString("")

	local Text_server = ccui.Helper:seekWidgetByName(root, "Text_server*11_0")
	Text_server:setString("")

	local Text_level = ccui.Helper:seekWidgetByName(root, "Text_level")
	Text_level:setString("")
end

function RoleBiographyRankCell:onExit()
	-- 释放RoleBiographyRankCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_report_list.csb", root)
	-- ]]
end

function RoleBiographyRankCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyRankCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_report_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
