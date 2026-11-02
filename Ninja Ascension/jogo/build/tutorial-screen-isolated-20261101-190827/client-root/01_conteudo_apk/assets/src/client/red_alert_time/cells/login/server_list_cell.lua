-- ----------------------------------------------------------------------------------------------------
-- 说明：服务器列表控件 -- 
-- 创建时间：2016 2 24
-- 作者：杨晗
-- 修改记录：新建
-------------------------------------------------------------------------------------------------------

ServerListCell = class("ServerListCellClass", Window)
ServerListCell.__size = nil

--创建cell
local server_list_create_cell_terminal = {
    _name = "server_list_create_cell",
    _init = function (terminal)
    end,
    _inited = false,
    _instance = self,
    _state = 0,
    _invoke = function(terminal, instance, params)
    	local server_data = params
        local cell = ServerListCell:new()
        cell:init(server_data)
        cell:registerOnNodeEvent(cell)
        return cell
    end,
    _terminal = nil,
    _terminals = nil
}

state_machine.add(server_list_create_cell_terminal)
state_machine.init()

function ServerListCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.server_data = nil
    self.server_number = nil
    self.index = nil
    local function init_lserver_manager_cell_terminal()	
        state_machine.init()
    end
    
   -- call func init hom state machine.
end



function ServerListCell:onEnterTransitionFinish()

end

function ServerListCell:onInit()
	local csbItem = csb.createNode(config_csb.cells.login.server_list_cell)
	local root = csbItem:getChildByName("root")
    root:removeFromParent(false)
    self:addChild(root)    
	
	table.insert(self.roots, root)
 	if ServerListCell.__size == nil then
		local MySize = root:getContentSize()
	 	ServerListCell.__size = MySize
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_server_list"),nil, 
	{ 
		terminal_name = "server_managers_select_server", 
		cell = self,
		terminal_state = 0
	}
	,nil, 0)
	self:onUpdateDraw()
end

--添加ICON 点击事件
function ServerListCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_server_list_name = ccui.Helper:seekWidgetByName(root,"Text_server_list_name")
	Text_server_list_name:setString(self.server_data.server_name)

	local Text_server_list_number = ccui.Helper:seekWidgetByName(root,"Text_server_list_number")
	if nil ~= self.server_data.server_code then
		Text_server_list_number:setString(string.format(red_alert_all_str[15],self.server_data.server_code))
	else
		Text_server_list_number:setString(string.format(red_alert_all_str[15],self.server_data.server_number))
	end
	local isShowData = true
	for i, v in pairs(_ED.all_servers) do
		if zstring.tonumber(v.server_number)%1000 == 999 then
			isShowData = false
		end
	end
	if isShowData == false then
		Text_server_list_number:setString("")
		Text_server_list_name:setPositionY(Text_server_list_name:getPositionY()-Text_server_list_name:getContentSize().height / 2)
	end
	local Panel_server_list_types =  ccui.Helper:seekWidgetByName(root,"Panel_server_list_types")
	Panel_server_list_types:removeBackGroundImage()
	if tonumber(self.server_data.server_type) == -1 then

	else
		Panel_server_list_types:setBackGroundImage("images/ui/state/server_status_" .. self.server_data.server_type .. ".png")
	end

end


function ServerListCell:init(server_data)
	self.server_data = server_data
	self.server_number = server_data.server_number
	self:onInit()
	self:setContentSize(ServerListCell.__size)
	return self
end

function ServerListCell:onExit()

end

