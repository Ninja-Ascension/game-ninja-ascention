----------------------------------------------------------------------------------------------------
-- 说明：时装组合界面下滑列(组合)
-------------------------------------------------------------------------------------------------------
FashionInfoCombinationListCell = class("FashionInfoCombinationListCellClass", Window)

function FashionInfoCombinationListCell:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipmentInstance = nil
	self.equip_mouldId = nil
	app.load("client.cells.utils.resources_icon_cell")
    local function equip_info_describe_list_cell_terminal()
		
    end
    
    equip_info_describe_list_cell_terminal()
end

function FashionInfoCombinationListCell:onUpdateDraw()
	local root = self.roots[1]
	local Text_8 = ccui.Helper:seekWidgetByName(root, "Text_8")  -- 名称
	-- local Text_2 = ccui.Helper:seekWidgetByName(root, "Text_2")  -- 名称
	-- Text_2:setString("激活效果")

	local Text_4 = ccui.Helper:seekWidgetByName(root, "Text_4")  --
	local Text_5 = ccui.Helper:seekWidgetByName(root, "Text_5")  --
	local Text_4_0 = ccui.Helper:seekWidgetByName(root, "Text_4_0")  --
	local Text_5_0 = ccui.Helper:seekWidgetByName(root, "Text_5_0")  --
	Text_4:setString("")
	Text_5:setString("")
	Text_4_0:setString("")
	Text_5_0:setString("")

	local Panel_3_1 = ccui.Helper:seekWidgetByName(root, "Panel_3_1")
	local Panel_3_2 = ccui.Helper:seekWidgetByName(root, "Panel_3_2")

	local equipMouldId = nil
    local equipGrade =nil
	local equip = self.equipmentInstance
    if equip == nil then
        equipGrade = 1
        equipMouldId = self.equip_mouldId
    else
        equipGrade = tonumber(equip.user_equiment_grade)
        equipMouldId = equip.user_equiment_template
    end

	local suitId = dms.int(dms["equipment_mould"], equipMouldId, equipment_mould.suit_id)
	local suitData = dms.searchs(dms["equipment_fashion_pokedex"], equipment_fashion_pokedex.suit_id, suitId)
	local quality = dms.int(dms["equipment_mould"],equipMouldId,equipment_mould.grow_level) + 1
	if suitData ~= nil and table.getn(suitData) ~= 0 then
		
		local fashionIdOne = dms.atoi(suitData[1],equipment_fashion_pokedex.suit_fashion_id_1) 
		local fashionIdTwo = dms.atoi(suitData[1],equipment_fashion_pokedex.suit_fashion_id_2) 

			
		local tempCell = ResourcesIconCell:createCell()
		tempCell:init(7, 0, fashionIdOne)
		Panel_3_1:removeAllChildren(true)
		Panel_3_1:addChild(tempCell)
		tempCell:showName(fashionIdOne,7)

		local tempCell2 = ResourcesIconCell:createCell()
		tempCell2:init(7, 0, fashionIdTwo)
		Panel_3_2:removeAllChildren(true)
		Panel_3_2:addChild(tempCell2)
		tempCell2:showName(fashionIdTwo,7)
    end
    if tonumber(suitId) > 0 then
		-- local equipSuitId = dms.atos(suit[i], equipment_mould.id)
		local suit_name = dms.string(dms["suit_param"],suitId,suit_param.suit_name)
		Text_8:setString(suit_name)
		Text_8:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
		local activate_property1 = dms.string(dms["suit_param"],suitId,suit_param.activate_property1)
		local activate_property2 = dms.string(dms["suit_param"],suitId,suit_param.activate_property2)
		local activate_property3 = dms.string(dms["suit_param"],suitId,suit_param.activate_property3)
		local seq1 = zstring.split(activate_property1,"|")
		local stringOne = ""
		for i,v in pairs(seq1) do
			local influenceType = zstring.split(v,",")		--每一种属性
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if i == 1 then
				if _pType+1 > 4 then
					Text_4:setString(_influence_type[_pType+1])
					Text_5:setString("+".._pValue.."%")
				else
					Text_4:setString(_influence_type[_pType+1])
					Text_5:setString("+".._pValue)
				end
			elseif i == 2 then
				if _pType+1 > 4 then
					Text_4_0:setString(_influence_type[_pType+1])
					Text_5_0:setString("+".._pValue.."%")
				else
					Text_4_0:setString(_influence_type[_pType+1])
					Text_5_0:setString("+".._pValue)
				end
			end
		end	
	end
	
end

function FashionInfoCombinationListCell:onEnterTransitionFinish()
    local csbFashionInfoCombinationListCell = csb.createNode("packs/EquipStorage/equipment_information_list_6.csb")
	local root = csbFashionInfoCombinationListCell:getChildByName("root")
	root:removeFromParent(true)
	self:addChild(root)
	table.insert(self.roots, root)
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local MySize = PanelGeneralsEquipment:getContentSize()
	self:setContentSize(MySize)
	
	self:onUpdateDraw()
	-- Text_5 描述
	
	
end


function FashionInfoCombinationListCell:onExit()

end

function FashionInfoCombinationListCell:init(equipmentInstance,equipId)
	self.equipmentInstance = equipmentInstance
	self.equip_mouldId = equipId
end

function FashionInfoCombinationListCell:createCell()
	local cell = FashionInfoCombinationListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end