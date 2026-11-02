-- ----------------------------------------------------------------------------------------------------
-- 说明：宝物详情界面
-- 创建时间
-- 作者：
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------

EquipParticularsTwo = class("EquipParticularsTwoClass", Window)
   
function EquipParticularsTwo:ctor()
    self.super:ctor()
	self.roots = {}
	self.equipId = nil
	app.load("client.cells.npc.plot_npc_cell")
    -- Initialize Home page state machine.
	local function init_equip_information_teo_terminal()
		--去获取
		local equip_patch_information_page_get_two_terminal = {
            _name = "equip_patch_information_page_get_two",
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
		state_machine.add(equip_patch_information_page_get_two_terminal)
    end
    
    init_equip_information_teo_terminal()
end

function EquipParticularsTwo:onUpdateDraw()
	local root = self.roots[1]
	
	--名字
	local heraData=dms.string(dms["equipment_mould"],self.equipId,equipment_mould.equipment_name)
	local equTextName = ccui.Helper:seekWidgetByName(root, "Text_2")
	equTextName:setString(heraData)
	
	local propType = dms.int(dms["equipment_mould"],self.equipId,equipment_mould.grow_level)+1
	equTextName:setColor(cc.c4b(color_Type[propType][1],color_Type[propType][2],color_Type[propType][3],255))
	--类型
	local TypeCurrent = tonumber(dms.string(dms["equipment_mould"],self.equipId,equipment_mould.equipment_type)) 
	--装备类型：0武器	1头盔	2项链	3盔甲	4战马	5兵书	
	local equPanelType= ccui.Helper:seekWidgetByName(root, "Panel_21_9")
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
	local equPanelCard= ccui.Helper:seekWidgetByName(root, "Panel_juese_5")
	local equipIcon = nil
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_pokemon
		then
		--修改图片路径
		local big_picindex = dms.int(dms["equipment_mould"],self.equipId,equipment_mould.All_icon)
		equipIcon = string.format("images/ui/big_props/big_props_%s.png",big_picindex)
	else
		equipIcon = string.format("images/ui/big_props/big_props_%s.png",self.equipId)
	end
	equPanelCard:setBackGroundImage(equipIcon)
	
	--基础属性
	local equQualityName = ccui.Helper:seekWidgetByName(root, "Text_4_6")
	local equQualityCount = ccui.Helper:seekWidgetByName(root, "Text_5_8")
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

			if _pType >= 4 and _pType <= 17 then
				_pValue = _pValue .."%"
			end
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
	local upgradeName = ccui.Helper:seekWidgetByName(root, "Text_6_10")
	local upgradeCount = ccui.Helper:seekWidgetByName(root, "Text_7_12")
	local everyLevel = dms.string(dms["equipment_mould"],self.equipId,equipment_mould.grow_value)
	local everyLevelAdd = zstring.split(everyLevel,"|")
	for i,v in pairs(everyLevelAdd) do
		local influenceType = zstring.split(v,",")		--每一种属性
		if table.getn(influenceType) >= 2 then
			local _pType = tonumber(influenceType[1])
			local _pValue = influenceType[2]

			if _pType >= 4 and _pType <= 17 then
				_pValue = _pValue .."%"
			end
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
	
	--简介内容
	local describeCount = ccui.Helper:seekWidgetByName(root, "Text_19_34")
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
	
	fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Button_go_4"), nil, 
	{
		terminal_name = "equip_patch_information_page_get_two", 
		terminal_state = 0, 
		_ship = self.equipId,
		isPressedActionEnabled = true
	}, nil, 0)

end

function EquipParticularsTwo:onEnterTransitionFinish()
	if __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		return
	end
    local csbEquipParticularsTwo = csb.createNode("packs/Fragmentation_info_bw_xx.csb")
    self:addChild(csbEquipParticularsTwo)
	local root = csbEquipParticularsTwo:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end

function EquipParticularsTwo:onLoad( ... )
	local csbEquipParticularsTwo = csb.createNode("packs/Fragmentation_info_bw_xx.csb")
    self:addChild(csbEquipParticularsTwo)
	local root = csbEquipParticularsTwo:getChildByName("root")
	table.insert(self.roots, root)
	
	self:onUpdateDraw()
end


function EquipParticularsTwo:onExit()
	state_machine.remove("equip_patch_information_page_get_two")
end

function EquipParticularsTwo:init(equipID)
	self.equipId = equipID
end

function EquipParticularsTwo:createCell()
	local cell = EquipParticularsTwo:new()
	cell:registerOnNodeEvent(cell)
	return cell
end