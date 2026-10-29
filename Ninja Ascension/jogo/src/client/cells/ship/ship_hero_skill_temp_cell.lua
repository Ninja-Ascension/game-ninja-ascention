---------------------------------
---说明：武将信息界面的 技能卡子界面
-- 创建时间:
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
---------------------------------

FormationHeroSkillTemp = class("FormationHeroSkillTempClass", Window)
   
function FormationHeroSkillTemp:ctor()
    self.super:ctor()
	self.hero = nil
	self.page = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

end
function FormationHeroSkillTemp:getNewSkillMould()
	local level = 0
	if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
	tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(self.hero.ship_id) then
		level = _ED.hero_skillstren_info.level
	else
		level = self.hero.ship_skillstren.skill_level
	end
	for j,k in pairs(_ED.user_ship) do
		if tonumber(k.captain_type) == 0 then
			--学艺技能
			for i , v in pairs(_ED.user_skill_equipment) do
			   if tonumber(v.equip_state) == 1 then
			   		local skillEquipment = dms.element(dms["skill_equipment_mould"],v.skill_equipment_base_mould)
			   		local skill_mould_id = dms.atoi(skillEquipment,skill_equipment_mould.skill_equipment_base_mould)
					local skillNames = dms.string(dms["skill_mould"], skill_mould_id + tonumber(level) - 1, skill_mould.skill_name)
					local skillNamesDes = dms.string(dms["skill_mould"], skill_mould_id + tonumber(level) - 1, skill_mould.skill_describe)
					return skillNames,skillNamesDes
			   end
			end
		end
	end
