----------------------------------------------------------------------------------------------------
-- 说明：装备信息界面下滑列(套装)
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipInfoSuitListCell = class("EquipInfoSuitListCellClass", Window)
 
function EquipInfoSuitListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
    local function equip_info_suit_list_cell_terminal()
		local equip_info_suit_list_terminal = {
            _name = "equip_info_suit_list",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
                
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_info_suit_list_terminal)
        state_machine.init()
    end
    
    equip_info_suit_list_cell_terminal()
end


function EquipInfoSuitListCell:onEnterTransitionFinish()
    local csbEquipInfoSuitListCell = csb.createNode("packs/EquipStorage/equipment_information_list_3.csb")
	local root = csbEquipInfoSuitListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	
	local suitOne = ccui.Helper:seekWidgetByName(root, "Panel_3_1")
	local suitTwo = ccui.Helper:seekWidgetByName(root, "Panel_3_2")
	local suitThree = ccui.Helper:seekWidgetByName(root, "Panel_3_3")
	local suitFour = ccui.Helper:seekWidgetByName(root, "Panel_3_4")
	local suitName = ccui.Helper:seekWidgetByName(root, "Text_8")			--套装名称
	local quality = dms.int(dms["equipment_mould"],self.equipmentInstance.user_equiment_template,equipment_mould.grow_level) + 1
	
	--画套装装备图
	local suitPlace ={
		suitOne,
		suitTwo,
		suitThree,
		suitFour,
	}
	
	--记录激活了多少件套装
	local all_suit_number = 0
	--记录装备类型
	app.load("client.cells.equip.equip_icon_new_cell")
	local equipType = dms.int(dms["equipment_mould"],self.equipmentInstance.user_equiment_template,equipment_mould.equipment_type)
	local suit = dms.searchs(dms["equipment_mould"], equipment_mould.suit_id, dms.string(dms["equipment_mould"],self.equipmentInstance.user_equiment_template,equipment_mould.suit_id))
	local suitId = dms.int(dms["equipment_mould"],self.equipmentInstance.user_equiment_template,equipment_mould.suit_id)
	local ship = fundShipWidthId(self.equipmentInstance.ship_id)
	if tonumber(suitId) > 0 then
		for i =1,4 do
			local equipSuitId = dms.atos(suit[i], equipment_mould.id)
			if tonumber(self.equipmentInstance.user_equiment_template) == tonumber(equipSuitId) then
				local equipCell = EquipIconCell:createCell()
				equipCell:init(equipCell.enum_type._SHOW_EMBOITEMENT_INFORMATION, self.equipmentInstance, equipSuitId, ship)
				suitPlace[i]:addChild(equipCell)
				if equipCell:isActive() then
					all_suit_number = all_suit_number + 1
				end
			else
				local equipCell = EquipIconCell:createCell()
				equipCell:init(equipCell.enum_type._SHOW_EMBOITEMENT_INFORMATION, nil, equipSuitId, ship)
				suitPlace[i]:addChild(equipCell)
				if equipCell:isActive() then
					all_suit_number = all_suit_number + 1
				end
			end
		end		
	end
	
	
	--两件效果
	ccui.Helper:seekWidgetByName(root, "Text_2"):setString("2" .. _string_piece_info[31] .. ":")
	
	--三件效果
	ccui.Helper:seekWidgetByName(root, "Text_4"):setString("3" .. _string_piece_info[31] .. ":")
	
	--四件效果
	ccui.Helper:seekWidgetByName(root, "Text_4_0"):setString("4" .. _string_piece_info[31] .. ":")
	
	if tonumber(suitId) > 0 then
		local equipSuitId = dms.atos(suit[i], equipment_mould.id)
		local suit_name = dms.string(dms["suit_param"],suitId,suit_param.suit_name)
		suitName:setString(suit_name)
		suitName:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		local activate_property1 = dms.string(dms["suit_param"],suitId,suit_param.activate_property1)
		local activate_property2 = dms.string(dms["suit_param"],suitId,suit_param.activate_property2)
		local activate_property3 = dms.string(dms["suit_param"],suitId,suit_param.activate_property3)
		local seq1 = zstring.split(activate_property1,"|")
		local seq2 = zstring.split(activate_property2,"|")
		local seq3 = zstring.split(activate_property3,"|")
		local stringOne = ""
		local stringTwo= ""
		local stringThree = ""
		for i,v in pairs(seq1) do
			local influenceType = zstring.split(v,",")		--每一种属性
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if _pType+1 > 4 then
				stringOne = stringOne .. string_equiprety_name[_pType+1].._pValue.."%" .. " "
			else
				stringOne = stringOne .. string_equiprety_name[_pType+1].._pValue .. " "
			end
		end	
		for i,v in pairs(seq2) do
			local influenceType = zstring.split(v,",")		--每一种属性
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if _pType+1 > 4 then
				stringTwo = stringTwo .. string_equiprety_name[_pType+1].._pValue.."%" .. " "
			else
				stringTwo = stringTwo .. string_equiprety_name[_pType+1].._pValue .. " "
			end
		end	
		for i,v in pairs(seq3) do
			local influenceType = zstring.split(v,",")		--每一种属性
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if _pType+1 > 4 then
				stringThree = stringThree .. string_equiprety_name[_pType+1].._pValue.."%" .. " "
			else
				stringThree = stringThree .. string_equiprety_name[_pType+1].._pValue .. " "
			end
		end	
		ccui.Helper:seekWidgetByName(root, "Text_3"):setString(stringOne)
		ccui.Helper:seekWidgetByName(root, "Text_5"):setString(stringTwo)
		ccui.Helper:seekWidgetByName(root, "Text_5_0"):setString(stringThree)
	end
	
	if all_suit_number == 2 then
		ccui.Helper:seekWidgetByName(root, "Text_2"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_3"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
	elseif all_suit_number == 3 then
		ccui.Helper:seekWidgetByName(root, "Text_2"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_3"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_4"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_5"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
	elseif all_suit_number == 4 then
		ccui.Helper:seekWidgetByName(root, "Text_2"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_3"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_4"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_5"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_4_0"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		ccui.Helper:seekWidgetByName(root, "Text_5_0"):setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
	end

	
end


function EquipInfoSuitListCell:onExit()
	state_machine.remove("equip_info_suit_list")
end

function EquipInfoSuitListCell:init(equipmentInstance)
	self.equipmentInstance = equipmentInstance
end

function EquipInfoSuitListCell:createCell()
	local cell = EquipInfoSuitListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end