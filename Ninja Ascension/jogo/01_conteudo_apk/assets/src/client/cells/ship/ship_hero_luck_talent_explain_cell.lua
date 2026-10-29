---------------------------------
---说明：武将信息界面的 缘分、天赋、技能卡
-- 创建时间:2015.03.17
-- 作者：刘毅
-- 修改记录：
-- 最后修改人：
---------------------------------
-- formation_hero_luck_talent_explain_cell.lua

HeroLuckTalentExplain = class("HeroLuckTalentExplainClass", Window)
   
function HeroLuckTalentExplain:ctor()
    self.super:ctor()
	self.hero = nil
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.page = nil
	self.texts = {}
end

function HeroLuckTalentExplain:onUpdateDrawLot() --缘分
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")	-- 
	Text_biaoti:setString(_string_piece_info[37])
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	
	-- ship.relationship_count 缘分数量
	-- local frameAddCount = 18	--字体间距
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local sizeX = PanelGeneralsEquipment:getContentSize().width
	local sizeY = PanelGeneralsEquipment:getContentSize().height
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	local lableBaseSize = nil 
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		lableBaseSize = Text_shuoming:getContentSize()
	else
		lableBaseSize = lableCell:getContentSize()
	end
	local tipHeight = 0
	for i, v in pairs(self.texts) do
		local colorIndex = v[1]
		local textInfo = "[" .. v[2] .. "]" .. " " .. v[3]
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		if tonumber(colorIndex) == 0 then
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
		lableCell:setString(textInfo)
		Panel_14:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		tipHeight = tipHeight + lableSize.height
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableCell:setPosition(cc.p(lableCell:getPositionX()+30, -1 * tipHeight+15))
		else
			lableCell:setPosition(cc.p(lableCell:getPositionX()+10, -1 * tipHeight))
		end
	end
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY-Image_18:getContentSize().height))
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self:setContentSize(cc.size(sizeX,sizeY+tipHeight-30))
	else
		self:setContentSize(cc.size(sizeX,sizeY+tipHeight+5))
	end	
	
	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight-Image_18:getContentSize().height)
end

function HeroLuckTalentExplain:onUpdateDrawTalent() --天赋
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")	-- 
	Text_biaoti:setString(_string_piece_info[38])
	local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
	local Image_18 = ccui.Helper:seekWidgetByName(root, "Image_18")
	local Panel_14 = ccui.Helper:seekWidgetByName(root, "Panel_14")
	
	-- local frameAddCount = 18	--字体间距
	local Text_width = Text_shuoming:getPositionX()
	local Text_height = Text_shuoming:getPositionY()
	local sizeX = PanelGeneralsEquipment:getContentSize().width
	local sizeY = PanelGeneralsEquipment:getContentSize().height
	local Panel_14_high = Panel_14:getPositionY()
	local Panel_14_width = Panel_14:getPositionX()
	
	local label_UI = csb.createNode("utils/version_length.csb")
	local label_root = label_UI:getChildByName("root")
	local lableCell = ccui.Helper:seekWidgetByName(label_root, "Text_2")
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		lableBaseSize = Text_shuoming:getContentSize()
	else
		lableBaseSize = lableCell:getContentSize()
	end
	local tipHeight = 0
	for i, v in pairs(self.texts) do
		local colorIndex = v[1]
		--> print(v[1],v[2],v[3])
		local textInfo = "[" .. v[2] .. "]" .. " " .. v[3] .. "(" .. _string_piece_info[51] .."+" .. i .. _string_piece_info[52] ..")"
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		if tonumber(colorIndex) == 0 then
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
		Panel_14:addChild(lableCell)
		lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
		local lableSize = lableCell:getContentSize()
		
		tipHeight = tipHeight + lableSize.height
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
			lableCell:setPosition(cc.p(lableCell:getPositionX()+30, -1 * tipHeight+15))
		else
			lableCell:setPosition(cc.p(lableCell:getPositionX()+10, -1 * tipHeight))
		end
	end
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY-Image_18:getContentSize().height))
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self:setContentSize(cc.size(sizeX,sizeY+tipHeight-30))
	else
		self:setContentSize(cc.size(sizeX,sizeY+tipHeight+5))
	end	
	
	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight-Image_18:getContentSize().height)
