-- ----------------------------------------------------------------------------------------------------
-- 说明：服务器列表控件左侧 -- 
-- 创建时间：2016 2 24
-- 作者：杨晗
-- 修改记录：新建
-------------------------------------------------------------------------------------------------------

ServerListLeftCell = class("ServerListLeftCellClass", Window)
ServerListLeftCell.__size = nil

--创建cell
local server_list_left_create_cell_terminal = {
    _name = "server_list_left_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
        local table_index = params[1]
        local name = params[2]
        local max_table_number = params[3]
        local cell = ServerListLeftCell:new()
        cell:init(table_index, name,max_table_number)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(server_list_left_create_cell_terminal)
state_machine.init()

function ServerListLeftCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.table_index = nil
	self.name = nil   
	self.max_table_number = nil 
    local function init_server_list_left_cell_terminal()	
        -- state_machine.init()
    end
    init_server_list_left_cell_terminal()
   -- call func init hom state machine.
end

function ServerListLeftCell:setSelected(params)
	local root = self.roots[1]
	local Image_server_interval_light = ccui.Helper:seekWidgetByName(root,"Image_server_interval_light")
	if Image_server_interval_light == nil then
		return
	end
	Image_server_interval_light:setVisible(params)
end


function ServerListLeftCell:onEnterTransitionFinish()
	if self.max_table_number == self.table_index then
		state_machine.excute("server_list_left_cell_change_server_list_page",0,{
			_datas = 
			{
				terminal_name = "server_list_left_cell_change_server_list_page", 
				cell = self,
				terminal_state = 0
			}
			})
	end
end

function ServerListLeftCell:onInit()
	local csbItem = csb.createNode(config_csb.cells.login.server_list_left_cell)
	local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)     	
	table.insert(self.roots, root)
 	if ServerListLeftCell.__size == nil then
	 	local Image_server_interval_bg = ccui.Helper:seekWidgetByName(root, "Image_server_interval_bg")
		local MySize = root:getContentSize()
	 	ServerListLeftCell.__size = MySize
	end
	local Text_server_interval = ccui.Helper:seekWidgetByName(root, "Text_server_interval")
	Text_server_interval:setString(self.name)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_server_interval_bg"),nil, 
	{
		terminal_name = "server_list_left_cell_change_server_list_page", 
		cell = self,
		terminal_state = 0
	}
	,nil, 0)

end

function ServerListLeftCell:init(table_index,name,max_table_number)
	self.table_index = table_index
	self.name = name
	self.max_table_number = max_table_number
	self:onInit()
	self:setContentSize(ServerListLeftCell.__size)
	return self
end

function ServerListLeftCell:onExit()

end

