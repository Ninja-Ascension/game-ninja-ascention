-- ----------------------------------------------------------------------------------------------------
-- 说明：装备详情界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipParticulars = class("EquipParticularsClass", Window)
   
function EquipParticulars:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipId = nil
	app.load("client.cells.npc.plot_npc_cell")
    -- Initialize Home page state machine.
    local function init_equip_information_terminal()
		--去获取
		local equip_patch_information_page_get_terminal = {
            _name = "equip_patch_information_page_get",
            _init = function (terminal)
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local ship = params._datas._ship
				app.load("client.packs.hero.HeroPatchInformationPageGetWay")
				local cell = HeroPatchInformationPageGetWay:createCell()
				cell:init(ship,1)
				fwin:open(cell, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        state_machine.init()
		state_machine.add(equip_patch_information_page_get_terminal)
    end
    
    init_equip_information_terminal()
end

function EquipParticulars:onUpdateDraw()
	local root = self.roots[1]
	
	--名字
	local heraData=dms.string(dms["equipment_mould"],self.equipId,equipment_mould.equipment_name)
	local equTextName = ccui.Helper:seekWidgetByName(root, "Text_name_1")
	equTextName:setString(heraData)
	local propType = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.grow_level)+1
	equTextName:setColor(cc.c4b(color_Type[propType][1],color_Type[propType][2],color_Type[propType][3],255))
	
	--类型
	local TypeCurrent = tonumber(dms.string(dms["equipment_mould"],self.equipId,equipment_mould.equipment_type)) 
	--装备类型：0武器	1头盔	2项链	3盔甲	4战马	5兵书	
	local equPanelType= ccui.Helper:seekWidgetByName(root, "Panel_21")
	local equipIconeType = nil
	if TypeCurrent == 0 then
		equipIconeType = string.format("images/ui/quality/zb_leixing_0.png")
	elseif TypeCurrent ==1 then 
		equipIconeType = string.format("images/ui/quality/zb_leixing_1.png")
	elseif TypeCurrent ==2 then
		equipIconeType = string.format("images/ui/quality/zb_leixing_2.png")
	elseif TypeCurrent ==3 then
		equipIconeType = string.format("images/ui/quality/zb_leixing_3.png")
	elseif TypeCurrent ==6 then
		equipIconeType = string.format("images/ui/quality/zb_leixing_6.png")
	elseif TypeCurrent ==7 then
		-- equipIconeType = string.format("images/ui/quality/zb_leixing_0.png")
	end
	equPanelType:setBackGroundImage(equipIconeType)
	
	-- 图像
	local equPanelCard= ccui.Helper:seekWidgetByName(root, "Panel_juese")
	local equipIcon = ""
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_warship_girl_b
		or __lua_project_id == __lua_project_yugioh
		then 
		local AllIcon = dms.int(dms["equipment_mould"], self.equipId, equipment_mould.All_icon)
		equipIcon = string.format("images/ui/big_props/big_props_%s.png",""..AllIcon)
	else
		equipIcon = string.format("images/ui/big_props/big_props_%s.png",self.equipId)
	end
	equPanelCard:setBackGroundImage(equipIcon)	

	--基础属性
	local equQualityName = ccui.Helper:seekWidgetByName(root, "Text_4")
	local equQualityCount = ccui.Helper:seekWidgetByName(root, "Text_5")
	local equipProperty = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.initial_value)
	local initialValue = zstring.split(equipProperty,"|")
	local c = 1
	local refine = {}
	for i,v in pairs(initialValue) do
		if i>3 then
			break
		end
		local influenceType = zstring.split(v,",")		--每一种属性
		if table.getn(influenceType) >= 2 then 
			local _pType = tonumber(influenceType[1])
			local _pValue = tonumber(influenceType[2])
			-- if refine[_pType] ~= nil then
				-- _pValue = _pValue + tonumber(refine[_pType])
				-- refine[_pType] = nil
			-- end
			if table.getn(initialValue) > 1 then
				if i==1 then
					equQualityName:setString(string_equiprety_name_teo[_pType+1].."+".._pValue)
				elseif i==2 then
					equQualityCount:setString(string_equiprety_name_teo[_pType+1].."+".._pValue)
				end
			else
				equQualityName:setString(string_equiprety_name_teo[_pType+1])
				equQualityCount:setString("+".._pValue)
			end
			c = c+1
		end
	end
	--升级属性
	local upgradeName = ccui.Helper:seekWidgetByName(root, "Text_6")
	local upgradeCount = ccui.Helper:seekWidgetByName(root, "Text_7")
	local everyLevel = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.grow_value)
	local everyLevelAdd = zstring.split(everyLevel,"|")
	for i,v in pairs(everyLevelAdd) do
		local influenceType = zstring.split(v,",")		--每一种属性
		if table.getn(influenceType) >= 2 then
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if table.getn(everyLevelAdd) > 1 then
				if i==1 then
					upgradeName:setString(string_equiprety_name_teo[_pType+1].."+".._pValue)
				elseif i==2 then
					upgradeCount:setString(string_equiprety_name_teo[_pType+1].."+".._pValue)
				end
			else
				upgradeName:setString(string_equiprety_name_teo[_pType+1])
				upgradeCount:setString("+".._pValue)
			end
		end
		
	end
	--套装效果加成属性
	local EquipName = ccui.Helper:seekWidgetByName(root, "Text_10")
	local twoEquip = ccui.Helper:seekWidgetByName(root, "Text_11")
	local threeEquip = ccui.Helper:seekWidgetByName(root, "Text_13")
	local fourEquip = ccui.Helper:seekWidgetByName(root, "Text_14")
	EquipName:setString(dms.string(dms["equipment_mould"],self.equipId,equipment_mould.equipment_name))
	EquipName:setColor(cc.c4b(color_Type[propType][1],color_Type[propType][2],color_Type[propType][3],255))
	twoEquip:setString(_string_piece_info[48]..":")
	threeEquip:setString(_string_piece_info[49]..":")
	fourEquip:setString(_string_piece_info[50]..":")
	
	local twoCount = ccui.Helper:seekWidgetByName(root, "Text_12")
	local threeCount = ccui.Helper:seekWidgetByName(root, "Text_15")
	local fourCount = ccui.Helper:seekWidgetByName(root, "Text_16")
	
	local stringOne = ""
	local stringTwo= ""
	local stringThree = ""
	--装备2套
	local equipData1 = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.suit_id)
	if tonumber(equipData1) > 0 then
		local suitParamData = dms.string(dms["suit_param"],equipData1,suit_param.activate_property1)
		local suitParamPropertyOne = zstring.split(suitParamData,"|")
		for i,v in pairs(suitParamPropertyOne) do
			local influenceType = zstring.split(v,",")		--每一种属性
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				if _pType+1 > 4 then
					stringOne = stringOne .. string_equiprety_name[_pType+1].._pValue.."%" .. " "
				else
					stringOne = stringOne .. string_equiprety_name[_pType+1].._pValue .. " "
				end
			else
				if _pType+1 > 4 then
					twoCount:setString(string_equiprety_name[_pType+1].._pValue.."%")
				else
					twoCount:setString(string_equiprety_name[_pType+1].._pValue)
				end
			end	
		end	
		--装备3套
		local suitParamData1 = dms.string(dms["suit_param"],equipData1,suit_param.activate_property2)
		local suitParamPropertyTwo = zstring.split(suitParamData1,"|")
		for i,v in pairs(suitParamPropertyTwo) do
			local influenceType = zstring.split(v,",")		
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				if _pType+1 > 4 then
					stringTwo = stringTwo .. string_equiprety_name[_pType+1].._pValue.."%" .. " "
				else
					stringTwo = stringTwo .. string_equiprety_name[_pType+1].._pValue .. " "
				end
			else
				if _pType+1 > 4 then
					threeCount:setString(string_equiprety_name[_pType+1].._pValue.."%")
				else
					threeCount:setString(string_equiprety_name[_pType+1].._pValue)
				end
			end	
		end	
		--装备4套
		local suitParamData2 = dms.string(dms["suit_param"],equipData1,suit_param.activate_property3)
		local suitParamPropertyThree = zstring.split(suitParamData2,"|")
		local strShuxing = ""
		for i,v in pairs(suitParamPropertyThree) do
			local influenceType = zstring.split(v,",")		
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]
			if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
				if _pType+1 > 4 then
					stringThree = stringThree .. string_equiprety_name[_pType+1].._pValue.."%" .. " "
				else
					stringThree = stringThree .. string_equiprety_name[_pType+1].._pValue .. " "
				end
			else
				if _pType+1 > 4 then
					strShuxing =  strShuxing.." ".. string_equiprety_name[_pType+1].._pValue.."%" 
					fourCount:setString(string_equiprety_name[_pType+1].._pValue.."%")
				else
					strShuxing =  strShuxing.." "..string_equiprety_name[_pType+1].._pValue.."%" 
					fourCount:setString(string_equiprety_name[_pType+1].._pValue)
				end

			end
		end	

		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			fourCount:setString(strShuxing)
		elseif __lua_project_id == __lua_project_warship_girl_a 
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_digimon_adventure 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			twoCount:setString(stringOne)
			threeCount:setString(stringTwo)
			fourCount:setString(stringThree)
		end
	end
	
	--简介内容
	local describeCount = ccui.Helper:seekWidgetByName(root, "Text_19")
	local equipIntro = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.trace_remarks)
	local equipData = dms.element(dms["equipment_mould"], self.equipId)
	local size = describeCount:getContentSize()
	if equipData ~= nil then
		local equipment_type = dms.element(dms["equipment_mould"], self.equipId,equipment_mould.equipment_type)
	
		equipIntro = zstring.split(equipIntro,"|")
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			or __lua_project_id == __lua_project_red_alert 
			then
			equipIntro = equipIntro[1]
		else
			_ED.user_info.user_gender = "1"
			equipIntro = equipIntro[zstring.tonumber(_ED.user_info.user_gender)]
		end
		describeCount:setString(equipIntro)
		describeCount:setContentSize(size.width,70)
		describeCount:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
	end
	
	-- 绘制装备小头像
	local rewardItem = {
		"Panel_tz_1",
		"Panel_tz_2",
		"Panel_tz_3",
		"Panel_tz_4",
		}
	local equipData = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.suit_id)
	local suit = dms.searchs(dms["equipment_mould"], equipment_mould.suit_id, equipData)
	local suitId = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.suit_id)
	if tonumber(suitId) > 0 then
		for i =1,4 do	
		-- [[应该调用装备小图标绘制
			local equipSuitId = dms.atos(suit[i], equipment_mould.id)
			app.load("client.cells.equip.equip_icon_cell")
			local equipCell = EquipIconCell:createCell()
			equipCell:init(equipCell.enum_type._SHOW_EMBOITEMENT_INFORMATION_PARTICULARS, nil,equipSuitId)
			local mRewardItem = ccui.Helper:seekWidgetByName(root, rewardItem[i])
			mRewardItem:addChild(equipCell)
		--]]
		end		
	end

	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go"), nil, 
	{
		terminal_name = "equip_patch_information_page_get", 
		terminal_state = 0, 
		_ship = self.equipId,
		isPressedActionEnabled = true
	}, nil, 0)
end

function EquipParticulars:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		return
	end
    local csbEquipParticulars = csb.createNode("packs/Fragmentation_info_xx.csb")
    self:addChild(csbEquipParticulars)
	local root = csbEquipParticulars:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function EquipParticulars:onLoad( ... )
	local csbEquipParticulars = csb.createNode("packs/Fragmentation_info_xx.csb")
    self:addChild(csbEquipParticulars)
	local root = csbEquipParticulars:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end


function EquipParticulars:onExit()
	state_machine.remove("equip_patch_information_page_get")
end

function EquipParticulars:init(equipID)
	self.equipId = equipID
end

function EquipParticulars:createCell()
	local cell = EquipParticulars:new()
	cell:registerOnNodeEvent(cell)
	return cell
end