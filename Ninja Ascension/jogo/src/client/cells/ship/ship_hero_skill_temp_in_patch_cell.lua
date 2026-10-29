---------------------------------
---说明：武将碎片信息界面的 技能卡子界面
-- 创建时间:
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
---------------------------------

FormationHeroSkillTempInPatch = class("FormationHeroSkillTempInPatchClass", Window)
   
function FormationHeroSkillTempInPatch:ctor()
    self.super:ctor()
	self.hero = nil
	self.page = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

end

function FormationHeroSkillTempInPatch:onUpdateDraw()
	local root = self.roots[1]
	if self.page == 1 then
		local pic = ccui.Helper:seekWidgetByName(root, "Image_7_8")
		pic:setVisible(true)
		local Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18_4")
		local Panel_jineng_2 = ccui.Helper:seekWidgetByName(root, "Panel_jineng_2_6")
		local Text_width = Text_18:getPositionX()
		local Text_height = Text_18:getPositionY()
		local pic_width = pic:getPositionX()
		local pic_height = pic:getPositionY()
		
		local label_UI = csb.createNode("utils/version_length.csb")
		local label_root = label_UI:getChildByName("root")
		local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
		local lableBaseSize = lableCell:getContentSize()
		local id = dms.string(dms["ship_mould"], self.hero, ship_mould.skill_mould)
		local skill_name = dms.string(dms["skill_mould"], id, skill_mould.skill_name)
		local skill_describe = dms.string(dms["skill_mould"], id, skill_mould.skill_describe)
		local textInfo = "["..skill_name.."]".." "..skill_describe
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-Text_width-30, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			lableCell:setColor(cc.c3b(234,212,155))
		end
		Panel_jineng_2:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
		pic:setPosition(cc.p(0,pic_height))
		
		self:setContentSize(lableSize.width,lableSize.height+8)
		
	elseif self.page == 2 then
		local pic = ccui.Helper:seekWidgetByName(root, "Image_8_10")
		pic:setVisible(true)
		local Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18_4")
		local Panel_jineng_2 = ccui.Helper:seekWidgetByName(root, "Panel_jineng_2_6")
		local Text_width = Text_18:getPositionX()
		local Text_height = Text_18:getPositionY()
		local pic_width = pic:getPositionX()
		local pic_height = pic:getPositionY()
		
		local label_UI = csb.createNode("utils/version_length.csb")
		local label_root = label_UI:getChildByName("root")
		local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
		local lableBaseSize = lableCell:getContentSize()
		local id = dms.string(dms["ship_mould"], self.hero, ship_mould.deadly_skill_mould)
		local skill_name = dms.string(dms["skill_mould"], id, skill_mould.skill_name)
		local skill_describe = dms.string(dms["skill_mould"], id, skill_mould.skill_describe)
		local textInfo = "["..skill_name.."]".." "..skill_describe
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-Text_width-30, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			lableCell:setColor(cc.c3b(234,212,155))
		end
		Panel_jineng_2:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
		pic:setPosition(cc.p(0,pic_height))
		
		self:setContentSize(lableSize.width,lableSize.height+8)
		
	elseif self.page == 3 then
		local zoariumSkill = dms.int(dms["ship_mould"], self.hero, ship_mould.zoarium_skill)
		local skillName = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.skill_name)
		local skillDescribe = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.skill_describe)
		local person = dms.string(dms["skill_mould"], zoariumSkill, skill_mould.release_mould)
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
		
		local pic = ccui.Helper:seekWidgetByName(root, "Image_9_12")
		pic:setVisible(true)
		local Text_18 = ccui.Helper:seekWidgetByName(root, "Text_18_4")
		local Panel_jineng_2 = ccui.Helper:seekWidgetByName(root, "Panel_jineng_2_6")
		local Text_width = Text_18:getPositionX()
		local Text_height = Text_18:getPositionY()
		local pic_width = pic:getPositionX()
		local pic_height = pic:getPositionY()
		local label_UI = csb.createNode("utils/version_length.csb")
		local label_root = label_UI:getChildByName("root")
		local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
		local lableBaseSize = lableCell:getContentSize()
		local textInfo = "["..skillName.."]".." "..skillDescribe
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-pic_width-60, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		-- if unionShipActive == false then
			-- lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[13][1],tipStringInfo_quality_color_Type[13][2],tipStringInfo_quality_color_Type[13][3]))
		-- else
		lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			lableCell:setColor(cc.c3b(234,212,155))
		end
		-- end
		Panel_jineng_2:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		lableCell:setPosition(cc.p(Text_width-pic_width, Text_height+16-lableSize.height))
		pic:setPosition(cc.p(0,pic_height))
		
		self:setContentSize(lableSize.width,lableSize.height+8)
		
	end
end


function FormationHeroSkillTempInPatch:onEnterTransitionFinish()

end


function FormationHeroSkillTempInPatch:onExit()

end

function FormationHeroSkillTempInPatch:init(hero,page)
	self.hero = hero		--模板id
	self.page = page
	
    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_4_2 = csb.createNode("packs/generals_information_4_2.csb")
	local root = csbGeneralsInformation_4_2:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_4_2)
	self:onUpdateDraw()
end

function FormationHeroSkillTempInPatch:createCell()
	local cell = FormationHeroSkillTempInPatch:new()
	cell:registerOnNodeEvent(cell)
	return cell
end