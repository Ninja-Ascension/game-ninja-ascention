-- 通用菜单列表cell
GeneraltMenuListCell = class("GeneraltMenuListCell", Window)
GeneraltMenuListCell.__size = nil

-- 创建Cell实例
local generalt_menu_list_cell_create_terminal = {
	_name = "generalt_menu_list_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if GeneraltMenuListCell then
			local cell = GeneraltMenuListCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			cell:registerOnNoteUpdate(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(generalt_menu_list_cell_create_terminal)
state_machine.init()

-- 构造器
function GeneraltMenuListCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var
    self._id = nil    -- 按钮ID
    self._str = ""          -- 按钮文本
    self._callback = nil    -- 点击回调函数
    self._show_tag = nil    -- 是否显示按钮标签 (nil 或者 -1 不显示)
	-- Initialize illustration cell page state machine.
	local function init_generalt_menu_list_cell_terminal()

		-- 点击
		local generalt_menu_list_cell_click_terminal = {
			_name = "generalt_menu_list_cell_click",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				if params then
                    local mCell = params._datas.m_cell
                    mCell._callback(mCell._id)
				end
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

        state_machine.add(generalt_menu_list_cell_click_terminal)
		state_machine.init()
	end
	-- call func init illustration cell state machine.
	init_generalt_menu_list_cell_terminal()
end

-- 对象初始化 {按钮ID,按钮文字,回调函数,标签显示}
function GeneraltMenuListCell:init(params)
    self._id = params[1]
    self._str = params[2]   
    self._callback = params[3]
    self._show_tag = params[4] == nil and -1 or params[4]
	self:onInit(params)
	return self
end

function GeneraltMenuListCell:onUpdateDraw()
	local root = self.roots[1]
    self.Text_9_0 = ccui.Helper:seekWidgetByName(root, "Text_9_0")
	self.Text_9_0:setString(self._str)
	self.Text_9 = ccui.Helper:seekWidgetByName(root, "Text_9")
	self.Text_9:setString(self._str)
	local Image_1 = ccui.Helper:seekWidgetByName(root, "Image_1")
	if self._show_tag == -1 then 
		Image_1:setVisible(false)
	else
		Image_1:setVisible(true)
	end
end

function GeneraltMenuListCell:setTouchState(_state)
	local root = self.roots[1]
	local flag = not _state
    self.Button_6:setTouchEnabled(flag)
	self.Button_6:setHighlighted(_state)
	self.Text_9_0:setVisible(flag)
	self.Text_9:setVisible(_state)
end

function GeneraltMenuListCell:onEnterTransitionFinish()
	
end

function GeneraltMenuListCell:onInit(params)
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("utils/common_paging_2.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	self:clearUIInfo()
	if GeneraltMenuListCell.__size == nil then
		GeneraltMenuListCell.__size = root:getContentSize()
	end
	self:setContentSize(GeneraltMenuListCell.__size)

    
	self.Button_6 = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_6"), nil,
	{
		terminal_name = "generalt_menu_list_cell_click",
		terminal_state = 0,
		m_cell = self,
		isPressedActionEnabled = true,
	}, nil, 0)	
	self.Button_6:setSwallowTouches(false)
	self:onUpdateDraw()
end

function GeneraltMenuListCell:onExit()
	-- 释放IllustrationCellWindow界面资源.
	self:clearUIInfo()
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("utils/common_paging_2.csb", root)
	-- ]]
end

function GeneraltMenuListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function GeneraltMenuListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:clearUIInfo()
	self:stopAllActions()
	cacher.freeRef("utils/common_paging_2.csb", root)
	self:unregisterOnNoteUpdate(self)
	root:removeFromParent(false)
	self.roots = {}
end

function GeneraltMenuListCell:clearUIInfo()
	local root = self.roots[1]
	if root == nil then
        return
    end
	if root._x ~= nil then
        root:setPositionX(root._x)
    end
    if root._y ~= nil then
        root:setPositionY(root._y)
    end
end

-- ~END
-- ----------------------------------------------------------------------------
