-- ----------------------------------------------------------------------------------------------------
-- 说明：碎片信息界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipFragmentQuality = class("EquipFragmentQualityClass", Window)
   
function EquipFragmentQuality:ctor()
    self.super:ctor()
	self.roots = {}
	self.propId = nil
	self.types = nil
	app.load("client.packs.equipment.EquipFragmentAcquire")
    local function init_equip_information_terminal()
		
        state_machine.init()
    end
    
    init_equip_information_terminal()
end
function EquipFragmentQuality:onUpdateDraw()
	local root = self.roots[1]
	
	local mouldId = nil
	local num = 0
	if self.types == 2 then
		mouldId = self.propId
		for i, v in pairs(_ED.user_prop) do
			if tonumber(v.user_equiment_template) == tonumber(mouldId) then
				num = v.prop_number
			end
		end
	else
		mouldId = self.propId.user_prop_template
		num = self.propId.prop_number
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			for i, v in pairs(_ED.user_prop) do
				if tonumber(v.user_prop_template) == tonumber(mouldId) then
					num = v.prop_number
				end
			end
		end
	end

	--名字
	local heraData=dms.string(dms["prop_mould"],mouldId,prop_mould.prop_name)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
        heraData = setThePropsIcon(mouldId)[2]
    end
	local TextName= ccui.Helper:seekWidgetByName(root, "Text_name")
	TextName:setString(heraData)
	local colortype = dms.string(dms["prop_mould"],mouldId,prop_mould.prop_quality)
	TextName:setColor(cc.c3b(color_Type[colortype+1][1],color_Type[colortype+1][2],color_Type[colortype+1][3]))
	
	--数量
	local TextCount= ccui.Helper:seekWidgetByName(root, "Text_shuliang_0")
	local maxNumber = dms.int(dms["prop_mould"], mouldId, prop_mould.split_or_merge_count)
	TextCount:setString(num .. "/" .. maxNumber)
	--介绍内容
	local Text6= ccui.Helper:seekWidgetByName(root, "Text_6")
	local propremark = dms.string(dms["prop_mould"],mouldId,prop_mould.remarks)
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		propremark = drawPropsDescription(mouldId)
	end
	Text6:setString(propremark)
	
	if self.types == 2 then
		--绘制小头像
		local PanelIcons= ccui.Helper:seekWidgetByName(root, "Panel_icons")
		app.load("client.cells.prop.prop_icon_new_cell")
		local picCell = PropIconNewCell:createCell()
		picCell:init(14,mouldId)
		PanelIcons:addChild(picCell)
	else
		--绘制小头像
		local PanelIcons= ccui.Helper:seekWidgetByName(root, "Panel_icons")
		app.load("client.cells.prop.prop_icon_new_cell")
		local picCell = PropIconNewCell:createCell()
		picCell:init(picCell.enum_type._SHOW_EQUIP_INFORMATION,self.propId)
		PanelIcons:addChild(picCell)
	end
	
	-- 装备类型
	local equipId = dms.string(dms["prop_mould"],mouldId,prop_mould.change_of_equipment)
	local TypeCurrent = tonumber(dms.string(dms["equipment_mould"],equipId,equipment_mould.equipment_type)) 
	local textType= ccui.Helper:seekWidgetByName(root, "Text_leixin")
	local str = nil
	if TypeCurrent == 0 then
		str = _string_piece_info[7]
	elseif TypeCurrent == 1 then
		str = _string_piece_info[9]
	elseif TypeCurrent == 2 then
		str = _string_piece_info[8]
	elseif TypeCurrent == 3 then
		str = _string_piece_info[10]
	end
	textType:setString(str)
	
	local getWay = dms.string(dms["prop_mould"], mouldId, prop_mould.trace_address)
	if getWay ~= nil and zstring.tonumber(getWay) ~= -1 then
	
		local temp = zstring.split(getWay, ",")
		for i, v in pairs(temp) do
			if tonumber(v) > 0 then 
				local cell = EquipFragmentAcquire:createCell()
				cell:init(v)
				ccui.Helper:seekWidgetByName(root, "ListView_1"):addChild(cell)
			end
		end
	else
		ccui.Helper:seekWidgetByName(root, "Text_huode_xx"):setString(_string_piece_info[365])
	end
	
	
end

function EquipFragmentQuality:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		return
	end
    local csbEquipFragmentQuality = csb.createNode("packs/Fragmentation_info.csb")
    self:addChild(csbEquipFragmentQuality)
	local root = csbEquipFragmentQuality:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function EquipFragmentQuality:onLoad( ... )
	local csbEquipFragmentQuality = csb.createNode("packs/Fragmentation_info.csb")
    self:addChild(csbEquipFragmentQuality)
	local root = csbEquipFragmentQuality:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function EquipFragmentQuality:onExit()

end

function EquipFragmentQuality:init(prop, types)
	self.propId = prop
	self.types = types
end


function EquipFragmentQuality:createCell()
	local cell = EquipFragmentQuality:new()
	cell:registerOnNodeEvent(cell)
	return cell
end