end

function HeroLuckTalentExplain:onUpdateDrawExplain() --武将说明
	local root = self.roots[1]
	local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
	local Text_shuoming = ccui.Helper:seekWidgetByName(root, "Text_shuoming")
	Text_biaoti:setString(_string_piece_info[39])
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
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		lableBaseSize = Text_shuoming:getContentSize()
	else
		lableBaseSize = lableCell:getContentSize()
	end
	local tipHeight = 0
	local captain_type = dms.int(dms["ship_mould"], self.hero.ship_template_id, ship_mould.captain_type)
	if captain_type == 3 then 
		Text_biaoti:setString(_pet_tipString_info[2])
	else
		Text_biaoti:setString(_string_piece_info[39])
	end
	
	local textInfo = dms.string(dms["ship_mould"], self.hero.ship_template_id, ship_mould.introduce)
	local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
			lableCell:getFontSize(), cc.size(lableBaseSize.width, 0), 
			cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
	lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[12][1],tipStringInfo_quality_color_Type[12][2],tipStringInfo_quality_color_Type[12][3]))
	Panel_14:addChild(lableCell)
	lableCell:setAnchorPoint(CCPoint(0, 0))-->设置锚点
	local lableSize = lableCell:getContentSize()
		
	tipHeight = tipHeight + lableSize.height

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then	
		lableCell:setPosition(cc.p(lableCell:getPositionX()+30, -1 * tipHeight+15))
	else
		lableCell:setPosition(cc.p(lableCell:getPositionX()+10, -1 * tipHeight))
	end
	PanelGeneralsEquipment:setContentSize(cc.size(sizeX,tipHeight + sizeY-Image_18:getContentSize().height))
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		self:setContentSize(cc.size(sizeX,sizeY+tipHeight-10 ))
	else
		self:setContentSize(cc.size(sizeX,sizeY+tipHeight+5))
	end	
	
	Panel_14:setPosition(Panel_14_width,Panel_14_high+tipHeight-Image_18:getContentSize().height)
end

function HeroLuckTalentExplain:onEnterTransitionFinish()

    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_6 = csb.createNode("packs/HeroStorage/generals_information_6.csb")
	local root = csbGeneralsInformation_6:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_6)
	self.oSize = root:getContentSize()
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then			--龙虎门项目控制
		if self.hero == nil then
			local Text_biaoti = ccui.Helper:seekWidgetByName(root, "Text_biaoti")		--标题
			local PanelGeneralsEquipment = ccui.Helper:seekWidgetByName(root, "Panel_shuoming")
			if self.page == 4 then
				Text_biaoti:setString(_string_piece_info[37])
			elseif self.page == 5 then
				Text_biaoti:setString(_string_piece_info[38])
			elseif self.page == 6 then
				Text_biaoti:setString(_string_piece_info[39])
			end
			self:setContentSize(cc.size(PanelGeneralsEquipment:getContentSize().width,PanelGeneralsEquipment:getContentSize().height))
			return
		end
	end
	if self.page == 4 then
		self:onUpdateDrawLot()
	elseif self.page == 5 then
		self:onUpdateDrawTalent()
	elseif self.page == 6 then
		self:onUpdateDrawExplain()
	end
	
	
	self.size = self:getContentSize()
	-- local layer = cc.LayerGradient:create(cc.c4b(255,0,0,255), cc.c4b(0,255,0,255), cc.p(0.9, 0.9))
	-- layer:setContentSize(cc.size(self.size.width+ 5, self.size.height))
	-- self:addChild(layer, -1000)
	
	csbGeneralsInformation_6:setPosition(cc.p(0, self.size.height - self.oSize.height))
end

function HeroLuckTalentExplain:onExit()

end

function HeroLuckTalentExplain:init(hero, page, text)
	self.hero = hero
	self.texts = text
	self.page = page
end

function HeroLuckTalentExplain:createCell()
	local cell = HeroLuckTalentExplain:new()
	cell:registerOnNodeEvent(cell)
	return cell
end