end
function FormationHeroSkillTemp:onUpdateDraw()
	local root = self.roots[1]
	if self.page == 1 then
		local pic = ccui.Helper:seekWidgetByName(root, "Image_7")
		pic:setVisible(true)
		local Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18")
		local Panel_jineng_2 = ccui.Helper:seekWidgetByName(root, "Panel_jineng_2")
		local Text_width = Text_18:getPositionX()
		local Text_height = Text_18:getPositionY()
		local pic_width = pic:getPositionX()
		local pic_height = pic:getPositionY()
		
		local label_UI = csb.createNode("utils/version_length.csb")
		local label_root = label_UI:getChildByName("root")
		local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
		local lableBaseSize = nil
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableBaseSize=Text_18:getContentSize()
		else
			lableBaseSize=lableCell:getContentSize()
		end
		local textInfo = "["..self.hero.skill_name.."]".." "..self.hero.skill_describe
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-Text_width, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		Panel_jineng_2:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
			pic:setPosition(cc.p(pic_width,pic_height))
		else
			lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
			pic:setPosition(cc.p(0,pic_height))
		end
		
		self:setContentSize(lableSize.width,lableSize.height+8)
		
	elseif self.page == 2 then
		local pic = ccui.Helper:seekWidgetByName(root, "Image_8")
		pic:setVisible(true)
		local Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18")
		local Panel_jineng_2 = ccui.Helper:seekWidgetByName(root, "Panel_jineng_2")
		local Text_width = Text_18:getPositionX()
		local Text_height = Text_18:getPositionY()
		local pic_width = pic:getPositionX()
		local pic_height = pic:getPositionY()
		
		local label_UI = csb.createNode("utils/version_length.csb")
		local label_root = label_UI:getChildByName("root")
		local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
		local lableBaseSize = nil
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableBaseSize=Text_18:getContentSize()
		else
			lableBaseSize=lableCell:getContentSize()
		end
		local level = 0
		if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
		tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(self.hero.ship_id) then
			level = _ED.hero_skillstren_info.level
		else
			level = self.hero.ship_skillstren.skill_level
		end
		local hero_data = dms.element(dms["ship_mould"], self.hero.ship_template_id)
		local skillInfos = zstring.split(dms.atos(hero_data, ship_mould.skill_mould_info),",")
		local nextSkillId = skillInfos[tonumber(level)]

		local skillNames = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_name)
		local skillNamesDes = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_describe)
		if __lua_project_id == __lua_project_gragon_tiger_gate
			or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2
			or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto 
			then
			local captain_type = dms.atoi(hero_data, ship_mould.captain_type)
			if captain_type == 0 then
				skillNames,skillNamesDes = self:getNewSkillMould()
			end
		end
		local textInfo = "["..skillNames.."]".." "..skillNamesDes
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-Text_width, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		Panel_jineng_2:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
			pic:setPosition(cc.p(pic_width,pic_height))
		else
			lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
			pic:setPosition(cc.p(0,pic_height))
		end
		
		self:setContentSize(lableSize.width,lableSize.height+8)
		
	elseif self.page == 3 then
		local zoariumSkill = dms.int(dms["ship_mould"], self.hero.ship_base_template_id, ship_mould.zoarium_skill)
		
		if _ED.hero_skillstren_info.level ~= nil and _ED.hero_skillstren_info.hero_id ~= nil and
		tonumber(_ED.hero_skillstren_info.hero_id) == tonumber(self.hero.ship_id) then
			level = _ED.hero_skillstren_info.level
		else
			level = self.hero.ship_skillstren.skill_level
		end
		
		local count = 0
		local nextSkillId = zoariumSkill
		local maxSkillLevel = tonumber(dms.string(dms["pirates_config"],276,pirates_config.param))
		for i=1,maxSkillLevel do
			count = count + 1
			if tonumber(level) == count then 
				break
			end
			if zoariumSkill == nil then 
				break
			end
			local id = dms.int(dms["skill_mould"],nextSkillId,skill_mould.next_level_skill)
			nextSkillId = id
		end

		local skillNames = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_name)
		local skillNamesDes = dms.string(dms["skill_mould"], nextSkillId, skill_mould.skill_describe)
		local person = dms.string(dms["skill_mould"], nextSkillId, skill_mould.release_mould)
		local ser = {}
		local num = 1
		for i,v in pairs(_ED.user_ship) do
				if zstring.tonumber(v.formation_index) > 0 then
					ser[num] = v.ship_base_template_id
					num = num + 1
				end
			end
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
		
		local pic = ccui.Helper:seekWidgetByName(root, "Image_9")
		pic:setVisible(true)
		local Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18")
		local Panel_jineng_2 = ccui.Helper:seekWidgetByName(root, "Panel_jineng_2")
		local Text_width = Text_18:getPositionX()
		local Text_height = Text_18:getPositionY()
		local pic_width = pic:getPositionX()
		local pic_height = pic:getPositionY()
		local label_UI = csb.createNode("utils/version_length.csb")
		local label_root = label_UI:getChildByName("root")
		local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
		
		local lableBaseSize = nil
		local widthtemp = 0
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableBaseSize=Text_18:getContentSize()
			widthtemp=20
		else
			lableBaseSize=lableCell:getContentSize()
		end
		local textInfo = "["..skillNames.."]".." "..skillNamesDes
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-pic_width - widthtemp, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		-- if unionShipActive == false then
		-- 	lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[13][1],tipStringInfo_quality_color_Type[13][2],tipStringInfo_quality_color_Type[13][3]))
		-- else
		-- 	lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		-- end
		if tunionShipActive == false then
  			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
   				lableCell:setColor(cc.c3b(179,120,68))
 			else
				lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[13][1],tipStringInfo_quality_color_Type[13][2],tipStringInfo_quality_color_Type[13][3]))
  			end
  		else
			if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
				lableCell:setColor(cc.c3b(255,110,13))
			else
				lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
			end
 		end
		Panel_jineng_2:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
	
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
			pic:setPosition(cc.p(pic_width,pic_height))
		else
			lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
			pic:setPosition(cc.p(0,pic_height))
		end

		self:setContentSize(lableSize.width,lableSize.height+8)
		
	end
end


function FormationHeroSkillTemp:onEnterTransitionFinish()

end


function FormationHeroSkillTemp:onExit()

end

function FormationHeroSkillTemp:init(hero,page)
	self.hero = hero
	self.page = page
	
    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_4_1 = csb.createNode("packs/HeroStorage/generals_information_4_1.csb")
	local root = csbGeneralsInformation_4_1:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_4_1)
	self:onUpdateDraw()
end

function FormationHeroSkillTemp:createCell()
	local cell = FormationHeroSkillTemp:new()
	cell:registerOnNodeEvent(cell)
	return cell
end