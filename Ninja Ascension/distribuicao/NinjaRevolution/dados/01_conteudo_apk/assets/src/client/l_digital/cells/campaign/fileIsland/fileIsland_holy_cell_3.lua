----------------------------------------------------------------------------------------------------
-- 说明：文件岛圣物左侧列表cell中的icon cell
----------------------------------------------------------------------------------------------------
FileIslandHolyCell_3 = class("FileIslandHolyCell_3_Class", Window)
FileIslandHolyCell_3.__size = nil

function FileIslandHolyCell_3:ctor()
    self.super:ctor()
	self.roots = {}

	local function init_fileIsland_holy_cell_icon_terminal()
		-- 点击icon
		local fileIsland_holy_cell_icon_click_terminal = {
            _name = "fileIsland_holy_cell_icon_click",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local idx = params._datas.idx
            	local cell = params._datas.cell
            	cell.Image_holy_right_icon_hook:setVisible(true)

            	state_machine.excute("FileIslandHolyCellInfo_open", 0, {cell = cell}) 
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

        -- 隐藏选中动画
        local fileIsland_holy_cell_icon_hide_select_anim_terminal = {
            _name = "fileIsland_holy_cell_icon_hide_select_anim",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	local cell = params.cell
            	cell.Image_holy_right_icon_hook:setVisible(false)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }

		state_machine.add(fileIsland_holy_cell_icon_click_terminal)
		state_machine.add(fileIsland_holy_cell_icon_hide_select_anim_terminal)
        state_machine.init()
	end

	init_fileIsland_holy_cell_icon_terminal()
end

function FileIslandHolyCell_3:onUpdateDraw()
	local root = self.roots[1]

	-- 隐藏所有箭头先
	self.Sprite_holy_right_icon_arrow_1:setVisible(false)
	self.Sprite_holy_right_icon_arrow_3:setVisible(false)
	self.Sprite_holy_right_icon_arrow_2:setVisible(false)
	self.Sprite_holy_right_icon_arrow_1_1:setVisible(false)
	self.Sprite_holy_right_icon_arrow_3_1:setVisible(false)

	-- 如果是单数行，箭头向右
	if self.holycell2.index % 2 ~= 0 then
		if self.taskData.idx ~= self.taskData.maxNum then
			self.Sprite_holy_right_icon_arrow_2:setVisible(true)
		end
	-- 如果是偶数行，箭头向左
	else
		if self.taskData.idx ~= self.taskData.maxNum then
			self.Sprite_holy_right_icon_arrow_3_1:setVisible(true)
		end
	end

	-- 第4个显示朝下的箭头
	if self.index == 4 then
		self.Sprite_holy_right_icon_arrow_1:setVisible(true)
	end

	if self.taskData.idx == self.taskData.maxNum then
		self.Sprite_holy_right_icon_arrow_1:setVisible(false)
	end

	self.Text_holy_right_icon_n:setString(self.taskData.idx)
	self.Text_holy_right_icon_n:setVisible(true)
end

function FileIslandHolyCell_3:onInit()
    local root = cacher.createUIRef("campaign/explore/explore_holy_right_icon_cell.csb", "root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)

	-- 选中动画
	self.Image_holy_right_icon_hook = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_hook")
	-- 背景1
	self.Image_holy_right_icon_bg_1 = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_bg_1")
	-- 背景2
	self.Image_holy_right_icon_bg_2 = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_bg_2")
	-- 图标
	self.Panel_holy_right_icon = ccui.Helper:seekWidgetByName(root, "Panel_holy_right_icon")
	fwin:addTouchEventListener(self.Panel_holy_right_icon, nil, 
    {
        terminal_name = "fileIsland_holy_cell_icon_click", 
        terminal_state = 0,
        isPressedActionEnabled = true,
        idx = self.taskData.idx,
        cell = self
    }, 
    nil, 0)

	-- 等级数
	self.Text_holy_right_icon_n = ccui.Helper:seekWidgetByName(root, "Text_holy_right_icon_n")
	-- 解锁条件
	self.Text_holy_right_icon_lock_n = ccui.Helper:seekWidgetByName(root, "Text_holy_right_icon_lock_n")
	-- 锁图标
	self.Image_holy_right_icon_lock = ccui.Helper:seekWidgetByName(root, "Image_holy_right_icon_lock")
	-- 下边箭头，朝下
	self.Sprite_holy_right_icon_arrow_1 = root:getChildByName("Sprite_holy_right_icon_arrow_1")
	-- 左边箭头，朝右
	self.Sprite_holy_right_icon_arrow_3 = root:getChildByName("Sprite_holy_right_icon_arrow_3")
	-- 右边箭头，朝右
	self.Sprite_holy_right_icon_arrow_2 = root:getChildByName("Sprite_holy_right_icon_arrow_2")
	-- 右边箭头，朝左
	self.Sprite_holy_right_icon_arrow_1_1 = root:getChildByName("Sprite_holy_right_icon_arrow_1_1")
	-- 左边箭头，朝左
	self.Sprite_holy_right_icon_arrow_3_1 = root:getChildByName("Sprite_holy_right_icon_arrow_3_1")
	
	local panel_size = root:getContentSize()
	self:onUpdateDraw()

	self:setContentSize(panel_size)
	if FileIslandHolyCell_3.__size == nil then
		FileIslandHolyCell_3.__size = panel_size
	end

end

function FileIslandHolyCell_3:reload()
    local root = self.roots[1]
    if root ~= nil then
        return
    end

    self:onInit()
end

function FileIslandHolyCell_3:unload()
    local root = self.roots[1]
    if root == nil then
        return
    end
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_holy_right_icon_cell.csb", root)
    root:stopAllActions()
    root:removeFromParent(false)
    self.roots = {}
end

function FileIslandHolyCell_3:clearUIInfo()
    local root = self.roots[1]
    if self.Image_holy_right_icon_hook then
    	self.Image_holy_right_icon_hook:setVisible(false)
    end
    
end

function FileIslandHolyCell_3:onExit()
	self:clearUIInfo()

    cacher.freeRef("campaign/explore/explore_holy_right_icon_cell.csb", self.roots[1])
end

function FileIslandHolyCell_3:initData()

end

function FileIslandHolyCell_3:init(params, index, holycell2)
	self.taskData = params or {}
	self:initData()

	-- FileIslandHolyCell_2
	self.holycell2 = holycell2
	self.index = index

	self:onInit()

	if FileIslandHolyCell_3.__size then
		self:setContentSize(FileIslandHolyCell_3.__size)
	end
end

function FileIslandHolyCell_3:createCell()
	local cell = FileIslandHolyCell_3:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


