----------------------------------------------------------------------------------------------------
-- 说明：装备精炼界面
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
EquipRefinePage = class("EquipRefinePageClass", Window)
   
function EquipRefinePage:ctor()
    self.super:ctor()
	self.roots = {}
	self.green = nil
	self.blue = nil
	self.red = nil
	self.yellow = nil
	self.greenNum = 0
	self.blueNum = 0
	self.redNum = 0
	self.yellowNum = 0
	self._cell = nil
	self._string_type = nil
	self.level = nil
	self.one = false
	self.two = false
	self.three = false
	self.four = false

	self.isregister = false
	app.load("client.cells.utils.property_change_tip_info_cell") 
	app.load("client.packs.hero.HeroPatchInformationPageGetWay")
	
    local function init_equip_refine_page_terminal()
		-- 关闭自己
		local equip_refine_close_terminal = {
            _name = "equip_refine_close",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				state_machine.excute("equip_strengthen_refine_strorage_back", 0, "equip_strengthen_refine_strorage_back.")
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 绿色精炼
		local equip_refine_green_terminal = {
            _name = "equip_refine_green",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local one = instance:onMas(instance.equipmentInstance.user_equiment_id)
				local function responseRefineGreen(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					instance.isregister = false
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if instance == nil or instance.roots == nil then
							return
						end
						pushEffect(formatMusicFile("effect", 9989))
					
						local ArmatureInde = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_equipment_lv")
						local ArmatureNode_1 = ArmatureInde:getChildByName("ArmatureNode_equipment_lv")
						local animation = ArmatureNode_1:getAnimation()
						animation:playWithIndex(0, 0, 0)
						app.load("client.cells.utils.add_attribute_animationTwo")
						local newPage = AddAttributeAnimationTwo:createCell()
						local name = {}
						name[1] = "+5"
						newPage:init(name, 2, cc.p(0, 0), 5, 1)
						fwin:open(newPage, fwin._view)
						-- state_machine.excute("equip_refine_refush", 0, "equip_refine_refush.")
						state_machine.excute("equip_refine_refush", 0, {_datas = {cell = params._datas._cell}})
						local two = instance:onMas(instance.equipmentInstance.user_equiment_id)
						if two ~= one then
							local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
							local str = ""
							local textData = {}
							table.insert(textData, {property = _strengthen_master_info[11], value = two, add = _strengthen_master_info[14] })
							tipInfo:init(6,str, textData)		
							fwin:open(tipInfo, fwin._view)
						end
						
						if self.greenNum == nil or self.greenNum <= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_37"):setColor(cc.c3b(130, 130, 130))
							ccui.Helper:seekWidgetByName(instance.roots[1], "Text_42"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
						end
					end
				end
				if self.greenNum ~= nil and self.greenNum > 0 then
					instance.isregister = true
					local str = instance.equipmentInstance.user_equiment_id .. "\r\n" .. self.green
					protocol_command.equipment_refining.param_list = str
					NetworkManager:register(protocol_command.equipment_refining.code, nil, nil, nil, nil, responseRefineGreen, false, nil)
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[8], 2)
						fwin:open(cell, fwin._windows)
						self.one = false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 蓝色精炼
		local equip_refine_blue_terminal = {
            _name = "equip_refine_blue",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local one = instance:onMas(instance.equipmentInstance.user_equiment_id)
				local function responseRefineBlue(response)
					_ED.baseFightingCount = calcTotalFormationFight()
					instance.isregister = false
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if response.node == nil or response.node.roots == nil or response.node.roots[1] == nil then
							return
						end
						pushEffect(formatMusicFile("effect", 9989))
						local ArmatureInde = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_equipment_lan")
						local ArmatureNode_1 = ArmatureInde:getChildByName("ArmatureNode_equipment_lan")
						local animation = ArmatureNode_1:getAnimation()
						animation:playWithIndex(1, 0, 0)
						app.load("client.cells.utils.add_attribute_animationTwo")
						local newPage = AddAttributeAnimationTwo:createCell()
						local name = {}
						name[1] = "+10"
						newPage:init(name, 2, cc.p(0, 0), 5, 1)
						fwin:open(newPage, fwin._view)
						-- state_machine.excute("equip_refine_refush", 0, "equip_refine_refush.")
						state_machine.excute("equip_refine_refush", 0, {_datas = {cell = params._datas._cell}})
						local two = instance:onMas(instance.equipmentInstance.user_equiment_id)
						if two ~= one then
							local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
							local str = ""
							local textData = {}
							table.insert(textData, {property = _strengthen_master_info[11], value = two, add = _strengthen_master_info[14] })
							tipInfo:init(6,str, textData)	
							fwin:open(tipInfo, fwin._view)
						end
						
						if self.blueNum == nil or self.blueNum <= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_36"):setColor(cc.c3b(130, 130, 130))
							ccui.Helper:seekWidgetByName(instance.roots[1], "Text_43"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
						end
					end
				end
				if self.blueNum ~= nil and self.blueNum > 0 then
					instance.isregister = true
					local str = instance.equipmentInstance.user_equiment_id .. "\r\n" .. self.blue
					protocol_command.equipment_refining.param_list = str
					NetworkManager:register(protocol_command.equipment_refining.code, nil, nil, nil, instance, responseRefineBlue, false, nil)
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[7], 2)
						fwin:open(cell, fwin._windows)
						self.two = false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 红色精炼
		local equip_refine_red_terminal = {
            _name = "equip_refine_red",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local one = instance:onMas(instance.equipmentInstance.user_equiment_id)
				local function responseRefineRed(response)
					instance.isregister = false
					_ED.baseFightingCount = calcTotalFormationFight()
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if instance == nil or instance.roots == nil then
							return
						end
						pushEffect(formatMusicFile("effect", 9989))
						
						local ArmatureInde = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_equipment_lan_0")
						local ArmatureNode_1 = ArmatureInde:getChildByName("ArmatureNode_equipment_zi")
						local animation = ArmatureNode_1:getAnimation()
						animation:playWithIndex(2, 0, 0)
						app.load("client.cells.utils.add_attribute_animationTwo")
						local newPage = AddAttributeAnimationTwo:createCell()
						local name = {}
						name[1] = "+25"
						newPage:init(name, 2, cc.p(0, 0), 5, 1)
						fwin:open(newPage, fwin._view)
						-- state_machine.excute("equip_refine_refush", 0, "equip_refine_refush.")
						state_machine.excute("equip_refine_refush", 0, {_datas = {cell = params._datas._cell}})
						local two = instance:onMas(instance.equipmentInstance.user_equiment_id)
						if two ~= one then
							local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
							local str = ""
							local textData = {}
							table.insert(textData, {property = _strengthen_master_info[11], value = two, add = _strengthen_master_info[14] })
							tipInfo:init(6,str, textData)	
							fwin:open(tipInfo, fwin._view)
						end
						
						if self.redNum == nil or self.redNum <= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_35"):setColor(cc.c3b(130, 130, 130))
							ccui.Helper:seekWidgetByName(instance.roots[1], "Text_44"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
						end
					end
				end
				if self.redNum ~= nil and self.redNum > 0 then
					instance.isregister = true
					local str = instance.equipmentInstance.user_equiment_id .. "\r\n" .. self.red
					protocol_command.equipment_refining.param_list = str
					NetworkManager:register(protocol_command.equipment_refining.code, nil, nil, nil, nil, responseRefineRed, false, nil)
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[6], 2)
						fwin:open(cell, fwin._windows)
						self.three = false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 黄色精炼
		local equip_refine_yellow_terminal = {
            _name = "equip_refine_yellow",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local one = instance:onMas(instance.equipmentInstance.user_equiment_id)
				local function responseRefineYellow(response)
					instance.isregister = false
					_ED.baseFightingCount = calcTotalFormationFight()
					if response.RESPONSE_SUCCESS and response.PROTOCOL_STATUS >= 0 then
						if instance == nil or instance.roots == nil then
							return
						end
						pushEffect(formatMusicFile("effect", 9989))
					
						local ArmatureInde = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_equipment_cheng")
						local ArmatureNode_1 = ArmatureInde:getChildByName("ArmatureNode_equipment_cheng")
						local animation = ArmatureNode_1:getAnimation()
						animation:playWithIndex(3, 0, 0)
						app.load("client.cells.utils.add_attribute_animationTwo")
						local newPage = AddAttributeAnimationTwo:createCell()
						local name = {}
						name[1] = "+50"
						newPage:init(name, 2, cc.p(0, 0), 5, 1)
						fwin:open(newPage, fwin._view)
						-- state_machine.excute("equip_refine_refush", 0, "equip_refine_refush.")
						state_machine.excute("equip_refine_refush", 0, {_datas = {cell = params._datas._cell}})
						local two = instance:onMas(instance.equipmentInstance.user_equiment_id)
						if two ~= one then
							local tipInfo = PropertyChangeTipInfoAnimationCell:createCell()
							local str = ""
							local textData = {}
							table.insert(textData, {property = _strengthen_master_info[11], value = two, add = _strengthen_master_info[14] })
							tipInfo:init(6,str, textData)	
							fwin:open(tipInfo, fwin._view)
						end
						
						if self.yellowNum == nil or self.yellowNum <= 0 then
							ccui.Helper:seekWidgetByName(instance.roots[1], "Image_40"):setColor(cc.c3b(130, 130, 130))
							ccui.Helper:seekWidgetByName(instance.roots[1], "Text_45"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
						end
					end
				end
				if self.yellowNum ~= nil and self.yellowNum > 0 then
					instance.isregister = true
					local str = instance.equipmentInstance.user_equiment_id .. "\r\n" .. self.yellow
					protocol_command.equipment_refining.param_list = str
					NetworkManager:register(protocol_command.equipment_refining.code, nil, nil, nil, nil, responseRefineYellow, false, nil)
				else
					if fwin:find("HeroPatchInformationPageGetWayClass") == nil then
						local cell = HeroPatchInformationPageGetWay:createCell()
						cell:init(zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")[5], 2)
						fwin:open(cell, fwin._windows)
						self.four = false
					end
				end
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		
		-- 刷新界面信息
		local equip_refine_refush_terminal = {
            _name = "equip_refine_refush",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
				local cell = params._datas.cell
				if self.level < tonumber(self.equipmentInstance.equiment_refine_level) then
					if __lua_project_id == __lua_project_gragon_tiger_gate
						or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
						or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
						or __lua_project_id == __lua_project_red_alert 
						then
						instance.one = false
						instance.two = false
						instance.three = false
						instance.four = false
						state_machine.excute("equip_list_view_show_equip_list_view_update_allcell",0,"")
					end
					local ArmatureInde = ccui.Helper:seekWidgetByName(instance.roots[1],"Panel_equipment_cheng")
					local ArmatureNode_1 = ArmatureInde:getChildByName("ArmatureNode_equipment_cheng")
					local animation = ArmatureNode_1:getAnimation()
					animation:playWithIndex(4, 0, 0)
					
					pushEffect(formatMusicFile("effect", 9992))
					if "equip_list_tan" == instance._string_type then
						state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = cell}})
						state_machine.excute("equip_list_view_del_and_insert_cell", 0, {_datas = {_cell = cell}})
					elseif "formation" == instance._string_type then
						state_machine.excute("equip_list_update_page", 0, {_datas = {_cell = cell}})
						-- playEffectForAbilityUp()
					elseif "strengthen_master" == instance._string_type then
						state_machine.excute("strengthen_master_draw_equip_refine", 0, "strengthen_master_draw_equip_refine.")	
						state_machine.excute("formation_property_change_equip_info", 0, "formation_property_change_equip_info.")	
					end
				end	
				
				instance:onUpdateDraw()
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		--切换装备的刷新
		local equip_refine_change_equip_refush_terminal = {
            _name = "equip_refine_change_equip_refush",
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
		
		--红装技能展示
		local equip_refine_page_red_equip_skill_see_terminal = {
            _name = "equip_refine_page_red_equip_skill_see",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
            	app.load("client.packs.equipment.EquipRedSeeInfo")	
				local cell = EquipRedSeeInfo:new()
				cell:init(instance.equipmentInstance)
				fwin:open(cell, fwin._dialog)
                return true
            end,
            _terminal = nil,
            _terminals = nil
        }
		state_machine.add(equip_refine_close_terminal)
		state_machine.add(equip_refine_green_terminal)
		state_machine.add(equip_refine_blue_terminal)
		state_machine.add(equip_refine_red_terminal)
		state_machine.add(equip_refine_yellow_terminal)
		state_machine.add(equip_refine_refush_terminal)
        state_machine.add(equip_refine_change_equip_refush_terminal)
        state_machine.add(equip_refine_page_red_equip_skill_see_terminal)
        state_machine.init()
    end
    
    init_equip_refine_page_terminal()
end

function EquipRefinePage:onMas(id)
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
				if i <= 4 then
					if grade1 == nil then
						grade1 = tonumber(v.equiment_refine_level)
					end
					if grade1 > tonumber(v.equiment_refine_level) then
						grade1 = tonumber(v.equiment_refine_level)
					end
					
				end
			end
			-- table.insert(textData, {property = _strengthen_master_info[10], value = grade1, add = _strengthen_master_info[14] })
		end
		if grade1 ~= nil then
			local strengthen_master_data = dms.searchs(dms["strengthen_master_info"], strengthen_master_info.master_type, 1)
			for i, v in ipairs(strengthen_master_data) do
				local need_level = dms.atoi(v, strengthen_master_info.need_level)
				if grade1 >= need_level then
					nums = dms.atoi(v, strengthen_master_info.master_level)
				end
			end
		end
	end
	return nums
end

--红装光效显示设置
function EquipRefinePage:setRedVisible(isshow)
	local hong = ccui.Helper:seekWidgetByName(self.roots[1], "Panel_pzgz_hong")
	if nil ~= hong then
		hong:setVisible(isshow)
	end
end

function EquipRefinePage:onUpdateDraw()
	local root = self.roots[1]
	local upPrice = {}
	local name = ccui.Helper:seekWidgetByName(root, "Text_1")
	local allPic = ccui.Helper:seekWidgetByName(root, "Panel_3")
	local describe = ccui.Helper:seekWidgetByName(root, "Text_7")
	local describeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0_1")
	local describeTwo = ccui.Helper:seekWidgetByName(root, "Text_8")
	local describeNumTwo = ccui.Helper:seekWidgetByName(root, "Text_7_0")
	
	local nextDescribe = ccui.Helper:seekWidgetByName(root, "Text_7_2")
	local nextDescribeNum = ccui.Helper:seekWidgetByName(root, "Text_7_0_1_0")
	
	local nextDescribeTwo = ccui.Helper:seekWidgetByName(root, "Text_8_1")
	local nextDescribeNumTwo = ccui.Helper:seekWidgetByName(root, "Text_7_0_2")
	
	local greenText = ccui.Helper:seekWidgetByName(root, "Text_42")
	local blueText = ccui.Helper:seekWidgetByName(root, "Text_43")
	local redText = ccui.Helper:seekWidgetByName(root, "Text_44")
	local yellowText = ccui.Helper:seekWidgetByName(root, "Text_45") 
	
	local level = ccui.Helper:seekWidgetByName(root, "Text_15_0")		--精炼等级
	local loadingBar = ccui.Helper:seekWidgetByName(root, "LoadingBar_1") 	--进度条
	local bar =  ccui.Helper:seekWidgetByName(root, "Text_32")	--进度条文字
	
	local equipName = dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.equipment_name)
	local quality = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.grow_level)
	local picIndex = dms.int(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.All_icon)
	local refiningGrowValue = dms.string(dms["equipment_mould"], self.equipmentInstance.user_equiment_template, equipment_mould.refining_grow_value)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local lv =ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lv")
		local lan=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_lan")
		local zi=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_zi")
		local cheng=ccui.Helper:seekWidgetByName(root, "Panel_pzgz_cheng")
		lv:setVisible(false)
		lan:setVisible(false)
		zi:setVisible(false)
		cheng:setVisible(false)
		self:setRedVisible(false)		
		if quality == 1 then							--绿色--注意 ：这里的 quality 和信息界面有差异
		--print("绿色")
			lv:setVisible(true)
		elseif quality == 2 then
		--print("蓝色")
			lan:setVisible(true)
		elseif quality == 3 then
		--print("紫色")
			zi:setVisible(true)
		elseif quality == 4 then
			cheng:setVisible(true)
		elseif quality == 5 then
			self:setRedVisible(true)	
		end
	end
	
	name:setString(equipName)
	name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	allPic:setBackGroundImage(string.format("images/ui/big_props/big_props_%d.png", picIndex))
	level:setString(self.equipmentInstance.equiment_refine_level)
	self.level = tonumber(self.equipmentInstance.equiment_refine_level)
	
	local data = zstring.split(dms.string(dms["pirates_config"], 273, pirates_config.param), ",")
	
	local green = data[8]
	local blue = data[7]
	local red = data[6]
	local yellow = data[5]
	local status1 = false
	local status2 = false
	local status3 = false
	local status4 = false
	for i, v in pairs(_ED.user_prop) do
		if tonumber(v.user_prop_template) == tonumber(green) then
			self.green = v.user_prop_id
			self.greenNum = tonumber(v.prop_number)
			status1 = true
		end
		if tonumber(v.user_prop_template) == tonumber(blue) then
			self.blue = v.user_prop_id
			self.blueNum = tonumber(v.prop_number)
			status2 = true
		end
		if tonumber(v.user_prop_template) == tonumber(red) then
			self.red = v.user_prop_id
			self.redNum = tonumber(v.prop_number)
			status3 = true
		end
		if tonumber(v.user_prop_template) == tonumber(yellow) then
			self.yellow = v.user_prop_id
			self.yellowNum = tonumber(v.prop_number)
			status4 = true
		end
	end
	
	local Button_jn = ccui.Helper:seekWidgetByName(root, "Button_jn")
	if Button_jn ~= nil then
		if quality == 5 then
			ccui.Helper:seekWidgetByName(root, "Button_jn"):setVisible(true)
		else
			ccui.Helper:seekWidgetByName(root, "Button_jn"):setVisible(false)
		end
	end

	if status1 == false then
		self.greenNum = 0
		ccui.Helper:seekWidgetByName(root, "Image_37"):setColor(cc.c3b(130, 130, 130))
	end
	if status2 == false then
		self.blueNum = 0
		ccui.Helper:seekWidgetByName(root, "Image_36"):setColor(cc.c3b(130, 130, 130))
	end
	if status3 == false then
		self.redNum = 0
		ccui.Helper:seekWidgetByName(root, "Image_35"):setColor(cc.c3b(130, 130, 130))
	end
	if status4 == false then
		self.yellowNum = 0
		ccui.Helper:seekWidgetByName(root, "Image_40"):setColor(cc.c3b(130, 130, 130))
	end
	greenText:setString(self.greenNum)
	blueText:setString(self.blueNum)
	redText:setString(self.redNum)
	yellowText:setString(self.yellowNum)
	if tonumber(self.greenNum) <= 0 then
		ccui.Helper:seekWidgetByName(root, "Text_42"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	end
	if tonumber(self.blueNum) <= 0 then
		ccui.Helper:seekWidgetByName(root, "Text_43"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	end
	if tonumber(self.redNum) <= 0 then
		ccui.Helper:seekWidgetByName(root, "Text_44"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	end
	if tonumber(self.yellowNum) <= 0 then
		ccui.Helper:seekWidgetByName(root, "Text_45"):setColor(cc.c3b(color_Type[6][1], color_Type[6][2], color_Type[6][3]))
	end
	
	local LabelList = {
		describe,
		describeTwo,
	}
	local lableNode = {
		describeNum,
		describeNumTwo,
	}
	local lableAddList = {
		nextDescribe,
		nextDescribeTwo,
	}
	local lableAddNoe = {
		nextDescribeNum,
		nextDescribeNumTwo,
	}
	
	
	local myLevel = tonumber(self.equipmentInstance.equiment_refine_level)
	local temp = zstring.split(refiningGrowValue,"|")
	for i,v in ipairs(temp) do
		local Keyvalues = zstring.split(v,",")
		if  table.getn(Keyvalues) > 1  then 
			lableAddList[i]:setString(string_equiprety_name[tonumber(Keyvalues[1])+1])
			if i == 1 then
				lableAddNoe[i]:setString(tonumber(Keyvalues[2])*(myLevel+1))
			else
				lableAddNoe[i]:setString(tonumber(Keyvalues[2])*(myLevel+1).."%")
			end
		end
	end
	
	if myLevel == 0 then
		local temp = zstring.split(refiningGrowValue,"|")
		for i,v in ipairs(temp) do
			local Keyvalues = zstring.split(v,",")
			if  table.getn(Keyvalues) > 1  then 
				LabelList[i]:setString(string_equiprety_name[tonumber(Keyvalues[1])+1])
				if i == 1 then
					lableNode[i]:setString(0)
				else
					lableNode[i]:setString(string.format("%.1f%%",0))
				end
			end
		end
	else
		local temb = zstring.split(self.equipmentInstance.equiment_refine_param,"|")
		for i,v in ipairs(temb) do
			local Keyvalue = zstring.split(v,",")
			if  table.getn(Keyvalue) > 1  then 
				LabelList[i]:setString(string_equiprety_name[tonumber(Keyvalue[1])+1])
				if i == 1 then
					lableNode[i]:setString(Keyvalue[2])
				else
					lableNode[i]:setString(string.format("%.1f%%",Keyvalue[2]))
				end
			end
		end
	end
	
	
	
	local leveldemandexp = 0
	
	if quality == 0 then
		leveldemandexp = dms.int(dms["equipment_refining_experience_param"], myLevel+1, equipment_refining_experience_param.needs_experience_white)
	elseif quality == 1 then
		leveldemandexp = dms.int(dms["equipment_refining_experience_param"], myLevel+1, equipment_refining_experience_param.needs_experience_green)
	elseif quality == 2 then
		leveldemandexp = dms.int(dms["equipment_refining_experience_param"], myLevel+1, equipment_refining_experience_param.needs_experience_blue)
	elseif quality == 3 then
		leveldemandexp = dms.int(dms["equipment_refining_experience_param"], myLevel+1, equipment_refining_experience_param.needs_experience_purple)
	elseif quality == 4 then
		leveldemandexp = dms.int(dms["equipment_refining_experience_param"], myLevel+1, equipment_refining_experience_param.needs_experience_orange)
	elseif quality == 5 then
		leveldemandexp = dms.int(dms["equipment_refining_experience_param"], myLevel+1, equipment_refining_experience_param.needs_experience_red)
	end
	if leveldemandexp ~= nil then
		local equipLevelSchedule = tonumber(self.equipmentInstance.user_equiment_exprience)/leveldemandexp*100
		if leveldemandexp == -1 then
			bar:setString(_string_piece_info[344])
			loadingBar:setPercent(100)
		else
			bar:setString(self.equipmentInstance.user_equiment_exprience.."/"..leveldemandexp)
			loadingBar:setPercent(equipLevelSchedule)
		end
	end
end

function EquipRefinePage:onUpdate(dt)
	if self.isregister == true then
		return
	end
	if self.one == true then
		state_machine.excute("equip_refine_green", 0, {_datas = {_equip = self.equipmentInstance,_cell = self._cell,isPressedActionEnabled = true}})
	elseif self.two == true then
		state_machine.excute("equip_refine_blue", 0, {_datas = {_equip = self.equipmentInstance,_cell = self._cell,isPressedActionEnabled = true}})
	elseif self.three == true then
		state_machine.excute("equip_refine_red", 0, {_datas = {_equip = self.equipmentInstance,_cell = self._cell,isPressedActionEnabled = true}})
	elseif self.four == true then
		state_machine.excute("equip_refine_yellow", 0, {_datas = {_equip = self.equipmentInstance,_cell = self._cell,isPressedActionEnabled = true}})
	end
end

function EquipRefinePage:onEnterTransitionFinish()
    local csbEquipRefinePage = csb.createNode("packs/EquipStorage/equipment_strengthen_2.csb")
	self:addChild(csbEquipRefinePage)
	
	local root = csbEquipRefinePage:getChildByName("root")
	table.insert(self.roots, root)
	
	if __lua_project_id == __lua_project_gragon_tiger_gate
		or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
		or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
		or __lua_project_id == __lua_project_red_alert 
		then
		local action = csb.createTimeline("packs/EquipStorage/equipment_strengthen_2.csb") 
		csbEquipRefinePage:runAction(action)
		action:play("tubiao_ing", true)
	end
	
	if self._string_type == "formation" then
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
		else
			app.load("client.player.EquipPlayerInfomation")
			if fwin:find("EquipPlayerInfomationClass") == nil then
				fwin:open(EquipPlayerInfomation:new(),fwin._windows)
			end
		end
		state_machine.excute("formation_property_change_before", 0, "formation_property_change_before.")
	end

	self:onUpdateDraw()
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_37"), nil, 
	-- {
		-- terminal_name = "equip_refine_green", 
		-- terminal_state = 0, 
		-- _equip = self.equipmentInstance,  
		-- _cell = self._cell,
		-- isPressedActionEnabled = true
	-- }, 
	-- nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_36"), nil, 
	-- {
		-- terminal_name = "equip_refine_blue", 
		-- terminal_state = 0, 
		-- _equip = self.equipmentInstance,  
		-- _cell = self._cell,
		-- isPressedActionEnabled = true
	-- }, 
	-- nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_35"), nil, 
	-- {
		-- terminal_name = "equip_refine_red", 
		-- terminal_state = 0, 
		-- _equip = self.equipmentInstance,  
		-- _cell = self._cell,
		-- isPressedActionEnabled = true
	-- }, 
	-- nil, 0)
	-- fwin:addTouchEventListener(ccui.Helper:seekWidgetByName(root, "Image_40"), nil, 
	-- {
		-- terminal_name = "equip_refine_yellow", 
		-- terminal_state = 0, 
		-- _equip = self.equipmentInstance,  
		-- _cell = self._cell,
		-- isPressedActionEnabled = true
	-- }, 
	-- nil, 0)
	
	-----------按钮监听状态
	local buttonOne = ccui.Helper:seekWidgetByName(self.roots[1], "Image_37")
	local buttonTwo = ccui.Helper:seekWidgetByName(self.roots[1], "Image_36")
	local buttonThree = ccui.Helper:seekWidgetByName(self.roots[1], "Image_35")
	local buttonFour = ccui.Helper:seekWidgetByName(self.roots[1], "Image_40")
	local function buttonOneTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()
		if ccui.TouchEventType.began == evenType then
			self.one = true
		elseif ccui.TouchEventType.moved == evenType then
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				if __mpoint.x - __spoint.x > 100 
					or __mpoint.x - __spoint.x < -100 
					or __mpoint.y - __spoint.y > 80 
					or __mpoint.y - __spoint.y < -80 
					then
					self.one = false
					self.two = false
					self.three = false
					self.four = false
				end
			end
		elseif ccui.TouchEventType.ended == evenType then
			self.one = false
			self.two = false
			self.three = false
			self.four = false
		end
	end
	buttonOne:addTouchEventListener(buttonOneTouchEvent)
	
	
	local function buttonTwoTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()	
		if ccui.TouchEventType.began == evenType then
			self.two = true
		elseif ccui.TouchEventType.moved == evenType then
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
							-- print("xxxxxxx",__mpoint.x - __spoint.x)
				-- print("yyyyyyyyy",__mpoint.y - __spoint.y)
				if __mpoint.x - __spoint.x > 100 
					or __mpoint.x - __spoint.x < -100 
					or __mpoint.y - __spoint.y > 80 
					or __mpoint.y - __spoint.y < -80 
					then
					self.one = false
					self.two = false
					self.three = false
					self.four = false
				end
			end
		elseif ccui.TouchEventType.ended == evenType then
			self.one = false
			self.two = false
			self.three = false
			self.four = false
		end
	end
	buttonTwo:addTouchEventListener(buttonTwoTouchEvent)
	
	
	local function buttonThreeTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()	
		if ccui.TouchEventType.began == evenType then
			self.three = true
		elseif ccui.TouchEventType.moved == evenType then
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
				if __mpoint.x - __spoint.x > 100 
					or __mpoint.x - __spoint.x < -100 
					or __mpoint.y - __spoint.y > 80 
					or __mpoint.y - __spoint.y < -80 
					then
					self.one = false
					self.two = false
					self.three = false
					self.four = false
				end
			end
		elseif ccui.TouchEventType.ended == evenType then
			self.one = false
			self.two = false
			self.three = false
			self.four = false
		end
	end
	buttonThree:addTouchEventListener(buttonThreeTouchEvent)
	
	
	local function buttonFourTouchEvent(sender, evenType)
		local __spoint = sender:getTouchBeganPosition()
		local __mpoint = sender:getTouchMovePosition()
		local __epoint = sender:getTouchEndPosition()	
		if ccui.TouchEventType.began == evenType then
			self.four = true
		elseif ccui.TouchEventType.moved == evenType then
			if __lua_project_id == __lua_project_gragon_tiger_gate
				or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
				or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
				or __lua_project_id == __lua_project_red_alert 
				then
							-- print("xxxxxxx",__mpoint.x - __spoint.x)
				-- print("yyyyyyyyy",__mpoint.y - __spoint.y)
				if __mpoint.x - __spoint.x > 100 
					or __mpoint.x - __spoint.x < -100 
					or __mpoint.y - __spoint.y > 80 
					or __mpoint.y - __spoint.y < -80 
					then
					self.one = false
					self.two = false
					self.three = false
					self.four = false
				end
			end
		elseif ccui.TouchEventType.ended == evenType then
			self.one = false
			self.two = false
			self.three = false
			self.four = false
		end
	end
	buttonFour:addTouchEventListener(buttonFourTouchEvent)
	
	local Button_jn = ccui.Helper:seekWidgetByName(root, "Button_jn")
	if Button_jn ~= nil then
		fwin:addTouchEventListener(Button_jn, nil,
		{
			terminal_name = "equip_refine_page_red_equip_skill_see", 
			cell = self
		}, nil, 0)
	end
	
	fwin:addTouchEventListener(allPic, nil, {func_string = [[state_machine.excute("equip_refine_close", 0, "click equip_refine_close.'")]]}, nil, 0)
end

function EquipRefinePage:onExit()
	state_machine.remove("equip_refine_close")
	state_machine.remove("equip_refine_green")
	state_machine.remove("equip_refine_blue")
	state_machine.remove("equip_refine_red")
	state_machine.remove("equip_refine_yellow")
	state_machine.remove("equip_refine_refush")
	state_machine.remove("equip_refine_change_equip_refush")
	state_machine.remove("equip_refine_page_red_equip_skill_see")
end

function EquipRefinePage:close( ... )
	if self._string_type == "formation" then
		if fwin:find("EquipPlayerInfomationClass") ~= nil then
			fwin:close(fwin:find("EquipPlayerInfomationClass"))
		end
	end
end

function EquipRefinePage:init(equipmentInstance,_cell,_string_type)
	self.equipmentInstance = equipmentInstance
	self._cell = _cell
	self._string_type = _string_type
end
