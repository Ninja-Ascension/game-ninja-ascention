----------------------------------------------------------------------------------------------------
-- 说明：主线副本列表元件的绘制及逻辑实现
-------------------------------------------------------------------------------------------------------
BattleFunctionOpenCell = class("BattleFunctionOpenCellClass", Window)
 
function BattleFunctionOpenCell:ctor()
    self.super:ctor()
	self.roots = {}
    self.functionId = 0
	self.openType = 0
	self.enum_type = {
		FORMATION_EQUIP_DRESS = 1,				-- 	1:阵容装备没有时的去获得
	}
	local function init_battle_function_open_terminal()
		
		local go_to_get_button_touch_terminal = {
            _name = "go_to_get_button_touch",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				local _openType = tonumber(params._datas.open_Type)
				local mySelf = params._datas.mCell
				if _openType == mySelf.enum_type.FORMATION_EQUIP_DRESS then
					state_machine.excute("home_click_hero_shop", 0, nil)
				end
				state_machine.excute("to_get_equip_close", 0, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(go_to_get_button_touch_terminal)
        state_machine.init()
    end
    -- init_plot_copy_cell_terminal()
	
	init_battle_function_open_terminal()
end

function BattleFunctionOpenCell:onUpdateDraw()
	local root = self.roots[1]
	local openLv = dms.string(dms["function_param"],self.functionId ,function_param.open_leve) --开启等级
	local openIcon = dms.string(dms["function_param"],self.functionId ,function_param.icon) --图标
	local openName = dms.string(dms["function_param"],self.functionId ,function_param.name) --名字
	local openDescribe = dms.string(dms["function_param"],self.functionId ,function_param.describe) --描述信息
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        local describeInfo = ""
        local describeData = zstring.split(openDescribe, "|")
        for i, v in pairs(describeData) do
            local word_info = dms.element(dms["word_mould"], zstring.tonumber(v))
            describeInfo = describeInfo .. word_info[3]
        end
        
        openDescribe = describeInfo
    end
	self.openType = dms.string(dms["function_param"],self.functionId ,function_param.genre) --类型
	
	local functionName = ccui.Helper:seekWidgetByName(root, "Text_name001")	
	local functionDescribe = ccui.Helper:seekWidgetByName(root, "Text_jiesao")	
	functionName:setString(openName)
	functionDescribe:setString(openDescribe)
	local functionIcon = ccui.Helper:seekWidgetByName(root, "Panel_button")	
	local IconWay = string.format("images/ui/function_icon/function_icon_%d.png", openIcon)
	functionIcon:setBackGroundImage(IconWay)
	local functionOpenLv1 = ccui.Helper:seekWidgetByName(root, "Text_kaiqidengji")	
	local functionOpenLv2 = ccui.Helper:seekWidgetByName(root, "Text_weikaiqi")	
	local functionOpenLv3 = ccui.Helper:seekWidgetByName(root, "Button_qianwang")	
	if tonumber(_ED.user_info.user_grade) < tonumber(openLv) then
		functionOpenLv1:setVisible(true)
		if verifySupportLanguage(_lua_release_language_en) == true then
			functionOpenLv1:setString(_string_piece_info[182]..openLv)
		else
			functionOpenLv1:setString(openLv.._string_piece_info[182])
		end
		functionOpenLv2:setVisible(false)
		functionOpenLv3:setVisible(false)
	elseif tonumber(_ED.user_info.user_grade) == tonumber(openLv) then
		functionOpenLv1:setVisible(false)
		functionOpenLv2:setVisible(true)
		functionOpenLv3:setVisible(false)
	elseif tonumber(_ED.user_info.user_grade) > tonumber(openLv) then
		functionOpenLv1:setVisible(false)
		functionOpenLv2:setVisible(true)
		functionOpenLv3:setVisible(false)
	end
end



function BattleFunctionOpenCell:onEnterTransitionFinish()
    local csbEquipPatchListCell = csb.createNode("battle/list_kaiqi.csb")
	local root = csbEquipPatchListCell:getChildByName("root")
	table.insert(self.roots, root)
	self:setContentSize(root:getChildByName("Panel_20"):getContentSize())
	self:addChild(csbEquipPatchListCell)	
	
	self:onUpdateDraw()
		
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_qianwang"), nil, 
		{
			terminal_name = "go_to_get_button_touch",
			terminal_state = 0, 
			open_Type = self.openType,
			mCell = self,
			isPressedActionEnabled = true
		}, 
		nil, 0)
end

function BattleFunctionOpenCell:onExit()
	state_machine.remove("go_to_get_button_touch")
end

function BattleFunctionOpenCell:init(function_id)
	self.functionId = function_id
end

function BattleFunctionOpenCell:createCell()
	local cell = BattleFunctionOpenCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end