-- ----------------------------------------------------------------------------------------------------
-- 说明：图鉴cell
-- 创建时间
-- 作者：邓啸宇
-- 修改记录：
-- 最后修改人：
-------------------------------------------------------------------------------------------------------
CatalogueStorageList = class("CatalogueStorageListClass", Window)
	
function CatalogueStorageList:ctor()
    self.super:ctor()
    self.roots = {}
	self.ship = nil
	self.num = 0
	self.allHero = {}
	self.hero_panel = {}
    -- Initialize CatalogueStorage page state machine.
    local function init_catalogue_storage_terminal()
        local catalogue_show_info_click_head_terminal = {
            _name = "catalogue_show_info_click_head",
            _init = function (terminal) 
                
            end,
            _inited = false,
            _instance = self,
            _state = 0,
            _invoke = function(terminal, instance, params)
			
				state_machine.excute("shortcut_function_goto_log", 0, shortcut.shortcut_function_back_scene_enum.Home)
			
				app.load("client.packs.hero.HeroPatchInformation")
				local cell = HeroPatchInformation:new()
				cell:init(params._datas._id, nil , nil, 2)
				fwin:open(cell, fwin._windows)
				return true
            end,
            _terminal = nil,
            _terminals = nil
        }
	
        state_machine.add(catalogue_show_info_click_head_terminal)
        state_machine.init()
    end
    
    -- call func init hom state machine.
    init_catalogue_storage_terminal()
end

function CatalogueStorageList:onHeadDraw(id)
	local csbItem = csb.createNode("icon/item.csb")
	local roots = csbItem:getChildByName("root")
	roots:removeFromParent(true)
	local Panel_kuang = ccui.Helper:seekWidgetByName(roots, "Panel_kuang")
	local Panel_head = ccui.Helper:seekWidgetByName(roots, "Panel_prop")
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		if Panel_head ~= nil then
	        Panel_head:removeAllChildren(true)
	        Panel_head:removeBackGroundImage()
	    end
	    if Panel_kuang ~= nil then
	        Panel_kuang:removeAllChildren(true)
	        Panel_kuang:removeBackGroundImage()
	    end
    end
	local name = ccui.Helper:seekWidgetByName(roots, "Label_name")
	local quality = dms.int(dms["ship_mould"], id, ship_mould.ship_type)
	local pic = dms.int(dms["ship_mould"], id, ship_mould.head_icon)
	local quality_path = nil
	local big_icon_path = string.format("images/ui/props/props_%s.png", pic)
	local background = cc.Sprite:create(big_icon_path)
	background:setAnchorPoint(cc.p(0.5, 0.5))
	background:setPosition(cc.p(Panel_head:getContentSize().width/2, Panel_head:getContentSize().height/2))
	Panel_head:addChild(background)
	
	if __lua_project_id == __lua_project_digimon_adventure or __lua_project_id == __lua_project_naruto 
		or __lua_project_id == __lua_project_pokemon 
		then 
		local next_ship_id = dms.int(dms["ship_mould"], id, ship_mould.way_of_gain)
		Panel_head:setSwallowTouches(false)
		ccui.Helper:seekWidgetByName(roots, "Image_jiantou"):setVisible(false)	
		if next_ship_id ~= nil and next_ship_id ~= -1 then 
			ccui.Helper:seekWidgetByName(roots, "Image_jiantou"):setVisible(true)	
		end
	end
	local status = false
	for i,v in pairs(self.allHero) do
		if tonumber(id) == tonumber(v) then
			status = true
		end
	end
	
	if status == false then
		quality_path = ("images/ui/quality/icon_enemy_1.png")
		app.load("frameworks.support.filters.gray")
		gray.setGray(background)

	else
		quality_path = string.format("images/ui/quality/icon_enemy_%d.png", tonumber(quality)+1)
		self.num = self.num + 1
	end
	
	Panel_kuang:setBackGroundImage(quality_path)
	-- Panel_head:setBackGroundImage(big_icon_path)
	name:setColor(cc.c3b(color_Type[quality+1][1],color_Type[quality+1][2],color_Type[quality+1][3]))
	if __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto then
		--进化形象
		local evo_image = dms.string(dms["ship_mould"], id, ship_mould.fitSkillTwo)
		local evo_info = zstring.split(evo_image, ",")
		--进化模板id
		-- local ship_evo = zstring.split(fundShipWidthId(""..shipID).evolution_status, "|")
		local evo_mould_id = evo_info[dms.int(dms["ship_mould"], id, ship_mould.captain_name)]
		local name_mould_id = dms.int(dms["ship_evo_mould"], evo_mould_id, ship_evo_mould.name_index)
		local word_info = dms.element(dms["word_mould"], name_mould_id)
		_name = word_info[3]
		name:setString(_name)
	else
		name:setString(dms.string(dms["ship_mould"], id, ship_mould.captain_name))
	end

	fwin:addTouchEventListener(Panel_head, nil, 
	{
		terminal_name = "catalogue_show_info_click_head", 	
		_id = id,
		terminal_state = 0,
	}, 
	nil, 0)
	
	return roots
