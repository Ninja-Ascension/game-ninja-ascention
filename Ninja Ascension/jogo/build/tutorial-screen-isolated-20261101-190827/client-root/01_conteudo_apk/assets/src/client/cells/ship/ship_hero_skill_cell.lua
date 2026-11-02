---------------------------------
---说明：武将信息界面的 技能卡
-- 创建时间:2015.03.17
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
---------------------------------

FormationHeroSkill = class("FormationHeroSkillClass", Window)
   
function FormationHeroSkill:ctor()
    self.super:ctor()
	self.hero = nil
	self.userfashion = nil  
	self.info = {}
	self.listPositionX = nil
	app.load("client.cells.ship.ship_hero_skill_get_cell")
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	local function init_formation_hero_skill_terminal()
		-- local get_special_skill_terminal = {
            -- _name = "get_special_skill",
            -- _init = function (terminal) 
                
            -- end,
            -- _inited = false,
            -- _instance = self,
            -- _state = 0,
            -- _invoke = function(terminal, instance, params)
				-- TipDlg.drawTextDailog(_function_unopened_tip_string)
                -- return true
            -- end,
            -- _terminal = nil,
            -- _terminals = nil
        -- }
		
		-- state_machine.add(get_special_skill_terminal)
		state_machine.init()
	end
	init_formation_hero_skill_terminal()
