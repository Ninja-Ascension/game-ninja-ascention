-- ----------------------------------------------------------------------------------------------------
-- 说明：金钱跳转路径控件
-- 创建时间：2015-11-03
-- 作者：杨晗
-- 修改记录：新建
-------------------------------------------------------------------------------------------------------

SilverToGetListCell = class("SilverToGetListCellClass", Window)
SilverToGetListCell.__size = nil
function SilverToGetListCell:ctor()
    self.super:ctor()
    self.roots = {}
	self.mouldId = nil
    local function init_silver_toget_listcell_terminal()
	--跳转
		local silver_toget_listcell_gotoget_terminal = {
			_name = "silver_toget_listcell_gotoget",
			_init = function (terminal)
				
			end,
			_inited = false,
			_instance = self,
			_state = 0,
			_invoke = function(terminal, instance, params)
				local mouldId = params._datas.mouldId
				state_machine.excute("shortcut_function_trace", 0, {trace_function_id = mouldId, _datas = {}})
				fwin:close(fwin:find("SilverToGetClass"))
				return true
			end,
			_terminal = nil,
			_terminals = nil
		}
		state_machine.add(silver_toget_listcell_gotoget_terminal)
        state_machine.init()
    end
    init_silver_toget_listcell_terminal()
   -- call func init hom state machine.
end



function SilverToGetListCell:onEnterTransitionFinish()

end

function SilverToGetListCell:onInit()

	local root = cacher.createUIRef("packs/to_get_list.csb", "root")
 	table.insert(self.roots, root)
 	self:addChild(root)

 	if SilverToGetListCell.__size == nil then
	 	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
		local MySize = Panel_2:getContentSize()
	 	SilverToGetListCell.__size = MySize
	end
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_1101"),nil, 
	{
		terminal_name = "silver_toget_listcell_gotoget", 
		terminal_state = 0,
		isPressedActionEnabled = true,
		mouldId = self.mouldId
	}
	,nil, 0)
	self:initDraw()
end

--绘制
function SilverToGetListCell:initDraw()
	local root = self.roots[1]
	local panel_image = ccui.Helper:seekWidgetByName(root,"Panel_1103") --图片背景
	local Text_1103 = ccui.Helper:seekWidgetByName(root,"Text_1103") -- 未开启提示文字
	local Button_1101 = ccui.Helper:seekWidgetByName(root,"Button_1101") -- 跳转按钮
	local textName = ccui.Helper:seekWidgetByName(root,"Text_1101") -- 名字
	local textDes = ccui.Helper:seekWidgetByName(root,"Text_1102") -- 描述
	local panel_1101 = ccui.Helper:seekWidgetByName(root,"Panel_1101") -- 遮挡层
	local name = dms.string(dms["function_param"], self.mouldId, function_param.name)
	local pic = dms.int(dms["function_param"], self.mouldId, function_param.icon)
	local des = dms.string(dms["function_param"], self.mouldId, function_param.describe)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local describeInfo = ""
        local describeData = zstring.split(des, "|")
        for i, v in pairs(describeData) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            describeInfo = describeInfo .. word_info[3]
        end
        
        des = describeInfo
    end
	panel_1101:setSwallowTouches(false)
	Button_1101:setVisible(false)
	Text_1103:setVisible(false)
	textName:setString("")
	textDes:setString("")
	panel_image:removeBackGroundImage()
	
	textName:setString(name)
	textDes:setString(des)
	panel_image:setBackGroundImage(string.format("images/ui/function_icon/function_icon_%d.png", pic))
	
	--功能开启等级
	local funopenId = dms.string(dms["function_param"],self.mouldId,function_param.open_function)
	local openlevel = dms.int(dms["fun_open_condition"],funopenId,fun_open_condition.level)
	
	--当前角色等级
	local user_level= tonumber(_ED.user_info.user_grade)
	
	if user_level >= openlevel then
		Button_1101:setVisible(true)
	else
		Text_1103:setVisible(true)
	end
end

function SilverToGetListCell:reload()
	local root = self.roots[1]
	if root ~= nil then
		return
	end
	self:onInit()
end

function SilverToGetListCell:unload()
	local root = self.roots[1]
	if root == nil then
		return
	end
	cacher.freeRef("packs/to_get_list.csb", root)
	root:stopAllActions()
	root:removeFromParent(false)
	self.roots = {}
end

function SilverToGetListCell:init(mouldId,index)
	self.mouldId  = tonumber(mouldId)
	if index ~= nil and index < 5 then
		self:onInit()
	end
	self:setContentSize(SilverToGetListCell.__size)
	return self
end

function SilverToGetListCell:createCell()
	local cell = SilverToGetListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end


function SilverToGetListCell:onExit()
	cacher.freeRef("packs/to_get_list.csb", self.roots[1])
	state_machine.remove("silver_toget_listcell_gotoget")
end

