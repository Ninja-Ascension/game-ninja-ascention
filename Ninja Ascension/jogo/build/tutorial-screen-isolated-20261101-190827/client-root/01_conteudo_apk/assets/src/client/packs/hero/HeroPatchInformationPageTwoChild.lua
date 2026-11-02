-- ----------------------------------------------------------------------------------------------------
-- 说明：游戏中的武将碎片信息界面2下拉列表子界面
-------------------------------------------------------------------------------------------------------
HeroPatchInformationPageTwoChild = class("HeroPatchInformationPageTwoChildClass", Window)

function HeroPatchInformationPageTwoChild:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.page = nil
	self.texts = {}
	app.load("client.cells.ship.ship_hero_skill_temp_in_patch_cell")
	app.load("client.cells.ship.ship_hero_skill_temp_in_patch_cell")
end

function HeroPatchInformationPageTwoChild:onUpdateDrawLot()		--缘分
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")	-- 
	Text_biaoti:setString(_string_piece_info[37])
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	
	-- ship.relationship_count 缘分数量
	local frameAddCount = 18	--字体间距
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local sizeX = PanelGeneralsEquipment:getContentSize().width
	local sizeY = PanelGeneralsEquipment:getContentSize().height
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	local tipHeight = 0
	
	for i, v in pairs(self.texts) do
		local colorIndex = v[1]
		local textInfo = "[" .. v[2] .. "]" .. " " .. v[3]
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width*0.9, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			
		-- if tonumber(colorIndex) == 0 then
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
		Panel_14:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		tipHeight = tipHeight + lableSize.height
		lableCell:setPosition(cc.p(lableCell:getPositionX()+10, -1 * tipHeight))
		
	end
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY-Image_18:getContentSize().height))
	self:setContentSize(cc.size(sizeX,sizeY+tipHeight))
	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight-Image_18:getContentSize().height)
	
end

function HeroPatchInformationPageTwoChild:onUpdateDrawTalent()
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")	-- 
	Text_biaoti:setString(_string_piece_info[38])
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	
	local frameAddCount = 18	--字体间距
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local sizeX = PanelGeneralsEquipment:getContentSize().width
	local sizeY = PanelGeneralsEquipment:getContentSize().height
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	local tipHeight = 0
	
	for i, v in pairs(self.texts) do
		local colorIndex = v[1]
		local textInfo = "[" .. v[2] .. "]" .. " " .. v[3] .. "(" .. _string_piece_info[51] .."+" .. i .. _string_piece_info[52] ..")"
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width*0.9, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			
		-- if tonumber(colorIndex) == 0 then
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
		Panel_14:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		tipHeight = tipHeight + lableSize.height
		lableCell:setPosition(cc.p(lableCell:getPositionX()+10, -1 * tipHeight))
	end
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY-Image_18:getContentSize().height))
	self:setContentSize(cc.size(sizeX,sizeY+tipHeight))
	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight-Image_18:getContentSize().height)
end

function HeroPatchInformationPageTwoChild:onUpdateDrawExplain()
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")
	local panel = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local sizeX = PanelGeneralsEquipment:getContentSize().width
	local sizeY = PanelGeneralsEquipment:getContentSize().height
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	local tipHeight = 0
	
	local textInfo = dms.string(dms["ship_mould"], self.hero, ship_mould.introduce)

	local captain_type = dms.int(dms["ship_mould"], self.hero, ship_mould.captain_type)
	if captain_type == 3 then
	--宠物 
		Text_biaoti:setString(_pet_tipString_info[2])
	else
		Text_biaoti:setString(_string_piece_info[39])
	end
	
	local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width*0.9, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		or __lua_project_id == __lua_project_rouge 
		or __lua_project_id == __lua_project_yugioh 
		then
		lableCell:setColor(cc.c3b(234,212,155))
	end
	Panel_14:addChild(lableCell)
	lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
	local lableSize = lableCell:getContentSize()
	
	tipHeight = tipHeight + lableSize.height
	lableCell:setPosition(cc.p(lableCell:getPositionX()+10, -1 * tipHeight))
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY-Image_18:getContentSize().height))
	self:setContentSize(cc.size(sizeX,sizeY+tipHeight))
	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight-Image_18:getContentSize().height)
end

