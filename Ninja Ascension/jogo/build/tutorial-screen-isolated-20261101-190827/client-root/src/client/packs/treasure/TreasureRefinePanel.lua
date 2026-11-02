---------------------------------
-- 说明：宝物精炼界面
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureRefinePanel = class("TreasureRefinePanelClass", Window)

function TreasureRefinePanel:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	
	self.currentTreasure = nil			-- 宝物实例
	self.cacheIconPanel = nil			-- 缓存期望精炼道具的底板
	self.cacheNameText = nil			-- 缓存名字显示文本控件
	
	self.cacheAttrTypeList = {}			-- 缓存当前精炼属性类型的文本List
	self.cacheAttrTypeNum = {}			-- 缓存当前精炼属性类型
	self.cacheAttrValueList = {}		-- 缓存当前精炼属性数值的文本List
	self.cacheAttrValueNum = {}			-- 缓存当前精炼属性数值差
	self.cacheNextAttrTypeList = {}		-- 缓存下一级精炼属性类型的文本List
	self.cacheNextAttrValueList = {}	-- 缓存下一级精炼属性数值的文本List
	self.cacheNeedPropList = {}			-- 缓存精炼需求的道具panel
	self.cacheNeedTreasureList = {}		-- 缓存精炼需求的装备panel
	
	-- 进阶需求
	self.needSilver = 0   				-- 需求银币
	self.prop1_count = 0				-- 道具1拥有量
	self.equipment1_count = 0			-- 装备1拥有量
	
	self._string_type = nil
	
	app.load("client.cells.treasure.treasure_icon_cell")
	app.load("client.cells.prop.prop_icon_cell")
	app.load("client.cells.equip.equip_icon_cell")
	app.load("client.cells.utils.property_change_tip_info_cell") 
	app.load("client.packs.hero.HeroPatchInformationPageGetWay")
    -- Initialize HeroSeat state machine.
    local function init_treasure_refine_terminal()
		
		--强制关闭
		local treasure_refine_auto_close_terminal = {
            _name = "treasure_refine_auto_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				fwin:close(instance)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--更新方法封装
		local treasure_refine_update_terminal = {
            _name = "treasure_refine_update",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateRequire()
				instance:onUpdateInfo()
				state_machine.excute("treasure_storage_sell_remove_cell", 0, "event treasure_storage_sell_remove_cell.")
				state_machine.excute("treasure_list_view_del_and_insert_cell", 0, instance.currentTreasure)
				if "strengthen_master" == instance._string_type then
					state_machine.excute("strengthen_master_draw_treasure_refine", 0, "strengthen_master_draw_treasure_refine.")
					state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")			
				end
				
				ccui.Helper:seekWidgetByName(instance.roots[1], "Button_5"):setTouchEnabled(true)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--开始精炼
		local treasure_refine_excute_terminal = {
            _name = "treasure_refine_excute",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local one = instance:onMas(instance.currentTreasure.user_equiment_id)
				local function responseTreatrueCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						pushEffect(formatMusicFile("effect", 9989))
					
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_5"):setTouchEnabled(false)
						state_machine.excute("treasure_storage_update_listview", 0, instance.currentTreasure)
						-- ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_1"):setVisible(true)
						local ArmatureInde = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_1")
						local ArmatureNode_1 = ArmatureInde:getChildByName("ArmatureNode_2")
						local animation = ArmatureNode_1:getAnimation()
						animation:playWithIndex(0, 0, 0)
						self.needSilver = 0   				-- 需求银币
						self.prop1_count = 0				-- 道具1拥有量
						self.equipment1_count = 0			-- 装备1拥有量
						local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
						local str = _string_piece_info[193] .. "  " .. instance.currentTreasure.user_equiment_name .. _string_piece_info[194]
						local textData = {}
						local nameOne = self.cacheAttrTypeNum[1] .. "+"
						local nameTwo = self.cacheAttrTypeNum[2] .. "+"
						local numOne = self.cacheAttrValueNum[1]
						local numTwo = self.cacheAttrValueNum[2]
						
						local two = instance:onMas(instance.currentTreasure.user_equiment_id)
						if two ~= one then
							table.insert(textData, {property = _strengthen_master_info[11], value = two, add = _strengthen_master_info[14] })
						end
						
						table.insert(textData, {property = nameOne, value = numOne})
						table.insert(textData, {property = nameTwo, value = numTwo})

						tipInfo:init(4,str, textData)	
						fwin:open(tipInfo, fwin._view)
					end
				end
				
				local refiningRequire 		= zstring.split(dms.string(dms["equipment_mould"], self.currentTreasure.user_equiment_template, equipment_mould.refining_require_id), ",")
				local currentRankLevel 		= self.currentTreasure.equiment_refine_level    											-- 当前进阶等级
				local currentRankLevelNext 	= self.currentTreasure.equiment_refine_level  +  1  	
				local currentTreasureMould 	= dms.element(dms["equipment_mould"], self.currentTreasure.user_equiment_template)									-- 当前进阶等级 + 1
				local maxRankLevel			= dms.atoi(currentTreasureMould, equipment_mould.refining_max_level)						-- 最大进阶等级
				local rankData 				= dms.element(dms["equipment_rank_link"], zstring.tonumber(refiningRequire[currentRankLevelNext]))		-- 需求配置表
				if zstring.tonumber(currentRankLevel)  == zstring.tonumber(maxRankLevel) then
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						then
						TipDlg.drawTextDailog(_string_piece_info[426])
					else
						TipDlg.drawTextDailog(_string_piece_info[378])
					end
					return
				end
				if self.equipment1_count < dms.atoi(rankData, equipment_rank_link.equipment1_count) then	--所需装备不足
					local equipId = dms.atoi(rankData, equipment_rank_link.need_equipment1)
					local cell = HeroPatchInformationPageGetWay:createCell()
					cell:init(equipId, 1)
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						fwin:open(cell, fwin._ui)
					else
						fwin:open(cell, fwin._view)
					end
					return
				elseif self.prop1_count < dms.atoi(rankData, equipment_rank_link.prop1_count) then	--所需宝物精炼石不足
					local propId = dms.atos(rankData, equipment_rank_link.need_prop1)
					local cell = HeroPatchInformationPageGetWay:createCell()
					cell:init(propId, 2)
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						fwin:open(cell, fwin._ui)
					else
						fwin:open(cell, fwin._view)
					end
					return
				elseif self.needSilver < dms.atoi(rankData, equipment_rank_link.need_silver) then	--金钱不足
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						state_machine.excute("shortcut_function_silver_to_get_open",0,1)
					else
						TipDlg.drawTextDailog(_string_piece_info[127])
					end
					return
				else
					protocol_command.equipment_rank_up.param_list = self.currentTreasure.user_equiment_id
					NetworkManager:register(protocol_command.equipment_rank_up.code, nil, nil, nil, nil, responseTreatrueCallback, false, nil)	
				end
				
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--心法列表图标点击后的刷新
		local treasure_refine_update_of_change_icon_terminal = {
            _name = "treasure_refine_update_of_change_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				instance:onUpdateRequire()
				instance:onUpdateInfo()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		 --红装信息
        local treasure_refine_red_equip_skill_see_terminal = {
            _name = "treasure_refine_red_equip_skill_see",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
 	           	app.load("client.packs.equipment.EquipRedSeeInfo")	
				local cell = EquipRedSeeInfo:new()
				cell:init(instance.currentTreasure)
				fwin:open(cell, fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(treasure_refine_excute_terminal)
		state_machine.add(treasure_refine_update_terminal)
		state_machine.add(treasure_refine_auto_close_terminal)
		state_machine.add(treasure_refine_update_of_change_icon_terminal)
		state_machine.add(treasure_refine_red_equip_skill_see_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_treasure_refine_terminal()
end

function TreasureRefinePanel:onMas(id)
	local grade1 = nil		--装备精炼大师
	local nums = nil
	local shipId = _ED.user_equiment[id].ship_id
	if shipId ~= nil and zstring.tonumber(shipId) > 0 then
		local equips_id = {}
		local ship_equips = _ED.user_ship[shipId].equipment

		for i, v in pairs(ship_equips) do
			if v.user_equiment_id ~= "0" then
				local tempType = zstring.tonumber(v.equipment_type)
				
				if tempType < 4 then
					equips_id[tempType] = v.user_equiment_id
				end
			end	
		end
		local status = true
		for i = 1, 4 do
			if equips_id[i - 1] == nil then
				status = false
			end
		end
		
		if status == true then
			for i, v in pairs(ship_equips) do
				if 4 <i and i<= 6 then
					if grade1 == nil then
						grade1 = zstring.tonumber(v.equiment_refine_level)
					end
					if grade1 ~= nil then								--装备不为空
						if grade1 > zstring.tonumber(v.equiment_refine_level) then
							grade1 = zstring.tonumber(v.equiment_refine_level)
						end
					end
					
				end
			end
			-- table.insert(textData, {property = _strengthen_master_info[10], value = grade1, add = _strengthen_master_info[14] })
		end
		local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 3)
		for i, v in ipairs(strengthen_master_data) do
			local need_level = dms.atoi(v, strengthen_master_info.need_level)
			if grade1 ~= nil then
				if grade1 >= need_level then
					nums = dms.atoi(v, strengthen_master_info.master_level)
				end
			end
		end
	end
	return nums
end

--通过宝物实例 获取对应icon_patch
function TreasureRefinePanel:getIconPath(treasure)
	local mould_id = treasure.user_equiment_template
	local big_icon_index = dms.string(dms["equipment_mould"], mould_id, equipment_mould.All_icon)
	local big_icon_path = string.format("images/ui/big_props/big_props_%s.png", big_icon_index)
	
	local imageView = ccui.ImageView:create()
    imageView:loadTexture(big_icon_path)
	return imageView
end

-- 进阶需求更新
function TreasureRefinePanel:onUpdateRequire()
	-- 进阶需求ID
	local refiningRequire 		= zstring.split(dms.string(dms["equipment_mould"], self.currentTreasure.user_equiment_template, equipment_mould.refining_require_id), ",")
	local currentRankLevel 		= self.currentTreasure.equiment_refine_level    											-- 当前进阶等级
	local currentRankLevelNext 	= self.currentTreasure.equiment_refine_level  +  1  										-- 当前进阶等级 + 1
	local currentTreasureMould 	= dms.element(dms["equipment_mould"], self.currentTreasure.user_equiment_template)	-- 当前装备模板
	local maxRankLevel			= dms.atoi(currentTreasureMould, equipment_mould.refining_max_level)						-- 最大进阶等级
	local rankData 				= dms.element(dms["equipment_rank_link"], zstring.tonumber(refiningRequire[currentRankLevelNext]))		-- 需求配置表
	if zstring.tonumber(currentRankLevel) == zstring.tonumber(maxRankLevel) then
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_25"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_26"):setVisible(false)
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_27"):setVisible(false)
		return
	end
	self.needSilver = dms.atoi(rankData, equipment_rank_link.need_silver)
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_31"):setString(self.needSilver)			-- 银币
	if tonumber(_ED.user_info.user_silver) < tonumber(self.needSilver) then
		ccui.Helper:seekWidgetByName(self.roots[1], "Text_31"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	end
	
	-- 装备的
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		self.equipment1_count = 0
	end
	self.cacheNeedTreasureList[1]:removeAllChildren(true)
	self.cacheNeedTreasureList[2]:setString("")
	self.cacheNeedTreasureList[3]:setString("")
	if dms.atoi(rankData, equipment_rank_link.equipment1_count) > 0 then
		for i, v in pairs(_ED.user_equiment) do
			if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
				or __lua_project_id == __lua_project_pokemon 
				or __lua_project_id == __lua_project_rouge 
				or __lua_project_id == __lua_project_warship_girl_b 
				or __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto
				then 
				if zstring.tonumber(v.user_equiment_template) == dms.atoi(rankData, equipment_rank_link.need_equipment1) 
				and (v.ship_id == "0" or v.ship_id == nil) 
				and (v.user_equiment_id ~= self.currentTreasure.user_equiment_id) and zstring.tonumber(v.user_equiment_grade) == 1 
				and zstring.tonumber(v.equiment_refine_level) == 0 then 
				--强化等级 精炼等级为1
					self.equipment1_count = self.equipment1_count + 1
				end
			else
				if zstring.tonumber(v.user_equiment_template) == dms.atoi(rankData, equipment_rank_link.need_equipment1) 
				and (v.ship_id == "0" or v.ship_id == nil) 
				and (v.user_equiment_id ~= self.currentTreasure.user_equiment_id) then 
					self.equipment1_count = self.equipment1_count + 1
				end
			end
			
		end
		
		local str = self.equipment1_count.."/".. dms.atoi(rankData, equipment_rank_link.equipment1_count)

		local cell = EquipIconCell:createCell()
		cell:init(cell.enum_type._SHOW_EMBOITEMENT_GETWAY, nil, dms.atoi(rankData, equipment_rank_link.need_equipment1))
		self.cacheNeedTreasureList[1]:addChild(cell)
		self.cacheNeedTreasureList[2]:setString(dms.string(dms["equipment_mould"], dms.atoi(rankData, equipment_rank_link.need_equipment1), equipment_mould.equipment_name))
		self.cacheNeedTreasureList[3]:setString(str)
		if self.equipment1_count < dms.atoi(rankData, equipment_rank_link.equipment1_count) then
			self.cacheNeedTreasureList[3]:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
		else
			self.cacheNeedTreasureList[3]:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
		end
	end
	-- 道具的
	local prop1_count = dms.atoi(rankData, equipment_rank_link.prop1_count)
	if prop1_count > 0 then
		for i, v in pairs(_ED.user_prop) do
			if zstring.tonumber(v.user_prop_template) == dms.atoi(rankData, equipment_rank_link.need_prop1) then
				self.prop1_count = zstring.tonumber(v.prop_number)
			end
		end
		
		local str = self.prop1_count.."/".. prop1_count

		local cell = PropIconCell:createCell()
		--> print("dms.atoi(rankData, equipment_rank_link.need_prop1)",dms.atoi(rankData, equipment_rank_link.need_prop1))
		cell:init(10, ""..dms.atoi(rankData, equipment_rank_link.need_prop1))
		self.cacheNeedPropList[1]:addChild(cell)
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	        self.cacheNeedPropList[2]:setString(setThePropsIcon(dms.atoi(rankData, equipment_rank_link.need_prop1))[2])
	    else
	    	self.cacheNeedPropList[2]:setString(dms.string(dms["prop_mould"], dms.atoi(rankData, equipment_rank_link.need_prop1), prop_mould.prop_name))
	    end
		self.cacheNeedPropList[3]:setString(str)
		if self.prop1_count < prop1_count then
			self.cacheNeedPropList[3]:setColor(cc.c3b(color_Type[6][1],color_Type[6][2],color_Type[6][3]))
		else
			self.cacheNeedPropList[3]:setColor(cc.c3b(color_Type[2][1],color_Type[2][2],color_Type[2][3]))
		end
	end
	
end

--红装光效显示设置
function TreasureRefinePanel:setRedVisible(isshow)
	local hong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	if nil ~= hong then
		hong:setVisible(isshow)
	end
end

-- 进阶属性更新
function TreasureRefinePanel:onUpdateInfo()
	local currentTreasureMould 	= dms.element(dms["equipment_mould"], self.currentTreasure.user_equiment_template)	-- 当前装备模板
	local currentRankLevel 		= self.currentTreasure.equiment_refine_level    									-- 当前进阶等级
	local maxRankLevel			= dms.atoi(currentTreasureMould, equipment_mould.refining_max_level)				-- 最大进阶等级
	
	-- 加成属性的填写
	local addParamData 	= zstring.split(dms.atos(currentTreasureMould, equipment_mould.refining_grow_value), "|")
	-- 名称显示 包括品级颜色
	local currentTreasureName = self.currentTreasure.user_equiment_name
	local treasureGrowLevel = dms.int(dms["equipment_mould"], self.currentTreasure.user_equiment_template, equipment_mould.grow_level) + 1
	self.cacheNameText:setString(currentTreasureName)
	self.cacheNameText:setColor(cc.c3b(tipStringInfo_quality_color_Type[treasureGrowLevel][1],tipStringInfo_quality_color_Type[treasureGrowLevel][2],tipStringInfo_quality_color_Type[treasureGrowLevel][3]))

	-- 品阶
	local treasureGrowLevelLable = ccui.Helper:seekWidgetByName(self.roots[1], "Text_32_0")
	treasureGrowLevelLable:setString(currentRankLevel .. _string_piece_info[46])
	
	-- 贴图
	local big_icon_path = self:getIconPath(self.currentTreasure)
	self.cacheIconPanel:removeAllChildren(true)
	self.cacheIconPanel:addChild(big_icon_path)
	for i = 1, #addParamData do
		local addParam = zstring.split(addParamData[i], ",")
		local typeName = _equiprety_name[zstring.tonumber(addParam[1])+1]      --加成属性名称
		local typeIndex = zstring.tonumber(addParam[1]) + 1
		local addPercent = ""
		if typeIndex >= 5 and typeIndex <= 18 then
			addPercent = "%"
		elseif typeIndex >= 34 and typeIndex <= 35 then
			addPercent = "%"
		end
		local refineNum = "+" .. tostring(zstring.tonumber(addParam[2]) * currentRankLevel) .. addPercent				-- 加成值
		self.cacheAttrTypeList[i]:setString(typeName)
		self.cacheAttrValueList[i]:setString(refineNum)
		
		if zstring.tonumber(currentRankLevel) ==zstring.tonumber(maxRankLevel) then
			-- 进阶需求隐藏
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_25"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_26"):setVisible(false)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_27"):setVisible(false)
		else
			-- 进阶需求显示
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_25"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_26"):setVisible(true)
			ccui.Helper:seekWidgetByName(self.roots[1], "Panel_27"):setVisible(true)
			local refineNumAdd = "+" .. tostring(zstring.tonumber(addParam[2]) * (currentRankLevel + 1)) .. addPercent				-- 加成值
			self.cacheNextAttrTypeList[i]:setString(typeName)
			self.cacheNextAttrValueList[i]:setString(refineNumAdd)
			self.cacheAttrTypeNum[i] = typeName
			self.cacheAttrValueNum[i] = zstring.tonumber(addParam[2]) * (currentRankLevel + 1) - zstring.tonumber(addParam[2]) * currentRankLevel
		end
	end
	

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local lv =ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lv")
		local lan=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_lan")
		local zi=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_zi")
		local cheng=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_cheng")
		lv:setVisible(false)
		lan:setVisible(false)
		zi:setVisible(false)
		cheng:setVisible(false)
		self:setRedVisible(false)
		if treasureGrowLevel == 2 then
			lv:setVisible(true)
		elseif treasureGrowLevel == 3 then
			lan:setVisible(true)
		elseif treasureGrowLevel == 4 then
			zi:setVisible(true)
		elseif treasureGrowLevel == 5 then
			cheng:setVisible(true)
		elseif treasureGrowLevel == 6 then
		 	self:setRedVisible(true)
		end
	end
	local Button_jn = ccui.Helper:seekWidgetByName(self.roots[1], "Button_jn")
	local quality = dms.int(dms["equipment_mould"], self.currentTreasure.user_equiment_template, equipment_mould.grow_level)
	if Button_jn ~= nil then 
		if quality == 5 then
			Button_jn:setVisible(true)
		else
			Button_jn:setVisible(false)
		end
	end
end

function TreasureRefinePanel:onEnterTransitionFinish()
    local csbTreasureRefine = csb.createNode("packs/TreasureStorage/treasure_strengthen_2.csb")
	local root = csbTreasureRefine:getChildByName("root")
	root:removeFromParent(true)
    self:addChild(root)
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		local action1 = csb.createTimeline("packs/TreasureStorage/treasure_strengthen_2.csb")
		self:runAction(action1)
		action1:play("tubiao_ing", true)

		if self._string_type == "formation" then
			state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
		end
	else
		if self._string_type == "formation" then
			app.load("client.player.EquipPlayerInfomation")
			if fwin:find("EquipPlayerInfomationClass") == nil then
				fwin:open(EquipPlayerInfomation:new(),fwin._windows)
			end
			state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
		end
	end
	--开始精炼
	local treasure_refine_excute_button = ccui.Helper:seekWidgetByName(root, "Button_5")
	fwin:addTouchEventListener(treasure_refine_excute_button, nil, 
	{
		terminal_name = "treasure_refine_excute", 
		next_terminal_name = "", 
		but_image = "", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)

	--红装按钮显示隐藏
	local Button_jn = ccui.Helper:seekWidgetByName(root, "Button_jn")
	local quality = dms.int(dms["equipment_mould"], self.currentTreasure.user_equiment_template, equipment_mould.grow_level)
	if Button_jn ~= nil then 
		if quality == 5 then 
			Button_jn:setVisible(true)
		else
			Button_jn:setVisible(false)
		end
		fwin:addTouchEventListener(Button_jn, nil,
		{
			terminal_name = "treasure_refine_red_equip_skill_see", 
			cell = self
		}, nil, 0)
	end
	
	--缓存期望精炼道具的panel
	local iconPanel = ccui.Helper:seekWidgetByName(root, "Panel_3")
	self.cacheIconPanel = iconPanel
	
	--名字显示
	local nameText = ccui.Helper:seekWidgetByName(root, "Text_1")
	self.cacheNameText = nameText
	
	--当前当前级别基础属性类型显示文本
	self.cacheAttrTypeList = { 
	ccui.Helper:seekWidgetByName(root, "Text_7"), 
	ccui.Helper:seekWidgetByName(root, "Text_8") }
	
	--当前当前级别基础属性数值显示文本
	self.cacheAttrValueList = { 
	ccui.Helper:seekWidgetByName(root, "Text_7_0_1"), 
	ccui.Helper:seekWidgetByName(root, "Text_7_0") }
	for i=1,2 do
		self.cacheAttrValueList[i]:setString("")
		self.cacheAttrTypeList[i]:setString("")
	end
	
	--下一级属性类型显示文本
	self.cacheNextAttrTypeList = { 
	ccui.Helper:seekWidgetByName(root, "Text_7_2"), 
	ccui.Helper:seekWidgetByName(root, "Text_8_1") }
	
	--下一级属性数值显示文本
	self.cacheNextAttrValueList = { 
	ccui.Helper:seekWidgetByName(root, "Text_7_0_1_0"), 
	ccui.Helper:seekWidgetByName(root, "Text_7_0_2") }

	--进阶需求道具  1.图标位子  2.名称   3.需求量
	self.cacheNeedPropList = { 
	ccui.Helper:seekWidgetByName(root, "Panel_5"), 
	ccui.Helper:seekWidgetByName(root, "Text_27"), 
	ccui.Helper:seekWidgetByName(root, "Text_27_0_0") }

	--进阶需求宝物  1.图标位子  2.名称   3.需求量
	self.cacheNeedTreasureList = { 
	ccui.Helper:seekWidgetByName(root, "Panel_5_0"), 
	ccui.Helper:seekWidgetByName(root, "Text_27_0"), 
	ccui.Helper:seekWidgetByName(root, "Text_27_0_0_0") }
	self:onUpdateInfo()
	self:onUpdateRequire()
end


function TreasureRefinePanel:onExit()
	state_machine.remove("treasure_refine_auto_close")
	state_machine.remove("treasure_refine_excute")
	state_machine.remove("treasure_refine_update")
	state_machine.remove("treasure_refine_update_of_change_icon")
	state_machine.remove("treasure_refine_red_equip_skill_see")
end

function TreasureRefinePanel:close( ... )
	if self._string_type == "formation" then
		if fwin:find("EquipPlayerInfomationClass") ~= nil then
			fwin:close(fwin:find("EquipPlayerInfomationClass"))
		end
	end
end

function TreasureRefinePanel:init(currentTreasure, _string_type)
	self.currentTreasure = currentTreasure
	self._string_type = _string_type
end