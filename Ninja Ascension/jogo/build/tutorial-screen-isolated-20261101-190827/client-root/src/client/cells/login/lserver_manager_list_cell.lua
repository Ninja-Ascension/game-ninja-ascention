-- ----------------------------------------------------------------------------------------------------
-- 说明：服务器列表控件 -- 
-- 创建时间：2015
-- 作者：杨晗
-- 修改记录：新建
-- 2015-11-06 舰娘也开始使用此文件
-------------------------------------------------------------------------------------------------------

LServerManagerCell = class("LServerManagerCellClass", Window)
LServerManagerCell.__size = nil
function LServerManagerCell:ctor()
    self.super:ctor()
    self.roots = {}
    self.server_type = nil
    self.server_name = nil
    self.defer = nil 
    self._undef = nil
    local function init_lserver_manager_cell_terminal()	
        state_machine.init()
    end
    
   -- call func init hom state machine.
end



function LServerManagerCell:onEnterTransitionFinish()

end

function LServerManagerCell:onInit()

	local root = cacher.createUIRef("login/server_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)
 	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		then
		if LServerManagerCell.__size == nil then
		 	LServerManagerCell.__size = root:getContentSize()
		end
	else
	 	if LServerManagerCell.__size == nil then
		 	local Panel_11984 = ccui.Helper:seekWidgetByName(root, "Panel_11984")
			local MySize = Panel_11984:getContentSize()
		 	LServerManagerCell.__size = MySize
		end
	end
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "ImageView_server_information_0_0_0"),nil, 
		{
			_sel = self.defer, 
			_undef = self._undef, 
			terminal_name = "server_manager_select_server", 
			terminal_state = 0
		}
		,nil, 0)
	else
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_11984"),nil, 
		{
			_sel = self.defer, 
			_undef = self._undef, 
			terminal_name = "server_manager_select_server", 
			terminal_state = 0
		}
		,nil, 0)
	end
	self:initDraw()
end

--添加ICON 点击事件
function LServerManagerCell:initDraw()
	local root = self.roots[1]
	local serverName = ccui.Helper:seekWidgetByName(root,"Label_server_name_1_0_0_0*")
	serverName:setString("")
	serverName:setString(self.server_name)

	-- 新服标签
	local Image_1 = ccui.Helper:seekWidgetByName(root,"Image_1")
	if true and Image_1 then
		if tonumber(self.server_type) == 1 then 
			Image_1:setVisible(true)
		else
			Image_1:setVisible(false)
		end
	end
	local serverType =  ccui.Helper:seekWidgetByName(root,"Panel_2")
	serverType:removeBackGroundImage()
	if true then
		if tonumber(self.server_type) == -1 then
		elseif tonumber(self.server_type) == 0 or tonumber(self.server_type) == 1 or tonumber(self.server_type) == 3 then
			serverType:setBackGroundImage("image/server/server_state_1.png")
		elseif tonumber(self.server_type) == 2 then
			serverType:setBackGroundImage("image/server/server_state_4.png")
		elseif tonumber(self.server_type) == 4 then
			serverType:setBackGroundImage("image/server/server_state_3.png")
		elseif tonumber(self.server_type) == 5 then
			serverType:setBackGroundImage("image/server/server_state_2.png")
		end
	else
		if tonumber(self.server_type) == -1 then
		elseif tonumber(self.server_type) == 0 then
			serverType:setBackGroundImage("images/ui/state/server_status_0.png")
		elseif tonumber(self.server_type) == 1 then
			serverType:setBackGroundImage("images/ui/state/server_status_1.png")
		elseif tonumber(self.server_type) == 2 then
			serverType:setBackGroundImage("images/ui/state/server_status_2.png")
		elseif tonumber(self.server_type) == 3 then
			serverType:setBackGroundImage("images/ui/state/server_status_3.png")
		elseif tonumber(self.server_type) == 4 then
			serverType:setBackGroundImage("images/ui/state/server_status_4.png")
		elseif tonumber(self.server_type) == 5 then
			serverType:setBackGroundImage("images/ui/state/server_status_5.png")
		end
	end
	

end

function LServerManagerCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function LServerManagerCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("login/server_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function LServerManagerCell:init(server_type,server_name,index,defer,_undef)
	self.server_type = server_type
	self.server_name = server_name
	self.defer = defer 
    self._undef = _undef
	if index ~= nil and index < 9 then
		self:onInit()
	end
	self:setContentSize(LServerManagerCell.__size)
	return self
end

function LServerManagerCell:createCell()
	local cell = LServerManagerCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function LServerManagerCell:onExit()
	cacher.freeRef("login/server_list.csb", self.roots[1])
end