function HeroPatchInformationPageTwoChild:onUpdateinfo()
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")	-- 
	-- Text_biaoti:setString(_string_piece_info[37])
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Image_20 = ccui.Helper:seekWidgetByName(root, "Image_20")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	Image_18:setVisible(false)
	Image_20:setVisible(false)
	-- ship.relationship_count 缘分数量
	local frameAddCount = 18	--字体间距
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local sizeX = PanelGeneralsEquipment:getContentSize().width
	local sizeY = PanelGeneralsEquipment:getContentSize().height
	local a = Image_18:getContentSize().width
	local b = Image_18:getContentSize().height
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = lableCell:getContentSize()
	local tipHeight = 0
	
	for i, v in pairs(self.texts) do
		local colorIndex = v[1]
		local textInfo = "[" .. v[2] .. "]" .. " " .. v[3]
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width*0.9, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
			
		if tonumber(colorIndex) == 0 then
			lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[13][1],tipStringInfo_quality_color_Type[13][2],tipStringInfo_quality_color_Type[13][3]))
		else
			lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
		end
		if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
			or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge 
			or __lua_project_id == __lua_project_yugioh 
			then
			lableCell:setColor(cc.c3b(234,212,155))
		end
		Panel_14:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		tipHeight = tipHeight + lableSize.height
		lableCell:setPosition(cc.p(lableCell:getPositionX()+10, -1 * tipHeight))
		
	end
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY-Image_18:getContentSize().height-b))
	self:setContentSize(cc.size(sizeX,sizeY+tipHeight-b))
	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight-Image_18:getContentSize().height)
end

function HeroPatchInformationPageTwoChild:onUpdateSkill()
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")	-- 
	Text_biaoti:setString(_string_piece_info[43])
	local panelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Image_20 = ccui.Helper:seekWidgetByName(root, "Image_20")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	local Panel_shuoming_width = panelGeneralsEquipment:getContentSize().width
	local Panel_shuoming_height = panelGeneralsEquipment:getContentSize().height
	
	local AllSize = 0
	for i = 1, 3 do
		if i <= 2 then
			local cell = FormationHeroSkillTempInPatch:createCell()
			cell:init(self.hero,i)
			local size = cell:getContentSize()
			cell:setPosition(cc.p(Text_width,Text_height-AllSize))
			AllSize = AllSize + size.height
			Panel_14:addChild(cell)
		elseif i==3 then
			local zoariumSkill = dms.int(dms["ship_mould"], self.hero, ship_mould.zoarium_skill)
			if zoariumSkill ~= -1 then
				local cell = FormationHeroSkillTempInPatch:createCell()
				cell:init(self.hero,i)
				local size = cell:getContentSize()
				cell:setPosition(cc.p(Text_width,Text_height-AllSize))
				AllSize = AllSize + size.height
				Panel_14:addChild(cell)
			end
		end
	end
	panelGeneralsEquipment:setContentSize(cc.size(Panel_shuoming_width, Panel_shuoming_height+AllSize-Image_18:getContentSize().height))
	Panel_14:setPosition(Panel_14:getPositionX(), Panel_14:getPositionY() + AllSize-Image_18:getContentSize().height)
	self:setContentSize(cc.size(Panel_shuoming_width,Panel_shuoming_height + AllSize-20))
	panelGeneralsEquipment:setPosition(panelGeneralsEquipment:getPositionX(), panelGeneralsEquipment:getPositionY()-Image_18:getContentSize().height+20)
	Image_18:setPosition(cc.p(Image_18:getPositionX(),Image_18:getPositionY()+20))
	Image_20:setPosition(cc.p(Image_20:getPositionX(),Image_20:getPositionY()+20))
	Text_biaoti:setPosition(cc.p(Text_biaoti:getPositionX(),Text_biaoti:getPositionY()+20))
end

function HeroPatchInformationPageTwoChild:onEnterTransitionFinish()
	local csbHeroPatchInformationPageTwoChild= csb.createNode("packs/generals_tanchuangtxt.csb")
	
    self:addChild(csbHeroPatchInformationPageTwoChild)
	local root = csbHeroPatchInformationPageTwoChild:getChildByName("root")
	table.insert(self.roots, root)
	self.oSize = root:getContentSize()
	
	
	if self.page == 1 then
		self:onUpdateDrawLot()
	elseif self.page == 2 then
		self:onUpdateDrawTalent()
	elseif self.page == 3 then
		self:onUpdateDrawExplain()
	elseif self.page == 4 then
		self:onUpdateinfo()
	elseif self.page == 0 then
		self:onUpdateSkill()
	end
	
	self.size = self:getContentSize()
	
	csbHeroPatchInformationPageTwoChild:setPosition(cc.p(0, self.size.height - self.oSize.height))
end

function HeroPatchInformationPageTwoChild:onExit()

end

function HeroPatchInformationPageTwoChild:init(hero, page, text)
	self.hero = hero	--模板id
	self.texts = text
	self.page = page
end

function HeroPatchInformationPageTwoChild:createCell()
	local cell = HeroPatchInformationPageTwoChild:new()
	cell:registerOnNodeEvent(cell)
	return cell
end