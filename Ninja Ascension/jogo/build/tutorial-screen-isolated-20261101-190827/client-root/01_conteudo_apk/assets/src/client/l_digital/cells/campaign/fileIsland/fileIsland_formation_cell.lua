----------------------------------------------------------------------------------------------------
-- 说明：文件岛圣物左侧列表cell
----------------------------------------------------------------------------------------------------
FileIslandFormationCell = class("FileIslandFormationCellClass", Window)
FileIslandFormationCell.__size = nil

function FileIslandFormationCell:ctor()
    self.super:ctor()
	self.roots = {}
end

function FileIslandFormationCell:onUpdateDraw()
	local root = self.roots[1]
	self.Text_explore_friend_name:setString(self.taskData.nickName)
	self.Text_explore_friend_lv:setString(self.taskData.level)
	self.Text_explore_friend_fighting:setString(self.taskData.combat)
end

function FileIslandFormationCell:onInit()
    local root = cacher.createUIRef("campaign/explore/explore_boss_formation_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	-- 玩家名
	self.Text_explore_friend_name = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_name")
	-- 等级
	self.Text_explore_friend_lv = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_lv")
	-- 战力
	self.Text_explore_friend_fighting = ccui.Helper:seekWidgetByName(root, "Text_explore_friend_fighting")

	local panel_size = root:getContentSize()

	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if FileIslandFormationCell.__size == nil then
		FileIslandFormationCell.__size = panel_size
	end

end

function FileIslandFormationCell:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function FileIslandFormationCell:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_boss_formation_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function FileIslandFormationCell:clearUIInfo()
    local root = self.roots[1]
    if self.Text_explore_friend_name then
    	self.Text_explore_friend_name:setString("")
    end

    if self.Text_explore_friend_lv then
    	self.Text_explore_friend_lv:setString("")
    end
    
    if self.Text_explore_friend_fighting then
    	self.Text_explore_friend_fighting:setString("")
    end
    
end

function FileIslandFormationCell:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_boss_formation_cell.csb", self.roots[1])
end

function FileIslandFormationCell:initData()

end

function FileIslandFormationCell:init(params, index, holy)
	self.taskData = params or {}
	self:initData()

	-- 列表所在的类
	self.fileIslandHolyThing = holy
	self.index = index

	if index and index < 6 then
		self:onInit()
	end

	if FileIslandFormationCell.__size then
		self:setContentSize(FileIslandFormationCell.__size)
	end
end

function FileIslandFormationCell:createCell()
	local cell = FileIslandFormationCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


