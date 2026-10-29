---------------------------------
---说明：时装信息界面的 技能卡
---------------------------------

FashionInfoHeroSkill = class("FashionInfoHeroSkillClass", Window)
   
function FashionInfoHeroSkill:ctor()
    self.super:ctor()
	
	self.equip = nil
	self.equip_mould = nil
	self.info = {}
	app.load("client.cells.fashion.fashion_info_skill_temp_cell")
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	local function init_formation_hero_skill_terminal()

		state_machine.init()
	end
	init_formation_hero_skill_terminal()
end

function FashionInfoHeroSkill:onUpdateDraw()
	local root = self.roots[1]
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_fashion_shuoming")
	local panelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_fashion_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_fashion_14")
	
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	local Panel_shuoming_width = panelGeneralsEquipment:getContentSize().width
	local Panel_shuoming_height = panelGeneralsEquipment:getContentSize().height

	local equip = self.equip
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
				cell:init(self.info,1)
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
				cell:init(self.info,2)
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
				cell:init(self.info,3,isopen)
				local size = cell:getContentSize()
				-- cell:setPosition(cc.p(Text_shuoming:getPositionX(), Text_height-AllSize))
				AllSize = AllSize + size.height

				Panel_14:addChild(cell)
				cell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				cell:setPosition(cc.p(Text_shuoming:getPositionX(), -1 * AllSize))
			end
		
		end
	end
	panelGeneralsEquipment:setContentSize(cc.size(Panel_shuoming_width, Panel_shuoming_height+AllSize))

	self:setContentSize(cc.size(Panel_shuoming_width,Panel_shuoming_height+AllSize+5))
	Panel_14:setPosition(Panel_14:getPositionX(), Panel_14:getPositionY() + AllSize)

	panelGeneralsEquipment:setPosition(panelGeneralsEquipment:getPositionX(), panelGeneralsEquipment:getPositionY() + AllSize)
end

function FashionInfoHeroSkill:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_7 = csb.createNode("packs/EquipStorage/equipment_information_list_7.csb")
	local root = csbGeneralsInformation_7:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_7)

	ccui.Helper:seekWidgetByName(root, "Text_fashion_ti"):setString(_string_piece_info[43])

	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_fashion_shuoming")
	self:setContentSize(cc.size(PanelGeneralsEquipment:getContentSize().width, PanelGeneralsEquipment:getContentSize().height))
	
	self:onUpdateDraw()
	
end


function FashionInfoHeroSkill:onExit()
	-- state_machine.remove("get_special_skill")
end

function FashionInfoHeroSkill:init(equip,mouldid)
	self.equip = equip
	self.equip_mould = mouldid
end

function FashionInfoHeroSkill:createCell()
	local cell = FashionInfoHeroSkill:new()
	cell:registerOnNodeEvent(cell)
	return cell
end