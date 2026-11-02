--[[ ----------------------------------------------------------------------------
-- 卡册成就列表控件
--]] ----------------------------------------------------------------------------
IllustrationAchievementList = class("IllustrationAchievementListClass", Window)
IllustrationAchievementList.__size = nil

-- 创建Cell实例
local illustration_achievement_list_create_terminal = {
	_name = "illustration_achievement_list_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if IllustrationAchievementList then
			local cell = IllustrationAchievementList:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(illustration_achievement_list_create_terminal)
state_machine.init()

-- 构造器
function IllustrationAchievementList:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize illustration achievement list page state machine.
	local function init_illustration_achievement_list_terminal()
		
	end
	-- call func init illustration achievement list state machine.
	init_illustration_achievement_list_terminal()
end

-- 对象初始化
function IllustrationAchievementList:init(params)
	self.info = params

	if self.info.index < 9 then
		self:onInit(params)
	end
	self:setContentSize(IllustrationAchievementList.__size)
	return self
end

function IllustrationAchievementList:onUpdateDraw()
	local root = self.roots[1]

	local achieveData = self.info.data
	-- 卡册评分达到%s激活:
	self.Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
	self.Text_title_1:setString(string.format(tipStringInfo_illustration_tip[8], tostring(achieveData.markData)))

	local addDatas = zstring.split(achieveData.addData,"|")
	for i=1, 2 do
		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
		Text_attributes_n:setVisible(false)
		Text_attributes_t:setVisible(false)

		if addDatas[i] then
			local datas = zstring.split(addDatas[i],",")
			local addType = tonumber(datas[1])
			local addVal = tonumber(datas[2])
			
			Text_attributes_n:setVisible(true)
			Text_attributes_t:setVisible(true)
			local propertyName, propertyValue = getPropertyNameAndValue(addType, addVal)
			Text_attributes_n:setString(propertyName)
			Text_attributes_t:setString(propertyValue)
		end
		
	end

	if self.info.haveAim then
		self:setRed()
	end
end

-- 达成显示
function IllustrationAchievementList:setRed()
	local root = self.roots[1]
	local color = IllustrationHandle.getStringColor(tipStringInfo_illustration_tip[7])
	self.Text_title_1:setColor(color)
	for i=1,2 do
		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
		Text_attributes_n:setColor(color)
		Text_attributes_t:setColor(color)
	end
end

function IllustrationAchievementList:clearUIInfo( ... )
	local root = self.roots[1]
	if root == nil then
		return
	end

	self.Text_title_1 = ccui.Helper:seekWidgetByName(root, "Text_title_1")
	self.Text_title_1:setString("")
	self.Text_title_1:setColor(cc.c3b(255, 255, 255))

	for i = 1, 2 do
		local Text_attributes_n = ccui.Helper:seekWidgetByName(root, "Text_attributes_n_"..i)
		local Text_attributes_t = ccui.Helper:seekWidgetByName(root, "Text_attributes_t_"..i)
		Text_attributes_n:setString("")
		Text_attributes_t:setString("")
		Text_attributes_n:setColor(cc.c3b(255, 255, 255))
		Text_attributes_t:setColor(cc.c3b(255, 255, 255))
	end
end

function IllustrationAchievementList:onEnterTransitionFinish()
	
end

function IllustrationAchievementList:onInit(params)
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/illustration/illustration_achievement_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if IllustrationAchievementList.__size == nil then
		IllustrationAchievementList.__size = root:getContentSize()
	end
	self:clearUIInfo()
	self:onUpdateDraw()
end

function IllustrationAchievementList:onExit()
	-- 释放IllustrationAchievementListWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/illustration/illustration_achievement_list.csb", root)
	-- ]]
end

function IllustrationAchievementList:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function IllustrationAchievementList:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/illustration/illustration_achievement_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