end
function FormationHeroSkill:onUpdateDraw2()
	app.load("client.cells.fashion.fashion_info_skill_temp_cell")
	local root = self.roots[1]
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")
	local panelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	local Panel_shuoming_width = panelGeneralsEquipment:getContentSize().width
	local Panel_shuoming_height = panelGeneralsEquipment:getContentSize().height

	local equip = self.userfashion
	local equipId = nil

	local equip_lv = 1
	if equip ~= nil then

		equipId =equip.user_equiment_template
		equip_lv = zstring.tonumber(equip.user_equiment_grade)
	else
		equip_lv = 1
		equipId = self.equip_mould
	end

	
	local skills = dms.int(dms["equipment_mould"], equipId, equipment_mould.skill_equipment_adron_mould)
	local skillsData = dms.searchs(dms["equipment_fashion_skill"], equipment_fashion_skill.group_id, skills)



	local ship = fundShipWidthId(_ED.user_formetion_status[1])
	local level = nil
    if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
        tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(_ED.user_formetion_status[1]) then
        level = _ED.hero_skillstren_info.level
    else
        level = ship.ship_skillstren.skill_level
    end
    level = zstring.tonumber(level)
    local skillsDataOne = nil 
    local skillsDataTwo = nil 
    local skillsDataThere = nil 
    if table.getn(skillsData) ~= 0 then
        -- local skillsDataOne = dms.searchs(dms["equipment_fashion_skill"], equipment_fashion_skill.group_id, skills)
        for i,v in ipairs(skillsData) do
            local _type = dms.atoi(v,equipment_fashion_skill.skill_type)
            local _needLv = dms.atoi(v,equipment_fashion_skill.need_lv)
            if _type == 0 then
                if level >= _needLv then
                    skillsDataOne = v
                end
            elseif _type == 1 then
                if level >= _needLv then
                    skillsDataTwo = v
                end
            elseif _type == 2 then
                if level >= _needLv then
                    skillsDataThere = v
                end
            end
        end
    end 


	local AllSize = Image_18:getContentSize().height
	for i = 1 ,3 do
		if i == 1 then
			if skillsDataOne ~= nil then
				local skillmouidid = dms.atoi(skillsDataOne,equipment_fashion_skill.skill_mouid_id)
      			local skillDatas = dms.element(dms["skill_mould"],skillmouidid)
				-- self.equip._skill_name = dms.atos(skillDatas,skill_mould.skill_name)
				-- self.equip._skill_describe = dms.atos(skillDatas,skill_mould.skill_describe)
				self.info[1] = dms.atos(skillDatas,skill_mould.skill_name)
				self.info[2] = dms.atos(skillDatas,skill_mould.skill_describe)
				local cell = FashionInfoHeroSkillTemp:createCell()
				cell:init(self.info,1,nil,self.listPositionX)
				local size = cell:getContentSize()
				-- cell:setPosition(cc.p(Text_shuoming:getPositionX(), Text_height-AllSize))
				AllSize = AllSize + size.height
				Panel_14:addChild(cell)
				cell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				cell:setPosition(cc.p(Text_shuoming:getPositionX(), -1 * AllSize))
			end
		elseif i == 2 then
			if skillsDataTwo ~= nil then
				local skillmouidid = dms.atoi(skillsDataTwo,equipment_fashion_skill.skill_mouid_id)
      			local skillDatas = dms.element(dms["skill_mould"],skillmouidid)
				-- self.equip._skill_name_two = dms.atos(skillDatas,skill_mould.skill_name)
				-- self.equip._skill_describe_two = dms.atos(skillDatas,skill_mould.skill_describe)
				self.info[3] = dms.atos(skillDatas,skill_mould.skill_name)
				self.info[4] = dms.atos(skillDatas,skill_mould.skill_describe)
				local cell = FashionInfoHeroSkillTemp:createCell()
				cell:init(self.info,2,nil,self.listPositionX)
				local size = cell:getContentSize()
				-- cell:setPosition(cc.p(Text_shuoming:getPositionX(), Text_height-AllSize))
				AllSize = AllSize + size.height

				Panel_14:addChild(cell)
				cell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				cell:setPosition(cc.p(Text_shuoming:getPositionX(), -1 * AllSize))
			end
		elseif i == 3 then
			
			if skillsDataThere ~= nil then
				local isopen = false
				local skillequipmentmould = dms.atoi(skillsDataThere,equipment_fashion_skill.skill_equipment_mould)
		        local talentDatas = dms.searchs(dms["equipment_fashion_talent"], equipment_fashion_talent.group_id, skills)
		        if table.getn(talentDatas) ~= 0 then
		            for i,v in ipairs(talentDatas) do
		                if dms.atoi(v,equipment_fashion_talent.skill_fit_mould_id) == skillequipmentmould then
		                    if dms.atoi(v,equipment_fashion_talent.need_lv) <= tonumber(equip_lv) then
		                        isopen = true
		                    end
		                end  
		            end
		        end
		        local skillmouidid = dms.atoi(skillsDataThere,equipment_fashion_skill.skill_mouid_id)
      			local skillDatas = dms.element(dms["skill_mould"],skillmouidid)
				-- self.equip._skill_name_there = dms.atos(skillDatas,skill_mould.skill_name)
				-- self.equip._skill_describe_there = dms.atos(skillDatas,skill_mould.skill_describe)
				self.info[5] = dms.atos(skillDatas,skill_mould.skill_name)
				self.info[6] = dms.atos(skillDatas,skill_mould.skill_describe)
				local cell = FashionInfoHeroSkillTemp:createCell()
				cell:init(self.info,3,isopen,self.listPositionX)
				local size = cell:getContentSize()
				-- cell:setPosition(cc.p(Text_shuoming:getPositionX(), Text_height-AllSize))
				AllSize = AllSize + size.height

				Panel_14:addChild(cell)
				cell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				cell:setPosition(cc.p(Text_shuoming:getPositionX(), -1 * AllSize))
			end
		
		end
	end
	panelGeneralsEquipment:setContentSize(cc.size(Panel_shuoming_width, Panel_shuoming_height+AllSize-Image_18:getContentSize().height))

	self:setContentSize(cc.size(Panel_shuoming_width,Panel_shuoming_height+AllSize+5))
	Panel_14:setPosition(Panel_14:getPositionX(), Panel_14:getPositionY() + AllSize-Image_18:getContentSize().height)

	panelGeneralsEquipment:setPosition(panelGeneralsEquipment:getPositionX(), panelGeneralsEquipment:getPositionY() + AllSize-Image_18:getContentSize().height)

	
end



