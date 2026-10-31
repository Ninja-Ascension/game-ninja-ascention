----------------------------------------------------------------------------------------------------
-- 说明：装备仓库装备信息隐藏列
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipListTanCell = class("EquipListTanCellClass", Window)
   
function EquipListTanCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self._cell = nil 
    local function init_equip_list_tan_cell_terminal()
		
		local equip_list_tan_to_strengthen_terminal = {
            _name = "equip_list_tan_to_strengthen",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
				equipStrengthenRefineStrorageWindow:init(params._datas._equip, "1", params._datas._cell, "equip_list_tan")
				fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
				
				state_machine.excute("equip_expansion_action_start", 0, {_datas = {cell = params._datas._cell}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		local equip_list_tan_to_refine_terminal = {
            _name = "equip_list_tan_to_refine",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				if dms.int(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
					local equipStrengthenRefineStrorageWindow = EquipStrengthenRefineStrorage:new()
					equipStrengthenRefineStrorageWindow:init(params._datas._equip,"2", params._datas._cell, "equip_list_tan")
					fwin:open(equipStrengthenRefineStrorageWindow, fwin._view)
					
					state_machine.excute("equip_expansion_action_start", 0, {_datas = {cell = params._datas._cell}})
				else
					TipDlg.drawTextDailog(dms.string(dms["fun_open_condition"], tonumber(params._datas.openWinId), fun_open_condition.tip_info))
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
        --去升星
		local equip_list_tan_to_star_terminal = {
            _name = "equip_list_tan_to_star",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local equipStarWindow = EquipStrengthenRefineStrorage:new()
				equipStarWindow:init(params._datas._equip,"4", params._datas._cell, "equip_list_tan")
				fwin:open(equipStarWindow, fwin._view)
				state_machine.excute("equip_expansion_action_start", 0, {_datas = {cell = params._datas._cell}})
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_list_tan_to_strengthen_terminal)
		state_machine.add(equip_list_tan_to_refine_terminal)
		state_machine.add(equip_list_tan_to_star_terminal)
        state_machine.init()
    end
    
    init_equip_list_tan_cell_terminal()
end


function EquipListTanCell:onEnterTransitionFinish()
	local csbPath = ""
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge
		or __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_yugioh
		then 
		csbPath = "list/list_equipment_tan_1.csb"
	else
		csbPath = "list/list_equipment_tan.csb"
	end
    local csbEquipListTanCell = csb.createNode(csbPath)
	self:addChild(csbEquipListTanCell)
	
	local root = csbEquipListTanCell:getChildByName("root")
	table.insert(self.roots, root)
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_79520"), nil, 
	{
		terminal_name = "equip_list_tan_to_strengthen", 
		terminal_state = 0, 
		_equip = self.equipmentInstance, 
		_cell = self._cell,
		isPressedActionEnabled = true
	}, 
	nil, 0)
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_2"), nil, 
	{
		terminal_name = "equip_list_tan_to_refine", 
		terminal_state = 0, 
		_equip = self.equipmentInstance,  
		_cell = self._cell,
		openWinId = 40,
		isPressedActionEnabled = true
	}, 
	nil, 0)

	local upStarButton = ccui.Helper:seekWidgetByName(root, "Button_2_0")
	if upStarButton ~= nil then
		-- 装备升星功能
		fwin:addTouchEventListener(upStarButton, nil, 
		{
			terminal_name = "equip_list_tan_to_star", 
			terminal_state = 0, 
			_equip = self.equipmentInstance,  
			_cell = self._cell,
			isPressedActionEnabled = true
		}, 
		nil, 0)
		local maxStar = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.star_level)
		if maxStar == -1 then 
			ccui.Helper:seekWidgetByName(root, "Text_2"):setString(_equip_up_star_tip[1])
			upStarButton:setTouchEnabled(false)
			upStarButton:setColor(cc.c3b(150, 150, 150))
		else
			local currentStar = zstring.tonumber(self.equipmentInstance.current_star_level)-- 服务器数据
			if currentStar >= maxStar then 
				--满星
				upStarButton:setTouchEnabled(false)
				upStarButton:setColor(cc.c3b(150, 150, 150))
				ccui.Helper:seekWidgetByName(root, "Text_2"):setString(_equip_up_star_tip[2])
			else
				upStarButton:setTouchEnabled(true)
				upStarButton:setColor(cc.c3b(255, 255, 255))
				ccui.Helper:seekWidgetByName(root, "Text_2"):setString("")
			end
		end
	end

	if dms.int(dms["fun_open_condition"], 40, fun_open_condition.level) <= zstring.tonumber(_ED.user_info.user_grade) then
		ccui.Helper:seekWidgetByName(root, "Text_1"):setVisible(false)
	else
		ccui.Helper:seekWidgetByName(root, "Text_1"):setVisible(true)
		ccui.Helper:seekWidgetByName(root, "Text_1"):setString(dms.string(dms["fun_open_condition"], 40, fun_open_condition.tip_info))
	end
end


function EquipListTanCell:onExit()
	state_machine.remove("equip_list_tan_to_strengthen")
	state_machine.remove("equip_list_tan_to_refine")
end

function EquipListTanCell:init(cells)
	self._cell = cells
	self.equipmentInstance = cells.equipmentInstance
end

function EquipListTanCell:createCell()
	local cell = EquipListTanCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end