end


function CatalogueStorageList:onUpdateDrawPic()
	local root = self.roots[1]
	-- [[绘制滚动层
	local m_ScrollView = ccui.Helper:seekWidgetByName(root, "Panel_403")
	local image = ccui.Helper:seekWidgetByName(root, "Image_1")
	local Image_2 = ccui.Helper:seekWidgetByName(root, "Image_2")
	local Text_156 = ccui.Helper:seekWidgetByName(root, "Text_156")
	local Text_204 = ccui.Helper:seekWidgetByName(root, "Text_204")
	local Text_3 = ccui.Helper:seekWidgetByName(root, "Text_3")
	local Panel_2 = ccui.Helper:seekWidgetByName(root, "Panel_2")
	local panel = ccui.Layout:create()
	panel:setContentSize(m_ScrollView:getContentSize())
	panel:setPosition(cc.p(0,0))
	panel:removeAllChildren(true)
	m_ScrollView:addChild(panel)
	local sSize = panel:getContentSize()
	local controlSize = m_ScrollView:getContentSize()
	local cellWidth = sSize.width / 5
	
	local height = math.floor((table.getn(self.ship)-1) / 5 + 1)-1			--高度
	Panel_2:setContentSize(cc.size(Panel_2:getContentSize().width, Panel_2:getContentSize().height+height*125))
	self:setContentSize(Panel_2:getContentSize())
	image:setContentSize(cc.size(image:getContentSize().width, image:getContentSize().height+height*125))
	Image_2:setPosition(cc.p(Image_2:getPositionX(),Image_2:getPositionY()+height*125))
	Text_156:setPosition(cc.p(Text_156:getPositionX(),Text_156:getPositionY()+height*125))
	Text_204:setPosition(cc.p(Text_204:getPositionX(),Text_204:getPositionY()+height*125))
	Text_3:setPosition(cc.p(Text_3:getPositionX(),Text_3:getPositionY()+height*125))
	m_ScrollView:setPosition(cc.p(m_ScrollView:getPositionX(),m_ScrollView:getPositionY()+height*125))

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		for i=1,6 do
			local qualityImg = ccui.Helper:seekWidgetByName(root, "Image_pinzhi_bg_"..i)
			qualityImg:setVisible(false)
			qualityImg:setPosition(cc.p(qualityImg:getPositionX(),qualityImg:getPositionY()+height*125))
		end
	end
	
	local function addRewardScrollView(_index,id)
		local tempCell = nil
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then	
			tempCell = ccui.Layout:create()
			tempCell.id = id
			tempCell:setContentSize(cc.size(106,106))
			table.insert(self.hero_panel,tempCell)
		else
			tempCell = self:onHeadDraw(id)
		end

		local cellHeight = tempCell:getContentSize().height+20

		local row = math.floor((_index - 1) / 5 + 1)
		local col = math.floor((_index - 1) % 5)
		
		local controlHeight = row * cellHeight
		if controlHeight < sSize.height then
			controlSize.height = sSize.height
		else
			controlSize.height = controlHeight
		end
		
		m_ScrollView:setContentSize(cc.size(controlSize.width, controlSize.height))
		
		local pos = cc.p(cellWidth * col + (cellWidth - tempCell:getContentSize().width)/2,
			sSize.height - cellHeight * row)
		if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
			--显示英雄图鉴
			pos=cc.p(pos.x,pos.y+height*125)
			if height == 0 then
				m_ScrollView:setContentSize(cc.size(controlSize.width, controlSize.height+20))
				pos=cc.p(pos.x,pos.y+20)
			end
		end
		tempCell:setPosition(pos)
		panel:addChild(tempCell)
	end
	
	if _ED._legendInfoStatus == "" then
		local data = zstring.split(_ED.catalogue_hero_is_have, ",")
		for i = 1 , table.getn(data)-1 do
			self.allHero[i] =  data[i]
		end
	else
		local data = zstring.split(_ED.catalogue_hero_is_have, ",")
		local nums = 0
		for i = 1 , table.getn(data)-1 do
			self.allHero[i] =  data[i]
			nums = i
		end
		for i = nums+1 , tonumber(_ED._legendNumber) do
			self.allHero[i] =  _ED._legendInfo[i].legendMouldId
		end
	end
	
	for i = 1 , table.getn(self.ship) do
		addRewardScrollView(i,self.ship[i])
	end
	-- debug.print_r(self.allHero)
	-- debug.print_r(self.ship)

	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert then
		local num = 0
		for i,v in pairs(self.allHero) do
			for j,k in pairs(self.ship) do
				if tonumber(v) == tonumber(k) then
					num =  num + 1 
					break	
				end
			end
		end
		self.num = num
	end
	local types = dms.int(dms["ship_mould"], self.ship[1], ship_mould.ship_type)
	local quality = types + 1
	Text_156:setString(_ship_types_by_color[quality])
	Text_156:setColor(cc.c3b(color_Type[quality][1],color_Type[quality][2],color_Type[quality][3]))
	Text_3:setString(self.num .. "/" ..table.getn(self.ship))
	
	if __lua_project_id == __lua_project_gragon_tiger_gate or __lua_project_id == __lua_project_l_digital or __lua_project_id == __lua_project_l_dragonball or __lua_project_id == __lua_project_l_dragonball2 or __lua_project_id == __lua_project_l_pokemon or __lua_project_id == __lua_project_onepiece or __lua_project_id == __lua_project_l_naruto  or __lua_project_id == __lua_project_red_alert or __lua_project_id == __lua_project_legendary_game then
		ccui.Helper:seekWidgetByName(root, "Image_pinzhi_bg_"..quality):setVisible(true)
	end
end



function CatalogueStorageList:addHeroPanel()
	for i,v in pairs(self.hero_panel) do
		function addHero()
			v:addChild(self:onHeadDraw(v.id))
		end
		cc.Director:getInstance():getTextureCache():removeTextureForKey(fwin._asyncImg)
		cc.Director:getInstance():getTextureCache():addImageAsync(fwin._asyncImg, addHero,self)	
	end
end
function CatalogueStorageList:onEnterTransitionFinish()
	local csbCatalogueStorage = csb.createNode("system/Atlas_list.csb")
	self:addChild(csbCatalogueStorage)
	local root = csbCatalogueStorage:getChildByName("root")
	table.insert(self.roots, root)
	self:onUpdateDrawPic()
	
end

function CatalogueStorageList:onExit()
	-- state_machine.remove("catalogue_storage_list")
end

function CatalogueStorageList:init(ship)
	self.ship = ship
end

function CatalogueStorageList:createCell()
	local cell = CatalogueStorageList:new()
	cell:registerOnNodeEvent(cell)
	return cell
end