function FormationHeroSkill:onUpdateDraw()
	local root = self.roots[1]
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")
	local panelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	local Panel_shuoming_width = panelGeneralsEquipment:getContentSize().width
	local Panel_shuoming_height = panelGeneralsEquipment:getContentSize().height
	
	local AllSize = 50
	for i = 1 , 4 do
		if i <= 2 then
			local cell = FormationHeroSkillTemp:createCell()
			cell:init(self.hero,i)
			local size = cell:getContentSize()
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
				cell:setPosition(cc.p(Text_width+10,Text_height-AllSize))
			else
				cell:setPosition(cc.p(Text_width-10,Text_height-AllSize))
			end
			AllSize = AllSize + size.height
			Panel_14:addChild(cell)
		elseif i==3 then
			local zoariumSkill = dms.int(dms["ship_mould"], self.hero.ship_base_template_id, ship_mould.zoarium_skill)
			if zoariumSkill ~= -1 then
				local cell = FormationHeroSkillTemp:createCell()
				cell:init(self.hero,i)
				local size = cell:getContentSize()
				if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
					cell:setPosition(cc.p(Text_width+10,Text_height-AllSize))
				else
					cell:setPosition(cc.p(Text_width-10,Text_height-AllSize))
				end
				AllSize = AllSize + size.height
				Panel_14:addChild(cell)
			end
		else
			local zoariumSkill = dms.int(dms["ship_mould"], self.hero.ship_base_template_id, ship_mould.zoarium_skill)
			if zoariumSkill ~= -1 then
				local person = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.release_mould)
				local ser = {}
				local num = 1
				for i,v in pairs(_ED.user_ship) do
					if zstring.tonumber(v.formation_index) > 0 then
						ser[num] = v.ship_base_template_id
						num = num + 1
					end
				end
				local nextId = nil
				local step = zstring.split(person,",")
				local unionShipActive = true
				for i = 1, table.getn(step) do
					local shipMouldId = step[i]
					local isActive = false
					for j = 1, table.getn(ser) do
						if tonumber(ser[j]) == tonumber(shipMouldId) then
							isActive = true
							break
						end
					end
					if isActive == false then
						unionShipActive = false
						break
					end
				end
				
				for i = 1, table.getn(step) do
					if tonumber(step[i]) ~= tonumber(self.hero.ship_base_template_id) then
						nextId = step[i]
					end 
				end
				
				if zoariumSkill ~= -1 and unionShipActive == false then
					local cell = ShipHeroSkillGetCell:createCell()
					cell:init(nextId)
					local size = cell:getContentSize()
					cell:setPosition(cc.p(Text_width-10,Text_height-AllSize))
					AllSize = AllSize + 10
					Panel_14:addChild(cell)
				end
			end
		end
	end
	panelGeneralsEquipment:setContentSize(cc.size(Panel_shuoming_width, Panel_shuoming_height+AllSize-Image_18:getContentSize().height))
	Panel_14:setPosition(Panel_14:getPositionX(), Panel_14:getPositionY() + AllSize-Image_18:getContentSize().height)
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self:setContentSize(cc.size(Panel_shuoming_width,Panel_shuoming_height + AllSize - 100))
		panelGeneralsEquipment:setPosition(panelGeneralsEquipment:getPositionX(), panelGeneralsEquipment:getPositionY() + AllSize-Image_18:getContentSize().height - 80)
	else
		self:setContentSize(cc.size(Panel_shuoming_width,Panel_shuoming_height + AllSize))
		panelGeneralsEquipment:setPosition(panelGeneralsEquipment:getPositionX(), panelGeneralsEquipment:getPositionY() + AllSize-Image_18:getContentSize().height)
	end
end

function FormationHeroSkill:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_4 = csb.createNode("packs/HeroStorage/generals_information_6.csb")
	local root = csbGeneralsInformation_4:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_4)
	
	-- local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	-- local Panel_shuoming_width = PanelGeneralsEquipment:getContentSize().width
	-- local Panel_shuoming_height = PanelGeneralsEquipment:getContentSize().height
	-- PanelGeneralsEquipment:setContentSize(cc.size(Panel_shuoming_width,Panel_shuoming_height+100))
	-- self:setContentSize(cc.size(Panel_shuoming_width,Panel_shuoming_height+100))
	ccui.Helper:seekWidgetByName(root, "Text_biaoti"):setString(_string_piece_info[43])
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if self.hero == nil then
			local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
			self:setContentSize(cc.size(PanelGeneralsEquipment:getContentSize().width, PanelGeneralsEquipment:getContentSize().height + 10))
			return
		end
	end
	if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
		if self.userfashion ~= nil then
			self:onUpdateDraw2()
		else
			self:onUpdateDraw()
		end
	else
		self:onUpdateDraw()
	end
	
end


function FormationHeroSkill:onExit()
	-- state_machine.remove("get_special_skill")
end

function FormationHeroSkill:init(hero,userfashion,listPositionX)
	self.hero = hero
	self.userfashion = userfashion   --- 传入用户时装绘制时装的技能
	self.listPositionX = listPositionX
end

function FormationHeroSkill:createCell()
	local cell = FormationHeroSkill:new()
	cell:registerOnNodeEvent(cell)
	return cell
end