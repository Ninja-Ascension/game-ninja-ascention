--[[ ----------------------------------------------------------------------------
-- 
--]] ----------------------------------------------------------------------------
RoleBiographyAccessCell = class("RoleBiographyAccessCellClass", Window)
RoleBiographyAccessCell.__size = nil

-- 创建Cell实例
local role_biography_access_cell_create_terminal = {
	_name = "role_biography_access_cell_create",
	_init = function (terminal)
		
	end,
	_inited = false,
	_instance = self,
	_state = 0,
	_invoke = function(terminal, instance, params)
		if RoleBiographyAccessCell then
			local cell = RoleBiographyAccessCell:new()
			cell:init(params)
			cell:registerOnNodeEvent(cell)
			return cell
		end
		return true
	end,
	_terminal = nil,
	_terminals = nil
}

state_machine.add(role_biography_access_cell_create_terminal)
state_machine.init()

-- 构造器
function RoleBiographyAccessCell:ctor()
	self.super:ctor()
	self.roots = {}
	self.actions = {}

	-- var

	-- load lua files.

	-- Initialize ninja biographies obtain list page state machine.
	local function init_role_biography_access_cell_terminal()
		local role_biography_access_cell_go_terminal = {
			_name = "role_biography_access_cell_go",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				state_machine.excute("role_biography_divine_window_open", 0, nil)
				state_machine.excute("role_biography_description_window_close", 0, nil)
				state_machine.excute("role_biography_access_window_close", 0, nil)
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}

		state_machine.add(role_biography_access_cell_go_terminal)
	end
	-- call func init ninja biographies obtain list state machine.
	init_role_biography_access_cell_terminal()
end

-- 对象初始化
function RoleBiographyAccessCell:init(params)
	self._showType = params

	self:onInit(params)
	self:setContentSize(RoleBiographyAccessCell.__size)
	return self
end

function RoleBiographyAccessCell:onUpdateDraw()
	local root = self.roots[1]

	self.Text_1_0 = ccui.Helper:seekWidgetByName(root, "Text_1_0")
	self.Image_chouka = ccui.Helper:seekWidgetByName(root, "Image_chouka")
	self.Image_activity = ccui.Helper:seekWidgetByName(root, "Image_activity")

	if self._showType == 1 then
		self.Text_1_0:setString(tipStringInfo_role_biography[3])
		self.Button_qw:setVisible(true)
		self.Image_chouka:setVisible(true)
		self.Image_activity:setVisible(false)
	else
		self.Text_1_0:setString(tipStringInfo_role_biography[4])
		self.Button_qw:setVisible(false)
		self.Image_chouka:setVisible(false)
		self.Image_activity:setVisible(true)
	end
end

function RoleBiographyAccessCell:onEnterTransitionFinish()
	
end

function RoleBiographyAccessCell:onInit(params)
	-- 加载RoleBiographyAccessCellWindow界面资源.
	-- res.cultivate.ninja_biographies.ninja_biographies_obtain_list = res/cultivate/ninja_biographies/ninja_biographies_obtain_list.csb
	--[[ 不使用缓存创建
	local csbNode = csb.createNode("cultivate/ninja_biographies/ninja_biographies_obtain_list.csb")
	local root = csbNode:getChildByName("root")
	--]]
	-- [[ 使用缓存创建
	local root = cacher.createUIRef("cultivate/ninja_biographies/ninja_biographies_obtain_list.csb", "root")
	-- ]]
	root:removeFromParent(false)
	table.insert(self.roots, root)
	self:addChild(root)
	if RoleBiographyAccessCell.__size == nil then
		RoleBiographyAccessCell.__size = root:getContentSize()
	end

	self.Button_qw = fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qw"), nil,
	{
		terminal_name = "role_biography_access_cell_go",
		terminal_state = 0,
		isPressedActionEnabled = true,
	}, nil, 0)	

	self:onUpdateDraw()
end

function RoleBiographyAccessCell:onExit()
	-- 释放RoleBiographyAccessCellWindow界面资源.
	
	-- [[ 释放缓存
	local root = self.roots[1]
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_obtain_list.csb", root)
	-- ]]
end

function RoleBiographyAccessCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function RoleBiographyAccessCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	self:stopAllActions()
	root:removeFromParent(false)
	cacher.freeRef("cultivate/ninja_biographies/ninja_biographies_obtain_list.csb", root)
	
	self.roots = {}
end

-- ~END
-- ----------------------------------------------------------------------------
