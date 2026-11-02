----------------------------------------------------------------------------------------------------
-- 说明：文件岛圣物右侧列表cell
----------------------------------------------------------------------------------------------------
FileIslandHolyCell_2 = class("FileIslandHolyCell_2_Class", Window)
FileIslandHolyCell_2.__size = nil

function FileIslandHolyCell_2:ctor()
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

function FileIslandHolyCell_2:onUpdateDraw()
	local root = self.roots[1]

	for i = 1, #self.taskData do
		local node

		-- 单数行，从左向右排
		if self.index % 2 ~= 0 then
			node = self.iconTable[i]
		-- 偶数行，从右向左排
		else
			node = self.iconTable[5 - i]
		end

		node:removeAllChildren(true)

		local cellData = self.taskData[i]
		local cell = FileIslandHolyCell_3:createCell()
		cell:init(cellData, i, self)
		node:addChild(cell)

	end

end

function FileIslandHolyCell_2:onInit()
    local root = cacher.createUIRef("campaign/explore/explore_holy_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	self.iconTable = {}
	for i = 1, 4 do
		table.insert(self.iconTable, ccui.Helper:seekWidgetByName(root, "Panel_explore_holy_icon_" .. i))
	end

	local panel_size = root:getContentSize()

	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if FileIslandHolyCell_2.__size == nil then
		FileIslandHolyCell_2.__size = panel_size
	end

end

function FileIslandHolyCell_2:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function FileIslandHolyCell_2:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_holy_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function FileIslandHolyCell_2:clearUIInfo()
    local root = self.roots[1]
    
    if self.iconTable then
    	for i = 1, #self.iconTable do
    		local node = self.iconTable[i]
    		if node then
    			node:removeAllChildren(true)
    		end
    	end
    end

end

function FileIslandHolyCell_2:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_holy_cell.csb", self.roots[1])
end

function FileIslandHolyCell_2:initData()

end

function FileIslandHolyCell_2:init(params, index, holy)
	self.taskData = params or {}
	self:initData()

	-- 列表所在的类
	self.fileIslandHolyThing = holy
	self.index = index

	if index and index < 5 then
		self:onInit()
	end

	if FileIslandHolyCell_2.__size then
		self:setContentSize(FileIslandHolyCell_2.__size)
	end
end

function FileIslandHolyCell_2:createCell()
	local cell = FileIslandHolyCell_2:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


