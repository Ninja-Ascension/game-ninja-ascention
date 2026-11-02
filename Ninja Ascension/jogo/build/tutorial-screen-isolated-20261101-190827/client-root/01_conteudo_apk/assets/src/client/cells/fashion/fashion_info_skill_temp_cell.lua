---------------------------------
---说明：武将信息界面的 技能卡子界面
---------------------------------

FashionInfoHeroSkillTemp = class("FashionInfoHeroSkillTempClass", Window)
   
function FashionInfoHeroSkillTemp:ctor()
    self.super:ctor()
	self.info = nil
	self.page = nil
	self.isopen = false
	self.listPositionX = 0
	-- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例

end

function FashionInfoHeroSkillTemp:onUpdateDraw()
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
		local textInfo = "["..self.info[1].."]".." "..self.info[2]
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-Text_width -self.listPositionX, 0), 
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
		Panel_jineng_2:setPosition(Panel_jineng_2:getPositionX(), Panel_jineng_2:getPositionY() + lableSize.height)
		
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
		
		local textInfo = "["..self.info[3].."]".." "..self.info[4]
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-Text_width - self.listPositionX, 0), 
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
		Panel_jineng_2:setPosition(Panel_jineng_2:getPositionX(), Panel_jineng_2:getPositionY() + lableSize.height)
	elseif self.page == 3 then
	
		
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
		local textInfo = "["..self.info[5] .."]".." "..self.info[6]
		local lableCell = cc.Label:createWithTTF(textInfo, lableCell:getFontName(), 
				lableCell:getFontSize(), cc.size(lableBaseSize.width-pic_width - widthtemp - self.listPositionX, 0), 
				cc.VERTICAL_TEXT_ALIGNMENT_TOP, cc.VERTICAL_TEXT_ALIGNMENT_TOP)
		if self.isopen == false then
			lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[13][1],tipStringInfo_quality_color_Type[13][2],tipStringInfo_quality_color_Type[13][3]))
		else
			lableCell:setColor(cc.c3b(tipStringInfo_quality_color_Type[14][1],tipStringInfo_quality_color_Type[14][2],tipStringInfo_quality_color_Type[14][3]))
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
		Panel_jineng_2:setPosition(Panel_jineng_2:getPositionX(), Panel_jineng_2:getPositionY() + lableSize.height)
	end
end


function FashionInfoHeroSkillTemp:onEnterTransitionFinish()

end


function FashionInfoHeroSkillTemp:onExit()

end

function FashionInfoHeroSkillTemp:init(info,page,isopen,listPositionX)
	self.info = info
	self.page = page
	self.isopen = isopen
	if listPositionX ~= nil then
		self.listPositionX = zstring.tonumber(listPositionX)
	else
		self.listPositionX = 0
	end
	
    --获取 武将碎片选项卡 美术资源
    local csbGeneralsInformation_4_1 = csb.createNode("packs/HeroStorage/generals_information_4_1.csb")
	local root = csbGeneralsInformation_4_1:getChildByName("root")
	table.insert(self.roots, root)
    self:addChild(csbGeneralsInformation_4_1)
	self:onUpdateDraw()
end

function FashionInfoHeroSkillTemp:createCell()
	local cell = FashionInfoHeroSkillTemp:new()
	cell:registerOnNodeEvent(cell)
	return cell
end