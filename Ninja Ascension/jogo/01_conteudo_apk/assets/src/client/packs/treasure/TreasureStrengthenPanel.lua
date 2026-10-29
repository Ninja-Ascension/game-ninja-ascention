---------------------------------
-- 说明：宝物强化界面
-- 创建时间:2015.03.16
-- 作者：刘迎
-- 修改记录：
-- 最后修改人：
---------------------------------

TreasureStrengthenPanel = class("TreasureStrengthenPanelClass", Window)

function TreasureStrengthenPanel:ctor()
    self.super:ctor()
	
	-- 定义封装类中的变量
	self.roots = {}					-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.currentTreasure = nil		-- 宝物实例 由外部传参
	self.treasureAttributeName = {}  -- 1.当前等级   	2.当前经验		3.经验上限	4.加成属性一    5.加成属性二    
	self.treasureAttribute = {}  -- 1.当前等级   	2.当前经验		3.经验上限	4.加成属性一    5.加成属性二    
	self.treasureAttributeAdd = {}  -- 1.可加等级   2.可加经验经验（同时也是消耗的银币） 3.经验上限    4.加成属性一    5.加成属性二	
	self.treasureAttributeAdd[2] = 0 --经验值初始化
	self.materialButton = {}		-- 保存材料选择的+号按钮
	self.material = {}
	self.materialIconList = {}		-- 保存材料Icon的显示层的List  6号位为被强化宝物位子
	
	self.selectedMaterialList = {}	-- 已选择的材料实例数组 最高5个咩
	self.currentTreasureInit = false	--宝物信息是否初始化
	self.action = nil
	self._string_type = nil
	self.qianghuadonghua=nil
	self.Armature_baowuqianghua=nil
	self.Armature_qianghuaResult= nil --强化成功动画
	self.isSure = false
		app.load("client.cells.utils.property_change_tip_info_cell") 
	app.load("client.packs.treasure.TreasureMaterialSelectPanel")
    -- Initialize HeroSeat state machine.
    local function init_treasure_strengthen_terminal()
		
		--强制show
		local treasure_strengthen_page_treasure_auto_insert_terminal = {
            _name = "treasure_strengthen_page_treasure_auto_insert",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
                ---------------------满级提示yyyy
				if instance:isMaxGrade() then
					TipDlg.drawTextDailog(_string_piece_info[344])
					return
				end
				--------------------
				local dTreasureArray={}
				local pIndex = 1
				
				--得到宝物数组
				for i, trInfo in pairs(_ED.user_equiment) do
				
					if tonumber(trInfo.equipment_type) > 3  and tonumber(trInfo.equipment_type) < 6 and tonumber(trInfo.ship_id) == 0 
					
					or tonumber(trInfo.equipment_type) == 8 then
					
						--判断一下 因为紫色是不允许被自动选择的
						local grow = dms.int(dms["equipment_mould"], tonumber(trInfo.user_equiment_template), equipment_mould.grow_level)
						if grow < 3 or tonumber(trInfo.user_equiment_template) == 51 then
							if tonumber(self.currentTreasure.user_equiment_id) ~= tonumber(trInfo.user_equiment_id) then
								dTreasureArray[pIndex] = trInfo
								pIndex = pIndex + 1
							end
						end
						
					end
					
				end
				--进行冒泡排序 取得品质最低的5个宝物
				local userTrSortFunc = function(a,b)
					-- 获取品级
					local ar = dms.int(dms["equipment_mould"], tonumber(a.user_equiment_template), equipment_mould.rank_level)	
					local br = dms.int(dms["equipment_mould"], tonumber(b.user_equiment_template), equipment_mould.rank_level)
					
					local result = false
					
					if ar < br then
						result = true
					end
					
					return result 
				end
				
				--开始排序
				table.sort(dTreasureArray, userTrSortFunc)			
				--刷新材料模块
				self.selectedMaterialList = 
				{
					dTreasureArray[1],
					dTreasureArray[2],
					dTreasureArray[3],
					dTreasureArray[4],
					dTreasureArray[5]
				}
				
				if dTreasureArray[1] == nil then
					TipDlg.drawTextDailog(_string_piece_info[166])
				else
					self:onUpdateNewTreasure()
					self:onUpdateDraw()
				end
				--刷新
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--从材料界面过来的事件 并且需要刷新已选材料区
		local treasure_strengthen_from_material_terminal = {
            _name = "treasure_strengthen_from_material",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
				--刷新材料模块
				self.selectedMaterialList = params._datas.selected
				if #self.selectedMaterialList > 0 then 
					self:onUpdateNewTreasure()
					self:onUpdateDraw()
				else

				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--显示材料界面
		local treasure_strengthen_show_material_terminal = {
            _name = "treasure_strengthen_show_material",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params) 
            	---------------------满级提示yyyy
				if instance:isMaxGrade() then
					TipDlg.drawTextDailog(_string_piece_info[344])
					return
				end
				--------------------
				--刷新材料模块
				local newPage = TreasureMaterialSelectPanel:new()
				newPage:init(self.selectedMaterialList, self.currentTreasure)
				fwin:open(newPage, fwin._windows)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--强化
		local treasure_strengthen_true_terminal = {
            _name = "treasure_strengthen_true",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				--服务器返回
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					state_machine.lock("treasure_strengthen_true")
					state_machine.lock("treasure_strengthen_show_material")
				end
				local levelOne = tonumber(self.currentTreasure.user_equiment_grade)
				
				local function responseTreatrueCallback(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							if instance == nil or instance.roots == nil then
								state_machine.unlock("treasure_strengthen_true")
								state_machine.unlock("treasure_strengthen_show_material")
								return
							end
							instance.qianghuadonghua:setVisible(true)
							csb.animationChangeToAction(instance.Armature_baowuqianghua, 0, 0, nil)
						end

						if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
							or __lua_project_id == __lua_project_pokemon 
							or __lua_project_id == __lua_project_rouge 
							or __lua_project_id == __lua_project_yugioh 
							or __lua_project_id == __lua_project_warship_girl_b 
							then 
							instance.Armature_qianghuaResult:setVisible(true)
                            csb.animationChangeToAction(instance.Armature_qianghuaResult, 0, 0, false)
                            instance.Armature_qianghuaResult ._invoke = function(armatureBack)
                                instance.Armature_qianghuaResult:setVisible(false)
                            end
						end
						pushEffect(formatMusicFile("effect", 9991))
					
						ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1"):setTouchEnabled(false)
						state_machine.excute("treasure_storage_sell_remove_cell", 0, "event treasure_storage_sell_remove_cell.")
						state_machine.excute("treasure_storage_update_listview", 0, instance.currentTreasure)
						state_machine.excute("treasure_list_view_del_and_insert_cell", 0, instance.currentTreasure)
						state_machine.excute("treasure_icon_listview_update_listview",0,instance.currentTreasure)
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.excute("treasure_icon_list_view_remove_cell", 0, instance.selectedMaterialList)	
						end
						local action = csb.createTimeline("packs/TreasureStorage/treasure_strengthen_1.csb")
						action:play("treasure_add", false)
						instance.roots[1]:runAction(action)
						action:setFrameEventCallFunc(function (frame)
						if nil == frame then
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								state_machine.unlock("treasure_strengthen_true")
								state_machine.unlock("treasure_strengthen_show_material")
							end
							return
						end
						local str = frame:getEvent()
						
						if str == "play_add_over" then
							local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
							local str = ""
							local textData = {}
							local levelTwo = tonumber(self.currentTreasure.user_equiment_grade)
							if levelTwo - levelOne > 0 then
								table.insert(textData, {property = _string_piece_info[340], value = levelTwo })
								table.insert(textData, {property = self.treasureAttributeName[4], value = self.treasureAttributeAdd[4]})
								table.insert(textData, {property = self.treasureAttributeName[5], value = self.treasureAttributeAdd[5]})
							else
								table.insert(textData, {property = _string_piece_info[339], value = self.treasureAttributeAdd[2]})
							end
							
							tipInfo:init(8,str, textData)	
							
							fwin:open(tipInfo, fwin._view)
							self.selectedMaterialList = {}	-- 已选择的材料实例数组 最高5个咩
							instance:onUpdateNewTreasure()
							instance:onUpdateDraw()
							instance:onUpdateClean()
							if "strengthen_master" == instance._string_type then
								state_machine.excute("strengthen_master_draw_treasure_strengthen", 0, "strengthen_master_draw_treasure_strengthen.")
								state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")		
							end
							ccui.Helper:seekWidgetByName(instance.roots[1], "Button_1"):setTouchEnabled(true)
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								state_machine.unlock("treasure_strengthen_true")
								state_machine.unlock("treasure_strengthen_show_material")
							end
						end
						if __lua_project_id == __lua_project_gragon_tiger_gate
							or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
							or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
							or __lua_project_id == __lua_project_red_alert 
							then
							state_machine.unlock("treasure_strengthen_true")
							state_machine.unlock("treasure_strengthen_show_material")
						end
						if __lua_project_id == __lua_project_yugioh then
							instance:onUpdateDraw()
						end
						end)
						
					else
						state_machine.unlock("treasure_strengthen_show_material")  --yyyy
					end
				end
				
				--拼接字符串
				local temp = nil
				for i, v in pairs(self.selectedMaterialList) do
					if i == 1 then
						temp = v.user_equiment_id
					else
						temp = temp .. "," .. v.user_equiment_id
					end
				end
				if temp == nil then	
					TipDlg.drawTextDailog(_string_piece_info[208])
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						state_machine.unlock("treasure_strengthen_true")
						state_machine.unlock("treasure_strengthen_show_material")
					end
					return
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					if tonumber(_ED.user_info.user_silver) < tonumber(instance.treasureAttributeAdd[2]) then
						state_machine.excute("shortcut_function_silver_to_get_open",0,1)
						return
					end

					for i,v in pairs(self.selectedMaterialList) do
						local quality = dms.int(dms["equipment_mould"],v.user_equiment_template,equipment_mould.grow_level) + 1
						local equipment_type = dms.int(dms["equipment_mould"],v.user_equiment_template,equipment_mould.equipment_type)
						if tonumber(quality) > 3 and tonumber(equipment_type) ~= 8 and self.isSure == false then
							app.load("client.utils.ConfirmTip")
							if __lua_project_id == __lua_project_gragon_tiger_gate
								or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
								or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
								or __lua_project_id == __lua_project_red_alert 
								then
								state_machine.unlock("treasure_strengthen_true")
								state_machine.unlock("treasure_strengthen_show_material")
							end
							local tip = ConfirmTip:new()
							tip:init(instance,instance.sureToStreng,_string_piece_info[386])
							fwin:open(tip,fwin._windows)
							return
						end
					end
				end
				if __lua_project_id == __lua_project_gragon_tiger_gate
					or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
					or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
					or __lua_project_id == __lua_project_red_alert 
					then
					self.isSure = false
				end
				self.action:play("treasure_jindu_sansuo", false)
				protocol_command.treasure_escalate.param_list = self.currentTreasure.user_equiment_id .. "\r\n" .. temp
				NetworkManager:register(protocol_command.treasure_escalate.code, nil, nil, nil, nil, responseTreatrueCallback, false, nil)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		--取消一个升级材料的选择
		local treasure_resolve_cancel_one_terminal = {
            _name = "treasure_resolve_cancel_one",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local _equiment_id = params._datas._equiment_id
				local pos = nil
				local EquipInfotable = {}
				for i, v in pairs(instance.selectedMaterialList) do
					if v.user_equiment_id ~= _equiment_id then
						table.insert(EquipInfotable, v)
					end
				end
				
				instance.selectedMaterialList = {}
				for i, v in pairs(EquipInfotable) do
					table.insert(instance.selectedMaterialList, v)
					if #instance.selectedMaterialList == 5 then
						break
					end	
				end			
				instance:onUpdateNewTreasure()
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--从材料界面过来的事件 并且需要刷新已选材料区
		local treasure_strengthen_update_of_change_icon_terminal = {
            _name = "treasure_strengthen_update_of_change_icon",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	instance.selectedMaterialList = {}
				instance:onUpdateNewTreasure()
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
        --列表切换宝物刷新
        local treasure_refine_change_strengthen_update_terminal = {
            _name = "treasure_refine_change_strengthen_update",
            _init = function (terminal) 
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				instance:onUpdateDraw()	
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(treasure_strengthen_page_treasure_auto_insert_terminal)
		state_machine.add(treasure_strengthen_from_material_terminal)
		state_machine.add(treasure_strengthen_show_material_terminal)
		state_machine.add(treasure_strengthen_true_terminal)
		state_machine.add(treasure_resolve_cancel_one_terminal)
		state_machine.add(treasure_strengthen_update_of_change_icon_terminal)
		state_machine.add(treasure_refine_change_strengthen_update_terminal)
        state_machine.init()
    end
	
    -- call func init hom state machine.
    init_treasure_strengthen_terminal()
end
function TreasureStrengthenPanel:sureToStreng(sure_number)
	if sure_number == 0 then
		self.isSure = true
		state_machine.excute("treasure_strengthen_true",0,
			{
			_datas={
					terminal_name = "treasure_strengthen_true", 
					next_terminal_name = "", 
					but_image = "Button_1", 	
					terminal_state = 0, 
					isPressedActionEnabled = true
				}
			})
	end
end

function TreasureStrengthenPanel:isMaxGrade()  --yyyy
	local treasureType = dms.int(dms["equipment_mould"], tonumber(self.currentTreasure.user_equiment_template), equipment_mould.grow_level)
	local nextGradeNeedsExperience =  dms.int(dms["treasure_experience_param"], tonumber(self.currentTreasure.user_equiment_grade) + 1, treasureType+2)
	if nextGradeNeedsExperience == -1 then
		return true
	end
	return false
end

function TreasureStrengthenPanel:onMas(id)
	local grade1 = nil		--装备精炼大师
	local nums = nil
	local shipId = _ED.user_equiment[id].ship_id
	if shipId ~= nil and tonumber(shipId) > 0 then
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
				if i > 4 and i <= 6 then
					if grade1 == nil then
						grade1 = tonumber(v.user_equiment_grade)
					end
					if grade1 > tonumber(v.user_equiment_grade) then
						grade1 = tonumber(v.user_equiment_grade)
					end
					
				end
			end
			-- table.insert(textData, {property = _strengthen_master_info[10], value = grade1, add = _strengthen_master_info[14] })
		end
		local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 2)
		for i, v in ipairs(strengthen_master_data) do
			local need_level = dms.atoi(v, strengthen_master_info.need_level)
			if grade1 >= need_level then
				nums = dms.atoi(v, strengthen_master_info.master_level)
			end
		end
	end
	return nums
end

--通过宝物实例 获取对应icon_patch
function TreasureStrengthenPanel:getIconPath(treasure, typeNum)
	local csbTreasureStrengthen = csb.createNode("icon/item.csb")
	local root = csbTreasureStrengthen:getChildByName("root")
	root:removeFromParent(true)
	local Panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	local Panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	
	local mould_id = treasure.user_equiment_template
	local big_icon_index = dms.int(dms["equipment_mould"], mould_id, equipment_mould.All_icon)
	local quality = dms.int(dms["equipment_mould"], mould_id, equipment_mould.grow_level) + 1
	local big_icon_path = nil
	if typeNum == 1 then
		if big_icon_index < 10 then
			big_icon_index = "200"..big_icon_index
		elseif big_icon_index < 100 then
			big_icon_index = "20"..big_icon_index
		elseif big_icon_index < 1000 then
			big_icon_index = "2"..big_icon_index
		end
		big_icon_path = string.format("images/ui/props/props_%s.png", big_icon_index)
		quality_path = string.format("images/ui/quality/icon_enemy_%d.png", quality)
		Panel_ditu:setBackGroundImage(big_icon_path)
		Panel_kuang:setBackGroundImage(quality_path)
		
		fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Panel_prop"), nil, 
		{
			terminal_name = "treasure_strengthen_show_material", 	
			terminal_state = 0,
		}, 
		nil, 0)
		return root
	elseif typeNum == 2 then
		big_icon_path = string.format("images/ui/big_props/big_props_%s.png", big_icon_index)
		local imageView = ccui.ImageView:create()
		imageView:loadTexture(big_icon_path)
		return imageView
	end
		
end

-- 获取宝物属性
function TreasureStrengthenPanel:getAttribute()
	local valueList = zstring.split(self.currentTreasure.user_equiment_ability, "|")
	--> print("self.currentTreasure.user_equiment_ability", self.currentTreasure.user_equiment_ability)
	for i, v in pairs(valueList) do
		local attributeList = zstring.split(v, ",")
		local typeIndex = tonumber(attributeList[1]) + 1
		self.treasureAttribute[i + 3] = attributeList[2]
		
		--判断是否追加百分比符号
		local addName = string_equiprety_name[typeIndex]
		local addPercent = ""
		if typeIndex >= 5 and typeIndex <= 18 then
			addPercent = "%"
		elseif typeIndex >= 34 and typeIndex <= 35 then
			addPercent = "%"
		end
		--显示数据
		self.treasureAttribute[i + 3] = string.format("%.1f",self.treasureAttribute[i + 3])..addPercent
		self.treasureAttributeName[i + 3] = addName

		if (i >= 2) then break end
	end
end

-- 计算加成属性 并添值
function TreasureStrengthenPanel:onUpdateNewTreasure()
	self.treasureAttributeAdd[2] = 0				-- 可加经验

	for i = 1, 5 do
		if self.materialIconList[i]:getChildByTag(1000) ~= nil then
			self.materialIconList[i]:removeChildByTag(1000)
			self.material[i]:getChildByName("ArmatureNode_"..24+i):setVisible(true)
		end
		-- self.materialButton[i]:setVisible(true)
	end
	for i,v in pairs(self.selectedMaterialList) do
		--> print("num", i, "name", v.user_equiment_name,i)		
		if v ~= nil then
			self.treasureAttributeAdd[2] = self.treasureAttributeAdd[2] + getOfferOfTreasureExp(v.user_equiment_id)
			-- local big_icon_path = self:getIconPath(v,1)
			local mould_id = v.user_equiment_template
			local big_icon_index = dms.int(dms["equipment_mould"], mould_id, equipment_mould.All_icon)
			-- if big_icon_index < 10 then
				-- big_icon_index = "200"..big_icon_index
			-- elseif big_icon_index < 100 then
				-- big_icon_index = "20"..big_icon_index
			-- elseif big_icon_index < 1000 then
				-- big_icon_index = "2"..big_icon_index
			-- end
			-- big_icon_path = string.format("images/ui/big_props/big_props_%s.png", big_icon_index)
			-- self.materialIconList[i]:setBackGroundImage(big_icon_path)
			local equipCell = TreasureRefineryIcon:createCell()
			equipCell:init(3, v.user_equiment_template, v.user_equiment_id)
			self.materialIconList[i]:addChild(equipCell)
			equipCell:setTag(1000)
			
			
			fwin:addTouchEventListener(self.materialIconList[i], nil, 
			{
				terminal_name = "treasure_strengthen_show_material", 	
				terminal_state = 0,
			}, 
			nil, 0)
			
			-- big_icon_path:setAnchorPoint(cc.p(0, 0))
			self.materialIconList[i]:setVisible(true)
			-- self.materialButton[i]:setVisible(false)
			self.material[i]:getChildByName("ArmatureNode_"..24+i):setVisible(false)
		else
			-- self.materialButton[i]:setVisible(true)
			self.material[i]:getChildByName("ArmatureNode_"..24+i):setVisible(true)
			self.materialIconList[i]:setVisible(false)
		end
		if i == 5 then
			break
		end
	end
	
	self.treasureAttributeAdd[1] = getTreasureUpLevel(self.currentTreasure, self.treasureAttributeAdd[2], 0)
	local grow_value = dms.string(dms["equipment_mould"], tonumber(self.currentTreasure.user_equiment_template), equipment_mould.grow_value)

	local grow_value_num = zstring.split(grow_value, "|")
	for i, delivate in pairs(grow_value_num) do
		local attributeList = zstring.split(delivate, ",")
		self.treasureAttributeAdd[i + 3] = attributeList[2] * self.treasureAttributeAdd[1]

		local typeIndex = tonumber(attributeList[1]) + 1
		local addPercent = ""
		if typeIndex >= 5 and typeIndex <= 18 then
			addPercent = "%"
		elseif typeIndex >= 34 and typeIndex <= 35 then
			addPercent = "%"
		end
		
		self.treasureAttributeAdd[i + 3] = string.format("%.1f",self.treasureAttributeAdd[i + 3]) ..  addPercent
		if (i == 2) then
			break 
		end
	end
	
	local Text_2_0 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_2_0")			--等级
	local Text_5 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_5")				--属性一
	local Text_5_0 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_5_0")			--属性二
	local Text_3 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_3")				--消耗的金钱
	Text_2_0:setString("")
	Text_5:setString("")
	Text_5_0:setString("")
	Text_3:setString("0")
	--> print("********************************", self.treasureAttributeAdd[4])	
	if tonumber(self.treasureAttributeAdd[4]) ~= 0 then
		Text_2_0:setString("+" .. self.treasureAttributeAdd[1])
		
		Text_5:setString("+" .. self.treasureAttributeAdd[4])
		if self.treasureAttributeAdd[5] ~= nil then
			Text_5_0:setString("+" .. self.treasureAttributeAdd[5])	
		end
	end
	--消耗金币不需要self.treasureAttributeAdd[4] 判断
	Text_3:setString(self.treasureAttributeAdd[2])
	if tonumber(_ED.user_info.user_silver) < tonumber(self.treasureAttributeAdd[2]) then
		Text_3:setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	end
end

function TreasureStrengthenPanel:onUpdateClean()
	local Text_2_0 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_2_0")			--等级
	local Text_5 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_5")				--属性一
	local Text_5_0 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_5_0")			--属性二
	local Text_3 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_3")				--消耗的金钱
	
	Text_2_0:setString("")
	Text_5:setString("")
	Text_5_0:setString("")
	Text_3:setString("0")
end

--红装光效显示设置
function TreasureStrengthenPanel:setRedVisible(isshow)
	local hong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	if nil ~= hong then
		hong:setVisible(isshow)
	end
end

--更新文字属性信息
function TreasureStrengthenPanel:onUpdateDraw()
	local treasureType = dms.int(dms["equipment_mould"], tonumber(self.currentTreasure.user_equiment_template), equipment_mould.grow_level)
	--信息初始化
	if self.currentTreasureInit ~= true then
		self.treasureAttribute[1] = self.currentTreasure.user_equiment_grade
		self.treasureAttribute[2] = self.currentTreasure.user_equiment_exprience
		self.treasureAttribute[3] = dms.int(dms["treasure_experience_param"], tonumber(self.currentTreasure.user_equiment_grade) + 1, treasureType+2)
		
		self:getAttribute()
		-- self.currentTreasureInit = true
	end
	-- 获取控件
	local Text_2 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_2")			--等级
	local Text_2_exp 	= ccui.Helper:seekWidgetByName(self.roots[1], "Text_2_exp")		--经验
	local Text_4 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_4")  		-- 属性一
	local Text_6 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_6")  		-- 属性一
	local Text_4_0 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_4_0")  		-- 属性一
	local Text_6_0 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_6_0")  		-- 属性一
	local LoadingBar_1_2 	= ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1_2")  	-- 经验条
	local LoadingBar_1 	= ccui.Helper:seekWidgetByName(self.roots[1], "LoadingBar_1")  	-- 经验条
	local Text_1 		= ccui.Helper:seekWidgetByName(self.roots[1], "Text_1")  	-- 名称
	
	-- 填值
	if verifySupportLanguage(_lua_release_language_en) == true then
		Text_2:setString(_string_piece_info[6]..self.treasureAttribute[1])
	else
		Text_2:setString(self.treasureAttribute[1].._string_piece_info[6])
	end
	Text_2_exp:setString(zstring.tonumber(self.treasureAttribute[2]) + zstring.tonumber(self.treasureAttributeAdd[2]) .. "/" .. self.treasureAttribute[3])
	if zstring.tonumber(self.treasureAttribute[3]) == -1 then 
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_yugioh 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			or __lua_project_id == __lua_project_warship_girl_b 
			or __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  --yyyy
		 	then 
			--满级显示
			Text_2_exp:setString(_string_piece_info[344])
		end
	end
	LoadingBar_1_2:setPercent((zstring.tonumber(self.treasureAttribute[2]) + zstring.tonumber(self.treasureAttributeAdd[2])) / zstring.tonumber(self.treasureAttribute[3]) * 100)
	LoadingBar_1:setPercent(zstring.tonumber(self.treasureAttribute[2] ) / zstring.tonumber(self.treasureAttribute[3]) * 100)
	self.action:play("treasure_jindu_sansuo", true)
	Text_6:setString(math.floor(self.treasureAttribute[4]))
	Text_4:setString(self.treasureAttributeName[4])
	if self.treasureAttribute[5] ~= nil then
		Text_4_0:setString(self.treasureAttributeName[5])	
		Text_6_0:setString(self.treasureAttribute[5])	
	end
	-- 宝物名称
	Text_1:setString(self.currentTreasure.user_equiment_name)
	local treatureType = dms.int(dms["equipment_mould"], tonumber(self.currentTreasure.user_equiment_template), equipment_mould.grow_level) + 1
	Text_1:setColor(cc.c3b(tipStringInfo_quality_color_Type[treatureType][1],tipStringInfo_quality_color_Type[treatureType][2],tipStringInfo_quality_color_Type[treatureType][3]))
	-- 宝物图片

	local mould_id = self.currentTreasure.user_equiment_template
	local big_icon_index = dms.int(dms["equipment_mould"], mould_id, equipment_mould.All_icon)
	local big_icon_path = string.format("images/ui/big_props/big_props_%s.png", big_icon_index)
	self.materialIconList[6]:setBackGroundImage(big_icon_path)
	self.materialIconList[6]:setVisible(true)

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
		if treatureType == 1 then							--白色	
		elseif treatureType == 2 then
			lv:setVisible(true)
		elseif treatureType == 3 then
			lan:setVisible(true)
		elseif treatureType == 4 then
			zi:setVisible(true)
		elseif treatureType == 5 then
			cheng:setVisible(true)
		elseif treatureType == 6 then
		 	self:setRedVisible(true)		
		end
	end
	
end

--流程处理
function TreasureStrengthenPanel:onEnterTransitionFinish()
	-- if __lua_project_id == __lua_project_gragon_tiger_gate
	-- 	or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
	-- 	or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
	-- 	or __lua_project_id == __lua_project_red_alert 
	-- 	then
	--     local effect_paths = "images/ui/effice/effect_16/effect_16.ExportJson"
	--     ccs.ArmatureDataManager:getInstance():addArmatureFileInfo(effect_paths)	
	-- end
	app.load("client.refinery.TreasureRefineryIcon")
	local csbTreasureStrengthen = csb.createNode("packs/TreasureStorage/treasure_strengthen_1.csb")
	
	local root = csbTreasureStrengthen:getChildByName("root")
	-- root:removeFromParent(true)
    
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local action1 = csb.createTimeline("packs/TreasureStorage/treasure_strengthen_1.csb") 
    	csbTreasureStrengthen:runAction(action1)
		action1:play("tubiao_ing", true)
	end
	local action = csb.createTimeline("packs/TreasureStorage/treasure_strengthen_1.csb") 
    csbTreasureStrengthen:runAction(action)
	self.action = action
	self:addChild(csbTreasureStrengthen)
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		or __lua_project_id == __lua_project_warship_girl_b 
		then
		local armaturePanel = ccui.Helper:seekWidgetByName(root, "Panel_2")
	    self.Armature_qianghuaResult = armaturePanel:getChildByName("ArmatureNode_4") -- 强化动画
	    draw.initArmature( self.Armature_qianghuaResult, nil, -1, 0, 1)
	    csb.animationChangeToAction(self.Armature_qianghuaResult, 0, 0, false)
	    self.Armature_qianghuaResult:setVisible(false)
	end
		

	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		or __lua_project_id == __lua_project_legendary_game 
		then			--龙虎门项目控制
		app.load("client.player.EquipPlayerInfomation")
		if fwin:find("EquipPlayerInfomationClass") == nil then
			-- fwin:open(EquipPlayerInfomation:new(),fwin._windows)
		end
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
	self.materialButton = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_6"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_2"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_3"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_4"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Image_5"),
	}
	self.material = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_gouniang_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_gouniang_2"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_gouniang_3"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_gouniang_4"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_gouniang_5"),
	}
	
	self.materialIconList = 
	{
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowu_1"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowu_2"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowu_3"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowu_4"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowu_5"),
		ccui.Helper:seekWidgetByName(self.roots[1], "Panel_3"),
	}
	
	-- 自动添加
	local Button_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_2")
	fwin:addTouchEventListener(Button_2, nil, 
	{
		terminal_name = "treasure_strengthen_page_treasure_auto_insert", 
		next_terminal_name = "", 
		but_image = "Button_2", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	-- 强化
	local Button_2 = ccui.Helper:seekWidgetByName(self.roots[1], "Button_1")
	fwin:addTouchEventListener(Button_2, nil, 
	{
		terminal_name = "treasure_strengthen_true", 
		next_terminal_name = "", 
		but_image = "Button_1", 	
		terminal_state = 0, 
		isPressedActionEnabled = true
	}, 
	nil, 0)
	
	-- 响应进入元素选择界面
	for i = 1,5 do
		fwin:addTouchEventListener(self.materialButton[i], nil, 
		{
			terminal_name = "treasure_strengthen_show_material", 
			terminal_state = 0,
		}, 
		nil, 0)
		fwin:addTouchEventListener(self.materialIconList[i], nil, 
		{
			terminal_name = "treasure_strengthen_show_material", 	
			terminal_state = 0,
		}, 
		nil, 0)
	end
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		-- 动画
		local function changeActionCallback(armatureBack)
			armatureBack:getParent():setVisible(false)
		end
		
		self.qianghuadonghua=ccui.Helper:seekWidgetByName(self.roots[1], "Panel_baowuqianghua")
		self.Armature_baowuqianghua = self.qianghuadonghua:getChildByName("ArmatureNode_baowuqianghua")
		
		draw.initArmature(self.Armature_baowuqianghua, nil, -1, 0, 1)
		self.Armature_baowuqianghua:getAnimation():playWithIndex(0, 0, 0)
		self.Armature_baowuqianghua._invoke = changeActionCallback
	end
	-- 取消一个宝物
	-- for i = 1,5 do
		-- fwin:addTouchEventListener(self.materialButton[i], nil, 
		-- {
			-- terminal_name = "hero_strengthen_page_cancel_one", 
			-- terminal_state = 0,
		-- }, 
		-- nil, 0)
	-- end
	ccui.Helper:seekWidgetByName(self.roots[1], "Text_3"):setString("0")
	self:onUpdateDraw()
end

--隐藏自己
function TreasureStrengthenPanel:onHide()
	self.roots[1]:setVisible(false)
end

--显示自己
function TreasureStrengthenPanel:onShow()
	self.roots[1]:setVisible(true)
end

--数据传参
function TreasureStrengthenPanel:init(currentTreasure, _string_type)
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_warship_girl_b 
		or __lua_project_id == __lua_project_yugioh
		then 
		self.currentTreasure = fundUserEquipWidthId(currentTreasure.user_equiment_id)
	else
		self.currentTreasure = currentTreasure
	end
	
	self.surplusExp = tonumber(currentTreasure.user_equiment_exprience)
	self._string_type = _string_type
end

function TreasureStrengthenPanel:onExit()
	state_machine.remove("treasure_strengthen_page_treasure_auto_insert")
	state_machine.remove("treasure_strengthen_from_material")
	state_machine.remove("treasure_strengthen_show_material")
	state_machine.remove("treasure_strengthen_true")
	state_machine.remove("treasure_resolve_cancel_one")
	state_machine.remove("treasure_strengthen_update_of_change_icon")
	state_machine.remove("treasure_refine_change_strengthen_update")
	if self._string_type == "formation" then
		if fwin:find("EquipPlayerInfomationClass") ~= nil then
			fwin:close(fwin:find("EquipPlayerInfomationClass"))
		end
	end
end