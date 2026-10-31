----------------------------------------------------------------------------------------------------
-- 说明：文件岛圣物左侧列表cell
----------------------------------------------------------------------------------------------------
FileIslandHolyCell_1 = class("FileIslandHolyCell_1_Class", Window)
FileIslandHolyCell_1.__size = nil

function FileIslandHolyCell_1:ctor()
    self.super:ctor()
	self.roots = {}

	local function init_fileIsland_boss_cell_terminal()
		-- -- 点击cell
		-- local fileIsland_friend_cell_Button_explor_find_terminal = {
  --           _name = "fileIsland_friend_cell_Button_explor_find",
  --           _init = function (terminal) 
  --           end,
  --           _inited = false,
  --           _instance = self,
  --           _state = 0,
  --           _invoke = function(terminal, instance, params)
  --           	local cell = params._datas._cell

  --               return true
  --           end,
  --           _terminal = nil,
  --           _terminals = nil
  --       }

		-- state_machine.add(fileIsland_friend_cell_Button_explor_find_terminal)
  --       state_machine.init()
	end

	init_fileIsland_boss_cell_terminal()
end

function FileIslandHolyCell_1:onUpdateDraw()
	local root = self.roots[1]
	self.Text_holy_list_t:setString(self.taskData.nick)
end

function FileIslandHolyCell_1:onInit()
    local root = cacher.createUIRef("campaign/explore/explore_holy_left_list_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	-- 默认状态
	self.Image_holy_list_mr = ccui.Helper:seekWidgetByName(root, "Image_holy_list_mr")
	-- 选择状态
	self.Image_holy_list_xz = ccui.Helper:seekWidgetByName(root, "Image_holy_list_xz")

	self.Image_holy_list_mr:setVisible(true)
	self.Image_holy_list_xz:setVisible(false)

	local callback = function (sender, evenType)
        if evenType == ccui.TouchEventType.began then
        elseif evenType == ccui.TouchEventType.moved then
        elseif evenType == ccui.TouchEventType.ended then
        	self.Image_holy_list_mr:setVisible(false)
			self.Image_holy_list_xz:setVisible(true)

        	if self.fileIslandHolyThing.selectIndex == self.index then
        		return
        	end

        	state_machine.excute("fileIsland_holy_thing_refreshRightListView", 0, "") 

        	self.fileIslandHolyThing.listView:getItem(self.fileIslandHolyThing.selectIndex - 1).Image_holy_list_mr:setVisible(true)
        	self.fileIslandHolyThing.listView:getItem(self.fileIslandHolyThing.selectIndex - 1).Image_holy_list_xz:setVisible(false)

        	self.fileIslandHolyThing.selectIndex = self.index
        end
    end
    self.Image_holy_list_mr:addTouchEventListener(callback)
    self.Image_holy_list_xz:addTouchEventListener(callback)

	if self.fileIslandHolyThing.selectIndex == self.index then
		self.Image_holy_list_mr:setVisible(false)
		self.Image_holy_list_xz:setVisible(true)
	else
		self.Image_holy_list_mr:setVisible(true)
		self.Image_holy_list_xz:setVisible(false)
	end

	-- 圣物名
	self.Text_holy_list_t = ccui.Helper:seekWidgetByName(root, "Text_holy_list_t")
	-- 等级/未解锁
	self.Text_holy_list_lv_t = ccui.Helper:seekWidgetByName(root, "Text_holy_list_lv_t")
	-- 等级数
	self.Text_holy_list_lv_n = ccui.Helper:seekWidgetByName(root, "Text_holy_list_lv_n")

	local panel_size = root:getContentSize()
	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if FileIslandHolyCell_1.__size == nil then
		FileIslandHolyCell_1.__size = panel_size
	end

end

function FileIslandHolyCell_1:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function FileIslandHolyCell_1:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_holy_left_list_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function FileIslandHolyCell_1:clearUIInfo()
    local root = self.roots[1]
    if self.Text_holy_list_t then
    	self.Text_holy_list_t:setString("")
    end

    if self.Text_holy_list_lv_t then
    	self.Text_holy_list_lv_t:setString("")
    end
    
    if self.Text_holy_list_lv_n then
    	self.Text_holy_list_lv_n:setString("")
    end
	
	if self.Image_holy_list_mr then
		self.Image_holy_list_mr:setVisible(true)
	end

	if self.Image_holy_list_xz then
		self.Image_holy_list_xz:setVisible(false)
	end

end

function FileIslandHolyCell_1:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_holy_left_list_cell.csb", self.roots[1])
end

function FileIslandHolyCell_1:initData()

end

function FileIslandHolyCell_1:init(params, index, holy)
	self.taskData = params or {}
	self:initData()

	-- 列表所在的类
	self.fileIslandHolyThing = holy
	self.index = index

	if index and index < 6 then
		self:onInit()
	end

	if FileIslandHolyCell_1.__size then
		self:setContentSize(FileIslandHolyCell_1.__size)
	end
end

function FileIslandHolyCell_1:createCell()
	local cell = FileIslandHolyCell_1:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


