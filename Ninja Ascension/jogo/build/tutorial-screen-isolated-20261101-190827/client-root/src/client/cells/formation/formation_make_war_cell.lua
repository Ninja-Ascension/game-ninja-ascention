----------------------------------------------------------------------------------------------------
-- 说明：开战的 相克布阵小图标角色
-------------------------------------------------------------------------------------------------------
FormationMakeWarCell = class("FormationMakeWarCellClass", Window)
FormationMakeWarCell.__userHeroFontName = nil

function FormationMakeWarCell:ctor()
    self.super:ctor()

    -- 定义封装类中的变量
	self.roots = {}		-- 界面中的UI根节点，供模块获取界面中的UI元素实例
	self.ship = nil
	self.actions = {}
end

function FormationMakeWarCell:onUpdateDraw()
	local root = self.roots[1]

	local ship_template_id = nil
	local name = nil
	local quality = nil
	local capacity = nil -- 驱逐航母
	local picIndex = nil
	local shipmould = nil
	if self.ship ~= nil then
		ship_template_id = self.ship.ship_template_id
		shipmould = self.ship.ship_template_id
		name = dms.string(dms["ship_mould"], self.ship.ship_template_id, ship_mould.captain_name)
		if tonumber(self.ship.captain_type) == 0 then
			name = _ED.user_info.user_name
		end
		quality = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.ship_type) + 1
		
		-- capacity = dms.int(dms["ship_mould"], tonumber(self.ship.ship_base_template_id), ship_mould.capacity)
		if __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge
			then
			capacity = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.faction_id)
		else
			capacity = dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.capacity)
		end
		
		picIndex = dms.int(dms["ship_mould"], self.ship.ship_template_id, ship_mould.All_icon)+1000
		if __lua_project_id == __lua_project_warship_girl_a or __lua_project_id == __lua_project_warship_girl_b or __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto or __lua_project_id == __lua_project_pokemon 
			or __lua_project_id == __lua_project_rouge or __lua_project_id == __lua_project_yugioh then
			if dms.int(dms["ship_mould"], tonumber(self.ship.ship_template_id), ship_mould.captain_type) == 0 then
				local fashionEquip, pic = getUserFashion()
				if fashionEquip ~= nil and pic ~= nil then
					picIndex = pic + 1000
				end
			end
		end
		
		if ___is_open_leadname == true then
			if FormationMakeWarCell.__userHeroFontName == nil then
				FormationMakeWarCell.__userHeroFontName = ccui.Helper:seekWidgetByName(root, "Label_name"):getFontName()
			end

			if zstring.tonumber(shipmould) > 0 and dms.int(dms["ship_mould"], tonumber(shipmould), ship_mould.captain_type) == 0 then
				local Label_name = ccui.Helper:seekWidgetByName(root, "Label_name")
				Label_name:setFontName("")
				Label_name:setFontSize(Label_name:getFontSize())-->设置字体大小
			else
				ccui.Helper:seekWidgetByName(root, "Label_name"):setFontName(FormationMakeWarCell.__userHeroFontName)
			end
		end
	else
		local item = _ED.camp_preference_info.data[self.index]
		name = item.hero_name --dms.string(dms["ship_mould"], tonumber(item.hero_id), ship_mould.captain_name) 
		quality = tonumber(item.hero_quality)+1
		
		capacity = tonumber(item.hero_capacity) --dms.int(dms["ship_mould"], tonumber(item.hero_id), ship_mould.capacity) 
		picIndex = item.hero_pic
		shipmould = item.ship_type
	end

		-- local info = {}
	-- info.count = zstring.tonumber(npos(list))
	-- info.data = {}
	-- -- 人数
	-- -- 英雄id 英雄位置 英雄头像 英雄品质 角色类型(0:用户 1:环境卡片) 船只模板id(船只模板/环境战船)
	-- for i = 1, info.count do
		-- local item = {
			-- hero_id = npos(list),
			-- hero_location = npos(list),
			-- hero_pic = npos(list),
			-- hero_quality = npos(list),
			-- hero_type = npos(list),
			-- ship_type = npos(list),
		-- }
	
		-- table.insert(info.data, item)
	-- end
	
	-- _ED.camp_preference_info = info
	
	local shipImage = ccui.Helper:seekWidgetByName(root, "Panel_prop")
	
	shipImage:setBackGroundImage(string.format("images/ui/props/props_%d.png", picIndex))
	
	local panel_kuang = ccui.Helper:seekWidgetByName(root, "Panel_kuang")
	panel_kuang:setBackGroundImage(string.format("images/ui/quality/icon_enemy_%d.png", quality))
	
	local panel_ditu = ccui.Helper:seekWidgetByName(root, "Panel_ditu")
	panel_ditu:setBackGroundImage("images/ui/quality/icon_enemy_0.png")
	
	ccui.Helper:seekWidgetByName(root, "Label_name"):setString(name)
	ccui.Helper:seekWidgetByName(root, "Label_name"):setColor(cc.c3b(tipStringInfo_quality_color_Type[quality][1],tipStringInfo_quality_color_Type[quality][2],tipStringInfo_quality_color_Type[quality][3]))
	
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
	else	
		local panel_zhenying = ccui.Helper:seekWidgetByName(root, "Panel_zhenying")
		panel_zhenying:setBackGroundImage(string.format("images/ui/quality/pve_leixing_%d.png", capacity))
	end
	
	self:setTouchEnabled(true)
end

	
function FormationMakeWarCell:showEnhance()
	local root = self.roots[1]
	--local action = self.actions[1]
	local action = csb.createTimeline("battle/item_vs.csb")	
	root:runAction(action)
	action:play("image_xiangke", false)
	
	self.enhanceSign:setVisible(true)
	self.weakenSign:setVisible(false)
end

function FormationMakeWarCell:showWeaken()
	local root = self.roots[1]
	--local action = self.actions[1]
	local action = csb.createTimeline("battle/item_vs.csb")	
	root:runAction(action)
	action:play("image_beike", false)
	
	self.enhanceSign:setVisible(false)
	self.weakenSign:setVisible(true)
end				
			
function FormationMakeWarCell:hideSign()
	self.enhanceSign:setVisible(false)
	self.weakenSign:setVisible(false)
end	
			
				

function FormationMakeWarCell:onEnterTransitionFinish()
	local filePath = "battle/item_vs.csb" 
	local csbItem = csb.createNode(filePath)
	local root = csbItem:getChildByName("root")
	root:removeFromParent(false)
	self:addChild(root)
	table.insert(self.roots, root)
	self:onUpdateDraw()

	local action = csb.createTimeline("battle/item_vs.csb")	
	table.insert(self.actions, action )
	
	
	self.weakenSign = ccui.Helper:seekWidgetByName(root, "Image_1")
	self.enhanceSign = ccui.Helper:seekWidgetByName(root, "Image_2")
	-- action:setFrameEventCallFunc(function (frame)
		-- if nil == frame then
			-- return
		-- end

		-- local str = frame:getEvent()
		-- if str == "open" then
		-- elseif str == "close" then
		
		-- end
	-- end)
	
end

function FormationMakeWarCell:onExit()

end

function FormationMakeWarCell:init(_ship, _index)
	
	self.index = _index
	
	self.ship = _ship
	
end

function FormationMakeWarCell:createCell()
	local cell = FormationMakeWarCell:new()
	cell:registerOnNodeEvent(cell)
	return cell
end

