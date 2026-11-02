----------------------------------------------------------------------------------------------------
-- 说明：羁绊界面中，羁绊上面的小伙伴羁绊整合的绘制及逻辑处理
-------------------------------------------------------------------------------------------------------
FormationPartnerInfoListCell = class("formationPartnerInfoListCellClass", Window)

FormationPartnerInfoListCell.__userHeroFontName = nil

function FormationPartnerInfoListCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.ship = nil
end

function FormationPartnerInfoListCell:onUpdateDraw()
	local root = self.roots[1]
	self.size = root:getContentSize()
	self:setContentSize(self.size)
	if self.ship ~= nil then
		local _name = nil
		if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
			--进化形象
			local evo_image = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.fitSkillTwo)
			local evo_info = zstring.split(evo_image, ",")
			--进化模板id
			local ship_evo = zstring.split(self.ship.evolution_status, "|")
			local evo_mould_id = evo_info[tonumber(ship_evo[1])]
			local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
			local word_info = dms.element(dms["word_mould"], name_mould_id)
			_name = word_info[3]
		else
			_name = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name)
			if tonumber(self.ship.captain_type) == 0 then
				_name = _ED.user_info.user_name
			end
		end
		local panelName = ccui.Helper:seekWidgetByName(root, "Text_28")
		if ___is_open_leadname == true then
			if FormationPartnerInfoListCell.__userHeroFontName == nil then
				FormationPartnerInfoListCell.__userHeroFontName = panelName:getFontName()
			end
			if dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_type) == 0 then
				panelName:setFontName("")
				panelName:setFontSize(panelName:getFontSize())-->设置字体大小
			else
				panelName:setFontName(FormationPartnerInfoListCell.__userHeroFontName)
			end
		end

		panelName:setString(_name)
		local quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
		panelName:setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
		local shiPartner = ccui.Helper:seekWidgetByName(root, "Panel_41")
		local Image_39 = ccui.Helper:seekWidgetByName(root, "Image_39")
		local ditu = ccui.Helper:seekWidgetByName(root, "Image_40")
		-- ccui.Helper:seekWidgetByName(root, "Image_40"):setVisible(false)
		-- root:removeChild(shiPartner, true)
		-- local shiPartnerobj = shiPartner:clone()
		-- local relationIndex = 0
		local label_UI = csb.createNode("utils/version_length.csb")
		local label_root = label_UI:getChildByName("root")
		local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
		local lableBaseSize = lableCell:getContentSize()
		
		local showRelationName = ccui.Helper:seekWidgetByName(root, "Text_29")
		local showRelationInfo = ccui.Helper:seekWidgetByName(root, "Text_30")
		
		local nameWidth = showRelationName:getPositionX()
		local nameHeight = showRelationName:getPositionY()
		local infoWidth = showRelationInfo:getPositionX()
		local width = showRelationName:getContentSize().width
		local width2 = showRelationInfo:getContentSize().width
		local infoHeight = showRelationInfo:getPositionY()
		local sizeX = Image_39:getPositionX()
		local sizeY = Image_39:getContentSize().height
		local shiPartnerHigh = shiPartner:getPositionY()
		local shiPartnerWidth = shiPartner:getPositionX()
		
		local tipHeight = 0
		local tipHeight2 = 0
		
		
		local list = {}
		if self.ship ~= nil then
			-- 缘分过滤
			for i = 1 ,table.getn(self.ship.relationship) do
				list[i] = self.ship.relationship[i]
			end
			local function sort_is_activited(a, b)
				if zstring.tonumber(a.is_activited) > zstring.tonumber(b.is_activited) then
					return true
				end
				return false
			end
			table.sort(list, sort_is_activited)
		end
		
		for i=1, 12 do
			local relationship = list[i]
			if relationship ~= nil then
				local relationName= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_name)
				local relationInfo= dms.string(dms["fate_relationship_mould"], relationship.relationship_id, fate_relationship_mould.relation_describe)
				local num = string.utf8len(relationInfo)
				
				local textName = relationName
				local textInfo = relationInfo
				local lableCell2 = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
					lableCell:getFontSize(), cc.size(width2, 0), 
					cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
				local lableCellName = cc.Label:createWithTTF(textName, lableCell:getFontName(), 
					lableCell:getFontSize(), cc.size(width, 0), 
					cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)	
				
				if tonumber(relationship.is_activited) == 1 then
					lableCell2:setColor(cc.c3b(formation_relationship_color_Type_two[2][1],formation_relationship_color_Type_two[2][2],formation_relationship_color_Type_two[2][3]))
					lableCellName:setColor(cc.c3b(formation_relationship_color_Type_two[2][1],formation_relationship_color_Type_two[2][2],formation_relationship_color_Type_two[2][3]))
				else
					lableCell2:setColor(cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]))
					lableCellName:setColor(cc.c3b(formation_relationship_color_Type_two[1][1],formation_relationship_color_Type_two[1][2],formation_relationship_color_Type_two[1][3]))
				end
				
				
				shiPartner:addChild(lableCell2)
				shiPartner:addChild(lableCellName)
				lableCell2:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				lableCellName:setAnchorPoint(CCPoint(0, 0))-->设置锚点
				local lableSize = lableCell2:getContentSize()
				
				tipHeight = tipHeight + lableSize.height
				lableCell2:setPosition(cc.p(infoWidth, -1 * tipHeight))
				if verifySupportLanguage(_lua_release_language_en) == true then
					lableCellName:setPosition(cc.p(0, lableCell2:getPositionY() + lableSize.height - lableCellName:getContentSize().height))
				else
					lableCellName:setPosition(cc.p(0, lableCell2:getPositionY() + lableSize.height - 25))
				end
			end
		end
		showRelationName:setContentSize(cc.size(infoWidth,tipHeight + infoHeight))
		self:setContentSize(cc.size(infoWidth,infoHeight+tipHeight+15))
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			Image_39:setPosition(sizeX,shiPartnerHigh+tipHeight+panelName:getContentSize().height)
		else
			Image_39:setPosition(sizeX,shiPartnerHigh+tipHeight+panelName:getContentSize().height+20)
		end

		panelName:setPosition(panelName:getPositionX(), panelName:getContentSize().height + shiPartnerHigh+tipHeight)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			shiPartner:setPosition(shiPartnerWidth,shiPartnerHigh+tipHeight)
		else
			shiPartner:setPosition(shiPartnerHigh,shiPartnerHigh+tipHeight)
		end
		shiPartner:setPosition(shiPartnerWidth,shiPartnerHigh+tipHeight)
		ditu:setPosition(ditu:getPositionX()-50,ditu:getPositionY()-Image_39:getContentSize().height-16)
		ditu:setContentSize(ditu:getContentSize().width+90,ditu:getContentSize().height + tipHeight -Image_39:getContentSize().height-16 )
	end
end

function FormationPartnerInfoListCell:onEnterTransitionFinish()

end

function FormationPartnerInfoListCell:onInit()
	local filePath = "formation/line_up_jiban.csb"
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()
end

function FormationPartnerInfoListCell:onExit()

end

function FormationPartnerInfoListCell:init(_ship)
	self.ship = _ship
	self:onInit()
end

function FormationPartnerInfoListCell:createCell()
	local cell = FormationPartnerInfoListCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

